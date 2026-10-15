"""Independent public-wire/SDK fixture checks; no Jai distribution input."""
import csv
import io
from pathlib import Path
import struct
import sys

root = Path(sys.argv[1])
root.mkdir(parents=True, exist_ok=True)
if len(sys.argv) > 2 and sys.argv[2] == "fixtures":
    # Public BMP file format: BITMAPFILEHEADER + BITMAPINFOHEADER, 16x16 BGR.
    pixels = bytes((30, 20, 10)) * (16 * 16)
    header = struct.pack("<2sIHHI", b"BM", 54 + len(pixels), 0, 0, 54)
    dib = struct.pack("<IiiHHIIiiII", 40, 16, 16, 1, 24, 0, len(pixels), 0, 0, 0, 0)
    (root / "bitmap-ü.bmp").write_bytes(header + dib + pixels)
    sys.exit(0)

data = (root / "package.simp").read_bytes()
magic, version, flags, reserved, toc_offset = struct.unpack_from("<4sIIIq", data)
assert (magic, version, flags, reserved, toc_offset) == (b"simp", 1, 0, 0, 67)
toc_magic, reserved, count = struct.unpack_from("<4sIq", data, toc_offset)
assert (toc_magic, reserved, count) == (b"toc!", 0, 2)
cursor = toc_offset + 64
entries = []
for _ in range(count):
    size, = struct.unpack_from("<I", data, cursor)
    cursor += 4
    name = data[cursor:cursor + size].decode("utf-8")
    cursor += size
    assert data[cursor] == 0
    cursor += 1
    length, offset = struct.unpack_from("<qq", data, cursor)
    cursor += 16
    entries.append((name, data[offset:offset + length]))
assert cursor == len(data) and entries == [("zeta", bytes((1, 99, 3))), ("alpha", b"")]

csv_text = (root / "subtitles.csv").read_text()
rows = list(csv.reader(io.StringIO(csv_text)))
assert len(rows) == 3 and all(len(row) == 7 for row in rows)
assert rows[1] == ["262", "scene", 'Alice "A"', 'Hello <b>raw</b>\nSecond "line"', "gently", "scene_01.wav", "scene.wav"]
assert rows[2] == ["263", "outro", "BOB", "Bye", "", "outro_01.wav", "outro.wav"]
print("independent wire/CSV consumer ok")
