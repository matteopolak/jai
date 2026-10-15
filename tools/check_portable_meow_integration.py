#!/usr/bin/env python3
"""Verify the existing own x64 Meow assertions with NEW foundation sources.

Only this checkout's target overlay is written. This focused staged composition
does not claim production/corpus integration and never runs a supplied binary.
"""
import os
from pathlib import Path
import platform
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
baseline = ROOT / "target/portable-integration-stdlib"
source = ROOT.parent / "foundations/stdlib"
target = ROOT / "target/meow-foundation-overlay"
assert baseline.is_dir() and source.is_dir()
if platform.system() == "Darwin":
    native_target = ["-target", "x86_64-apple-darwin", "-cpu", "x64"]
elif platform.system() == "Linux" and platform.machine().lower() in {"x86_64", "amd64"}:
    native_target = ["-cpu", "x64"]
else:
    raise RuntimeError("this focused legacy native-x64 check needs macOS x64 execution or Linux x64")
shutil.copytree(baseline, target, dirs_exist_ok=True)
for path in ["Basic", "String", "File_Utilities", "internal/basic", "internal/string",
             "internal/files", "internal/basic-interface", "internal/native-path"]:
    assert (source / path).is_dir(), path
    shutil.copytree(source / path, target / path, dirs_exist_ok=True)
env = dict(os.environ, JAIC_STDLIB=str(target))
compiler = ROOT / "target/compiler/debug/jaic"
fixture = ROOT / "tests/stdlib/meow-hash.jai"
executable = ROOT / "target/portable-tests/meow-existing-x64"
subprocess.run([str(compiler), *native_target, str(fixture), "-exe", str(executable)],
               cwd=ROOT, env=env, check=True, timeout=60)
for command in [[str(compiler), "-cpu", "x64", "-interp", str(fixture), "--"], [str(executable)]]:
    result = subprocess.run(command, cwd=ROOT, env=env, check=True,
                            text=True, capture_output=True, timeout=45)
    assert result.stdout == "ok\n" and result.stderr == "", result
print("Existing own Meow assertions passed interpreter/native x64 using NEW foundation overlay")
