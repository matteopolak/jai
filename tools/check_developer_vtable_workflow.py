#!/usr/bin/env python3
"""Canonical typed-vtable printing and actual C++ slot dispatch on Mac."""

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
    scratch = Path(tempfile.mkdtemp(prefix="vtable-workflow-", dir=target))
    compiler, formatter, linter = (
        target / "debug/jaic",
        target / "jaifmt",
        target / "debug/jailint",
    )
    clang = llvm_prefix() / "bin/clang++"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), TMPDIR=str(scratch))
    tests = ROOT / "tests/developer-tools"
    emitter = tests / "bindings-vtable-workflow.jai"
    fixture = tests / "bindings-vtable-workflow.cpp"
    header = tests / "bindings-vtable-workflow.hpp"
    consumer_source = tests / "bindings-vtable-roundtrip.jai"
    production = [
        ROOT / "stdlib/internal/developer-tools/binding-declaration-emission.jai",
        ROOT / "stdlib/Bindings_Generator/declaration-emission.jai",
    ]
    sources = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").rglob("*.jai"))
    sources += [emitter, fixture, header, consumer_source, Path(__file__)]

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
        "native_platform": "Mac64 scalar Itanium slots; no other ABI execution",
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
            raise RuntimeError("Vtable workflow failed; see " + str(scratch))

    try:
        generated = scratch / "generated-vtable.jai"
        run([compiler, emitter, "-interp", "--", generated], "ok\n")
        for optimization in [0, 2]:
            binary = scratch / ("emitter-o" + str(optimization))
            run([compiler, emitter, "-O" + str(optimization), "-exe", binary])
            run([binary, generated], "ok\n")
        consumer = scratch / consumer_source.name
        shutil.copyfile(consumer_source, consumer)
        (scratch / "vtable-options.jai").write_text(
            "expected_wrappers :: false;\nexpected_accessor :: false;\n"
        )
        run([formatter, "--config", ROOT / "jaifmt.toml", generated])
        for optimization in [0, 2]:
            run(
                [
                    clang,
                    "-std=c++17",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-O" + str(optimization),
                    "-dynamiclib",
                    fixture,
                    "-o",
                    scratch / "libdispatch.dylib",
                ]
            )
            run([compiler, consumer, "-interp"], "ok\n")
            binary = scratch / ("consumer-o" + str(optimization))
            run([compiler, consumer, "-O" + str(optimization), "-exe", binary])
            run([binary], "ok\n")
        # Each option independently controls its public output, with real calls.
        for wrappers, accessor in [
            (False, False),
            (True, False),
            (False, True),
            (True, True),
        ]:
            directory = scratch / ("options-" + str(int(wrappers)) + str(int(accessor)))
            directory.mkdir()
            output = directory / "generated-vtable.jai"
            consumer = directory / consumer_source.name
            shutil.copyfile(consumer_source, consumer)
            shutil.copyfile(
                scratch / "libdispatch.dylib", directory / "libdispatch.dylib"
            )
            w, a = str(wrappers).lower(), str(accessor).lower()
            (directory / "vtable-options.jai").write_text(
                "expected_wrappers :: " + w + ";\nexpected_accessor :: " + a + ";\n"
            )
            run([compiler, emitter, "-interp", "--", output, w, a], "ok\n")
            run([formatter, "--config", ROOT / "jaifmt.toml", output])
            run([compiler, consumer, "-interp"], "ok\n")
            for optimization in [0, 2]:
                binary = directory / ("consumer-o" + str(optimization))
                run([compiler, consumer, "-O" + str(optimization), "-exe", binary])
                run([binary], "ok\n")
            run([linter, "-D", "warnings", consumer, output])
            run([formatter, "--config", ROOT / "jaifmt.toml", "--check", output])
        run(
            [
                formatter,
                "--config",
                ROOT / "jaifmt.toml",
                "--check",
                emitter,
                consumer,
                generated,
                *production,
            ]
        )
        run([linter, "-D", "warnings", emitter, consumer, generated])
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
    print("Vtable workflow PASS " + str(scratch / "verification.json"))


if __name__ == "__main__":
    main()
