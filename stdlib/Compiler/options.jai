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
    O0 :: 1;
    O1 :: 2;
    O2 :: 3;
    O3 :: 4;
    OS :: 5;
    OZ :: 6;
};

Llvm_Machine_Code_Optimization_Setting :: enum u8 {
    UNSET :: 0;
    NONE :: 1;
    LESS :: 2;
    DEFAULT :: 3;
    AGGRESSIVE :: 4;
};

Llvm_Options :: struct {
    bitcode_optimization_setting: Llvm_Bitcode_Optimization_Setting;
    machine_code_optimization_setting: Llvm_Machine_Code_Optimization_Setting;

    function_sections: bool = false;

    enable_tail_calls := false;
    enable_loop_unrolling := false;
    enable_slp_vectorization := false;
    enable_loop_vectorization := false;

    preserve_debug_info := true;

    merge_functions := false;
    disable_inlining := true;
    disable_mem2reg := false;

    enable_split_modules := true;

    output_bitcode_before_optimizations := false;
    output_llvm_ir_before_optimizations := false;

    output_bitcode := false;
    output_llvm_ir := false;

    target_system_triple: string;
    target_system_cpu: string;
    target_system_features: string;

    command_line: [] string;
}

Build_Options :: struct {
    output_type: enum u8 {
        NO_OUTPUT :: 0;
        EXECUTABLE :: 1;
        DYNAMIC_LIBRARY :: 2;
        STATIC_LIBRARY :: 3;
        OBJECT_FILE :: 4;
    } = .EXECUTABLE;

    // Settings a parent metaprogram typically wants to hand to the workspaces it creates.
    using Commonly_Propagated: struct {
        write_added_strings := true;
        runtime_storageless_type_info := false;

        shorten_filenames_in_error_messages := false;
        use_visual_studio_message_format := false;
        use_natvis_compatible_types := false;
        minimum_os_version: struct {
            major: u8;
            minor: u8;
        };

        lazy_foreign_function_lookups := false;
        disable_redzone := false;

        enable_bytecode_inliner := true;
        enable_bytecode_deduplication := true;
        stack_trace := true;
        use_ansi_color := true;
        interactive_bytecode_debugger := false;
        debug_for_expansions := false;
        enable_frame_pointers := true;

        runtime_support_definitions: enum u8 {
            AUTO;
            ENTRY_POINT_AND_INIT;
            ONLY_INIT;
            OMIT;
        } = .AUTO;
        backtrace_on_crash: enum u8 {
            OFF;
            ON;
        } = .ON;

        array_bounds_check: enum u8 {
            OFF;
            ON;
            ALWAYS;
        } = .ON;
        cast_bounds_check: enum u8 {
            OFF;
            NONFATAL;
            FATAL;
        } = .FATAL;
        null_pointer_check: enum u8 {
            OFF;
            ON;
        } = .ON;
        arithmetic_overflow_check: enum u8 {
            OFF;
            NONFATAL;
            FATAL;
        } = .OFF;

        // Which unreferenced code jaic still type-checks: NONE everything, ALL only what the
        // program reaches, MODULES_ONLY all of the program's own files (output is pruned either way).
        dead_code_elimination: enum u8 {
            NONE;
            ALL;
            MODULES_ONLY;
        } = .MODULES_ONLY;

        max_bytecode_instructions_for_inlined_initializer: s32 = 8;
        context_size_max: s32 = 4096;

        prevent_compile_time_calls_from_runtime := false;

        info_flags: enum_flags u32 {
            POLYMORPH_MATCH :: 0x1;
            POLYMORPH_DEDUPLICATE :: 0x2;
        }

        text_output_flags: enum_flags u32 {
            OUTPUT_LINK_LINE :: 0x1;
            OUTPUT_TIMING_INFO :: 0x2;
        } = xx 3;

        os_target := OS;
        cpu_target := CPU;
        backend: enum u32 {
            X64;
            LLVM;
        } = .LLVM;

        machine_options: [MACHINE_OPTIONS_SIZE] u8;

        emit_debug_info: enum u32 {
            NONE :: 0;
            DWARF :: 1;
            CODEVIEW :: 2;
            DEFAULT :: 3;
        } = .DEFAULT;

        maximum_polymorph_depth := 100;
        maximum_array_count_before_compile_time_returns_are_not_reflected_in_ast := 5000;

        x64_options: X64_Options;
        llvm_options: Llvm_Options;
    }

    output_executable_name: string;
    output_path: string;
    intermediate_path: string;
    entry_point_name: string;

    compile_time_command_line: [] string;

    append_executable_filename_extension := true;

    use_custom_link_command := false;

    temporary_storage_size: s32 = 32768;

    import_path: [] string;

    additional_linker_arguments: [] string;

    user_data_u64: u64;
    user_data_string: string;
    user_data_pointer: *void;
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
    output_path: string;
}

