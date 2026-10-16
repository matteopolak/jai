#!/usr/bin/env python3
"""Independent resolved shared-library filename compiler/interpreter reduction."""

import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import tempfile

from build_developer_bindings import llvm_prefix

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    scratch = Path(tempfile.mkdtemp(prefix="resolved-library-path-", dir=target))
    compiler = target / "debug/jaic"
    prefix = llvm_prefix()
    library = scratch / (
        "libowned_resolved" + (".dylib" if platform.system() == "Darwin" else ".so")
    )
    native = (
        ROOT / "tests/developer-tools/compiler-requests/foreign-library-resolved-path.c"
    )
    source = scratch / "resolved-library-path.jai"
    source.write_text(
        '#import "Basic";\nlib :: #library,shared ' + json.dumps(str(library)) + ";\n"
        'value :: () -> s32 #foreign lib "original_resolved_value";\n'
        'main :: () { assert(value() == 42); print("ok\\n"); }\n'
    )
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    receipt = {
        "passed": False,
        "compiler_sha256": hashlib.sha256(compiler.read_bytes()).hexdigest(),
        "native_source_sha256": hashlib.sha256(native.read_bytes()).hexdigest(),
        "commands": [],
    }

    def run(command, expected=""):
        result = subprocess.run(
            [str(v) for v in command],
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=90,
        )
        passed = (
            result.returncode == 0 and result.stdout == expected and not result.stderr
        )
        receipt["commands"].append(
            {
                "command": [str(v) for v in command],
                "exit": result.returncode,
                "passed": passed,
                "diagnostic": result.stderr.splitlines()[:2],
            }
        )
        return passed

    flags = ["-dynamiclib"] if platform.system() == "Darwin" else ["-shared", "-fPIC"]
    built = run(
        [
            prefix / "bin/clang",
            "-std=c11",
            "-Wall",
            "-Wextra",
            "-Werror",
            *flags,
            native,
            "-o",
            library,
        ]
    )
    if built:
        run([compiler, source, "-interp"], "ok\n")
        for optimization in [0, 2]:
            executable = scratch / ("consumer-o" + str(optimization))
            if run([compiler, source, "-O" + str(optimization), "-exe", executable]):
                run([executable], "ok\n")
    receipt["passed"] = all(c["passed"] for c in receipt["commands"])
    (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print(
        "Resolved library path reduction "
        + ("PASS " if receipt["passed"] else "RED ")
        + str(scratch / "verification.json")
    )
    if not receipt["passed"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
