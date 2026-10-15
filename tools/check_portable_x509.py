#!/usr/bin/env python3
"""DER public-key-info extraction against actual independently created C X509."""
import argparse
import os
from pathlib import Path
import platform
import subprocess
from portable_android_stage import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--openssl", type=Path, default=Path("/opt/homebrew/opt/openssl@3"))
    args = parser.parse_args()
    output = ROOT / "target/portable-x509"
    output.mkdir(parents=True, exist_ok=True)
    native = output / "public-fixture-producer"
    subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    "-I" + str(args.openssl / "include"), "-L" + str(args.openssl / "lib"),
                    "-Wl,-rpath," + str(args.openssl / "lib"),
                    str(ROOT / "tests/portable-stdlib/native/x509-public-fixtures.c"),
                    "-lcrypto", "-o", str(native)], check=True)
    result = subprocess.run([str(native)], capture_output=True, check=True, timeout=60)
    if result.stderr or len(result.stdout) < 16:
        raise RuntimeError("native public certificate construction failed")
    (output / "public-vectors.bin").write_bytes(result.stdout)
    compose()
    env = dict(os.environ, JAIC_STDLIB=str(LIBRARY))
    compiler = str(ROOT / "target/compiler/debug/jaic")
    folder = ROOT / "tests/portable-stdlib/android-asn1-x509"
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    for name in ["main", "failures"]:
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
    for target in ["linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu,
                            str(folder / "source-check.jai")], env=env, check=True)
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(LIBRARY / "Android/Toolchain/module.jai"),
                    str(LIBRARY / "internal/android-toolchain/x509-structure.jai"), str(folder)], env=env, check=True)
    print("Four native C-created v1/v2/v3 Edwards/RSA certificates match borrowed SPKI extraction; 6 failures, 10 interpreter/native O0/O2 runs, target source checks and strict lint pass")


if __name__ == "__main__":
    main()
