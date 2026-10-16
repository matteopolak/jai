#!/usr/bin/env python3
"""Actual AppKit/runtime checks with both default assertion configurations."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="cocoa-assertions-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    fixture = ROOT / "tests/portable-stdlib/cocoa-default-assertions.jai"
    helper = ROOT / "tests/portable-stdlib/native/cocoa-assertions.m"
    identity = {
        "compiler_sha256": hashlib.sha256(compiler.read_bytes()).hexdigest(),
        "source_hashes": {
            name: hashlib.sha256(body).hexdigest() for name, body in captured.items()
        },
        "tests": {
            str(path): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in [fixture, helper]
        },
        "configuration_changes": ["Basic/module.jai"],
        "scope": "Real AppKit policy and registered method; native Mac, no user window.",
    }
    (work / "identity.json").write_text(json.dumps(identity, indent=2) + "\n")
    rows = []

    def run(name, command, env, expected=""):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == 0 and result.stdout == expected and not result.stderr
        )
        rows.append(
            dict(
                name=name,
                command=list(map(str, command)),
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        )
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return passed

    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    if not run(
        "native-sdk-helper",
        [
            "clang",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-dynamiclib",
            "-fPIC",
            "-framework",
            "AppKit",
            helper,
            "-o",
            work / "libportable_cocoa_probe.dylib",
        ],
        env,
    ):
        raise SystemExit(1)
    source = work / "main.jai"
    source.write_text(
        "COCOA_PROBE :: #library "
        + json.dumps(str(work / "portable_cocoa_probe"))
        + ";\n#load "
        + json.dumps(str(fixture))
        + ";\n"
    )
    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library))
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if run(
                mode + ":" + optimization + ":build",
                [compiler, source, "-" + optimization, "-exe", executable],
                env,
            ):
                for case in ["application", "observer", "collision"]:
                    run(
                        mode + ":" + optimization + ":" + case,
                        [executable, mode, case],
                        env,
                        "ok\n",
                    )
    owned = [
        "internal/window/cocoa.jai",
        "internal/window/cocoa-queries.jai",
        "internal/input/cocoa-events.jai",
    ]
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    for cpu in ["x64", "arm64"]:
        run(
            cpu + ":source",
            [compiler, source, "-check", "-os", "macos", "-cpu", cpu],
            env,
        )
        run(
            cpu + ":lint",
            [
                target / "debug/jailint",
                "-D",
                "warnings",
                "-os",
                "macos",
                "-cpu",
                cpu,
                "--context",
                source,
                "--manifest",
                work / (cpu + "-lint.json"),
                *[ROOT / "stdlib" / name for name in owned],
                fixture,
            ],
            env,
        )
    for path in [fixture, *[ROOT / "stdlib" / name for name in owned]]:
        run("format:" + path.name, [target / "jaifmt", "--check", path], env)
    assert all(
        (ROOT / "stdlib" / name).read_bytes() == captured[name]
        for name in [*owned, "Basic/module.jai"]
    ), "owned source changed during verification"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
