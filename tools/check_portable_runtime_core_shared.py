#!/usr/bin/env python3
"""Reviewed Runtime data/output/startup/once behavior; isolated real shared executions."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="runtime-core-shared-", dir=target))
    compiler = target / "debug/jaic"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    fixtures = [
        ROOT / ("tests/portable-stdlib/" + name + ".jai")
        for name in [
            "runtime-core-contracts",
            "runtime-number-contracts",
            "runtime-once-threads",
            "runtime-temp-default",
        ]
    ]
    owned = [
        ROOT / "stdlib/Runtime_Support/module.jai",
        ROOT / "stdlib/internal/runtime/module.jai",
        ROOT / "stdlib/internal/runtime/faults.jai",
    ]
    hashes = {
        str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in [*owned, *fixtures]
    }
    (work / "identity.json").write_text(
        json.dumps(
            dict(
                compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
                stdlib=str(ROOT / "stdlib"),
                source_hashes=hashes,
            ),
            indent=2,
        )
        + "\n"
    )
    rows = []

    def run(name, command, output="", errors=""):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == 0
            and result.stdout == output
            and result.stderr == errors
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

    for source in fixtures:
        output, errors = "ok\n", ""
        if source.stem == "runtime-number-contracts":
            output = "0|18446744073709551615|ff|1010|ff|-37|9223372036854775807|done\nunsynchronized\nordinary\n"
            errors = "-25|111\nerror\n"
        run(source.stem + ":interp", [compiler, source, "-interp"], output, errors)
        for mode in ["O0", "O2"]:
            executable = work / (source.stem + "-" + mode)
            if run(
                source.stem + ":" + mode + ":build",
                [compiler, source, "-" + mode, "-exe", executable],
            ):
                run(source.stem + ":" + mode + ":native", [executable], output, errors)
        for platform in ["macos", "linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                name = source.stem + ":" + platform + ":" + cpu
                run(
                    name + ":source",
                    [compiler, source, "-check", "-os", platform, "-cpu", cpu],
                )
                checked = run(
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
                        work / (name.replace(":", "-") + "-lint.json"),
                        *owned,
                        source,
                    ],
                )
                if checked:
                    manifest = json.loads(
                        (work / (name.replace(":", "-") + "-lint.json")).read_text()
                    )
                    # The requested private module has a conditional Windows-only load.
                    # Count that source only in the Windows context, where it is visited.
                    inactive = (
                        {str(ROOT / "stdlib/internal/runtime/windows-io.jai")}
                        if platform != "windows"
                        else set()
                    )
                    visited = {
                        path
                        for context in manifest["contexts"]
                        for path in context["visited_files"]
                    }
                    passed = (
                        not manifest["incomplete"]
                        and set(manifest["unvisited_files"]) == inactive
                        and all(context["complete"] for context in manifest["contexts"])
                        and {str(path) for path in [*owned, source]} <= visited
                    )
                    rows.append(
                        dict(
                            name=name + ":active-context-coverage",
                            passed=passed,
                            inactive_foreign_backend=sorted(inactive),
                            unvisited_files=manifest["unvisited_files"],
                        )
                    )
                    (work / "results.json").write_text(
                        json.dumps(rows, indent=2) + "\n"
                    )
                    print(
                        name + ":active-context-coverage",
                        "PASS" if passed else "FAIL",
                        flush=True,
                    )
    for path in [*owned, *fixtures]:
        run(
            "format:" + str(path.relative_to(ROOT)),
            [target / "jaifmt", "--check", path],
        )
    assert all(
        hashlib.sha256(Path(p).read_bytes()).hexdigest() == digest
        for p, digest in hashes.items()
    )
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
