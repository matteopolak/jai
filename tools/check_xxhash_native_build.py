#!/usr/bin/env python3
"""Build pinned xxhash070 and execute upstream's complete v0.7.0 sanity checks.

Run on the target OS with its native SDK/toolchain. Windows ARM64 callers must
select --platform windows-arm64 even when their Python is an emulated x64 build.
Downloads, intermediates and outputs stay in this clean worktree.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

import build_native_libs as builder

SANITY_SOURCE = {
    "repository": "Cyan4973/xxHash",
    "revision": "v0.7.0",
    "files": {
        "xxhsum.c": "26feeeba850ed5264338c7637ffe22d536761962e1f83678ce6135a9d72dfbdf"
    },
}
PATCHED_HEADER_SHA256 = (
    "5c3b5f114944d49416d63367a838c9add83f1e67a65e7f99a74f76c026f2d43d"
)
EXPECTED_EXPORTS = set(
    """XXH128 XXH32 XXH32_canonicalFromHash XXH32_copyState
XXH32_createState XXH32_digest XXH32_freeState XXH32_hashFromCanonical XXH32_reset XXH32_update
XXH3_128bits XXH3_128bits_withSeed XXH3_64bits XXH3_64bits_withSeed XXH64
XXH64_canonicalFromHash XXH64_copyState XXH64_createState XXH64_digest XXH64_freeState
XXH64_hashFromCanonical XXH64_reset XXH64_update XXH_versionNumber""".split()
)


def run(command):
    subprocess.run(list(map(str, command)), check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", default=builder.host_dir())
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    platform = args.platform
    if platform not in {
        "windows-x64",
        "windows-arm64",
        "macos-x64",
        "macos-arm64",
        "linux-x64",
        "linux-arm64",
    }:
        parser.error("select a native Windows, macOS or Linux platform")
    if platform.split("-")[0] != builder.host_dir().split("-")[0]:
        parser.error(
            "this runner executes on the target OS; cross-link checks are separate"
        )
    if not platform.startswith("windows") and platform != builder.host_dir():
        parser.error(
            "the Unix builder uses the host compiler architecture; select the real host platform"
        )
    out = (args.out or builder.ROOT / "target/xxhash-native" / platform).resolve()
    if not out.is_relative_to(builder.ROOT):
        parser.error("--out must stay inside this checkout")
    out.mkdir(parents=True, exist_ok=True)
    work = out / "work"
    work.mkdir(exist_ok=True)
    tempfile.tempdir = str(work)
    manifest = json.loads(builder.MANIFEST.read_text())
    source = builder.fetch(manifest["sources"]["xxhash070"], out / "source")
    sanity = builder.fetch(SANITY_SOURCE, out / "sanity")
    if platform == "windows-arm64":
        with tempfile.TemporaryDirectory() as audit:
            patched = builder.prepare_xxhash_arm64_source(source, Path(audit))
            if (
                hashlib.sha256((patched / "xxh3.h").read_bytes()).hexdigest()
                != PATCHED_HEADER_SHA256
            ):
                raise RuntimeError("audited patched xxh3.h hash changed")
    builder.build(
        "xxhash070", manifest["libraries"]["xxhash070"], source, out, platform
    )

    # Include the hash-verified official CLI tests in a small test entry point.
    # BMK_checkResult* explicitly exit on mismatches, independently of assert.
    wrapper = out / "vectors.c"
    wrapper.write_text(
        '#define main xxhash_official_cli_main\n#include "xxhsum.c"\n'
        '#undef main\nint main(void) { BMK_sanityCheck(); puts("ok"); return 0; }\n'
    )
    compiler = (
        [
            "clang",
            f"--target={builder.WINDOWS_TRIPLES[platform]}",
            "-fms-runtime-lib=static",
        ]
        if platform.startswith("windows")
        else ["cc"]
    )
    flags = ["-O2", "-I", str(source), "-I", str(sanity)]
    static = out / builder.static_name("xxhash070", platform)
    if platform.startswith("windows"):
        shared = out / "xxhash070.dll"
        listing = subprocess.run(
            ["llvm-readobj", "--file-headers", "--coff-exports", str(shared)],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        (out / "dll-coff.txt").write_text(listing)
        machine = (
            "IMAGE_FILE_MACHINE_ARM64"
            if platform == "windows-arm64"
            else "IMAGE_FILE_MACHINE_AMD64"
        )
        if f"Machine: {machine} " not in listing:
            raise RuntimeError("wrong native DLL machine type")
        exports = re.findall(r"^  Name: (\S+)$", listing, re.MULTILINE)
        if set(exports) != EXPECTED_EXPORTS or len(exports) != len(EXPECTED_EXPORTS):
            raise RuntimeError("missing/unexpected xxhash DLL exports")
        definitions = out / "xxhash070.def"
        definitions.write_text(
            "LIBRARY xxhash070.dll\nEXPORTS\n"
            + "".join(f"  {name}\n" for name in exports)
        )
        shared_link = out / "xxhash070-import.lib"
        run(
            [
                "llvm-dlltool",
                "-m",
                "arm64" if platform == "windows-arm64" else "i386:x86-64",
                "-d",
                definitions,
                "-D",
                "xxhash070.dll",
                "-l",
                shared_link,
            ]
        )
        rpath = []
    else:
        shared_link = out / (
            "libxxhash070.dylib" if platform.startswith("macos") else "libxxhash070.so"
        )
        rpath = [f"-Wl,-rpath,{out}"]
    for kind, library in [("static", static), ("shared", shared_link)]:
        executable = out / ("vectors-" + kind + (".exe" if os.name == "nt" else ""))
        run([*compiler, *flags, wrapper, library, *rpath, "-o", executable])
        result = subprocess.run([str(executable)], capture_output=True, timeout=60)
        (out / (kind + "-stdout.bin")).write_bytes(result.stdout)
        (out / (kind + "-stderr.bin")).write_bytes(result.stderr)
        result.check_returncode()
        if result.stdout != b"ok\n" and result.stdout != b"ok\r\n":
            raise RuntimeError(f"{kind} vector output mismatch: {result.stdout!r}")
        if result.stderr:
            raise RuntimeError(f"{kind} vector stderr: {result.stderr!r}")
        print(
            f"passed official xxhash v0.7.0 sanity checks: {platform} {kind}",
            flush=True,
        )


if __name__ == "__main__":
    main()
