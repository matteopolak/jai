#!/usr/bin/env python3
"""Run original Mac graphics catalogue regressions on the production stdlib.

Use a source-built compiler and the explicitly assigned CARGO_TARGET_DIR. The
native clipboard guard restores materialized items even if a child aborts.
No network, vendor inputs, alternate stdlib, or driver substitutes are used.
"""
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    "native-regressions/macos-clipboard-utf8.jai",
    "native-regressions/clipboard-round-trip.jai",
    "native-regressions/objc-window-levels.jai",
    "graphics-regressions/window-fullscreen-toggle.jai",
    "graphics-regressions/window-input-native-events.jai",
    "graphics-regressions/macos-window-context-reopen.jai",
]


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("real macOS is required")
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    compiler = target / "debug/jaic"
    output = target / "mac-graphics"
    output.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    guard = output / "clipboard-guard"
    subprocess.run(["clang", "-Wall", "-Wextra", "-Werror", "-fobjc-arc",
                    str(ROOT / "tests/window-render/clipboard-guard.m"),
                    "-framework", "AppKit", "-o", str(guard)], check=True)
    results = []
    evidence = {"host": {"os": platform.mac_ver()[0], "cpu": platform.machine()},
                "compiler": str(compiler), "stdlib": str(ROOT / "stdlib"), "results": results,
                "source_sha256": {}}
    inputs = [ROOT / "tests" / case for case in CASES] + [
        ROOT / "tests/window-render/clipboard-guard.m",
        ROOT / "stdlib/internal/clipboard/cocoa.jai",
        ROOT / "stdlib/internal/window/cocoa.jai",
        ROOT / "stdlib/internal/input/cocoa-events.jai",
        Path(__file__).resolve()]
    for path in inputs:
        evidence["source_sha256"][str(path.relative_to(ROOT))] = hashlib.sha256(path.read_bytes()).hexdigest()

    def run(command, name):
        completed = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True)
        (output / (name + ".stdout")).write_text(completed.stdout)
        (output / (name + ".stderr")).write_text(completed.stderr)
        return completed.returncode

    for case in CASES:
        source = ROOT / "tests" / case
        name = source.stem
        for mode in ["interp", "O0", "O2"]:
            record = {"source": case, "mode": mode}
            command = [str(compiler), str(source)]
            if mode == "interp":
                command.append("-interp")
            else:
                executable = output / (name + "-" + mode)
                executable.unlink(missing_ok=True)
                command += ["-" + mode, "-exe", str(executable)]
                record["compile_exit"] = run(command, name + "-" + mode + "-compile")
                command = [str(executable)]
            if record.get("compile_exit", 0) == 0:
                if "clipboard" in name:
                    command.insert(0, str(guard))
                record["runtime_exit"] = run(command, name + "-" + mode)
            results.append(record)
            print(json.dumps(record), flush=True)
            (output / "results.json").write_text(json.dumps(evidence, indent=2) + "\n")
    evidence["source_inputs_stable"] = all(
        evidence["source_sha256"][str(path.relative_to(ROOT))] == hashlib.sha256(path.read_bytes()).hexdigest()
        for path in inputs)
    (output / "results.json").write_text(json.dumps(evidence, indent=2) + "\n")
    return int(not evidence["source_inputs_stable"] or any(
        row.get("compile_exit", 0) != 0 or row.get("runtime_exit") != 0 for row in results))


if __name__ == "__main__":
    sys.exit(main())
