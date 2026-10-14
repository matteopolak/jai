#!/usr/bin/env python3
"""Original platform I/O fixtures; use an explicit source-built compiler.

Run against an integrated stdlib using --stdlib. On Windows --native exercises
actual OS behavior. Cross source checks never count as Windows execution.
"""
import argparse
import os
import platform
import shutil
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]


def run(command, env, expected=None):
    result = subprocess.run([str(arg) for arg in command], cwd=ROOT, env=env,
                            capture_output=True, timeout=60)
    if result.returncode or result.stderr or (expected is not None and result.stdout != expected.encode()):
        raise RuntimeError(f"{' '.join(map(str, command))}\n"
                           f"exit={result.returncode}\n{result.stdout.decode(errors='replace')}{result.stderr.decode(errors='replace')}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, required=True)
    parser.add_argument("--stdlib", type=Path, required=True)
    parser.add_argument("--native", action="store_true")
    parser.add_argument("--cross-check", action="store_true")
    parser.add_argument("--wasm", action="store_true", help="execute Wasm interpreter and real WASI O0/O2")
    parser.add_argument("--case", action="append", choices=sorted(p.stem for p in (ROOT / "tests/platform-io").glob("*-contract.jai")),
                        help="select contract cases; omitted means all cases, argument bridge always runs")
    parser.add_argument("--windows-build", choices=["x64", "arm64"],
                        help="cross-build Windows fixtures; requires the selected native toolchain")
    parser.add_argument("--private-process", action="store_true",
                        help="test the real private engine from a library-owned test entry")
    parser.add_argument("--windows-crash", action="store_true",
                        help="source-build Windows exception diagnostics and the enabled-startup fault fixture")
    args = parser.parse_args()
    compiler = args.jaic.resolve(strict=True)
    if not compiler.is_relative_to(ROOT / "target"):
        parser.error("use the compiler source-built under this checkout target directory")
    env = dict(os.environ, JAIC_STDLIB=str(args.stdlib.resolve(strict=True)))
    conflict = ROOT / "tests/platform-io/negative/windows-runtime-configuration-conflict.jai"
    for cpu in ["x64", "arm64"]:
        rejected = subprocess.run([str(compiler), str(conflict), "-os", "windows", "-cpu", cpu, "-check"],
                                  cwd=ROOT, env=env, capture_output=True, timeout=60)
        if rejected.returncode != 1 or b"conflicts with the configured runtime instance" not in rejected.stderr or rejected.stdout:
            raise RuntimeError(f"expected original runtime configuration conflict: {rejected}")
    output = ROOT / "target/platform-io-tests"
    output.mkdir(parents=True, exist_ok=True)
    fixtures = sorted((ROOT / "tests/platform-io").glob("*-contract.jai"))
    if args.case:
        fixtures = [source for source in fixtures if source.stem in args.case]
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
    source = ROOT / "tests/platform-io/arguments.jai"
    arguments = ["雪😀", "", 'quote" and slash\\']
    run([compiler, source, "-interp", "--", *arguments], env, "ok\n")
    if args.native:
        for optimization in ["-O0", "-O2"]:
            executable = output / ("arguments" + optimization + (".exe" if os.name == "nt" else ""))
            run([compiler, source, optimization, "-exe", executable], env)
            run([executable, *arguments], env, "ok\n")
    print("passed", source.relative_to(ROOT), flush=True)
    if args.windows_build:
        for source in [*fixtures, ROOT / "tests/platform-io/arguments.jai"]:
            for optimization in ["-O0", "-O2"]:
                executable = output / (source.stem + "-windows-" + args.windows_build + optimization + ".exe")
                run([compiler, source, "-os", "windows", "-cpu", args.windows_build,
                     optimization, "-exe", executable], env)
            print("cross-built", source.relative_to(ROOT), args.windows_build, flush=True)
    if args.private_process:
        source = ROOT / "stdlib/Process/tests/windows-private-engine.jai"
        helper = ROOT / "tests/platform-io/windows-process-child.jai"
        for cpu in ["x64", "arm64"]:
            run([compiler, source, "-os", "windows", "-cpu", cpu, "-check", "-no_dce"], env)
            run([compiler, helper, "-os", "windows", "-cpu", cpu, "-check", "-no_dce"], env)
        if os.name == "nt" or args.windows_build:
            target = [] if os.name == "nt" else ["-os", "windows", "-cpu", args.windows_build]
            for optimization in ["-O0", "-O2"]:
                executable = output / ("private-process" + optimization + ".exe")
                child = output / ("private-process-child" + optimization + ".exe")
                run([compiler, helper, *target, optimization, "-exe", child], env)
                run([compiler, source, *target, optimization, "-exe", executable], env)
                if os.name == "nt":
                    run([executable, child], env, "ok\n")
                    for mode in ["parent-kill", "parent-keep"]:
                        marker = output / (mode + optimization + ".marker")
                        marker.unlink(missing_ok=True)
                        try:
                            run([executable, child, mode, marker], env, "")
                            deadline = time.monotonic() + 2
                            while time.monotonic() < deadline and not marker.exists():
                                time.sleep(0.02)
                            if marker.exists() != (mode == "parent-keep"):
                                raise RuntimeError(f"parent exit lifetime mismatch: {mode}")
                        finally:
                            marker.unlink(missing_ok=True)
        print("private engine checked without source staging; public Process adapter remains unimplemented", flush=True)
    if args.windows_crash:
        cpu = args.windows_build or ("arm64" if platform.machine().lower() in {"arm64", "aarch64"} and os.name == "nt" else "x64")
        if cpu != "x64":
            raise RuntimeError("reviewed native crash backtraces support Windows x64 only")
        subprocess.run([sys.executable, str(ROOT / "tools/build_platform_io_runtime.py"),
                        "--stdlib", str(args.stdlib.resolve()), "--cpu", cpu], cwd=ROOT, check=True)
        bootstrap = ROOT / "stdlib/Runtime_Support/tests/windows-crash-bootstrap.jai"
        run([compiler, bootstrap, "-os", "windows", "-cpu", "x64", "-check", "-no_dce"], env)
        rejected = subprocess.run([str(compiler), str(bootstrap), "-os", "windows", "-cpu", "arm64", "-check", "-no_dce"],
                                  cwd=ROOT, env=env, capture_output=True, timeout=60)
        if rejected.returncode != 1 or b"Windows crash backtraces require x64" not in rejected.stderr or rejected.stdout:
            raise RuntimeError(f"expected reviewed ARM64 crash rejection: {rejected}")
        crash_output = output / "windows-crash"
        crash_output.mkdir(exist_ok=True)
        definitions = (f'BACKTRACE_ENABLED :: true; OUTPUT_PATH :: "{crash_output.as_posix()}"; '
                       f'CHILD_SOURCE :: "{(ROOT / "tests/platform-io/windows-fault.jai").as_posix()}";')
        builder = ROOT / "tests/portable-stdlib/startup-crash/build.jai"
        run([compiler, builder, "-os", "windows", "-cpu", cpu, "-add", definitions,
             "-exe", crash_output / "builder.exe"], env)
        shutil.copy2(args.stdlib.resolve() / "internal/runtime/crash-native/platform_io_windows_crash.dll",
                     crash_output / "platform_io_windows_crash.dll")
        if os.name == "nt":
            result = subprocess.run([str(crash_output / "startup-crash.exe")], cwd=ROOT, env=env,
                                    capture_output=True, timeout=60)
            if (result.returncode & 0xffffffff) != 0xc0000005 or result.stdout or b"Windows exception 0x00000000c0000005" not in result.stderr or b"native stack:" not in result.stderr:
                raise RuntimeError(f"Windows exception diagnostic mismatch: {result}")
            print("passed native Windows exception diagnostics", flush=True)
        else:
            print("cross-built Windows exception diagnostics; native execution outstanding", flush=True)


if __name__ == "__main__":
    main()
