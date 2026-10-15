#!/usr/bin/env python3
"""Exercise actual CPU font APIs with private original fonts and real FreeType.

Simp's reviewed NONE renderer is used for CPU metrics/features/glyph allocation;
this is not GPU rendering coverage. No shared binary font fixture is rewritten.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import struct
import subprocess
import tempfile
from portable_assertion_test_config import disabled_default_copy
from window_render_feature_font import build_font, checksum

ROOT = Path(__file__).resolve().parents[1]
FIXED_FONT = """STARTFONT 2.1
FONT -Cleanroom-Test-Medium-R-Normal--8-80-75-75-C-80-ISO10646-1
SIZE 8 75 75
FONTBOUNDINGBOX 8 8 0 0
STARTPROPERTIES 3
FONT_ASCENT 8
FONT_DESCENT 0
DEFAULT_CHAR 63
ENDPROPERTIES
CHARS 1
STARTCHAR QUESTION
ENCODING 63
SWIDTH 1000 0
DWIDTH 8 0
BBX 8 8 0 0
BITMAP
3C
42
02
0C
10
00
10
00
ENDCHAR
ENDFONT
"""


def without_gsub(font):
    # Rename the optional table in our original font, preserving SFNT validity.
    data = bytearray(font)
    count = struct.unpack_from(">H", data, 4)[0]
    head = None
    renamed = False
    for index in range(count):
        at = 12 + index * 16
        tag = bytes(data[at:at + 4])
        offset = struct.unpack_from(">I", data, at + 8)[0]
        if tag == b"GSUB":
            data[at:at + 4] = b"CRG0"
            renamed = True
        if tag == b"head":
            head = offset
    assert head is not None and renamed
    struct.pack_into(">I", data, head + 8, 0)
    struct.pack_into(">I", data, head + 8, (0xb1b0afba - checksum(data)) & 0xffffffff)
    assert checksum(data) == 0xb1b0afba
    return bytes(data)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--freetype-prefix", type=Path, default=Path("/opt/homebrew/opt/freetype"))
    args = parser.parse_args()
    prefix = args.freetype_prefix.resolve()
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="font-assertions-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    source = ROOT / "tests/portable-stdlib/font-default-assertions.jai"
    font = build_font(False)
    (work / "features.ttf").write_bytes(font)
    (work / "no-gsub.ttf").write_bytes(without_gsub(font))
    (work / "fixed.bdf").write_text(FIXED_FONT)
    inputs = [work / "features.ttf", work / "no-gsub.ttf", work / "fixed.bdf"]
    immutable = [ROOT / "tests/window-render/assets" / name
                 for name in ["feature-font.ttf", "filtered-feature-font.ttf"]]
    input_hashes = {str(path): digest(path) for path in inputs + immutable}
    sdk_files = [prefix / "lib/libfreetype.dylib"]
    sdk_files.extend(prefix / "include/freetype2/freetype" / name
                     for name in ["freetype.h", "tttables.h"])
    identity = dict(
        shared_head=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        source_hashes={name: hashlib.sha256(data).hexdigest() for name, data in captured.items()},
        compiler_sha256=digest(compiler), test_sha256=digest(source), inputs=input_hashes,
        sdk={str(path): digest(path) for path in sdk_files},
        configuration_changes=["Basic/module.jai"],
        configuration_diff="Basic/module.jai existing default ENABLE_ASSERT true -> false",
        scope="Actual FreeType CPU font API; original private SFNT inputs, not GPU/window/device coverage.",
    )
    (work / "identity.json").write_text(json.dumps(identity, indent=2) + "\n")
    rows = []

    def run(name, command, env, expected):
        result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=120)
        passed = result.returncode == 0 and result.stdout == expected and not result.stderr
        rows.append(dict(name=name, command=list(map(str, command)), exit=result.returncode,
                         stdout=result.stdout, stderr=result.stderr, passed=passed))
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return passed

    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library), DYLD_LIBRARY_PATH=str(prefix / "lib"),
                   LIBRARY_PATH=str(prefix / "lib"))
        for case in ["metrics", "features", "glyphsize", "sdk-error"]:
            fixture = work / ("fixed.bdf" if case == "sdk-error" else
                              "features.ttf" if case == "features" else "no-gsub.ttf")
            run(mode + ":interp:" + case,
                [compiler, source, "-interp", "--", mode, case, fixture], env, "ok\n")
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if not run(mode + ":" + optimization + ":build",
                       [compiler, source, "-" + optimization, "-exe", executable], env, ""):
                continue
            for case in ["metrics", "features", "glyphsize", "sdk-error"]:
                fixture = work / ("fixed.bdf" if case == "sdk-error" else
                                  "features.ttf" if case == "features" else "no-gsub.ttf")
                run(mode + ":" + optimization + ":" + case,
                    [executable, mode, case, fixture], env, "ok\n")
    assert all(digest(Path(path)) == value for path, value in input_hashes.items()), "font fixture changed"
    owned = ["Basic/module.jai", "Simp/module.jai", "internal/rendering/dynamic-fonts.jai",
             "internal/rendering/font-features.jai"]
    assert all((ROOT / "stdlib" / name).read_bytes() == captured[name] for name in owned), "owned source changed"
    assert digest(source) == identity["test_sha256"], "test changed"
    assert all((disabled / name).read_bytes() == body for name, body in captured.items()
               if name != "Basic/module.jai"), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
