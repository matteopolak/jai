#!/usr/bin/env python3
"""Execute public enum printers and generated bindings against an original C API."""
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess

from build_developer_bindings import llvm_prefix

ROOT = Path(__file__).resolve().parents[1]


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("Enum native verification currently requires macOS")
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    scratch = target / "enum-printers"
    scratch.mkdir(parents=True, exist_ok=True)
    compiler = target / "debug/jaic"
    formatter = target / "jaifmt"
    linter = target / "debug/jailint"
    sdk = llvm_prefix()
    fixtures = ROOT / "tests/developer-tools"
    emitter = fixtures / "bindings-enum-printers.jai"
    consumer = fixtures / "bindings-enum-printers-roundtrip.jai"
    native = fixtures / "bindings-enum-printers-native.c"
    generated = scratch / "developer-tools-enums-generated.jai"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    paths = list((ROOT / "stdlib/Bindings_Generator").glob("*.jai"))
    paths += list((ROOT / "stdlib/internal/developer-tools").glob("*.jai"))
    paths += [emitter, consumer, native]

    def snapshot():
        return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                for p in sorted(paths)}

    before = snapshot()
    receipt = {"sdk": str(sdk), "source_sha256": before, "commands": [],
               "passed": False, "native_platform": "macOS", "cross_target": "not run"}

    def run(command, expected=""):
        result = subprocess.run([str(p) for p in command], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=90)
        receipt["commands"].append({"command": [str(p) for p in command],
                                    "exit": result.returncode,
                                    "expected_stdout": result.stdout == expected,
                                    "empty_stderr": not result.stderr})
        if result.returncode or result.stdout != expected or result.stderr:
            raise RuntimeError("Enum workflow failed: " + (result.stderr or result.stdout)[:400])

    try:
        for mode in ["interp", "0", "2"]:
            if mode == "interp":
                run([compiler, emitter, "-interp", "--", scratch], "ok\n")
            else:
                executable = scratch / ("emitter-o" + mode)
                run([compiler, emitter, "-O" + mode, "-exe", executable])
                run([executable, scratch], "ok\n")
            run([formatter, "--config", ROOT / "jaifmt.toml", generated])
            for optimization in [0, 2]:
                run([sdk / "bin/clang", "-std=c11", "-O" + str(optimization),
                     "-Wall", "-Wextra", "-Werror", "-dynamiclib", native,
                     "-o", scratch / "libenum_printers.dylib"])
                run([compiler, consumer, "-interp", "-I", scratch], "ok\n")
                executable = scratch / ("consumer-" + mode + "-o" + str(optimization))
                run([compiler, consumer, "-O" + str(optimization), "-I", scratch,
                     "-exe", executable])
                run([executable], "ok\n")
        run([formatter, "--config", ROOT / "jaifmt.toml", "--check", emitter, consumer, generated])
        run([linter, "-D", "warnings", "-I", scratch, emitter, consumer])
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = before == snapshot()
        if not receipt["source_unchanged"]:
            receipt["passed"] = False
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError("Shared sources changed during enum checks; rerun required")
    print("Enum printers and generated native C enum/default calls passed interpreter/Mac O0/O2")


if __name__ == "__main__":
    main()