Optimization_Type :: enum u8 {
    DEBUG :: 0;
    VERY_DEBUG :: 1;
    OPTIMIZED :: 2;
    VERY_OPTIMIZED :: 3;
    OPTIMIZED_SMALL :: 4;
    OPTIMIZED_VERY_SMALL :: 5;
};

// Apply a whole build flavor at once: runtime checks, frame-pointer policy and the
// LLVM pass levels. Callers can still tweak individual fields afterwards.
set_optimization :: (build_options: *Build_Options, type: Optimization_Type, preserve_debug_info := true) {
    for_shipping := type != .DEBUG && type != .VERY_DEBUG;
    wide_vectors := type == .VERY_OPTIMIZED;

    ir_level, codegen_level := optimization_levels_for(type);

    backend := *build_options.llvm_options;
    backend.bitcode_optimization_setting = ir_level;
    backend.machine_code_optimization_setting = codegen_level;
    backend.preserve_debug_info = preserve_debug_info;
    backend.disable_inlining = !for_shipping;
    backend.enable_split_modules = !for_shipping;
    backend.enable_tail_calls = for_shipping;
    backend.enable_loop_unrolling = for_shipping;
    backend.enable_loop_vectorization = wide_vectors;
    backend.enable_slp_vectorization = wide_vectors;

    // Debug flavors leave arithmetic_overflow_check at whatever the caller chose.
    if for_shipping {
        build_options.arithmetic_overflow_check = .OFF;
        build_options.array_bounds_check = .OFF;
        build_options.null_pointer_check = .OFF;
        build_options.cast_bounds_check = .OFF;
    } else {
        build_options.array_bounds_check = .ON;
        build_options.null_pointer_check = .ON;
        build_options.cast_bounds_check = .FATAL;
    }

    // Unwinders and profilers on macOS expect frame pointers regardless of flavor.
    build_options.enable_frame_pointers = preserve_debug_info || !for_shipping || OS == .MACOS;
    build_options.x64_options.enable_unix_runtime_frame_information = !for_shipping;

    if !preserve_debug_info build_options.emit_debug_info = .NONE;
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

    check_build_options(previous, option_store[id], loc);
    forward_options(id, previous, option_store[id]);
}

set_build_options_dc :: (options: Build_Options_During_Compile, w: Workspace = -1, loc := #caller_location) {
    id := resolve_workspace(w);
    ensure_option_slot(id);

    stored := *option_store[id];
    if options.interactive_bytecode_debugger && !stored.interactive_bytecode_debugger {
        option_warning(loc, "Build_Options_During_Compile.interactive_bytecode_debugger", "jaic has no bytecode debugger");
    }

    if !options.do_output {
        stored.output_type = .NO_OUTPUT;
    } else if stored.output_type == .NO_OUTPUT {
        stored.output_type = .EXECUTABLE;
    }
    stored.write_added_strings = options.write_added_strings;
    stored.append_executable_filename_extension = options.append_executable_filename_extension;
    stored.interactive_bytecode_debugger = options.interactive_bytecode_debugger;
    if options.output_executable_name.count > 0 stored.output_executable_name = options.output_executable_name;
    if options.output_path.count > 0 stored.output_path = options.output_path;

    __jaic_workspace_set_option(id, "do_output", ifx options.do_output then "true" else "false");
    __jaic_workspace_set_option(id, "append_executable_filename_extension", ifx options.append_executable_filename_extension then "true" else "false");
    if options.output_executable_name.count > 0 __jaic_workspace_set_option(id, "output_executable_name", options.output_executable_name);
    if options.output_path.count > 0 __jaic_workspace_set_option(id, "output_path", options.output_path);
    for options.append_linker_arguments {
        __jaic_workspace_set_option(id, "additional_linker_argument", it);
    }
}

