#!/usr/bin/env python3
"""Generate target-specific canonical bridges; verify Jai source and native objects."""

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
    scratch = Path(tempfile.mkdtemp(prefix="public-bridge-targets-", dir=target))
    prefix = llvm_prefix()
    clang = prefix / "bin/clang++"
    compiler = target / "debug/jaic"
    resource = subprocess.check_output(
        [str(clang), "-print-resource-dir"], text=True
    ).strip()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    tests = ROOT / "tests/developer-tools"
    paths = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    paths += list((ROOT / "stdlib/internal/developer-tools").rglob("*.jai"))
    paths += list(tests.glob("bindings-public-cpp-bridge*")) + [Path(__file__)]

    def snapshot():
        return {
            str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(paths))
            if p.is_file()
        }

    before = snapshot()
    receipt = {
        "passed": False,
        "native_execution": "not performed",
        "sdk": str(prefix),
        "source_sha256": before,
        "targets": [],
    }
    try:
        for label, triple, os_name, cpu, format_name in [
            ("windows-x64", "x86_64-pc-windows-msvc", "windows", "x64", "COFF-x86-64"),
            (
                "linux-arm64",
                "aarch64-unknown-linux-gnu",
                "linux",
                "arm64",
                "elf64-littleaarch64",
            ),
        ]:
            output = scratch / label
            output.mkdir()
            row = {"target": triple, "commands": []}
            receipt["targets"].append(row)

            def run(command, expected=""):
                result = subprocess.run(
                    [str(v) for v in command],
                    cwd=ROOT,
                    env=env,
                    capture_output=True,
                    text=True,
                    timeout=90,
                )
                valid = expected is None or result.stdout == expected
                row["commands"].append(
                    {
                        "command": [str(v) for v in command],
                        "exit": result.returncode,
                        "stdout_match": valid,
                        "stderr_empty": not result.stderr,
                    }
                )
                if result.returncode or not valid or result.stderr:
                    raise RuntimeError(
                        "Target bridge failure: "
                        + (result.stderr or result.stdout)[:500]
                    )
                return result.stdout

            # Host execution calls the configured host libclang with an explicit
            # target argument; no target foreign procedure is executed on host.
            run(
                [
                    compiler,
                    tests / "bindings-public-cpp-bridge.jai",
                    "-interp",
                    "--",
                    output,
                    "-resource-dir",
                    resource,
                    "-target",
                    triple,
                ],
                "ok\n",
            )
            run(
                [
                    compiler,
                    tests / "bindings-public-cpp-bridge-roundtrip.jai",
                    "-check",
                    "-I",
                    output,
                    "-os",
                    os_name,
                    "-cpu",
                    cpu,
                ]
            )
            for optimization in [0, 2]:
                object_path = output / ("consumer-o" + str(optimization) + ".o")
                run(
                    [
                        clang,
                        "--target=" + triple,
                        "-resource-dir",
                        resource,
                        "-std=c++17",
                        "-O" + str(optimization),
                        "-Wall",
                        "-Wextra",
                        "-Werror",
                        "-I",
                        output,
                        "-c",
                        tests / "bindings-public-cpp-bridge-consumer.cpp",
                        "-o",
                        object_path,
                    ]
                )
                headers = run(
                    [prefix / "bin/llvm-readobj", "--file-headers", object_path], None
                )
                if "Format: " + format_name not in headers:
                    raise RuntimeError(
                        "Target object format does not match requested machine"
                    )
                row.setdefault("objects", []).append(
                    {
                        "optimization": optimization,
                        "sha256": hashlib.sha256(object_path.read_bytes()).hexdigest(),
                        "format": format_name,
                    }
                )
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = before == snapshot()
        if not receipt["source_unchanged"]:
            receipt["passed"] = False
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError("Shared source drift invalidated target bridge receipt")
    print(
        "Target-specific Jai source/native object checks passed; receipt: "
        + str(scratch / "verification.json")
    )


if __name__ == "__main__":
    main()
