#!/usr/bin/env python3
"""Owned platform I/O format/lint scope; incomplete lint coverage is a failure."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
OWNED = [
    "stdlib/Process/module.jai", "stdlib/internal/process/windows.jai", "stdlib/internal/process/windows-types.jai",
    "stdlib/File/module.jai", "stdlib/internal/files/file.jai",
    "stdlib/internal/files/native-unix.jai", "stdlib/internal/files/native-windows.jai",
    "stdlib/internal/platform-io", "stdlib/System/module.jai", "stdlib/internal/system/windows.jai",
    "stdlib/Thread/module.jai", "stdlib/internal/thread",
    "stdlib/Runtime_Support/module.jai", "stdlib/internal/runtime/module.jai",
    "stdlib/internal/runtime/windows-io.jai",
    "stdlib/internal/runtime/windows-arguments.jai", "stdlib/Runtime_Support_Crash_Handler/module.jai",
    "stdlib/internal/runtime/windows-crash-types.jai", "stdlib/internal/runtime/windows-crash-handler.jai",
    "stdlib/internal/runtime/windows-arm64-crash",
    "tests/platform-io",
]


def owned_files():
    return sorted({file for path in OWNED for file in
                   ([ROOT / path] if (ROOT / path).is_file() else (ROOT / path).rglob("*.jai"))})


def lint_owned(binary, stdlib):
    files = owned_files()
    staged = {}
    for file in files:
        path = stdlib / file.relative_to(ROOT / "stdlib") if file.is_relative_to(ROOT / "stdlib") else file
        if path.read_bytes() != file.read_bytes():
            raise RuntimeError(f"staged owned source differs: {file}")
        staged[file] = path.resolve()
    env = dict(os.environ, JAIC_STDLIB=str(stdlib))
    checked = set()
    output = ROOT / "target/platform-io-lint"
    output.mkdir(parents=True, exist_ok=True)
    for os_target, cpu in [("macos", "arm64"), ("linux", "x64"), ("windows", "x64"), ("windows", "arm64")]:
        selected = []
        for original, path in staged.items():
            relative = original.relative_to(ROOT).as_posix()
            # OS-specific source roots are checked on their actual supported
            # targets. #load files still receive context from their real module.
            if os_target != "windows" and "windows" in relative:
                continue
            if os_target == "windows" and ("native-unix" in relative or "native-macos" in relative or "synchronization.jai" in relative):
                continue
            if os_target == "windows" and cpu == "arm64" and (
                    "Runtime_Support_Crash_Handler" in relative or "windows-crash" in relative or "windows-arm64-crash-handler" in relative):
                continue  # Reviewed x64-only handler; negative ARM64 checks live in the test runner.
            if os_target == "windows" and cpu != "arm64" and "windows-arm64-crash/module.jai" in relative:
                continue  # Private native context adapter is ARM64-only.
            if os_target == "linux" and "native-macos" in relative:
                continue
            selected.append(str(path))
        manifest = output / f"{os_target}-{cpu}.txt"
        definitions = []
        if os_target == "windows":
            definitions = ["--add", f'OPTIMIZED :: false; BACKTRACE_ENABLED :: true; '
                           f'OUTPUT_PATH :: "{output.as_posix()}"; '
                           f'CHILD_SOURCE :: "{(ROOT / "tests/platform-io/windows-fault.jai").as_posix()}";']
        result = subprocess.run([str(binary), "-D", "warnings", "--os", os_target, "--cpu", cpu,
                                 "--config", str(ROOT / "jailint.toml"), "--checked-files", str(manifest), *definitions, *selected],
                                cwd=ROOT, env=env, text=True, capture_output=True)
        (output / f"{os_target}-{cpu}.log").write_text(result.stdout + result.stderr)
        sys.stdout.write(result.stdout)
        sys.stderr.write(result.stderr)
        if result.returncode:
            return result.returncode
        checked.update(Path(path).resolve() for path in manifest.read_text().splitlines() if path)
        print(f"passed strict lint {os_target}/{cpu}", flush=True)
    missing = [str(original.relative_to(ROOT)) for original, path in staged.items() if path not in checked]
    if missing:
        raise RuntimeError("owned files never checked: " + ", ".join(missing))
    print(f"passed strict lint coverage of {len(files)} owned Jai files", flush=True)
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--lint", action="store_true")
    parser.add_argument("--jaifmt", type=Path)
    parser.add_argument("--jailint", type=Path)
    parser.add_argument("--stdlib", type=Path)
    args = parser.parse_args()
    if args.lint:
        if not args.jailint or not args.stdlib:
            parser.error("--lint requires --jailint and --stdlib source-built tool/dependencies")
        return lint_owned(args.jailint.resolve(strict=True), args.stdlib.resolve(strict=True))
    if not args.jaifmt:
        parser.error("format/check requires --jaifmt source-built formatter")
    return subprocess.run([str(args.jaifmt.resolve(strict=True)), "--config", str(ROOT / "jaifmt.toml"),
                           *(["--check"] if args.check else []), *OWNED], cwd=ROOT).returncode


if __name__ == "__main__":
    sys.exit(main())
