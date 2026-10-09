// Workspace management, message interception, reporting and the remaining Compiler
// procedures. Everything that needs the compiler goes through the __jaic_* primitives
// declared at the bottom of this file.

#scope_export

Report :: enum u8 {
    ERROR :: 0;
    ERROR_CONTINUABLE :: 1;
    WARNING :: 2;
    INFO :: 3;
}

Workspace_Status :: enum u8 {
    OK :: 0;
    FAILED :: 1;
}

Intercept_Flags :: enum_flags u32 {
    SKIP_EXPRESSIONS_WITHOUT_NOTES :: 0x1;
    SKIP_DECLARATIONS :: 0x2;
    SKIP_PROCEDURE_HEADERS :: 0x4;
    SKIP_PROCEDURE_BODIES :: 0x8;
    SKIP_STRUCTS :: 0x10;
    SKIP_OTHERS :: 0x20;
    SKIP_ALL :: SKIP_EXPRESSIONS_WITHOUT_NOTES | SKIP_DECLARATIONS | SKIP_PROCEDURE_HEADERS | SKIP_PROCEDURE_BODIES | SKIP_STRUCTS | SKIP_OTHERS;
    DO_PERFORMANCE_REPORT_POLYMORPHS :: 0x1000;
    DO_PERFORMANCE_REPORT_RUNS :: 0x2000;
}

Version_Info :: struct {
    major: s32;
    minor: s32;
    micro: s32;
}

Metaprogram_Plugin :: struct {
    workspace: Workspace;

    before_intercept: (p: *Metaprogram_Plugin, flags: *Intercept_Flags);
    add_source: (p: *Metaprogram_Plugin);
    message: (p: *Metaprogram_Plugin, message: *Message);
    finish: (p: *Metaprogram_Plugin);
    shutdown: (p: *Metaprogram_Plugin);

    handle_one_option: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> (new_cursor: int);
    log_help: (p: *Metaprogram_Plugin);

    // Newer plugins take all of their `-plug Name -- ...` options at once instead of
    // through handle_one_option, and can refuse them.
    init: (p: *Metaprogram_Plugin, options: [] string) -> bool;
}

Get_Root_Type_Status :: enum u8 {
    UNINITIALIZED :: 0;
    SUCCESS :: 1;
    INPUT_IS_CODE_NULL :: 2;
    CORRUPTED :: 3;
    NOT_TYPED :: 4;
}

Type_Info_Flags :: enum u32 {
    NO_TYPE_INFO :: 0x1;
    PROCEDURES_ARE_VOID_POINTERS :: 0x2;
    NO_SIZE_COMPLAINT :: 0x4;
}

Runtime_Info :: struct {
    type_table: [] *Type_Info;

    global_data_info: *Global_Data_Info;
}

Data_Segment_Index :: enum u16 {
    WRITABLE :: 0x0;
    WRITABLE_NO_RESET :: 0x1;
    READ_ONLY :: 0x2;
    BSS :: 0x3;
    USER_SEGMENT :: 0x10;
}

Data_Segment :: struct {}

Data_Segment_Characteristics :: enum_flags u32 {
    READ :: 0x1;
    WRITE :: 0x2;
    EXECUTE :: 0x4;
    ZEROED :: 0x8;
}

Global_Data_Segment_Info :: struct {
    segment_tag: enum u16 {
        BSS :: 0;
        DATA :: 1;
        RDATA :: 2;
        NO_RESET :: 3;

        USER :: 5;
    }

    data: [] u8;
}

Global_Data_Info :: struct {
    version_stamp: u64;
    segment_info: [] Global_Data_Segment_Info;
}

Compiler_Pin :: struct {
    name: string;
    pin: string;
}

// ---------------------------------------------------------------------------
// Workspaces
// ---------------------------------------------------------------------------

compiler_create_workspace :: (name := "") -> Workspace {
    id := __jaic_workspace_create(name);
    ensure_option_slot(id);
    while workspace_names.count <= id array_add(*workspace_names, "");
    workspace_names[id] = copy_text(name);
    return id;
}

