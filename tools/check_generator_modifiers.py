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
    "stdlib/Bindings_Generator/module.jai",
    "stdlib/Bindings_Generator/active-context.jai",
    "stdlib/internal/developer-tools/generator-session/module.jai",
    "stdlib/Bindings_Generator/modifiers.jai",
    "stdlib/internal/developer-tools/generator-modifiers.jai",
    "tests/developer-tools/generator-modifiers.jai",
    "tests/developer-tools/generator-modifiers-targets.jai",
]
FIXTURES = [ROOT / path for path in OWNED[-2:]]
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
        linted = set()
        for index, fixture in enumerate(FIXTURES):
            checked = TARGET / f"generator-modifiers-linted-{index}.txt"
            run([TARGET / "debug/jailint", "-D", "warnings", "--checked-files", checked,
                 "--context", fixture, *OWNED[:-2], fixture])
            linted.update(checked.read_text().splitlines())
        for path in OWNED:
            if str(ROOT / path) not in linted:
                raise RuntimeError(f"strict lint omitted {path}")
        for os_name in ["windows", "linux"]:
            for cpu in ["x64", "arm64"]:
                for fixture in FIXTURES:
                    run([JAIC, fixture, "-check", "-os", os_name, "-cpu", cpu])
        for fixture in FIXTURES:
            run([JAIC, fixture, "-interp"], "ok\n")
            for optimization in [0, 2]:
                exe = TARGET / f"{fixture.stem}-O{optimization}"
                run([JAIC, fixture, f"-O{optimization}", "-exe", exe])
                run([exe], "ok\n")
        for name in ["generator-model-helpers", "generator-model-native"]:
            run([JAIC, ROOT / f"tests/developer-tools/{name}.jai", "-interp"], "ok\n")
        print("generator modifiers: format, strict contextual lint, 8 target source checks, 2 interpreter and 4 Mac native O0/O2 executions, 2 model interpreter regressions passed")
    finally:
        (TARGET / "generator-modifiers-evidence.json").write_text(
            json.dumps(EVIDENCE, indent=2) + "\n")


if __name__ == "__main__":
    main()
