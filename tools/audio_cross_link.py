#!/usr/bin/env python3
"""Cross-link NEW audio fixtures against owned SDK artifacts; never executes them."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import struct
import subprocess

from audio_build_native import ROOT, PLAN

TRIPLES = {
    "macos-x64": "x86_64-apple-macosx11.0",
    "macos-arm64": "aarch64-apple-macosx11.0",
    "linux-x64": "x86_64-unknown-linux-gnu",
    "linux-arm64": "aarch64-unknown-linux-gnu",
    "windows-x64": "x86_64-pc-windows-gnu",
    "windows-arm64": "aarch64-pc-windows-msvc",
}
CASES = tuple(sorted(Path(entry["path"]).stem for entry in
                     json.loads((ROOT / "tests/audio/manifest.json").read_text())["cases"]
                     if Path(entry["path"]).stem != "windows-abi"))


def binary_target(path):
    data = path.read_bytes()
    if data[:4] == b"\xcf\xfa\xed\xfe":
        return "macos", {0x1000007: "x64", 0x100000c: "arm64"}.get(struct.unpack_from("<I", data, 4)[0])
    if data[:4] == b"\x7fELF" and data[4:6] == bytes((2, 1)):
        return "linux", {62: "x64", 183: "arm64"}.get(struct.unpack_from("<H", data, 18)[0])
    if data[:2] == b"MZ":
        position = struct.unpack_from("<I", data, 60)[0]
        if data[position:position+4] == b"PE\0\0":
            return "windows", {0x8664: "x64", 0xaa64: "arm64"}.get(struct.unpack_from("<H", data, position+4)[0])
    raise RuntimeError("Unrecognized linked executable format")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", choices=PLAN["platforms"], required=True)
    parser.add_argument("--artifacts", type=Path, required=True)
    parser.add_argument("--compiler", type=Path, default=ROOT / "target/compiler/debug" / ("jaic.exe" if os.name == "nt" else "jaic"))
    parser.add_argument("--linker", help="public target SDK linker/driver")
    parser.add_argument("--target", help="explicit SDK triple, e.g. Windows MSVC instead of GNU")
    args = parser.parse_args()
    entry = PLAN["platforms"][args.platform]
    artifacts = args.artifacts.resolve()
    metadata = json.loads((artifacts / "audio-build.json").read_text())
    if metadata["platform"] != args.platform:
        raise RuntimeError("SDK artifacts do not match requested target")
    for filename, digest in metadata["artifacts"].items():
        if hashlib.sha256((artifacts / filename).read_bytes()).hexdigest() != digest:
            raise RuntimeError("SDK artifact checksum mismatch")
    output = ROOT / "target/audio-cross-link" / args.platform
    output.mkdir(parents=True, exist_ok=True)
    shutil.copy2(ROOT / "tools/audio_run_cross.py", output / "run.py")
    shutil.copytree(ROOT / "tests/audio/fixtures", output / "fixtures", dirs_exist_ok=True)
    shutil.copytree(artifacts / "licenses", output / "licenses", dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"),
               JAIC_NATIVE_LIBS=str(artifacts), JAIC_CROSS_LIBS=str(artifacts))
    if args.linker:
        env["JAIC_LINKER"] = args.linker
    elif entry["os"] == "windows" and "libjai_audio_output.a" in metadata["artifacts"]:
        driver = shutil.which("x86_64-w64-mingw32-gcc" if entry["cpu"] == "x64" else "aarch64-w64-mingw32-clang")
        if not driver:
            raise RuntimeError("GNU Windows cross link requires an installed target SDK driver")
        env["JAIC_LINKER"] = driver
    if entry["os"] == "windows" and "jai_audio_output.lib" in metadata["artifacts"]:
        env["LIB"] = str(artifacts) + (";" + env["LIB"] if env.get("LIB") else "")
    target = args.target or TRIPLES[args.platform]
    if not args.target and entry["os"] == "windows":
        architecture = "x86_64" if entry["cpu"] == "x64" else "aarch64"
        environment = "gnu" if "libjai_audio_output.a" in metadata["artifacts"] else "msvc"
        target = architecture + "-pc-windows-" + environment
    records = []
    cases = CASES + (("windows-abi",) if entry["os"] == "windows" else ())
    for case in cases:
        for level in ("O0", "O2"):
            executable = output / (case + "-" + level + (".exe" if entry["os"] == "windows" else ""))
            executable.unlink(missing_ok=True)
            result = subprocess.run([str(args.compiler.resolve()), str(ROOT / "tests/audio" / (case + ".jai")),
                                     "-target", target, "-" + level, "-exe", str(executable)],
                                    cwd=ROOT, env=env, capture_output=True, text=True, timeout=60)
            if result.returncode or result.stderr:
                diagnostics = [line for line in result.stderr.splitlines() if "error:" in line or "undefined reference" in line]
                raise RuntimeError(f"{case}-{level} cross link failed: exit {result.returncode}; " + "; ".join(diagnostics[:6]))
            if binary_target(executable) != (entry["os"], entry["cpu"]):
                raise RuntimeError("Linked binary OS/CPU differs from requested SDK target")
            records.append({"file": executable.name, "sha256": hashlib.sha256(executable.read_bytes()).hexdigest(),
                            "linked": True, "executed": False})
            print(f"{args.platform} {case}-{level}: linked and OS/CPU verified; not executed", flush=True)
    (output / "result.json").write_text(json.dumps({"platform": args.platform, "target": target,
                                                  "records": records, "native_execution": False}, indent=2) + "\n")


if __name__ == "__main__":
    main()
