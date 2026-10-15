#!/usr/bin/env python3
"""Actual watcher registry lifecycle, default Basic assertions enabled/disabled."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    subprocess.run(["python3", "-B", str(ROOT / "tools/build_portable_watcher.py")], check=True)
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["File_Watcher", "internal/watching", "Pool", "internal/allocation"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    for relative in ["macOS", "Objective_C"]:
        shutil.copytree(ROOT.parent / "bindings/stdlib" / relative, library / relative, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    source = ROOT / "tests/portable-stdlib/file-watcher/lifecycle-no-assert.jai"
    output = ROOT / "target/portable-watcher-assertions"
    output.mkdir(parents=True, exist_ok=True)
    facade = library / "Basic/module.jai"
    original = facade.read_text()
    if original.count("ENABLE_ASSERT := true") != 1:
        raise RuntimeError("NEW Basic default parameter changed")
    try:
        for enabled in [True, False]:
            facade.write_text(original if enabled else original.replace("ENABLE_ASSERT := true", "ENABLE_ASSERT := false"))
            commands = [[str(binaries / "jaic"), "-interp", str(source)]]
            for mode in ["-O0", "-O2"]:
                executable = output / (str(enabled) + mode)
                subprocess.run([str(binaries / "jaic"), str(source), mode, "-exe", str(executable)], env=env, check=True)
                commands.append([str(executable)])
            for command in commands:
                result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=8)
                if result.returncode or result.stdout != "ok\n" or result.stderr:
                    raise RuntimeError(f"{command!r}: exit={result.returncode} {result.stdout}{result.stderr}")
            print(f"File_Watcher actual default assertions={enabled}: eight init/poll/deinit lifecycles pass interpreter/native O0/O2", flush=True)
    finally:
        facade.write_text(original)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "File_Watcher"),
                    str(library / "internal/watching/mac.jai"), str(source)], env=env, check=True)


if __name__ == "__main__":
    main()
