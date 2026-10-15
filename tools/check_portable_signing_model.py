#!/usr/bin/env python3
"""Canonical shared signing model only; no claimed signing/key/device result."""
import os
from pathlib import Path
import subprocess
from portable_android_stage import compose

ROOT = Path(__file__).resolve().parents[1]


def main():
    library = compose()
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-signing-model"
    output.mkdir(parents=True, exist_ok=True)
    source = ROOT / "tests/portable-stdlib/android-signing-model/main.jai"
    commands = [[compiler, "-interp", str(source)]]
    for mode in ["-O0", "-O2"]:
        executable = output / ("model" + mode)
        subprocess.run([compiler, str(source), mode, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    for target in ["linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/android-toolchain/signing-model.jai"), str(source)], env=env, check=True)
    print("Canonical signing model: exact enum/default/record names, promoted JKS members and union storage pass interpreter/native O0/O2, Linux/Windows source checks and strict lint; no signing functions stubbed")


if __name__ == "__main__":
    main()
