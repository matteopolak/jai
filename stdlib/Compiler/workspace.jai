// Workspace management, message interception, reporting and the remaining Compiler
// procedures. Everything that needs the compiler goes through the __jaic_* primitives
// declared at the bottom of this file.

#scope_export

Report :: enum u8 {
    ERROR             :: 0;
    ERROR_CONTINUABLE :: 1;
    WARNING           :: 2;
    INFO              :: 3;
}

Workspace_Status :: enum u8 {
    OK     :: 0;
    FAILED :: 1;
}

Intercept_Flags :: enum_flags u32 {
    SKIP_EXPRESSIONS_WITHOUT_NOTES :: 0x1;
    SKIP_DECLARATIONS              :: 0x2;
    SKIP_PROCEDURE_HEADERS         :: 0x4;
    SKIP_PROCEDURE_BODIES          :: 0x8;
    SKIP_STRUCTS                   :: 0x10;
    SKIP_OTHERS                    :: 0x20;
    SKIP_ALL                       :: SKIP_EXPRESSIONS_WITHOUT_NOTES | SKIP_DECLARATIONS | SKIP_PROCEDURE_HEADERS | SKIP_PROCEDURE_BODIES | SKIP_STRUCTS | SKIP_OTHERS;
    DO_PERFORMANCE_REPORT_POLYMORPHS :: 0x1000;
    DO_PERFORMANCE_REPORT_RUNS       :: 0x2000;
}

Version_Info :: struct {
    major: s32;
    minor: s32;
    micro: s32;
}

Metaprogram_Plugin :: struct {
    workspace: Workspace;

    before_intercept:  (p: *Metaprogram_Plugin, flags: *Intercept_Flags);
    add_source:        (p: *Metaprogram_Plugin);
    message:           (p: *Metaprogram_Plugin, message: *Message);
    finish:            (p: *Metaprogram_Plugin);
    shutdown:          (p: *Metaprogram_Plugin);

    handle_one_option: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> (new_cursor: int);
    log_help:          (p: *Metaprogram_Plugin);
}

Get_Root_Type_Status :: enum u8 {
    UNINITIALIZED      :: 0;
    SUCCESS            :: 1;
    INPUT_IS_CODE_NULL :: 2;
    CORRUPTED          :: 3;
    NOT_TYPED          :: 4;
}

Type_Info_Flags :: enum u32 {
    NO_TYPE_INFO                 :: 0x1;
    PROCEDURES_ARE_VOID_POINTERS :: 0x2;
    NO_SIZE_COMPLAINT            :: 0x4;
}

Runtime_Info :: struct {
    type_table: [] *Type_Info;

    global_data_info: *Global_Data_Info;
}

Data_Segment_Index :: enum u16 {
    WRITABLE          :: 0x0;
    WRITABLE_NO_RESET :: 0x1;
    READ_ONLY         :: 0x2;
    BSS               :: 0x3;
    USER_SEGMENT      :: 0x10;
}

Data_Segment :: struct {}

Data_Segment_Characteristics :: enum_flags u32 {
    READ    :: 0x1;
    WRITE   :: 0x2;
    EXECUTE :: 0x4;
    ZEROED  :: 0x8;
}

Global_Data_Segment_Info :: struct {
    segment_tag: enum u16 {
        BSS      :: 0;
        DATA     :: 1;
        RDATA    :: 2;
        NO_RESET :: 3;

        USER :: 5;
    }

    data: [] u8;
}

Global_Data_Info :: struct {
    version_stamp: u64;
    segment_info:  [] Global_Data_Segment_Info;
}

Compiler_Pin :: struct {
    name: string;
    pin:  string;
}

// ---------------------------------------------------------------------------
// Workspaces
// ---------------------------------------------------------------------------

compiler_create_workspace :: (name := "") -> Workspace {
    id := __jaic_workspace_create(name);
    ensure_option_slot(id);
    while workspace_names.count <= id  array_add(*workspace_names, "");
    workspace_names[id] = copy_text(name);
    return id;
}

compiler_destroy_workspace :: (w: Workspace) {
    // jaic keeps finished workspaces alive for diagnostics; only drop our own bookkeeping.
    compiler_end_intercept(w);
}

get_current_workspace :: () -> Workspace {
    return __jaic_current_workspace();
}

get_name :: (w: Workspace = -1) -> string {
    id := resolve_workspace(w);
    if id < 0 || id >= workspace_names.count  return "";
    return workspace_names[id];
}

