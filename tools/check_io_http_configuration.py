#!/usr/bin/env python3
"""Focused source/optional interpreter checks; no native, server or network runs."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--source-root", type=Path, default=ROOT)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--interpreter", action="store_true")
    args = parser.parse_args()
    root = args.source_root.resolve(strict=True)
    compiler = args.compiler.resolve(strict=True)
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(root / "stdlib"), TMPDIR=str(output))
    rows = []

    def run(label, arguments, status=0, stdout="", diagnostic=None):
        command = [str(compiler), *map(str, arguments)]
        try:
            result = subprocess.run(
                command, cwd=root, env=env, capture_output=True, text=True, timeout=90
            )
            passed = result.returncode == status
            if diagnostic is None:
                passed = passed and result.stdout == stdout and not result.stderr
            else:
                passed = (
                    passed
                    and diagnostic in result.stderr
                    and "error during compile-time execution" not in result.stderr
                )
            row = dict(
                label=label,
                command=command,
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        except subprocess.TimeoutExpired:
            row = dict(label=label, command=command, passed=False, error="timeout")
        rows.append(row)
        (output / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(f"{label}: {'PASS' if row['passed'] else 'FAIL'}", flush=True)

    protocol = root / "tests/extensions/io-configuration-protocol/main.jai"
    parent = root / "tests/extensions/io-configured-production.jai"
    run("real-io-child-no-output", [parent, "-check"])
    for setting in ("enabled", "disabled"):
        run(
            "real-worker-source-" + setting,
            [
                root / "tests/extensions/io-configured-workers.jai",
                "-check",
                "-add",
                '#import "Basic"()(ENABLE_ASSERT = '
                + str(setting == "enabled").lower()
                + ");",
            ],
        )
        run(
            "main-configuration-" + setting,
            [protocol, "-check", "-", setting],
            stdout="child configuration accepted\n",
        )

    # Independent required negatives: wrong argument group and wrong owner.
    negative = output / "negative"
    module = negative / "modules/Invalid_Settings"
    module.mkdir(parents=True, exist_ok=True)
    (negative / "first-list.jai").write_text(
        '#import "Basic"(ENABLE_ASSERT = false);\nmain :: () {}\n'
    )
    (module / "module.jai").write_text('#import "Basic"()(ENABLE_ASSERT = false);\n')
    (negative / "non-main.jai").write_text(
        '#import "Invalid_Settings";\nmain :: () {}\n'
    )
    run(
        "reject-first-list-program-setting",
        [negative / "first-list.jai", "-check"],
        status=1,
        diagnostic="Too many module parameters",
    )
    run(
        "reject-non-main-program-setting",
        [negative / "non-main.jai", "-I", negative / "modules", "-check"],
        status=1,
        diagnostic="main program",
    )

    termination = (
        ("status", 37, "before exit 37\n"),
        ("failure", 1, "FAIL: independent WASM termination control\n1 failure(s)\n"),
    )
    for name, status, stdout in termination:
        source = root / f"tests/extensions/http-wasm-termination-{name}.jai"
        for target in ("macos", "wasm"):
            run(f"http-{name}-{target}-check", [source, "-check", "-os", target])
            if args.interpreter:
                run(
                    f"http-{name}-{target}-interp",
                    [source, "-interp", "-os", target],
                    status=status,
                    stdout=stdout,
                )

    if args.interpreter:
        cpu = "arm64" if platform.machine().lower() in ("arm64", "aarch64") else "x64"
        for setting in ("enabled", "disabled"):
            run(
                "parent-interpreter-" + setting,
                [protocol, "-interp", "-", setting],
                stdout="child configuration accepted\nparent protocol complete\n",
            )
            # Exercise the real Io parent with a non-network child main, including
            # its existing interpreter child-output path and ERROR/COMPLETE checks.
            child = output / (setting + "-child.jai")
            child.write_text(
                '#import "Basic";\n'
                f"#assert #exists(String_Builder.Buffer.ensured_count) == {str(setting == 'enabled').lower()};\n"
                f'main :: () {{ print("{setting} child output\\n"); }}\n'
            )
            run(
                "real-parent-child-output-" + setting,
                [
                    parent,
                    "-interp",
                    "-",
                    setting,
                    child,
                    output / "unused",
                    "interp",
                    cpu,
                ],
                stdout=setting + " child output\n",
            )

    (output / "compiler-sha256.txt").write_text(
        hashlib.sha256(compiler.read_bytes()).hexdigest() + "\n"
    )
    raise SystemExit(any(not row["passed"] for row in rows))


if __name__ == "__main__":
    main()
