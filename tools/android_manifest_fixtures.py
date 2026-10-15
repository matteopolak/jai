"""Original independent AXML fixture, using the public Android wire ABI."""
from pathlib import Path
import struct
import zipfile

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / "tests/android-project/fixtures"


def make_fixtures():
    DEST.mkdir(parents=True, exist_ok=True)
    strings = ["manifest", "package", "jai.independent", "Unicode 😀"]
    payload = bytearray()
    offsets = []
    for value in strings:
        offsets.append(len(payload))
        encoded = value.encode("utf-16le")
        payload += struct.pack("<H", len(encoded) // 2) + encoded + b"\0\0"
    payload += bytes((-len(payload)) % 4)
    pool = struct.pack("<HHIIIIII", 1, 28, 28 + 4 * len(strings) + len(payload),
                       len(strings), 0, 0, 28 + 4 * len(strings), 0)
    pool += struct.pack("<4I", *offsets) + payload
    start = struct.pack("<HHIII", 0x102, 16, 56, 1, 0xffffffff)
    start += struct.pack("<II6H", 0xffffffff, 0, 20, 20, 1, 0, 0, 0)
    start += struct.pack("<IIIHBBI", 0xffffffff, 1, 2, 8, 0, 3, 2)
    end = struct.pack("<HHIIIII", 0x103, 16, 24, 1, 0xffffffff, 0xffffffff, 0)
    body = pool + start + end
    data = struct.pack("<HHI", 3, 8, 8 + len(body)) + body
    (DEST / "independent-utf16.axml").write_bytes(data)
    for name, method in [("stored", zipfile.ZIP_STORED), ("deflated", zipfile.ZIP_DEFLATED)]:
        with zipfile.ZipFile(DEST / f"independent-{name}.apk", "w", compression=method) as archive:
            info = zipfile.ZipInfo("AndroidManifest.xml", date_time=(2026, 1, 1, 0, 0, 0))
            info.compress_type = method
            archive.writestr(info, data)
    constants = []
    for label, path in [("UTF16", "independent-utf16.axml"), ("STORED", "independent-stored.apk"), ("DEFLATED", "independent-deflated.apk")]:
        escaped = "".join(f"\\x{byte:02x}" for byte in (DEST / path).read_bytes())
        constants.append(f'FIXTURE_{label} :: "{escaped}";')
    (DEST / "embedded.jai").write_text("\n".join(constants) + "\n")


if __name__ == "__main__":
    make_fixtures()
