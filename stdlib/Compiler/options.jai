// Build_Options and friends, plus the Jai-side per-workspace option store.
//
// jaic does not own a Build_Options record that Jai code can point into. Instead
// this module keeps one Build_Options per workspace id and, on set_build_options,
// forwards the subset the Rust side understands as (key, text value) pairs through
// __jaic_workspace_set_option. See docs/metaprogramming/compiler-module.md for the key table.

#scope_export

MACHINE_OPTIONS_SIZE :: 128;

X64_Options :: struct {
    use_dlls := false;
    enable_register_allocation := false;
    enable_unix_runtime_frame_information := true;
}

Llvm_Bitcode_Optimization_Setting :: enum u8 {
    UNSET :: 0;
    O0    :: 1;
    O1    :: 2;
    O2    :: 3;
    O3    :: 4;
    OS    :: 5;
    OZ    :: 6;
};

Llvm_Machine_Code_Optimization_Setting :: enum u8 {
    UNSET      :: 0;
    NONE       :: 1;
    LESS       :: 2;
    DEFAULT    :: 3;
    AGGRESSIVE :: 4;
};

Llvm_Options :: struct {
    bitcode_optimization_setting:      Llvm_Bitcode_Optimization_Setting;
    machine_code_optimization_setting: Llvm_Machine_Code_Optimization_Setting;

    function_sections: bool = false;

    enable_tail_calls         := false;
    enable_loop_unrolling     := false;
    enable_slp_vectorization  := false;
    enable_loop_vectorization := false;

    preserve_debug_info := true;

    merge_functions  := false;
    disable_inlining := true;
    disable_mem2reg  := false;

    enable_split_modules := true;

    output_bitcode_before_optimizations := false;
    output_llvm_ir_before_optimizations := false;

    output_bitcode := false;
    output_llvm_ir := false;

    target_system_triple:   string;
    target_system_cpu:      string;
    target_system_features: string;

    command_line: [] string;
}

Build_Options :: struct {
    output_type: enum u8 {
        NO_OUTPUT       :: 0;
        EXECUTABLE      :: 1;
        DYNAMIC_LIBRARY :: 2;
        STATIC_LIBRARY  :: 3;
        OBJECT_FILE     :: 4;
    } = .EXECUTABLE;

    // Settings a parent metaprogram typically wants to hand to the workspaces it creates.
    using Commonly_Propagated: struct {
        write_added_strings           := true;
        runtime_storageless_type_info := false;

        shorten_filenames_in_error_messages := false;
        use_visual_studio_message_format    := false;
        use_natvis_compatible_types         := false;
        minimum_os_version: struct {
            major: u8;
            minor: u8;
        };

        lazy_foreign_function_lookups := false;
        disable_redzone               := false;

        enable_bytecode_inliner       := true;
        enable_bytecode_deduplication := true;
        stack_trace                   := true;
        use_ansi_color                := true;
        interactive_bytecode_debugger := false;
        debug_for_expansions          := false;
        enable_frame_pointers         := true;

        runtime_support_definitions: enum u8 {
            AUTO;
            ENTRY_POINT_AND_INIT;
            ONLY_INIT;
            OMIT;
        } = .AUTO;
        backtrace_on_crash: enum u8 { OFF; ON; } = .ON;

        array_bounds_check:        enum u8 { OFF; ON; ALWAYS; }      = .ON;
        cast_bounds_check:         enum u8 { OFF; NONFATAL; FATAL; } = .FATAL;
        null_pointer_check:        enum u8 { OFF; ON; }              = .ON;
        arithmetic_overflow_check: enum u8 { OFF; NONFATAL; FATAL; } = .OFF;

        dead_code_elimination: enum u8 { NONE; ALL; MODULES_ONLY; } = .MODULES_ONLY;

        max_bytecode_instructions_for_inlined_initializer: s32 = 8;
        context_size_max: s32 = 4096;

        prevent_compile_time_calls_from_runtime := false;

        info_flags: enum_flags u32 {
            POLYMORPH_MATCH       :: 0x1;
            POLYMORPH_DEDUPLICATE :: 0x2;
        }

        text_output_flags: enum_flags u32 {
            OUTPUT_LINK_LINE   :: 0x1;
            OUTPUT_TIMING_INFO :: 0x2;
        } = xx 3;

        os_target  := OS;
        cpu_target := CPU;
        backend: enum u32 { X64; LLVM; } = .LLVM;

        machine_options: [MACHINE_OPTIONS_SIZE] u8;

        emit_debug_info: enum u32 {
            NONE     :: 0;
            DWARF    :: 1;
            CODEVIEW :: 2;
            DEFAULT  :: 3;
        } = .DEFAULT;

        maximum_polymorph_depth := 100;
        maximum_array_count_before_compile_time_returns_are_not_reflected_in_ast := 5000;

        x64_options:  X64_Options;
        llvm_options: Llvm_Options;
    }

    output_executable_name: string;
    output_path:            string;
    intermediate_path:      string;
    entry_point_name:       string;

    compile_time_command_line: [] string;

    append_executable_filename_extension := true;

    use_custom_link_command := false;

    temporary_storage_size: s32 = 32768;

    import_path: [] string;

    additional_linker_arguments: [] string;

    user_data_u64:          u64;
    user_data_string:       string;
    user_data_pointer:      *void;
    user_data_pointer_size: s32;
}

