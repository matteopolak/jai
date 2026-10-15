#!/usr/bin/env python3
"""Check MSVC CRT dependency selection in own Rust static-library metadata, without an SDK link."""

from pathlib import Path
import os
import re
import subprocess


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    (root / "target").mkdir(exist_ok=True)
    environment = os.environ.copy()
    environment["RUSTC_WRAPPER"] = ""
    for target in ["x86_64-pc-windows-msvc", "aarch64-pc-windows-msvc"]:
        for static in [False, True]:
            mode = "static" if static else "dynamic"
            command = [
                "cargo",
                "rustc",
                "--locked",
                "-p",
                "jaic",
                "--lib",
                "--target",
                target,
                "--crate-type",
                "staticlib",
                "--",
                "-C",
                f"target-feature={'+' if static else '-'}crt-static",
                "--print=native-static-libs",
            ]
            result = subprocess.run(
                command, cwd=root, env=environment, capture_output=True, text=True
            )
            log = root / "target" / f"windows-crt-{target}-{mode}.log"
            log.write_text(result.stdout + result.stderr)
            result.check_returncode()
            dependencies = re.findall(r"native-static-libs: (.*)", result.stderr)
            if len(dependencies) != 1:
                raise SystemExit(f"missing/unexpected Rust dependency report: {log}")
            tokens = dependencies[0].lower().split()
            crt = "libcmt" if static else "msvcrt"
            if f"/defaultlib:{crt}" not in tokens and f"{crt}.lib" not in tokens:
                raise SystemExit(f"Rust's selected {mode} CRT not reported: {log}")
            if "ucrt.lib" in tokens or "libucrt.lib" in tokens:
                raise SystemExit(
                    f"extra explicit UCRT dependency bypasses Rust's CRT selection: {log}"
                )
            print(
                f"{target} {mode}: Rust selected {crt}; no forced UCRT library (metadata only)"
            )


if __name__ == "__main__":
    main()
