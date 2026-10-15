#!/usr/bin/env python3
"""Build/link and execute owned interpreter-thread tests with the native Windows SDK."""

import os
from pathlib import Path
import subprocess
import sys


def main() -> None:
    if sys.platform != "win32":
        raise SystemExit(
            "requires a native Windows x64/ARM64 Rust host and SDK; no cross-only pass"
        )
    root = Path(__file__).resolve().parents[1]
    environment = os.environ.copy()
    environment["RUSTC_WRAPPER"] = ""
    base = ["cargo", "test", "--locked", "-p", "jaic"]
    # Compile and link the actual Rust test executables before running any fixture.
    # This catches unavailable import libraries that cargo check/clippy cannot catch.
    targets = [
        ["--lib"],
        ["--test", "cleanroom_windows_threads"],
        ["--test", "cleanroom_windows_thread_aliases"],
    ]
    for target in targets:
        subprocess.run(
            base + target + ["--no-run"], cwd=root, env=environment, check=True
        )
    subprocess.run(
        base + ["--lib", "interp::threads::"], cwd=root, env=environment, check=True
    )
    for target in targets[1:]:
        subprocess.run(base + target, cwd=root, env=environment, check=True)


if __name__ == "__main__":
    main()
