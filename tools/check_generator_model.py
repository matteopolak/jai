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
    "stdlib/Bindings_Generator/module.jai",
    "stdlib/Bindings_Generator/generator-state.jai",
    "stdlib/Bindings_Generator/model-helpers.jai",
    "stdlib/internal/developer-tools/generator-model-helpers.jai",
    "stdlib/internal/developer-tools/generator-session/module.jai",
    "stdlib/internal/developer-tools/generator-session-access.jai",
    "stdlib/internal/developer-tools/generator-token-helpers.jai",
    "stdlib/internal/developer-tools/generator-reference-helpers.jai",
    "stdlib/internal/developer-tools/generator-canonical-construction.jai",
    "stdlib/internal/developer-tools/generator-model-lookup.jai",
    "stdlib/internal/developer-tools/generator-special-construction.jai",
    "stdlib/internal/developer-tools/binding-native-model.jai",
    "tests/developer-tools/generator-model-helpers.jai",
    "tests/developer-tools/generator-model-native.jai",
    "tests/developer-tools/generator-model-session.jai",
    "tests/developer-tools/generator-model-tokens.jai",
    "tests/developer-tools/generator-model-construction.jai",
    "tests/developer-tools/generator-model-objc.jai",
    "tests/developer-tools/generator-model-macros.jai",
    "tests/developer-tools/generator-model-cpp.jai",
    "tests/developer-tools/generator-model-typedefs.jai",
]
FIXTURES = [
    "generator-model-helpers", "generator-model-native",
    "generator-model-session", "generator-model-tokens",
    "generator-model-construction",
    "generator-model-objc", "generator-model-macros", "generator-model-cpp", "generator-model-typedefs", "bindings-macros",
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
    return result.stdout


def main():
    try:
        prefix = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
        layout = None
        for optimization in [0, 2]:
            probe = TARGET / f"generator-model-layout-O{optimization}"
            run([prefix / "bin/clang", "-std=c11", "-Wall", "-Wextra", "-Werror",
                 f"-O{optimization}", ROOT / "tests/developer-tools/generator-model-layout.c", "-o", probe])
            output = run([probe])
            if layout is not None and output != layout:
                raise RuntimeError("Original SDK layout oracle differs between O0/O2")
            layout = output
        oracle = TARGET / "generator-model-layout-oracle.jai"
        oracle.write_text(layout)
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", oracle])
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", oracle])
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", *OWNED])
        run([TARGET / "debug/jailint", "-D", "warnings", *OWNED])
        for os_name in ["windows", "linux"]:
            run([JAIC, ROOT / "tests/developer-tools/generator-model-helpers.jai",
                 "-check", "-os", os_name, "-cpu", "x64"])
        for name in FIXTURES:
            source = ROOT / f"tests/developer-tools/{name}.jai"
            run([JAIC, source, "-interp"], "ok\n")
            for optimization in [0, 2]:
                exe = TARGET / f"generator-model-{name}-O{optimization}"
                run([JAIC, source, f"-O{optimization}", "-exe", exe])
                run([exe], "ok\n")
        print(f"generator model: format, strict lint, 2 cross-target source checks, {len(FIXTURES)} interpreter and {2 * len(FIXTURES)} native executions passed")
    finally:
        (TARGET / "generator-model-evidence.json").write_text(json.dumps(evidence, indent=2) + "\n")


if __name__ == "__main__":
    main()
