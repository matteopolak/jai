#!/usr/bin/env python3
"""Original macOS SDK tracing oracle for public Debug.break_once behavior."""
import os
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUILD = Path(os.environ.get("CARGO_TARGET_DIR", ROOT / "target"))
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))


def run(command, expected=""):
    result = subprocess.run([str(item) for item in command], cwd=ROOT, env=ENV,
                            capture_output=True, text=True, timeout=60)
    if result.returncode or result.stdout != expected or result.stderr:
        raise RuntimeError(f"Debug once oracle failed: {command}\n{result.returncode}\n{result.stdout}\n{result.stderr}")


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("This original SDK tracing oracle requires macOS")
    run(["python3", ROOT / "tools/build_developer_debug.py"])
    sdk = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
    driver = ROOT / "target/debug-trace-driver"
    run([sdk / "bin/clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
         ROOT / "tests/developer-tools/debug-trace-driver.c", "-o", driver])
    source = ROOT / "tests/developer-tools/debug-break-once.jai"
    jaic = BUILD / "debug/jaic"
    for mode in ["interp", "0", "2"]:
        command = [jaic, source, "-interp"]
        if mode != "interp":
            executable = ROOT / f"target/debug-break-once-o{mode}"
            run([jaic, source, f"-O{mode}", "-exe", executable])
            command = [executable]
        run(command, "ok\n")
        run([driver, *command], "ok\n")
    paths = [ROOT / "stdlib/internal/developer-tools/debug-native.jai", source]
    run([ROOT / "target/jaifmt", "--config", ROOT / "jaifmt.toml", "--check", *paths])
    # The internal file requires the public module's enum declarations.
    run([BUILD / "debug/jailint", "-D", "warnings", ROOT / "stdlib/Debug/module.jai", source])
    print("Debug.break_once passed actual SDK tracing and untraced Mac interpreter/native O0/O2, format and strict lint")


if __name__ == "__main__":
    main()
