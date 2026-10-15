#!/usr/bin/env python3
"""Reviewed diagnostic traversal/type semantics with independent stdout fixtures."""
import os
from pathlib import Path
import platform
import shutil
import subprocess
from check_portable_time_foundation import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]

EXPECTED = (
    "SEQUENCE\n    INTEGER 127\nSET\n    NULL \n"
    "OBJECT_IDENTIFIER 1.2.3.4.\nPRINTABLE_STRING hi\nUTF8_STRING é\n"
    "BIT_STRING ab cd\nOCTET_STRING (2 bytes) 00 ff\n"
    "INTEGER 01 02 03 04 05 06 07 08 09\n"
    "UTC_TIME 2 January 2025, 03:04:05\nUTC_TIME 31 December 1999, 23:59:59\n"
    "UTC_TIME 31 December 2049, 23:59:59\nUTC_TIME 1 January 1950, 00:00:00\n"
    "[2] NULL \n[2] IMPLICT type (0xa bytes)\n        NULL \nNULL \nINTEGER 0\n"
    "\x1b[0;33m--- named ---\n\x1b[0mPRINTABLE_STRING hi\n\x1b[0;33m--- named ---\n\x1b[0m"
    "\x1b[0;33m--- children ---\n\x1b[0mNULL \n\x1b[0;33m--- children ---\n\x1b[0m"
)


def main():
    output = ROOT / "target/portable-asn1-printer"
    output.mkdir(parents=True, exist_ok=True)
    baseline = ROOT / "target/portable-integration-stdlib"
    for relative in ["Android/Toolchain", "internal/android-toolchain"]:
        shutil.copytree(ROOT / "stdlib" / relative, baseline / relative, dirs_exist_ok=True)
    compose()
    env = dict(os.environ, JAIC_STDLIB=str(LIBRARY))
    compiler = str(ROOT / "target/compiler/debug/jaic")
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    expected = {"main": EXPECTED, "failures": "NULL ok\n",
                "nesting": "".join("    " * depth + "SEQUENCE\n" for depth in range(300)) + "    " * 300 + "NULL \n"}
    for name, text in expected.items():
        source = ROOT / "tests/portable-stdlib/android-asn1-printer" / (name + ".jai")
        commands = [[compiler, "-interp", str(source)]]
        for flags, label in targets:
            for optimization in ["-O0", "-O2"]:
                executable = output / (name + label + optimization)
                subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(executable)], env=env, check=True)
                commands.append([str(executable)])
        for command in commands:
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stdout != text or result.stderr:
                raise RuntimeError(f"{command!r}: status={result.returncode}, stdout length={len(result.stdout)}, stderr={result.stderr}")
        for target in ["linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                subprocess.run([compiler, "-check", "-os", target, "-cpu", cpu, str(source)], env=env, check=True)
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(LIBRARY / "Android/Toolchain/module.jai"),
                    str(LIBRARY / "internal/android-toolchain/asn1-diagnostics.jai"),
                    str(ROOT / "tests/portable-stdlib/android-asn1-printer")], env=env, check=True)
    print("ASN.1 printer types/overloads/300-level nesting/7 diagnosed failures pass 15 interpreter/native runs, Linux/Windows both-CPU source checks and strict lint")


if __name__ == "__main__":
    main()
