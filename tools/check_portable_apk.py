#!/usr/bin/env python3
"""Independent ZIP fixture producer; real APK file/view/iteration behavior."""
import io
import os
from pathlib import Path
import struct
import subprocess
import zipfile
from portable_android_stage import compose

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "target/portable-apk"


def fixtures():
    memory = io.BytesIO()
    with zipfile.ZipFile(memory, "w") as archive:
        archive.writestr("first", b"aligned payload", compress_type=zipfile.ZIP_STORED)
        archive.writestr("second", b"compressed" * 10, compress_type=zipfile.ZIP_DEFLATED)
        archive.writestr("empty", b"", compress_type=zipfile.ZIP_STORED)
    original = memory.getvalue()
    start = struct.unpack_from("<I", original, len(original) - 6)[0]
    first_payload = 30 + len("first")
    padding = (-first_payload) % 4096
    wire = bytearray(original[:first_payload] + bytes(padding) + original[first_payload:])
    struct.pack_into("<H", wire, 28, padding)
    directory = start + padding
    at = directory
    for _ in range(3):
        offset = struct.unpack_from("<I", wire, at + 42)[0]
        if offset:
            struct.pack_into("<I", wire, at + 42, offset + padding)
        name, extra, comment = struct.unpack_from("<HHH", wire, at + 28)
        at += 46 + name + extra + comment
    struct.pack_into("<I", wire, len(wire) - 6, directory)
    # Native independent ZIP consumer establishes fixture validity first.
    with zipfile.ZipFile(io.BytesIO(wire)) as archive:
        assert archive.testzip() is None
    (OUTPUT / "unsigned.apk").write_bytes(wire)
    marker_only = struct.pack("<QQ", 24, 24) + b"APK Sig Block 42"
    signed = wire[:directory] + marker_only + wire[directory:]
    struct.pack_into("<I", signed, len(signed) - 6, directory + len(marker_only))
    with zipfile.ZipFile(io.BytesIO(signed)) as archive:
        assert archive.testzip() is None
    (OUTPUT / "marker-only.apk").write_bytes(signed)
    malformed = bytearray(signed)
    struct.pack_into("<Q", malformed, directory + 8, 0xffffffffffffffff)
    (OUTPUT / "bad-marker-size.apk").write_bytes(malformed)
    malformed_local = bytearray(wire)
    struct.pack_into("<I", malformed_local, 18, 0xffffffff)
    (OUTPUT / "bad-local-size.apk").write_bytes(malformed_local)


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    fixtures()
    library = compose()
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    case = ROOT / "tests/portable-stdlib/android-apk/main.jai"
    for optimization in ["-O0", "-O2"]:
        subprocess.run([compiler, str(case), optimization, "-exe", str(OUTPUT / ("main" + optimization))],
                       cwd=ROOT, env=env, check=True)
    for name in ["unsigned.apk", "marker-only.apk"]:
        argument = str(OUTPUT / name)
        commands = [[compiler, "-interp", str(case), "--", argument]]
        commands += [[str(OUTPUT / ("main" + mode)), argument] for mode in ["-O0", "-O2"]]
        for command in commands:
            result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stderr or not result.stdout.endswith("ok\n"):
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    failures = [("bad-marker-size.apk", "signing-block sizes are invalid"),
                ("bad-local-size.apk", "APK local payload is out of bounds"),
                ("absent.apk", "APK ZIP directory could not be loaded")]
    for name, diagnostic in failures:
        commands = [[compiler, "-interp", str(case), "--", str(OUTPUT / name)]]
        commands += [[str(OUTPUT / ("main" + mode)), str(OUTPUT / name)] for mode in ["-O0", "-O2"]]
        for command in commands:
            result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode == 0 or diagnostic not in result.stdout + result.stderr:
                raise RuntimeError(f"Missing required failure: {command!r}: {result.stdout}{result.stderr}")
    pointer = ROOT / "tests/portable-stdlib/pending/android-apk-pointer.jai"
    result = subprocess.run([compiler, "-check", str(pointer)], env=env, cwd=ROOT,
                            capture_output=True, text=True, timeout=90)
    if result.returncode == 0 or "APK iteration yields values, not pointers" not in result.stderr:
        raise RuntimeError(f"Missing pointer rejection: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/archive/android-apk.jai"), str(case)],
                   env=env, cwd=ROOT, check=True)
    print("APK: actual unsigned/marker-only files, owned/borrowed views, payload offsets, forward/reverse iteration and zeroing deinit pass six interpreter/native O0/O2 runs, nine real malformed/missing-file failures, POINTER compile rejection and strict lint")


if __name__ == "__main__":
    main()
