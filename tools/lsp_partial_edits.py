#!/usr/bin/env python3
"""Run source-built IDE correctness checks in timeout-isolated per-file processes.

This is a regression harness, not a benchmark. It never executes supplied binaries.
"""
import argparse
import concurrent.futures
import json
import hashlib
from pathlib import Path
import subprocess
import shutil
import sys
import uuid

ROOT = Path(__file__).resolve().parents[1]


def sources(paths):
    files = set()
    for path in paths:
        path = Path(path).resolve()
        if path.is_file():
            files.add(path)
        else:
            files.update(p for p in path.rglob("*.jai") if p.is_file())
    return sorted(files)


def build_worker():
    result = subprocess.run(
        ["cargo", "build", "-p", "jai-language-server", "--example", "partial_edit_coverage", "--message-format=json"],
        cwd=ROOT, capture_output=True, text=True, check=True,
    )
    for line in result.stdout.splitlines():
        msg = json.loads(line)
        if msg.get("reason") == "compiler-artifact" and msg.get("target", {}).get("name") == "partial_edit_coverage" and msg.get("executable"):
            # Later local builds must not change the binary midway through a sweep.
            worker_dir = ROOT / "artifacts/lsp-edits/workers"
            worker_dir.mkdir(parents=True, exist_ok=True)
            worker = worker_dir / str(uuid.uuid4())
            shutil.copy2(msg["executable"], worker)
            return str(worker)
    raise RuntimeError("cargo did not report the source-built worker")


def run_file(worker, file, args):
    command = [worker, str(file), str(args.stdlib.resolve()) if args.stdlib else "-", str(args.max_lines)]
    try:
        out = subprocess.run(command, capture_output=True, text=True, timeout=args.timeout, cwd=ROOT)
    except subprocess.TimeoutExpired as error:
        stderr = error.stderr or b""
        if isinstance(stderr, bytes):
            stderr = stderr.decode("utf-8", errors="replace")
        return {"file": str(file), "failures": [f"worker exceeded {args.timeout}s timeout"], "edits": 0, "assertions": 0, "stderr": stderr[-8192:]}
    try:
        report = json.loads(out.stdout)
    except (ValueError, TypeError):
        report = {"file": str(file), "failures": ["worker did not return JSON"], "edits": 0, "assertions": 0}
    if out.returncode and not report["failures"]:
        report["failures"].append(f"worker exit {out.returncode}")
    if out.stderr:
        report["stderr"] = out.stderr[-8192:]
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", type=Path)
    parser.add_argument("--retry-report", type=Path, help="rerun failed files from an earlier correctness report")
    parser.add_argument("--stdlib", type=Path, help="NEW independent stdlib, using prelude/module.jai")
    parser.add_argument("--max-lines", type=int, default=8, help="evenly sampled nonempty lines per file; 0 checks every line")
    parser.add_argument("--timeout", type=int, default=60, help="hard timeout per worker process")
    parser.add_argument("--jobs", type=int, default=2)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    if args.max_lines < 0 or args.timeout <= 0 or args.jobs <= 0:
        parser.error("limits must be nonnegative, with positive timeout/jobs")
    paths = list(args.paths)
    if args.retry_report:
        paths.extend(Path(r["file"]) for r in json.loads(args.retry_report.read_text())["files"] if r["failures"])
    files = sources(paths)
    if not files:
        parser.error("no Jai sources found")
    worker = build_worker()
    provenance = {"worker_sha256": hashlib.sha256(Path(worker).read_bytes()).hexdigest(),
                  "max_lines": args.max_lines, "stdlib": str(args.stdlib.resolve()) if args.stdlib else None,
                  "timeout_seconds": args.timeout}
    reports = []
    args.report.parent.mkdir(parents=True, exist_ok=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        pending = {pool.submit(run_file, worker, file, args): file for file in files}
        for future in concurrent.futures.as_completed(pending):
            report = future.result()
            reports.append(report)
            print(f"{len(reports)}/{len(files)} {'FAIL' if report['failures'] else 'PASS'} {pending[future]} ({report['edits']} edits)", flush=True)
            # Persist after each completed file so interruptions do not lose evidence.
            args.report.write_text(json.dumps({**provenance, "files": sorted(reports, key=lambda r: r["file"])}, indent=2) + "\n")
    failed = sum(bool(r["failures"]) for r in reports)
    print(f"{len(reports)} files, {sum(r['edits'] for r in reports)} edits, {sum(r['assertions'] for r in reports)} assertions, {failed} failed files")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
