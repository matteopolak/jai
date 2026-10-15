#!/usr/bin/env python3
"""JAVA_HOME host discovery using a source-built launcher protocol fixture."""
import os
import platform
from pathlib import Path
import shutil
import subprocess
from check_portable_time_foundation import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-java"
    output.mkdir(parents=True, exist_ok=True)
    home = output / "JDK space"
    (home / "bin").mkdir(parents=True, exist_ok=True)
    executable = home / "bin/java"
    subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    str(ROOT / "tests/portable-stdlib/native/java-protocol.c"), "-o", str(executable)], check=True)
    failing = output / "failing JDK/bin"
    failing.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(executable, failing / "java")
    shutil.copymode(executable, failing / "java")
    library = ROOT / "target/portable-integration-stdlib"
    for relative in ["Android/Toolchain", "internal/android-toolchain"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    compose()
    library = LIBRARY
    env = dict(os.environ, JAIC_STDLIB=str(library))
    compiler = str(ROOT / "target/compiler/debug/jaic")
    source = ROOT / "tests/portable-stdlib/android-java/main.jai"
    commands = [[compiler, "-interp", str(source), "--"]]
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    for flags, label in targets:
        for optimization in ["-O0", "-O2"]:
            binary = output / (label + optimization)
            subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(binary)], env=env, check=True)
            commands.append([str(binary)])
    for command in commands:
        for value in [str(home), str(home) + "///", str(output / "failing JDK"),
                      str(output / "missing JDK"), "", None]:
            configuration = env.copy()
            if value is None:
                configuration.pop("JAVA_HOME", None)
            else:
                configuration["JAVA_HOME"] = value
            arguments = [str(home / "bin"), str(executable)] if value and "JDK space" in value else ["missing"]
            result = subprocess.run([*command, *arguments], cwd=ROOT, env=configuration,
                                    capture_output=True, text=True, timeout=45)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}, JAVA_HOME={value!r}: {result.stdout}{result.stderr}")
    for cpu in ["x64", "arm64"]:
        subprocess.run([compiler, "-check", "-os", "linux", "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(library / "internal/android-toolchain/java-discovery.jai"), str(source)], env=env, check=True)
    print("JAVA_HOME discovery passes 30 interpreter/native configurations, Linux source checks and strict lint; real JVM/Windows integration pending")


if __name__ == "__main__":
    main()
