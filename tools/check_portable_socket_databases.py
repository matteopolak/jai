#!/usr/bin/env python3
"""Actual active Mac Socket database declarations versus official SDK C layouts."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    shutil.copytree(ROOT / "stdlib/Socket", library / "Socket", dirs_exist_ok=True)
    for source in (ROOT / "stdlib/internal/net").glob("socket*.jai"):
        shutil.copyfile(source, library / "internal/net" / source.name)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-socket-databases"
    output.mkdir(parents=True, exist_ok=True)
    source = ROOT / "tests/portable-stdlib/socket-databases/main.jai"
    expected = None
    for flags, label in [([], "host"), (["-arch", "x86_64"], "x64")]:
        executable = output / ("sdk-" + label)
        subprocess.run(["clang", "-std=c11", "-Wall", "-Wextra", "-Werror", *flags,
                        str(ROOT / "tests/portable-stdlib/native/socket-databases.c"), "-o", str(executable)], check=True)
        result = subprocess.run([str(executable)], capture_output=True, text=True, check=True)
        if result.stderr or (expected is not None and result.stdout != expected):
            raise RuntimeError(f"SDK database shape mismatch: {result.stdout}{result.stderr}")
        expected = result.stdout
    commands = [[compiler, "-interp", str(source)]]
    for flags, label in [([], "host"), (["-target", "x86_64-apple-darwin"], "x64")]:
        for level in ["-O0", "-O2"]:
            executable = output / (label + level)
            subprocess.run([compiler, str(source), *flags, level, "-exe", str(executable)], env=env, check=True)
            commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != expected or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(source)], env=env, check=True)
    print("Mac network databases: active public layouts/canonical names and real SDK calls match C, interpreter/native ARM64/x64 O0/O2; fixture strict lint passes")


if __name__ == "__main__":
    main()
