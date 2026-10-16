#!/usr/bin/env python3
"""Scoped current-source emission effects; independent native fixtures, private outputs."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import tempfile
import time

from build_developer_bindings import llvm_prefix

ROOT = Path(__file__).resolve().parents[1]
WORKFLOWS = {
    "bitfield-printers": ("bitfields", "bitfield_printers"),
    "linkage-emission": ("linkage", "linkage_emission"),
    "template-printing": ("templates", None),
    "enum-printers": ("enums", "enum_printers"),
    "signature-callback": ("signature", "signature_callback"),
    "canonical-printing": ("canonical", "canonical_printing"),
    "function-wrappers": ("wrappers", "function_wrappers"),
    "inline-type-printing": ("inline", None),
    "anonymous-bitfields": ("anonymous-bits", "anonymous_bitfields"),
    "canonical-driver": ("driver", None),
    "deep-emission": ("deep", None),
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workflows", nargs="*", choices=list(WORKFLOWS))
    args = parser.parse_args()
    if platform.system() != "Darwin":
        raise RuntimeError("These native consumers currently require macOS")
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    compiler = target / "debug/jaic"
    formatter = target / "jaifmt"
    linter = target / "debug/jailint"
    prefix = llvm_prefix()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    fixtures = ROOT / "tests/developer-tools"
    selected = args.workflows or list(WORKFLOWS)
    receipt_path = target / ("emission-workflows-" + str(time.time_ns()) + ".json")
    sources = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").glob("binding*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").glob("generator*.jai"))
    sources += list(
        (ROOT / "stdlib/internal/developer-tools/generator-session").glob("*.jai")
    )
    sources += list(
        (ROOT / "stdlib/internal/developer-tools/emission-state").glob("*.jai")
    )
    sources += [
        ROOT / "stdlib/internal/developer-tools/cpp-fragments.jai",
        ROOT / "stdlib/Pool/module.jai",
        ROOT / "stdlib/internal/allocation/pool.jai",
        Path(__file__),
    ]
    for name in selected:
        sources += list(fixtures.glob("bindings-" + name + "*"))

    def snapshot():
        return {
            str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(sources))
            if p.is_file()
        }

    before = snapshot()
    tool_hashes = {
        str(p): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in [compiler, formatter, linter, prefix / "bin/clang"]
    }
    receipt = {
        "workflows": selected,
        "sdk": str(prefix),
        "source_sha256": before,
        "tool_sha256": tool_hashes,
        "passed": False,
        "commands": [],
        "cross_target": "not run",
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
                "Scoped emission failure: " + (result.stderr or result.stdout)[:500]
            )

    try:
        for name in selected:
            stem, library = WORKFLOWS[name]
            scratch = Path(
                tempfile.mkdtemp(prefix="emission-" + name + "-", dir=target)
            )
            emitter = fixtures / ("bindings-" + name + ".jai")
            consumer = fixtures / ("bindings-" + name + "-roundtrip.jai")
            if name == "deep-emission":
                consumer = scratch / "deep-consumer.jai"
            generated = scratch / ("developer-tools-" + stem + "-generated.jai")
            for mode in ["interp", "0", "2"]:
                if mode == "interp":
                    run([compiler, emitter, "-interp", "--", scratch], "ok\n")
                else:
                    executable = scratch / ("emitter-o" + mode)
                    run([compiler, emitter, "-O" + mode, "-exe", executable])
                    run([executable, scratch], "ok\n")
                run([formatter, "--config", ROOT / "jaifmt.toml", generated])
                if name == "deep-emission":
                    run([formatter, "--config", ROOT / "jaifmt.toml", consumer])
                for optimization in [0, 2]:
                    if library:
                        run(
                            [
                                prefix / "bin/clang",
                                "-std=c11",
                                "-O" + str(optimization),
                                "-Wall",
                                "-Wextra",
                                "-Werror",
                                "-dynamiclib",
                                fixtures / ("bindings-" + name + "-native.c"),
                                "-o",
                                scratch / ("lib" + library + ".dylib"),
                            ]
                        )
                    run([compiler, consumer, "-interp", "-I", scratch], "ok\n")
                    executable = scratch / (
                        "consumer-" + mode + "-o" + str(optimization)
                    )
                    run(
                        [
                            compiler,
                            consumer,
                            "-O" + str(optimization),
                            "-I",
                            scratch,
                            "-exe",
                            executable,
                        ]
                    )
                    run([executable], "ok\n")
                    if name == "deep-emission":
                        cpp_binary = scratch / (
                            "cpp-consumer-" + mode + "-o" + str(optimization)
                        )
                        run(
                            [
                                prefix / "bin/clang++",
                                "-std=c++17",
                                "-O" + str(optimization),
                                "-Wall",
                                "-Wextra",
                                "-Werror",
                                scratch / "deep-consumer.cpp",
                                "-o",
                                cpp_binary,
                            ]
                        )
                        run([cpp_binary])
            run(
                [
                    formatter,
                    "--config",
                    ROOT / "jaifmt.toml",
                    "--check",
                    emitter,
                    consumer,
                    generated,
                ]
            )
            run([linter, "-D", "warnings", "-I", scratch, emitter, consumer, generated])
        run([linter, "-D", "warnings", ROOT / "stdlib/Bindings_Generator/module.jai"])
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = before == snapshot()
        receipt["tools_unchanged"] = all(
            hashlib.sha256(Path(p).read_bytes()).hexdigest() == digest
            for p, digest in tool_hashes.items()
        )
        if not receipt["source_unchanged"] or not receipt["tools_unchanged"]:
            receipt["passed"] = False
        receipt_path.write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError(
            "Shared generator sources changed during verification; rerun required"
        )
    print(
        "Scoped generated emission workflows passed interpreter/native Mac O0/O2; receipt: "
        + str(receipt_path)
    )


if __name__ == "__main__":
    main()
