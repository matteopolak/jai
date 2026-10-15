#!/usr/bin/env python3
"""Build/link and execute owned interpreter-thread tests with the native Windows SDK."""

import argparse
import os
from pathlib import Path
import subprocess
import sys


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--build-only",
        action="store_true",
        help="link both tools without running thread tests",
    )
    parser.add_argument(
        "--llvm-linkage",
        choices=["static", "dynamic"],
        default="static",
        help="match the native Windows workflow's LLVM configuration (default: static)",
    )
    args = parser.parse_args()
    if sys.platform != "win32":
        raise SystemExit(
            "requires a native Windows x64/ARM64 Rust host and SDK; no cross-only pass"
        )
    root = Path(__file__).resolve().parents[1]
    environment = os.environ.copy()
    environment["RUSTC_WRAPPER"] = ""
    # Inherit CARGO_BUILD_TARGET and all CRT/Rust flags. In particular, do not mix an
    # import CRT with the +crt-static configuration required by the CI LLVM archive.
    for package, binary, features in [
        (
            "jaic-cli",
            "jaic",
            ["--no-default-features", "--features", f"{args.llvm_linkage}-llvm"],
        ),
        ("jailint", "jailint", []),
    ]:
        subprocess.run(
            ["cargo", "build", "--locked", "-p", package, "--bin", binary] + features,
            cwd=root,
            env=environment,
            check=True,
        )
    if args.build_only:
        return
    base = ["cargo", "test", "--locked", "-p", "jaic"]
    # Compile and link the actual Rust test executables before running any fixture.
    # This catches unavailable import libraries that cargo check/clippy cannot catch.
    targets = [
        ["--lib"],
        ["--test", "cleanroom_windows_threads"],
        ["--test", "cleanroom_windows_thread_aliases"],
        ["--test", "cleanroom_windows_thread_description"],
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
