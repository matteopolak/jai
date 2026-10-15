#!/usr/bin/env python3
"""Verify original x64 Meow assertions against the selected production library.
"""
import argparse
import os
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--jaic", type=Path, default=ROOT / "target/debug/jaic")
parser.add_argument("--stdlib", type=Path, default=ROOT / "stdlib")
args = parser.parse_args()
compiler = args.jaic.resolve(strict=True)
library = args.stdlib.resolve(strict=True)
env = dict(os.environ, JAIC_STDLIB=str(library))
if platform.system() == "Darwin":
    native_target = ["-target", "x86_64-apple-darwin", "-cpu", "x64"]
elif platform.system() == "Linux" and platform.machine().lower() in {"x86_64", "amd64"}:
    native_target = ["-cpu", "x64"]
else:
    raise RuntimeError("this focused legacy native-x64 check needs macOS x64 execution or Linux x64")
fixture = ROOT / "tests/stdlib/meow-hash.jai"
executable = ROOT / "target/portable-tests/meow-existing-x64"
executable.parent.mkdir(parents=True, exist_ok=True)
subprocess.run([str(compiler), *native_target, str(fixture), "-exe", str(executable)],
               cwd=ROOT, env=env, check=True, timeout=60)
for command in [[str(compiler), "-cpu", "x64", "-interp", str(fixture), "--"], [str(executable)]]:
    result = subprocess.run(command, cwd=ROOT, env=env, check=True,
                            text=True, capture_output=True, timeout=45)
    assert result.stdout == "ok\n" and result.stderr == "", result
print("Existing own Meow assertions passed interpreter/native x64 against the selected production library")
