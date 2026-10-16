#!/usr/bin/env python3
"""Real Mach protection failure/retry; custom SDK helper requires native execution."""

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
    work = Path(tempfile.mkdtemp(prefix="unmapping-protection-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    fixture = ROOT / "tests/portable-stdlib/unmapping-protection-retention.jai"
    lifecycle = ROOT / "tests/portable-stdlib/unmapping-lifecycle.jai"
    helper = ROOT / "tests/portable-stdlib/native/unmapping-protection.c"
    identity = dict(
        shared_head=subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
        source_hashes={
            name: hashlib.sha256(body).hexdigest() for name, body in captured.items()
        },
        tests={
            str(path): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in [fixture, lifecycle, helper]
        },
        configuration_changes=["Basic/module.jai"],
        scope="Mac Mach SDK protection failure with reservation retained, real FREE retry. Native only: custom interpreter foreign helper unavailable.",
    )
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
        "sdk-helper",
        [
            "clang",
            "-std=c11",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-dynamiclib",
            "-fPIC",
            helper,
            "-o",
            work / "libtest_unmapping.dylib",
        ],
        env,
    ):
        raise SystemExit(1)
    source = work / "main.jai"
    source.write_text(
        "TEST_VM :: #library "
        + json.dumps(str(work / "test_unmapping"))
        + ";\n#load "
        + json.dumps(str(fixture))
        + ";\n"
    )
    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library))
        run(mode + ":lifecycle:interp", [compiler, lifecycle, "-interp"], env, "ok\n")
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if run(
                mode + ":" + optimization + ":build",
                [compiler, source, "-" + optimization, "-exe", executable],
                env,
            ):
                run(mode + ":" + optimization, [executable, mode], env, "ok\n")
            executable = work / (mode + "-lifecycle-" + optimization)
            if run(
                mode + ":lifecycle:" + optimization + ":build",
                [compiler, lifecycle, "-" + optimization, "-exe", executable],
                env,
            ):
                run(mode + ":lifecycle:" + optimization, [executable], env, "ok\n")
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    run("strict-lint", [target / "debug/jailint", "-D", "warnings", source], env)
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run(
                platform + ":" + cpu + ":source",
                [compiler, lifecycle, "-check", "-os", platform, "-cpu", cpu],
                env,
            )
            run(
                platform + ":" + cpu + ":owned-lint",
                [
                    target / "debug/jailint",
                    "-D",
                    "warnings",
                    "-os",
                    platform,
                    "-cpu",
                    cpu,
                    "--context",
                    lifecycle,
                    "--manifest",
                    work / (platform + "-" + cpu + "-lint.json"),
                    ROOT / "stdlib/Unmapping_Allocator/module.jai",
                    ROOT / "stdlib/internal/allocation/unmapping.jai",
                    ROOT / "stdlib/internal/allocation/virtual-memory.jai",
                ],
                env,
            )
    for path in [
        fixture,
        lifecycle,
        ROOT / "stdlib/Unmapping_Allocator/module.jai",
        ROOT / "stdlib/internal/allocation/unmapping.jai",
        ROOT / "stdlib/internal/allocation/virtual-memory.jai",
    ]:
        run("format:" + path.name, [target / "jaifmt", "--check", path], env)
    owned = [
        "Basic/module.jai",
        "Unmapping_Allocator/module.jai",
        "internal/allocation/unmapping.jai",
        "internal/allocation/virtual-memory.jai",
    ]
    assert all(
        (ROOT / "stdlib" / name).read_bytes() == captured[name] for name in owned
    ), "owned source changed"
    assert all(
        hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest
        for path, digest in identity["tests"].items()
    ), "test changed"
    assert all(
        (disabled / name).read_bytes() == body
        for name, body in captured.items()
        if name != "Basic/module.jai"
    ), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
