#!/usr/bin/env python3
"""Reviewed optimized Default_Allocator heap behavior on the real Mac x64 host."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    shutil.copytree(ROOT / "stdlib/Default_Allocator", library / "Default_Allocator", dirs_exist_ok=True)
    for source in (ROOT / "stdlib/internal/allocation").glob("default-*.jai"):
        shutil.copyfile(source, library / "internal/allocation" / source.name)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-default-allocator"
    output.mkdir(parents=True, exist_ok=True)
    source = ROOT / "tests/portable-stdlib/default-allocator-heaps/main.jai"
    target = ["-target", "x86_64-apple-darwin"]
    commands = [[compiler, *target, "-interp", str(source), "--"]]
    for level in ["-O0", "-O2"]:
        executable = output / ("heaps" + level)
        subprocess.run([compiler, str(source), *target, level, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        for failure in ["wrong-heap", "wrong-size", "unknown-pointer"]:
            result = subprocess.run([*command, failure], env=env, capture_output=True, text=True, timeout=60)
            if result.returncode == 0 or "Default_Allocator" not in result.stdout + result.stderr:
                raise RuntimeError(f"invalid allocator input accepted: {failure}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-target", "x86_64-apple-darwin", "-D", "warnings",
                    str(library / "Default_Allocator/module.jai"),
                    str(library / "internal/allocation/default-heaps.jai"),
                    str(library / "internal/allocation/default-records.jai"), str(source)], env=env, check=True)
    print("Default_Allocator heaps: init/finalize/reinitialize, exact capabilities/canonical records, aligned zero/small/large allocations, grow/shrink/preservation, failure retention, ownership/free-all/destroy/statistics pass x64 interpreter/native O0/O2 and strict lint")


if __name__ == "__main__":
    main()
