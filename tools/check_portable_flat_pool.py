#!/usr/bin/env python3
"""Actual OS release and failed-release ownership, default assertions on/off."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def execute(source, label, binaries, env, output, expected="ok\n", diagnosed=False):
    commands = [[str(binaries / "jaic"), "-interp", str(source)]]
    for mode in ["-O0", "-O2"]:
        executable = output / (label + mode)
        subprocess.run([str(binaries / "jaic"), str(source), mode, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or not result.stdout.endswith(expected):
            raise RuntimeError(f"{command!r}: exit={result.returncode} {result.stdout}{result.stderr}")
        if diagnosed:
            if "flat-pool reservation release failed" not in result.stdout + result.stderr:
                raise RuntimeError("real failed release did not report its error")
        elif result.stdout != expected or result.stderr:
            raise RuntimeError(f"unexpected diagnostics: {result.stdout}{result.stderr}")


def main():
    foundation.compose()
    library = foundation.LIBRARY
    shutil.copytree(ROOT / "stdlib/Flat_Pool", library / "Flat_Pool", dirs_exist_ok=True)
    for name in ["flat-pool.jai", "virtual-memory.jai"]:
        shutil.copyfile(ROOT / "stdlib/internal/allocation" / name, library / "internal/allocation" / name)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    output = ROOT / "target/portable-flat-pool-release"
    output.mkdir(parents=True, exist_ok=True)
    sdk = output / "sdk-release"
    subprocess.run(["clang", "-std=c11", "-Wall", "-Wextra", "-Werror", "-O2",
                    str(ROOT / "tests/portable-stdlib/native/flat-pool-release.c"), "-o", str(sdk)], check=True)
    subprocess.run([str(sdk)], check=True)
    source = ROOT / "tests/portable-stdlib/flat-pool-release/main.jai"
    failure = source.with_name("failure.jai")
    facade = library / "Basic/module.jai"
    original = facade.read_text()
    if original.count("ENABLE_ASSERT := true") != 1:
        raise RuntimeError("NEW Basic default parameter changed")
    try:
        for enabled in [True, False]:
            facade.write_text(original if enabled else original.replace("ENABLE_ASSERT := true", "ENABLE_ASSERT := false"))
            execute(source, "released" + str(enabled), binaries, env, output)
            if enabled:
                execute(ROOT / "tests/portable-stdlib/flat-pool.jai", "contracts", binaries, env, output)
            else:
                execute(failure, "retained", binaries, env, output, diagnosed=True)
            print(f"Flat_Pool real OS release, assertions={enabled}: interpreter/native O0/O2 pass", flush=True)
    finally:
        facade.write_text(original)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Flat_Pool"),
                    str(library / "internal/allocation/flat-pool.jai"),
                    str(library / "internal/allocation/virtual-memory.jai"), str(source), str(failure)], env=env, check=True)


if __name__ == "__main__":
    main()
