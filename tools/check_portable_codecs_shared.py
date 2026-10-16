#!/usr/bin/env python3
"""Reviewed CRC/Base64/PCG surface against current shared production."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]
OWNED = [
    "Base64/module.jai",
    "Crc/module.jai",
    "PCG/module.jai",
    "internal/codecs/base64.jai",
    "internal/codecs/crc.jai",
    "internal/random/pcg.jai",
]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="codecs-shared-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    tests = [
        ROOT / "tests/portable-stdlib" / name
        for name in ["codec-contracts.jai", "codecs.jai"]
    ]
    negative = ROOT / "tests/portable-stdlib/negative/base64-decoder-store.jai"
    hashes = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in [*tests, negative]
    }
    (work / "identity.json").write_text(
        json.dumps(
            dict(
                shared_head=subprocess.check_output(
                    ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
                ).strip(),
                compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
                source_hashes={
                    name: hashlib.sha256(body).hexdigest()
                    for name, body in captured.items()
                },
                tests=hashes,
                configuration_changes=["Basic/module.jai"],
            ),
            indent=2,
        )
        + "\n"
    )
    rows = []

    def run(name, command, env, expected="", rejected=False):
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
        if rejected:
            errors = [
                line.split(": error: ", 1)[1]
                for line in result.stderr.splitlines()
                if ": error: " in line
            ]
            passed = (
                result.returncode != 0
                and result.stdout == ""
                and errors
                == ["cannot assign into the constant `B.BASE64_DECODER_TABLE`"]
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

    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library))
        # The explicit-check fixture verifies behavior without optional assertions.
        # The existing built-in self-test fixture is run only with assertions enabled.
        for index, source in enumerate(tests if mode == "enabled" else tests[:1]):
            run(
                mode + ":" + source.name + ":interp",
                [compiler, source, "-interp"],
                env,
                "ok\n",
            )
            for optimization in ["O0", "O2"]:
                executable = work / (mode + "-" + str(index) + "-" + optimization)
                if run(
                    mode + ":" + source.name + ":" + optimization + ":build",
                    [compiler, source, "-" + optimization, "-exe", executable],
                    env,
                ):
                    run(
                        mode + ":" + source.name + ":" + optimization,
                        [executable],
                        env,
                        "ok\n",
                    )
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    run("constant-store-rejected", [compiler, negative, "-check"], env, rejected=True)
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run(
                platform + ":" + cpu + ":source",
                [compiler, tests[0], "-check", "-os", platform, "-cpu", cpu],
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
                    tests[0],
                    "--manifest",
                    work / (platform + "-" + cpu + "-lint.json"),
                    *[ROOT / "stdlib" / name for name in OWNED],
                ],
                env,
            )
    for source in tests:
        run(
            "lint:" + source.name,
            [target / "debug/jailint", "-D", "warnings", source],
            env,
        )
    for path in [*tests, negative, *[ROOT / "stdlib" / name for name in OWNED]]:
        run("format:" + path.name, [target / "jaifmt", "--check", path], env)
    assert all(
        (ROOT / "stdlib" / name).read_bytes() == captured[name]
        for name in [*OWNED, "Basic/module.jai"]
    ), "owned source changed"
    assert all(
        hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest
        for path, digest in hashes.items()
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
