#!/usr/bin/env python3
"""Real SDK/Jai resolver gate; compiler failures remain failures, never skips."""
import os
from pathlib import Path
import platform
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BINARIES = Path(os.environ.get("CARGO_TARGET_DIR", ROOT / "target/compiler")) / "debug"


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("this reviewed macOS ABI fixture requires its actual SDK")
    output = ROOT / "target/portable-socket-resolver"
    output.mkdir(parents=True, exist_ok=True)
    initial = []
    for _ in range(2):
        subprocess.run(["python3", "-B", str(ROOT / "tools/generate_socket_abi.py"),
                        "--formatter", str(ROOT / "target/jaifmt"), "--output-root", str(output / "generated")], check=True)
        initial.append(tuple((output / "generated" / relative).read_bytes() for relative in
                             ["stdlib/Socket/native.jai", "stdlib/internal/net/socket-abi.jai", "docs/socket-native-ledger.json"]))
    if initial[0] != initial[1]:
        raise RuntimeError("review-derived declaration generation is not stable")
    expected = [48, 8, 0, 4, 8, 12, 16, 24, 32, 40, 32123, 0x7f000001]
    for flags, label in [([], "host"), (["-arch", "x86_64"], "x64")]:
        native = output / ("sdk-probe-" + label)
        subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", *flags,
                        str(ROOT / "tests/portable-stdlib/native/socket-resolver.c"), "-o", str(native)], check=True)
        result = subprocess.run([str(native)], capture_output=True, text=True, check=True)
        if result.stderr or list(map(int, result.stdout.split())) != expected:
            raise RuntimeError(f"actual SDK ABI/resolver mismatch: {result.stdout}{result.stderr}")
        print(f"Actual macOS C SDK {label} layout and numeric resolver pass:", result.stdout.strip(), flush=True)
    library = output / "stdlib"
    shutil.copytree(ROOT / "target/portable-integration-stdlib", library, dirs_exist_ok=True)
    for relative in ["Socket/native.jai", "internal/net/socket-abi.jai"]:
        shutil.copyfile(output / "generated/stdlib" / relative, library / relative)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    compiler = str(BINARIES / "jaic")
    source = ROOT / "tests/portable-stdlib/socket-resolver/main.jai"
    commands = [[compiler, "-interp", str(source)]]
    for flags, label in [([], "host"), (["-target", "x86_64-apple-darwin"], "x64")]:
        for optimization in ["-O0", "-O2"]:
            executable = output / (label + optimization)
            subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(executable)], env=env, check=True)
            commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=45)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    for cpu in ["x64", "arm64"]:
        subprocess.run([compiler, "-check", "-os", "macos", "-cpu", cpu, str(source)], env=env, check=True)
    print("Actual Jai resolver execution passes interpreter/native ARM64/x64 O0/O2 and source checks; whole-binding lint follows", flush=True)
    subprocess.run([str(BINARIES / "jailint"), "-D", "warnings",
                    str(library / "Socket/native.jai"), str(library / "internal/net/socket-abi.jai"), str(source)], env=env, check=True)
    print("Jai public resolver passes interpreter/native both CPUs O0/O2, source checks and strict lint")


if __name__ == "__main__":
    main()
