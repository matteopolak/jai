#!/usr/bin/env python3
"""Reviewed aggregate emission, real SDK consumers, private shared-tree outputs."""
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
        raise RuntimeError("This native verification currently requires macOS")
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    scratch = target / "aggregate"
    scratch.mkdir(parents=True, exist_ok=True)
    compiler = target / "debug/jaic"
    formatter = target / "jaifmt"
    linter = target / "debug/jailint"
    sdk = llvm_prefix()
    fixtures = ROOT / "tests/developer-tools"
    emitter = fixtures / "bindings-aggregate.jai"
    consumer = fixtures / "bindings-aggregate-roundtrip.jai"
    storage = fixtures / "bindings-transaction-storage.jai"
    library = scratch / "libaggregate.dylib"
    generated = scratch / "developer-tools-aggregate-generated.jai"
    cpp = scratch / "developer-tools-aggregate-consumer.cpp"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    tracked = list((ROOT / "stdlib/Bindings_Generator").glob("*.jai"))
    tracked += list((ROOT / "stdlib/internal/developer-tools").glob("*.jai"))
    tracked += list((ROOT / "stdlib/internal/developer-tools/generator-session").glob("*.jai"))
    tracked += [emitter, consumer, storage, fixtures / "bindings-aggregate.h",
                fixtures / "bindings-aggregate-native.cpp"]

    def snapshot():
        return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                for p in sorted(tracked)}

    before = snapshot()
    receipt = {"scope": "aggregate emission and transactional storage",
               "sdk": str(sdk), "source_sha256": before, "commands": [],
               "native_platform": "macOS", "cross_target": "not run"}

    def run(command, expected=""):
        result = subprocess.run([str(p) for p in command], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=90)
        row = {"command": [str(p) for p in command], "exit": result.returncode,
               "expected_stdout": result.stdout == expected,
               "empty_stderr": not result.stderr}
        receipt["commands"].append(row)
        if result.returncode or result.stdout != expected or result.stderr:
            raise RuntimeError("Scoped aggregate command failed: " + str(command[0]) +
                               "; diagnostic=" + (result.stderr or result.stdout)[:400])

    try:
        for mode in ["interp", "0", "2"]:
            for source, args in [(emitter, [scratch, "aggregate"]), (storage, [])]:
                if mode == "interp":
                    run([compiler, source, "-interp", *(["--", *args] if args else [])], "ok\n")
                else:
                    executable = scratch / (source.stem + "-o" + mode)
                    run([compiler, source, "-O" + mode, "-exe", executable])
                    run([executable, *args], "ok\n")
            run([formatter, "--config", ROOT / "jaifmt.toml", generated])
            for optimization in [0, 2]:
                flags = [sdk / "bin/clang++", "-std=c++17", "-O" + str(optimization),
                         "-Wall", "-Wextra", "-Werror", "-I", fixtures]
                run([*flags, "-dynamiclib", fixtures / "bindings-aggregate-native.cpp",
                     "-o", library])
                cpp_executable = scratch / ("cpp-" + mode + "-o" + str(optimization))
                run([*flags, cpp, library, "-o", cpp_executable])
                run([cpp_executable])
                run([compiler, consumer, "-interp", "-I", scratch], "ok\n")
                executable = scratch / ("jai-" + mode + "-o" + str(optimization))
                run([compiler, consumer, "-O" + str(optimization), "-I", scratch,
                     "-exe", executable])
                run([executable], "ok\n")
        run([formatter, "--config", ROOT / "jaifmt.toml", "--check",
             emitter, consumer, storage, generated])
        run([linter, "-D", "warnings", "-I", scratch, emitter, consumer, storage])
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = snapshot() == before
        if not receipt["source_unchanged"]:
            receipt["passed"] = False
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError("Shared inputs changed during verification; rerun required")
    print("Aggregate Jai/C++ consumers and storage checks passed interpreter/native Mac O0/O2")


if __name__ == "__main__":
    main()
