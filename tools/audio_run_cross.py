#!/usr/bin/env python3
"""Run a self-contained package of NEW audio cross binaries on its exact host.

No compiler or stdlib source is needed. Translated CPU execution is not selected;
Rosetta has a separate explicitly labeled runner.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import struct
import subprocess


def host_target():
    system = {"Darwin": "macos", "Linux": "linux", "Windows": "windows"}[platform.system()]
    machine = {"arm64": "arm64", "ARM64": "arm64", "aarch64": "arm64", "AMD64": "x64", "x86_64": "x64"}[platform.machine()]
    return system + "-" + machine


def target_of(path):
    data = path.read_bytes()
    if data[:4] == b"\xcf\xfa\xed\xfe":
        return "macos-" + {0x1000007: "x64", 0x100000c: "arm64"}[struct.unpack_from("<I", data, 4)[0]]
    if data[:4] == b"\x7fELF" and data[4:6] == bytes((2, 1)):
        return "linux-" + {62: "x64", 183: "arm64"}[struct.unpack_from("<H", data, 18)[0]]
    if data[:2] == b"MZ":
        offset = struct.unpack_from("<I", data, 60)[0]
        if data[offset:offset+4] == b"PE\0\0":
            return "windows-" + {0x8664: "x64", 0xaa64: "arm64"}[struct.unpack_from("<H", data, offset+4)[0]]
    raise RuntimeError("Unknown executable format")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package", type=Path, default=Path(__file__).resolve().parent)
    parser.add_argument("--require-device", action="store_true")
    parser.add_argument("--require-multichannel", action="store_true")
    args = parser.parse_args()
    package = args.package.resolve()
    linked = json.loads((package / "result.json").read_text())
    if linked["platform"] != host_target():
        parser.error("Package differs from this host; no cross/translated execution is labeled native")
    env = dict(os.environ)
    for variable in ("JAIC_STDLIB", "JAIC_NATIVE_LIBS", "JAIC_CROSS_LIBS", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH", "DYLD_FALLBACK_LIBRARY_PATH"):
        env.pop(variable, None)
    if os.name == "nt":
        system = Path(os.environ["SystemRoot"])
        env["PATH"] = os.pathsep.join(map(str, (package, system / "System32", system)))
    results = []
    for entry in linked["records"]:
        binary = package / entry["file"]
        if binary.parent != package or hashlib.sha256(binary.read_bytes()).hexdigest() != entry["sha256"]:
            raise RuntimeError("Cross package path/checksum mismatch")
        if target_of(binary) != host_target():
            raise RuntimeError("Executable target differs from host")
        case = binary.stem.rsplit("-O", 1)[0]
        if case == "controlled-output":
            expected = ("native-2-channel-output-opened\nok\n", "native-6-channel-output-opened\nok\n",
                        "native-8-channel-output-opened\nok\n", "native-device-unavailable\nok\n")
        elif case in {"compressed-stream", "concurrent-render-stop", "concurrent-factories",
                      "device-lifecycle", "entity-phase", "entity-lifecycle", "region-lifetime", "streams"}:
            expected = ("native-device-opened\nok\n", "native-device-unavailable\nok\n")
        else:
            expected = ("ok\n",)
        result = subprocess.run([str(binary)], cwd=package, env=env, capture_output=True, text=True, timeout=30)
        if result.returncode or result.stderr or result.stdout not in expected:
            raise RuntimeError(f"{binary.name}: runtime failed, exit {result.returncode}")
        marker = result.stdout.splitlines()[0]
        if args.require_device and marker == "native-device-unavailable":
            raise RuntimeError("Required native endpoint unavailable; no playback pass recorded")
        results.append({"binary": binary.name, "marker": marker, "execution": "exact-host native"})
        print(f"{host_target()} {binary.name}: {marker}", flush=True)
    for channels in (6, 8):
        for entry in linked["records"]:
            if not entry["file"].startswith("controlled-output"):
                continue
            binary = package / entry["file"]
            result = subprocess.run([str(binary)], cwd=package, env=dict(env, JAI_AUDIO_CHANNELS=str(channels)),
                                    capture_output=True, text=True, timeout=30)
            opened = f"native-{channels}-channel-output-opened\nok\n"
            if result.returncode or result.stderr or result.stdout not in (opened, "native-device-unavailable\nok\n"):
                raise RuntimeError("Logical multichannel runtime failed")
            if args.require_multichannel and result.stdout != opened:
                raise RuntimeError("Required logical multichannel SDK format unavailable")
            results.append({"binary": binary.name, "logical_channels": channels,
                            "marker": result.stdout.splitlines()[0], "execution": "exact-host native"})
            print(f"{host_target()} logical {channels} {binary.name}: {result.stdout.splitlines()[0]}", flush=True)
    (package / "runtime-result.json").write_text(json.dumps({"platform": host_target(), "results": results,
                                                            "physical_speakers_hotplug_focus": "not tested"}, indent=2) + "\n")


if __name__ == "__main__":
    main()