add_build_file :: (filename: string, w: Workspace, loc := #caller_location) {
    __jaic_workspace_add_file(resolve_workspace(w), filename);
}

// `code` only names a scope in the reference compiler. jaic adds the text to the
// workspace's top level regardless.
add_build_string :: (data: string, w: Workspace, code := #code,null, loc := #caller_location) {
    __jaic_workspace_add_string(resolve_workspace(w), data);
}

// The scoped-by-message form: jaic cannot target a particular file or module scope
// yet, so the text lands in the workspace's top level.
add_build_string :: (data: string, w: Workspace, message: *Message, loc := #caller_location) {
    __jaic_workspace_add_string(resolve_workspace(w), data);
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

compiler_begin_intercept :: (w: Workspace, flags: Intercept_Flags = 0) {
    id := resolve_workspace(w);
    __jaic_workspace_begin_intercept(id);

    index := find_intercept(id);
    if index < 0 {
        array_add(*intercepted, id);
        array_add(*intercept_finished, false);
    } else {
        intercept_finished[index] = false;
    }
}

compiler_end_intercept :: (w: Workspace) {
    index := find_intercept(resolve_workspace(w));
    if index < 0  return;
    array_ordered_remove_by_index(*intercepted, index);
    array_ordered_remove_by_index(*intercept_finished, index);
    if intercept_cursor > index  intercept_cursor -= 1;
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
        if intercept_finished[index]  continue;

        id := intercepted[index];
        kind := __jaic_workspace_next_event(id);
        intercept_cursor = (index + 1) % intercepted.count;

        message := build_message(id, kind);
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
    // jaic has no status primitive. A workspace that already failed compiling keeps its
    // failure; marking a healthy one as FAILED aborts with a diagnostic so the exit code
    // is nonzero. Marking a workspace OK again cannot be honoured.
    if status != .FAILED  return;
    id := resolve_workspace(w);
    if id == last_complete_workspace && last_complete_error != 0  return;
    __jaic_report("The workspace was marked as failed by its metaprogram.", "", 0, 0, true);
}

// ---------------------------------------------------------------------------
// Diagnostics and locations
// ---------------------------------------------------------------------------

// Fatal for Report.ERROR; the other severities are reported without stopping the compile.
compiler_report :: (message: string, loc := #caller_location, mode := Report.ERROR) {
    fatal := mode == .ERROR;
    __jaic_report(message, loc.fully_pathed_filename, loc.line_number, loc.character_number, fatal);
}

compiler_report :: (filename: string, line_number: s64, character_number: s64, error_text: string, mode := Report.ERROR) {
    loc: Source_Code_Location;
    loc.fully_pathed_filename = filename;
    loc.line_number           = line_number;
    loc.character_number      = character_number;

    compiler_report(error_text, loc, mode);
}

make_location :: (c: *Code_Node) -> Source_Code_Location {
    loc: Source_Code_Location;
    if !c  return loc;
    loc.fully_pathed_filename = get_filename(c);
    loc.line_number           = c.l0;
    loc.character_number      = c.c0;
    return loc;
}

get_filename :: (node: *Code_Node) -> string {
    if !node || !node.enclosing_load  return "";
    return node.enclosing_load.fully_pathed_filename;
}

// Splits "a/b/c/d.foo.txt" into ("d.foo", "a/b/c/").
get_basename_and_path :: (input_name: string) -> (basename: string, path: string) {
    if input_name.count == 0  return "", "";

    dot_index   := -1;
    slash_index := -1;
    i := input_name.count - 1;
    while i >= 0 {
        c := input_name[i];
        if c == #char "." && dot_index == -1  dot_index = i;
        if c == #char "/" || c == #char "\\" {
            slash_index = i;
            break;
        }
        i -= 1;
    }

    basename := input_name;
    output_path := "";
    if slash_index >= 0 {
        basename.data  += slash_index + 1;
        basename.count -= slash_index + 1;
        output_path = input_name;
        output_path.count = slash_index + 1;
    }

    if dot_index >= 0 && dot_index > slash_index {
        basename.count = dot_index - slash_index - 1;
    }

    return basename, output_path;
}

is_subclass_of :: (info: *Type_Info, base_name: string, first_call := true) -> bool {
    if info.type != .STRUCT  return false;

    info_struct := cast(*Type_Info_Struct) info;

    while true {
        if info_struct.name == base_name  return !first_call;

        if info_struct.members.count == 0  break;

        member := info_struct.members[0];
        if !(member.flags & .AS)  break;

        member_type := member.type;
        if member_type.type == .STRUCT {
            info_struct = cast(*Type_Info_Struct) member_type;
            first_call = false;
            continue;
        } else if member_type.type == .POINTER {
            pointer := cast(*Type_Info_Pointer) member_type;
            return is_subclass_of(pointer.pointer_to, base_name, false);
        } else break;
    }

    return false;
}

