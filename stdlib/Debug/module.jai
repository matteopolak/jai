// Debug API: backtraces, breakpoints, assert and signal handlers. Runtime operations call host APIs.
#module_parameters(USE_GRAPHICS := true);
CRASH_HANDLER_USE_SEPARATE_THREAD :: false;

Assert_Response :: enum {
    Ignore;
    Debug;
    Abort;
}

Exit_Code :: enum s32 {
    Success :: 0;
    Failure :: 1;
    Abort :: 2;
    Assert :: 3;
    Exception :: 4;
}

Minidump_State :: enum {
    None;
    Mini;
    Full;
}

Crash_Handler :: #type (trace: [] string);
crash_handler: Crash_Handler;
ignored_asserts: Table(Source_Code_Location, bool, hash_scl, compare_scl);

hash_scl :: (loc: Source_Code_Location) -> u32 {
    hash: u32 = 2166136261;
    for byte: loc.fully_pathed_filename hash = cast,no_check(u32) (cast(u64) (hash ^ byte) * 16777619);
    line := cast,no_check(u64) loc.line_number;
    column := cast,no_check(u64) loc.character_number;
    for index: 0..7 {
        hash = cast,no_check(u32) (cast(u64) (hash ^ cast(u8) (line >> (index * 8) & 0xff)) * 16777619);
        hash = cast,no_check(u32) (cast(u64) (hash ^ cast(u8) (column >> (index * 8) & 0xff)) * 16777619);
    }
    return hash;
}

compare_scl :: (a: Source_Code_Location, b: Source_Code_Location) -> bool {
    if a.line_number != b.line_number || a.character_number != b.character_number return false;
    return a.fully_pathed_filename == b.fully_pathed_filename;
}

init :: () {
    enable_signal_handler(signal_handler_interactive);

    base: #Context;
    if context.assertion_failed == base.assertion_failed {
        // Replace the default assert handler.
        #if USE_GRAPHICS context.assertion_failed = interactive_assert;
        else context.assertion_failed = break_assert;
    }
    if context.logger == base.logger context.logger = logger;
}

backtrace :: (trace: [] *void, skip := 0) -> int {
    return backtrace(trace, trace.count, skip + 1);
}

backtrace :: (trace: [] *void, maxcount: int, skip := 0) -> int {
    #if OS == .MACOS || OS == .LINUX || OS == .ANDROID {
        frames: [256] *void;
        count := host_backtrace(frames.data, frames.count);
        first := skip;
        if first < 0 first = 0;
        if first > count first = count;
        available := count - first;
        if maxcount < available available = maxcount;
        if trace.count < available available = trace.count;
        if available < 0 available = 0;
        for index: 0..available - 1 trace[index] = frames[first + index];
        return available;
    } else #if OS == .WINDOWS {
        wanted := min(maxcount, trace.count);
        if wanted <= 0 return 0;
        first := cast(u32) max(skip, 0);
        return Windows.RtlCaptureStackBackTrace(first, cast(u32) min(wanted, 0xffff), trace.data, null);
    } else {
        // No native stack to walk (wasm): report an empty capture.
        return 0;
    }
}

backtrace_symbols :: (trace: [] *void, n: int) -> [] string {
    if n < 0 n = 0;
    if n > trace.count n = trace.count;
    result: [] string;
    result.count = n;
    result.data = cast(*string) alloc(n * size_of(string));
    #if OS == .WINDOWS {
        // Without debug information at hand, name each frame by its module and offset.
        for index: 0..n - 1 result[index] = describe_address(trace[index]);
        return result;
    } else #if OS == .WASM {
        for index: 0..n - 1 result[index] = sprint("0x%", formatInt(cast(u64) trace[index], base = 16));
        return result;
    } else {
        symbols := host_backtrace_symbols(trace.data, cast(s32) n);
        if !symbols {
            free(result.data);
            return .{};
        }
        for index: 0..n - 1 result[index] = copy_string(to_string(symbols[index]));
        host_free(symbols);
        return result;
    }
}

translate_symbols :: (trace: [] *void, n: int) -> [] string {
    return backtrace_symbols(trace, n);
}

backtrace :: (skip := 0) -> [] string {
    addresses: [64] *void;
    found := backtrace(addresses, addresses.count, skip + 1);
    return translate_symbols(addresses, found);
}

free_backtrace :: (trace_symbols: [] string) {
    for text: trace_symbols free(text.data);
    free(trace_symbols.data);
}

// Stops in an attached debugger the first time this call site is reached. The site is
// only remembered once a break actually happened, so running without a debugger first
// does not use up the break.
break_once :: inline (loc := #caller_location) -> bool {
    if table_contains(*ignored_asserts, loc) return false;
    stopped := breakpoint();
    if stopped table_set(*ignored_asserts, loc, true);
    return stopped;
}

breakpoint :: () -> bool #expand #no_debug {
    if !is_debugger_present() return false;
    debug_break();
    return true;
}

