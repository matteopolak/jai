#!/usr/bin/env python3
"""Fresh source-matched Minimal gate with complete shared source-set drift rejection."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rust_sources():
    paths = {ROOT / "Cargo.toml", ROOT / "Cargo.lock"}
    paths.update(
        p
        for p in (ROOT / "crates").rglob("*")
        if p.is_file() and (p.suffix in {".rs", ".c", ".h"} or p.name == "Cargo.toml")
    )
    return {str(p.relative_to(ROOT)): digest(p) for p in sorted(paths)}


def shared_sources():
    paths = set((ROOT / "stdlib").rglob("*.jai"))
    paths.update((ROOT / "jaifmt").rglob("*.jai"))
    paths.update(
        (ROOT / "tests/portable-stdlib/pending/relative-add-file").rglob("*.jai")
    )
    paths.update(
        ROOT / p
        for p in [
            "tests/portable-stdlib/minimal-path-contracts.jai",
            "tests/portable-stdlib/minimal-build-contracts.jai",
            "tests/portable-stdlib/pending/child-build-options-projection.jai",
            "tools/check_portable_minimal_shared.py",
            "tools/check_portable_minimal_guarded.py",
            "docs/specs/stdlib/modules/minimal-metaprogram.md",
            "docs/specs/stdlib/modules/compiler.md",
        ]
    )
    return {str(p.relative_to(ROOT)): digest(p) for p in sorted(paths)}


def main():
    base = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="minimal-guarded-", dir=base))
    target = work / "tools"
    target.mkdir()
    temporary = work / "tmp"
    temporary.mkdir()
    rust = rust_sources()
    source = shared_sources()
    (target / "source-identity.json").write_text(
        json.dumps(dict(root=str(ROOT), source_hashes=rust), indent=2) + "\n"
    )
    (work / "input-identity.json").write_text(
        json.dumps(dict(compiler_sources=rust, shared_sources=source), indent=2) + "\n"
    )
    env = dict(
        os.environ,
        CARGO_TARGET_DIR=str(target),
        TMPDIR=str(temporary),
        JAIC_STDLIB=str(ROOT / "stdlib"),
        LLVM_SYS_231_PREFIX=os.environ.get(
            "LLVM_SYS_231_PREFIX", "/opt/homebrew/opt/llvm"
        ),
    )
    rows = []

    def run(name, command, status=0, stdout=None, diagnostic=None):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=180,
        )
        passed = (
            result.returncode == status
            and (stdout is None or result.stdout == stdout)
            and (diagnostic is None or diagnostic in result.stderr)
        )
        row = dict(
            name=name,
            command=list(map(str, command)),
            exit=result.returncode,
            stdout=result.stdout,
            stderr=result.stderr,
            passed=passed,
        )
        rows.append(row)
        (work / "commands.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return result

    built = run(
        "fresh-compiler-tools",
        ["cargo", "build", "--locked", "--offline", "-p", "jaic-cli", "-p", "jailint"],
    )
    if built.returncode == 0:
        formatted = run(
            "source-built-formatter",
            [
                target / "debug/jaic",
                ROOT / "jaifmt/main.jai",
                "-O2",
                "-exe",
                target / "jaifmt",
            ],
        )
        if formatted.returncode == 0:
            run(
                "focused-minimal",
                [sys.executable, ROOT / "tools/check_portable_minimal_shared.py"],
            )
            relative = ROOT / "tests/portable-stdlib/pending/relative-add-file/main.jai"
            for mode in ["direct", "helper", "explicit-location"]:
                run(
                    "relative-control:" + mode,
                    [
                        target / "debug/jaic",
                        relative,
                        "-add",
                        "#run,stallable run_relative_file(" + json.dumps(mode) + ");",
                    ],
                    status=1 if mode == "helper" else 0,
                    stdout=None if mode == "helper" else "child compiled\n",
                    diagnostic="helper/child.jai" if mode == "helper" else None,
                )
            run(
                "relative-controls-strict-lint",
                [
                    target / "debug/jailint",
                    "-D",
                    "warnings",
                    "--context",
                    relative,
                    "--manifest",
                    work / "relative-lint.json",
                    relative,
                    relative.parent / "helper/insertion.jai",
                ],
            )
            for path in sorted(relative.parent.rglob("*.jai")):
                run("format:" + path.name, [target / "jaifmt", "--check", path])
    end_rust, end_source = rust_sources(), shared_sources()
    rust_drift = sorted(
        p for p in rust.keys() | end_rust.keys() if rust.get(p) != end_rust.get(p)
    )
    shared_drift = sorted(
        p
        for p in source.keys() | end_source.keys()
        if source.get(p) != end_source.get(p)
    )
    children = sorted(target.glob("minimal-shared-*/results.json"))
    child_rows = json.loads(children[-1].read_text()) if children else []
    summary = dict(
        compiler_source_drift=rust_drift,
        shared_source_drift=shared_drift,
        source_guard_passed=not rust_drift and not shared_drift,
        focused_receipt=str(children[-1]) if children else None,
        focused_passed=sum(row["passed"] for row in child_rows),
        focused_failed=sum(not row["passed"] for row in child_rows),
        focused_failures=[row["name"] for row in child_rows if not row["passed"]],
        command_failures=[row["name"] for row in rows if not row["passed"]],
        tools={
            str(p.relative_to(target)): digest(p)
            for p in [
                target / "debug/jaic",
                target / "debug/jailint",
                target / "jaifmt",
            ]
            if p.exists()
        },
    )
    summary["passed"] = summary["source_guard_passed"] and all(
        row["passed"] for row in rows
    )
    (work / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print("receipt:", work, flush=True)
    print(json.dumps(summary, indent=2), flush=True)
    raise SystemExit(0 if summary["passed"] else 1)


if __name__ == "__main__":
    main()
