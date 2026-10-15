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
from cleanroom_lint_contexts import TARGETS, checked_coverage, resolve_contexts, target_coverage_gaps

ROOT = Path(__file__).resolve().parents[1]


def owned_sources(root, baseline):
    stdlib = [p for p in (root / "stdlib").rglob("*.jai")
              if p.relative_to(root / "stdlib").parts[0] != "Extensions"
              or p.relative_to(root / "stdlib").parts[:2] == ("Extensions", "SDL3")]
    changed = subprocess.check_output([
        "git", "diff", "--name-only", "-z", "--diff-filter=ACMRT", baseline, "--", "tests"
    ], cwd=root).decode().split("\0")
    untracked = subprocess.check_output([
        "git", "ls-files", "--others", "--exclude-standard", "-z", "--", "tests"
    ], cwd=root).decode().split("\0")
    tests = [root / p for p in changed + untracked if p.endswith(".jai") and (root / p).is_file()]
    return sorted(set(stdlib + tests))


def hashes(paths, root):
    return {str(p.relative_to(root)): hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None
            for p in paths}


def input_snapshot(root, baseline, tools, controls):
    return {
        "head": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip(),
        "sources": hashes(owned_sources(root, baseline), root),
        "tools": hashes(tools, root),
        "controls": hashes(controls, root),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", required=True, help="permitted independent baseline OID")
    parser.add_argument("--format", action="store_true", help="format before checking")
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--contexts", type=Path, help="real enclosing programs and source-check targets; no library overlays")
    args = parser.parse_args()
    report = args.report.resolve()
    report.parent.mkdir(parents=True, exist_ok=True)
    logs = report.parent / (report.stem + "-logs")
    logs.mkdir(exist_ok=True)
    files = owned_sources(ROOT, args.baseline)
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
        return status

    if args.format:
        run("format", [formatter, "--config", ROOT / "jaifmt.toml", *files])
    controls = [ROOT / "jaifmt.toml", ROOT / "jailint.toml", Path(__file__).resolve(),
                ROOT / "tools/cleanroom_lint_contexts.py"]
    if args.contexts:
        controls.append(args.contexts.resolve())
    before = input_snapshot(ROOT, args.baseline, (formatter, linter), controls)
    result["inputs_before"] = before

    def finish_inputs():
        after = input_snapshot(ROOT, args.baseline, (formatter, linter), controls)
        result["inputs_after"] = after
        result["source_sha256"] = after["sources"]
        result["changed_during_checks"] = sorted(
            name for name in before["sources"].keys() | after["sources"].keys()
            if before["sources"].get(name) != after["sources"].get(name))
        result["source_stable"] = before["sources"] == after["sources"]
        result["inputs_stable"] = before == after

    run("format-check", [formatter, "--check", "--config", ROOT / "jaifmt.toml", *files])
    # Listing every owned file lets jailint associate #load fragments with their
    # real public module. Directory runs below remain useful diagnostic isolation,
    # but cannot alone establish coverage for fragments loaded across directories.
    if args.contexts:
        result["context_manifest"] = str(args.contexts.resolve())
        result["context_manifest_sha256"] = hashlib.sha256(args.contexts.read_bytes()).hexdigest()
        context_document = json.loads(args.contexts.read_text())
        jobs = resolve_contexts(context_document, ROOT)
        covered = set()
        target_coverage = {}
        result["lint_contexts"] = []
        for job in jobs:
            label = "context-" + job["id"]
            manifest = logs / (label + ".json")
            status = run(label, [linter, "-v", "-D", "warnings", "--config", ROOT / "jailint.toml",
                                 *TARGETS[job["target"]], "--context", job["source"],
                                 "--manifest", manifest, *job["paths"]])
            if not manifest.is_file():
                result["lint_contexts"].append({"id": job["id"], "clean": False,
                                                "error": "linter did not write its required coverage manifest"})
                continue
            coverage = checked_coverage(json.loads(manifest.read_text()), status)
            result["lint_contexts"].append({"id": job["id"], "target": job["target"],
                                           "manifest": str(manifest), **coverage})
            covered.update(coverage["visited_complete"])
            target_coverage.setdefault(job["target"], set()).update(coverage["visited_complete"])
        result["uncovered_owned_files"] = [str(p.relative_to(ROOT)) for p in files
                                           if str(p.resolve()) not in covered]
        result["uncovered_by_target"] = {
            target: [str(path.relative_to(ROOT)) for path in paths]
            for target, paths in target_coverage_gaps(
                files, target_coverage, context_document.get("required_targets", list(TARGETS))).items()}
        finish_inputs()
        report.write_text(json.dumps(result, indent=2) + "\n")
        failed = (sum(not c["passed"] for c in result["checks"])
                  + sum(not c["clean"] for c in result["lint_contexts"])
                  + sum(len(paths) for paths in result["uncovered_by_target"].values())
                  + int(not result["inputs_stable"]))
        print(f'{len(files)} owned files; {len(result["uncovered_owned_files"])} without clean complete context; {failed} failures; report: {report}')
        return int(failed != 0)
    result["context_mode"] = "legacy diagnostic isolation; target/context completeness not established"
    run("lint-combined", [linter, "-v", "-D", "warnings", "--config", ROOT / "jailint.toml", *files])
    groups = {}
    for file in files:
        relative = file.relative_to(ROOT)
        depth = 3 if relative.parts[:2] in (("stdlib", "internal"), ("stdlib", "Extensions")) else 2
        group = "/".join(relative.parts[:depth])
        groups.setdefault(group, []).append(file)
    for group, paths in sorted(groups.items()):
        run(group.replace("/", "-"), [linter, "-v", "-D", "warnings", "--config", ROOT / "jailint.toml", *paths])
    finish_inputs()
    report.write_text(json.dumps(result, indent=2) + "\n")
    failed = sum(not r["passed"] for r in result["checks"]) + int(not result["inputs_stable"])
    print(f'{len(files)} source files; {failed}/{len(result["checks"])} failed checks; report: {report}')
    return int(failed != 0)


if __name__ == "__main__":
    raise SystemExit(main())
