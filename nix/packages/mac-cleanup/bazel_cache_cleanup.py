#!/usr/bin/env python3
"""On-demand cleanup of abandoned Bazel outputs; no scheduler or AI required."""

import argparse
import contextlib
import fcntl
import json
import os
from pathlib import Path
import re
import shutil
import stat
import subprocess
import sys
import time


class Unsafe(RuntimeError):
    pass


def command(args):
    try:
        result = subprocess.run(args, capture_output=True, text=True, timeout=60)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise Unsafe(f"Could not run {args[0]}; cleanup disabled") from exc
    if result.returncode or result.stderr.strip():
        raise Unsafe(f"{args[0]} reported an error or warning; cleanup disabled")
    return result.stdout


def inside(path, root):
    return path != root and root in path.parents


def plain_directory(path):
    if path.resolve() != path or not path.is_dir():
        raise Unsafe("directory is missing or has a symlink in its path")
    if path.stat().st_uid != os.getuid():
        raise Unsafe("directory is not owned by the current user")


def read_marker(path):
    flags = os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK
    try:
        fd = os.open(path / "DO_NOT_BUILD_HERE", flags)
        with os.fdopen(fd) as stream:
            if not stat.S_ISREG(os.fstat(stream.fileno()).st_mode):
                raise Unsafe("workspace marker is not a regular file")
            value = stream.read(8193).strip()
    except OSError as exc:
        raise Unsafe("cannot read workspace marker safely") from exc
    if not value or len(value) > 8192 or "\n" in value or not Path(value).is_absolute():
        raise Unsafe("invalid workspace marker")
    source = Path(value)
    if source.resolve() != source:
        raise Unsafe("workspace marker contains a symlink or noncanonical path")
    return source


def registered_worktrees(workspace):
    # Inspect every immediate repository and its worktree registry. Unknown
    # registries block cleanup instead of treating missing information as safe.
    repos = [p for p in workspace.iterdir() if p.is_dir() and (p / ".git").exists()]
    if not repos:
        raise Unsafe("no repository registries found; cleanup disabled")
    registered = set()
    for repo in repos:
        output = command(["/usr/bin/git", "-C", str(repo), "worktree", "list", "--porcelain", "-z"])
        for field in output.split("\0"):
            if field.startswith("worktree "):
                registered.add(Path(field[9:]).resolve())
    return registered


def live_references():
    processes = command(["/bin/ps", "-axo", "pid=,args="])
    # Ignore our own process. Do not print command lines, which can contain secrets.
    processes = [line for line in processes.splitlines()
                 if line.split(maxsplit=1) and line.split(maxsplit=1)[0] != str(os.getpid())]
    opened = command(["/usr/sbin/lsof", "-nP", "-Fpn"])
    paths = []
    pid = None
    for line in opened.splitlines():
        if line.startswith("p"):
            pid = line[1:]
        elif line.startswith("n/") and pid != str(os.getpid()):
            paths.append(line[1:])
    return processes, paths


def is_referenced(path, references):
    processes, opened = references
    value = str(path)
    return any(value in line for line in processes) or any(
        name == value or name.startswith(value + "/") for name in opened
    )


def newest_entry(path):
    # Only scan outputs already established as orphaned. Never follow source
    # symlinks inside execroot, and count the link's own timestamp, not its target.
    latest = path.lstat().st_mtime
    def failed(exc):
        raise Unsafe("could not inspect all output entries") from exc
    try:
        for root, dirs, files in os.walk(path, followlinks=False, onerror=failed):
            for name in dirs + files:
                latest = max(latest, (Path(root) / name).lstat().st_mtime)
    except OSError as exc:
        raise Unsafe("output changed or could not be inspected") from exc
    return latest


def eligibility(path, roots, workspace, registered, references, cutoff):
    try:
        if not any(inside(path, root) for root in roots):
            raise Unsafe("outside the allowed output locations")
        plain_directory(path)
        source = read_marker(path)
        if not inside(source, workspace):
            raise Unsafe("source checkout is outside the Langdock workspace")
        if os.path.lexists(source):
            raise Unsafe("source checkout still exists")
        if source in registered:
            raise Unsafe("Git still registers the source worktree")
        if is_referenced(path, references):
            raise Unsafe("referenced by a running process or open file")
        pid_file = path / "server" / "server.pid.txt"
        if os.path.lexists(pid_file):
            if pid_file.is_symlink() or not pid_file.is_file():
                raise Unsafe("cannot safely inspect server PID")
            try:
                pid = int(pid_file.read_text().strip())
                if pid <= 0:
                    raise ValueError()
                os.kill(pid, 0)
            except ProcessLookupError:
                pass
            except (OSError, ValueError):
                raise Unsafe("server PID cannot be verified inactive")
            else:
                raise Unsafe("Bazel server PID is still alive")
        if newest_entry(path) > cutoff:
            raise Unsafe("output contains recently modified entries")
        return None
    except Unsafe as exc:
        return str(exc)


