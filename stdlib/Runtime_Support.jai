// Runtime bootstrap and compiler output hooks. Native system calls use system libraries.
#module_parameters(DEFINE_SYSTEM_ENTRY_POINT: bool, DEFINE_INITIALIZATION: bool, ENABLE_BACKTRACE_ON_CRASH: bool, TEMPORARY_STORAGE_SIZE: s32 = 32768);
#scope_export
OS_IS_UNIX :: OS == .MACOS || OS == .LINUX || OS == .PS5 || OS == .IOS || OS == .ANDROID;

__element_duplicate :: (start: *u8, num_elements: s64, size: s64) #c_call #no_aoc {
    if num_elements <= 1 || size <= 0 return;
    written: s64 = 1;
    while written < num_elements {
        memcpy(start + written * size, start, size);
        written += 1;
    }
}

write_nonnegative_number :: (n: u64, base := 10, to_standard_error := false) #no_context #no_abc #no_aoc {
    if base < 2 || base > 36 {
        write_string("<invalid numeric base>", to_standard_error);
        return;
    }
    buffer: [64] u8;
    position: s64 = buffer.count;
    value := n;
    alphabet := "0123456789abcdefghijklmnopqrstuvwxyz";
    while true {
        position -= 1;
        buffer[position] = alphabet[value % cast(u64) base];
        value /= cast(u64) base;
        if value == 0 break;
    }
    text: string;
    text.count = buffer.count - position;
    text.data = buffer.data + position;
    write_string(text, to_standard_error);
}

write_number :: (n: s64, base := 10, to_standard_error := false) #no_context #no_aoc {
    bits := cast,no_check(u64) n;
    if n < 0 {
        write_string("-", to_standard_error);
        bits = 0 - bits;
    }
    write_nonnegative_number(bits, base, to_standard_error);
}

runtime_support_assertion_failed :: (loc: Source_Code_Location, message: string) -> bool {
    write_loc(loc, true);
    write_strings(": assertion failed: ", message, "\n", to_standard_error = true);
    debug_break();
    return false;
}

runtime_support_default_logger :: (message: string, data: *void, info: Log_Info) {
    if message.count == 0 return;
    error_output := (info.common_flags & Log_Flags.ERROR) != 0;
    if message[message.count - 1] == #char "\n" write_string(message, error_output);
    else write_strings(message, "\n", to_standard_error=error_output);
}

c_style_strlen :: (str: *u8) -> s64 #no_context {
    if !str return 0;
    count: s64;
    while str[count] != 0 count += 1;
    return count;
}
to_string :: (c_string: *u8) -> string #no_context {
    text: string;
    text.count = c_style_strlen(c_string);
    text.data = c_string;
    return text;
}

__array_bounds_check_fail :: (index: s64, limit: s64, line_number: s64, filename: *u8) #no_context {
    write_failure_location(filename, line_number);
    write_strings("array index ", to_standard_error = true);
    write_number(index, to_standard_error = true);
    write_string(" outside count ", true);
    write_number(limit, to_standard_error = true);
    write_string("\n", true);
    debug_break();
}
__cast_bounds_check_fail :: (pre_value: s64, pre_flags: u32, post_value: s64, post_flags: u32, fatal: u8, line_number: s64, filename: *u8) #no_context {
    write_failure_location(filename, line_number);
    write_string("numeric cast changed value ", true);
    write_number(pre_value, to_standard_error = true);
    write_string(" to ", true);
    write_number(post_value, to_standard_error = true);
    write_string("\n", true);
    if fatal != 0 debug_break();
}
__null_pointer_check_fail :: (index: s64, line_number: s64, filename: *u8) #no_context {
    write_failure_location(filename, line_number);
    write_string("null pointer access at offset ", true);
    write_number(index, to_standard_error = true);
    write_string("\n", true);
    debug_break();
}
__arithmetic_overflow :: (left: s64, right: s64, type_code: u16, line_number: s64, filename: *u8) #no_context #no_aoc {
    write_failure_location(filename, line_number);
    write_string("arithmetic overflow: ", true);
    write_number(left, to_standard_error = true);
    write_string(", ", true);
    write_number(right, to_standard_error = true);
    write_string("\n", true);
}

write_string_unsynchronized :: (s: string, to_standard_error := false) #no_context {
    #if OS == .WASM {
        wasm_write_string(s.count, s.data, to_standard_error);
    } else {
        cursor: s64;
        while cursor < s.count {
            #if OS == .WINDOWS {
                handle := GetStdHandle(ifx to_standard_error then -12 else -11);
                remaining := s.count - cursor;
                if remaining > 0x7fff_ffff remaining = 0x7fff_ffff;
                requested := cast(u32) remaining;
                transferred: u32;
                if WriteFile(handle, s.data + cursor, requested, *transferred, null) == 0 return;
                amount := cast(s64) transferred;
            } else #if OS_IS_UNIX {
                amount := host_write(ifx to_standard_error then 2 else 1, s.data + cursor, cast(u64) (s.count - cursor));
            } else {
                #assert false "Runtime output requires a host adapter for this target";
            }
            // A failed or zero write cannot make forward progress.
            if amount <= 0 return;
            cursor += amount;
        }
    }
}

write_string :: (s: string, to_standard_error := false) #no_context #compiler {
    lock_output();
    defer unlock_output();
    write_string_unsynchronized(s, to_standard_error);
}
write_strings :: (strings: ..string, to_standard_error := false) #no_context #compiler {
    lock_output();
    defer unlock_output();
    for text: strings write_string_unsynchronized(text, to_standard_error);
}

