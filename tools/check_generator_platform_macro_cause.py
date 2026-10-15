#!/usr/bin/env python3
"""Preserve the failing combined gate while verifying its independent reduced cause."""
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
PREFIX = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))


def run(command, code=0, output=None):
    result = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                            text=True, capture_output=True, timeout=60)
    if result.returncode != code or result.stderr or (output is not None and result.stdout != output):
        raise RuntimeError(f"{command}: status={result.returncode}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def main():
    source = ROOT / "tests/developer-tools/generator-platform-macro-cause.jai"
    run([ROOT / "target/jaifmt", "--config", ROOT / "jaifmt.toml", "--check", source])
    run([ROOT / "target/debug/jailint", "-D", "warnings", source])
    expected = "expressions=3 evaluations=0 diagnostics=0\ncallback-specific=false callback-generic=true\n"
    run([ROOT / "target/debug/jaic", source, "-interp"], 1, expected)
    oracle = "expression=100 type=101 evaluated=0\nexpression=111 type=112 evaluated=0\nexpression=109 type=112 evaluated=0\nexpressions=3 evaluations=0 diagnostics=0\n"
    for optimization in [0, 2]:
        native = ROOT / f"target/generator-platform-macro-cause-c-o{optimization}"
        run([PREFIX / "bin/clang", "-std=c11", f"-O{optimization}", "-Wall", "-Wextra", "-Werror",
             "-I", PREFIX / "include", ROOT / "tests/developer-tools/generator-platform-macro-cause.c",
             "-L", PREFIX / "lib", f"-Wl,-rpath,{PREFIX / 'lib'}", "-lclang", "-o", native])
        run([native], output=oracle)
        executable = ROOT / f"target/generator-platform-macro-cause-o{optimization}"
        run([ROOT / "target/debug/jaic", source, f"-O{optimization}", "-exe", executable], output="")
        run([executable], 1, expected)
    evidence = {"scope": "independent diagnostic regression reduction, not a repaired combined gate",
                "sdk_oracle": oracle.splitlines(), "jai_reproducer": expected.splitlines(),
                "diagnostic_reproducer_exit": 1,
                "modes": ["interpreter", "Mac native O0", "Mac native O2"],
                "owner": "stdlib-tools callback-model materialization",
                "cause": "find_probe_expression selects first nonvoid expression; SDK returns null evaluation; model_numeric_macro sets failed without specific diagnostic; outer materializer reports only generic error"}
    (ROOT / "docs/native/generator-platform-macro-cause.json").write_text(json.dumps(evidence, indent=2) + "\n")
    print("Verified native SDK/FFI facts and reproduced the unresolved callback diagnostic failure at exit 1; combined gate unchanged")


if __name__ == "__main__":
    main()
