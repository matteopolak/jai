#!/usr/bin/env python3
"""Compile target SDK objects without claiming a linked library or runtime."""
import argparse
import hashlib
import json
from pathlib import Path
import shlex

from audio_build_native import ROOT, PLAN, command, opaque_decoder, verify_object


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", choices=PLAN["platforms"], required=True)
    parser.add_argument("--cc", required=True, help="real target compiler with public SDK/header flags")
    args = parser.parse_args()
    entry = PLAN["platforms"][args.platform]
    output = ROOT / "target/audio-object-check" / args.platform
    output.mkdir(parents=True, exist_ok=True)
    cc = shlex.split(args.cc)
    flags = ["-std=c11", "-O2"]
    if entry["os"] != "windows":
        flags += ["-fPIC"]
    native = ROOT / "stdlib/internal/audio/native"
    objects = []
    for source in [native / "output.c", ROOT / "tests/audio/native-output.c",
                   ROOT / "tests/audio/native-routing.c",
                   ROOT / "tests/audio/failure-injection/sdk-close.c"] + (
                   [ROOT / "tests/audio/native-windows-abi.c"] if entry["os"] == "windows" else []
                   ) + ([native / "focus.m"] if entry["os"] == "macos" else []):
        destination = output / (source.stem + ".o")
        destination.unlink(missing_ok=True)
        command([*cc, *flags, "-Wall", "-Wextra", "-Werror", "-I", native,
                 "-c", source, "-o", destination])
        verify_object(destination, entry)
        objects.append(destination)
    decoder = output / "stb_vorbis.o"
    decoder.unlink(missing_ok=True)
    command([*cc, *flags, "-c", opaque_decoder(output), "-o", decoder], owned=False)
    verify_object(decoder, entry)
    objects.append(decoder)
    record = {"platform": args.platform, "compiler": cc, "kind": "target SDK-header object compilation",
              "library_linked": False, "native_execution": False,
              "objects": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in objects}}
    (output / "result.json").write_text(json.dumps(record, indent=2) + "\n")
    print(f"{args.platform}: SDK-header objects compiled/OS-CPU verified; no CRT/library link or execution claim", flush=True)


if __name__ == "__main__":
    main()
