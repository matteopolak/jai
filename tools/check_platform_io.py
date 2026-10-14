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
    parser.add_argument("--windows-build", choices=["x64", "arm64"],
                        help="cross-build Windows fixtures; requires the selected native toolchain")
    parser.add_argument("--private-process", action="store_true",
                        help="test the private engine using an explicitly test-only staged module")
    parser.add_argument("--windows-crash", action="store_true",
                        help="source-build Windows exception diagnostics and the enabled-startup fault fixture")
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
        if not args.stdlib.resolve().is_relative_to(ROOT / "target"):
            parser.error("private engine test requires a staged stdlib in this checkout's target directory")
        wrapper = args.stdlib.resolve() / "Platform_IO_Process_Test"
        wrapper.mkdir()
        module = wrapper / "module.jai"
        module.write_text('#load "../internal/platform-io/tests/windows-process.jai";\n')
        try:
            source = ROOT / "tests/platform-io/windows-process-backend.jai"
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
            print("private engine checked; public Process adapter still pending reviewed layouts", flush=True)
        finally:
            module.unlink()
            wrapper.rmdir()
    if args.windows_crash:
        cpu = args.windows_build or ("arm64" if platform.machine().lower() in {"arm64", "aarch64"} and os.name == "nt" else "x64")
        subprocess.run([sys.executable, str(ROOT / "tools/build_platform_io_runtime.py"),
                        "--stdlib", str(args.stdlib.resolve()), "--cpu", cpu], cwd=ROOT, check=True)
        bootstrap = ROOT / "tests/platform-io/windows-runtime-bootstrap.jai"
        for target_cpu in ["x64", "arm64"]:
            run([compiler, bootstrap, "-os", "windows", "-cpu", target_cpu, "-check", "-no_dce"], env)
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
