#!/usr/bin/env python3
"""Stage the owned audio facade using Basic(ENABLE_ASSERT=false).

Only a producer-owned test copy is changed. The remaining NEW modules resolve
from the worktree, and no production or peer source is edited.
"""
import os
import re
import shutil
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def stage_audio():
    # The compiler correctly restricts internal imports to stdlib-origin files.
    # Stage this NEW dependency inside our owned audio subtree, not a peer tree.
    modules = ROOT / "stdlib/Sound_Player/test-stage"
    shutil.rmtree(modules, ignore_errors=True)
    facade = modules / "Sound_Player/module.jai"
    facade.parent.mkdir(parents=True, exist_ok=True)
    original = ROOT / "stdlib/Sound_Player/module.jai"
    source = original.read_text()
    if source.count('#import "Basic";') != 1:
        raise RuntimeError("Audio Basic import changed; review staging")
    source = source.replace('#import "Basic";', '#import "Basic"(ENABLE_ASSERT = false);')
    source = re.sub(r'#load "([^"]+)"',
                    lambda m: '#load "' + str((original.parent / m[1]).resolve()) + '"', source)
    facade.write_text(source)
    return modules


def main():
    out = ROOT / "target/audio-no-assert"
    modules = stage_audio()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"),
               JAIC_NATIVE_LIBS=str(ROOT / "target/audio-native"))
    compiler = ROOT / "target/compiler/debug/jaic"
    fixture = ROOT / "tests/audio/assertion-independent.jai"
    out.mkdir(parents=True, exist_ok=True)
    base = [str(compiler), str(fixture), "-import_dir", str(modules)]

    def run(command):
        result = subprocess.run(list(map(str, command)), env=env, cwd=ROOT / "tests/audio",
                                capture_output=True, text=True, timeout=60)
        if result.returncode or result.stderr or result.stdout != "ok\n":
            raise RuntimeError(f"disabled-assert regression failed: exit {result.returncode}; "
                               + result.stderr[:1200])

    run([*base, "-interp"])
    for optimization in ("-O0", "-O2"):
        executable = out / ("assertion-independent" + optimization + (".exe" if os.name == "nt" else ""))
        build = subprocess.run([*base, optimization, "-exe", str(executable)], env=env,
                               capture_output=True, text=True, timeout=60)
        if build.returncode or build.stderr:
            raise RuntimeError(f"disabled-assert build failed: {build.stderr[:1200]}")
        run([executable])
    for osname in ("macos", "windows", "linux"):
        for cpu in ("x64", "arm64"):
            build = subprocess.run([*base, "-check", "-os", osname, "-cpu", cpu], env=env,
                                   capture_output=True, text=True, timeout=60)
            if build.returncode or build.stderr:
                raise RuntimeError(f"disabled-assert {osname}/{cpu} source check failed: {build.stderr[:1200]}")
    print("disabled-assert audio regression: interpreter/native O0/O2 passed")


if __name__ == "__main__":
    try:
        main()
    finally:
        shutil.rmtree(ROOT / "stdlib/Sound_Player/test-stage", ignore_errors=True)
