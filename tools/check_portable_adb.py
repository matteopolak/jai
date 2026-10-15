#!/usr/bin/env python3
"""ADB host process/protocol regression; no actual server/device/auth commands."""
import os
import platform
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-adb"
    output.mkdir(parents=True, exist_ok=True)
    fixture = output / "sdk protocol fixture"
    subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    str(ROOT / "tests/portable-stdlib/native/adb-protocol.c"), "-o", str(fixture)], check=True)
    shutil.copyfile(fixture, output / "malformed SDK fixture")
    library = ROOT / "target/portable-integration-stdlib"
    for relative in ["Android/Toolchain", "internal/android-toolchain"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    compiler = ROOT / "target/compiler/debug/jaic"
    source = ROOT / "tests/portable-stdlib/android-adb/main.jai"
    commands = [[str(compiler), "-interp", str(source)]]
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    for flags, label in targets:
        for optimization in ["-O0", "-O2"]:
            executable = output / (label + optimization)
            subprocess.run([str(compiler), str(source), *flags, optimization, "-exe", str(executable)],
                           env=env, check=True, timeout=90)
            commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, text=True, capture_output=True, timeout=45)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}\n{result.stdout}{result.stderr}")
    verbose_source = source.with_name("verbosity.jai")
    for mode in ["interp", "O0", "O2"]:
        command = [str(compiler), "-interp", str(verbose_source)]
        if mode != "interp":
            executable = output / ("verbosity-" + mode)
            subprocess.run([str(compiler), str(verbose_source), "-" + mode, "-exe", str(executable)], env=env, check=True)
            command = [str(executable)]
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=45)
        if result.returncode or result.stdout != "echo-args\nvisible\nok\n" or result.stderr:
            raise RuntimeError(f"verbosity: {result.stdout}{result.stderr}")
    for cpu in ["x64", "arm64"]:
        subprocess.run([str(compiler), "-check", "-os", "linux", "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/android-toolchain/adb-types.jai"),
                    str(library / "internal/android-toolchain/adb-process.jai"),
                    str(library / "internal/android-toolchain/adb-transfer.jai"),
                    str(library / "internal/android-toolchain/adb-apps.jai"), str(source.parent)],
                   env=env, check=True, timeout=90)
    print("ADB native CLI protocol fixture passes interpreter/native O0/O2, Linux both-CPU checking and strict lint; SDK/device integration remains pending")


if __name__ == "__main__":
    main()
