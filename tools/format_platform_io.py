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
    "stdlib/internal/runtime/startup.jai", "stdlib/internal/runtime/windows-io.jai",
    "stdlib/internal/runtime/windows-arguments.jai", "stdlib/internal/runtime/windows-crash.jai",
    "stdlib/Runtime_Support/tests/windows-crash-bootstrap.jai",
    "tests/platform-io",
]


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
        env = dict(os.environ, JAIC_STDLIB=str(args.stdlib.resolve(strict=True)))
        result = subprocess.run([str(args.jailint.resolve(strict=True)), "-v", "-D", "warnings",
                                 "--config", str(ROOT / "jailint.toml"), *OWNED],
                                cwd=ROOT, env=env, capture_output=True, text=True)
        sys.stdout.write(result.stdout)
        sys.stderr.write(result.stderr)
        incomplete = "did not compile completely" in result.stdout + result.stderr
        if incomplete:
            print("platform I/O lint incomplete: required bodies were not checked; see docs/platform-io-compiler-handoff.md", file=sys.stderr)
        return result.returncode or int(incomplete)
    if not args.jaifmt:
        parser.error("format/check requires --jaifmt source-built formatter")
    return subprocess.run([str(args.jaifmt.resolve(strict=True)), "--config", str(ROOT / "jaifmt.toml"),
                           *(["--check"] if args.check else []), *OWNED], cwd=ROOT).returncode


if __name__ == "__main__":
    sys.exit(main())
