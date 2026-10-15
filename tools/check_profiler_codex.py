#!/usr/bin/env python3
"""Focused Iprof/Codex validation, using this checkout and source-built tools."""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    "codex-inspection", "codex-metrics", "codex-records",
    "iprof-history-values", "iprof-stack-depth", "iprof-manual-clock",
    "iprof-report", "iprof-traverse", "iprof-client-setup", "iprof-public-state",
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, default=ROOT / "target/debug/jaic")
    parser.add_argument("--jailint", type=Path, default=ROOT / "target/debug/jailint")
    args = parser.parse_args()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))

    def run(command, expected=None):
        result = subprocess.run([str(x) for x in command], cwd=ROOT, env=env,
                                text=True, capture_output=True, timeout=60)
        if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
            raise RuntimeError(f"{command}: exit {result.returncode}\n{result.stdout}\n{result.stderr}")
        return result.stdout

    formatter = ROOT / "target/profiler-codex-jaifmt"
    run([args.jaic, ROOT / "jaifmt/main.jai", "-O2", "-exe", formatter])
    source_paths = [ROOT / "stdlib/Iprof/module.jai", ROOT / "stdlib/Codex/module.jai",
                    ROOT / "stdlib/Codex/metrics-model.jai"]
    directory = ROOT / "stdlib/internal/developer-tools"
    source_paths += sorted(directory.glob("iprof-*.jai"))
    source_paths += sorted(directory.glob("codex-*.jai"))
    source_paths += sorted((directory / "profiling").glob("*.jai"))
    tests = [ROOT / "tests/developer-tools" / (name + ".jai") for name in CASES]
    run([formatter, "--config", ROOT / "jaifmt.toml", "--check", *source_paths, *tests])
    for name, source in zip(CASES, tests):
        run([args.jaic, source, "-interp"], expected="ok\n")
        for optimization in [0, 2]:
            exe = ROOT / f"target/profiler-codex-{name}-o{optimization}"
            run([args.jaic, source, f"-O{optimization}", "-exe", exe])
            run([exe], expected="ok\n")
        print(f"{name}: interpreter and native O0/O2 passed", flush=True)

    # Client-setup #run creates sources that its strict lint pass consumes.
    run([args.jailint, "-D", "warnings", *source_paths, *tests])

    # The original client fixture builds these children with all eight
    # manual/graphics/history combinations; actually execute each one.
    for configuration in range(8):
        source = ROOT / f"target/developer-tools-iprof-client-input-c{configuration}.jai"
        run([formatter, "--config", ROOT / "jaifmt.toml", source])
        run([formatter, "--config", ROOT / "jaifmt.toml", "--check", source])
        run([args.jailint, "-D", "warnings", source])
        for optimization in [0, 2]:
            run([ROOT / f"target/developer-tools-iprof-client-c{configuration}-o{optimization}"],
                expected="ok\n")
    print("Generated client setup: all eight configurations executed at O0/O2", flush=True)

    # Source checks are evidence of target typing only, never native execution.
    for target in ["windows", "linux"]:
        for name in ["codex-records", "iprof-traverse"]:
            run([args.jaic, ROOT / "tests/developer-tools" / (name + ".jai"),
                 "-check", "-os", target, "-cpu", "x64"])
        print(f"{target} x64: canonical records and traversal source checks passed", flush=True)


if __name__ == "__main__":
    main()
