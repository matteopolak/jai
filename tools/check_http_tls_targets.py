#!/usr/bin/env python3
"""Check real HTTP/TLS target bodies and strict contextual lint, without execution."""

import argparse
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, required=True)
    parser.add_argument("--jailint", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--os", choices=["wasm", "windows", "linux", "macos"])
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    compiler = args.jaic.resolve(strict=True)
    linter = args.jailint.resolve(strict=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    contexts = [
        ("wasm", "x64", "http-date-target", "stdlib/Extensions/Http/date.jai"),
        (
            "windows",
            "x64",
            "tls-windows-target",
            "stdlib/Extensions/Tls/trust_windows.jai",
        ),
        (
            "windows",
            "arm64",
            "tls-windows-target",
            "stdlib/Extensions/Tls/trust_windows.jai",
        ),
        (
            "windows",
            "x64",
            "http-native-date-target",
            "stdlib/Extensions/Http/date.jai",
        ),
        (
            "windows",
            "arm64",
            "http-native-date-target",
            "stdlib/Extensions/Http/date.jai",
        ),
        (
            "linux",
            "x64",
            "http-native-date-target",
            "stdlib/Extensions/Http/date.jai",
        ),
        (
            "macos",
            "arm64",
            "http-native-date-target",
            "stdlib/Extensions/Http/date.jai",
        ),
    ]
    results = []
    for target_os, cpu, fixture, report in contexts:
        if args.os and args.os != target_os:
            continue
        source = f"tests/extensions/{fixture}.jai"
        target = ["-os", target_os, "-cpu", cpu]
        reports = [report]
        if fixture == "http-native-date-target":
            reports.append("stdlib/Extensions/Http/date_native.jai")
        for mode, command in [
            ("check", [str(compiler), "-check", "-no_dce", *target, source]),
            (
                "lint",
                [
                    str(linter),
                    "-D",
                    "warnings",
                    *target,
                    "--context",
                    source,
                    *reports,
                    source,
                ],
            ),
        ]:
            process = subprocess.run(
                command, cwd=ROOT, env=env, text=True, capture_output=True, timeout=90
            )
            passed = process.returncode == 0 and not process.stderr
            results.append(
                dict(
                    target_os=target_os,
                    cpu=cpu,
                    fixture=fixture,
                    mode=mode,
                    command=command,
                    exit=process.returncode,
                    passed=passed,
                    stdout=process.stdout,
                    stderr=process.stderr,
                )
            )
            (args.output / "results.json").write_text(
                json.dumps(results, indent=2) + "\n"
            )
            print(
                f"{target_os}/{cpu} {fixture} {mode}: {'PASS' if passed else 'FAIL'}",
                flush=True,
            )
    if args.os is None or args.os == "wasm":
        command = [
            str(compiler),
            "-check",
            "-no_dce",
            "-os",
            "wasm",
            "tests/extensions/http-date-now-wasm-negative.jai",
        ]
        process = subprocess.run(
            command, cwd=ROOT, env=env, text=True, capture_output=True, timeout=90
        )
        expected = "module `Extensions/Http` has no exported member `http_date_now`"
        passed = process.returncode == 1 and expected in process.stderr
        results.append(
            dict(
                target_os="wasm",
                fixture="http-date-now-wasm-negative",
                mode="check-negative",
                command=command,
                exit=process.returncode,
                passed=passed,
                stdout=process.stdout,
                stderr=process.stderr,
            )
        )
        (args.output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
        print(
            f"WASM native-only clock export rejection: {'PASS' if passed else 'FAIL'}",
            flush=True,
        )
    print("Source and lint checks only; no native execution evidence.")
    raise SystemExit(any(not result["passed"] for result in results))


if __name__ == "__main__":
    main()
