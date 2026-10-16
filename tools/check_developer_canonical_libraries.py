#!/usr/bin/env python3
"""Canonical multi-library generation and actual linked original C consumers."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

from build_developer_bindings import llvm_prefix

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    scratch = Path(tempfile.mkdtemp(prefix="canonical-libraries-", dir=target))
    prefix = llvm_prefix()
    compiler = target / "debug/jaic"
    formatter = target / "jaifmt"
    linter = target / "debug/jailint"
    tests = ROOT / "tests/developer-tools"
    # Exact copies of these NEW test inputs keep the oracle's relative logical
    # libraries beside the consumers. Production always uses the shared stdlib.
    inputs = [
        tests / name
        for name in [
            "bindings-canonical-libraries.jai",
            "bindings-canonical-libraries-roundtrip.jai",
            "bindings-canonical-libraries.h",
            "bindings-configured-sdk-version.jai",
        ]
    ]
    for source in inputs:
        (scratch / source.name).write_bytes(source.read_bytes())
    emitter = scratch / inputs[0].name
    consumer = scratch / inputs[1].name
    version_test = scratch / inputs[3].name
    clang = prefix / "bin/clang"
    version = subprocess.check_output([str(clang), "-dumpversion"], text=True).strip()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    for name in ["LIBRARY_PATH", "DYLD_LIBRARY_PATH"]:
        env[name] = str(scratch) + (":" + env[name] if env.get(name) else "")
    sources = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").rglob("*.jai"))
    sources += list(tests.glob("bindings-canonical-libraries*"))
    sources += [Path(__file__), inputs[3]]
    sources += [
        ROOT / "stdlib/Pool/module.jai",
        ROOT / "stdlib/internal/allocation/pool.jai",
    ]

    def snapshot():
        return {
            str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(sources))
            if p.is_file()
        }

    before = snapshot()
    receipt = {
        "passed": False,
        "source_sha256": before,
        "tool_sha256": {
            str(p): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in [compiler, formatter, linter, clang, prefix / "bin/llvm-ar"]
        },
        "configured_sdk_version": version,
        "staged_test_input_sha256": {
            p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs
        },
        "commands": [],
        "native_platform": "Mac host",
        "other_native": "not executed",
    }

    def run(command, expected="", negative=False):
        result = subprocess.run(
            [str(v) for v in command],
            cwd=scratch,
            env=env,
            capture_output=True,
            text=True,
            timeout=90,
        )
        matched = (
            result.returncode != 0
            and "configured LLVM/libclang version mismatch" in result.stderr
            if negative
            else result.returncode == 0
            and result.stdout == expected
            and not result.stderr
        )
        receipt["commands"].append(
            {
                "command": [str(v) for v in command],
                "exit": result.returncode,
                "expected_failure": negative,
                "passed": matched,
            }
        )
        if not matched:
            raise RuntimeError(
                "Canonical library failure: " + (result.stderr or result.stdout)[:450]
            )

    try:
        native = tests / "bindings-canonical-libraries-native.c"
        for name, symbol, value in [
            ("primary", "primary_value", 42),
            ("static", "static_value", 17),
            ("system", "system_value", 3),
        ]:
            flags = [
                "-std=c11",
                "-Wall",
                "-Wextra",
                "-Werror",
                "-DLIBRARY_SYMBOL=" + symbol,
                "-DLIBRARY_VALUE=" + str(value),
            ]
            if name == "static":
                obj = scratch / "provider.o"
                run([clang, *flags, "-c", native, "-o", obj])
                run(
                    [prefix / "bin/llvm-ar", "rcs", scratch / "libdriver_static.a", obj]
                )
            else:
                run(
                    [
                        clang,
                        *flags,
                        "-dynamiclib",
                        native,
                        "-o",
                        scratch / ("libdriver_" + name + ".dylib"),
                    ]
                )
        run([compiler, version_test, "-interp", "--", version], "ok\n")
        run([compiler, version_test, "-interp", "--", "0.0.0"], negative=True)
        for mode in ["interp", "0", "2"]:
            if mode == "interp":
                run([compiler, emitter, "-interp", "--", scratch], "ok\n")
            else:
                binary = scratch / ("emitter-o" + mode)
                run([compiler, emitter, "-O" + mode, "-exe", binary])
                run([binary, scratch], "ok\n")
            for optimization in [0, 2]:
                binary = scratch / ("consumer-" + mode + "-o" + str(optimization))
                run(
                    [
                        compiler,
                        consumer,
                        "-O" + str(optimization),
                        "-I",
                        scratch,
                        "-exe",
                        binary,
                    ]
                )
                run([binary], "ok\n")
        generated = scratch / "developer-tools-libraries-generated.jai"
        run([formatter, "--config", ROOT / "jaifmt.toml", generated])
        run(
            [
                formatter,
                "--config",
                ROOT / "jaifmt.toml",
                "--check",
                emitter,
                consumer,
                version_test,
                generated,
            ]
        )
        run(
            [
                linter,
                "-D",
                "warnings",
                "-I",
                scratch,
                emitter,
                consumer,
                generated,
                version_test,
                ROOT / "stdlib/Bindings_Generator/module.jai",
            ]
        )
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = before == snapshot()
        receipt["passed"] &= receipt["source_unchanged"]
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError("Source drift invalidated verification")
    print(
        "Canonical library workflow passed; receipt: "
        + str(scratch / "verification.json")
    )


if __name__ == "__main__":
    main()
