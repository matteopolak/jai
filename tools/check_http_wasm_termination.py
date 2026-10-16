#!/usr/bin/env python3
"""Strict HTTP WASM checks, actual interpreter/WASI runs, and browser-host controls.

No native application is built or run. Output arguments are mandatory so that
the caller owns every generated module, capture and browser compiler artifact.
"""

import argparse
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    (
        "tests/extensions/http-wasm-termination-failure.jai",
        1,
        "FAIL: independent WASM termination control\n1 failure(s)\n",
    ),
    ("tests/extensions/http-wasm-termination-status.jai", 37, "before exit 37\n"),
    ("stdlib/Extensions/Http/tests/codec.jai", 0, "ok\n"),
    ("stdlib/Extensions/Http/tests/smuggling.jai", 0, "ok\n"),
    ("tests/extensions/http-codec-roundtrip.jai", 0, "ok\n"),
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, required=True)
    parser.add_argument("--browser-compiler", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    compiler = args.jaic.resolve(strict=True)
    browser = args.browser_compiler.resolve(strict=True)
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    results = []

    def run(label, command, expected_exit=0, expected_stdout=""):
        try:
            result = subprocess.run(
                command, cwd=ROOT, env=env, text=True, capture_output=True, timeout=90
            )
            passed = (
                result.returncode == expected_exit
                and not result.stderr
                and (expected_stdout is None or result.stdout == expected_stdout)
            )
            record = dict(
                label=label,
                command=command,
                expected_exit=expected_exit,
                expected_stdout=expected_stdout,
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        except subprocess.TimeoutExpired as error:
            record = dict(label=label, command=command, passed=False, error=str(error))
        results.append(record)
        (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
        print(f"{label}: {'PASS' if record['passed'] else 'FAIL'}", flush=True)
        return record["passed"]

    for source, status, stdout in CASES:
        name = Path(source).stem
        run(
            name + "-check", [str(compiler), "-check", "-no_dce", "-os", "wasm", source]
        )
        run(
            name + "-wasm-interp",
            [str(compiler), "-interp", "-os", "wasm", source],
            status,
            stdout,
        )
        for optimization in ["O0", "O2"]:
            module = output / f"{name}-{optimization}.wasm"
            built = run(
                name + "-" + optimization + "-build",
                [
                    str(compiler),
                    "-os",
                    "wasm",
                    "-" + optimization,
                    source,
                    "-exe",
                    str(module),
                ],
            )
            if built:
                run(
                    name + "-" + optimization + "-wasi",
                    [
                        "node",
                        "--no-warnings",
                        str(ROOT / "tools/wasi_run.mjs"),
                        str(module),
                    ],
                    status,
                    stdout,
                )
            else:
                results.append(
                    dict(
                        label=name + "-" + optimization + "-wasi",
                        passed=False,
                        not_run="WASM build failed",
                    )
                )
                (output / "results.json").write_text(
                    json.dumps(results, indent=2) + "\n"
                )
    run(
        "actual-browser-sandbox",
        [
            "node",
            str(ROOT / "tools/check_http_wasm_termination.mjs"),
            str(browser),
            str(output / "browser-results.json"),
        ],
        expected_stdout=None,
    )
    raise SystemExit(any(not result["passed"] for result in results))


if __name__ == "__main__":
    main()
