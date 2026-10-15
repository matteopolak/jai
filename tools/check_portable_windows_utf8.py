#!/usr/bin/env python3
"""Check Windows_Utf8 ABI targets; --native requires actual Windows execution.

Uses the NEW dependency composition prepared by check_portable_stdlib.py.
Never substitutes Kernel32 or reports type-checking as runtime execution.
"""
import argparse
import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--native", action="store_true")
    args = parser.parse_args()
    if args.native and os.name != "nt":
        parser.error("native Windows_Utf8 verification requires an actual Windows host")
    suffix = ".exe" if os.name == "nt" else ""
    compiler = ROOT / f"target/compiler/debug/jaic{suffix}"
    library = ROOT / "target/portable-integration-stdlib"
    if not (library / "prelude/module.jai").is_file():
        parser.error("prepare the independent dependency composition first")
    for relative in ["Windows_Utf8/module.jai", "internal/text/windows-utf8.jai"]:
        destination = library / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ROOT / "stdlib" / relative, destination)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    source = ROOT / "tests/portable-stdlib/windows-utf8/main.jai"

    def checked(arguments, expected=None):
        result = subprocess.run(arguments, cwd=ROOT, env=env, text=True,
                                capture_output=True, check=True)
        if result.stderr or (expected is not None and result.stdout != expected):
            raise RuntimeError(f"{arguments!r}\n{result.stdout}{result.stderr}")

    for cpu in ["x64", "arm64"]:
        checked([str(compiler), "-check", "-os", "windows", "-cpu", cpu, str(source)])
        print(f"Windows/{cpu} ABI/body type-check passed", flush=True)
    if not args.native:
        print("Kernel32 runtime execution remains unverified; no native pass claimed")
        return
    checked([str(compiler), "-interp", str(source)], "ok\n")
    for optimization in ["-O0", "-O2"]:
        executable = ROOT / f"target/windows-utf8{optimization}{suffix}"
        checked([str(compiler), str(source), optimization, "-exe", str(executable)])
        checked([str(executable)], "ok\n")
    print("Actual Windows interpreter/native O0/O2 passed")


if __name__ == "__main__":
    main()