// A workspace not compiled yet never is; one already compiled keeps what it wrote.
compiler_destroy_workspace :: (w: Workspace) {
    compiler_end_intercept(w);
    __jaic_workspace_set_option(resolve_workspace(w), "destroy", "");
}

get_current_workspace :: () -> Workspace {
    return __jaic_current_workspace();
}

get_name :: (w: Workspace = -1) -> string {
    id := resolve_workspace(w);
    if id < 0 || id >= workspace_names.count return "";
    return workspace_names[id];
}

add_build_file :: (filename: string, w: Workspace, loc := #caller_location) {
    __jaic_workspace_add_file(resolve_workspace(w), filename);
}

// jaic adds the text to the workspace's top level; it cannot add it where a `code` value
// was written, so passing one is an error rather than a string added elsewhere.
add_build_string :: (data: string, w: Workspace, code := #code,null, loc := #caller_location) {
    if !__jaic_code_is_null(code) {
        text := "add_build_string: jaic cannot add a string in the scope of a Code value; leave `code` out to add it at the workspace's top level";
        __jaic_report(text, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx Report.ERROR);
    }
    __jaic_workspace_add_string(resolve_workspace(w), data);
}

// The text is added to the module of `message` (a FILE or IMPORT message); other
// messages add it to the workspace's top level.
add_build_string :: (data: string, w: Workspace, message: *Message, loc := #caller_location) {
    record := record_of(message);
    if record && message && (message.kind == .FILE || message.kind == .IMPORT) {
        __jaic_workspace_add_string_to_module(resolve_workspace(w), data, record);
    } else {
        __jaic_workspace_add_string(resolve_workspace(w), data);
    }
}

compiler_get_version_info :: (version_info_return: *Version_Info) -> string {
    text := __jaic_compiler_version();

    if version_info_return {
        info: Version_Info;
        parse_version_numbers(text, *info);
        <<version_info_return = info;
    }

    return text;
}

get_toplevel_command_line :: () -> [] string {
    return collect_command_line();
}

// ---------------------------------------------------------------------------
// Message interception
// ---------------------------------------------------------------------------

// The SKIP_ flags leave those kinds out of TYPECHECKED messages (and a message left with
// nothing is not sent). SKIP_EXPRESSIONS_WITHOUT_NOTES is a hint jaic does not need: every
// typechecked expression is delivered.
compiler_begin_intercept :: (w: Workspace, flags: Intercept_Flags = 0, loc := #caller_location) {
    id := resolve_workspace(w);
    __jaic_workspace_begin_intercept(id);

    if flags & (.DO_PERFORMANCE_REPORT_POLYMORPHS | .DO_PERFORMANCE_REPORT_RUNS) {
        text := "jaic ignores the Intercept_Flags DO_PERFORMANCE_REPORT_*: it has no performance reports (use -time for timings)";
        __jaic_report(text, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx Report.WARNING);
    }

    index := find_intercept(id);
    if index < 0 {
        array_add(*intercepted, id);
        array_add(*intercept_finished, false);
        array_add(*intercept_flags, flags);
    } else {
        intercept_finished[index] = false;
        intercept_flags[index] = flags;
    }
}

compiler_end_intercept :: (w: Workspace) {
    index := find_intercept(resolve_workspace(w));
    if index < 0 return;
    array_ordered_remove_by_index(*intercepted, index);
    array_ordered_remove_by_index(*intercept_finished, index);
    array_ordered_remove_by_index(*intercept_flags, index);
    if intercept_cursor > index intercept_cursor -= 1;
}

// Returns the next message from any intercepted workspace that still has events,
// cycling between workspaces. Once every workspace has delivered its COMPLETE message,
// further calls keep returning a COMPLETE message (for the workspace that finished last),
// so `while true { m := compiler_wait_for_message(); if m.kind == .COMPLETE break; }`
// terminates. The returned message stays valid until the next call.
compiler_wait_for_message :: () -> *Message {
    tried := 0;
    while tried < intercepted.count {
        index := (intercept_cursor + tried) % intercepted.count;
        tried += 1;
        if intercept_finished[index] continue;

        id := intercepted[index];
        kind := __jaic_workspace_next_event(id);
        intercept_cursor = (index + 1) % intercepted.count;

        message := build_message(id, kind);
        if message.kind == .TYPECHECKED && !keep_typechecked(cast(*Message_Typechecked) message, intercept_flags[index]) {
            tried = 0;
            continue;
        }
        if message.kind == .COMPLETE {
            intercept_finished[index] = true;
            last_complete_workspace = id;
            last_complete_error = cast(s64) (cast(*Message_Complete) message).error_code;
        }
        return message;
    }

    // Everything has finished (or nothing was ever intercepted).
    return fill_complete(last_complete_workspace, last_complete_error);
}

