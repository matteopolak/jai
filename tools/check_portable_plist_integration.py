#!/usr/bin/env python3
"""Validate real XML plist output with NEW formatting foundations and native tools."""
import os
from pathlib import Path
import platform
import shutil
import subprocess

from check_portable_stdlib import valid_bundle_plist

ROOT = Path(__file__).resolve().parents[1]
baseline = ROOT / "target/portable-integration-stdlib"
source = ROOT.parent / "foundations/stdlib"
target = ROOT / "target/plist-foundation-overlay"
assert baseline.is_dir() and source.is_dir()
shutil.copytree(baseline, target, dirs_exist_ok=True)
for path in ["Basic", "String", "File_Utilities", "internal/basic", "internal/string",
             "internal/files", "internal/basic-interface", "internal/basic-context", "internal/native-path"]:
    assert (source / path).is_dir(), path
    shutil.copytree(source / path, target / path, dirs_exist_ok=True)
env = dict(os.environ, JAIC_STDLIB=str(target))
compiler = ROOT / "target/compiler/debug/jaic"
fixture = ROOT / "tests/portable-stdlib/bundle-plist.jai"
executable = ROOT / "target/portable-tests/plist-foundations"
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