@contextlib.contextmanager
def output_lock(path):
    # Bazel uses POSIX record locks. flock alone would not exclude Bazel.
    fd = None
    try:
        fd = os.open(path / "lock", os.O_RDWR | os.O_NOFOLLOW | os.O_NONBLOCK)
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid() or info.st_nlink != 1:
            raise Unsafe("unexpected lock file type or ownership")
        fcntl.lockf(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        yield
    except OSError as exc:
        raise Unsafe("output lock is unavailable or held; skipped") from exc
    finally:
        if fd is not None:
            os.close(fd)


def discover(standard, custom):
    found = []
    if standard.exists():
        plain_directory(standard)
        found.extend(p for p in standard.iterdir() if re.fullmatch(r"[a-f0-9]{32}", p.name))
    if custom.exists():
        plain_directory(custom)
        def failed(exc):
            raise Unsafe("could not inspect custom output locations") from exc
        for root, dirs, files in os.walk(custom, followlinks=False, onerror=failed):
            path = Path(root)
            if "DO_NOT_BUILD_HERE" in files:
                found.append(path)
                dirs[:] = []
            else:
                # A bounded search through launcher/workspace path components,
                # never a recursive search of build artifacts.
                dirs[:] = [d for d in dirs if not (path / d).is_symlink()
                           and len((path / d).relative_to(custom).parts) <= 12]
    return sorted(set(found))


def remove_output(path):
    if not shutil.rmtree.avoids_symlink_attacks:
        raise Unsafe("Python does not provide symlink-safe recursive deletion")
    def retry(function, name, exc_info):
        if not isinstance(exc_info[1], PermissionError):
            raise exc_info[1]
        # Change only directory permissions, never shared/hard-linked files.
        parent = Path(name).parent
        plain_directory(parent)
        parent.chmod(stat.S_IMODE(parent.stat().st_mode) | stat.S_IWUSR | stat.S_IXUSR)
        function(name)
    shutil.rmtree(path, onerror=retry)


def main():
    parser = argparse.ArgumentParser(description=__doc__, epilog=(
        "Default: preview only. --apply deletes only orphaned outputs at least 5 days old "
        "after Git, lock, process and open-file checks. Keeps existing checkouts, shared "
        "download caches and active dev outputs. No scheduled task is installed."))
    parser.add_argument("--apply", action="store_true", help="delete eligible outputs after fresh safety checks")
    parser.add_argument("--json", action="store_true", help="emit a machine-readable report")
    args = parser.parse_args()
    home = Path.home().resolve()
    workspace = home / "langdock"
    standard = home / "Library/Caches/bazel" / ("_bazel_" + __import__("getpass").getuser())
    custom = home / ".cache/langdock/bazel"
    roots = [standard, custom]
    before = shutil.disk_usage(home).free
    report = {"mode": "apply" if args.apply else "preview", "minimum_age_days": 5,
              "outputs": [], "errors": []}
    try:
        plain_directory(workspace)
        registered = registered_worktrees(workspace)
        references = live_references()
        for path in discover(standard, custom):
            record = {"path": str(path), "action": "keep"}
            report["outputs"].append(record)
            cutoff = time.time() - 5 * 86400
            reason = eligibility(path, roots, workspace, registered, references, cutoff)
            if reason:
                record["reason"] = reason
                continue
            try:
                with output_lock(path):
                    if args.apply:
                        # Recheck source/registry/process state under the lock.
                        reason = eligibility(path, roots, workspace, registered_worktrees(workspace),
                                             live_references(), cutoff)
                        if reason:
                            record["reason"] = reason
                            continue
                        remove_output(path)
                        record["action"] = "deleted"
                    else:
                        record["action"] = "would_delete"
                    record["reason"] = "orphaned, at least 5 days old, and not in use"
            except (OSError, Unsafe) as exc:
                record["reason"] = str(exc)
                if args.apply:
                    report["errors"].append(f"Cleanup not completed: {path}: {exc}")
    except (OSError, Unsafe) as exc:
        report["errors"].append(str(exc))
    after = shutil.disk_usage(home).free
    report.update(free_gib=round(after / 2**30, 2),
                  free_space_change_gib=round((after - before) / 2**30, 2),
                  low_space=after < 50 * 2**30)
    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print("APPLY" if args.apply else "PREVIEW — no files deleted")
        for row in report["outputs"]:
            print(f"{row['action'].upper()}: {row['path']}\n  {row['reason']}")
        for error in report["errors"]:
            print(f"ERROR: {error}", file=sys.stderr)
        print(f"Free space: {report['free_gib']:.2f} GiB")
        if report["low_space"]:
            print("Free space is below 50 GiB. Review other usage; active outputs were preserved.")
        if not args.apply:
            print("Run this command with --apply to delete eligible outputs.")
    return 1 if report["errors"] else 0


if __name__ == "__main__":
    sys.exit(main())
