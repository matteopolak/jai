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
    runtime_support_report_assertion(loc, message);
    __runtime_support_disable_stack_trace = true;
    debug_break();
    return false;
}

// `path:line:col: error: assertion failed: message`, then the procedures that were running,
// innermost first, from the one running the line `loc` names: the frames above it are the
// assertion machinery itself (`assert_helper`, the context's handler, this procedure). jaic's
// interpreter replaces this with its own report (the failing line with its source, and the
// call stack), which leaves out the same frames the same way.
runtime_support_report_assertion :: (loc: Source_Code_Location, message: string) #compiler {
    write_loc(loc, true);
    write_string(": error: assertion failed", true);
    if message.count write_strings(": ", message, "\n", to_standard_error = true);
    else write_string("\n", true);

    node := context.stack_trace;
    while node && !runtime_support_runs_line(node, loc) node = node.next;
    if !node node = context.stack_trace;
    if node write_string("call stack (innermost first):\n", true);
    while node {
        if node.info {
            write_string("    ", true);
            if node.info.name.count write_string(node.info.name, true);
            else write_string("(anonymous procedure)", true);
            write_strings(" at ", runtime_support_shown_path(node.info.location.fully_pathed_filename), to_standard_error = true);
            write_number_after(":", node.line_number, true);
            write_string("\n", true);
        }
        node = node.next;
    }
}

// The directory the build started in, with a trailing separator (empty when unknown); jaic
// provides it. Paths under it are shown relative to it, the way jaic shows them.
__jaic_build_directory: string #elsewhere;

runtime_support_shown_path :: (path: string) -> string #no_context #no_abc {
    base := __jaic_build_directory;
    if base.count == 0 || path.count <= base.count return path;
    for i: 0..base.count - 1 if path[i] != base[i] return path;
    shown := path;
    shown.data += base.count;
    shown.count -= base.count;
    return shown;
}

runtime_support_runs_line :: (node: *Stack_Trace_Node, loc: Source_Code_Location) -> bool #no_context {
    return node.info != null && cast(s64) node.line_number == loc.line_number
        && runtime_support_same_text(node.info.location.fully_pathed_filename, loc.fully_pathed_filename);
}

runtime_support_same_text :: (a: string, b: string) -> bool #no_context {
    if a.count != b.count return false;
    for i: 0..a.count - 1 if a[i] != b[i] return false;
    return true;
}

runtime_support_default_logger :: (message: string, data: *void, info: Log_Info) {
    if message.count == 0 return;
    error_output := (info.common_flags & Log_Flags.ERROR) != 0;
    if message[message.count - 1] == #char "\n" write_string(message, error_output);
    else write_strings(message, "\n", to_standard_error = error_output);
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

// Called by code compiled with Build_Options.arithmetic_overflow_check on, when `+`, `-` or `*` on
// integers does not fit its type. `type_code` bit 15: fatal, bit 14: signed, bits 7-8: operator
// (1 add, 2 sub, 3 mul), low bits: operand size in bytes.
__arithmetic_overflow :: (left: s64, right: s64, type_code: u16, line_number: s64, filename: *u8) #no_context #no_aoc {
    fatal := (type_code & 0x8000) != 0;
    signed := (type_code & 0x4000) != 0;
    operator_index := (type_code >> 7) & 0x3;
    bits := cast(u64) (type_code & 0xf) * 8;

    operator_text := " * ";
    if operator_index == 1 operator_text = " + ";
    else if operator_index == 2 operator_text = " - ";

    write_failure_location(filename, line_number);
    write_string("arithmetic overflow computing ", true);
    if signed write_number(left, to_standard_error = true);
    else write_nonnegative_number(cast,no_check(u64) left, to_standard_error = true);
    write_string(operator_text, true);
    if signed write_number(right, to_standard_error = true);
    else write_nonnegative_number(cast,no_check(u64) right, to_standard_error = true);
    write_string(ifx signed then " as s" else " as u", true);
    write_nonnegative_number(bits, to_standard_error = true);
    write_string(": the result does not fit\n", true);

    if fatal my_panic();
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

// jaic's native code calls this when a runtime check fails, then traps unless the check is
// nonfatal. The wording matches the interpreter's (`ir::check_message` in jaic). `reason`:
// 1 missing return, 2 #asm divide fault, 3 index out of range (a: index, b: count), 4 cast
// overflow (a: the value; b: target bytes, bit 8 target signed, bit 9 value signed), 5 no case
// of a #complete switch matched (a: the value), 6 integer division by zero, 7 the address of a
// null pointer's target was used without a read (`p.*` boxed into an Any).
runtime_support_check_failed :: (reason: s64, a: s64, b: s64, fatal: bool, line: s64, filename: *u8) #no_context #no_abc #no_aoc {
    write_failure_location(filename, line);
    write_string(ifx fatal then "error: " else "warning: ", true);
    if reason == {
        case 1;
            write_string("reached the end of a procedure that must return a value", true);
        case 2;
            write_string("#asm division fault: the divisor is zero or the quotient does not fit", true);
        case 3;
            write_number_after("array bounds check failed: index ", a, true);
            write_number_after(" is outside an array of ", b, true);
            write_string(ifx b == 1 then " element" else " elements", true);
        case 4;
            write_string("cast of ", true);
            if b & 0x200 write_number(a, to_standard_error = true);
            else write_nonnegative_number(cast,no_check(u64) a, to_standard_error = true);
            write_string(ifx b & 0x100 then " to `s" else " to `u", true);
            write_nonnegative_number(cast,no_check(u64) (b & 0xff) * 8, to_standard_error = true);
            write_string("` overflows", true);
        case 5;
            write_number_after("no case of the `#complete` switch matches its value, ", a, true);
        case 6;
            write_string("integer division by zero", true);
        case 7;
            write_string("null pointer dereference: read through a null pointer", true);
        case;
            write_string("runtime check failed", true);
    }
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
    default_allocator :: Allocator.{ runtime_support_default_allocator_proc, null };
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
        // Code that receives a context from elsewhere (Remap_Context) compares this with its own.
        first_thread_context.context_info = type_info(#Context);
        __command_line_arguments = .{ argc, argv };
        #if OS == .WINDOWS windows_utf8_arguments();
        first_thread_temporary_storage.data = first_thread_temporary_storage_data.data;
        first_thread_temporary_storage.size = TEMPORARY_STORAGE_SIZE;
        first_thread_context.temporary_storage = *first_thread_temporary_storage;
        return *first_thread_context;
    }

    #program_export
    __jai_runtime_fini :: (_context: *void) #c_call {}
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
        success := compare_and_swap(*output_lock, 0, 1);
        if success return;
    }
}