compiler_custom_link_command_is_complete :: (w: Workspace, exit_code := 0) {
    __jaic_custom_link_complete(resolve_workspace(w), exit_code);
}

compiler_set_workspace_status :: (status: Workspace_Status, w: Workspace = -1) {
    // A workspace that already failed compiling keeps its failure; marking a healthy one as
    // FAILED aborts with a diagnostic so the exit code is nonzero. A failed workspace cannot
    // be made OK again, and saying so is an error rather than a no-op.
    id := resolve_workspace(w);
    failed := id == last_complete_workspace && last_complete_error != 0;
    if status == .OK {
        if failed __jaic_report("compiler_set_workspace_status: jaic cannot mark a failed workspace as OK", "", 0, 0, xx Report.ERROR);
        return;
    }
    if failed return;
    __jaic_report("the metaprogram marked the workspace as failed", "", 0, 0, xx Report.ERROR);
}

// ---------------------------------------------------------------------------
// Diagnostics and locations
// ---------------------------------------------------------------------------

// Only Report.ERROR stops the build; warnings, info and continuable errors just print.
// ERROR stops the metaprogram; ERROR_CONTINUABLE lets it go on, but the build fails.
compiler_report :: (message: string, loc := #caller_location, mode := Report.ERROR) {
    __jaic_report(message, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx mode);
}

compiler_report :: (filename: string, line_number: s64, character_number: s64, error_text: string, mode := Report.ERROR) {
    __jaic_report(error_text, filename, line_number, character_number, xx mode);
}

// A null node yields an empty location rather than crashing a reporting path.
make_location :: (c: *Code_Node) -> Source_Code_Location {
    if c == null return .{};
    return .{ fully_pathed_filename = get_filename(c), line_number = c.l0, character_number = c.c0 };
}

get_filename :: (node: *Code_Node) -> string {
    if !node || !node.enclosing_load return "";
    return node.enclosing_load.fully_pathed_filename;
}

// Breaks a path into its directory (trailing separator kept) and the file name
// minus its last extension: "dir/sub/name.tar.gz" -> ("name.tar", "dir/sub/").
get_basename_and_path :: (input_name: string) -> (basename: string, path: string) {
    // Everything up to and including the last slash or backslash is the directory.
    name_start := input_name.count;
    while name_start > 0 {
        ch := input_name[name_start - 1];
        if ch == #char "/" || ch == #char "\\" break;
        name_start -= 1;
    }

    directory := input_name;
    directory.count = name_start;

    file := input_name;
    file.data += name_start;
    file.count -= name_start;

    // Trim at the final dot of the file part, if there is one.
    stem := file.count;
    while stem > 0 {
        stem -= 1;
        if file[stem] == #char "." {
            file.count = stem;
            break;
        }
    }

    return file, directory;
}

// True when `info` reaches a struct named `base_name` by following `using` (#as)
// first members, through struct values or pointers. A type is not its own subclass.
is_subclass_of :: (info: *Type_Info, base_name: string, first_call := true) -> bool {
    hops := ifx first_call then 0 else 1;
    current := info;
    while current && current.type == .STRUCT {
        as_struct := cast(*Type_Info_Struct) current;
        if hops > 0 && as_struct.name == base_name return true;
        if as_struct.members.count == 0 return false;

        head := *as_struct.members[0];
        if !(head.flags & .AS) return false;

        // An embedded base may be held by value or behind one pointer.
        current = head.type;
        if current.type == .POINTER current = (cast(*Type_Info_Pointer) current).pointer_to;
        hops += 1;
    }
    return false;
}

