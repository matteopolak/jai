#!/usr/bin/env python3
"""Public generate_bridge through canonical loading/modeling and real C++ consumers."""

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
    scratch = Path(tempfile.mkdtemp(prefix="canonical-bridge-driver-", dir=target))
    prefix = llvm_prefix()
    compiler, formatter, linter = (
        target / "debug/jaic",
        target / "jaifmt",
        target / "debug/jailint",
    )
    clang = prefix / "bin/clang++"
    resource = subprocess.check_output(
        [str(clang), "-print-resource-dir"], text=True
    ).strip()
    tests = ROOT / "tests/developer-tools"
    emitter = tests / "bindings-canonical-bridge.jai"
    normalizer = tests / "bindings-options-normalization.jai"
    sources = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").rglob("*.jai"))
    sources += list(tests.glob("bindings-canonical-bridge*")) + [Path(__file__)]
    sources += [normalizer]
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
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    receipt = {
        "passed": False,
        "source_sha256": before,
        "compiler_sha256": hashlib.sha256(compiler.read_bytes()).hexdigest(),
        "commands": [],
        "native_platform": "Mac host",
        "other_native": "not executed",
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
        receipt["commands"].append(
            {
                "command": [str(v) for v in command],
                "exit": result.returncode,
                "stdout_match": result.stdout == expected,
                "stderr_empty": not result.stderr,
            }
        )
        if result.returncode or result.stdout != expected or result.stderr:
            raise RuntimeError(
                "Canonical bridge failure: " + (result.stderr or result.stdout)[:400]
            )

    def provider(optimization):
        run(
            [
                clang,
                "-std=c++17",
                "-O" + str(optimization),
                "-Wall",
                "-Wextra",
                "-Werror",
                "-dynamiclib",
                tests / "bindings-canonical-bridge-native.cpp",
                "-o",
                scratch / "libdriver_cpp.dylib",
            ]
        )

    try:
        for mode in ["interp", "0", "2"]:
            provider(0)
            if mode == "interp":
                run([compiler, normalizer, "-interp"], "ok\n")
                run([compiler, emitter, "-interp", "--", scratch, resource], "ok\n")
            else:
                normalized_binary = scratch / ("normalizer-o" + mode)
                run([compiler, normalizer, "-O" + mode, "-exe", normalized_binary])
                run([normalized_binary], "ok\n")
                binary = scratch / ("emitter-o" + mode)
                run([compiler, emitter, "-O" + mode, "-exe", binary])
                run([binary, scratch, resource], "ok\n")
            for optimization in [0, 2]:
                provider(optimization)
                binary = scratch / ("consumer-" + mode + "-o" + str(optimization))
                run(
                    [
                        clang,
                        "-std=c++17",
                        "-O" + str(optimization),
                        "-Wall",
                        "-Wextra",
                        "-Werror",
                        "-I",
                        scratch,
                        tests / "bindings-canonical-bridge-consumer.cpp",
                        "-L",
                        scratch,
                        "-ldriver_cpp",
                        "-o",
                        binary,
                    ]
                )
                run([binary])
        run(
            [
                formatter,
                "--config",
                ROOT / "jaifmt.toml",
                "--check",
                emitter,
                normalizer,
            ]
        )
        run(
            [
                linter,
                "-D",
                "warnings",
                emitter,
                normalizer,
                ROOT / "stdlib/Bindings_Generator/module.jai",
            ]
        )
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = before == snapshot()
        if not receipt["source_unchanged"]:
            receipt["passed"] = False
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError("Source drift invalidated canonical bridge verification")
    print(
        "Canonical public bridge passed; receipt: " + str(scratch / "verification.json")
    )


if __name__ == "__main__":
    main()
