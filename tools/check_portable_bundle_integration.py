#!/usr/bin/env python3
"""Run actual macOS bundle/icon tools on original source fixtures in both modes."""
import argparse
import os
from pathlib import Path
import platform
import plistlib
import shutil
import struct
import subprocess
import zlib

ROOT = Path(__file__).resolve().parents[1]
if platform.system() != "Darwin":
    raise RuntimeError("native macOS bundle integration requires macOS tools")
output = ROOT / "target/portable-tests"
output.mkdir(parents=True, exist_ok=True)


def chunk(kind, body):
    return struct.pack(">I", len(body)) + kind + body + struct.pack(">I", zlib.crc32(kind + body))


image = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", 16, 16, 8, 6, 0, 0, 0))
pixels = (b"\0" + bytes([30, 90, 170, 255]) * 16) * 16
image += chunk(b"IDAT", zlib.compress(pixels)) + chunk(b"IEND", b"")
(output / "bundle-image.png").write_bytes(image)
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--jaic", type=Path, default=ROOT / "target/debug/jaic")
parser.add_argument("--stdlib", type=Path, default=ROOT / "stdlib")
args = parser.parse_args()
compiler = args.jaic.resolve(strict=True)
library = args.stdlib.resolve(strict=True)
env = dict(os.environ, JAIC_STDLIB=str(library))
source = ROOT / "tests/portable-stdlib/bundle-app/main.jai"
executable = output / "bundle-app-test"
executable.parent.mkdir(parents=True, exist_ok=True)
subprocess.run([str(compiler), str(source), "-exe", str(executable)],
               cwd=ROOT, env=env, check=True, timeout=60)
fixtures = output / "bundle app fixtures"
for command in [[str(compiler), "-interp", str(source), "--"], [str(executable)]]:
    if fixtures.exists():
        shutil.rmtree(fixtures)  # Only this original test's known output directory.
    result = subprocess.run(command, cwd=ROOT, env=env, check=True,
                            capture_output=True, text=True, timeout=60)
    assert result.stdout == "ok\n" and result.stderr == "", result
    assert not list(fixtures.glob("*.work-*")), "icon staging cleanup left directories"
    icon = (fixtures / "Converted.icns").read_bytes()
    assert icon[:4] == b"icns" and struct.unpack(">I", icon[4:8])[0] == len(icon)
    for size in [16, 32, 128, 256, 512]:
        for scale in [1, 2]:
            suffix = "@2x" if scale == 2 else ""
            image_path = fixtures / f"roundtrip.iconset/icon_{size}x{size}{suffix}.png"
            png = image_path.read_bytes()
            assert png[:8] == b"\x89PNG\r\n\x1a\n" and png[12:16] == b"IHDR"
            assert struct.unpack(">II", png[16:24]) == (size * scale, size * scale)
    for contents_only in [True, False]:
        bundle = fixtures / f"Example {str(contents_only).lower()}.app"
        with (bundle / "Contents/Info.plist").open("rb") as stream:
            metadata = plistlib.load(stream)
        assert metadata["CFBundleExecutable"] == "source program"
        assert metadata["CFBundlePackageType"] == "APPL" and metadata["CFBundleIconFile"] == "Icon.icns"
        assert (bundle / "Contents/Resources/Icon.icns").read_bytes() == icon
    shutil.rmtree(fixtures)
print("Real bundles, copied executable/resources, XML plist, ten ICNS sizes, failure diagnostics and cleanup pass both modes")
