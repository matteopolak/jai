#!/usr/bin/env python3
"""Reviewed parser behavior; dynamic initializer remains a separate compiler gate."""
import os
from pathlib import Path
import shutil
import subprocess
import argparse
import check_portable_default_metaprogram as default

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dynamic-candidate", action="store_true",
                        help="run the positive initializer candidate; compiler gaps remain failures")
    args = parser.parse_args()
    library = default.compose()
    shutil.copytree(ROOT / "stdlib/Metaprogram_Plugins", library / "Metaprogram_Plugins", dirs_exist_ok=True)
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
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Metaprogram_Plugins/module.jai"),
                    str(library / "internal/build/plugin-arguments.jai"), str(source)], env=env, check=True)
    print("Metaprogram_Plugins parser: borrowed names/options, canonical record, no-plugin identity, grouping/terminator/ordinary arguments, empty names and safe invalid-index policy pass interpreter/native O0/O2 and strict lint; init_plugins NOT completed")
    if args.dynamic_candidate:
        candidate = library / "Metaprogram_Plugins/dynamic-init.jai"
        shutil.copyfile(ROOT / "pending/metaprogram-plugins-init.jai", candidate)
        facade = library / "Metaprogram_Plugins/module.jai"
        facade.write_text(facade.read_text() + '\n#load "dynamic-init.jai";\n')
        dynamic = ROOT / "tests/portable-stdlib/metaprogram-plugins/dynamic.jai"
        modules = ROOT / "tests/portable-stdlib/metaprogram-plugins/modules"
        result = subprocess.run([compiler, str(dynamic), "-import_dir", str(modules)], env=env,
                                capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "initialized 41\nok\n" or result.stderr:
            raise RuntimeError(f"positive dynamic plugin test remains blocked: {result.stdout}{result.stderr}")
        print("Positive dynamic-name plugin init and changed-name failure pass actual compiler workspace")


if __name__ == "__main__":
    main()
