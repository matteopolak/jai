"""Original C objects and malformed Mach-O fixtures; SDK tools are format oracles."""
from pathlib import Path
import struct
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "target/executable-fixtures"


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    source = OUT / "answer.c"
    source.write_text("int object_value = 37;\nint object_zero;\n__attribute__((noinline)) int object_helper(int x) { return x + 5; }\nint object_answer(void) { return object_helper(object_value); }\n")
    for name, target in [("macho", "arm64-apple-macos14"), ("elf", "x86_64-linux-gnu"),
                         ("coff", "x86_64-pc-windows-msvc")]:
        subprocess.run(["xcrun", "clang", "-target", target, "-g", "-c", str(source),
                        "-o", str(OUT / (name + ".o"))], check=True)
    subprocess.run(["xcrun", "otool", "-hv", str(OUT / "macho.o")], check=True)
    subprocess.run(["xcrun", "clang", "-target", "x86_64-apple-macos14", "-c", str(source),
                    "-o", str(OUT / "macho-x64.o")], check=True)
    subprocess.run(["xcrun", "lipo", "-create", str(OUT / "macho.o"), str(OUT / "macho-x64.o"),
                    "-output", str(OUT / "universal.o")], check=True)
    subprocess.run(["xcrun", "lipo", "-info", str(OUT / "universal.o")], check=True)
    subprocess.run(["/opt/homebrew/bin/lld-link", "/entry:object_answer", "/subsystem:console", "/nodefaultlib",
                    "/debug", "/pdb:" + str(OUT / "answer.pdb"), "/out:" + str(OUT / "answer.exe"), str(OUT / "coff.o")], check=True)
    subprocess.run(["/opt/homebrew/opt/lld/bin/ld.lld", "-e", "object_answer", "-o", str(OUT / "elf-executable"),
                    str(OUT / "elf.o")], check=True)
    oracle = "/opt/homebrew/opt/llvm/bin/llvm-readobj"
    for name in ["macho", "elf", "coff"]:
        result = subprocess.run([oracle, "--file-headers", "--sections", "--symbols", str(OUT / (name + ".o"))],
                                check=True, text=True, capture_output=True)
        (OUT / (name + "-oracle.txt")).write_text(result.stdout)
        assert "object_answer" in result.stdout and "object_value" in result.stdout
    sdk = subprocess.check_output(["xcrun", "--show-sdk-path"], text=True).strip()
    assert (Path(sdk) / "usr/include/mach-o/loader.h").is_file()
    probe = OUT / "abi.c"
    probe.write_text('#include <mach-o/loader.h>\n#include <mach-o/nlist.h>\n'
                     '_Static_assert(sizeof(struct mach_header_64)==32,"header");\n'
                     '_Static_assert(sizeof(struct segment_command_64)==72,"segment");\n'
                     '_Static_assert(sizeof(struct section_64)==80,"section");\n'
                     '_Static_assert(sizeof(struct nlist_64)==16,"symbol");\n')
    subprocess.run(["xcrun", "clang", "-c", str(probe), "-o", str(OUT / "abi.o")], check=True)
    wire = bytearray((OUT / "macho.o").read_bytes())
    malformed = {}
    bad = wire.copy()
    struct.pack_into("<I", bad, 20, len(wire))
    malformed["commands-overrun"] = bad
    bad = wire.copy()
    struct.pack_into("<I", bad, 36, 0)
    malformed["zero-command"] = bad
    cursor = 32
    for _ in range(struct.unpack_from("<I", wire, 16)[0]):
        cmd, size = struct.unpack_from("<II", wire, cursor)
        if cmd == 0x19:
            bad = wire.copy()
            struct.pack_into("<I", bad, cursor + 64, 0xffffffff)
            malformed["sections-overrun"] = bad
            bad = wire.copy()
            struct.pack_into("<II", bad, cursor + 72 + 56, 0, 0x20000000)
            malformed["relocations-overflow"] = bad
        if cmd == 2:
            bad = wire.copy()
            symoff = struct.unpack_from("<I", wire, cursor + 8)[0]
            struct.pack_into("<I", bad, symoff, 0xffffffff)
            malformed["symbol-name-overrun"] = bad
            bad = wire.copy()
            struct.pack_into("<I", bad, cursor + 12, 0x10000000)
            malformed["symbols-overflow"] = bad
        cursor += size
    for name, data in malformed.items():
        (OUT / (name + ".o")).write_bytes(data)
    for wide in [False, True]:
        for big in [False, True]:
            endian = ">" if big else "<"
            stride = 32 if wide else 20
            offset = 8 + stride
            wire = struct.pack(endian + "II", 0xcafebabf if wide else 0xcafebabe, 1)
            wire += struct.pack(endian + ("iiQQII" if wide else "iiIII"), 12, 0, offset, 3, 0, *([0] if wide else []))
            (OUT / f"fat-{int(wide)}-{int(big)}.o").write_bytes(wire + b"abc")
            if wide:
                bad = bytearray(wire + b"abc")
                struct.pack_into(endian + "I", bad, 36, 1)
                (OUT / f"fat-reserved-{int(big)}.o").write_bytes(bad)
    wire = struct.pack(">II", 0xcafebabe, 2)
    wire += struct.pack(">iiIII", 12, 0, 48, 3, 0)
    wire += struct.pack(">iiIII", 7, 0, 49, 2, 0)
    (OUT / "fat-overlap.o").write_bytes(wire + b"abc")
    for name in ["elf", "coff"]:
        wire = bytearray((OUT / (name + ".o")).read_bytes())
        bad = wire.copy()
        if name == "elf":
            struct.pack_into("<Q", bad, 40, 0xfffffffffffffff8)
        else:
            struct.pack_into("<I", bad, 12, 0xffffffff)
        (OUT / (name + "-overflow.o")).write_bytes(bad)
        if name == "coff":
            bad = wire.copy()
            struct.pack_into("<H", bad, 2, 0x4001)
            (OUT / "coff-sections-overflow.o").write_bytes(bad)


if __name__ == "__main__":
    main()
