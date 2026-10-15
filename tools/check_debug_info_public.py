#!/usr/bin/env python3
"""Build owned public parser fixtures with the official SDK and this compiler only."""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import struct
import uuid
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "target"
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
JAIC = Path(os.environ["CARGO_TARGET_DIR"]) / "debug/jaic"
LINT = JAIC.with_name("jailint")
LLVM = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm")) / "bin"


def run(args):
    result = subprocess.run([str(x) for x in args], cwd=ROOT, env=ENV,
                            text=True, capture_output=True, timeout=60)
    if result.returncode:
        raise RuntimeError(f"{args}\n{result.stdout}\n{result.stderr}")
    return result.stdout, result.stderr


def dwarf_fixtures():
    oracle = ["check_sdk_units :: () {"]
    evidence = []
    linker = shutil.which("ld.lld")
    if not linker:
        raise RuntimeError("Official ld.lld is required to apply ELF debug relocations")
    for architecture, triple in [("x86", "i386-unknown-linux-gnu"),
                                 ("x64", "x86_64-unknown-linux-gnu"),
                                 ("arm64", "aarch64-unknown-linux-gnu")]:
        for optimization in [0, 2]:
            stem = TARGET / f"debug-info-{architecture}-o{optimization}"
            run([LLVM / "clang", "-target", triple, "-std=c11", "-gdwarf-4", "-g",
                 f"-O{optimization}", "-Wall", "-Wextra", "-Werror", "-c",
                 "tests/developer-tools/dwarf-types-native.c", "-o", stem.with_suffix(".o")])
            run([linker, "--entry=original_debug_types", stem.with_suffix(".o"), "-o", stem.with_suffix(".elf")])
            sections = {name: Path(f"{stem}-{name}.bin") for name in ["info", "abbrev", "line", "str"]}
            run([LLVM / "llvm-objcopy", *[arg for name, path in sections.items()
                 for arg in ["--dump-section", f".debug_{name}={path}"]], stem.with_suffix(".elf")])
            dump, _ = run([LLVM / "llvm-dwarfdump", "--debug-info", stem.with_suffix(".elf")])
            Path(f"{stem}-sdk.txt").write_text(dump)
            types = []
            for record in re.finditer(r"^0x([0-9a-f]+):\s+DW_TAG_([a-z0-9_]+)\n(.*?)(?=^0x[0-9a-f]+:|\Z)", dump, re.M | re.S):
                offset, tag, attrs = record.groups()
                if not (tag.endswith("_type") or tag == "typedef"):
                    continue
                name = re.search(r'DW_AT_name\s+\("([^"\n]*)"\)', attrs)
                size = re.search(r"DW_AT_byte_size\s+\((0x[0-9a-f]+|[0-9]+)\)", attrs)
                encoding = re.search(r"DW_AT_encoding\s+\(DW_ATE_([a-z_]+)\)", attrs)
                types.append(dict(offset=int(offset, 16), tag=tag.upper(), name=name[1] if name else "",
                                  size=int(size[1], 0) if size else 0, encoding=encoding[1].upper() if encoding else None))
            if len(types) < 7:
                raise RuntimeError("SDK fixture lacks the expected type coverage")
            oracle += ["    {", f"        info := load_bytes({json.dumps(str(sections['info']))});",
                       f"        abbrev := load_bytes({json.dumps(str(sections['abbrev']))});",
                       f"        lines := load_bytes({json.dumps(str(sections['line']))});",
                       f"        strings := load_bytes({json.dumps(str(sections['str']))});",
                       "        defer free(info.data); defer free(abbrev.data); defer free(lines.data); defer free(strings.data);",
                       "        parsed, ok := D.parse_dwarf_debug_info(info, abbrev, lines, strings);",
                       "        assert(ok && parsed.compilation_units.count == 1);",
                       "        defer release_info(*parsed);", "        unit := parsed.compilation_units[0];",
                       f"        assert(unit.types.count == {len(types)});"]
            for item in types:
                encoding = "." + item["encoding"] if item["encoding"] else "cast(D.Dwarf_Base_Type) 0"
                oracle += ["        {", f"            actual := D.get_type(unit, {item['offset']});",
                           f"            assert(actual != null && actual.tag == .{item['tag']} && actual.name == {json.dumps(item['name'])});",
                           f"            assert(actual.size == {item['size']} && actual.base_type == {encoding});", "        }"]
            oracle += ["        check_unit(unit);", "    }"]
            evidence.append(dict(architecture=architecture, optimization=optimization, types=types,
                                 sections={name: hashlib.sha256(path.read_bytes()).hexdigest() for name, path in sections.items()}))
            if architecture == "x64" and optimization == 0:
                for name, path in sections.items():
                    shutil.copyfile(path, TARGET / f"debug-info-{name}.bin")
    oracle += ["}"]
    (TARGET / "debug-info-sdk.jai").write_text("\n".join(oracle) + "\n")
    synthetic_dwarf()
    return evidence


