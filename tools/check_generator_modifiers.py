#!/usr/bin/env python3
"""Verify owned modifier helpers with this checkout's source-built T7 tools."""
import json
import os
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), TMPDIR=str(TARGET))
JAIC = TARGET / "debug/jaic"
OWNED = [
    "stdlib/Bindings_Generator/modifiers.jai",
    "stdlib/internal/developer-tools/generator-modifiers.jai",
    "tests/developer-tools/generator-modifiers.jai",
]
FIXTURE = ROOT / OWNED[-1]
EVIDENCE = []


def run(command, expected=None):
    result = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                            capture_output=True, text=True, timeout=60)
    EVIDENCE.append(dict(command=[str(x) for x in command], exit=result.returncode,
                         stdout=result.stdout, stderr=result.stderr))
    if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
        raise RuntimeError(json.dumps(EVIDENCE[-1], indent=2))


def main():
    try:
        if platform.system() != "Darwin":
            raise RuntimeError("Mac native evidence requires a Darwin host")
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", *OWNED])
        checked = TARGET / "generator-modifiers-linted.txt"
        run([TARGET / "debug/jailint", "-D", "warnings", "--checked-files", checked,
             *OWNED])
        linted = checked.read_text().splitlines()
        for path in OWNED:
            if str(ROOT / path) not in linted:
                raise RuntimeError(f"strict lint omitted {path}")
        for os_name in ["windows", "linux"]:
            for cpu in ["x64", "arm64"]:
                run([JAIC, FIXTURE, "-check", "-os", os_name, "-cpu", cpu])
        run([JAIC, FIXTURE, "-interp"], "ok\n")
        for optimization in [0, 2]:
            exe = TARGET / f"generator-modifiers-O{optimization}"
            run([JAIC, FIXTURE, f"-O{optimization}", "-exe", exe])
            run([exe], "ok\n")
        print("generator modifiers: format, strict lint, 4 target source checks, interpreter and Mac native O0/O2 passed")
    finally:
        (TARGET / "generator-modifiers-evidence.json").write_text(
            json.dumps(EVIDENCE, indent=2) + "\n")


if __name__ == "__main__":
    main()
