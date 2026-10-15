#!/usr/bin/env python3
"""Actual SDK/status checks and optional real Java generation/read/sign workflow."""
import os
import argparse
from pathlib import Path
import subprocess
import tempfile
from portable_android_stage import compose
from portable_crypto_stage import compose_into as compose_crypto

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--java-bin", type=Path, help="actual SDK bin directory for the pending positive test")
    parser.add_argument("--openssl", type=Path, default=Path("/opt/homebrew/opt/openssl@3"))
    args = parser.parse_args()
    library = compose()
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-jks-generation"
    output.mkdir(parents=True, exist_ok=True)
    keystore = output / "must-not-exist.jks"
    if keystore.exists():
        raise RuntimeError("test destination already exists; refusing to read an existing store")
    source = ROOT / "tests/portable-stdlib/android-jks-generation/main.jai"
    commands = [[compiler, "-interp", str(source), "--"]]
    for level in ["-O0", "-O2"]:
        executable = output / ("negative" + level)
        subprocess.run([compiler, str(source), level, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run([*command, str(keystore)], env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or not result.stdout.endswith("ok\n") or "Java keytool did not create" not in result.stdout + result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        if keystore.exists():
            raise RuntimeError("unavailable SDK produced a fabricated store")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/android-toolchain/jks-generation.jai"), str(source)], env=env, check=True)
    print("JKS generation: rejection/status and real absent-SDK failure pass interpreter/native O0/O2 and strict lint", flush=True)
    if args.java_bin:
        compose_crypto(library, args.openssl)
        positive = source.with_name("positive.jai")
        roundtrip = source.with_name("roundtrip.jai")
        for fixture in [positive, roundtrip]:
            positive_commands = [([compiler, "-interp", str(fixture), "--"], "interp")]
            for level in ["-O0", "-O2"]:
                executable = output / (fixture.stem + level)
                subprocess.run([compiler, str(fixture), level, "-exe", str(executable)], env=env, check=True)
                positive_commands.append(([str(executable)], level))
            for algorithm in (["EC"] if fixture == positive else ["EC", "RSA", "DSA"]):
                for command, mode in positive_commands:
                    directory = Path(tempfile.mkdtemp(prefix=fixture.stem + algorithm + mode, dir=output))
                    destination = directory / "fresh.jks"
                    extra = [algorithm] if fixture == roundtrip else []
                    result = subprocess.run([*command, str(args.java_bin.resolve()), str(destination), *extra],
                                            env=env, capture_output=True, text=True, timeout=90)
                    if result.returncode or result.stdout != "ok\n" or result.stderr:
                        raise RuntimeError(f"{command!r}: {result.returncode} {result.stdout}{result.stderr}")
                    if destination.read_bytes()[:4] != bytes.fromhex("feedfeed"):
                        raise RuntimeError("actual SDK did not produce JKS framing")
                    subprocess.run([str(args.java_bin / "keytool"), "-list", "-keystore", str(destination),
                                    "-storetype", "JKS", "-storepass", "password", "-alias", "jaiiskewl"],
                                   check=True, capture_output=True, timeout=30)
                print(f"Actual Java {fixture.stem}/{algorithm} interpreter/native O0/O2 passes", flush=True)
            for target in ["linux", "windows"]:
                for cpu in ["x64", "arm64"]:
                    subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu, str(fixture)], env=env, check=True)
        subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(positive), str(roundtrip)], env=env, check=True)
        print("Actual Java JKS creation/list/defaults plus EC/RSA/DSA read/decrypt/sign/independent C verify pass interpreter/native O0/O2 and strict lint; other key-size/native-platform and production packaging gates remain")
    else:
        print("Positive Java workflow not requested; no SDK success credit")


if __name__ == "__main__":
    main()