make_integer_literal :: (v: s64) -> *Code_Literal {
    literal := New(Code_Literal);

    literal.kind        = .LITERAL;
    literal.value_type  = .NUMBER;
    literal.value_flags = .IS_A_NUMBER;
    literal._s64        = v;

    return literal;
}

make_string_literal :: (s: string) -> *Code_Literal {
    literal := New(Code_Literal);
    literal.kind       = .LITERAL;
    literal.value_type = .STRING;
    literal._string    = copy_text(s);
    return literal;
}

// ---------------------------------------------------------------------------
// Reflection of the running program
// ---------------------------------------------------------------------------

get_runtime_info :: (w: Workspace = -1) -> Runtime_Info {
    return __runtime_info;
}

// Provided by the compiler (filled once the program is fully compiled).
__runtime_info: Runtime_Info #elsewhere;

get_type_table :: (w: Workspace = -1) -> [] *Type_Info {
    return get_runtime_info(w).type_table;
}

// ---------------------------------------------------------------------------
// Operations that need compiler internals jaic does not expose yet. They type-check
// everywhere and report an error only when actually called.
// ---------------------------------------------------------------------------

compiler_get_nodes :: (code: Code) -> (root: *Code_Node, expressions: [] *Code_Node) {
    unsupported("compiler_get_nodes");
    nodes: [] *Code_Node;
    return null, nodes;
}

compiler_get_code :: (node: *Code_Node, code_to_copy_scope_from: Code = #code,null) -> Code {
    unsupported("compiler_get_code");
    return #code,null;
}

code_to_string :: (code: Code) -> string {
    unsupported("code_to_string");
    return "";
}

print_expression :: (builder: *String_Builder, node: *Code_Node) {
    unsupported("print_expression");
}

get_root_type :: (code: Code) -> (status: Get_Root_Type_Status, type: Type) {
    unsupported("get_root_type");
    result: Type;
    return .CORRUPTED, result;
}

get_type :: (ti: *Type_Info) -> Type {
    unsupported("get_type");
    result: Type;
    return result;
}

compiler_set_type_info_flags :: (type: Type, flags: Type_Info_Flags) {
    unsupported("compiler_set_type_info_flags");
}

compiler_modify_procedure :: (w: Workspace, body: *Code_Procedure_Body) {
    unsupported("compiler_modify_procedure");
}

compiler_make_procedure_live :: (w: Workspace, header: *Code_Procedure_Header) {
    unsupported("compiler_make_procedure_live");
}

compiler_get_struct_location :: (w: Workspace, info: *Type_Info_Struct) -> Source_Code_Location {
    unsupported("compiler_get_struct_location");
    loc: Source_Code_Location;
    return loc;
}

compiler_report_errors_for_unresolved_identifiers :: (filename: string, w: Workspace = -1) {
    unsupported("compiler_report_errors_for_unresolved_identifiers");
}