// Options that can be changed from inside the program being compiled.
Build_Options_During_Compile :: struct {
    do_output := true;
    write_added_strings := true;
    append_executable_filename_extension := true;
    interactive_bytecode_debugger := false;

    append_linker_arguments: [] string;
    output_executable_name: string;
    output_path           : string;
}

Optimization_Type :: enum u8 {
    DEBUG                :: 0;
    VERY_DEBUG           :: 1;
    OPTIMIZED            :: 2;
    VERY_OPTIMIZED       :: 3;
    OPTIMIZED_SMALL      :: 4;
    OPTIMIZED_VERY_SMALL :: 5;
};

// Apply a whole build flavor at once: runtime checks, frame-pointer policy and the
// LLVM pass levels. Callers can still tweak individual fields afterwards.
set_optimization :: (options: *Build_Options, type: Optimization_Type, preserve_debug_info := true) {
    for_shipping := type != .DEBUG && type != .VERY_DEBUG;
    wide_vectors := type == .VERY_OPTIMIZED;

    ir_level, codegen_level := optimization_levels_for(type);

    backend := *options.llvm_options;
    backend.bitcode_optimization_setting      = ir_level;
    backend.machine_code_optimization_setting = codegen_level;
    backend.preserve_debug_info       = preserve_debug_info;
    backend.disable_inlining          = !for_shipping;
    backend.enable_split_modules      = !for_shipping;
    backend.enable_tail_calls         = for_shipping;
    backend.enable_loop_unrolling     = for_shipping;
    backend.enable_loop_vectorization = wide_vectors;
    backend.enable_slp_vectorization  = wide_vectors;

    // Debug flavors leave arithmetic_overflow_check at whatever the caller chose.
    if for_shipping {
        options.arithmetic_overflow_check = .OFF;
        options.array_bounds_check        = .OFF;
        options.null_pointer_check        = .OFF;
        options.cast_bounds_check         = .OFF;
    } else {
        options.array_bounds_check = .ON;
        options.null_pointer_check = .ON;
        options.cast_bounds_check  = .FATAL;
    }

    // Unwinders and profilers on macOS expect frame pointers regardless of flavor.
    options.enable_frame_pointers = preserve_debug_info || !for_shipping || OS == .MACOS;
    options.x64_options.enable_unix_runtime_frame_information = !for_shipping;

    if !preserve_debug_info  options.emit_debug_info = .NONE;
}

// Copy only the fields a child workspace should inherit (no names, paths or imports).
copy_commonly_propagated_fields :: (a: Build_Options, b: *Build_Options) {
    b.Commonly_Propagated = a.Commonly_Propagated;
}

get_build_options :: (w: Workspace = -1) -> Build_Options {
    id := resolve_workspace(w);
    ensure_option_slot(id);
    return option_store[id];
}

// Stores the options for workspace `w` and forwards the settings jaic understands.
// Relative `import_path` entries are anchored at the directory of `loc`.
set_build_options :: (options: Build_Options, w: Workspace = -1, loc := #caller_location) {
    id := resolve_workspace(w);
    ensure_option_slot(id);

    previous := option_store[id];
    option_store[id] = options;

    // Rewrite relative import paths in the stored copy as well, so a later
    // get_build_options() sees exactly what the compiler uses.
    if options.import_path.count > 0 && !string_slices_equal(options.import_path, previous.import_path) {
        option_store[id].import_path = anchor_paths(options.import_path, loc.fully_pathed_filename);
    }

    forward_options(id, previous, option_store[id]);
}

set_build_options_dc :: (options: Build_Options_During_Compile, w: Workspace = -1) {
    id := resolve_workspace(w);
    ensure_option_slot(id);

    stored := *option_store[id];

    if !options.do_output {
        stored.output_type = .NO_OUTPUT;
    } else if stored.output_type == .NO_OUTPUT {
        stored.output_type = .EXECUTABLE;
    }
    stored.write_added_strings = options.write_added_strings;
    stored.append_executable_filename_extension = options.append_executable_filename_extension;
    stored.interactive_bytecode_debugger = options.interactive_bytecode_debugger;
    if options.output_executable_name.count > 0  stored.output_executable_name = options.output_executable_name;
    if options.output_path.count > 0             stored.output_path = options.output_path;

    __jaic_workspace_set_option(id, "do_output", ifx options.do_output then "true" else "false");
    if options.output_executable_name.count > 0  __jaic_workspace_set_option(id, "output_executable_name", options.output_executable_name);
    if options.output_path.count > 0             __jaic_workspace_set_option(id, "output_path", options.output_path);
    for options.append_linker_arguments {
        __jaic_workspace_set_option(id, "additional_linker_argument", it);
    }
}

