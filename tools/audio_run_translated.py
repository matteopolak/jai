#!/usr/bin/env python3
"""Execute owned macOS x64 cross fixtures through installed Rosetta.

Records translated execution separately from native ARM64 and physical x64.
No translator is installed and no Windows/Linux target is executed here.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

from audio_build_native import ROOT, host_platform
from audio_cross_link import binary_target


def execute(path, env, expected, required):
    result = subprocess.run(["/usr/bin/arch", "-x86_64", str(path)], cwd=ROOT / "tests/audio",
                            env=env, capture_output=True, text=True, timeout=30)
    if result.returncode or result.stderr or result.stdout not in expected:
        lines = [line for line in (result.stderr + result.stdout).splitlines() if "failed" in line or "Bad CPU" in line]
        raise RuntimeError(f"translated {path.name}: exit {result.returncode}; " + "; ".join(lines[:3]))
    marker = result.stdout.splitlines()[0]
    if required and marker == "native-device-unavailable":
        raise RuntimeError("Required real SDK device unavailable; no device pass recorded")
    return {"binary": path.name, "marker": marker, "execution": "Rosetta x64 on macOS ARM64",
            "physical_x64_hardware": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-device", action="store_true")
    parser.add_argument("--require-multichannel", action="store_true")
    args = parser.parse_args()
    if host_platform() != "macos-arm64":
        parser.error("This runner only labels macOS x64 translation on a macOS ARM64 host")
    folder = ROOT / "target/audio-cross-link/macos-x64"
    linked = json.loads((folder / "result.json").read_text())
    if linked["platform"] != "macos-x64":
        raise RuntimeError("Cross-link record is not the expected target")
    env = dict(os.environ)
    for variable in ("JAIC_NATIVE_LIBS", "JAIC_CROSS_LIBS", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH", "DYLD_FALLBACK_LIBRARY_PATH"):
        env.pop(variable, None)
    records = []
    for entry in linked["records"]:
        path = folder / entry["file"]
        if path.parent != folder or hashlib.sha256(path.read_bytes()).hexdigest() != entry["sha256"]:
            raise RuntimeError("Owned cross binary path/checksum mismatch")
        if binary_target(path) != ("macos", "x64"):
            raise RuntimeError("Cross binary architecture mismatch")
        if path.name.startswith("signatures"):
            expected = ("ok\n",)
        elif path.name.startswith("controlled-output"):
            expected = ("native-2-channel-output-opened\nok\n", "native-6-channel-output-opened\nok\n",
                        "native-8-channel-output-opened\nok\n", "native-device-unavailable\nok\n")
        else:
            expected = ("native-device-opened\nok\n", "native-device-unavailable\nok\n")
        record = execute(path, env, expected, args.require_device)
        records.append(record)
        print(f"translated macos-x64 {path.name}: {record['marker']}; no physical x64 claim", flush=True)
    for channels in (6, 8):
        selected = dict(env, JAI_AUDIO_CHANNELS=str(channels))
        expected = (f"native-{channels}-channel-output-opened\nok\n", "native-device-unavailable\nok\n")
        for level in ("O0", "O2"):
            path = folder / ("controlled-output-" + level)
            record = execute(path, selected, expected, args.require_multichannel)
            record["logical_channels"] = channels
            records.append(record)
            print(f"translated macos-x64 logical {channels} {level}: {record['marker']}; physical speakers unverified", flush=True)
    (folder / "translated-runtime.json").write_text(json.dumps({"execution": "Rosetta x64 translation on macOS ARM64",
                                                               "physical_x64_hardware": False,
                                                               "records": records}, indent=2) + "\n")


if __name__ == "__main__":
    main()