is_debugger_present :: inline () -> bool {
    #if OS == .WINDOWS {
        return Windows.IsDebuggerPresent() != 0;
    } else #if OS == .MACOS {
        query: [4] s32 = .[POSIX.CTL_KERN, POSIX.KERN_PROC, POSIX.KERN_PROC_PID, POSIX.getpid()];
        process: POSIX.kinfo_proc;
        count: u64 = size_of(POSIX.kinfo_proc);
        if POSIX.sysctl(query.data, query.count, *process, *count, null, 0) != 0 return false;
        return cast(bool) (process.kp_proc.p_flag & POSIX.P_TRACED);
    } else #if OS == .LINUX || OS == .ANDROID {
        descriptor := host_open("/proc/self/status".data, 0);
        if descriptor < 0 return false;
        defer host_close(descriptor);
        bytes: [4096] u8;
        count := host_read(descriptor, bytes.data, bytes.count);
        if count <= 0 return false;
        text := string.{ count, bytes.data };
        label := "TracerPid:";
        for start: 0..text.count - label.count {
            matching := true;
            for byte, index: label if text[start + index] != byte matching = false;
            if !matching continue;
            cursor := start + label.count;
            while cursor < text.count && (text[cursor] == #char " " || text[cursor] == #char "\t") cursor += 1;
            return cursor < text.count && text[cursor] >= #char "1" && text[cursor] <= #char "9";
        }
        return false;
    } else {
        return false;
    }
}

attach_to_debugger :: () -> bool {
    // Return actual attachment state. Launching an external debugger is a separate unsupported capability.
    return is_debugger_present();
}

output :: (text: string) {
    write_string(text, true);
}

abort :: (exit_code := Exit_Code.Abort) {
    host_exit(cast(s32) exit_code);
}

get_written_minidump_filename :: () -> string {
    return written_minidump_filename;
}

set_minidump_state :: (state: Minidump_State) {
    minidump_state = state;
}

set_report_mode :: (interactive: bool) {
    signal_handler_interactive = interactive;
}

enable_signal_handler :: (interactive := false) {
    signal_handler_interactive = interactive;
    if signal_handler_enabled return;
    #if OS == .MACOS || OS == .LINUX || OS == .ANDROID {
        for number, index: watched_signals prior_handlers[index] = host_signal(number, install_handler);
        signal_handler_enabled = true;
    } else #if OS == .WINDOWS {
        prior_exception_filter = Windows.SetUnhandledExceptionFilter(handle_exception);
        signal_handler_enabled = true;
    } else {
        // No signals or exception filters to hook; the handler simply stays off.
        return;
    }
}

disable_signal_handler :: () {
    if !signal_handler_enabled return;
    #if OS == .WINDOWS {
        Windows.SetUnhandledExceptionFilter(prior_exception_filter);
    } else #if OS == .WASM {
    } else {
        for number, index: watched_signals host_signal(number, prior_handlers[index]);
    }
    signal_handler_enabled = false;
}

no_assert :: (loc: Source_Code_Location, message: string) -> bool {
    // This callback intentionally accepts the assertion failure without reporting it.
    return false;
}

print_assert :: (loc: Source_Code_Location, message: string) -> bool {
    output(loc.fully_pathed_filename);
    output(": assertion failed: ");
    output(message);
    output("\n");
    return false;
}

// Like print_assert, followed by one line per frame of the current call stack.
trace_assert :: (loc: Source_Code_Location, message: string) -> bool {
    frames := backtrace();
    print_assert(loc, message);
    for frames {
        output(it);
        output("\n");
    }
    free_backtrace(frames);
    return false;
}

break_assert :: (loc: Source_Code_Location, message: string) -> bool {
    print_assert(loc, message);
    return breakpoint();
}

#if USE_GRAPHICS {
    interactive_assert :: (loc: Source_Code_Location, message: string) -> bool {
        trace_assert(loc, message);
        return breakpoint();
    }
}

logger :: (message: string, data: *void, info: Log_Info) {
    runtime_support_default_logger(message, data, info);
}

is_valid_pointer :: (ptr: *void) -> bool {
    #if OS == .WINDOWS {
        // Ask for the page's state rather than touching it: IsBadReadPtr reads the byte and
        // catches the fault, which a debugger or crash handler sees first.
        if !ptr return false;
        info: Windows.MEMORY_BASIC_INFORMATION;
        if Windows.VirtualQuery(ptr, *info, size_of(Windows.MEMORY_BASIC_INFORMATION)) == 0 return false;
        if info.State != Windows.MEM_COMMIT || (info.Protect & Windows.PAGE_GUARD) return false;
        READABLE :: 0x02 | 0x04 | 0x08 | 0x20 | 0x40 | 0x80;
        return (info.Protect & READABLE) != 0;
    } else #if OS == .MACOS || OS == .LINUX || OS == .ANDROID {
        // The kernel reads the byte for us: writing it into a pipe fails with EFAULT, rather
        // than crashing, when the address cannot be read.
        if !ptr return false;
        ends: [2] s32;
        if host_pipe(ends.data) != 0 return false;
        defer {
            host_close(ends[0]);
            host_close(ends[1]);
        }
        return host_write(ends[1], ptr, 1) == 1;
    } else {
        // Linear memory has no unmapped holes below its size, and address 0 is not a valid object.
        return ptr != null;
    }
}

