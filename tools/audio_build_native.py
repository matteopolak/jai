#!/usr/bin/env python3
"""Build audio-owned native code and an opaque pinned official C decoder locally.

Never invokes the shared-root native builder. Native dependency content is compiled
as a library and is not inspected as Jai compatibility source.
"""
import hashlib
import json
from pathlib import Path
import platform
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "target/audio-native"


def main():
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
    subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", *shared,
                    str(native / "output.c"), "-o", str(native / f"libjai_audio_output.{extension}"),
                    *libraries], cwd=ROOT, check=True)
    print("Built owned native output adapter against the host SDK.", flush=True)


if __name__ == "__main__":
    main()
