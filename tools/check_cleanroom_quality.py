#!/usr/bin/env python3
"""Run unchanged repository format/lint tools on integrated independent sources.

No overlays, peer checkout reads, warning suppressions or partial-compile passes.
Every directory has a separate linter process to bound tool state. Reports retain
all diagnostics and fail on incomplete compilation even when jailint returns zero.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", required=True, help="permitted independent baseline OID")
    parser.add_argument("--format", action="store_true", help="format before checking")
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    report = args.report.resolve()
    report.parent.mkdir(parents=True, exist_ok=True)
    logs = report.parent / (report.stem + "-logs")
    logs.mkdir(exist_ok=True)
    stdlib = [p for p in (ROOT / "stdlib").rglob("*.jai")
              if p.relative_to(ROOT / "stdlib").parts[0] != "Extensions"
              or p.relative_to(ROOT / "stdlib").parts[:2] == ("Extensions", "SDL3")]
    names = subprocess.check_output([
        "git", "diff", "--name-only", "--diff-filter=A", args.baseline, "HEAD", "--", "tests"
    ], cwd=ROOT, text=True).splitlines()
    files = sorted(set(stdlib + [ROOT / p for p in names if p.endswith(".jai")]))
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    formatter = ROOT / "target/jaifmt"
    linter = ROOT / "target/debug/jailint"
    result = {"stdlib": str(ROOT / "stdlib"), "source_files": len(files), "checks": [],
              "tool_sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in (formatter, linter)}}

    def run(label, command):
        try:
            process = subprocess.run(list(map(str, command)), cwd=ROOT, env=env,
                                     capture_output=True, text=True, timeout=180)
            output = process.stdout + process.stderr
            status = process.returncode
        except subprocess.TimeoutExpired as error:
            output = str(error)
            status = None
        (logs / (label + ".log")).write_text(output)
        incomplete = "did not compile completely" in output
        passed = status == 0 and not incomplete
        result["checks"].append({"label": label, "command": list(map(str, command)),
                                 "exit": status, "incomplete": incomplete, "passed": passed})
        report.write_text(json.dumps(result, indent=2) + "\n")
        print(f'{"PASS" if passed else "FAIL"} {label}', flush=True)

    if args.format:
        run("format", [formatter, "--config", ROOT / "jaifmt.toml", *files])
    run("format-check", [formatter, "--check", "--config", ROOT / "jaifmt.toml", *files])
    groups = {}
    for file in files:
        relative = file.relative_to(ROOT)
        depth = 3 if relative.parts[:2] in (("stdlib", "internal"), ("stdlib", "Extensions")) else 2
        group = "/".join(relative.parts[:depth])
        groups.setdefault(group, []).append(file)
    for group, paths in sorted(groups.items()):
        run(group.replace("/", "-"), [linter, "-v", "-D", "warnings", "--config", ROOT / "jailint.toml", *paths])
    result["source_sha256"] = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
    report.write_text(json.dumps(result, indent=2) + "\n")
    failed = sum(not r["passed"] for r in result["checks"])
    print(f'{len(files)} source files; {failed}/{len(result["checks"])} failed checks; report: {report}')
    return int(failed != 0)


if __name__ == "__main__":
    raise SystemExit(main())
