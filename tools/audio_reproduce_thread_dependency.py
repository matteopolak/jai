#!/usr/bin/env python3
"""Reproduce NEW Thread's disabled-assert dependency defect, without peer edits.

The command returns failure while the defect is present; it is not an audio pass.
"""
import os
import shutil
import subprocess
from audio_verify_no_assert import ROOT


def main():
    modules = ROOT / "stdlib/Sound_Player/thread-test-stage"
    facade = modules / "Basic/module.jai"
    facade.parent.mkdir(parents=True, exist_ok=True)
    source = (ROOT / "stdlib/Basic/module.jai").read_text()
    if source.count("ENABLE_ASSERT := true") != 1:
        raise RuntimeError("Review NEW Basic parameter before staging")
    facade.write_text(source.replace("ENABLE_ASSERT := true", "ENABLE_ASSERT := false"))
    compiler = ROOT / "target/compiler/debug/jaic"
    fixture = ROOT / "tests/audio/dependencies/thread-no-assert.jai"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    baseline = subprocess.run([str(compiler), str(fixture), "-interp"], env=env,
                              capture_output=True, text=True, timeout=30)
    if baseline.returncode or baseline.stderr or baseline.stdout != "semaphore-after-init-signal: SUCCESS\n":
        raise RuntimeError("Enabled Thread baseline failed; classify independently")
    result = subprocess.run([str(compiler), str(fixture), "-interp", "-import_dir", str(modules)],
                            env=env, capture_output=True, text=True, timeout=30)
    print("Thread assertions enabled: SUCCESS; disabled-assert actual follows", flush=True)
    print(result.stdout.strip(), flush=True)
    if result.stderr:
        raise RuntimeError("Dependency regression produced compiler/runtime diagnostics; review locally")
    return result.returncode


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    finally:
        shutil.rmtree(ROOT / "stdlib/Sound_Player/thread-test-stage", ignore_errors=True)
