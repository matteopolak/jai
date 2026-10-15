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
    "stdlib/internal/developer-tools/generator-record-metadata.jai",
    "stdlib/internal/developer-tools/generator-lifecycle.jai",
    "stdlib/internal/developer-tools/generator-macro-evaluation.jai",
    "stdlib/internal/developer-tools/generator-array-construction.jai",
    "stdlib/internal/developer-tools/generator-special-construction.jai",
    "stdlib/internal/developer-tools/generator-aggregate-construction.jai",
    "stdlib/internal/developer-tools/generator-template-construction.jai",
    "stdlib/internal/developer-tools/generator-native-string.jai",
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
    "tests/developer-tools/generator-model-aggregates.jai",
    "tests/developer-tools/generator-model-record-edges.jai",
    "tests/developer-tools/generator-model-templates.jai",
    "tests/developer-tools/generator-model-literals.jai",
    "tests/developer-tools/generator-model-vtables.jai",
    "tests/developer-tools/generator-model-virtual-conversion.jai",
    "tests/developer-tools/generator-model-lifecycle.jai",
    "tests/developer-tools/generator-model-arrays.jai",
]
FIXTURES = [
    "generator-model-helpers", "generator-model-native",
    "generator-model-session", "generator-model-tokens",
    "generator-model-construction",
    "generator-model-objc", "generator-model-macros", "generator-model-cpp", "generator-model-typedefs", "generator-model-aggregates", "generator-model-record-edges", "generator-model-templates", "generator-model-literals", "generator-model-virtual-conversion", "generator-model-lifecycle",
    "bindings-tree", "bindings-equivalence", "generator-model-vtables", "generator-model-arrays",
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
    evidence.clear()
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
        template_layout = None
        for optimization in [0, 2]:
            probe = TARGET / f"generator-model-template-layout-O{optimization}"
            run([prefix / "bin/clang++", "-std=c++17", "-fblocks", "-Wall", "-Wextra", "-Werror",
                 f"-O{optimization}", ROOT / "tests/developer-tools/generator-model-template-layout.cpp", "-o", probe])
            output = run([probe])
            if template_layout is not None and output != template_layout:
                raise RuntimeError("Original SDK template layout oracle differs between O0/O2")
            template_layout = output
        template_oracle = TARGET / "generator-model-template-layout-oracle.jai"
        template_oracle.write_text(template_layout)
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", template_oracle])
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", template_oracle])
        vtable_layout = None
        for optimization in [0, 2]:
            probe = TARGET / f"generator-model-vtable-layout-O{optimization}"
            run([prefix / "bin/clang++", "-std=c++17", "-Wall", "-Wextra", "-Werror",
                 f"-O{optimization}", ROOT / "tests/developer-tools/generator-model-vtable-layout.cpp", "-o", probe])
            output = run([probe])
            if vtable_layout is not None and output != vtable_layout:
                raise RuntimeError("Original SDK vtable oracle differs between O0/O2")
            vtable_layout = output
        vtable_oracle = TARGET / "generator-model-vtable-layout-oracle.jai"
        vtable_oracle.write_text(vtable_layout)
        for optimization in [0, 2]:
            probe = TARGET / f"generator-model-arrays-sdk-O{optimization}"
            run([prefix / "bin/clang++", "-std=c++17", "-Wall", "-Wextra", "-Werror",
                 f"-O{optimization}", ROOT / "tests/developer-tools/generator-model-arrays-sdk.cpp", "-o", probe])
            run([probe], "ok\n")
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", vtable_oracle])
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", vtable_oracle])
        run([TARGET / "jaifmt", "--config", "jaifmt.toml", "--check", *OWNED])
        run([TARGET / "debug/jailint", "-D", "warnings", "--manifest", TARGET / "generator-model-lint.json", "--checked-files", TARGET / "generator-model-lint.files", "-I", TARGET, *OWNED])
        for os_name in ["windows", "linux"]:
            run([JAIC, ROOT / "tests/developer-tools/generator-model-helpers.jai",
                 "-check", "-os", os_name, "-cpu", "x64", "-I", TARGET])
        for name in FIXTURES:
            source = ROOT / f"tests/developer-tools/{name}.jai"
            run([JAIC, source, "-interp", "-I", TARGET], "ok\n")
            for optimization in [0, 2]:
                exe = TARGET / f"generator-model-{name}-O{optimization}"
                run([JAIC, source, f"-O{optimization}", "-exe", exe, "-I", TARGET])
                run([exe], "ok\n")
        print(f"generator model: format, strict lint, 2 cross-target source checks, {len(FIXTURES)} interpreter and {2 * len(FIXTURES)} native executions passed")
    finally:
        (TARGET / "generator-model-evidence.json").write_text(json.dumps(evidence, indent=2) + "\n")


if __name__ == "__main__":
    main()