def synthetic_dwarf():
    def unit(payload):
        return struct.pack("<IHIB", len(payload) + 7, 4, 0, 8) + payload

    def literal(data):
        return "u8.[" + ", ".join(str(value) for value in data) + "]"

    # A concrete DIE inherits name/convention/main through a specification,
    # while its explicit false external attribute overrides the source's true.
    abbrev = bytes([1, 0x11, 1, 0, 0, 2, 0x2e, 0, 3, 8, 0x3f, 0x0c,
                    0x36, 0x0b, 0x6a, 0x19, 0, 0, 3, 0x2e, 0, 0x47, 0x13,
                    0x3f, 0x0c, 0, 0, 0])
    payload = bytes([1, 2]) + b"source\0" + bytes([1, 7, 3]) + struct.pack("<I", 12) + bytes([0, 0])
    output = ["check_synthetic_dwarf :: () {", "    {", f"        bytes := {literal(unit(payload))};",
              f"        abbrev := {literal(abbrev)};", "        parsed, ok := D.parse_dwarf_debug_info(bytes, abbrev, .{}, .{});",
              "        assert(ok && parsed.compilation_units[0].subprograms.count == 2);", "        defer release_info(*parsed);",
              "        for sub, index: parsed.compilation_units[0].subprograms {",
              '            assert(sub.name == "source" && sub.calling_convention == 7 && sub.is_main);',
              "            assert(sub.external == (index == 0));", "        }", "    }"]
    # Forward dependencies are resolved without recursive native calls. The
    # final DIE supplies the name; every earlier node inherits it.
    chain_abbrev = bytes([1, 0x11, 1, 0, 0, 2, 0x2e, 0, 0x31, 0x13, 0, 0,
                          3, 0x2e, 0, 3, 8, 0, 0, 0])
    chain = bytearray([1])
    for index in range(256):
        chain += bytes([2]) + struct.pack("<I", 12 + (index + 1) * 5)
    chain += bytes([3]) + b"end\0" + bytes([0])
    output += ["    {", f"        bytes := {literal(unit(chain))};", f"        abbrev := {literal(chain_abbrev)};",
               "        parsed, ok := D.parse_dwarf_debug_info(bytes, abbrev, .{}, .{});",
               "        assert(ok && parsed.compilation_units[0].subprograms.count == 257);", "        defer release_info(*parsed);",
               '        for sub: parsed.compilation_units[0].subprograms assert(sub.name == "end");', "    }", "}"]
    (TARGET / "debug-info-synthetic.jai").write_text("\n".join(output) + "\n")


