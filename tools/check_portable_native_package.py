#!/usr/bin/env python3
"""Relocate a composed package and execute its real private native crash helper."""
import os
from pathlib import Path
import platform
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("this native install-name/package gate requires actual macOS SDK tools")
    subprocess.run(["python3", "-B", str(ROOT / "tools/build_portable_runtime.py")], check=True)
    helper = ROOT / "stdlib/internal/runtime/crash-native/libportable_crash.dylib"
    identity = subprocess.check_output(["otool", "-D", str(helper)], text=True).splitlines()[1:]
    if identity != ["@rpath/libportable_crash.dylib"]:
        raise RuntimeError(f"private helper embeds a build-tree install name: {identity!r}")
    foundation.compose()
    output = ROOT / "target/portable-native-package"
    original = output / "initial-distribution"
    relocated = output / "relocated-distribution"
    for directory in [original, relocated]:
        if directory.exists():
            shutil.rmtree(directory)
    library = original / "stdlib"
    shutil.copytree(foundation.LIBRARY, library)
    runtime = library / "internal/runtime"
    shutil.copytree(ROOT / "stdlib/internal/runtime", runtime, dirs_exist_ok=True)
    shutil.copytree(ROOT / "stdlib/Runtime_Support", library / "Runtime_Support", dirs_exist_ok=True)
    original.rename(relocated)
    library = relocated / "stdlib"
    env = dict(os.environ)
    env.pop("JAIC_NATIVE_LIBS", None)  # Default package lookup; parent overrides unchanged.
    env["JAIC_STDLIB"] = str(library)
    result = subprocess.run(["python3", "-B", str(ROOT / "tools/check_portable_crash.py"),
                             "--stdlib", str(library)], env=env, capture_output=True, text=True, timeout=120)
    if result.returncode:
        raise RuntimeError(f"relocated package crash check failed: {result.stdout}{result.stderr}")
    executable = ROOT / "target/portable-tests/startup-on/startup-crash"
    linked = subprocess.check_output(["otool", "-L", str(executable)], text=True)
    if "@rpath/libportable_crash.dylib" not in linked or str(ROOT / "stdlib/internal/runtime/crash-native") in linked:
        raise RuntimeError(f"native program links the build-tree helper: {linked}")
    commands = subprocess.check_output(["otool", "-l", str(executable)], text=True)
    selected_directory = str(library / "internal/runtime/crash-native")
    if selected_directory not in commands or original.exists():
        raise RuntimeError("native program does not search the selected relocated distribution")
    print(result.stdout, end="")
    print("Private native helper: relocatable install name, relocated selected package/rpath and actual ON/OFF native crash behavior pass; no Homebrew/coordinator helper path or override feature")


if __name__ == "__main__":
    main()