// Fresh literal nodes for metaprograms that splice generated code into the AST.
make_integer_literal :: (v: s64) -> *Code_Literal {
    node := New(Code_Literal);
    node.kind = .LITERAL;
    node.value_flags = .IS_A_NUMBER;
    node.value_type = .NUMBER;
    node._s64 = v;
    return node;
}

// The text is copied so the node does not alias the caller's buffer.
make_string_literal :: (s: string) -> *Code_Literal {
    node := New(Code_Literal);
    node.kind = .LITERAL;
    node.value_type = .STRING;
    node._string = copy_text(s);
    return node;
}

// ---------------------------------------------------------------------------
// Reflection of the running program
// ---------------------------------------------------------------------------

// Only the running program's own information: another workspace's is not reachable.
get_runtime_info :: (w: Workspace = -1, loc := #caller_location) -> Runtime_Info {
    if w >= 0 && w != __jaic_current_workspace() {
        text := tprint("get_runtime_info: jaic has the type table of the running program only, not of workspace %", w);
        __jaic_report(text, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx Report.ERROR);
    }
    return __runtime_info;
}

// Provided by the compiler (filled once the program is fully compiled).
__runtime_info: Runtime_Info #elsewhere;

get_type_table :: (w: Workspace = -1, loc := #caller_location) -> [] *Type_Info {
    return get_runtime_info(w, loc).type_table;
}

// ---------------------------------------------------------------------------
// Operations that need compiler internals jaic does not expose yet. They type-check
// everywhere and report an error only when actually called.
// ---------------------------------------------------------------------------

// The nodes of `code`. From compile-time code that has done nothing observable yet, names,
// calls and types are resolved (see docs/metaprogramming/compiler-records.md).
compiler_get_nodes :: (code: Code) -> (root: *Code_Node, expressions: [] *Code_Node) {
    Code_Nodes :: struct {
        root: *Code_Node;
        expressions: [] *Code_Node;
    }
    nodes := cast(*Code_Nodes) record_struct(__jaic_code_nodes(code), type_info(Code_Nodes));
    return nodes.root, nodes.expressions;
}

// The tree under `node` as a new Code value: printed with Program_Print and parsed again.
// Without `code_to_copy_scope_from`, names resolve where the code is inserted.
compiler_get_code :: (node: *Code_Node, code_to_copy_scope_from: Code = #code,null) -> Code {
    PP :: #import "Program_Print";
    builder: String_Builder;
    PP.print_expression(*builder, node);
    return __jaic_parse_code(builder_to_string(*builder), code_to_copy_scope_from);
}

code_to_string :: (code: Code) -> string {
    PP :: #import "Program_Print";
    root := compiler_get_nodes(code);
    builder: String_Builder;
    PP.print_expression(*builder, root);
    return builder_to_string(*builder);
}

print_expression :: (builder: *String_Builder, node: *Code_Node) {
    PP :: #import "Program_Print";
    PP.print_expression(builder, node);
}

get_root_type :: (code: Code) -> (status: Get_Root_Type_Status, type: Type) {
    unsupported("get_root_type");
    result: Type;
    return .CORRUPTED, result;
}

// A `Type` is represented by its `*Type_Info`.
get_type :: (ti: *Type_Info) -> Type {
    return (cast(*Type) *ti).*;
}

compiler_set_type_info_flags :: (type: Type, flags: Type_Info_Flags) {
    __jaic_set_type_info_flags(type, cast(s64) flags);
}

__jaic_set_type_info_flags :: (type: Type, flags: s64) #compiler;

// Replaces the procedure's statements with `body.block.statements`. A statement the
// compiler built and nobody changed keeps its code; one that is new or was edited in place
// (anywhere below it) is printed with Program_Print and parsed again in the body.
// Procedures already compiled (used by #run) keep their code.
compiler_modify_procedure :: (w: Workspace, body: *Code_Procedure_Body) {
    PP :: #import "Program_Print";
    statements: [..] s64;
    sources: [..] string;
    defer array_free(statements);
    defer array_free(sources);
    for body.block.statements {
        record := record_of(it);
        if record && record_differs(it, record) record = 0;
        source: string;
        if !record {
            builder: String_Builder;
            PP.print_expression(*builder, it);
            source = builder_to_string(*builder);
        }
        array_add(*statements, record);
        array_add(*sources, source);
    }
    __jaic_modify_procedure(resolve_workspace(w), record_of(body), statements.data, sources.data, statements.count);
    body.body_flags |= .ALREADY_MODIFIED;
}