def codeview_fixtures():
    output = ["check_sdk_types :: () {"]
    evidence = []
    for architecture, triple in [("x64", "x86_64-pc-windows-msvc"), ("arm64", "aarch64-pc-windows-msvc")]:
        for optimization in [0, 2]:
            stem = TARGET / f"debug-info-codeview-{architecture}-o{optimization}"
            run([LLVM / "clang", "-target", triple, "-g", "-gcodeview", f"-O{optimization}",
                 "-std=c11", "-Wall", "-Wextra", "-Werror", "-c", "tests/developer-tools/dwarf-types-native.c",
                 "-o", stem.with_suffix(".obj")])
            section = stem.with_suffix(".bin")
            run([LLVM / "llvm-objcopy", "--dump-section", f".debug$T={section}", stem.with_suffix(".obj")])
            dump, _ = run([LLVM / "llvm-readobj", "--codeview", stem.with_suffix(".obj")])
            Path(f"{stem}-sdk.txt").write_text(dump)
            kinds = re.findall(r"TypeLeafKind: LF_([A-Z0-9_]+) \(0x[0-9A-Fa-f]+\)", dump.split("CodeViewDebugInfo [", 1)[0])
            # LF_MEMBER appears within FIELDLIST and has no independent type index.
            kinds = [kind for kind in kinds if kind != "MEMBER"]
            output += ["    {", f"        bytes, read_ok := read_entire_file({json.dumps(str(section))});", "        assert(read_ok);",
                       "        defer free(bytes);", "        ok, types := D.parse_codeview_types(cast([] u8) bytes);",
                       f"        assert(ok && types.count == {len(kinds)});", "        defer release_cv_types(types);"]
            for index, kind in enumerate(kinds):
                output.append(f"        assert(types[{index}].kind == .{kind});")
            output += ["        for type: types {", "            if type.kind == .STRUCTURE {", "                record := cast(*D.Codeview_Struct) type;",
                       '                assert(record.name == "Original_Type_Pair");', "                if !(record.properties & .FWDREF) assert(record.size == 8 && record.num_fields == 2);",
                       "            }", "            if type.kind == .FIELDLIST {", "                list := cast(*D.Codeview_List) type;",
                       '                assert(list.members.count == 2 && list.members[0].name == "left" && list.members[1].name == "right");',
                       "                assert(list.members[0].offset == 0 && list.members[1].offset == 4);", "            }", "        }", "    }"]
            evidence.append(dict(architecture=architecture, optimization=optimization, kinds=kinds,
                                 section_sha256=hashlib.sha256(section.read_bytes()).hexdigest()))
            if architecture == "x64" and optimization == 0:
                shutil.copyfile(section, TARGET / "debug-info-codeview-types.bin")
    output += ["}"]
    (TARGET / "debug-info-codeview-sdk.jai").write_text("\n".join(output) + "\n")
    return evidence


