#!/usr/bin/env python3
"""Check canonical Basic array ownership using the actual supplied compiler."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--stdlib", type=Path, required=True)
    parser.add_argument("--capture", type=Path, required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    fixtures = root / "tests/portable-stdlib/basic-array-context"
    args.capture.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["JAIC_STDLIB"] = str(args.stdlib.resolve())
    rows = []
    cases = [
        ("provider-poke", True, ""),
        ("loaded-poke", True, ""),
        ("facade-poke", False, "operator=="),
        ("provider-no-poke", False, "operator=="),
        ("loaded-no-poke", False, "operator=="),
        ("facade-no-poke", False, "operator=="),
        ("basic-array-find", True, ""),
        ("basic-primitive-enum", True, ""),
        ("basic-explicit-comparator", True, ""),
        ("basic-without-poke", False, "operator=="),
        ("basic-record-no-operator", False, "operator=="),
        (
            "negative-internal-import",
            False,
            "standard-library internal sources are private",
        ),
        ("negative-private-helper", False, "copy_array_elements"),
        ("configuration", True, ""),
        ("poke", True, ""),
        ("family", True, ""),
        ("debugger-default", True, ""),
    ]
    passed = True
    for name, positive, diagnostic in cases:
        for mode in ["-check", "-interp"] if positive else ["-check"]:
            command = [
                str(args.compiler.resolve()),
                str(fixtures / (name + ".jai")),
                "-import_dir",
                str(fixtures / "modules"),
                mode,
            ]
            result = subprocess.run(
                command, env=env, cwd=root, text=True, capture_output=True, check=False
            )
            ok = (
                result.returncode == 0
                if positive
                else result.returncode == 1 and diagnostic in result.stderr
            )
            rows.append(
                {
                    "case": name,
                    "mode": mode,
                    "command": command,
                    "exit": result.returncode,
                    "stdout": result.stdout,
                    "stderr": result.stderr,
                    "expected": "PASS" if positive else "REJECT: " + diagnostic,
                    "pass": ok,
                }
            )
            passed = passed and ok
            (args.capture / "checks.json").write_text(
                json.dumps(
                    {
                        "compiler_sha256": hashlib.sha256(
                            args.compiler.read_bytes()
                        ).hexdigest(),
                        "commands": rows,
                    },
                    indent=2,
                )
                + "\n"
            )
            print(f"{name} {mode}: {'PASS' if ok else 'FAIL'}", flush=True)
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
