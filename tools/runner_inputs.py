#!/usr/bin/env python3
"""Package or extract hashed reference data; never execute any input file."""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import tarfile

ROOT = Path(__file__).resolve().parents[1]
BINARIES = ("bin/jai-macos", "bin/jai-linux", "bin/jai.exe",
            "bin/lld-macos", "bin/lld-linux", "bin/lld.exe")


def digest(path):
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def safe_path(name):
    path = PurePosixPath(name)
    if (not name or path.is_absolute() or ".." in path.parts or "\\" in name
            or str(path) != name):
        raise ValueError(f"unsafe input path: {name!r}")
    return path


def pack(reference, archive, manifest):
    reference = reference.resolve()
    files = sorted(set(p.relative_to(reference).as_posix() for p in reference.rglob("*.jai")) | set(BINARIES))
    records = []
    archive.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(archive, "w:gz", compresslevel=1) as bundle:
        for name in files:
            safe_path(name)
            path = reference / name
            if path.is_symlink() or not path.is_file() or reference not in path.resolve().parents:
                raise ValueError(f"not a regular reference input: {name}")
            records.append({"path": name, "bytes": path.stat().st_size, "sha256": digest(path)})
            info = bundle.gettarinfo(str(path), arcname=name)
            info.mode = 0o600
            info.uid = info.gid = 0
            info.uname = info.gname = ""
            with path.open("rb") as stream:
                bundle.addfile(info, stream)
    manifest.parent.mkdir(parents=True, exist_ok=True)
    manifest.write_text(json.dumps({"format": 1, "archive_sha256": digest(archive), "files": records}, indent=2) + "\n")
    print(f"Packaged {len(files)} data files; no input code executed")


def extract(archive, manifest, destination):
    data = json.loads(manifest.read_text())
    if data["format"] != 1 or digest(archive) != data["archive_sha256"]:
        raise ValueError("input archive hash or format mismatch")
    expected = {}
    for record in data["files"]:
        name = record["path"]
        safe_path(name)
        if name in expected:
            raise ValueError("duplicate manifest input")
        expected[name] = record
    if destination.exists():
        raise ValueError("input destination must not exist")
    # Inspect the entire directory before any writes: no links, devices,
    # unexpected files, duplicates, or decompression sizes outside the manifest.
    with tarfile.open(archive, "r:gz") as bundle:
        members = bundle.getmembers()
        seen = set()
        for member in members:
            safe_path(member.name)
            record = expected.get(member.name)
            if (not member.isfile() or member.name in seen or record is None
                    or member.size != record["bytes"]):
                raise ValueError("unexpected archive member")
            seen.add(member.name)
        if seen != set(expected):
            raise ValueError("missing archive input")
        destination.mkdir(parents=True)
        for member in members:
            output = destination / member.name
            output.parent.mkdir(parents=True, exist_ok=True)
            stream = bundle.extractfile(member)
            with output.open("xb") as target:
                while chunk := stream.read(1024 * 1024):
                    target.write(chunk)
            output.chmod(0o400)
            if digest(output) != expected[member.name]["sha256"]:
                raise ValueError(f"input hash mismatch: {member.name}")
    print(f"Verified and extracted {len(expected)} non-executable data files")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("pack", "extract"))
    parser.add_argument("--archive", type=Path, default=ROOT / "artifacts/runner/reference-inputs.tar.gz")
    parser.add_argument("--manifest", type=Path, default=ROOT / "corpus/reference-inputs.json")
    parser.add_argument("--reference", type=Path, default=ROOT / "reference")
    args = parser.parse_args()
    if args.operation == "pack":
        pack(args.reference, args.archive, args.manifest)
    else:
        extract(args.archive, args.manifest, args.reference)


if __name__ == "__main__":
    main()
