#!/usr/bin/env python3
"""Verify public ISA wrappers with actual opcodes, hardware and capability errors."""
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess
import struct

ROOT = Path(__file__).resolve().parents[1]
LIBRARY = ROOT / "target/portable-integration-stdlib"
OUTPUT = ROOT / "target/portable-machine-instructions"


def main():
    system = platform.system()
    if system == "Darwin":
        target = ["-target", "x86_64-apple-darwin"]
        interpreter = ROOT / "target/compiler/x86_64-apple-darwin/debug/jaic"
        c_target = ["-arch", "x86_64"]
    elif system == "Linux" and platform.machine().lower() in ["amd64", "x86_64"]:
        target, c_target = [], []
        interpreter = ROOT / "target/compiler/debug/jaic"
    else:
        raise RuntimeError("ISA execution requires actual x64 or macOS translation")
    disassembler = shutil.which("llvm-objdump")
    if not disassembler:
        raise RuntimeError("llvm-objdump is required")
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for name in ["Machine_X64", "internal/machine"]:
        shutil.copytree(ROOT / "stdlib" / name, LIBRARY / name, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(LIBRARY))
    compiler = ROOT / "target/compiler/debug/jaic"
    fixture = ROOT / "tests/portable-stdlib/machine-x64/instructions.jai"

    def checked(command, expected=None):
        result = subprocess.run([str(p) for p in command], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=120)
        if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
            raise RuntimeError(f"{command!r}\n{result.stdout}{result.stderr}")
        return result.stdout

    oracle = OUTPUT / "cpuid"
    checked(["clang", *c_target, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
             ROOT / "tests/portable-stdlib/native/cpuid-features.c", "-o", oracle])
    data = subprocess.run([str(oracle)], capture_output=True, check=True, timeout=30).stdout
    if len(data) != 48:
        raise RuntimeError("incomplete native SDK CPUID oracle")
    leaves = struct.unpack("<12I", data)[1:]
    capabilities = {"rdrand": bool(leaves[1] & (1 << 30)),
                    "rdseed": bool(leaves[6] & (1 << 18))}
    print(f"Actual native SDK CPUID optional capabilities: {capabilities}", flush=True)
    mnemonics = ["rdtsc", "rdtscp", "rdrand", "rdseed", "mfence", "lfence", "sfence",
                 "prefetcht0", "prefetcht1", "prefetcht2", "prefetchnta"]
    for optimization in ["-O0", "-O2"]:
        program = OUTPUT / ("public" + optimization)
        checked([compiler, *target, optimization, fixture, "-exe", program])
        checked([program], "ok\n")
        listing = checked([disassembler, "-d", program])
        (OUTPUT / (program.name + ".asm")).write_text(listing)
        counts = {name: len(re.findall(r"^\s*[0-9a-f]+:.*\b" + name + r"[a-z]*\b", listing, re.MULTILINE))
                  for name in mnemonics}
        if any(count == 0 for count in counts.values()):
            raise RuntimeError(f"missing public-wrapper opcodes: {counts}")
        print(f"public native {optimization}: {counts}", flush=True)
        for name, available in capabilities.items():
            source = ROOT / f"tests/portable-stdlib/machine-x64/{name}.jai"
            if available:
                rng_program = OUTPUT / (name + optimization)
                checked([compiler, *target, optimization, source, "-exe", rng_program])
                checked([rng_program], "ok\n")
                print(f"actual {name} execution {optimization} passed", flush=True)
    checked([interpreter, "-interp", fixture], "ok\n")
    for name, available in capabilities.items():
        source = ROOT / f"tests/portable-stdlib/machine-x64/{name}.jai"
        if available:
            checked([interpreter, "-interp", source], "ok\n")
        else:
            result = subprocess.run([str(interpreter), "-interp", str(source)], env=env, cwd=ROOT,
                                    text=True, capture_output=True, timeout=30)
            (OUTPUT / (name + "-unavailable.log")).write_text(result.stdout + result.stderr)
            if result.returncode == 0 or name.upper() not in result.stderr:
                raise RuntimeError(f"missing {name} unavailable-CPU diagnostic: {result.stdout}{result.stderr}")
            print(f"{name}: actual interpreter capability error verified; native execution remains pending capable CI", flush=True)
    for target_os in ["macos", "linux", "windows"]:
        checked([compiler, "-check", "-os", target_os, "-cpu", "x64", fixture])
    checked([ROOT / "target/compiler/debug/jailint", *target, "-D", "warnings",
             LIBRARY / "Machine_X64", LIBRARY / "internal/machine",
             ROOT / "tests/portable-stdlib/machine-x64/instructions.jai",
             ROOT / "tests/portable-stdlib/machine-x64/rdrand.jai",
             ROOT / "tests/portable-stdlib/machine-x64/rdseed.jai"])
    print("Public wrappers pass native/interpreter execution, target source checks and strict target-aware lint", flush=True)


if __name__ == "__main__":
    main()
