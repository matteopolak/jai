#!/usr/bin/env python3
"""Original canonical-model effects, using this worktree's source-built tools."""
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"])
if not TARGET.is_absolute():
    TARGET = ROOT / TARGET
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
JAIC = TARGET / "debug/jaic"
OWNED = [
    "stdlib/Bindings_Generator/generator-state.jai",
    "stdlib/Bindings_Generator/model-helpers.jai",
    "stdlib/internal/developer-tools/generator-model-helpers.jai",
    "tests/developer-tools/generator-model-helpers.jai",
    "tests/developer-tools/generator-model-native.jai",
]
FIXTURES = [
    "generator-model-helpers", "generator-model-native",
    "bindings-tree", "bindings-equivalence",
]
evidence = []


def run(command, expected=None):
    result = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                            capture_output=True, text=True, timeout=60)
    evidence.append(dict(command=[str(x) for x in command], exit=result.returncode,
                         stdout=result.stdout, stderr=result.stderr))
    if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
        raise RuntimeError(json.dumps(evidence[-1], indent=2))


def main():
    try:
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", *OWNED])
        run([TARGET / "debug/jailint", "-D", "warnings", *OWNED])
        for name in FIXTURES:
            source = ROOT / f"tests/developer-tools/{name}.jai"
            run([JAIC, source, "-interp"], "ok\n")
            for optimization in [0, 2]:
                exe = TARGET / f"generator-model-{name}-O{optimization}"
                run([JAIC, source, f"-O{optimization}", "-exe", exe])
                run([exe], "ok\n")
        print("generator model: format, strict lint, 4 interpreter and 8 native executions passed")
    finally:
        (TARGET / "generator-model-evidence.json").write_text(json.dumps(evidence, indent=2) + "\n")


if __name__ == "__main__":
    main()
