#!/usr/bin/env python3
"""Reviewed signed relative pointer widths, explicit bases and relocation."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="relative-pointers-shared-", dir=target))
    compiler = target / "debug/jaic"
    fixtures = [ROOT / "tests/portable-stdlib/relative-pointer-contracts.jai"]
    owned = [
        ROOT / "stdlib/Relative_Pointers/module.jai",
        ROOT / "stdlib/internal/memory/relative-pointers.jai",
    ]
    captured = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in [*fixtures, *owned]
    }
    (work / "identity.json").write_text(
        json.dumps(
            {
                "compiler_sha256": hashlib.sha256(compiler.read_bytes()).hexdigest(),
                "source_hashes": captured,
                "stdlib": str(ROOT / "stdlib"),
            },
            indent=2,
        )
        + "\n"
    )
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    rows = []

    def run(name, command, expected=""):
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

    for index, source in enumerate(fixtures):
        run(f"fixture{index}:interp", [compiler, source, "-interp"], "ok\n")
        for mode in ["O0", "O2"]:
            executable = work / f"fixture{index}-{mode}"
            if run(
                f"fixture{index}:{mode}:build",
                [compiler, source, "-" + mode, "-exe", executable],
            ):
                run(f"fixture{index}:{mode}:run", [executable], "ok\n")
        for platform in ["macos", "linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                name = f"fixture{index}:{platform}:{cpu}"
                run(
                    name + ":source",
                    [compiler, source, "-check", "-os", platform, "-cpu", cpu],
                )
                run(
                    name + ":lint",
                    [
                        target / "debug/jailint",
                        "-D",
                        "warnings",
                        "-os",
                        platform,
                        "-cpu",
                        cpu,
                        "--context",
                        source,
                        "--manifest",
                        work / (name.replace(":", "-") + ".json"),
                        *owned,
                        source,
                    ],
                )
    for path in [*fixtures, *owned]:
        run(
            "format:" + str(path.relative_to(ROOT)),
            [target / "jaifmt", "--check", path],
        )
    assert all(
        hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest
        for path, digest in captured.items()
    ), "owned source changed during verification"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
