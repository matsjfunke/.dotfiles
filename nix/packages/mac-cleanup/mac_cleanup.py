"""Deterministic macOS cleanup. Preview by default; --apply enables deletion."""

import argparse
import contextlib
from datetime import datetime
import fcntl
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys


def log(message):
    print(f"{datetime.now().astimezone().isoformat(timespec='seconds')} {message}", flush=True)


def personal_files(home, apply):
    # Preserve the existing find -mmin +60 policy, including its directory
    # semantics. Use absolute macOS binaries and never follow directory symlinks.
    directories = [home / name for name in ("Downloads", "Desktop", ".Trash")]
    directories = [p for p in directories if os.path.lexists(p)]
    if not directories:
        log("personal: no configured directories exist")
        return
    for directory in directories:
        if directory.is_symlink() or not directory.is_dir():
            raise RuntimeError(f"personal: refusing unexpected directory {directory}")
    args = ["/usr/bin/find", *map(str, directories), "-mindepth", "1", "-mmin", "+60"]
    if apply:
        subprocess.run(args + ["-exec", "/bin/rm", "-rf", "{}", "+"], check=True)
    else:
        result = subprocess.run(args + ["-print0"], check=True, stdout=subprocess.PIPE)
        log(f"personal: {result.stdout.count(bytes([0]))} matching entries (directory matches include their contents)")


def bazel_outputs(home, apply):
    if not (home / "langdock").is_dir():
        log("bazel: no Langdock workspace; skipped")
        return
    args = [sys.executable, "-u", str(Path(__file__).with_name("bazel_cache_cleanup.py"))]
    if apply:
        args.append("--apply")
    subprocess.run(args, check=True)


def homebrew_downloads(home, apply):
    brew = Path("/opt/homebrew/bin/brew")
    if not brew.is_file():
        log("homebrew: Homebrew is not installed; skipped")
        return
    env = os.environ.copy()
    env.update(HOME=str(home), HOMEBREW_NO_AUTO_UPDATE="1", HOMEBREW_NO_ANALYTICS="1",
               HOMEBREW_CLEANUP_MAX_AGE_DAYS="30")
    args = [str(brew), "cleanup", "--prune=30"]
    if not apply:
        args.append("--dry-run")
    # Homebrew also removes obsolete installed formula versions as part of its
    # supported cleanup; this does not uninstall unlisted apps or use --zap.
    subprocess.run(args, env=env, check=True)


def _find_tool(home, name):
    """Locate a CLI without relying on launchd's minimal PATH."""
    candidates = [
        Path("/etc/profiles/per-user") / home.name / "bin" / name,
        home / ".nix-profile/bin" / name,
        Path("/run/current-system/sw/bin") / name,
        Path("/usr/local/bin") / name,
        Path("/opt/homebrew/bin") / name,
    ]
    return next((str(c) for c in candidates if os.access(c, os.X_OK)), None)


