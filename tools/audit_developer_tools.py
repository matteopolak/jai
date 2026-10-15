#!/usr/bin/env python3
"""Inventory reviewed tooling declarations without reading corpus/native vendor inputs.

Presence is lexical evidence only, never a claim of behavioral or ABI coverage.
"""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = {
    "Bindings_Generator": "bindings-generator", "Generate_C_Header": "generate-c-header",
    "Check": "check", "Codex": "codex", "Debug": "debug", "Debug_Info": "debug-info",
    "Print_Vars": "print-vars", "Iprof": "iprof", "Performance_Report": "performance-report",
    "Rewrite": "rewrite",
}


def remaining_matrix(inventory):
    questions = {
        ("Bindings_Generator", "generate_bridge"): "Bindings_Generator question9: bridge naming/output/library contract",
        ("Bindings_Generator", "ensure_local_libclang_exists"): "Bindings_Generator question11: installation/copy policy",
        ("Bindings_Generator", "clang_getFileTime"): "Bindings_Generator question12: canonical time_t dependency",
        ("Bindings_Generator", "is_same_type"): "Bindings_Generator question10: model equivalence",
        ("Bindings_Generator", "is_same_expression"): "Bindings_Generator question10: model equivalence",
        ("Bindings_Generator", "is_same_literal"): "Bindings_Generator question10: literal equivalence",
        ("Debug_Info", "parse_frame_description_entry"): "Debug_Info question4: remaining frame encodings/offset conventions",
        ("Debug_Info", "parse_compilation_unit_v4"): "Debug_Info questions5/6: Parse_Context and Declaration.kind shapes",
        ("Debug_Info", "parse_dwarf_debug_info"): "Debug_Info questions5/6: canonical parser dependencies",
        ("Debug_Info", "get_filename"): "Debug_Info question8: file/directory indexing and path text",
        ("Debug_Info", "get_filename_for_file_id"): "Debug_Info question8 for DWARF overload; CodeView implementation pending",
    }
    output = ["# Developer tooling remaining function matrix", "",
              "Generated from the reviewed per-API inventory by tools/audit_developer_tools.py. Native source/symbol coverage is distinct from invocation. Supported subsets have additional limits in the progress/deviations documents; this table is not a claim that other paths are complete.", "",
              "[Precise questions](../specs/stdlib/developer-tools-questions.md), [verified effects](developer-tools-progress.md), [limits and dependencies](developer-tools-deviations.md), [native integration plan](../developer-tools-native-integration.md).", ""]
    for module, information in inventory.items():
        functions = {}
        for entry in information["declarations"]:
            if re.search(r"::\s*(?:inline\s+)?\(", entry["declaration"]):
                functions.setdefault(entry["name"], []).append(entry)
        pending = {name: entries for name, entries in functions.items() if any(entry["implementation"] == "pending" for entry in entries)}
        source_only = {name: entries for name, entries in functions.items() if any("invocation remains unverified" in entry["implementation"] for entry in entries)}
        output += [f"## {module}", "", f"{len(pending)} function names have pending declarations; {len(source_only)} native function names still lack invocation fixtures.", ""]
        if pending:
            output += ["| Function | Reviewed overload variants | Next work / precise question |", "| --- | ---: | --- |"]
            for name, entries in sorted(pending.items()):
                reason = questions.get((module, name), "Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior.")
                if module == "Debug_Info" and ("msf" in name or "stream" in name or name in {"parse_pdb", "get_stream_size", "stream_exists", "is_valid_page_number", "is_valid_stream_number", "is_valid_user_stream_number", "verify_integrity", "ensure_room", "is_free_page", "alloc_page", "free_page", "is_fpm_page_number"}):
                    reason = "Debug_Info question7: canonical MSF/UPN/UNSN dependencies; private MSF wire reader is staged"
                if module == "Codex":
                    reason = "Codex questions1–3: reviewed wire/metrics/plugin semantics are being refined"
                if module == "Iprof":
                    reason = "Iprof questions1–3: instrumentation/timer/history/report semantics are being refined"
                output.append(f"| `{name}` | {len(entries)} | {reason} |")
            output.append("")
        if source_only:
            output += ["| Native function | Evidence / next check |", "| --- | --- |"]
            output += [f"| `{name}` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |" for name in sorted(source_only)]
            output.append("")
    (ROOT / "docs/status/developer-tools-remaining.md").write_text("\n".join(output).rstrip() + "\n")


