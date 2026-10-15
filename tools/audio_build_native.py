#!/usr/bin/env python3
"""Build audio-owned native code and an opaque pinned official C decoder locally.

Never invokes the shared-root native builder. Native dependency content is compiled
as a library and is not inspected as Jai compatibility source.
"""
import hashlib
import argparse
import json
from pathlib import Path
import platform
import shutil
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "target/audio-native"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check-windows", action="store_true",
                        help="cross-compile owned Windows x64 adapter using the installed MinGW SDK")
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    system = platform.system()
    if system == "Darwin":
        shared, extension = ["-dynamiclib"], "dylib"
    elif system == "Linux":
        shared, extension = ["-shared", "-fPIC"], "so"
    else:
        raise SystemExit("This native builder currently supports macOS/Linux hosts.")
    source = json.loads((ROOT / "tools/native-libs.json").read_text())["sources"]["stb"]
    vendor = OUT / "official-c-dependencies"
    vendor.mkdir(exist_ok=True)
    path = vendor / "stb_vorbis.c"
    if not path.exists():
        url = f"https://raw.githubusercontent.com/{source['repository']}/{source['revision']}/stb_vorbis.c"
        data = urllib.request.urlopen(url, timeout=30).read()
        if hashlib.sha256(data).hexdigest() != source["files"]["stb_vorbis.c"]:
            raise RuntimeError("official stb_vorbis checksum mismatch")
        path.write_bytes(data)
    if hashlib.sha256(path.read_bytes()).hexdigest() != source["files"]["stb_vorbis.c"]:
        raise RuntimeError("cached official stb_vorbis checksum mismatch")
    license_path = OUT / "licenses/stb-LICENSE.txt"
    if not license_path.exists():
        data = urllib.request.urlopen(
            f"https://raw.githubusercontent.com/{source['repository']}/{source['revision']}/LICENSE", timeout=30).read()
        if hashlib.sha256(data).hexdigest() != source["files"]["LICENSE"]:
            raise RuntimeError("official stb license checksum mismatch")
        license_path.parent.mkdir(parents=True, exist_ok=True)
        license_path.write_bytes(data)
    commands = [
        ["clang", "-std=c11", "-O2", "-fPIC", "-c", str(path), "-o", str(OUT / "stb_vorbis.o")],
        ["ar", "rcs", str(OUT / "libstb_vorbis.a"), str(OUT / "stb_vorbis.o")],
        ["clang", *shared, str(OUT / "stb_vorbis.o"), "-o", str(OUT / f"libstb_vorbis.{extension}"), "-lm"],
    ]
    for command in commands:
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        if result.returncode:
            raise RuntimeError(f"native dependency build failed: {command[0]} exit {result.returncode}")
        warnings = result.stderr.count("warning:")
        if warnings:
            print(f"Official C decoder build reported {warnings} compiler warning(s); no warning suppression applied.")
    print("Built pinned official C stb_vorbis within this worktree.", flush=True)
    native = ROOT / "stdlib/internal/audio/native"
    libraries = (["-framework", "AudioToolbox", "-framework", "CoreAudio", "-framework", "CoreFoundation"]
                 if system == "Darwin" else ["-lasound"])
    check_owned(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", *shared,
                    str(native / "output.c"), "-o", str(native / f"libjai_audio_output.{extension}"),
                    *libraries])
    print("Built owned native output adapter against the host SDK.", flush=True)
    if args.check_windows:
        compiler = shutil.which("x86_64-w64-mingw32-gcc")
        if not compiler:
            raise SystemExit("Windows adapter check requires an installed public MinGW-w64 SDK.")
        check_owned([compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", "-shared",
                     str(native / "output.c"), "-o", str(OUT / "jai_audio_output-windows-x64.dll"),
                     "-lwinmm"])
        print("Cross-compiled Windows x64 adapter with warnings denied; no Windows execution claimed.", flush=True)


def check_owned(command):
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    if result.returncode or result.stderr:
        errors = [line for line in result.stderr.splitlines() if "error:" in line or "warning:" in line]
        raise RuntimeError(f"owned native build failed: exit {result.returncode}; " + "; ".join(errors[:6]))


if __name__ == "__main__":
    main()