def _tilt_running():
    # Tilt's UI/API always listens on 10350 while "task dev" is up.
    result = subprocess.run(["/usr/sbin/lsof", "-nP", "-iTCP:10350", "-sTCP:LISTEN", "-t"],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return result.returncode == 0


def _dir_gib(path):
    total = 0
    for root, _dirs, files in os.walk(path):
        for name in files:
            with contextlib.suppress(OSError):
                total += os.lstat(os.path.join(root, name)).st_blocks * 512
    return total / 2**30


DEV_INTERVAL_DAYS = 28
DEV_LOW_SPACE_GIB = 50
PROMPT_DUMP_MAX_BYTES = 1 * 2**30
PROMPT_DUMP_MAX_AGE_DAYS = 7


def dev_caches(home, apply):
    """Langdock dev caches: prompt dumps daily; Docker/pnpm/devserver caches monthly."""
    workspace = home / "langdock"
    if not workspace.is_dir():
        log("dev: no Langdock workspace; skipped")
        return

    # 1. Debug prompt dumps (DEBUG=true appends every prompt, unbounded). Daily.
    now = datetime.now().timestamp()
    for dump_dir in workspace.glob("*/.prompt-dumps"):
        if dump_dir.is_symlink() or not dump_dir.is_dir():
            continue
        for entry in dump_dir.iterdir():
            if entry.is_symlink() or not entry.is_file():
                continue
            info = entry.stat()
            too_big = info.st_size > PROMPT_DUMP_MAX_BYTES
            too_old = now - info.st_mtime > PROMPT_DUMP_MAX_AGE_DAYS * 86400
            if too_big or too_old:
                log(f"dev: {'remove' if apply else 'would remove'} {entry} ({info.st_size / 2**30:.1f} GiB)")
                if apply:
                    entry.unlink()

    # 2. Heavier caches: monthly, or immediately when the disk is getting full.
    stamp = home / ".local/state/mac-cleanup/dev-caches.stamp"
    free_gib = shutil.disk_usage(home).free / 2**30
    age_days = (now - stamp.stat().st_mtime) / 86400 if stamp.exists() else float("inf")
    if age_days < DEV_INTERVAL_DAYS and free_gib >= DEV_LOW_SPACE_GIB:
        log(f"dev: monthly caches last pruned {age_days:.0f}d ago, {free_gib:.0f} GiB free; skipped")
        return
    last = "never" if age_days == float("inf") else f"{age_days:.0f}d ago"
    log(f"dev: pruning monthly caches (last run {last}, {free_gib:.0f} GiB free)")
    failures = []

    # Docker: unused images/containers/networks and build cache older than 30 days.
    # Volumes (database data) are never touched.
    docker = _find_tool(home, "docker")
    if docker and subprocess.run([docker, "info"], stdout=subprocess.DEVNULL,
                                 stderr=subprocess.DEVNULL, timeout=30).returncode == 0:
        commands = [[docker, "system", "prune", "-f", "--filter", "until=720h"],
                    [docker, "builder", "prune", "-f", "--filter", "until=720h"]]
        for cmd in commands:
            if apply:
                if subprocess.run(cmd, timeout=1800).returncode != 0:
                    failures.append("docker")
            else:
                log("dev: would run " + " ".join(cmd[1:]))
        if not apply:
            subprocess.run([docker, "system", "df"], timeout=60)
    else:
        log("dev: Docker is not running; docker prune skipped")

    # pnpm: drop packages no project references any more.
    pnpm = _find_tool(home, "pnpm")
    if pnpm:
        repo = workspace / "langdock"
        cwd = repo if repo.is_dir() else home
        if apply:
            if subprocess.run([pnpm, "store", "prune"], cwd=cwd, timeout=1800).returncode != 0:
                failures.append("pnpm")
        else:
            log(f"dev: would run pnpm store prune in {cwd}")
    else:
        log("dev: pnpm not found; skipped")

    # Per-app Vite/devserver caches; regenerated by "task dev". Only while Tilt is down.
    devserver = home / ".cache/langdock/js-run-devserver"
    if devserver.is_dir() and not devserver.is_symlink():
        if _tilt_running():
            log("dev: Tilt is running; js-run-devserver kept (will retry next run)")
            failures.append("js-run-devserver")
        else:
            log(f"dev: {'remove' if apply else 'would remove'} {devserver} ({_dir_gib(devserver):.1f} GiB)")
            if apply:
                shutil.rmtree(devserver)

    if apply and not failures:
        stamp.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
        stamp.touch()
    elif failures:
        log(f"dev: incomplete ({', '.join(failures)}); will retry on the next daily run")


@contextlib.contextmanager
def single_run(home):
    directory = home / ".local/state/mac-cleanup"
    directory.mkdir(parents=True, exist_ok=True, mode=0o700)
    if directory.resolve() != directory or directory.stat().st_uid != os.getuid():
        raise RuntimeError("unexpected cleanup state directory")
    fd = os.open(directory / "run.lock", os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW, 0o600)
    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid() or info.st_nlink != 1:
            raise RuntimeError("unexpected cleanup lock")
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise RuntimeError("another cleanup is already running") from exc
        yield
    finally:
        os.close(fd)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true", help="perform cleanup; otherwise preview only")
    parser.add_argument("--only", choices=("personal", "bazel", "homebrew", "dev"), help="run one cleanup policy")
    args = parser.parse_args()
    if os.geteuid() == 0:
        parser.error("run as your normal user, not root")
    home = Path.home().resolve()
    stages = [("personal", personal_files), ("bazel", bazel_outputs), ("homebrew", homebrew_downloads),
              ("dev", dev_caches)]
    failures = []
    log("cleanup starting: " + ("apply" if args.apply else "preview"))
    try:
        with single_run(home) if args.apply else contextlib.nullcontext():
            for name, action in stages:
                if args.only and args.only != name:
                    continue
                log(f"{name}: starting")
                try:
                    action(home, args.apply)
                    log(f"{name}: completed")
                except (OSError, RuntimeError, subprocess.SubprocessError) as exc:
                    failures.append(name)
                    print(f"{name}: FAILED: {exc}", file=sys.stderr, flush=True)
            free_gib = shutil.disk_usage(home).free / 2**30
            log(f"cleanup finished: {free_gib:.1f} GiB free; failed policies: {', '.join(failures) or 'none'}")
            if free_gib < 50:
                log("LOW SPACE: less than 50 GiB free; review additional usage")
                subprocess.run(["/usr/bin/osascript", "-e",
                                f'display notification "Only {free_gib:.0f} GiB free. See /tmp/cleanup.log" '
                                'with title "Disk almost full" sound name "Basso"'], check=False)
    except (OSError, RuntimeError) as exc:
        print(f"cleanup: FAILED: {exc}", file=sys.stderr, flush=True)
        return 1
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
