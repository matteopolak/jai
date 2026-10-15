#!/usr/bin/env python3
"""Validate real XML plist output with NEW formatting foundations and native tools."""
import argparse
import os
from pathlib import Path
import platform
import subprocess

from check_portable_stdlib import valid_bundle_plist

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--jaic", type=Path, default=ROOT / "target/debug/jaic")
parser.add_argument("--stdlib", type=Path, default=ROOT / "stdlib")
args = parser.parse_args()
compiler = args.jaic.resolve(strict=True)
library = args.stdlib.resolve(strict=True)
env = dict(os.environ, JAIC_STDLIB=str(library))
fixture = ROOT / "tests/portable-stdlib/bundle-plist.jai"
executable = ROOT / "target/portable-tests/plist-foundations"
executable.parent.mkdir(parents=True, exist_ok=True)
subprocess.run([str(compiler), str(fixture), "-exe", str(executable)],
               cwd=ROOT, env=env, check=True, timeout=60)
for command in [[str(compiler), "-interp", str(fixture), "--"], [str(executable)]]:
    result = subprocess.run(command, cwd=ROOT, env=env, check=True,
                            text=True, capture_output=True, timeout=45)
    assert result.stderr == "" and valid_bundle_plist(result.stdout, require_reals=True), result
    if platform.system() == "Darwin":
        checked = subprocess.run(["/usr/bin/plutil", "-lint", "-"], input=result.stdout,
                                 text=True, capture_output=True, check=True, timeout=45)
        assert checked.stdout.strip() == "<stdin>: OK" and checked.stderr == "", checked
print("Plist escaped strings, booleans, full-width integers and finite reals pass independent/native parsers in both modes")
