#!/usr/bin/env python3
"""Real relocated-package watcher linkage and native lifecycle on both Mac CPUs."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    subprocess.run(["python3", "-B", str(ROOT / "tools/build_portable_watcher.py")], check=True)
    helper = ROOT / "stdlib/internal/watching/native/libportable_watch.dylib"
    output = subprocess.check_output(["otool", "-D", str(helper)], text=True)
    identities = [line for line in output.splitlines() if not line.endswith(":")]
    if identities != ["@rpath/libportable_watch.dylib"] * 2:
        raise RuntimeError(f"watcher helper embeds nonrelocatable identity: {identities!r}")
    foundation.compose()
    directory = ROOT / "target/portable-watcher-package"
    original = directory / "initial-distribution"
    moved = directory / "moved-distribution"
    for path in [original, moved]:
        if path.exists():
            shutil.rmtree(path)
    library = original / "stdlib"
    shutil.copytree(foundation.LIBRARY, library)
    for relative in ["File_Watcher", "internal/watching", "Pool", "internal/allocation"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    for relative in ["macOS", "Objective_C"]:
        shutil.copytree(ROOT.parent / "bindings/stdlib" / relative, library / relative, dirs_exist_ok=True)
    original.rename(moved)
    library = moved / "stdlib"
    env = dict(os.environ, JAIC_STDLIB=str(library))
    env.pop("JAIC_NATIVE_LIBS", None)  # Child default test only; preserve parent overrides.
    compiler = Path(os.environ["CARGO_TARGET_DIR"]) / "debug/jaic"
    source = ROOT / "tests/portable-stdlib/file-watcher/lifecycle-no-assert.jai"
    for cpu, flags in [("host", []), ("x64", ["-target", "x86_64-apple-darwin"])]:
        for mode in ["-O0", "-O2"]:
            executable = directory / (cpu + mode)
            subprocess.run([str(compiler), str(source), *flags, mode,
                            "-exe", str(executable)], env=env, check=True)
            linked = subprocess.check_output(["otool", "-L", str(executable)], text=True)
            commands = subprocess.check_output(["otool", "-l", str(executable)], text=True)
            if "@rpath/libportable_watch.dylib" not in linked or str(ROOT / "stdlib/internal/watching") in linked:
                raise RuntimeError(f"native watcher still links producer-tree helper: {linked}")
            if str(library / "internal/watching/native") not in commands or original.exists():
                raise RuntimeError("native watcher does not search selected relocated distribution")
            result = subprocess.run([str(executable)], env=env, capture_output=True, text=True, timeout=15)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"native relocated watcher failed: {result.returncode} {result.stdout}{result.stderr}")
    print("Watcher universal install name, selected relocated distribution/rpath and actual ARM64/x64 native O0/O2 lifecycle pass; production package inclusion/deployment target remains coordinator gate")


if __name__ == "__main__":
    main()