compiler_make_procedure_live :: (w: Workspace, header: *Code_Procedure_Header) {
    unsupported("compiler_make_procedure_live");
}

// Where the struct is declared; empty for a struct the program never declared (built-ins).
compiler_get_struct_location :: (w: Workspace, info: *Type_Info_Struct) -> Source_Code_Location {
    loc: Source_Code_Location;
    __jaic_struct_location(info, *loc.fully_pathed_filename, *loc.line_number, *loc.character_number);
    return loc;
}

__jaic_struct_location :: (info: *Type_Info_Struct, path: *string, line: *s64, column: *s64) #compiler;

compiler_report_errors_for_unresolved_identifiers :: (filename: string, w: Workspace = -1) {
    unsupported("compiler_report_errors_for_unresolved_identifiers");
}

compiler_report_errors_for_untyped_declarations_with_these_notes :: (w: Workspace, labels: ..string) {
    unsupported("compiler_report_errors_for_untyped_declarations_with_these_notes");
}

compiler_set_memory_breakpoint :: (pointer: *void) {
    unsupported("compiler_set_memory_breakpoint");
}

compiler_add_library_search_directory :: (path: string) {
    unsupported("compiler_add_library_search_directory");
}

compiler_get_base_path :: () -> string {
    unsupported("compiler_get_base_path");
    return "";
}

remap_import :: (w: Workspace, host_module_name: string, import_name: string, replacement_name: string) {
    unsupported("remap_import");
}

provide_import :: (w: Workspace, message: *Message_Failed_Import, type: Provided_Import_Type, value: string) {
    unsupported("provide_import");
}

// The copy lives in compile-time memory; a constant holding the returned view (`data ::
// #run add_global_data(...)`) is emitted into the program's data with its bytes. jaic
// places it with the program's other constant data whatever the segment; a user segment
// (from add_data_segment, which jaic does not have) is an error.
add_global_data :: (data: [] u8, segment: Data_Segment_Index, user_segment: *Data_Segment = null, w: Workspace = -1, loc := #caller_location) -> [] u8 {
    if segment == .USER_SEGMENT || user_segment {
        text := "add_global_data: jaic has no user data segments";
        __jaic_report(text, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx Report.ERROR);
    }
    result: [] u8;
    result.data = alloc(data.count);
    result.count = data.count;
    memcpy(result.data, data.data, data.count);
    return result;
}

add_data_segment :: (section_name: string, characteristics := Data_Segment_Characteristics.READ | .WRITE, alignment: s32 = 16, w: Workspace = -1) -> (segment: *Data_Segment, actual_segment_will_be_created: bool) {
    unsupported("add_data_segment");
    return null, false;
}

// Hook for compiler developers to attach breakpoints to; does nothing.
developer_debug :: (x: *void) {}

// ---------------------------------------------------------------------------
// Primitives bound by jaic (see docs/metaprogramming/compiler-module.md). Not part of the public API.
// ---------------------------------------------------------------------------

__jaic_workspace_create :: (name: string) -> s64 #compiler;
__jaic_current_workspace :: () -> s64 #compiler;
__jaic_workspace_add_file :: (ws: s64, path: string) #compiler;
__jaic_workspace_add_string :: (ws: s64, source: string) #compiler;
__jaic_workspace_set_option :: (ws: s64, key: string, value: string) #compiler;
__jaic_workspace_begin_intercept :: (ws: s64) #compiler;
__jaic_workspace_next_event :: (ws: s64) -> s64 #compiler;
__jaic_event_int :: (index: s64) -> s64 #compiler;
__jaic_event_string :: (index: s64) -> string #compiler;
__jaic_command_line_count :: () -> s64 #compiler;
__jaic_command_line_arg :: (index: s64) -> string #compiler;
__jaic_report :: (message: string, file: string, line: s64, column: s64, mode: s64) #compiler;
__jaic_code_is_null :: (code: Code) -> bool #compiler;
__jaic_compiler_version :: () -> string #compiler;
__jaic_custom_link_complete :: (ws: s64, exit_code: s64) #compiler;

