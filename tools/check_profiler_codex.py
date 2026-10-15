#!/usr/bin/env python3
"""Focused Iprof/Codex validation, using this checkout and source-built tools."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    "codex-inspection", "codex-metrics", "codex-conditional", "codex-records", "codex-wire", "codex-export", "codex-lifecycle",
    "iprof-history-values", "iprof-smoothing", "iprof-stack-depth", "iprof-manual-clock",
    "iprof-options", "iprof-hooks", "iprof-size-boundary", "iprof-graphics", "iprof-frames", "iprof-automatic", "iprof-report", "iprof-traverse", "iprof-client-setup", "iprof-public-state",
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jaic", type=Path, default=ROOT / "target/debug/jaic")
    parser.add_argument("--jailint", type=Path, default=ROOT / "target/debug/jailint")
    args = parser.parse_args()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    report = ROOT / "target/profiler-codex-checks.json"
    evidence = {"complete": False, "commands": []}
    owned = [ROOT / "stdlib/Iprof/module.jai", ROOT / "stdlib/Codex/module.jai"]
    owned += list((ROOT / "stdlib/internal/developer-tools").glob("iprof-*.jai"))
    owned += list((ROOT / "stdlib/internal/developer-tools").glob("codex-*.jai"))
    owned += list((ROOT / "stdlib/internal/developer-tools/profiling").rglob("*.jai"))
    evidence["source_sha256"] = {str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sorted(owned)}
    report.parent.mkdir(parents=True, exist_ok=True)

    def record(command, result, expectation):
        evidence["commands"].append({"command": [str(x) for x in command],
                                     "expected": expectation, "exit_code": result.returncode,
                                     "stdout": result.stdout, "stderr": result.stderr})
        report.write_text(json.dumps(evidence, indent=2) + "\n")

    def run(command, expected=None):
        result = subprocess.run([str(x) for x in command], cwd=ROOT, env=env,
                                text=True, capture_output=True, timeout=60)
        record(command, result, "success")
        if result.returncode or result.stderr or (expected is not None and result.stdout != expected):
            raise RuntimeError(f"{command}: exit {result.returncode}\n{result.stdout}\n{result.stderr}")
        return result.stdout

    for optimization in [0, 2]:
        child = ROOT / f"target/profiler-codex-plugin-child-o{optimization}"
        run([args.jaic, ROOT / "tests/developer-tools/codex-plugin-input.jai", f"-O{optimization}", "-exe", child,
             "+Codex", "-export_file", ROOT / "target/profiler-codex-export.codex"])
        run([child], expected="ok\n")

    for optimization in [0, 2]:
        for minimum in [0, 999999]:
            child = ROOT / f"target/profiler-codex-iprof-o{optimization}-n{minimum}"
            output = ROOT / "target/profiler-codex-iprof-child.csv"
            run([args.jaic, ROOT / "tests/developer-tools/iprof-plugin-input.jai", f"-O{optimization}", "-exe", child,
                 "+Iprof", "-min_size", minimum, "-csv", output])
            run([child], expected="ok\n")
            rows = list(csv.DictReader(output.read_text().splitlines()[1:]))
            by_name = {row["name"]: row for row in rows}
            if "main" not in by_name or float(by_name["main"]["calls"]) != 1:
                raise RuntimeError("Iprof CLI did not record the actual entry point")
            if minimum == 0:
                if "leaf" not in by_name or float(by_name["leaf"]["calls"]) != 2 or float(by_name["leaf"]["self (ms)"]) < 5:
                    raise RuntimeError("Iprof CLI did not record actual deferred leaf timing")
                if float(by_name["main"]["hier (ms)"]) < float(by_name["leaf"]["self (ms)"]):
                    raise RuntimeError("Iprof CLI lost inclusive main timing")
            elif "leaf" in by_name:
                raise RuntimeError("Iprof CLI ignored minimum expression size")

    for optimization in [0, 2]:
        for include_modules in [False, True]:
            child = ROOT / f"target/profiler-codex-modules-o{optimization}-m{int(include_modules)}"
            output = ROOT / "target/profiler-codex-iprof-modules.csv"
            command = [args.jaic, ROOT / "tests/developer-tools/iprof-modules-input.jai", f"-O{optimization}",
                       "-I", ROOT / "tests/developer-tools/profiler-modules", "-exe", child,
                       "+Iprof", "-min_size", "0", "-csv", output]
            if include_modules:
                command.append("-modules")
            run(command)
            run([child], expected="ok\n")
            rows = list(csv.DictReader(output.read_text().splitlines()[1:]))
            names = {row["name"] for row in rows}
            if ("child_call" in names) != include_modules:
                raise RuntimeError("Iprof -modules did not control imported procedure instrumentation")

    for plugin, option in [("Iprof", ["-min_size", "3junk"]), ("Iprof", ["-csv"]), ("Codex", ["-export_file"]), ("Codex", ["-unknown"])]:
        result = subprocess.run([str(args.jaic), "tests/developer-tools/codex-plugin-input.jai", "-check", "+" + plugin, *option],
                                cwd=ROOT, env=env, text=True, capture_output=True, timeout=60)
        record([args.jaic, "tests/developer-tools/codex-plugin-input.jai", "-check", "+" + plugin, *option], result, "option rejection")
        if result.returncode == 0 or plugin + ":" not in result.stdout + result.stderr:
            raise RuntimeError(f"{plugin} accepted malformed options or failed on an unrelated error")
    for name in ["codex-put-aggregate", "codex-get-pointer"]:
        result = subprocess.run([str(args.jaic), f"tests/developer-tools/rejections/{name}.jai", "-check"],
                                cwd=ROOT, env=env, text=True, capture_output=True, timeout=60)
        record([args.jaic, f"tests/developer-tools/rejections/{name}.jai", "-check"], result, "scalar predicate rejection")
        if result.returncode == 0 or "requires a scalar" not in result.stderr:
            raise RuntimeError("Codex scalar predicate did not reject the unsupported type")

    formatter = ROOT / "target/profiler-codex-jaifmt"
    run([args.jaic, ROOT / "jaifmt/main.jai", "-O2", "-exe", formatter])
    source_paths = [ROOT / "stdlib/Iprof/module.jai", ROOT / "stdlib/Codex/module.jai",
                    ROOT / "stdlib/Codex/metrics-model.jai"]
    directory = ROOT / "stdlib/internal/developer-tools"
    source_paths += sorted(directory.glob("iprof-*.jai"))
    source_paths += sorted(directory.glob("codex-*.jai"))
    source_paths += sorted((directory / "profiling").rglob("*.jai"))
    tests = [ROOT / "tests/developer-tools" / (name + ".jai") for name in CASES]
    plugin_inputs = [ROOT / "tests/developer-tools" / (name + "-plugin-input.jai") for name in ["codex", "iprof"]]
    plugin_inputs += [ROOT / "tests/developer-tools/codex-conditional-input.jai", ROOT / "tests/developer-tools/iprof-modules-input.jai", ROOT / "tests/developer-tools/profiler-modules/Measured_Child/module.jai"]
    run([formatter, "--config", ROOT / "jaifmt.toml", "--check", *source_paths, *tests, *plugin_inputs])
    for name, source in zip(CASES, tests):
        run([args.jaic, source, "-interp"], expected="ok\n")
        for optimization in [0, 2]:
            exe = ROOT / f"target/profiler-codex-{name}-o{optimization}"
            run([args.jaic, source, f"-O{optimization}", "-exe", exe])
            run([exe], expected="ok\n")
        print(f"{name}: interpreter and native O0/O2 passed", flush=True)

    dump = ROOT / "tests/developer-tools/codex-dump.jai"
    commands = [[args.jaic, dump, "-interp"]]
    for optimization in [0, 2]:
        exe = ROOT / f"target/profiler-codex-dump-o{optimization}"
        run([args.jaic, dump, f"-O{optimization}", "-exe", exe])
        commands.append([exe])
    for command in commands:
        output = run(command)
        if "Codex v2:" not in output or "procedure conditional" not in output or "procedure allocation" not in output or not output.endswith("ok\n"):
            raise RuntimeError("Codex dump did not traverse the real file records or reject the bad header")
    tests.append(dump)

    # Client-setup #run creates sources that its strict lint pass consumes.
    run([args.jailint, "-D", "warnings", "-I", ROOT / "tests/developer-tools/profiler-modules", *tests, *plugin_inputs])

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
    for optimization in [0, 2]:
        run([ROOT / f"target/profiler-codex-hook-child-o{optimization}"], expected="ok\n")
        for offset in [0, 1]:
            run([ROOT / f"target/profiler-codex-size-o{optimization}-d{offset}"], expected="ok\n")
            file = ROOT / f"target/profiler-codex-size-o{optimization}-d{offset}.csv"
            rows = list(csv.DictReader(file.read_text().splitlines()[1:]))
            names = {row["name"] for row in rows}
            if "main" not in names or ("leaf" in names) != (offset == 0):
                raise RuntimeError("Iprof minimum-expression boundary differs from the compiler's own count")
    print("Public hook forwarding and exact expression boundaries: native O0/O2 children executed", flush=True)
    print("Generated client setup: all eight configurations executed at O0/O2", flush=True)

    consumer = ROOT / "target/profiler-codex-wire-consumer"
    run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
         ROOT / "tests/developer-tools/codex-wire-consumer.c", "-o", consumer])
    for file in ["profiler-codex-export.codex", "profiler-codex-lifecycle.codex"]:
        run([consumer, ROOT / "target" / file], expected="ok\n")
    print("Independent native C consumer: both real Codex exports validated", flush=True)

    # Source checks are evidence of target typing only, never native execution.
    for target in ["windows", "linux"]:
        for name in ["codex-records", "iprof-traverse"]:
            run([args.jaic, ROOT / "tests/developer-tools" / (name + ".jai"),
                 "-check", "-os", target, "-cpu", "x64"])
        print(f"{target} x64: canonical records and traversal source checks passed", flush=True)

    # Retain this full module check: known Context bootstrap ordering failures
    # remain errors, never exclusions or a claim of full lint coverage.
    run([args.jailint, "-D", "warnings", "-I", ROOT / "tests/developer-tools/profiler-modules", *source_paths, *tests, *plugin_inputs])
    evidence["complete"] = True
    report.write_text(json.dumps(evidence, indent=2) + "\n")


if __name__ == "__main__":
    main()
