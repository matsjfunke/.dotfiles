import contextlib
import io
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time
import unittest
from unittest.mock import patch

import bazel_cache_cleanup as cleanup


class CleanupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.workspace = self.root / "langdock"
        self.workspace.mkdir()
        self.cache = self.root / "cache"
        self.cache.mkdir()
        self.output = self.cache / ("a" * 32)
        self.output.mkdir()
        self.source = self.workspace / "removed-worktree"
        (self.output / "DO_NOT_BUILD_HERE").write_text(str(self.source))
        (self.output / "lock").touch()
        (self.output / "artifact").write_text("regenerable")
        self.age_output()
        self.cutoff = time.time() - 5 * 86400

    def age_output(self):
        old = time.time() - 6 * 86400
        for path in [*self.output.rglob("*"), self.output]:
            os.utime(path, (old, old), follow_symlinks=False)

    def reason(self, registered=None, refs=None):
        return cleanup.eligibility(self.output, [self.cache], self.workspace,
                                   registered or set(), refs or ([], []), self.cutoff)

    def test_old_orphan_is_eligible(self):
        self.assertIsNone(self.reason())

    def test_existing_checkout_is_kept(self):
        self.source.mkdir()
        self.assertIn("still exists", self.reason())

    def test_registered_but_missing_worktree_is_kept(self):
        self.assertIn("Git still registers", self.reason({self.source}))

    def test_live_process_or_open_file_is_kept(self):
        for refs in [([f"123 node {self.output}/artifact"], []),
                     ([], [str(self.output / "artifact")])]:
            self.assertIn("running process", self.reason(refs=refs))

    def test_nested_recent_file_is_kept(self):
        directory = self.output / "deep"
        directory.mkdir()
        (directory / "new-output").touch()
        os.utime(self.output, (1, 1))
        self.assertIn("recently modified", self.reason())

    def test_live_server_is_kept(self):
        (self.output / "server").mkdir()
        (self.output / "server/server.pid.txt").write_text(str(os.getpid()))
        self.age_output()
        self.assertIn("still alive", self.reason())

    def test_marker_symlink_is_rejected(self):
        marker = self.output / "DO_NOT_BUILD_HERE"
        marker.unlink()
        outside = self.root / "marker"
        outside.write_text(str(self.source))
        marker.symlink_to(outside)
        self.assertIn("marker safely", self.reason())

    def test_symlinked_output_is_rejected(self):
        original = self.output
        moved = self.root / "outside"
        original.rename(moved)
        original.symlink_to(moved)
        self.assertIn("symlink", self.reason())

    def test_outside_cache_or_workspace_is_rejected(self):
        result = cleanup.eligibility(self.output, [self.workspace], self.workspace,
                                     set(), ([], []), self.cutoff)
        self.assertIn("outside the allowed", result)
        (self.output / "DO_NOT_BUILD_HERE").write_text(str(self.root / "outside"))
        self.assertIn("outside the Langdock", self.reason())

    def test_held_posix_lock_is_rejected(self):
        child = subprocess.Popen([sys.executable, "-c",
            "import fcntl,sys; f=open(sys.argv[1],'r+'); "
            "fcntl.lockf(f,fcntl.LOCK_EX); print('locked',flush=True); sys.stdin.read()",
            str(self.output / "lock")], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            text=True)
        try:
            self.assertEqual(child.stdout.readline().strip(), "locked")
            with self.assertRaises(cleanup.Unsafe):
                with cleanup.output_lock(self.output):
                    self.fail("must not acquire a held Bazel lock")
        finally:
            child.communicate(timeout=5)

    def test_lock_file_symlink_is_rejected(self):
        lock = self.output / "lock"
        lock.unlink()
        other = self.root / "other-lock"
        other.touch()
        lock.symlink_to(other)
        with self.assertRaises(cleanup.Unsafe):
            with cleanup.output_lock(self.output):
                self.fail("must not follow lock symlinks")

    def test_delete_preserves_symlink_target(self):
        outside = self.root / "real-source"
        outside.mkdir()
        (outside / "important.txt").write_text("keep me")
        (self.output / "source").symlink_to(outside)
        cleanup.remove_output(self.output)
        self.assertFalse(self.output.exists())
        self.assertEqual((outside / "important.txt").read_text(), "keep me")

    def test_readonly_directories_can_be_removed(self):
        directory = self.output / "readonly"
        directory.mkdir()
        (directory / "artifact").touch()
        directory.chmod(0o500)
        cleanup.remove_output(self.output)
        self.assertFalse(self.output.exists())

    def test_command_failure_blocks_cleanup(self):
        with patch.object(cleanup.subprocess, "run", return_value=
                          subprocess.CompletedProcess([], 1, "", "denied")):
            with self.assertRaises(cleanup.Unsafe):
                cleanup.live_references()

    def test_preview_cannot_delete(self):
        with patch.object(cleanup.Path, "home", return_value=self.root), \
             patch.object(cleanup, "registered_worktrees", return_value=set()), \
             patch.object(cleanup, "live_references", return_value=([], [])), \
             patch.object(cleanup, "discover", return_value=[self.output]), \
             patch.object(cleanup, "eligibility", return_value=None), \
             patch.object(cleanup, "remove_output") as remove, \
             patch.object(sys, "argv", ["cleanup"]), \
             contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(cleanup.main(), 0)
            remove.assert_not_called()
        self.assertTrue(self.output.exists())

    def test_apply_rechecks_before_deletion(self):
        with patch.object(cleanup.Path, "home", return_value=self.root), \
             patch.object(cleanup, "registered_worktrees", return_value=set()), \
             patch.object(cleanup, "live_references", return_value=([], [])), \
             patch.object(cleanup, "discover", return_value=[self.output]), \
             patch.object(cleanup, "eligibility", side_effect=[None, "source checkout still exists"]), \
             patch.object(cleanup, "remove_output") as remove, \
             patch.object(sys, "argv", ["cleanup", "--apply"]), \
             contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(cleanup.main(), 0)
            remove.assert_not_called()


if __name__ == "__main__":
    unittest.main()
