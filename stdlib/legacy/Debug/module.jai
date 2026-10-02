// Explicit original Debug API. Runtime operations call actual host APIs.
#module_parameters(USE_GRAPHICS := true);
CRASH_HANDLER_USE_SEPARATE_THREAD :: false;
Assert_Response :: enum { Ignore; Debug; Abort; }
Exit_Code :: enum s32 {
    Success :: 0;
    Failure :: 1;
    Abort :: 2;
    Assert :: 3;
    Exception :: 4;
}
Minidump_State :: enum { None; Mini; Full; }
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
}
backtrace :: (trace: []*void, skip:=0) -> int {
    return backtrace(trace, trace.count, skip + 1);
}
backtrace :: (trace: []*void, maxcount: int, skip:=0) -> int {
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
        for index: 0..available-1 trace[index] = frames[first + index];
        return available;
    } else {
        #assert false "Native stack capture is not implemented for this target";
    }
}
backtrace_symbols :: (trace: []*void, n: int) -> [] string {
    if n < 0 n = 0;
    if n > trace.count n = trace.count;
    result: [] string;
    result.count = n;
    result.data = cast(*string) alloc(n * size_of(string));
    symbols := host_backtrace_symbols(trace.data, cast(s32) n);
    if !symbols {
        free(result.data);
        return .{};
    }
    for index: 0..n-1 result[index] = copy_string(to_string(symbols[index]));
    host_free(symbols);
    return result;
}
translate_symbols :: (trace: []*void, n: int) -> [] string {
    return backtrace_symbols(trace, n);
}
backtrace :: (skip:=0) -> [] string {
    addresses: [64] *void;
    found := backtrace(addresses, addresses.count, skip + 1);
    return translate_symbols(addresses, found);
}
free_backtrace :: (trace_symbols: [] string) {
    for text: trace_symbols free(text.data);
    free(trace_symbols.data);
}

break_once :: inline (loc := #caller_location) -> bool {
    value, exists := table_find(*ignored_asserts, loc);
    if exists return false;
    if breakpoint() {
        table_add(*ignored_asserts, loc, true);
        return true;
    }
    return false;
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
        text := string.{count, bytes.data};
        label := "TracerPid:";
        for start: 0..text.count-label.count {
            matching := true;
            for byte, index: label if text[start + index] != byte matching = false;
            if !matching continue;
            cursor := start + label.count;
            while cursor < text.count && (text[cursor] == #char " " || text[cursor] == #char "\t") cursor += 1;
            return cursor < text.count && text[cursor] >= #char "1" && text[cursor] <= #char "9";
        }
        return false;
    } else {
        #assert false "Debugger detection requires a host adapter";
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
enable_signal_handler :: (interactive:=false) {
    signal_handler_interactive = interactive;
    if signal_handler_enabled return;
    #if OS == .MACOS || OS == .LINUX || OS == .ANDROID {
        for number, index: watched_signals prior_handlers[index] = host_signal(number, install_handler);
        signal_handler_enabled = true;
    } else {
        #assert false "Crash signal installation requires a host adapter";
    }
}
disable_signal_handler :: () {
    if !signal_handler_enabled return;
    for number, index: watched_signals host_signal(number, prior_handlers[index]);
    signal_handler_enabled = false;
}
no_assert :: (loc: Source_Code_Location, message: string) {
    // This callback intentionally accepts the assertion failure without reporting it.
    return;
}
print_assert :: (loc: Source_Code_Location, message: string) {
    output(loc.fully_pathed_filename);
    output(": assertion failed: ");
    output(message);
    output("\n");
}
trace_assert :: (loc: Source_Code_Location, message: string) {
    print_assert(loc, message);
    trace := backtrace();
    defer free_backtrace(trace);
    for text: trace { output(text); output("\n"); }
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
        return ptr && Windows.IsBadReadPtr(ptr, 1) == 0;
    } else {
        #assert false "Pointer mapping validation requires a host memory-map adapter";
    }
}

#scope_module
#import "Basic";
#import "Hash_Table";
#if OS == .WINDOWS {
    Windows :: #import "Windows";
} else {
    POSIX :: #import "POSIX";
    siginfo_t :: POSIX.siginfo_t;
}
Signal_Handler :: #type (signal: s32) #c_call;
libc :: #system_library "c";
host_signal :: (number: s32, handler: Signal_Handler) -> Signal_Handler #foreign libc "signal";
host_exit :: (code: s32) #foreign libc "_exit";
host_backtrace :: (addresses: **void, count: s32) -> s32 #foreign libc "backtrace";
host_backtrace_symbols :: (addresses: **void, count: s32) -> **u8 #foreign libc "backtrace_symbols";
host_free :: (pointer: *void) #foreign libc "free";
host_open :: (path: *u8, flags: s32) -> s32 #foreign libc "open";
host_read :: (descriptor: s32, buffer: *void, count: u64) -> s64 #foreign libc "read";
host_close :: (descriptor: s32) -> s32 #foreign libc "close";
watched_signals: [5] s32 = .[11, 4, 8, 5, ifx OS == .MACOS then 10 else 7];
prior_handlers: [5] Signal_Handler;
signal_handler_enabled := false;
signal_handler_interactive := true;
written_minidump_filename := "";
minidump_state := Minidump_State.Mini;

install_handler :: (signal: s32) #c_call {
    handle_signal(signal, null, null);
}
handle_signal :: (sig: s32, info: *siginfo_t, secret: *void) #c_call {
    write_string_unsynchronized("Fatal process signal\n", true);
    addresses: [64] *void;
    count := host_backtrace(addresses.data, addresses.count);
    for index: 0..count-1 {
        write_address_unsynchronized(cast(u64) addresses[index]);
        write_string_unsynchronized("\n", true);
    }
    host_exit(128 + sig);
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
    write_string_unsynchronized(string.{16 - position, bytes.data + position}, true);
}
