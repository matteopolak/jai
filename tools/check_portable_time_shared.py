#!/usr/bin/env python3
"""Reviewed owned Basic time/calendar APIs against actual shared sources."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="time-shared-", dir=target))
    compiler = target / "debug/jaic"
    fixtures = [
        ROOT / ("tests/portable-stdlib/" + name + ".jai")
        for name in [
            "apollo",
            "time-conversion",
            "calendar-text",
            "calendar-native",
            "apollo-caller-return",
            "elapsed-time",
            "time-configured/main",
            "filetime-kernel",
        ]
    ]
    fixtures[7] = ROOT / "stdlib/Basic/tests/portable-filetime-kernel.jai"
    fixtures.append(ROOT / "tests/portable-stdlib/time-float-contracts.jai")
    former_reduction = (
        ROOT / "tests/portable-stdlib/pending/apollo-negative-femtosecond-float.jai"
    )
    common = [
        ROOT / ("stdlib/internal/basic/" + name + ".jai")
        for name in ["apollo", "time-errors", "elapsed-time", "calendar-text"]
    ]
    unix = [ROOT / "stdlib/internal/basic/clock-calendar.jai"]
    windows = [
        ROOT / ("stdlib/internal/basic/" + name + ".jai")
        for name in ["filetime", "windows-clock", "windows-calendar"]
    ]
    kernel = ROOT / "stdlib/internal/time/filetime.jai"
    owned = [*common, *unix, *windows, kernel]
    captured = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in [*fixtures, *owned, former_reduction]
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
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), TZ="UTC0")
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
    source = fixtures[6]
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            name = f"configured:{platform}:{cpu}"
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
                    *common,
                    *(windows if platform == "windows" else unix),
                    source,
                ],
            )
    run(
        "private-filetime-lint",
        [
            target / "debug/jailint",
            "-D",
            "warnings",
            "--context",
            fixtures[7],
            kernel,
            fixtures[7],
        ],
    )
    run("caller-return-lint", [target / "debug/jailint", "-D", "warnings", fixtures[4]])
    run("former-negative-femtosecond:interp", [compiler, former_reduction, "-interp"])
    run(
        "former-negative-femtosecond:lint",
        [target / "debug/jailint", "-D", "warnings", former_reduction],
    )
    for path in [*fixtures, *owned, former_reduction]:
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