compile_time_debug_break :: () #compiler #no_context;
debug_break :: () #no_context {
    if #compile_time {
        compile_time_debug_break();
    } else {
        #if CPU == .X64 {
            #asm { int3; }
        } else #if CPU == .ARM64 {
            #bytes .[0x20, 0x00, 0x20, 0xd4];
        } else #if OS == .WASM {
            wasm_debug_break();
        } else {
            #assert false "Debug trap requires a target adapter";
        }
    }
}

one_time_init :: (synch_value: *s32, to_insert: Code) #expand {
    while true {
        success, previous := compare_and_swap(synch_value, 0, 1);
        if success {
            #insert to_insert;
            committed, old := compare_and_swap(synch_value, 1, 2);
            if !committed debug_break();
            break;
        }
        if previous == 2 break;
    }
}

Context_Base :: struct {
    context_info: *Type_Info_Struct;
    thread_index: u32;
    allocator := default_allocator;
    logger := runtime_support_default_logger;
    logger_data: *void;
    log_source_identifier: u64;
    log_level: Log_Level;
    temporary_storage: *Temporary_Storage;
    stack_trace: *Stack_Trace_Node;
    assertion_failed := runtime_support_assertion_failed;
    handling_assertion_failure := false;
    default_allocator :: Allocator.{runtime_support_default_allocator_proc, null};
}
// The arena bookkeeping lives in `implementation_data`, owned by Basic's temporary allocator.
Temporary_Storage :: struct {
    data: *u8;
    size: s64;
    total_bytes_occupied: s64;
    high_water_mark: s64;
    last_set_mark_location: Source_Code_Location;
    implementation_data: [256] u8;
}

runtime_support_default_allocator_proc :: Default_Allocator.allocator_proc;

#if DEFINE_INITIALIZATION {
    first_thread_context: #Context;
    first_thread_temporary_storage: Temporary_Storage;
    first_thread_temporary_storage_data: [TEMPORARY_STORAGE_SIZE] u8 #align 64;
    #program_export
    __jai_runtime_init :: (argc: s32, argv: **u8) -> *#Context #c_call {
        initializer_of(#Context)(*first_thread_context);
        __command_line_arguments = .{argc, argv};
        first_thread_temporary_storage.data = first_thread_temporary_storage_data.data;
        first_thread_temporary_storage.size = TEMPORARY_STORAGE_SIZE;
        first_thread_context.temporary_storage = *first_thread_temporary_storage;
        return *first_thread_context;
    }
    #program_export
    __jai_runtime_fini :: (_context: *void) #c_call {
    }
}

// Optional startup hooks are ordinary source callbacks, run in registration order.
runtime_startup_first_hooks: [] ();
runtime_startup_second_hooks: [] ();
__instrumentation_first :: () {
    for callback: runtime_startup_first_hooks callback();
}
__instrumentation_second :: () {
    for callback: runtime_startup_second_hooks callback();
}

#if DEFINE_SYSTEM_ENTRY_POINT {
    #program_export "main"
    __system_entry_point :: (argc: s32, argv: **u8) -> s32 #c_call {
        runtime_context := __jai_runtime_init(argc, argv);
        exit_code: s32;
        push_context runtime_context.* {
            #if ENABLE_BACKTRACE_ON_CRASH {
                Handler :: #import "Runtime_Support_Crash_Handler";
                Handler.init();
            }
            __instrumentation_first();
            __instrumentation_second();
            // The compiler binds this to the program's `main`; a `main` returning
            // an integer provides the process exit code.
            __program_main :: () -> s32 #entry_point;
            exit_code = __program_main();
        }
        __jai_runtime_fini(runtime_context);
        return exit_code;
    }
}

#scope_module
Default_Allocator :: #import "Default_Allocator";
output_lock: s32;
lock_output :: () #no_context {
    while true {
        success, previous := compare_and_swap(*output_lock, 0, 1);
        if success return;
    }
}
unlock_output :: () #no_context {
    success, previous := compare_and_swap(*output_lock, 1, 0);
    if !success debug_break();
}
write_loc :: (loc: Source_Code_Location, to_standard_error := false) #no_context {
    write_string(loc.fully_pathed_filename, to_standard_error);
    write_string(":", to_standard_error);
    write_number(loc.line_number, to_standard_error = to_standard_error);
    write_string(":", to_standard_error);
    write_number(loc.character_number, to_standard_error = to_standard_error);
}
write_failure_location :: (filename: *u8, line: s64) #no_context {
    write_string(to_string(filename), true);
    write_string(":", true);
    write_number(line, to_standard_error = true);
    write_string(": ", true);
}
my_panic :: () #no_context {
    write_string("runtime panic\n", true);
    debug_break();
}
__panic_due_to_runtime_call_of_compile_time_procedure :: (line_number: s64, filename: *u8) #no_context {
    write_failure_location(filename, line_number);
    write_string("compile-time procedure called at runtime\n", true);
    my_panic();
}

#if OS == .WINDOWS {
    kernel32 :: #system_library "kernel32";
    GetStdHandle :: (handle: s32) -> *void #foreign kernel32;
    WriteFile :: (handle: *void, buffer: *void, buffer_length: u32, written_result: *u32, overlapped: *void) -> s32 #foreign kernel32;
} else #if OS_IS_UNIX {
    libc :: #system_library "c";
    host_write :: (fd: s32, bytes: *u8, count: u64) -> s64 #foreign libc "write";
} else #if OS == .WASM {
    wasm_write_string :: (count: s64, data: *void, to_standard_error: bool) #foreign;
    wasm_debug_break :: () #foreign;
}
