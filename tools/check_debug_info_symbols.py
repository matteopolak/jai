#!/usr/bin/env python3
"""Original COFF inline objects and public SDK symbol/annotation/source oracles."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct
from check_debug_info_public import ROOT, TARGET, LLVM, run

OPCODES = {"CodeOffset": "CODE_OFFSET", "ChangeCodeOffsetBase": "CHANGE_CODE_OFFSET_BASE",
           "ChangeCodeOffset": "CHANGE_CODE_OFFSET", "ChangeCodeLength": "CHANGE_CODE_LENGTH",
           "ChangeFile": "CHANGE_FILE", "ChangeLineOffset": "CHANGE_LINE_OFFSET",
           "ChangeLineEndDelta": "CHANGE_LINE_END_DELTA", "ChangeRangeKind": "CHANGE_RANGE_KIND",
           "ChangeColumnStart": "CHANGE_COLUMN_START", "ChangeColumnEndDelta": "CHANGE_COLUMN_END_DELTA",
           "ChangeCodeOffsetAndLineOffset": "CHANGE_CODE_OFFSET_AND_LINE_OFFSET",
           "ChangeCodeLengthAndCodeOffset": "CHANGE_CODE_LENGTH_AND_CODE_OFFSET", "ChangeColumnEnd": "CHANGE_COLUMN_END"}
PROCEDURES = {"LPROC32", "GPROC32", "LPROC32_ID", "GPROC32_ID"}


def annotations(body):
    result = []
    match = re.search(r"BinaryAnnotations \[\n(.*?)\n      \]", body, re.S)
    if not match:
        raise RuntimeError("SDK inline annotations are absent")
    for line in match[1].splitlines():
        if "Annotation Padding" in line:
            continue
        name, value = line.strip().split(": ", 1)
        opcode = OPCODES[name]
        item = dict(opcode=opcode)
        if name == "ChangeCodeOffsetAndLineOffset":
            parsed = re.fullmatch(r"\{CodeOffset: (0x[0-9A-Fa-f]+), LineOffset: (-?\d+)\}", value)
            item.update(first=int(parsed[1], 16), second=int(parsed[2]), second_signed=True)
        elif name == "ChangeCodeLengthAndCodeOffset":
            parsed = re.fullmatch(r"\{CodeOffset: (0x[0-9A-Fa-f]+), Length: (0x[0-9A-Fa-f]+)\}", value)
            item.update(first=int(parsed[2], 16), second=int(parsed[1], 16))
        else:
            item.update(first=int(value, 0), first_signed=name in {"ChangeLineOffset", "ChangeColumnEndDelta"})
        result.append(item)
    return result


def main():
    output = ["check_sdk_symbol_workflows :: () {"]
    evidence = []
    for architecture, triple in [("x64", "x86_64-pc-windows-msvc"), ("arm64", "aarch64-pc-windows-msvc")]:
        for optimization in [0, 2]:
            stem = TARGET / f"debug-info-symbols-{architecture}-o{optimization}"
            obj = stem.with_suffix(".obj")
            binary = stem.with_suffix(".bin")
            run([LLVM / "clang", "-target", triple, "-std=c11", "-g", "-gcodeview", f"-O{optimization}",
                 "-Wall", "-Wextra", "-Werror", "-c", "tests/developer-tools/codeview-inline-native.c", "-o", obj])
            run([LLVM / "llvm-objcopy", "--dump-section", f".debug$S={binary}", obj])
            dump, _ = run([LLVM / "llvm-readobj", "--codeview", obj])
            Path(f"{stem}-sdk.txt").write_text(dump)
            debug = dump.split("CodeViewDebugInfo [", 1)[1]
            symbols = []
            stack = []
            for record in re.finditer(r"^    (\w+) \{\n(.*?)^    \}\n", debug, re.M | re.S):
                body = record[2]
                kind_match = re.search(r"^      Kind: S_([A-Z_0-9]+) ", body, re.M)
                if not kind_match:
                    continue
                kind = kind_match[1]
                if kind in {"END", "PROC_ID_END", "INLINESITE_END"}:
                    if not stack:
                        raise RuntimeError("SDK scope-end is unmatched")
                    stack.pop()
                elif kind == "BLOCK32":
                    stack.append(None)
                elif kind in PROCEDURES | {"INLINESITE", "COMPILE", "COMPILE3"}:
                    item = dict(kind=kind, children=[])
                    if kind in PROCEDURES:
                        item.update(name=re.search(r"DisplayName: (.*)", body)[1],
                                    length=int(re.search(r"CodeSize: (0x[0-9A-Fa-f]+)", body)[1], 16),
                                    segment=int(re.search(r"Segment: (0x[0-9A-Fa-f]+)", body)[1], 16),
                                    offset=int(re.search(r"CodeOffset: [^\n]+\+(0x[0-9A-Fa-f]+)", body)[1], 16),
                                    type=int(re.search(r"FunctionType: [^\n]+\((0x[0-9A-Fa-f]+)\)", body)[1], 16))
                    if kind == "INLINESITE":
                        item.update(inlinee=int(re.search(r"Inlinee: [^\n]+\((0x[0-9A-Fa-f]+)\)", body)[1], 16), annotations=annotations(body))
                        parent = next((value for value in reversed(stack) if value is not None), None)
                        if parent is None:
                            raise RuntimeError("SDK inline site has no procedure parent")
                        symbols[parent]["children"].append(len(symbols))
                    if kind == "COMPILE3":
                        item.update(cpu=int(re.search(r"Machine: [^\n]+\((0x[0-9A-Fa-f]+)\)", body)[1], 16),
                                    language=int(re.search(r"Language: [^\n]+\((0x[0-9A-Fa-f]+)\)", body)[1], 16),
                                    compiler=re.search(r"VersionName: (.*)", body)[1],
                                    frontend=list(map(int, re.search(r"FrontendVersion: ([0-9.]+)", body)[1].split("."))),
                                    backend=list(map(int, re.search(r"BackendVersion: ([0-9.]+)", body)[1].split("."))))
                    symbols.append(item)
                    if kind in PROCEDURES | {"INLINESITE"}:
                        stack.append(len(symbols) - 1)
            if stack or not any(item["kind"] == "INLINESITE" for item in symbols):
                raise RuntimeError("Original SDK fixture lacks complete inline scopes")
            inlinees = []
            for record in re.finditer(r"^    InlineeSourceLine \{\n(.*?)^    \}", debug, re.M | re.S):
                body = record[1]
                inlinees.append(dict(inlinee=int(re.search(r"Inlinee: [^\n]+\((0x[0-9A-Fa-f]+)\)", body)[1], 16),
                                     file=int(re.search(r"FileID: [^\n]+\((0x[0-9A-Fa-f]+)\)", body)[1], 16),
                                     line=int(re.search(r"SourceLineNum: (\d+)", body)[1])))
            output += ["    {", f"        bytes, read_ok := read_entire_file({json.dumps(str(binary))});", "        assert(read_ok);", "        defer free(bytes);",
                       "        info: D.Codeview_Debug_Info;", "        assert(D.parse_codeview_symbols(*info, cast([] u8) bytes));", "        defer release_debug_symbols(*info);",
                       f"        assert(info.symbols.count == {len(symbols)} && info.inlinee_line_info.count == {len(inlinees)});"]
            for index, item in enumerate(symbols):
                output += [f"        assert(info.symbols[{index}].symbol_type == .{item['kind']});"]
                if item["kind"] == "COMPILE3":
                    output += ["        {", f"            compiler := cast(*D.Codeview_Symbol_Compile3) info.symbols[{index}];",
                               f"            assert(compiler.target_cpu == {item['cpu']} && compiler.language == {item['language']} && compiler.compiler_version == {json.dumps(item['compiler'])});"]
                    for field, values in [("fe_version", item["frontend"]), ("be_version", item["backend"])]:
                        for member, value in zip(["major", "minor", "build", "qfe"], values):
                            output.append(f"            assert(compiler.{field}.{member} == {value});")
                    output += ["        }"]
                if item["kind"] in PROCEDURES:
                    output += ["        {", f"            procedure := cast(*D.Codeview_Symbol_Procedure) info.symbols[{index}];",
                               f"            assert(procedure.name == {json.dumps(item['name'])} && procedure.length == {item['length']} && procedure.offset == {item['offset']});",
                               f"            assert(procedure.segment_index == {item['segment']} && cast(u32) procedure.type == {item['type']});",
                               f"            assert(procedure.inlinesites.count == {len(item['children'])});"]
                    for child_index, child in enumerate(item["children"]):
                        output.append(f"            assert(cast(*D.Codeview_Symbol) procedure.inlinesites[{child_index}] == info.symbols[{child}]);")
                    output += ["            placed, sequences := D.overlay_inlinesites(info.line_info, procedure.*, procedure.inlinesites, info);",
                               "            assert(placed && sequences.count > 0);", "            defer release_sequences(sequences);",
                               "            total: u64;", "            for sequence, row: sequences {",
                               "                assert(sequence.segment_index == procedure.segment_index);",
                               "                if row assert(sequence.text_offset == sequences[row - 1].text_offset + sequences[row - 1].length_in_bytes);",
                               "                total += sequence.length_in_bytes;", "            }", "            assert(total == procedure.length);", "        }"]
                if item["kind"] == "INLINESITE":
                    output += ["        {", f"            site := cast(*D.Codeview_Symbol_Inline_Site) info.symbols[{index}];",
                               f"            assert(cast(u32) site.inlinee == {item['inlinee']} && site.children.count == {len(item['children'])});",
                               f"            assert(site.binary_annotations.count == {len(item['annotations'])});"]
                    for child_index, child in enumerate(item["children"]):
                        output.append(f"            assert(cast(*D.Codeview_Symbol) site.children[{child_index}] == info.symbols[{child}]);")
                    for annotation_index, annotation in enumerate(item["annotations"]):
                        field = "signed" if annotation.get("first_signed") else "unsigned"
                        output.append(f"            assert(site.binary_annotations[{annotation_index}].opcode == .{annotation['opcode']} && site.binary_annotations[{annotation_index}].operand1.{field} == {annotation['first']});")
                        if "second" in annotation:
                            field = "signed" if annotation.get("second_signed") else "unsigned"
                            output.append(f"            assert(site.binary_annotations[{annotation_index}].operand2.{field} == {annotation['second']});")
                    output += ["        }"]
            for index, item in enumerate(inlinees):
                output.append(f"        assert(cast(u32) info.inlinee_line_info[{index}].inlinee == {item['inlinee']} && cast(u32) info.inlinee_line_info[{index}].file_id == {item['file']} && info.inlinee_line_info[{index}].source_line == {item['line']});")
            source = str(ROOT / "tests/developer-tools/codeview-inline-native.c")
            output += ["        for checksum: info.file_checksums {", "            filename, filename_ok := D.get_filename_for_file_id(info, checksum.id);",
                       f"            assert(filename_ok && filename == {json.dumps(source)});", "        }", "    }"]
            evidence.append(dict(architecture=architecture, optimization=optimization, sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
                                 projected_symbols=symbols, inlinees=inlinees))
            if architecture == "x64" and optimization == 2:
                shutil.copyfile(binary, TARGET / "codeview-inline-original.bin")
                data = binary.read_bytes()
                at = 4
                procedure_payload = None
                while at < len(data):
                    section, length = struct.unpack_from("<II", data, at)
                    if section == 0xf1:
                        cursor = at + 8
                        while cursor < at + 8 + length:
                            record_length, kind = struct.unpack_from("<HH", data, cursor)
                            if kind in {0x110f, 0x1110, 0x1146, 0x1147}:
                                procedure_payload = record_length - 2
                                procedure_next = cursor + 12
                            if kind == 0x114d:
                                parent_offset = cursor + 4
                                break
                            cursor += 2 + record_length
                        else:
                            at = (at + 8 + length + 3) & ~3
                            continue
                        break
                    at = (at + 8 + length + 3) & ~3
                if procedure_payload is None:
                    raise RuntimeError("Original procedure payload is absent")
                (TARGET / "debug-info-symbol-mutations.jai").write_text(f"Native_Site_Parent_Offset :: {parent_offset};\nNative_Procedure_Payload_Size :: {procedure_payload};\nNative_Procedure_Next_Offset :: {procedure_next};\n")
    output += ["}"]
    path = TARGET / "debug-info-symbol-sdk.jai"
    path.write_text("\n".join(output) + "\n")
    run([TARGET / "jaifmt", "--config", ROOT / "jaifmt.toml", path])
    synthetic_symbols()
    return evidence


def synthetic_symbols():
    def record(kind, payload=b""):
        padding = (-len(payload) - 4) % 4
        return struct.pack("<HH", len(payload) + padding + 2, kind) + payload + bytes(padding)

    def section(records):
        return struct.pack("<III", 4, 0xf1, len(records)) + records

    def literal(data):
        return "u8.[" + ", ".join(str(value) for value in data) + "]"

    def compressed(value):
        if value < 0x80:
            return bytes([value])
        if value < 0x4000:
            return bytes([0x80 | (value >> 8), value & 255])
        return bytes([0xc0 | (value >> 24), (value >> 16) & 255, (value >> 8) & 255, value & 255])

    payload = struct.pack("<8IHB", 0, 0, 0, 30, 2, 20, 0x1000, 100, 2, 1) + b"f\0"
    data = b"".join(record(kind, payload) + record(0x114f if kind in {0x1146, 0x1147} else 6)
                    for kind in [0x110f, 0x1110, 0x1146, 0x1147])
    output = ["check_synthetic_symbol_records :: () {", "    {", f"        data := {literal(section(data))};",
              "        info: D.Codeview_Debug_Info;", "        assert(D.parse_codeview_symbols(*info, data));", "        defer release_debug_symbols(*info);",
              "        assert(info.symbols.count == 4);", "        kinds := D.Codeview_Symbol_Type.[.LPROC32, .GPROC32, .LPROC32_ID, .GPROC32_ID];",
              "        for symbol, index: info.symbols {", "            procedure := cast(*D.Codeview_Symbol_Procedure) symbol;",
              '            assert(symbol.symbol_type == kinds[index] && procedure.name == "f" && procedure.length == 30);',
              "            assert(procedure.offset == 100 && procedure.segment_index == 2 && procedure.debug_start_offset == 2 && procedure.debug_end_offset == 20);",
              "        }", "    }"]
    annotations = bytes([1]) + compressed(0x123456) + bytes([9]) + compressed(300) + bytes([6]) + compressed(2 * 0x12345 + 1)
    annotations += bytes([11]) + compressed(((2 * 1234 + 1) << 4) | 7) + bytes([4, 2])
    site = struct.pack("<III", 0, 0, 0x1000)
    valid = record(0x1110, payload) + record(0x114d, site + annotations) + record(0x114e) + record(6)
    output += ["    {", f"        data := {literal(section(valid))};", "        info: D.Codeview_Debug_Info;",
               "        assert(D.parse_codeview_symbols(*info, data));", "        defer release_debug_symbols(*info);",
               "        site := cast(*D.Codeview_Symbol_Inline_Site) info.symbols[1];", "        assert(site.binary_annotations.count == 5);",
               "        assert(site.binary_annotations[0].operand1.unsigned == 0x123456 && site.binary_annotations[1].operand1.unsigned == 300);",
               "        assert(site.binary_annotations[2].operand1.signed == -0x12345);",
               "        assert(site.binary_annotations[3].operand1.unsigned == 7 && site.binary_annotations[3].operand2.signed == -1234);", "    }"]
    malformed = [record(0x1110, payload) + record(0x114d, site + tail) + record(0x114e) + record(6)
                 for tail in [bytes([0xe0]), bytes([14, 1]), bytes([1, 0xdf, 255, 255])]]
    for data in malformed:
        output += ["    {", f"        data := {literal(section(data))};", "        info: D.Codeview_Debug_Info;", "        before := live_allocations;",
                   "        assert(!D.parse_codeview_symbols(*info, data) && info.symbols.count == 0 && live_allocations == before);", "    }"]
    output += ["}"]
    path = TARGET / "debug-info-symbol-synthetic.jai"
    path.write_text("\n".join(output) + "\n")
    run([TARGET / "jaifmt", "--config", ROOT / "jaifmt.toml", path])


if __name__ == "__main__":
    main()