#scope_module
#import "Basic";
#import "Hash_Table";

#if OS == .WINDOWS {
    Windows :: #import "Windows";
} else #if OS != .WASM {
    POSIX :: #import "POSIX";

    siginfo_t :: POSIX.siginfo_t;
}

Signal_Handler :: #type (signal: s32) #c_call;

#if OS == .WASM {
    host_exit :: (code: s32) {
        exit(code);
    }
} else {
libc :: #system_library "c";
host_signal :: (number: s32, handler: Signal_Handler) -> Signal_Handler #foreign libc "signal";
host_exit :: (code: s32) #foreign libc "_exit";
host_backtrace :: (addresses: **void, count: s32) -> s32 #foreign libc "backtrace";
host_backtrace_symbols :: (addresses: **void, count: s32) -> **u8 #foreign libc "backtrace_symbols";
host_free :: (pointer: *void) #foreign libc "free";
host_open :: (path: *u8, flags: s32) -> s32 #foreign libc "open";
host_read :: (descriptor: s32, buffer: *void, count: u64) -> s64 #foreign libc "read";
host_close :: (descriptor: s32) -> s32 #foreign libc "close";
host_pipe :: (ends: *s32) -> s32 #foreign libc "pipe";
host_write :: (descriptor: s32, buffer: *void, count: u64) -> s64 #foreign libc "write";
}
watched_signals: [5] s32 = .[11, 4, 8, 5, ifx OS == .MACOS then 10 else 7];
prior_handlers: [5] Signal_Handler;
signal_handler_enabled := false;
signal_handler_interactive := true;
written_minidump_filename := "";
minidump_state := Minidump_State.Mini;

#if OS == .WINDOWS {
    prior_exception_filter: Windows.LPTOP_LEVEL_EXCEPTION_FILTER;

    handle_exception :: (info: *Windows.EXCEPTION_POINTERS) -> s32 #c_call {
        write_string_unsynchronized("Fatal exception 0x", true);
        code := info.ExceptionRecord.ExceptionCode;
        write_address_unsynchronized(code);
        write_string_unsynchronized("\n", true);
        addresses: [64] *void;
        count := Windows.RtlCaptureStackBackTrace(0, addresses.count, addresses.data, null);
        for index: 0..cast(s64) count - 1 {
            write_address_unsynchronized(cast(u64) addresses[index]);
            write_string_unsynchronized("\n", true);
        }
        Windows.ExitProcess(code);
        return Windows.EXCEPTION_EXECUTE_HANDLER;
    }

    // "module.exe+0x1a2b", or the bare address outside every module.
    describe_address :: (address: *void) -> string {
        module: Windows.HANDLE;
        flags :: Windows.GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | Windows.GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT;
        if !Windows.GetModuleHandleExW(flags, cast(*u16) address, *module) return sprint("0x%", formatInt(cast(u64) address, base = 16));
        wide: [260] u16;
        length := Windows.GetModuleFileNameW(module, wide.data, wide.count);
        name: String_Builder;
        start := 0;
        for index: 0..length - 1 if wide[index] == #char "\\" || wide[index] == #char "/" start = index + 1;
        // Module file names are ASCII in practice; anything else shows as '?'.
        for index: start..length - 1 append(*name, ifx wide[index] < 0x80 then cast(u8) wide[index] else #char "?");
        print_to_builder(*name, "+0x%", formatInt(cast(u64) address - cast(u64) module, base = 16));
        return builder_to_string(*name);
    }
}

#if OS != .WINDOWS && OS != .WASM {
    install_handler :: (signal: s32) #c_call {
        handle_signal(signal, null, null);
    }

    handle_signal :: (sig: s32, info: *siginfo_t, secret: *void) #c_call {
        write_string_unsynchronized("Fatal process signal\n", true);
        addresses: [64] *void;
        count := host_backtrace(addresses.data, addresses.count);
        for index: 0..count - 1 {
            write_address_unsynchronized(cast(u64) addresses[index]);
            write_string_unsynchronized("\n", true);
        }
        host_exit(128 + sig);
    }
}

write_address_unsynchronized :: (address: u64) #no_context {
    digits := "0123456789abcdef";
    bytes: [16] u8;
    position: s64 = 16;
    value := address;
    while true {
        position -= 1;
        bytes[position] = digits[value & 15];
        value >>= 4;
        if value == 0 break;
    }
    write_string_unsynchronized(string.{ 16 - position, bytes.data + position }, true);
}
