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
    parser.add_argument("--only", choices=("personal", "bazel", "homebrew"), help="run one cleanup policy")
    args = parser.parse_args()
    if os.geteuid() == 0:
        parser.error("run as your normal user, not root")
    home = Path.home().resolve()
    stages = [("personal", personal_files), ("bazel", bazel_outputs), ("homebrew", homebrew_downloads)]
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
    except (OSError, RuntimeError) as exc:
        print(f"cleanup: FAILED: {exc}", file=sys.stderr, flush=True)
        return 1
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
