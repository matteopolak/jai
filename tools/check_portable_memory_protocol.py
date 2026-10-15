#!/usr/bin/env python3
"""Reviewed packet layouts and opaque trace-pair equality, with no dereferences."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["Protocol_For_Memory_Visualization/module.jai", "internal/debug/memory-protocol.jai"]:
        shutil.copyfile(ROOT / "stdlib" / relative, library / relative)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-memory-protocol"
    output.mkdir(parents=True, exist_ok=True)
    for name in ["memory-protocol", "memory-protocol-compare"]:
        source = ROOT / "tests/portable-stdlib" / (name + ".jai")
        commands = [[compiler, "-interp", str(source)]]
        for mode in ["-O0", "-O2"]:
            executable = output / (name + mode)
            subprocess.run([compiler, str(source), mode, "-exe", str(executable)], env=env, cwd=ROOT, check=True)
            commands.append([str(executable)])
        for command in commands:
            result = subprocess.run(command, env=env, cwd=ROOT, capture_output=True, text=True, timeout=60)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        for target in ["linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu, str(source)],
                               env=env, cwd=ROOT, check=True)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Protocol_For_Memory_Visualization/module.jai"),
                    str(library / "internal/debug/memory-protocol.jai"),
                    str(ROOT / "tests/portable-stdlib/memory-protocol.jai"),
                    str(ROOT / "tests/portable-stdlib/memory-protocol-compare.jai")],
                   env=env, cwd=ROOT, check=True)
    print("Memory protocol: canonical packet layouts and 2401 symmetric opaque pointer-pair comparisons pass #run/interpreter/native O0/O2, Linux/Windows both-CPU source checks and strict lint")


if __name__ == "__main__":
    main()