#scope_module

// LLVM IR and codegen levels per flavor; both debug flavors run unoptimized.
optimization_levels_for :: (type: Optimization_Type) -> Llvm_Bitcode_Optimization_Setting, Llvm_Machine_Code_Optimization_Setting {
    if type == .OPTIMIZED return .O2, .DEFAULT;
    if type == .VERY_OPTIMIZED return .O3, .AGGRESSIVE;
    if type == .OPTIMIZED_SMALL return .OS, .DEFAULT;
    if type == .OPTIMIZED_VERY_SMALL return .OZ, .AGGRESSIVE;
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
    for 0..count - 1 array_add(*result, copy_text(__jaic_command_line_arg(it)));
    return result;
}

anchor_paths :: (paths: [] string, anchor_file: string) -> [] string {
    result: [..] string;
    directory := directory_of(anchor_file);
    for paths {
        if is_rooted(it) || directory.count == 0 {
            array_add(*result, it);
        } else {
            // Keep the anchor's own separator: `C:\game\mods`, not `C:\game/mods`.
            separator := anchor_file[directory.count];
            array_add(*result, tprint("%1%2%3", directory, string.{ 1, *separator }, it));
        }
    }
    return result;
}

forward_options :: (id: s64, previous: Build_Options, options: Build_Options) {
    if options.output_executable_name.count > 0 __jaic_workspace_set_option(id, "output_executable_name", options.output_executable_name);
    if options.output_path.count > 0 __jaic_workspace_set_option(id, "output_path", options.output_path);
    __jaic_workspace_set_option(id, "output_type", enum_member_name(options.output_type));

    if !string_slices_equal(options.import_path, previous.import_path) {
        __jaic_workspace_set_option(id, "import_path_clear", "");
        for options.import_path __jaic_workspace_set_option(id, "import_path", it);
    }

    __jaic_workspace_set_option(id, "os_target", enum_member_name(options.os_target));
    __jaic_workspace_set_option(id, "cpu_target", enum_member_name(options.cpu_target));

    // The LLVM bitcode level is the single optimization knob jaic reads. UNSET is not sent
    // so the compiler keeps its own default.
    level := options.llvm_options.bitcode_optimization_setting;
    if level != .UNSET __jaic_workspace_set_option(id, "optimization", enum_member_name(level));

    // Cross targets (wasm) take their triple, CPU and feature string from here; empty means the target's default.
    llvm := options.llvm_options;
    __jaic_workspace_set_option(id, "llvm_target_system_triple", llvm.target_system_triple);
    __jaic_workspace_set_option(id, "llvm_target_system_cpu", llvm.target_system_cpu);
    __jaic_workspace_set_option(id, "llvm_target_system_features", llvm.target_system_features);

    __jaic_workspace_set_option(id, "entry_point_name", options.entry_point_name);
    __jaic_workspace_set_option(id, "temporary_storage_size", decimal(options.temporary_storage_size));
    __jaic_workspace_set_option(id, "intermediate_path", options.intermediate_path);
    __jaic_workspace_set_option(id, "append_executable_filename_extension", flag_text(options.append_executable_filename_extension));
    __jaic_workspace_set_option(id, "use_custom_link_command", flag_text(options.use_custom_link_command));
    __jaic_workspace_set_option(id, "disable_redzone", flag_text(options.disable_redzone));
    if options.runtime_support_definitions != previous.runtime_support_definitions {
        __jaic_workspace_set_option(id, "runtime_support_definitions", enum_member_name(options.runtime_support_definitions));
    }
    __jaic_workspace_set_option(id, "backtrace_on_crash", enum_member_name(options.backtrace_on_crash));

    __jaic_workspace_set_option(id, "enable_frame_pointers", flag_text(options.enable_frame_pointers));
    version := options.minimum_os_version;
    __jaic_workspace_set_option(id, "minimum_os_version", tprint("%.%", version.major, version.minor));
    machine := llvm.machine_code_optimization_setting;
    if machine != .UNSET __jaic_workspace_set_option(id, "machine_code_optimization", enum_member_name(machine));
    __jaic_workspace_set_option(id, "llvm_enable_loop_unrolling", flag_text(llvm.enable_loop_unrolling));
    __jaic_workspace_set_option(id, "llvm_enable_loop_vectorization", flag_text(llvm.enable_loop_vectorization));
    __jaic_workspace_set_option(id, "llvm_enable_slp_vectorization", flag_text(llvm.enable_slp_vectorization));
    __jaic_workspace_set_option(id, "llvm_merge_functions", flag_text(llvm.merge_functions));
    __jaic_workspace_set_option(id, "llvm_disable_inlining", flag_text(llvm.disable_inlining));
    __jaic_workspace_set_option(id, "llvm_enable_tail_calls", flag_text(llvm.enable_tail_calls));
    __jaic_workspace_set_option(id, "llvm_enable_split_modules", flag_text(llvm.enable_split_modules));
    __jaic_workspace_set_option(id, "llvm_preserve_debug_info", flag_text(llvm.preserve_debug_info));
    __jaic_workspace_set_option(id, "output_llvm_ir", flag_text(llvm.output_llvm_ir));
    __jaic_workspace_set_option(id, "output_bitcode", flag_text(llvm.output_bitcode));
    __jaic_workspace_set_option(id, "output_llvm_ir_before_optimizations", flag_text(llvm.output_llvm_ir_before_optimizations));
    __jaic_workspace_set_option(id, "output_bitcode_before_optimizations", flag_text(llvm.output_bitcode_before_optimizations));

    if !string_slices_equal(options.additional_linker_arguments, previous.additional_linker_arguments) {
        __jaic_workspace_set_option(id, "additional_linker_arguments_clear", "");
        for options.additional_linker_arguments __jaic_workspace_set_option(id, "additional_linker_argument", it);
    }

    __jaic_workspace_set_option(id, "stack_trace", ifx options.stack_trace then "true" else "false");
    __jaic_workspace_set_option(id, "emit_debug_info", enum_member_name(options.emit_debug_info));
    __jaic_workspace_set_option(id, "array_bounds_check", enum_member_name(options.array_bounds_check));
    __jaic_workspace_set_option(id, "null_pointer_check", enum_member_name(options.null_pointer_check));
    __jaic_workspace_set_option(id, "arithmetic_overflow_check", enum_member_name(options.arithmetic_overflow_check));
    __jaic_workspace_set_option(id, "cast_bounds_check", enum_member_name(options.cast_bounds_check));

    // Sent only once changed, so options that never mention it keep the command line's `-no_dce`.
    if options.dead_code_elimination != previous.dead_code_elimination {
        __jaic_workspace_set_option(id, "dead_code_elimination", enum_member_name(options.dead_code_elimination));
    }
}

