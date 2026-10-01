import hashlib
import io
import json
from pathlib import Path
import tarfile
import tempfile
import unittest

from runner_inputs import extract


class RunnerInputTests(unittest.TestCase):
    def bundle(self, root, members, records):
        archive = root / "inputs.tar.gz"
        with tarfile.open(archive, "w:gz") as bundle:
            for name, content, kind in members:
                info = tarfile.TarInfo(name)
                info.type = kind
                if kind == tarfile.REGTYPE:
                    info.size = len(content)
                    bundle.addfile(info, io.BytesIO(content))
                else:
                    info.linkname = "/tmp/outside"
                    bundle.addfile(info)
        manifest = root / "manifest.json"
        manifest.write_text(json.dumps({"format": 1, "archive_sha256": hashlib.sha256(archive.read_bytes()).hexdigest(), "files": records}))
        return archive, manifest

    def record(self, name, content=b"inert bytes"):
        return {"path": name, "bytes": len(content), "sha256": hashlib.sha256(content).hexdigest()}

    def test_extracts_verified_data_without_executable_permissions(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            archive, manifest = self.bundle(root, [("bin/input", b"inert bytes", tarfile.REGTYPE)], [self.record("bin/input")])
            extract(archive, manifest, root / "reference")
            output = root / "reference/bin/input"
            self.assertEqual(output.read_bytes(), b"inert bytes")
            self.assertEqual(output.stat().st_mode & 0o777, 0o400)

    def test_rejects_traversal_links_duplicates_missing_and_unlisted_files(self):
        for members in [
            [("../escape", b"inert bytes", tarfile.REGTYPE)],
            [("bin/input", b"", tarfile.SYMTYPE)],
            [("bin/input", b"inert bytes", tarfile.REGTYPE)] * 2,
            [],
            [("bin/unlisted", b"inert bytes", tarfile.REGTYPE)],
        ]:
            with self.subTest(members=members), tempfile.TemporaryDirectory() as temp:
                root = Path(temp)
                archive, manifest = self.bundle(root, members, [self.record("bin/input")])
                with self.assertRaises(ValueError):
                    extract(archive, manifest, root / "reference")
                self.assertFalse((root / "reference").exists())

    def test_rejects_changed_archive_and_member_bytes(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            archive, manifest = self.bundle(root, [("bin/input", b"wrong bytes", tarfile.REGTYPE)], [self.record("bin/input")])
            with self.assertRaises(ValueError):
                extract(archive, manifest, root / "reference")
            archive.write_bytes(b"changed")
            with self.assertRaises(ValueError):
                extract(archive, manifest, root / "other")


if __name__ == "__main__":
    unittest.main()
