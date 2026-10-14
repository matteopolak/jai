#!/usr/bin/env python3
"""Check the foundations cases against explicitly selected clean-room source builds."""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASES = ("builder-format", "integer-format", "string-patterns", "hash-floats", "basic-filesystem",
         "file-utilities-shape", "foundation-filesystem", "hash-scalars", "file-visitation")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", required=True, type=Path)
    parser.add_argument("--stdlib", required=True, type=Path)
    parser.add_argument("--jaifmt", type=Path, help="unchanged repository CLI built with the selected library")
    parser.add_argument("--cross", action="store_true")
    args = parser.parse_args()
    compiler = args.jaic.resolve(strict=True)
    if not compiler.is_relative_to(ROOT / "target"):
        parser.error("use a compiler built from independent sources under this checkout's target")
    env = dict(os.environ, JAIC_STDLIB=str(args.stdlib.resolve(strict=True)))
    output = ROOT / "target/foundations-tests"
    output.mkdir(parents=True, exist_ok=True)

    if args.jaifmt:
        formatter = args.jaifmt.resolve(strict=True)
        if not formatter.is_relative_to(ROOT / "target"):
            parser.error("use a jaifmt source build under this checkout's target")
        directory = output / "jaifmt-cli"
        directory.mkdir(exist_ok=True)
        hidden = directory / ".hidden"
        hidden.mkdir(exist_ok=True)
        (hidden / "ignored.jai").write_text("deliberately malformed {")
        source = directory / "sample.jai"
        source.write_text("main::(){value:=1;value+=2;}\n")
        check = subprocess.run([formatter, "--check", source], cwd=ROOT, env=env,
                               capture_output=True, text=True, timeout=60)
        if check.returncode != 1 or not check.stdout or check.stderr:
            raise RuntimeError(f"jaifmt dirty-file check: {check}")
        rewrite = subprocess.run([formatter, directory], cwd=ROOT, env=env,
                                 capture_output=True, text=True, timeout=60)
        if rewrite.returncode or rewrite.stderr:
            raise RuntimeError(f"jaifmt recursive rewrite: {rewrite}")
        formatted = source.read_text()
        clean = subprocess.run([formatter, "--check", directory], cwd=ROOT, env=env,
                               capture_output=True, text=True, timeout=60)
        if clean.returncode or clean.stdout or clean.stderr or source.read_text() != formatted:
            raise RuntimeError(f"jaifmt idempotence: {clean}")
        stdin = subprocess.run([formatter, "--stdin"], input="main::(){value:=1;value+=2;}\n",
                               cwd=ROOT, env=env, capture_output=True, text=True, timeout=60)
        if stdin.returncode or stdin.stderr or stdin.stdout != formatted:
            raise RuntimeError(f"jaifmt stdin: {stdin}")
        if (hidden / "ignored.jai").read_text() != "deliberately malformed {":
            raise RuntimeError("jaifmt modified a pruned hidden directory")
        print("passed unchanged jaifmt CLI: check/rewrite/recursion/pruning/stdin/idempotence", flush=True)

    def run(command, expected=None):
        result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=60)
        if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
            raise RuntimeError(f"{command}\nexit={result.returncode}\n{result.stdout}{result.stderr}")

    for name in CASES:
        source = ROOT / f"tests/portable-stdlib/{name}.jai"
        run([compiler, "-interp", source], "ok\n")
        for level in ("O0", "O2"):
            binary = output / f"{name}-{level}"
            run([compiler, source, f"-{level}", "-exe", binary])
            run([binary], "ok\n")
        print(f"passed interpreter/native O0/O2: {name}", flush=True)
    if args.cross:
        for os_name, cpu in (("linux", "x64"), ("linux", "arm64"), ("macos", "arm64"), ("windows", "x64"), ("wasm", "wasm64")):
            for name in CASES:
                if name in ("basic-filesystem", "foundation-filesystem", "file-visitation") and os_name in ("windows", "wasm"):
                    continue
                target = ["-target", "wasm64-unknown-wasi"] if os_name == "wasm" else ["-os", os_name, "-cpu", cpu]
                run([compiler, "-check", "-no_dce", *target,
                     ROOT / f"tests/portable-stdlib/{name}.jai"])
            print(f"checked unused code: {os_name}/{cpu}", flush=True)


if __name__ == "__main__":
    main()
