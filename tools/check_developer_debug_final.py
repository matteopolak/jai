#!/usr/bin/env python3
"""Final reviewed Debug contract: actual Mac behavior and conditional presence."""
import os
import platform
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUILD = Path(os.environ.get("CARGO_TARGET_DIR", ROOT / "target"))
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))


def run(command, output=None):
    result = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                            capture_output=True, text=True, timeout=60)
    if result.returncode or (output is not None and result.stdout != output):
        raise RuntimeError(f"Final Debug contract failed: {command}\n{result.stdout}\n{result.stderr}")
    return result


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("Final contract execution requires the reviewed Mac platform behavior")
    source = ROOT / "tests/developer-tools/debug-final-contract.jai"
    compiler = BUILD / "debug/jaic"
    sdk = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
    for optimization in [0, 2]:
        executable = ROOT / f"target/debug-command-o{optimization}"
        run([sdk / "bin/clang", "-std=c11", f"-O{optimization}", "-Wall", "-Wextra", "-Werror",
             ROOT / "tests/developer-tools/debug-command.c", "-o", executable], "")
        run([executable], "")
    for mode in ["interp", "0", "2"]:
        command = [compiler, source, "-interp"]
        if mode != "interp":
            executable = ROOT / f"target/debug-final-contract-o{mode}"
            run([compiler, source, f"-O{mode}", "-exe", executable], "")
            command = [executable]
        result = run(command, "ok\n")
        if len(result.stderr.splitlines()) != 3 or "original ignored assertion" not in result.stderr:
            raise RuntimeError("Required public assertion diagnostics were not emitted")
    ownership = ROOT / "tests/developer-tools/debug-ignore-ownership.jai"
    for mode in ["interp", "0", "2"]:
        command = [compiler, ownership, "-interp"]
        if mode != "interp":
            executable = ROOT / f"target/debug-ignore-ownership-o{mode}"
            run([compiler, ownership, f"-O{mode}", "-exe", executable], "")
            command = [executable]
        result = run(command, "ok\n")
        if "original arena-owned suppression" not in result.stderr:
            raise RuntimeError("Actual retained assertion location diagnostic is missing")
    paths = [ROOT / "stdlib/Debug/module.jai", ROOT / "stdlib/internal/debug-state/module.jai",
             *[ROOT / f"stdlib/internal/developer-tools/debug-{name}.jai" for name in
               ["assertions", "dumps", "dialog-linux", "lifecycle"]], source, ownership]
    run([ROOT / "target/jaifmt", "--config", ROOT / "jaifmt.toml", "--check", *paths], "")
    # Facade roots provide the required module-conditional declarations.
    run([BUILD / "debug/jailint", "-D", "warnings", paths[0], source, ownership], "")
    for cpu in ["x64", "arm64"]:
        run([compiler, ROOT / "tests/developer-tools/debug-lifecycle.jai", "-check", "-os", "linux", "-cpu", cpu], "")
        run([BUILD / "debug/jailint", "--os", "linux", "--cpu", cpu, "-D", "warnings", paths[0]], "")
    print("Final Debug Mac conditional/canonical/assertion/attachment/dump contracts passed interpreter/native O0/O2; Linux type/lint checks passed")


if __name__ == "__main__":
    main()
