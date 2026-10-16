#!/usr/bin/env python3
"""Actual typed Objective-C receiver/selector calls through generated Jai wrappers."""

import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

from build_developer_bindings import llvm_prefix

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    scratch = Path(tempfile.mkdtemp(prefix="objc-workflow-", dir=target))
    compiler, formatter, linter = (
        target / "debug/jaic",
        target / "jaifmt",
        target / "debug/jailint",
    )
    clang = llvm_prefix() / "bin/clang"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), TMPDIR=str(scratch))
    tests = ROOT / "tests/developer-tools"
    emitter = tests / "bindings-objc-wrapper.jai"
    fixture = tests / "bindings-objc-native.c"
    consumer_source = tests / "bindings-objc-roundtrip.jai"
    production = [
        ROOT / "stdlib/internal/developer-tools/binding-declaration-emission.jai",
        ROOT / "stdlib/Bindings_Generator/declaration-emission.jai",
    ]
    sources = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").rglob("*.jai"))
    sources += [emitter, fixture, consumer_source, Path(__file__)]

    def snapshot():
        return {
            str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(sources))
        }

    before = snapshot()
    receipt = {
        "passed": False,
        "source_sha256": before,
        "commands": [],
        "compiler_sha256": hashlib.sha256(compiler.read_bytes()).hexdigest(),
        "native_platform": "Mac scalar instance/class calls; receiver explicitly represented",
        "not_claimed": "Canonical implicit receiver, variadic calls, universal Apple return ABI",
    }

    def run(command, expected=""):
        result = subprocess.run(
            [str(v) for v in command],
            cwd=scratch,
            env=env,
            capture_output=True,
            text=True,
            timeout=90,
        )
        passed = (
            result.returncode == 0 and result.stdout == expected and not result.stderr
        )
        index = len(receipt["commands"])
        (scratch / (str(index) + ".stdout.txt")).write_text(result.stdout)
        (scratch / (str(index) + ".stderr.txt")).write_text(result.stderr)
        receipt["commands"].append(
            {
                "command": [str(v) for v in command],
                "exit": result.returncode,
                "passed": passed,
                "first_diagnostic": result.stderr.splitlines()[:1],
            }
        )
        if not passed:
            raise RuntimeError("ObjC workflow failed; see " + str(scratch))

    try:
        generated = scratch / "generated-objc.jai"
        variants = scratch / "generated-return-variants.jai"
        run([compiler, emitter, "-interp", "--", generated, variants], "ok\n")
        for optimization in [0, 2]:
            binary = scratch / ("emitter-o" + str(optimization))
            run([compiler, emitter, "-O" + str(optimization), "-exe", binary])
            run([binary, generated, variants], "ok\n")
        consumer = scratch / consumer_source.name
        shutil.copyfile(consumer_source, consumer)
        run([formatter, "--config", ROOT / "jaifmt.toml", generated, variants])
        # These encode reviewed selection, not native return ABI on every CPU.
        run([compiler, variants, "-check"])
        for optimization in [0, 2]:
            run(
                [
                    clang,
                    "-std=c11",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-O" + str(optimization),
                    "-dynamiclib",
                    fixture,
                    "-lobjc",
                    "-o",
                    scratch / "libindependent_objc.dylib",
                ]
            )
            run([compiler, consumer, "-interp"], "ok\n")
            binary = scratch / ("consumer-o" + str(optimization))
            run([compiler, consumer, "-O" + str(optimization), "-exe", binary])
            run([binary], "ok\n")
        run(
            [
                formatter,
                "--config",
                ROOT / "jaifmt.toml",
                "--check",
                emitter,
                consumer,
                generated,
                variants,
                *production,
            ]
        )
        run([linter, "-D", "warnings", emitter, consumer, generated, variants])
        for source in production:
            run(
                [
                    linter,
                    "-D",
                    "warnings",
                    ROOT / "stdlib/Bindings_Generator/module.jai",
                    source,
                ]
            )
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = snapshot() == before
        receipt["passed"] &= receipt["source_unchanged"]
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["passed"]:
        raise RuntimeError("Source changed during verification: " + str(scratch))
    print("ObjC workflow PASS " + str(scratch / "verification.json"))


if __name__ == "__main__":
    main()
