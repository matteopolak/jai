#!/usr/bin/env python3
"""Execute real x64 CPUID against an independently source-built native C query.

An ARM64 macOS host runs x64 native programs through its normal translation.
The host ARM64 Jai interpreter must diagnose unsupported CPUID execution.
"""
import os
from pathlib import Path
import platform
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
LIBRARY = ROOT / "target/portable-integration-stdlib"
OUTPUT = ROOT / "target/portable-machine"
COMPILER = ROOT / "target/compiler/debug/jaic"


def checked(command, expected=None):
    result = subprocess.run([str(p) for p in command], cwd=ROOT,
                            env=dict(os.environ, JAIC_STDLIB=str(LIBRARY)),
                            capture_output=True, text=True, timeout=90)
    if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
        raise RuntimeError(f"{command!r}\n{result.stdout}{result.stderr}")
    return result


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for relative in ["Machine_X64", "internal/machine"]:
        shutil.copytree(ROOT / "stdlib" / relative, LIBRARY / relative, dirs_exist_ok=True)
    system, cpu = platform.system(), platform.machine().lower()
    if system == "Darwin":
        c_target = ["-arch", "x86_64"]
        jai_target = ["-target", "x86_64-apple-darwin", "-cpu", "x64"]
    elif system == "Linux" and cpu in {"x86_64", "amd64"}:
        c_target = []
        jai_target = ["-cpu", "x64"]
    else:
        raise RuntimeError("real x64 machine verification requires an x64 host or macOS x64 translation")
    native = OUTPUT / "cpuid-features"
    checked(["clang", *c_target, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
             ROOT / "tests/portable-stdlib/native/cpuid-features.c", "-o", native])
    with (OUTPUT / "cpuid.bin").open("wb") as output:
        subprocess.run([str(native)], cwd=ROOT, stdout=output, check=True, timeout=30)
    if (OUTPUT / "cpuid.bin").stat().st_size != 48:
        raise RuntimeError("native CPUID oracle output is incomplete")
    source = ROOT / "tests/portable-stdlib/machine-x64/main.jai"
    for os_name in ["macos", "linux", "windows"]:
        checked([COMPILER, "-check", "-os", os_name, "-cpu", "x64", source])
        checked([COMPILER, "-check", "-os", os_name, "-cpu", "x64",
                 ROOT / "tests/portable-stdlib/machine-x64/options.jai"])
    for optimization in ["-O0", "-O2"]:
        executable = OUTPUT / f"machine{optimization}"
        checked([COMPILER, *jai_target, optimization, source, "-exe", executable])
        checked([executable], "ok\n")
        vendor_probe = ROOT / "tests/portable-stdlib/machine-x64/cpuid-vendor.jai"
        original = OUTPUT / f"original-vendor{optimization}"
        checked([COMPILER, *jai_target, optimization, vendor_probe, "-exe", original])
        checked([original], "")
        projection = ROOT / "tests/portable-stdlib/machine-x64/options.jai"
        projected = OUTPUT / f"options{optimization}"
        checked([COMPILER, *jai_target, optimization, projection, "-exe", projected])
        checked([projected], "ok\n")
        print(f"real Machine_X64/native C comparison {optimization} passed", flush=True)
    if cpu in {"x86_64", "amd64"}:
        checked([COMPILER, "-cpu", "x64", "-interp", source], "ok\n")
        print("actual x64 interpreter passed", flush=True)
    else:
        result = subprocess.run([str(COMPILER), "-cpu", "x64", "-interp", str(source)],
                                cwd=ROOT, env=dict(os.environ, JAIC_STDLIB=str(LIBRARY)),
                                text=True, capture_output=True, timeout=60)
        if result.returncode == 0 or "CPUID" not in result.stderr or "x64" not in result.stderr:
            raise RuntimeError(f"expected unsupported interpreter-host diagnostic:\n{result.stdout}{result.stderr}")
        (OUTPUT / "unsupported-host.log").write_text(result.stdout + result.stderr)
        print("ARM64 interpreter explicitly rejects x64 CPUID; no emulation pass claimed", flush=True)
    checked([COMPILER, "-cpu", "x64", "-interp",
             ROOT / "tests/portable-stdlib/machine-x64/options.jai"], "ok\n")
    print("machine-options projection passed interpreter/native O0/O2", flush=True)


if __name__ == "__main__":
    main()