flag_text :: (on: bool) -> string {
    return ifx on then "true" else "false";
}

// Options jaic cannot honour, reported when a call changes one to a value jaic would not
// act on (docs/metaprogramming/build-options.md). An error where ignoring it would build a
// different program; a warning where the program is the same and only how the compiler
// works or reports would differ.
check_build_options :: (previous: Build_Options, options: Build_Options, loc: Source_Code_Location) {
    o := *options;
    p := *previous;

    if o.backend != p.backend && o.backend != .LLVM {
        option_warning(loc, "Build_Options.backend", "jaic always generates code with LLVM, and x64_options do not apply");
    }
    if o.array_bounds_check != p.array_bounds_check && o.array_bounds_check == .ALWAYS {
        option_warning(loc, "Build_Options.array_bounds_check = .ALWAYS", "it is treated as .ON, and #no_abc still turns the checks off");
    }
    if o.runtime_storageless_type_info && !p.runtime_storageless_type_info {
        option_warning(loc, "Build_Options.runtime_storageless_type_info", "type information is always stored in the program");
    }
    if o.shorten_filenames_in_error_messages && !p.shorten_filenames_in_error_messages {
        option_warning(loc, "Build_Options.shorten_filenames_in_error_messages", "messages always name files as they were loaded");
    }
    if o.use_visual_studio_message_format && !p.use_visual_studio_message_format {
        option_warning(loc, "Build_Options.use_visual_studio_message_format", "messages always use the file:line:column format");
    }
    if o.use_natvis_compatible_types && !p.use_natvis_compatible_types {
        option_warning(loc, "Build_Options.use_natvis_compatible_types", "debug information describes types as they are declared");
    }
    if o.lazy_foreign_function_lookups && !p.lazy_foreign_function_lookups {
        option_warning(loc, "Build_Options.lazy_foreign_function_lookups", "foreign procedures are bound when the program is linked or loaded");
    }
    if o.interactive_bytecode_debugger && !p.interactive_bytecode_debugger {
        option_warning(loc, "Build_Options.interactive_bytecode_debugger", "jaic has no bytecode debugger");
    }
    if o.debug_for_expansions && !p.debug_for_expansions {
        option_warning(loc, "Build_Options.debug_for_expansions", "for_expansion bodies get the debug information of the code they expand to");
    }
    if o.prevent_compile_time_calls_from_runtime && !p.prevent_compile_time_calls_from_runtime {
        option_warning(loc, "Build_Options.prevent_compile_time_calls_from_runtime", "jaic does not check for those calls");
    }
    if o.max_bytecode_instructions_for_inlined_initializer != p.max_bytecode_instructions_for_inlined_initializer {
        option_warning(loc, "Build_Options.max_bytecode_instructions_for_inlined_initializer", "jaic has no bytecode inliner");
    }
    if o.context_size_max != p.context_size_max {
        option_warning(loc, "Build_Options.context_size_max", "the context is as large as its members need");
    }
    if o.maximum_polymorph_depth != p.maximum_polymorph_depth {
        option_warning(loc, "Build_Options.maximum_polymorph_depth", "jaic's own limit on nested polymorph instantiations applies");
    }
    if o.maximum_array_count_before_compile_time_returns_are_not_reflected_in_ast != p.maximum_array_count_before_compile_time_returns_are_not_reflected_in_ast {
        option_warning(loc, "Build_Options.maximum_array_count_before_compile_time_returns_are_not_reflected_in_ast", "jaic has no such limit");
    }
    if o.info_flags != p.info_flags && o.info_flags != 0 {
        option_warning(loc, "Build_Options.info_flags", "jaic does not print polymorph matching information");
    }
    if o.text_output_flags != p.text_output_flags && o.text_output_flags != 0 {
        option_warning(loc, "Build_Options.text_output_flags", "jaic does not print the link line or timings (use -time for timings)");
    }

    llvm := *o.llvm_options;
    before := *p.llvm_options;
    if llvm.function_sections && !before.function_sections {
        option_warning(loc, "Build_Options.llvm_options.function_sections", "jaic puts all functions of an object file in one section");
    }
    if llvm.disable_mem2reg && !before.disable_mem2reg {
        option_warning(loc, "Build_Options.llvm_options.disable_mem2reg", "the optimization pipeline is chosen by the optimization level alone");
    }
    if llvm.command_line.count > 0 && !string_slices_equal(llvm.command_line, before.command_line) {
        option_warning(loc, "Build_Options.llvm_options.command_line", "jaic does not pass options to LLVM");
    }
}

option_warning :: (loc: Source_Code_Location, field: string, reason: string) {
    text := tprint("jaic ignores %1: %2", field, reason);
    __jaic_report(text, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx Report.WARNING);
}

option_error :: (loc: Source_Code_Location, field: string, reason: string) {
    text := tprint("jaic cannot honour Build_Options.%1: %2", field, reason);
    __jaic_report(text, loc.fully_pathed_filename, loc.line_number, loc.character_number, xx Report.ERROR);
}