def pdb_oracle():
    output = ["check_pdb_sdk :: (pdb: D.Pdb, architecture: string) {"]
    evidence = []
    for architecture in ["x64", "arm64"]:
        path = TARGET / f"developer-tools-msf-{architecture}.pdb"
        summary, _ = run([LLVM / "llvm-pdbutil", "dump", "-summary", "-types", "-ids", path])
        signature = int(re.search(r"Signature: (\d+)", summary)[1])
        age = int(re.search(r"Age: (\d+)", summary)[1])
        guid = uuid.UUID(re.search(r"GUID: \{([^}]+)\}", summary)[1])
        counts = list(map(int, re.findall(r"Showing (\d+) records", summary)))
        if len(counts) != 2:
            raise RuntimeError("SDK PDB type and ID counts are missing")
        output += [f"    if architecture == {json.dumps(architecture)} {{",
                   f"        assert(pdb.header.signature == {signature} && pdb.header.age == {age});",
                   f"        assert(pdb.tpi.count == {counts[0]} && pdb.ipi.count == {counts[1]});",
                   f"        assert(pdb.signature.Data1 == {guid.time_low} && pdb.signature.Data2 == {guid.time_mid} && pdb.signature.Data3 == {guid.time_hi_version});"]
        for index, byte in enumerate(guid.bytes[8:]):
            output.append(f"        assert(pdb.signature.Data4[{index}] == {byte});")
        output += ["        return;", "    }"]
        evidence.append(dict(architecture=architecture, signature=signature, guid=str(guid), age=age,
                             tpi_count=counts[0], ipi_count=counts[1], sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
    output += ["    assert(false);", "}"]
    (TARGET / "debug-info-pdb-sdk.jai").write_text("\n".join(output) + "\n")
    return evidence


def existing_regressions():
    # Generate the existing owned decoder/helper oracles independently. These
    # regressions supplement, and never replace, the public parser fixtures.
    import check_developer_dwarf_lines
    import check_developer_dwarf_line_wire
    import check_developer_dwarf_types
    import check_developer_dwarf_frames
    import check_developer_eh_frames
    import check_developer_codeview_strings
    for generator in [check_developer_dwarf_lines, check_developer_dwarf_line_wire,
                      check_developer_dwarf_types, check_developer_dwarf_frames,
                      check_developer_eh_frames, check_developer_codeview_strings]:
        generator.main()
    run([LLVM / "clang", "-target", "x86_64-unknown-linux-gnu", "-g", "-gdwarf-4", "-O0",
         "-c", "tests/developer-tools/dwarf-native.c", "-o", TARGET / "developer-tools-dwarf.o"])
    run([LLVM / "llvm-objcopy", "--dump-section", f".eh_frame={TARGET / 'developer-tools-eh-frame.bin'}", TARGET / "developer-tools-dwarf.o"])
    for architecture, triple in [("x64", "x86_64-pc-windows-msvc"), ("arm64", "aarch64-pc-windows-msvc")]:
        for name in ["codeview", "codeview-register"]:
            source = "codeview-lines" if name == "codeview" else name
            obj = TARGET / f"developer-tools-{name}-{architecture}.obj"
            binary = TARGET / f"developer-tools-{name}-{architecture}.bin"
            run([LLVM / "clang", "-target", triple, "-c", f"tests/developer-tools/{source}.c", "-o", obj])
            run([LLVM / "llvm-objcopy", "--dump-section", f".data={binary}", obj])
    return [ROOT / f"tests/developer-tools/{name}.jai" for name in ["dwarf-cfa", "dwarf-eh-frame", "dwarf-fde",
            "dwarf-line-query", "dwarf-line-wire", "dwarf-type-lookup", "codeview-strings", "msf-public",
            "msf-wire", "msf-page-bits", "codeview-lines", "codeview-register"]]


def main():
    TARGET.mkdir(exist_ok=True)
    evidence = dwarf_fixtures()
    # Original PDB producer and official SDK stream exports; no supplied binaries.
    import check_developer_msf
    check_developer_msf.main()
    codeview = codeview_fixtures()
    pdb = pdb_oracle()
    owned = [ROOT / path for path in ["stdlib/Debug_Info/module.jai",
             "stdlib/internal/developer-tools/dwarf-public.jai", "stdlib/internal/developer-tools/msf-streams.jai",
             "stdlib/internal/developer-tools/msf-wire.jai", "stdlib/internal/developer-tools/msf-page-bits.jai",
             "stdlib/Debug_Info/codeview-type-model.jai", "stdlib/Debug_Info/pdb-model.jai",
             "stdlib/internal/developer-tools/codeview-types.jai", "stdlib/internal/developer-tools/pdb-parser.jai",
             "stdlib/internal/developer-tools/codeview-truncate.jai", "tests/developer-tools/codeview-truncate.jai",
             "tests/developer-tools/codeview-test-support.jai", "tests/developer-tools/codeview-type-parser.jai",
             "tests/developer-tools/codeview-dump.jai", "tests/developer-tools/pdb-parser.jai", "tests/developer-tools/dwarf-public.jai", "tests/developer-tools/msf-parser.jai"]]
    generated = [TARGET / f"debug-info-{name}.jai" for name in ["sdk", "synthetic", "codeview-sdk", "pdb-sdk"]]
    run([TARGET / "jaifmt", "--config", ROOT / "jaifmt.toml", *generated])
    run([TARGET / "jaifmt", "--config", ROOT / "jaifmt.toml", "--check", *owned, *generated])
    fixtures = [ROOT / f"tests/developer-tools/{name}.jai" for name in ["dwarf-public", "msf-parser", "codeview-type-parser", "pdb-parser", "codeview-truncate", "codeview-dump"]]
    fixtures += existing_regressions()
    run([LINT, "-D", "warnings", ROOT / "stdlib/Debug_Info/module.jai",
         *fixtures])
    for fixture in fixtures:
        stdout, stderr = run([JAIC, fixture, "-interp"])
        output_ok = stdout == "ok\n" if fixture.stem != "codeview-dump" else stdout.endswith("ok\n") and "original_debug_entry" in stdout and "type 4097: int ()" in stdout
        if not output_ok or stderr:
            raise RuntimeError(f"Unexpected interpreter diagnostics: {stdout}\n{stderr}")
        for optimization in [0, 2]:
            exe = TARGET / f"{fixture.stem}-o{optimization}"
            run([JAIC, fixture, f"-O{optimization}", "-exe", exe])
            stdout, stderr = run([exe])
            output_ok = stdout == "ok\n" if fixture.stem != "codeview-dump" else stdout.endswith("ok\n") and "original_debug_entry" in stdout and "type 4097: int ()" in stdout
            if not output_ok or stderr:
                raise RuntimeError(f"Unexpected native diagnostics: {stdout}\n{stderr}")
    (ROOT / "docs/native/debug-info-public-evidence.json").write_text(json.dumps({
        "scope": "public DWARF4 parser metadata compared with relocated original SDK objects; CodeView record kinds/fields and PDB metadata compared with official SDK; public MSF streams compared with SDK exports; Mac interpreter/native O0/O2", "dwarf": evidence, "codeview": codeview, "pdb": pdb,
        "fixtures": [fixture.name for fixture in fixtures],
        "verification": ["formatter", "strict lint", "interpreter", "native O0", "native O2"]}, indent=2) + "\n")
    print("Public Debug_Info parser checks passed")


if __name__ == "__main__":
    main()
