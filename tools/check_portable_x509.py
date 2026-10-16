#!/usr/bin/env python3
"""DER public-key-info extraction against actual independently created C X509."""
import argparse
import os
from pathlib import Path
import platform
import subprocess
from openssl_sdk import discover_sdk, probe_sdk

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--openssl", type=Path, help="Installed SDK prefix; otherwise discover installed metadata/environment")
    parser.add_argument("--stdlib-root", type=Path, default=ROOT / "stdlib")
    args = parser.parse_args()
    target_value = os.environ.get("CARGO_TARGET_DIR")
    if not target_value:
        parser.error("CARGO_TARGET_DIR is required; no repository-local artifact fallback")
    target_dir = Path(target_value).resolve()
    output = target_dir / "portable-x509"
    output.mkdir(parents=True, exist_ok=True)
    sdk = discover_sdk(args.openssl)
    probe_sdk(sdk, output / "sdk-probe")
    env = sdk.runtime_environment()
    env.update(JAIC_STDLIB=str(args.stdlib_root.resolve()),
               TMPDIR=str(output / "sdk-probe/scratch"), TEMP=str(output / "sdk-probe/scratch"), TMP=str(output / "sdk-probe/scratch"))
    native = output / "public-fixture-producer"
    subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    *sdk.cflags,
                    str(ROOT / "tests/portable-stdlib/native/x509-public-fixtures.c"),
                    *sdk.ldflags, "-o", str(native)], env=env, cwd=output, check=True)
    result = subprocess.run([str(native)], env=env, cwd=output, capture_output=True, check=True, timeout=60)
    if result.stderr or len(result.stdout) < 16:
        raise RuntimeError("native public certificate construction failed")
    vectors = output / "public-vectors.bin"
    vectors.write_bytes(result.stdout)
    compiler = str(target_dir / "debug/jaic")
    folder = ROOT / "tests/portable-stdlib/android-asn1-x509"
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    for name in ["main", "failures"]:
        source = folder / (name + ".jai")
        fixture_args = [str(vectors)] if name == "main" else []
        commands = [[compiler, "-interp", str(source), "--", *fixture_args]]
        for flags, label in targets:
            for optimization in ["-O0", "-O2"]:
                executable = output / (name + label + optimization)
                subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(executable)], env=env, check=True)
                commands.append([str(executable), *fixture_args])
        for command in commands:
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    for target_system in ["linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            subprocess.run([compiler, "-check", "-os", target_system, "-cpu", cpu,
                            str(folder / "source-check.jai")], env=env, check=True)
    for name in ["main", "failures"]:
        source = folder / (name + ".jai")
        subprocess.run([str(target_dir / "debug/jailint"), "-D", "warnings", "--context", str(source),
                        str(args.stdlib_root / "internal/android-toolchain/x509-structure.jai"), str(source)], env=env, check=True)
    print("Four native C-created v1/v2/v3 Edwards/RSA certificates match borrowed SPKI extraction; 6 failures, 10 interpreter/native O0/O2 runs, target source checks and strict lint pass")


if __name__ == "__main__":
    main()
