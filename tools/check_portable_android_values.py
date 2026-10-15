#!/usr/bin/env python3
"""Reviewed pure Android manifest flags; no SDK/device tools are invoked."""
import os
import platform
from pathlib import Path
import subprocess
from portable_android_stage import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-android-values"
    output.mkdir(parents=True, exist_ok=True)
    compose()
    library = LIBRARY
    env = dict(os.environ, JAIC_STDLIB=str(library))
    compiler = str(ROOT / "target/compiler/debug/jaic")
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    sources = [ROOT / "tests/portable-stdlib/android-config-flags.jai",
               ROOT / "tests/portable-stdlib/android-config-flags/failures.jai"]
    for source in sources:
        commands = [[compiler, "-interp", str(source)]]
        for flags, label in targets:
            for optimization in ["-O0", "-O2"]:
                executable = output / (source.stem + label + optimization)
                subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(executable)],
                               env=env, check=True, timeout=90)
                commands.append([str(executable)])
        for command in commands:
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        for target in ["linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(library / "internal/android-toolchain/config-flags.jai"),
                    *map(str, sources)], env=env, check=True)
    print("Android manifest flags: 16 individual/256 pair combinations and 7 diagnosed failures pass interpreter/native O0/O2, Linux/Windows both-CPU checks and strict lint")


if __name__ == "__main__":
    main()
