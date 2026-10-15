#!/usr/bin/env python3
"""Run assigned Debug and preserved Debug_Info workflows with local evidence."""
import datetime
import json
import os
from pathlib import Path
import platform
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("This combined evidence recipe requires a Mac SDK host")
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    evidence = {"head": head, "timestamp": datetime.datetime.now(datetime.timezone.utc).isoformat(),
                "coverage": "Mac public interpreter/native O0/O2 and original SDK oracles; Windows SDK cross-build only",
                "limitations": ["No Windows/Linux native execution", "No Android compiler target",
                                "Foreign-thread/fatal callbacks executed native only"], "checks": []}
    report = ROOT / "docs/native/debug-public-evidence.json"
    suites = ["check_developer_debug_once.py", "check_developer_debug_lifecycle.py",
              "check_developer_debug_windows.py", "check_debug_info_public.py"]
    for suite in suites:
        result = subprocess.run([sys.executable, str(ROOT / "tools" / suite)], cwd=ROOT,
                                env=dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib")),
                                capture_output=True, text=True, timeout=300)
        evidence["checks"].append({"suite": suite, "status": result.returncode,
                                   "stdout": result.stdout, "stderr": result.stderr})
        report.write_text(json.dumps(evidence, indent=2) + "\n")
        if result.returncode:
            raise RuntimeError(f"{suite} failed; local diagnostics are in {report}")
        print(result.stdout, end="", flush=True)
    print("Combined assigned Debug and preserved Debug_Info checks passed; local evidence recorded")


if __name__ == "__main__":
    main()
