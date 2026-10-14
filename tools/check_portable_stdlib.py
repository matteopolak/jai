#!/usr/bin/env python3
"""Run focused supported cases with an explicitly source-built local compiler.

This is a worker regression set, not the coordinator's full conformance sweep.
Unimplemented module fixtures remain unchanged in tests/stdlib-contract.
"""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
CONTRACTS = [
    "basic", "string", "memory", "pcg", "codec", "bit-array", "reflection",
    "unicode", "pool", "adpcm", "bucket-array", "file-utils", "socket", "thread",
]
EXPECTED = {
    "runtime": "runtime -9223372036854775808 ff\n",
    "foundations": "-42 true text 55\n",
}


def run(command, env, expected=None, cwd=ROOT):
    result = subprocess.run(command, cwd=cwd, env=env, text=True,
                            capture_output=True, timeout=45)
    if result.returncode or (expected is not None and result.stdout != expected):
        print("FAILED:", " ".join(map(str, command)), file=sys.stderr)
        print(result.stdout, end="", file=sys.stderr)
        print(result.stderr, end="", file=sys.stderr)
        raise RuntimeError(f"exit={result.returncode}, expected stdout={expected!r}")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
        raise RuntimeError("unexpected compiler/runtime diagnostics")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, default=ROOT / "target/compiler/debug/jaic")
    parser.add_argument("--posix-root", required=True, type=Path,
                        help="new independently implemented POSIX module directory")
    parser.add_argument("--native", action="store_true")
    parser.add_argument("--check-target", action="append", default=[],
                        help="OS/CPU pair, e.g. linux/x64; checks portable cases only")
    args = parser.parse_args()
    compiler = args.jaic.resolve(strict=True)
    if not compiler.is_relative_to(ROOT / "target"):
        parser.error("compiler must be a source build under this checkout's target directory")
    root = ROOT / "target/portable-integration-stdlib"
    shutil.copytree(ROOT / "stdlib", root, dirs_exist_ok=True)
    shutil.copytree(args.posix_root, root / "POSIX", dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(root))
    output = ROOT / "target/portable-tests"
    output.mkdir(parents=True, exist_ok=True)
    cases = [(p, EXPECTED.get(p.stem, "ok\n"))
             for p in sorted((ROOT / "tests/portable-stdlib").glob("*.jai"))
             if p.stem != "bootstrap"]
    cases += [(ROOT / f"tests/stdlib-contract/{name}/main.jai", "ok\n") for name in CONTRACTS]
    run([str(compiler), "-check", str(ROOT / "tests/portable-stdlib/bootstrap.jai")], env)
    for index, (source, expected) in enumerate(cases):
        run([str(compiler), "-interp", str(source)], env, expected)
        if args.native:
            executable = output / f"case-{index}"
            run([str(compiler), str(source), "-exe", str(executable)], env)
            run([str(executable)], env, expected, source.parent)
        print("passed", source.relative_to(ROOT), flush=True)
    dependent = {"file", "filesystem", "socket-loopback"}
    posix_only = {"module-identity", "thread-lifetime", "thread-groups", "thread-condition", "thread-shutdown"}
    for target in args.check_target:
        os_name, cpu = target.split("/", 1)
        for source, _ in cases:
            if source.parent.name != "portable-stdlib" or source.stem in dependent or (os_name == "windows" and source.stem in posix_only):
                continue
            run([str(compiler), "-check", "-os", os_name, "-cpu", cpu, str(source)], env)
        print("checked portable cases", target, flush=True)
    print(f"{len(cases)} focused cases passed; native={args.native}")


if __name__ == "__main__":
    main()
