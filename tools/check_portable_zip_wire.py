#!/usr/bin/env python3
"""ZIP word/offset helpers and pure CRC against independent native-zlib outputs."""
import os
from pathlib import Path
import platform
import random
import struct
import subprocess
import zlib
from portable_android_stage import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-zip-wire"
    output.mkdir(parents=True, exist_ok=True)
    rng = random.Random(69431)
    payloads = [rng.randbytes(size) for size in range(257)]
    payloads += [b"123456789", bytes(range(256)), b"\xff" * 4096, b"\0" * 4097,
                 rng.randbytes(65535), rng.randbytes(65536), rng.randbytes(65537)]
    vectors = bytearray(struct.pack("<I", len(payloads)))
    for data in payloads:
        vectors += struct.pack("<I", len(data)) + data + struct.pack("<I", zlib.crc32(data))
    (output / "crc-vectors.bin").write_bytes(vectors)
    compose()
    env = dict(os.environ, JAIC_STDLIB=str(LIBRARY))
    compiler = str(ROOT / "target/compiler/debug/jaic")
    folder = ROOT / "tests/portable-stdlib/android-zip-wire"
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    for name in ["main", "vectors", "failures"]:
        source = folder / (name + ".jai")
        commands = [[compiler, "-interp", str(source)]]
        for flags, label in targets:
            for optimization in ["-O0", "-O2"]:
                executable = output / (name + label + optimization)
                subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(executable)], env=env, check=True)
                commands.append([str(executable)])
        for command in commands:
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        if name != "vectors":
            for target in ["linux", "windows"]:
                for cpu in ["x64", "arm64"]:
                    subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(LIBRARY / "Android/Toolchain/module.jai"),
                    str(LIBRARY / "internal/archive/android-zip-wire.jai"), str(folder)], env=env, check=True)
    print(f"ZIP: 65536 version words/{len(payloads)} native-zlib CRC vectors/alias mutation/units/5 faults pass 15 interpreter/native runs, target source checks and strict lint")


if __name__ == "__main__":
    main()
