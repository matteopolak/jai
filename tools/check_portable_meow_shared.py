#!/usr/bin/env python3
"""Current shared Meow register/storage/vector gate; immutable own C-derived data."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="meow-shared-", dir=target))
    compiler = target / "debug/jaic"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    fixtures = [
        ROOT / ("tests/portable-stdlib/" + name + ".jai")
        for name in ["meow", "meow-vectors", "meow-dump"]
    ]
    owned = [
        ROOT / "stdlib/Meow_Hash/module.jai",
        *sorted((ROOT / "stdlib/internal/hash/meow").glob("*.jai")),
    ]
    vector = ROOT / "tests/portable-stdlib/fixtures/meow-vectors.bin"
    expected_digest = "b4b8af0a8629e1cdc1a9853486158126e7e5756e72a062682e4eb354765ff639"
    assert hashlib.sha256(vector.read_bytes()).hexdigest() == expected_digest
    hashes = {
        str(p): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in [*fixtures, *owned, vector]
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

    def run(name, command, expected="ok\n", status=0, diagnostic=None):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == status
            and (expected is None or result.stdout == expected)
            and (diagnostic is None or diagnostic in result.stderr)
            and (status != 0 or not result.stderr)
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
        expected = (
            "ok\n"
            if index < 2
            else "state\n"
            + "".join(f"{i}: {i * 2 + 1} {i * 2 + 2}\n" for i in range(8))
            + "ok\n"
        )
        run(source.stem + ":interp", [compiler, source, "-interp"], expected)
        for mode in ["O0", "O2"]:
            executable = work / (source.stem + "-" + mode)
            if run(
                source.stem + ":" + mode + ":build",
                [compiler, source, "-" + mode, "-exe", executable],
                "",
            ):
                run(source.stem + ":" + mode + ":native", [executable], expected)
        for platform in ["macos", "linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                name = source.stem + ":" + platform + ":" + cpu
                run(
                    name + ":source",
                    [compiler, source, "-check", "-os", platform, "-cpu", cpu],
                    "",
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
                        work / (name.replace(":", "-") + "-lint.json"),
                        *owned,
                        source,
                    ],
                    "",
                )
    run(
        "invalid-lane",
        [compiler, ROOT / "tests/portable-stdlib/negative/meow-lane.jai", "-check"],
        expected=None,
        status=1,
        diagnostic="#assert failed",
    )
    for path in [*fixtures, *owned]:
        run(
            "format:" + str(path.relative_to(ROOT)),
            [target / "jaifmt", "--check", path],
            "",
        )
    assert all(
        hashlib.sha256(Path(p).read_bytes()).hexdigest() == digest
        for p, digest in hashes.items()
    )
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
