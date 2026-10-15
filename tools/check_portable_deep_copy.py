#!/usr/bin/env python3
"""Real graph/callback timing with actual default Basic assertions on and off."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["Deep_Copy", "Hash_Table"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    for relative in ["internal/memory", "internal/collections"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    for relative in ["Hash", "internal/hash"]:
        shutil.copytree(ROOT.parent / "foundations/stdlib" / relative, library / relative, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    output = ROOT / "target/portable-deep-copy"
    output.mkdir(parents=True, exist_ok=True)
    facade = library / "Basic/module.jai"
    original = facade.read_text()
    if original.count("ENABLE_ASSERT := true") != 1:
        raise RuntimeError("NEW Basic default parameter changed")
    sources = [ROOT / "tests/portable-stdlib" / name for name in
               ["deep-copy-timing/main.jai", "deep-copy-graph.jai", "deep-copy-scalars.jai", "deep-copy-debug.jai"]]
    for enabled in [True, False]:
        # Change the STAGED default module instance, not merely a caller import.
        facade.write_text(original if enabled else original.replace("ENABLE_ASSERT := true", "ENABLE_ASSERT := false"))
        for source in sources:
            commands = [[str(binaries / "jaic"), "-interp", str(source)]]
            for mode in ["-O0", "-O2"]:
                executable = output / (source.parent.name + source.stem + str(enabled) + mode)
                subprocess.run([str(binaries / "jaic"), str(source), mode, "-exe", str(executable)], env=env, check=True)
                commands.append([str(executable)])
            for command in commands:
                result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
                if result.returncode or result.stdout != "ok\n" or result.stderr:
                    raise RuntimeError(f"assertions={enabled} {command!r}: exit={result.returncode} {result.stdout}{result.stderr}")
        print(f"Deep_Copy actual default assertions={enabled}: timer/callback, graph, scalar and debug interpreter/native O0/O2 pass", flush=True)
    facade.write_text(original)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Deep_Copy"),
                    str(library / "internal/memory/deep-copy.jai"),
                    str(library / "internal/memory/deep-copy-types.jai"), *map(str, sources)], env=env, check=True)


if __name__ == "__main__":
    main()
