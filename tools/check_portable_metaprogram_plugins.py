#!/usr/bin/env python3
"""Reviewed parser and live initializer behavior against the production library."""
import os
from pathlib import Path
import subprocess
import check_portable_default_metaprogram as default

ROOT = Path(__file__).resolve().parents[1]


def main():
    library = default.compose()
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-metaprogram-plugins"
    output.mkdir(parents=True, exist_ok=True)
    source = ROOT / "tests/portable-stdlib/metaprogram-plugins/parser.jai"
    commands = [[compiler, "-interp", str(source)]]
    for level in ["-O0", "-O2"]:
        executable = output / ("parser" + level)
        subprocess.run([compiler, str(source), level, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "--context", str(source), "-D", "warnings", str(library / "Metaprogram_Plugins/module.jai"),
                    str(library / "internal/build/plugin-arguments.jai"),
                    str(library / "internal/build/plugin-initialization.jai"), str(source)], env=env, check=True)
    print("Metaprogram_Plugins parser/empty init: canonical borrowed records, grouping/terminator/no-plugin identity pass interpreter/native O0/O2 and full context-aware strict lint", flush=True)
    modules = ROOT / "tests/portable-stdlib/metaprogram-plugins/modules"
    cases = {"dynamic": "initialized 41\nok\n",
             "aggregate": "initialized 41\nconditional reject\ninitialized 41\nconditional accept\nok\n",
             "empty": "ok\n"}
    for name, expected in cases.items():
        fixture = ROOT / f"tests/portable-stdlib/metaprogram-plugins/{name}.jai"
        for flags, label in [(["-interp"], "interp"), (["-O0"], "O0"), (["-O2"], "O2")]:
            result = subprocess.run([compiler, str(fixture), *flags,
                                     *([] if label == "interp" else ["-exe", str(output / (name + label))]),
                                     "-import_dir", str(modules)], env=env, capture_output=True, text=True, timeout=60)
            if result.returncode or result.stdout != expected or result.stderr:
                raise RuntimeError(f"actual {name} initializer failed: {result.stdout}{result.stderr}")
        subprocess.run([str(binaries / "jailint"), "-I", str(modules), "-D", "warnings", str(fixture)], env=env, check=True)
    print("Active public dynamic names/parameters/workspace, aggregate init status/no-init options, real factory identities and empty/name consistency pass interpreter/O0/O2 builds and strict lint")
    for name, expected in [("invalid-module", "Deliberately_Unavailable_Plugin_Module"),
                           ("private-name", "initialization_requested")]:
        fixture = ROOT / f"tests/portable-stdlib/metaprogram-plugins/{name}.jai"
        result = subprocess.run([compiler, str(fixture), "-exe", str(output / name)],
                                env=env, capture_output=True, text=True, timeout=60)
        if result.returncode == 0 or expected not in result.stdout + result.stderr:
            raise RuntimeError(f"invalid module/public-visibility case accepted: {result.stdout}{result.stderr}")
    print("Ordinary unavailable-module diagnostics and private-helper visibility rejection remain intact")

if __name__ == "__main__":
    main()
