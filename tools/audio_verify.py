#!/usr/bin/env python3
"""Verify this audio worker's explicit scope using its own source-built tools."""
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT / "target/compiler/debug/jaic"
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"),
           JAIC_NATIVE_LIBS=str(ROOT / "target/audio-native"))
CASES = sorted((ROOT / "tests/audio").glob("*.jai"))
OWNED = [ROOT / "stdlib/Sound_Player/module.jai"]
OWNED += sorted(p for p in (ROOT / "stdlib/internal/audio").glob("*.jai")
                if p.name != "wav.jai")
OWNED += CASES


def run(command, expected=None):
    result = subprocess.run(list(map(str, command)), cwd=ROOT, env=ENV,
                            capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
        raise RuntimeError(f"{command}: exit {result.returncode}\n{result.stdout}{result.stderr}")
    return result.stdout


def main():
    output = ROOT / "target/audio-tests"
    output.mkdir(parents=True, exist_ok=True)
    run([ROOT / "target/jaifmt", "--check", *OWNED])
    run([ROOT / "target/compiler/debug/jailint", "-D", "warnings", *OWNED])
    print("source-built jaifmt --check and warnings-denied jailint passed", flush=True)
    for case in CASES:
        run([COMPILER, case, "-interp"], "ok\n")
        for level in ("O0", "O2"):
            executable = output / f"{case.stem}-{level}"
            run([COMPILER, case, "-" + level, "-exe", executable], "")
            run([executable], "ok\n")
        for target_os in ("linux", "windows", "macos"):
            for cpu in ("x64", "arm64"):
                run([COMPILER, case, "-check", "-os", target_os, "-cpu", cpu], "")
        print(f"{case.name}: interpreter, native O0/O2 and six target checks passed", flush=True)


if __name__ == "__main__":
    main()
