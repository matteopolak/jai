#!/usr/bin/env python3
"""Execute original general Compiler mechanisms needed by profiling instrumentation."""
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))


def run(command):
    result = subprocess.run([str(item) for item in command], cwd=ROOT, env=ENV,
                            text=True, capture_output=True, timeout=120)
    if result.returncode or result.stdout != "ok\n" or result.stderr:
        raise RuntimeError(f"Original instrumentation mechanism failed: {command}; status={result.returncode}, expected exact ok output and no diagnostics")


def main():
    folder = ROOT / "tests/developer-tools/compiler-requests"
    for stem, child in [("procedure-edit", "procedure-edit"), ("late-source", "late-source")]:
        run([ROOT / "target/debug/jaic", folder / f"{stem}-driver.jai", "-interp"])
        for optimization in [0, 2]:
            run([ROOT / f"target/developer-tools-{child}-o{optimization}"])
    print("Original procedure hooks and late-source/live-helper native O0/O2 effects passed")


if __name__ == "__main__":
    main()
