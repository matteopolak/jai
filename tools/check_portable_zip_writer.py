#!/usr/bin/env python3
"""Reviewed ZIP writer with independent Python/zlib full-archive consumers."""
import os
from pathlib import Path
import struct
import subprocess
import zipfile
from portable_android_stage import compose

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "target/portable-zip-writer"


def verify():
    with zipfile.ZipFile(OUTPUT / "archive.zip") as archive:
        expected = {"stored.txt": b"stored data", "compressed.txt": b"deflated data",
                    "aligned.txt": b"aligned data", "empty.txt": b"",
                    "source.jai": (ROOT / "tests/portable-stdlib/android-zip-writer/main.jai").read_bytes()}
        expected.update({f"boundary-{size}": bytes(i % 251 for i in range(size))
                         for size in [65534, 65535, 65536, 131071]})
        assert set(archive.namelist()) == set(expected)
        for name, data in expected.items():
            assert archive.read(name) == data
        info = archive.getinfo("aligned.txt")
        wire = (OUTPUT / "archive.zip").read_bytes()
        name_length, extra_length = struct.unpack_from("<HH", wire, info.header_offset + 26)
        offset = info.header_offset + 30 + name_length + extra_length
        assert offset % 4096 == 0
        assert wire[offset - extra_length:offset] == bytes(extra_length)
        assert info.extra == b""
        assert archive.testzip() is None
    with zipfile.ZipFile(OUTPUT / "implicit.zip") as archive:
        assert archive.read("file") == b"implicit init"
    dummy = (OUTPUT / "dummy.zip").read_bytes()
    assert struct.unpack_from("<I", dummy, 14)[0] == 0x12345678
    central = dummy.index(b"PK\x01\x02")
    assert struct.unpack_from("<I", dummy, central + 16)[0] == 0x12345678


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    library = compose()
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    fixtures = ROOT / "tests/portable-stdlib/android-zip-writer"
    for name in ["main", "failures"]:
        source = fixtures / (name + ".jai")
        commands = [[compiler, "-interp", str(source), "--", str(OUTPUT)]]
        for optimization in ["-O0", "-O2"]:
            executable = OUTPUT / (name + optimization)
            subprocess.run([compiler, str(source), optimization, "-exe", str(executable)],
                           env=env, cwd=ROOT, check=True)
            commands.append([str(executable), str(OUTPUT)])
        for command in commands:
            result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
            if name == "main":
                verify()
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Android/Toolchain/module.jai"),
                    *[str(library / "internal/archive" / name) for name in
                      ["android-zip-records.jai", "android-zip-writer.jai"]], str(fixtures)],
                   env=env, cwd=ROOT, check=True)
    print("ZIP writer: exact 30/46/22 layouts, stored/DEFLATE boundaries, CRC/dummy CRC, alignment, file/memory/implicit init and eight diagnosed failures pass interpreter/native O0/O2, independent ZIP/zlib consumers and strict lint")


if __name__ == "__main__":
    main()
