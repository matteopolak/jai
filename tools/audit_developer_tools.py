#!/usr/bin/env python3
"""Inventory reviewed tooling declarations without reading corpus/native vendor inputs.

Presence is lexical evidence only, never a claim of behavioral or ABI coverage.
"""
import hashlib
import argparse
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
        ("Bindings_Generator", "generate_bridge"): "Reviewed C++ source adapter contract resolved; implementation and compiled round trips pending",
        ("Bindings_Generator", "ensure_local_libclang_exists"): "Bindings_Generator question11: installation/copy policy",
        ("Bindings_Generator", "find_lib_for_foreign_name"): "generator-platform question1: canonical Generator context/libraries and ambiguity policy",
        ("Bindings_Generator", "os_get_symbol_names_from_file_fixed_and_cached"): "generator-platform question2: canonical public cache state, normalization, invalidation and ownership",
        ("Bindings_Generator", "get_libc_paths"): "generator-platform question4: meaning and relationship of the two path outputs",
        ("Bindings_Generator", "clang_getFileTime"): "Bindings_Generator question12: canonical time_t dependency",
        ("Bindings_Generator", "is_same_type"): "Bindings_Generator question10: model equivalence",
        ("Bindings_Generator", "is_same_expression"): "Bindings_Generator question10: model equivalence",
        ("Bindings_Generator", "is_same_literal"): "Bindings_Generator question10: literal equivalence",
        ("Debug_Info", "parse_frame_description_entry"): "Debug_Info question4: remaining frame encodings/offset conventions",
        ("Debug_Info", "parse_compilation_unit_v4"): "Reviewed Parse_Context and Declaration.kind resolved; canonical DWARF parser implementation pending",
        ("Debug_Info", "parse_dwarf_debug_info"): "Reviewed canonical parser dependencies resolved; implementation pending",
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
            output += ["| Function | Reviewed overload variants | Pending variants | Next work / precise question |", "| --- | ---: | ---: | --- |"]
            for name, entries in sorted(pending.items()):
                reason = questions.get((module, name), "Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior.")
                if module == "Debug_Info" and ("msf" in name or "stream" in name or name in {"parse_pdb", "get_stream_size", "stream_exists", "is_valid_page_number", "is_valid_stream_number", "is_valid_user_stream_number", "verify_integrity", "ensure_room", "is_free_page", "alloc_page", "free_page", "is_fpm_page_number"}):
                    reason = "Reviewed MSF/UPN/UNSN shapes resolved; canonical integration pending. Question7 retains parameter policies/PDB map shape and user-stream bounds"
                if module == "Codex":
                    reason = "Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details"
                if module == "Iprof":
                    reason = "Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2"
                if module == "Debug_Info" and name == "get_type":
                    reason = "CodeView overloads pending; canonical DWARF Compilation_Unit offset lookup is implemented/tested"
                if module == "Debug_Info" and name in {"init", "ensure_room", "set_all"}:
                    reason = "Question14: active-word/capacity, growth, rover and fill policy; already-sized bit operations execute against native PDB/SDK FPM oracles"
                if module == "Debug_Info" and name in {"parse_dwarf_debug_info", "parse_compilation_unit_v4"}:
                    reason = "Real DWARF4 line byte decoder is staged/tested; public integration, DIE/abbreviation parsing and questions8/10 remain unfinished"
                if module == "Debug" and name in {"init", "enable_signal_handler", "disable_signal_handler", "os_enable_signal_handler", "os_disable_signal_handler", "no_assert", "print_assert", "trace_assert", "set_report_mode"}:
                    reason = "Mac lifecycle/assertion effects verified; Windows implementation pending. Report-mode storage awaits graphics integration; minidump/attachment policy remains in Debug questions."
                unfinished = sum(entry["implementation"] == "pending" for entry in entries)
                output.append(f"| `{name}` | {len(entries)} | {unfinished} | {reason} |")
            output.append("")
        if module == "Codex":
            output += ["", "| Implemented function with remaining paths | Remaining work |", "| --- | --- |",
                       "| `collect_metrics` | Conditional weights and Basic allocator names await question2, with explicit rejection; calls/identity/assignments/globals/loop depth execute. |", ""]
        if module == "Bindings_Generator":
            output += ["", "| Implemented generator with remaining paths | Remaining work |", "| --- | --- |",
                       "| `generate_bindings` | Global POD aggregate/reference C++ declarations and custom overload/argument mappings execute; namespace/method/template/printf adapters, arbitrary ABI-changing callbacks and broader parsing remain unfinished. |",
                       "| `generate_bridge` | Global POD aggregate/reference adapters and custom overload/argument mappings execute; namespace/method/template/printf adapters and arbitrary ABI-changing callbacks remain unfinished. |", ""]
        if module == "Debug_Info":
            output += ["", "| Implemented map helper with remaining paths | Remaining work |", "| --- | --- |",
                       "| `is_free_page` | Initialized in-range words execute; capacity/active-word policy awaits question14. |",
                       "| `alloc_page` | In-range allocation bits execute; automatic growth and rover policy await question14. |",
                       "| `free_page` | In-range free bits execute; automatic growth and rover policy await question14. |",
                       "| `is_fpm_page_number` | MSF7 4096-byte big-map positions execute; other layouts remain unsupported. |", ""]
        if source_only:
            output += ["| Native function | Evidence / next check |", "| --- | --- |"]
            output += [f"| `{name}` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |" for name in sorted(source_only)]
            output.append("")
        if information.get("pending_public_member_dependencies"):
            output += ["| Pending public member | Reviewed expression | Missing reviewed dependency |", "| --- | --- | --- |"]
            for member in information["pending_public_member_dependencies"]:
                output.append(f"| `{member['enum']}.{member['member']}` | `{member['expression']}` | `{member['missing_reviewed_dependency']}`; Debug_Info question11 |")
            output.append("")
    (ROOT / "docs/status/developer-tools-remaining.md").write_text("\n".join(output).rstrip() + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--modules", nargs="+", choices=MODULES)
    selected = parser.parse_args().modules
    destination = ROOT / "docs/developer-tools-api.json"
    inventory = json.loads(destination.read_text()) if selected else {}
    for module, slug in MODULES.items():
        if selected and module not in selected:
            continue
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
                in_members = True
            elif line.startswith("#### Contextual layout dependencies"):
                aggregate = "module-contextual dependency descriptions (not additional exports)"
                in_members = True
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
                if item["name"] in {"ensure_local_libclang_exists", "os_get_symbol_names_from_file",
                                     "os_get_symbol_names_from_file_content", "os_load_library",
                                     "os_symbol_exists_in_library", "fix_macos_foreign_name",
                                     "function_is_missing_foreign_library"}:
                    item["implementation"] = "independent documented platform policy; original Mach-O/ELF/COFF/archive and live library effects, installed SDK discovery, interpreter/native Mac O0/O2; six desktop source checks; see generator-platform.md for ownership and contract limits"
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
                    item["implementation"] = "supported C parser/literal and global C++ scalar/pointer adapter-binding subset; actual generated/native/interpreter round trips; see limits"
                if item["name"] == "generate_bridge":
                    item["implementation"] = "global C++17 adapter subset; original native POD/reference effects and customized overload/argument/record/field mappings verified; scopes/methods/templates/printf and arbitrary ABI-changing callbacks pending"
                if item["name"] == "generate_bindings":
                    item["implementation"] = "C and global POD C++ generation subset; original aggregate/reference effects, custom overload/argument/record/field mappings and destination-preserving diagnostics verified; scopes/methods/templates/printf and arbitrary ABI-changing callbacks pending"
                if item["name"] in {"visit_declarations", "find_parent_enum", "create_type_of_enum", "change_type_to_enum",
                                     "change_return_type", "change_return_type_to_enum", "change_argument_type_to_enum",
                                     "create_pointer_to", "get_int_type"}:
                    item["implementation"] = "standalone model traversal/mutation subset; snapshot callbacks and ownership effects verified"
                if item["name"] in {"append_cpp_literal", "append_cpp_expression"}:
                    item["implementation"] = "C++17 fragment subset; generated native consumers O0/O2 from interpreter/native emitter runs, unsupported output preservation"
                if item["name"] in {"is_void_type", "is_bool_type", "is_same_location"}:
                    item["implementation"] = "model predicate subset; parsed native bool/void aliases, cycle diagnostics and live SDK file-handle metadata verified"
                if item["name"] in {"is_same_type", "is_same_expression", "is_same_literal"}:
                    item["implementation"] = "reviewed finite equivalence subset; scalar/alias/pointer/reference/nominal/function and literal/expression identity effects; unreviewed raw payload/array/hardcoded/CHAR/nested qualifier/variadic differences and cyclic/deep graphs explicitly diagnosed"
                if item["name"] in {"fill_location", "get_clang_type_alignment", "create_null_literal"}:
                    item["implementation"] = "native location/alignment and owned null literal helpers; live SDK values/errors and generated C++17 pointer effect verified"
                if item["name"] == "clang_getFileTime":
                    item["implementation"] = "canonical POSIX/private Windows signed64 time_t binding; real future>32-bit and pre-epoch timestamps, reflected identity and private-name rejection verified"
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
                if item["name"] in {"Codeview_Debug_Info", "Codeview_Type", "Codeview_Symbol", "Codeview_File_Checksum", "Codeview_File_Checksum_Id", "Codeview_String_Table_Id", "Codeview_Column_Type", "Codeview_Lines_File_Block", "Codeview_Line_Info_Sequence", "Codeview_Inlinee_Line_Info", "Type_Id", "Item_Id"}:
                    item["implementation"] = "reviewed canonical CodeView string/checksum/line context model; actual C13 SDK filename/file-ID/MD5 oracles and borrowed views; symbol/type byte parsing pending"
                if item["name"] in {"Codeview_Leaf_Type", "Codeview_Symbol_Type"}:
                    item["implementation"] = "reviewed u16 enum names/values/sentinels/aliases implemented; current reviewed RECTYPE_MAX/TYPE_LAST/ID_LAST and all dependent aliases verified; no guessed exports"
                if item["name"] == "get_string_from_table" or (item["name"] == "get_filename_for_file_id" and "Codeview_Debug_Info" in item["declaration"]):
                    item["implementation"] = "bounded CodeView C13 string/checksum-ID lookup; original Windows x64/arm64 C O0/O2 SDK filename/file-ID/source MD5 oracles, borrowed pointer identity and malformed/duplicate failures; ownership precision question12"
                if item["name"] in {"Debug_Info", "Compilation_Unit", "Debug_Type", "Subprogram", "Declaration", "Lexical_Block", "Dwarf_Language", "Dwarf_Tag", "Dwarf_Base_Type"}:
                    item["implementation"] = "reviewed canonical DWARF model/constants; canonical Bucket_Array dependencies and declaration kinds verified; byte parser remains pending"
                if item["name"] == "Line_Program_Header":
                    item["implementation"] = "canonical reviewed header shape/packed field offset; actual staged DWARF4 byte decoder with original x86/x64/arm64 O0/O2 SDK row oracles; public parser integration pending"
                if item["name"] == "get_type" and "cu: Compilation_Unit" in item["declaration"]:
                    item["implementation"] = "DWARF model offset lookup; six original C DWARF4 SDK-decoded type oracles, unsorted tables/missing offsets/borrowed storage/duplicate diagnostics in interpreter/native O0/O2; not a byte parser"
                if item["name"] in {"Msf", "Free_Page_Map"}:
                    item["implementation"] = "reviewed canonical record/contextual layouts implemented; Free_Page_Map operations and parse_msf remain pending"
                if item["name"] in {"is_free_page", "alloc_page", "free_page", "is_fpm_page_number"}:
                    item["implementation"] = "already-sized canonical free-page maps; native x64/arm64 PDB SDK FPM byte oracles, all bit queries, boundary/idempotent mutations and reserved MSF7 4096-page positions; init/growth/rover policies pending question14"
                if item["name"] == "Free_Page_Map":
                    item["implementation"] = "canonical record and already-sized bit operations with original native PDB SDK oracles; init/growth/rover policies pending question14"
                if item["name"] in {"is_msf", "is_pdb", "get_stream_data", "get_stream_size", "is_valid_stream_number", "stream_exists", "is_valid_page_number"}:
                    item["implementation"] = "canonical MSF7 read helper subset; actual original Clang/LLD x64/arm64 PDB streams compared to SDK byte exports in interpreter/native O0/O2, ownership/bounds and contextual visibility checked; parse_msf pending"
                if item["name"] in {"Line_Info", "Line_Info_Sequence", "Line_Mapping", "File_Info", "Dwarf_File_Id",
                                     "get_line_mapping_for_address", "get_line_mappings_for_address_range"}:
                    item["implementation"] = "reviewed line records and DWARF interval queries; original x64/arm64 O0/O2 line-table SDK oracles, interpreter/native effects and malformed/overlap diagnostics"
                if item["name"] in {"Int_Set", "cardinality", "is_set"}:
                    item["implementation"] = "reviewed bit-set record and operations; interpreter/native O0/O2 boundaries and borrowed-storage mutation verified"
                if item["name"] in {"Call_Frame_Address_Instruction_Type", "Call_Frame_Address_Instruction",
                                     "Frame_Common_Information_Entry", "decode_cfa_instructions", "parse_common_information_entry"}:
                    item["implementation"] = "supported DWARF frame subset; native-produced CIE and malformed-input fixture"
                if item["name"] in {"Frame_Description_Entry", "parse_frame_description_entry"}:
                    item["implementation"] = "reviewed eh_frame resolved-CIE and absolute8/PC-relative signed4 encodings; relocated native ranges/opcodes, extended CIE length marker, all truncated prefixes; extra debug_frame v4 subset also verified"
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
                if item["name"] in {"Assert_Response", "Crash_Handler", "crash_handler"}:
                    item["implementation"] = "reviewed canonical enum/callback/storage; actual native Mac O0/O2 fault-PC callback effect"
                if item["name"] in {"init", "enable_signal_handler", "disable_signal_handler", "os_enable_signal_handler", "os_disable_signal_handler", "no_assert", "print_assert", "trace_assert", "set_report_mode"}:
                    item["verified_scope"] = "Mac interpreter/native O0/O2 lifecycle, assertion ownership/diagnostics and non-swallowed failure; native fatal callbacks only. Windows implementation pending; Linux source only."
                if item["name"] in supported:
                    item["implementation"] = "macOS native effects; Windows SDK cross-build/signature checks, runtime pending; Linux source-only; Android/WASM debugger false"
        if module == "Iprof":
            supported = {"Report", "Report_Row", "Report_Mode", "Zone", "Zone_History", "NUM_VALUES", "NUM_TITLE",
                         "NUM_HEADER", "NUM_FRAME_SLOTS", "save_csv_report", "log_text_report"}
            for item in declarations:
                if item["name"] in supported:
                    item["implementation"] = "reporting subset; CSV/text, manual/history conditions verified"
                if item["name"] in {"History_Scalar", "NUM_SMOOTHING_SLOTS", "slot", "set_smoothing", "clear", "get_value"}:
                    item["implementation"] = "reviewed scalar-history shape, middle/clamped smoothing selector and borrowed-value access/clear; interpreter/native effects and independent module-instance storage verified; sampling/variance updates pending"
                if item["name"] in {"Profile_Tracker_Data_Record", "Zone_Profiling_Data", "count_recursion_depth"}:
                    item["implementation"] = "reviewed canonical tracker/stack records and pointer-identity ancestor count; measured manual core uses the stack records; history tracker updates remain pending"
                if item["name"] in {"init_runtime", "Stack_Push", "zone_begin", "zone_end", "MAX_DEPTH", "MAX_HASH_SIZE", "INIT_HASH_SIZE", "MAX_PROFILING_ZONES_FOR_MANUAL_MODE", "zones", "caches", "dummy", "dummy2", "stack", "zone_hash", "zone_hash_count", "zone_hash_mask", "timestamps_to_seconds", "integer_timestamps_per_second"}:
                    item["implementation"] = "measured manual-zone core; canonical POSIX/QPC clocks, real elapsed/self/hierarchical/call/recursion counters and stable cached/grown node identities, native/interpreter O0/O2 plus explicit rejection fixtures; Windows SDK links/source checks only; history/instrumentation/report creation pending"
                if item["name"] in {"TO_INSERT", "prepend_main", "Prepend_To_Main"}:
                    item["implementation"] = "reviewed-purpose real context client setup and runtime-init prepend macro; all manual/graphics/history configurations preserved and actual O0/O2 client programs verified; full instrumentation plugin pending"
        if module == "Codex":
            for item in declarations:
                if item["name"] in {"Math", "get_file_and_module", "is_global_ident"}:
                    item["implementation"] = "inspection subset; real producer code records and canonical Math identity verified"
                if item["name"] in {"Metrics", "collect_metrics"}:
                    item["implementation"] = "typed-tree metrics subset; real producer body and native public-node call/file/module/assignment/global/loop-depth effects; conditional forms and Basic allocator recognition explicitly rejected pending question2"
        if module == "Check":
            for item in declarations:
                if item["name"] in {"DEBUG_BINDINGS", "C_Porting_Check_Settings", "check_c_porting", "should_skip",
                                     "is_of_fixed_array_type", "do_error_checking"}:
                    item["implementation"] = "Windows-only porting subset; actual typed-message and manual diagnostic fixtures"
        inventory[module] = {"spec": str(spec.relative_to(ROOT)),
                             "spec_sha256": hashlib.sha256(contents.encode()).hexdigest(),
                             "declarations": declarations, "reviewed_members": members}
        if module == "Debug_Info":
            pending_path = ROOT / "docs/native/developer-tools-codeview-model-pending.json"
            if pending_path.exists():
                inventory[module]["pending_public_member_dependencies"] = json.loads(pending_path.read_text())["pending_aliases"]
    destination = ROOT / "docs/developer-tools-api.json"
    destination.write_text(json.dumps(inventory, indent=2) + "\n")
    remaining_matrix(inventory)
    print(f"Inventoried {sum(len(x['declarations']) for x in inventory.values())} reviewed declaration variants across {len(inventory)} modules")


if __name__ == "__main__":
    main()