#scope_module

#import "Basic";

// Event kinds returned by __jaic_workspace_next_event.
EVENT_FILE :: 1;
EVENT_PHASE :: 2;
EVENT_COMPLETE :: 3;
EVENT_IMPORT :: 4;
EVENT_TYPECHECKED :: 5;
EVENT_FAILED_IMPORT :: 6;
EVENT_ERROR :: 7;

PHASE_PRE_WRITE_EXECUTABLE :: 3;
PHASE_POST_WRITE_EXECUTABLE :: 4;
PHASE_READY_FOR_CUSTOM_LINK_COMMAND :: 5;

workspace_names: [..] string;

intercepted: [..] Workspace;
intercept_finished: [..] bool;
intercept_flags: [..] Intercept_Flags;
intercept_cursor: s64;

last_complete_workspace: Workspace = 2;
last_complete_error: s64;

// Message storage. One record per kind is reused; callers may only rely on a message
// until the next compiler_wait_for_message().
message_phase: Message_Phase;
message_complete: Message_Complete;
message_error: Message;
phase_object_files: [..] string;

resolve_workspace :: (w: Workspace) -> s64 {
    if w < 0 return __jaic_current_workspace();
    return w;
}

find_intercept :: (id: s64) -> s64 {
    for intercepted if it == id return it_index;
    return -1;
}

unsupported :: (name: string) {
    text := tprint("%1 is not supported by jaic yet (it needs syntax-tree access).", name);
    __jaic_report(text, "", 0, 0, xx Report.ERROR);
}

fill_complete :: (id: Workspace, error_code: s64) -> *Message {
    message_complete.kind = .COMPLETE;
    message_complete.workspace = id;
    message_complete.error_code = xx error_code;
    return *message_complete;
}

build_message :: (id: Workspace, event_kind: s64) -> *Message {
    if event_kind == {
        case EVENT_FILE;
            return record_struct(__jaic_event_int(0), type_info(Message_File));

        case EVENT_IMPORT;
            return record_struct(__jaic_event_int(0), type_info(Message_Import));

        case EVENT_TYPECHECKED;
            typechecked := cast(*Message_Typechecked) record_struct(__jaic_event_int(0), type_info(Message_Typechecked));
            // A body lowered after its header was reported reaches the header struct the
            // metaprogram may still hold from that earlier message.
            for typechecked.procedure_bodies {
                body := it.expression;
                if body && body.header body.header.body_or_null = body;
            }
            return typechecked;

        case EVENT_FAILED_IMPORT;
            return record_struct(__jaic_event_int(0), type_info(Message_Failed_Import));

        case EVENT_ERROR;
            message_error.kind = .ERROR;
            message_error.workspace = id;
            return *message_error;

        case EVENT_PHASE;
            phase := __jaic_event_int(0);
            message_phase.kind = .PHASE;
            message_phase.workspace = id;
            message_phase.phase = xx phase;
            message_phase.executable_name = "";
            message_phase.executable_write_failed = false;
            message_phase.linker_exit_code = 0;
            message_phase.num_items_waiting_to_typecheck = 0;
            phase_object_files.count = 0;
            message_phase.compiler_generated_object_files = phase_object_files;

            message_phase.support_object_files = .[];
            message_phase.system_libraries = .[];
            message_phase.user_libraries = .[];
            if phase == PHASE_PRE_WRITE_EXECUTABLE || phase == PHASE_READY_FOR_CUSTOM_LINK_COMMAND {
                // Strings: the objects, support objects, system and user libraries, then the
                // executable (counts in ints 1 to 4; PRE_WRITE has objects only).
                counts: [4] s64;
                for 0..3 counts[it] = __jaic_event_int(it + 1);
                lists: [4][..] string;
                next := 0;
                for count: counts {
                    for 0..count - 1 array_add(*lists[it_index], __jaic_event_string(next + it));
                    next += count;
                }
                for lists[0] array_add(*phase_object_files, it);
                message_phase.compiler_generated_object_files = phase_object_files;
                message_phase.support_object_files = lists[1];
                message_phase.system_libraries = lists[2];
                message_phase.user_libraries = lists[3];
                message_phase.executable_name = __jaic_event_string(next);
            } else if phase == PHASE_POST_WRITE_EXECUTABLE {
                message_phase.executable_write_failed = __jaic_event_int(1) != 0;
                message_phase.linker_exit_code = xx __jaic_event_int(2);
                message_phase.executable_name = __jaic_event_string(0);
            }
            return *message_phase;

        case EVENT_COMPLETE;
            return fill_complete(id, __jaic_event_int(0));
    }

    // 0 (or an unknown kind): the workspace has no more events; treat it as finished OK.
    return fill_complete(id, 0);
}