unlock_output :: () #no_context {
    success := compare_and_swap(*output_lock, 1, 0);
    if !success debug_break();
}

// Locations print as "path:line,column".
write_loc :: (loc: Source_Code_Location, to_standard_error := false) #no_context {
    stderr := to_standard_error;
    write_string(runtime_support_shown_path(loc.fully_pathed_filename), stderr);
    write_number_after(":", loc.line_number, stderr);
    write_number_after(":", loc.character_number, stderr);
}

// Prefix for runtime failure messages: "path:line: ", always on stderr.
write_failure_location :: (filename: *u8, line: s64) #no_context {
    write_string(runtime_support_shown_path(to_string(filename)), true);
    write_number_after(":", line, true);
    write_string(": ", true);
}

write_number_after :: (separator: string, value: s64, stderr: bool) #no_context {
    write_string(separator, stderr);
    write_number(value, to_standard_error = stderr);
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
    shell32 :: #system_library "shell32";
    GetStdHandle :: (handle: s32) -> *void #foreign kernel32;
    WriteFile :: (handle: *void, buffer: *void, buffer_length: u32, written_result: *u32, overlapped: *void) -> s32 #foreign kernel32;
    GetCommandLineW :: () -> *u16 #foreign kernel32;
    GetProcessHeap :: () -> *void #foreign kernel32;
    HeapAlloc :: (heap: *void, flags: u32, bytes: u64) -> *void #foreign kernel32;
    LocalFree :: (memory: *void) -> *void #foreign kernel32;
    WideCharToMultiByte :: (code_page: u32, flags: u32, wide: *u16, wide_count: s32, bytes: *u8, byte_count: s32, default_char: *u8, used_default: *s32) -> s32 #foreign kernel32;
    CommandLineToArgvW :: (command_line: *u16, count: *s32) -> **u16 #foreign shell32;

    // The C runtime's `argv` is in the ANSI code page; Jai strings are UTF-8, so the arguments
    // are re-read from the wide command line. The copies live as long as the process.
    windows_utf8_arguments :: () #no_context {
        CP_UTF8 :: 65001;
        count: s32;
        wide := CommandLineToArgvW(GetCommandLineW(), *count);
        if !wide return;
        heap := GetProcessHeap();
        arguments := cast(**u8) HeapAlloc(heap, 0, cast(u64) (count + 1) * size_of(*u8));
        if !arguments return;
        index: s32;
        while index < count {
            bytes := WideCharToMultiByte(CP_UTF8, 0, wide[index], -1, null, 0, null, null);
            text := cast(*u8) HeapAlloc(heap, 0, cast(u64) bytes + 1);
            if !text return;
            text[0] = 0;
            WideCharToMultiByte(CP_UTF8, 0, wide[index], -1, text, bytes, null, null);
            arguments[index] = text;
            index += 1;
        }
        arguments[count] = null;
        LocalFree(wide);
        __command_line_arguments = .{ count, arguments };
    }
} else #if OS_IS_UNIX {
    libc :: #system_library "c";
    host_write :: (fd: s32, bytes: *u8, count: u64) -> s64 #foreign libc "write";
} else #if OS == .WASM {
    wasm_write_string :: (count: s64, data: *void, to_standard_error: bool) #foreign;
    wasm_debug_break :: () #foreign;
}
