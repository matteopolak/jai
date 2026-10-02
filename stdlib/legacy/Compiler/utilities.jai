// Jai implementations of operations that need no compiler service.
compiler_report :: (filename: string, line_number: s64, character_number: s64, error_text: string, mode := Report.ERROR) {
    site := Source_Code_Location.{filename, line_number, character_number};
    compiler_report(error_text, site, mode);
}

get_type_table :: (w: Workspace = -1) -> [] *Type_Info {
    snapshot := get_runtime_info(w);
    return snapshot.type_table;
}

set_optimization :: (using build_options: *Build_Options, type: Optimization_Type, preserve_debug_info := true) {
    checks_enabled := type == .DEBUG || type == .VERY_DEBUG;
    array_bounds_check = ifx checks_enabled then .ON else .OFF;
    cast_bounds_check = ifx checks_enabled then .FATAL else .OFF;
    null_pointer_check = ifx checks_enabled then .ON else .OFF;
    if !checks_enabled arithmetic_overflow_check = .OFF;
    enable_frame_pointers = preserve_debug_info || checks_enabled || OS == .MACOS;
    x64_options.enable_unix_runtime_frame_information = checks_enabled;
    llvm_options.preserve_debug_info = preserve_debug_info;
    llvm_options.disable_inlining = checks_enabled;
    llvm_options.enable_tail_calls = !checks_enabled;
    llvm_options.enable_loop_unrolling = !checks_enabled;
    llvm_options.enable_split_modules = checks_enabled;
    llvm_options.enable_slp_vectorization = type == .VERY_OPTIMIZED;
    llvm_options.enable_loop_vectorization = type == .VERY_OPTIMIZED;
    llvm_options.machine_code_optimization_setting = .DEFAULT;
    if checks_enabled {
        llvm_options.bitcode_optimization_setting = .O0;
        llvm_options.machine_code_optimization_setting = .NONE;
    } else if type == .OPTIMIZED {
        llvm_options.bitcode_optimization_setting = .O2;
    } else if type == .VERY_OPTIMIZED {
        llvm_options.bitcode_optimization_setting = .O3;
        llvm_options.machine_code_optimization_setting = .AGGRESSIVE;
    } else if type == .OPTIMIZED_SMALL {
        llvm_options.bitcode_optimization_setting = .OS;
    } else {
        llvm_options.bitcode_optimization_setting = .OZ;
    }
    if !preserve_debug_info emit_debug_info = .NONE;
}

make_integer_literal :: (v: s64) -> *Code_Literal {
    literal := New(Code_Literal);
    literal.value_type = .NUMBER;
    literal.value_flags = .IS_A_NUMBER;
    literal._s64 = v;
    return literal;
}

make_string_literal :: (s: string) -> *Code_Literal {
    literal := New(Code_Literal);
    literal.value_type = .STRING;
    storage := cast(*u8) alloc(s.count + 1);
    memcpy(storage, s.data, s.count);
    storage[s.count] = 0;
    literal._string = .{s.count, storage};
    return literal;
}

is_subclass_of :: (info: *Type_Info, base_name: string, first_call := true) -> bool {
    cursor := info;
    examined := first_call;
    while cursor {
        if cursor.type == .POINTER {
            cursor = (cast(*Type_Info_Pointer) cursor).pointer_to;
            continue;
        }
        if cursor.type != .STRUCT return false;
        record := cast(*Type_Info_Struct) cursor;
        if record.name == base_name return !examined;
        if record.members.count == 0 return false;
        parent := record.members[0];
        if !(parent.flags & .AS) return false;
        cursor = parent.type;
        examined = false;
    }
    return false;
}

make_location :: (c: *Code_Node) -> Source_Code_Location {
    if !c return .{};
    return .{get_filename(c), c.l0, c.c0};
}

get_filename :: (node: *Code_Node) -> string {
    if !node || !node.enclosing_load return "";
    return node.enclosing_load.fully_pathed_filename;
}

get_basename_and_path :: (input_name: string) -> (basename: string, path: string) {
    start: s64;
    dot: s64 = -1;
    for byte, index: input_name {
        if byte == #char "/" || byte == #char "\\" {
            start = index + 1;
            dot = -1;
        } else if byte == #char "." {
            dot = index;
        }
    }
    path := string.{start, input_name.data};
    end := ifx dot < start then input_name.count else dot;
    basename := string.{end - start, input_name.data + start};
    #if OS == .WINDOWS {
        path = copy_string(path);
        for *byte: path if byte.* == #char "\\" byte.* = #char "/";
    }
    return basename, path;
}

copy_commonly_propagated_fields :: (a: Build_Options, b: *Build_Options) {
    b.Commonly_Propagated = a.Commonly_Propagated;
}

operator_to_string :: (op: Operator_Type) -> string {
    for entry: operator_spellings if entry.op == op return entry.text;
    return "";
}

#scope_module
#import "Basic";
operator_spellings: [] struct { op: Operator_Type; text: string; } = .[
    .{.ARRAY_SUBSCRIPT, "[]"}, .{.POINTER_DEREFERENCE, "(.*)"}, .{.POSTFIX_DEREFERENCE, ".*"},
    .{.PLUS_ASSIGN, "+="}, .{.MINUS_ASSIGN, "-="}, .{.TIMES_ASSIGN, "*="}, .{.DIV_ASSIGN, "/="},
    .{.MOD_ASSIGN, "%="}, .{.IS_EQUAL, "=="}, .{.IS_NOT_EQUAL, "!="}, .{.LOGICAL_AND, "&&"},
    .{.LOGICAL_OR, "||"}, .{.LESS_OR_EQUAL, "<="}, .{.GREATER_OR_EQUAL, ">="},
    .{.SHIFT_LEFT, "<<"}, .{.SHIFT_RIGHT, ">>"}, .{.ROTATE_LEFT, "<<<"}, .{.ROTATE_RIGHT, ">>>"},
    .{.SHIFT_LEFT_ASSIGN, "<<="}, .{.SHIFT_RIGHT_ASSIGN, ">>="}, .{.ROTATE_LEFT_ASSIGN, "<<<="}, .{.ROTATE_RIGHT_ASSIGN, ">>>="},
    .{.BITWISE_AND_ASSIGN, "&="}, .{.BITWISE_OR_ASSIGN, "|="}, .{.BITWISE_XOR_ASSIGN, "^="},
    .{.LOGICAL_AND_ASSIGN, "&&="}, .{.LOGICAL_OR_ASSIGN, "||="}
];