def main():
    inventory = {}
    for module, slug in MODULES.items():
        spec = ROOT / f"docs/specs/stdlib/modules/{slug}.md"
        contents = spec.read_text()
        declarations = []
        members = []
        section = ""
        aggregate = ""
        in_members = False
        for line_number, line in enumerate(contents.splitlines(), 1):
            if line.startswith("## "):
                section = line[3:]
                in_members = "type members" in section or "aggregate shapes" in section
            elif line.startswith("### "):
                section = line[4:]
            if line.startswith("#### `") or (in_members and line.startswith("### `")):
                aggregate = line.split("`")[1]
            if not in_members and line.startswith("- ") and "`" in line:
                signature = line.split("`", 2)[1]
                name = re.match(r"([A-Za-z_][A-Za-z_0-9]*)\s*(?:::|:)", signature)
                if name:
                    declarations.append({"name": name[1], "declaration": signature,
                                         "section": section, "spec_line": line_number,
                                         "implementation": "pending"})
            if in_members and line.strip() and not line.startswith("#"):
                members.append({"aggregate": aggregate, "reviewed_text": line,
                                "section": section, "spec_line": line_number})
        if module == "Generate_C_Header":
            for item in declarations:
                item["implementation"] = "supported subset; see developer-tools-deviations.md"
        if module == "Bindings_Generator":
            models = set()
            abi_evidence = ROOT / "docs/native/developer-tools-native-abi-evidence.json"
            abi_names = set()
            if abi_evidence.exists():
                for comparison in json.loads(abi_evidence.read_text())["native_expressions"]:
                    abi_names.update(re.findall(r"B\.([A-Za-z_][A-Za-z_0-9]*)", comparison["jai"]))
            extended_apis = set(re.findall(r"^\s*(clang_[A-Za-z_0-9]*)\s*::",
                                           (ROOT / "stdlib/Bindings_Generator/native-extended-api.jai").read_text(), re.MULTILINE))
            for path in (ROOT / "stdlib/Bindings_Generator").glob("*.jai"):
                models.update(re.findall(r"^\s*([A-Za-z_][A-Za-z_0-9]*)\s*::", path.read_text().split("#scope_file")[0], re.MULTILINE))
            for item in declarations:
                if item["name"] in models or item["name"] == "TARGET_OS":
                    item["implementation"] = "reviewed data/defaults/constants implemented; behavioral coverage varies by model"
                    if item["name"] in abi_names:
                        item["implementation"] = "reviewed native record/enum ABI; host official SDK size/alignment/member offsets/enum values verified; target runtime pending"
                if item["name"].startswith("clang_") and item["name"] in models:
                    item["implementation"] = "direct native parser API subset; official SDK interpreter/native O0/O2 struct and callback ABI effects"
                    if item["name"] in extended_apis:
                        item["implementation"] = "reviewed direct native binding implemented; source-checked only, direct invocation remains unverified"
                        if item["name"] in {"clang_getNullLocation", "clang_equalLocations", "clang_getNullRange",
                                             "clang_Range_isNull", "clang_equalRanges", "clang_getFileUniqueID",
                                             "clang_File_isEqual", "clang_File_tryGetRealPathName", "clang_getLocation",
                                             "clang_getExpansionLocation", "clang_getInstantiationLocation", "clang_getFileLocation",
                                             "clang_getLocationForOffset", "clang_getPresumedLocation", "clang_isBeforeInTranslationUnit",
                                             "clang_getRange", "clang_isDeclaration", "clang_isReference", "clang_isInvalid",
                                             "clang_isInvalidDeclaration", "clang_createCXCursorSet", "clang_disposeCXCursorSet",
                                             "clang_CXCursorSet_contains", "clang_CXCursorSet_insert"}:
                            item["implementation"] = "direct native source/file/range/cursor-set APIs; original physical and presumed source metadata, ownership and set effects verified interpreter/native O0/O2"
                        if item["name"] in {"clang_CXXConstructor_isConvertingConstructor", "clang_CXXConstructor_isCopyConstructor",
                                             "clang_CXXConstructor_isDefaultConstructor", "clang_CXXConstructor_isMoveConstructor",
                                             "clang_CXXMethod_isConst", "clang_CXXMethod_isCopyAssignmentOperator",
                                             "clang_CXXMethod_isDefaulted", "clang_CXXMethod_isDeleted", "clang_CXXMethod_isExplicit",
                                             "clang_CXXMethod_isMoveAssignmentOperator", "clang_CXXMethod_isPureVirtual",
                                             "clang_CXXMethod_isStatic", "clang_CXXMethod_isVirtual", "clang_CXXRecord_isAbstract",
                                             "clang_Cursor_getMangling", "clang_Cursor_isAnonymous", "clang_Cursor_isAnonymousRecordDecl",
                                             "clang_Cursor_isInlineNamespace", "clang_Type_visitFields", "clang_visitCXXBaseClasses",
                                             "clang_visitCXXMethods", "clang_getCursorAvailability", "clang_getCursorLanguage",
                                             "clang_getCursorLinkage", "clang_getCursorTLSKind", "clang_getCursorVisibility"}:
                            item["implementation"] = "direct native C++17 AST queries and class visitor callbacks; interpreter/native O0/O2 with independent public-header C visitor return/count oracle"
                if item["name"] in {"set_ExcludeDeclarationsFromPCH", "get_ExcludeDeclarationsFromPCH",
                                     "set_DisplayDiagnostics", "get_DisplayDiagnostics",
                                     "set_StorePreamblesInMemory", "get_StorePreamblesInMemory"}:
                    item["implementation"] = "reviewed bit views; native SDK layout, bit preservation and index creation verified"
                if item["name"] in {"generate_bindings", "normalize_options", "get_default_system_include_paths",
                                     "_default_get_func_args_for_printing", "looks_like_valid_identifier",
                                     "is_hex_digit", "is_valid_int_literal_suffix", "is_valid_float_literal_suffix",
                                     "convert_float_literal", "convert_literal_value", "generate_replacements_array"}:
                    item["implementation"] = "supported staged C parser/literal subset; actual native/interpreter round trips; see limits"
                if item["name"] in {"visit_declarations", "find_parent_enum", "create_type_of_enum", "change_type_to_enum",
                                     "change_return_type", "change_return_type_to_enum", "change_argument_type_to_enum",
                                     "create_pointer_to", "get_int_type"}:
                    item["implementation"] = "standalone model traversal/mutation subset; snapshot callbacks and ownership effects verified"
                if item["name"] in {"append_cpp_literal", "append_cpp_expression"}:
                    item["implementation"] = "C++17 fragment subset; generated native consumers O0/O2 from interpreter/native emitter runs, unsupported output preservation"
                if item["name"] in {"is_void_type", "is_bool_type", "is_same_location"}:
                    item["implementation"] = "model predicate subset; parsed native bool/void aliases, cycle diagnostics and live SDK file-handle metadata verified"
                if item["name"] in {"fill_location", "get_clang_type_alignment", "create_null_literal"}:
                    item["implementation"] = "native location/alignment and owned null literal helpers; live SDK values/errors and generated C++17 pointer effect verified"
        if module == "Performance_Report":
            for item in declarations:
                item["implementation"] = "implemented; measured native compiler plugin fixture"
        if module == "Print_Vars":
            for item in declarations:
                item["implementation"] = "implemented; original caller-code, formatting and logging fixture"
        if module == "Rewrite":
            for item in declarations:
                item["implementation"] = "supported subset; actual compiler-message rewrite and edit safety fixture"
        if module == "Debug_Info":
            for item in declarations:
                if item["name"] in {"Line_Info", "Line_Info_Sequence", "Line_Mapping", "File_Info", "Dwarf_File_Id",
                                     "get_line_mapping_for_address", "get_line_mappings_for_address_range"}:
                    item["implementation"] = "reviewed line records and DWARF interval queries; original x64/arm64 O0/O2 line-table SDK oracles, interpreter/native effects and malformed/overlap diagnostics"
                if item["name"] in {"Int_Set", "cardinality", "is_set"}:
                    item["implementation"] = "reviewed bit-set record and operations; interpreter/native O0/O2 boundaries and borrowed-storage mutation verified"
                if item["name"] in {"Call_Frame_Address_Instruction_Type", "Call_Frame_Address_Instruction",
                                     "Frame_Common_Information_Entry", "decode_cfa_instructions", "parse_common_information_entry"}:
                    item["implementation"] = "supported DWARF frame subset; native-produced CIE and malformed-input fixture"
                if item["name"] in {"Frame_Description_Entry", "parse_frame_description_entry"}:
                    item["implementation"] = "DWARF32 debug_frame v4 explicit-width FDE subset; original x86/x64/arm64 O0/O2 ranges/opcode sequences and all truncated prefixes; eh_frame pending question4"
                if item["name"] in {"Codeview_Line_Info", "get_line_number", "get_line_number_end_delta",
                                     "line_info_is_for_statement", "Codeview_Address_Range", "Codeview_Address_Gap",
                                     "Codeview_Symbol_Defrange_Register_Rel", "get_spilled_udt_member", "get_offset_parent"}:
                    item["implementation"] = "reviewed CodeView field subset; Microsoft public header and Windows x64/arm64 ABI-produced data, host interpreter/native effects"
        if module == "Debug":
            supported = {"Exit_Code", "Minidump_State", "CRASH_HANDLER_USE_SEPARATE_THREAD", "backtrace",
                         "free_backtrace", "backtrace_symbols", "translate_symbols", "os_backtrace",
                         "os_backtrace_symbols", "is_debugger_present", "os_is_debugger_present",
                         "is_valid_pointer", "output", "abort", "os_abort", "breakpoint"}
            for item in declarations:
                if item["name"] in supported:
                    item["implementation"] = "macOS native effects; Windows SDK cross-build/signature checks, runtime pending; Linux source-only; Android/WASM debugger false"
        if module == "Iprof":
            supported = {"Report", "Report_Row", "Report_Mode", "Zone", "Zone_History", "NUM_VALUES", "NUM_TITLE",
                         "NUM_HEADER", "NUM_FRAME_SLOTS", "save_csv_report", "log_text_report"}
            for item in declarations:
                if item["name"] in supported:
                    item["implementation"] = "reporting subset; CSV/text, manual/history conditions verified"
        if module == "Codex":
            for item in declarations:
                if item["name"] in {"Math", "get_file_and_module", "is_global_ident"}:
                    item["implementation"] = "inspection subset; real producer code records and canonical Math identity verified"
        if module == "Check":
            for item in declarations:
                if item["name"] in {"DEBUG_BINDINGS", "C_Porting_Check_Settings", "check_c_porting", "should_skip",
                                     "is_of_fixed_array_type", "do_error_checking"}:
                    item["implementation"] = "Windows-only porting subset; actual typed-message and manual diagnostic fixtures"
        inventory[module] = {"spec": str(spec.relative_to(ROOT)),
                             "spec_sha256": hashlib.sha256(contents.encode()).hexdigest(),
                             "declarations": declarations, "reviewed_members": members}
    destination = ROOT / "docs/developer-tools-api.json"
    destination.write_text(json.dumps(inventory, indent=2) + "\n")
    remaining_matrix(inventory)
    print(f"Inventoried {sum(len(x['declarations']) for x in inventory.values())} reviewed declaration variants across {len(inventory)} modules")


if __name__ == "__main__":
    main()