#scope_module

// LLVM IR and codegen levels per flavor; both debug flavors run unoptimized.
optimization_levels_for :: (type: Optimization_Type) -> Llvm_Bitcode_Optimization_Setting, Llvm_Machine_Code_Optimization_Setting {
    if type == .OPTIMIZED             return .O2, .DEFAULT;
    if type == .VERY_OPTIMIZED        return .O3, .AGGRESSIVE;
    if type == .OPTIMIZED_SMALL       return .OS, .DEFAULT;
    if type == .OPTIMIZED_VERY_SMALL  return .OZ, .AGGRESSIVE;
    return .O0, .NONE;
}

option_store: [..] Build_Options;
option_store_ready: [..] bool;

// Slot 2 (the target program, as in `jai`) is the metaprogram's own workspace: its defaults describe the host target and
// carry the command line the compiler was started with.
ensure_option_slot :: (id: s64) {
    while option_store.count <= id {
        options: Build_Options;
        array_add(*option_store, options);
        array_add(*option_store_ready, false);
    }
    if option_store_ready[id] return;
    option_store_ready[id] = true;

    // Like jai: the oldest macOS release the target CPU runs (metaprograms build target triples from it).
    stored := *option_store[id];
    if stored.os_target == .MACOS && stored.minimum_os_version.major == 0 {
        if stored.cpu_target == .ARM64 {
            stored.minimum_os_version.major = 11;
        } else {
            stored.minimum_os_version.major = 10;
            stored.minimum_os_version.minor = 13;
        }
    }

    if id == 2 {
        option_store[id].compile_time_command_line = collect_command_line();
    }
}

collect_command_line :: () -> [] string {
    count := __jaic_command_line_count();
    result: [..] string;
    for 0..count-1  array_add(*result, copy_text(__jaic_command_line_arg(it)));
    return result;
}

anchor_paths :: (paths: [] string, anchor_file: string) -> [] string {
    result: [..] string;
    directory := directory_of(anchor_file);
    for paths {
        if is_rooted(it) || directory.count == 0 {
            array_add(*result, it);
        } else {
            array_add(*result, join_paths(directory, it));
        }
    }
    return result;
}

forward_options :: (id: s64, previous: Build_Options, options: Build_Options) {
    if options.output_executable_name.count > 0  __jaic_workspace_set_option(id, "output_executable_name", options.output_executable_name);
    if options.output_path.count > 0             __jaic_workspace_set_option(id, "output_path", options.output_path);
    __jaic_workspace_set_option(id, "output_type", enum_member_name(options.output_type));

    if !string_slices_equal(options.import_path, previous.import_path) {
        __jaic_workspace_set_option(id, "import_path_clear", "");
        for options.import_path  __jaic_workspace_set_option(id, "import_path", it);
    }

    __jaic_workspace_set_option(id, "os_target",  enum_member_name(options.os_target));
    __jaic_workspace_set_option(id, "cpu_target", enum_member_name(options.cpu_target));

    // The LLVM bitcode level is the single optimization knob jaic reads. UNSET is not sent
    // so the compiler keeps its own default.
    level := options.llvm_options.bitcode_optimization_setting;
    if level != .UNSET  __jaic_workspace_set_option(id, "optimization", enum_member_name(level));

    if options.entry_point_name.count > 0  __jaic_workspace_set_option(id, "entry_point_name", options.entry_point_name);
    __jaic_workspace_set_option(id, "temporary_storage_size", decimal(options.temporary_storage_size));

    if !string_slices_equal(options.additional_linker_arguments, previous.additional_linker_arguments) {
        __jaic_workspace_set_option(id, "additional_linker_arguments_clear", "");
        for options.additional_linker_arguments  __jaic_workspace_set_option(id, "additional_linker_argument", it);
    }

    __jaic_workspace_set_option(id, "write_added_strings", ifx options.write_added_strings then "true" else "false");
    __jaic_workspace_set_option(id, "stack_trace",         ifx options.stack_trace then "true" else "false");
    __jaic_workspace_set_option(id, "emit_debug_info",     enum_member_name(options.emit_debug_info));
    __jaic_workspace_set_option(id, "array_bounds_check",        enum_member_name(options.array_bounds_check));
    __jaic_workspace_set_option(id, "null_pointer_check",        enum_member_name(options.null_pointer_check));
    __jaic_workspace_set_option(id, "arithmetic_overflow_check", enum_member_name(options.arithmetic_overflow_check));
}
