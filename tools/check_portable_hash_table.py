#!/usr/bin/env python3
"""Actual duplicate/tombstone/growth/iteration contract across configured tables."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["Hash_Table", "internal/collections"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    for relative in ["Hash", "internal/hash"]:
        shutil.copytree(ROOT.parent / "foundations/stdlib" / relative, library / relative, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    source = ROOT / "tests/portable-stdlib/hash-table-contract/main.jai"
    output = ROOT / "target/portable-hash-table-contract"
    output.mkdir(parents=True, exist_ok=True)
    commands = [[str(binaries / "jaic"), "-interp", str(source)]]
    for mode in ["-O0", "-O2"]:
        executable = output / ("table" + mode)
        subprocess.run([str(binaries / "jaic"), str(source), mode, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: exit={result.returncode} {result.stdout}{result.stderr}")
    for target in ["linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            subprocess.run([str(binaries / "jaic"), "-check", "-os", target, "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Hash_Table"),
                    str(library / "internal/collections/hash-table.jai"), str(source)], env=env, check=True)
    print("Hash_Table public duplicates/tombstones/growth/reset/iteration/collision contracts pass default and configured true/false-refill tables interpreter/native Mac O0/O2 and whole owned strict lint")


if __name__ == "__main__":
    main()
