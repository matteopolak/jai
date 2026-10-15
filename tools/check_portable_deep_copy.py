#!/usr/bin/env python3
"""Deep-copy behavior against the actual production library; no default-parameter edits."""
import os
from pathlib import Path
import subprocess
ROOT = Path(__file__).resolve().parents[1]

def main():
    library = ROOT / "stdlib"
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    env = dict(os.environ, JAIC_STDLIB=str(library))
    output = ROOT / "target/portable-deep-copy"
    output.mkdir(parents=True, exist_ok=True)
    sources = [ROOT / "tests/portable-stdlib" / name for name in
               ["deep-copy-timing/main.jai", "deep-copy-graph.jai", "deep-copy-scalars.jai", "deep-copy-debug.jai"]]
    for source in sources:
        commands = [[str(binaries / "jaic"), "-interp", str(source)]]
        for mode in ["-O0", "-O2"]:
            executable = output / (source.parent.name + source.stem + mode)
            subprocess.run([str(binaries / "jaic"), str(source), mode, "-exe", str(executable)], env=env, check=True)
            commands.append([str(executable)])
        for command in commands:
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Deep_Copy"),
                    str(library / "internal/memory/deep-copy.jai"),
                    str(library / "internal/memory/deep-copy-types.jai"), *map(str, sources)], env=env, check=True)
    print("Production Deep_Copy four fixtures pass interpreter/native O0/O2 and strict lint; no altered-default profile claim")

if __name__ == "__main__":
    main()
