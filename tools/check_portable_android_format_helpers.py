#!/usr/bin/env python3
"""Reviewed canonical formatter aliases, preserving nonbaked named parameters."""
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
    output = ROOT / "target/portable-android-format-helpers"
    output.mkdir(parents=True, exist_ok=True)
    source = ROOT / "tests/portable-stdlib/android-format-helpers/main.jai"
    commands = [[compiler, "-interp", str(source)]]
    for level in ["-O0", "-O2"]:
        executable = output / ("format" + level)
        subprocess.run([compiler, str(source), level, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/android-toolchain/format-helpers.jai"), str(source)], env=env, check=True)
    print("Android formatter aliases: actual canonical FormatInt, all256 values/four baked widths and named default forwarding pass interpreter/native O0/O2 and strict lint")


if __name__ == "__main__":
    main()