// Applies the SKIP_ flags of compiler_begin_intercept; false when nothing is left to send.
keep_typechecked :: (m: *Message_Typechecked, flags: Intercept_Flags) -> bool {
    if !(flags & (.SKIP_DECLARATIONS | .SKIP_PROCEDURE_HEADERS | .SKIP_PROCEDURE_BODIES | .SKIP_STRUCTS | .SKIP_OTHERS)) return true;
    if flags & .SKIP_DECLARATIONS m.declarations.count = 0;
    if flags & .SKIP_PROCEDURE_HEADERS m.procedure_headers.count = 0;
    if flags & .SKIP_PROCEDURE_BODIES m.procedure_bodies.count = 0;
    if flags & .SKIP_STRUCTS m.structs.count = 0;
    if flags & .SKIP_OTHERS m.others.count = 0;
    kept := 0;
    for m.all {
        node := it.expression;
        skip: Intercept_Flags = .SKIP_OTHERS;
        if node {
            if node.kind == {
                case .DECLARATION; skip = .SKIP_DECLARATIONS;
                case .PROCEDURE_HEADER; skip = .SKIP_PROCEDURE_HEADERS;
                case .PROCEDURE_BODY; skip = .SKIP_PROCEDURE_BODIES;
                case .STRUCT; skip = .SKIP_STRUCTS;
            }
        }
        if flags & skip continue;
        m.all[kept] = it;
        kept += 1;
    }
    m.all.count = kept;
    return kept > 0;
}

// "beta 0.2.029, jaic" -> 0, 2, 29: the first digit run, split on dots.
parse_version_numbers :: (text: string, info: *Version_Info) {
    i := 0;
    while i < text.count && !is_digit_char(text[i]) i += 1;

    parts: [3] s32;
    part := 0;
    while i < text.count && part < 3 {
        c := text[i];
        if is_digit_char(c) {
            parts[part] = parts[part] * 10 + (cast(s32) c - cast(s32) #char "0");
        } else if c == #char "." {
            part += 1;
        } else break;
        i += 1;
    }

    info.major = parts[0];
    info.minor = parts[1];
    info.micro = parts[2];
}

is_digit_char :: (c: u8) -> bool {
    return c >= #char "0" && c <= #char "9";
}

copy_text :: (s: string) -> string {
    return copy_string(s);
}

decimal :: (n: s64) -> string {
    return tprint("%", n);
}

enum_member_name :: (value: $T) -> string {
    info := cast(*Type_Info_Enum) type_info(T);
    v := cast(s64) value;
    for info.values if it == v return info.names[it_index];
    return "";
}

string_slices_equal :: (a: [] string, b: [] string) -> bool {
    if a.count != b.count return false;
    for a if it != b[it_index] return false;
    return true;
}

is_rooted :: (path: string) -> bool {
    if path.count == 0 return false;
    if path[0] == #char "/" || path[0] == #char "\\" return true;
    return path.count >= 3 && path[1] == #char ":" && (path[2] == #char "/" || path[2] == #char "\\");
}

directory_of :: (file: string) -> string {
    i := file.count - 1;
    while i >= 0 {
        if file[i] == #char "/" || file[i] == #char "\\" {
            result := file;
            result.count = i;
            return result;
        }
        i -= 1;
    }
    return "";
}

join_paths :: (directory: string, relative: string) -> string {
    return tprint("%/%", directory, relative);
}
