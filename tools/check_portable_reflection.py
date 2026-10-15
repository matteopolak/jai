#!/usr/bin/env python3
"""Full reviewed Reflection public API audit against actual NEW parser dependency."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["Reflection", "internal/reflection"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    source = ROOT / "tests/portable-stdlib/reflection-contract/main.jai"
    output = ROOT / "target/portable-reflection-contract"
    output.mkdir(parents=True, exist_ok=True)
    commands = [[str(binaries / "jaic"), "-interp", str(source)]]
    for mode in ["-O0", "-O2"]:
        executable = output / ("reflection" + mode)
        subprocess.run([str(binaries / "jaic"), str(source), mode, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: exit={result.returncode} {result.stdout}{result.stderr}")
    for target in ["linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            subprocess.run([str(binaries / "jaic"), "-check", "-os", target, "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Reflection"),
                    str(library / "internal/reflection"), str(source)], env=env, check=True)
    print("Reflection11 public API rows: scalar widths/ranges/failed-store preservation, cursor parsing, enum metadata, all array forms and struct field addresses pass interpreter/native Mac O0/O2, Linux/Windows both-CPU source checks and whole owned strict lint")


if __name__ == "__main__":
    main()
