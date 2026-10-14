#!/usr/bin/env python3
"""Original platform I/O fixtures; use an explicit source-built compiler.

Run against an integrated stdlib using --stdlib. On Windows --native exercises
actual OS behavior. Cross source checks never count as Windows execution.
"""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def run(command, env, expected=None):
    result = subprocess.run([str(arg) for arg in command], cwd=ROOT, env=env,
                            capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
        raise RuntimeError(f"{' '.join(map(str, command))}\n"
                           f"exit={result.returncode}\n{result.stdout}{result.stderr}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, required=True)
    parser.add_argument("--stdlib", type=Path, required=True)
    parser.add_argument("--native", action="store_true")
    parser.add_argument("--cross-check", action="store_true")
    parser.add_argument("--wasm", action="store_true", help="execute Wasm interpreter and real WASI O0/O2")
    args = parser.parse_args()
    compiler = args.jaic.resolve(strict=True)
    if not compiler.is_relative_to(ROOT / "target"):
        parser.error("use the compiler source-built under this checkout target directory")
    env = dict(os.environ, JAIC_STDLIB=str(args.stdlib.resolve(strict=True)))
    output = ROOT / "target/platform-io-tests"
    output.mkdir(parents=True, exist_ok=True)
    fixtures = sorted((ROOT / "tests/platform-io").glob("*-contract.jai"))
    for source in fixtures:
        if args.cross_check:
            for system, cpu in [("windows", "x64"), ("windows", "arm64"),
                                ("macos", "arm64"), ("linux", "x64")]:
                run([compiler, source, "-check", "-no_dce", "-os", system, "-cpu", cpu], env)
        run([compiler, source, "-interp"], env, "ok\n")
        if args.native:
            for optimization in ["-O0", "-O2"]:
                executable = output / (source.stem + optimization + (".exe" if os.name == "nt" else ""))
                run([compiler, source, optimization, "-exe", executable], env)
                run([executable], env, "ok\n")
        if args.wasm:
            run([compiler, source, "-check", "-no_dce", "-os", "wasm"], env)
            run([compiler, source, "-interp", "-os", "wasm"], env, "ok\n")
            for optimization in ["-O0", "-O2"]:
                executable = output / (source.stem + optimization + ".wasm")
                run([compiler, source, "-os", "wasm", optimization, "-exe", executable], env)
                run(["node", "--no-warnings", ROOT / "tools/wasi_run.mjs", executable], env, "ok\n")
            print("passed Wasm interpreter and WASI O0/O2", source.relative_to(ROOT), flush=True)
        print("passed", source.relative_to(ROOT), flush=True)


if __name__ == "__main__":
    main()
