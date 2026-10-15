#!/usr/bin/env python3
"""Real negative SDK/validation checks; positive Java generation remains pending."""
import os
import argparse
from pathlib import Path
import subprocess
from portable_android_stage import compose

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--java-bin", type=Path, help="actual SDK bin directory for the pending positive test")
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
    print("JKS generation: rejection/status and real absent-SDK failure pass interpreter/native O0/O2 and strict lint. POSITIVE JAVA KEYTOOL GENERATION UNVERIFIED: host Java unavailable; no success credit")
    if args.java_bin:
        positive = source.with_name("positive.jai")
        destination = output / "fresh-sdk-positive.jks"
        if destination.exists():
            raise RuntimeError("positive destination already exists; refusing existing credential input")
        subprocess.run([compiler, "-interp", str(positive), "--", str(args.java_bin.resolve()), str(destination)], env=env, check=True)
        if destination.read_bytes()[:4] != bytes.fromhex("feedfeed"):
            raise RuntimeError("actual SDK did not produce JKS framing")
        subprocess.run([str(args.java_bin / "keytool"), "-list", "-keystore", str(destination),
                        "-storetype", "JKS", "-storepass", "password", "-alias", "jaiiskewl"], check=True)
        print("Actual Java SDK positive JKS generation/list validation passes; native positive still pending")


if __name__ == "__main__":
    main()