compiler_report_errors_for_untyped_declarations_with_these_notes :: (w: Workspace, labels: .. string) {
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

add_global_data :: (data: [] u8, segment: Data_Segment_Index, user_segment: *Data_Segment = null, w: Workspace = -1) -> [] u8 {
    unsupported("add_global_data");
    nothing: [] u8;
    return nothing;
}

add_data_segment :: (section_name: string, characteristics := Data_Segment_Characteristics.READ | .WRITE, alignment: s32 = 16, w: Workspace = -1) -> (segment: *Data_Segment, actual_segment_will_be_created: bool) {
    unsupported("add_data_segment");
    return null, false;
}

// Hook for compiler developers to attach breakpoints to; does nothing.
developer_debug :: (x: *void) {}

// ---------------------------------------------------------------------------
// Primitives bound by jaic (see docs/compiler-module.md). Not part of the public API.
// ---------------------------------------------------------------------------

__jaic_workspace_create          :: (name: string) -> s64 #compiler;
__jaic_current_workspace         :: () -> s64 #compiler;
__jaic_workspace_add_file        :: (ws: s64, path: string) #compiler;
__jaic_workspace_add_string      :: (ws: s64, source: string) #compiler;
__jaic_workspace_set_option      :: (ws: s64, key: string, value: string) #compiler;
__jaic_workspace_begin_intercept :: (ws: s64) #compiler;
__jaic_workspace_next_event      :: (ws: s64) -> s64 #compiler;
__jaic_event_int                 :: (index: s64) -> s64 #compiler;
__jaic_event_string              :: (index: s64) -> string #compiler;
__jaic_command_line_count        :: () -> s64 #compiler;
__jaic_command_line_arg          :: (index: s64) -> string #compiler;
__jaic_report                    :: (message: string, file: string, line: s64, column: s64, is_error: bool) #compiler;
__jaic_compiler_version          :: () -> string #compiler;
__jaic_custom_link_complete      :: (ws: s64, exit_code: s64) #compiler;

#scope_module

#import "Basic";

// Event kinds returned by __jaic_workspace_next_event.
EVENT_FILE     :: 1;
EVENT_PHASE    :: 2;
EVENT_COMPLETE :: 3;
EVENT_IMPORT   :: 4;

PHASE_PRE_WRITE_EXECUTABLE         :: 3;
PHASE_POST_WRITE_EXECUTABLE        :: 4;
PHASE_READY_FOR_CUSTOM_LINK_COMMAND :: 5;

workspace_names: [..] string;

intercepted:        [..] Workspace;
intercept_finished: [..] bool;
intercept_cursor:   s64;

last_complete_workspace: Workspace = 1;
last_complete_error:     s64;

// Message storage. One record per kind is reused; callers may only rely on a message
// until the next compiler_wait_for_message().
message_file:     Message_File;
message_import:   Message_Import;
message_phase:    Message_Phase;
message_complete: Message_Complete;
phase_object_files: [..] string;

resolve_workspace :: (w: Workspace) -> s64 {
    if w < 0  return __jaic_current_workspace();
    return w;
}

find_intercept :: (id: s64) -> s64 {
    for intercepted  if it == id  return it_index;
    return -1;
}

unsupported :: (name: string) {
    text := tprint("%1 is not supported by jaic yet (it needs syntax-tree access).", name);
    __jaic_report(text, "", 0, 0, true);
}

fill_complete :: (id: Workspace, error_code: s64) -> *Message {
    message_complete.kind       = .COMPLETE;
    message_complete.workspace  = id;
    message_complete.error_code = xx error_code;
    return *message_complete;
}

build_message :: (id: Workspace, event_kind: s64) -> *Message {
    if event_kind == {
        case EVENT_FILE;
            message_file.kind  = .FILE;
            message_file.workspace = id;
            message_file.fully_pathed_filename = __jaic_event_string(0);
            message_file.enclosing_import = null;
            message_file.from_a_string = false;
            return *message_file;

        case EVENT_IMPORT;
            message_import.kind = .IMPORT;
            message_import.workspace = id;
            message_import.module_name = __jaic_event_string(0);
            message_import.fully_pathed_filename = __jaic_event_string(1);
            message_import.module_type = ifx message_import.fully_pathed_filename.count > 0 then .FILE else .UNINITIALIZED;
            return *message_import;

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

            if phase == PHASE_PRE_WRITE_EXECUTABLE || phase == PHASE_READY_FOR_CUSTOM_LINK_COMMAND {
                count := __jaic_event_int(1);
                for 0..count-1  array_add(*phase_object_files, __jaic_event_string(it));
                message_phase.compiler_generated_object_files = phase_object_files;
                message_phase.executable_name = __jaic_event_string(count);
            } else if phase == PHASE_POST_WRITE_EXECUTABLE {
                message_phase.executable_name = __jaic_event_string(0);
            }
            return *message_phase;

        case EVENT_COMPLETE;
            return fill_complete(id, __jaic_event_int(0));
    }

    // 0 (or an unknown kind): the workspace has no more events; treat it as finished OK.
    return fill_complete(id, 0);
}

// "beta 0.2.025, jaic" -> 0, 2, 25: the first digit run, split on dots.
parse_version_numbers :: (text: string, info: *Version_Info) {
    i := 0;
    while i < text.count && !is_digit_char(text[i])  i += 1;

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
    for info.values  if it == v  return info.names[it_index];
    return "";
}

string_slices_equal :: (a: [] string, b: [] string) -> bool {
    if a.count != b.count  return false;
    for a  if it != b[it_index]  return false;
    return true;
}

is_rooted :: (path: string) -> bool {
    if path.count == 0  return false;
    if path[0] == #char "/" || path[0] == #char "\\"  return true;
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
