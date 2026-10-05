// Bootstrap crash handling uses compiler-generated context stack frames.
init :: () {
    #if OS == .WINDOWS {
        SetUnhandledExceptionFilter(handle_exception);
    } else {
        for signal: fatal_signals host_signal(signal, install_handler);
    }
}
#if OS == .WINDOWS {
    // An unhandled structured exception (access violation, int3...): print the return addresses
    // and exit with the exception code, as Windows itself would.
    handle_exception :: (pointers: *EXCEPTION_POINTERS) -> s32 #c_call {
        write_string_unsynchronized("fatal runtime exception 0x", true);
        code := pointers.ExceptionRecord.ExceptionCode;
        write_address_unsynchronized(code);
        write_string_unsynchronized("\n", true);
        write_frames();
        ExitProcess(code);
        return 1;
    }
} else {
    handle_signal :: (sig: s32, info: *siginfo_t, secret: *void) #c_call {
        write_string_unsynchronized("fatal runtime signal\n", true);
        write_frames();
        host_exit(128 + sig);
    }
}
write_frames :: () #no_context {
    if __runtime_support_disable_stack_trace return;
    frames: [64] *void;
    found := host_backtrace(frames.data, frames.count);
    for index: 0..found-1 {
        write_address_unsynchronized(cast(u64) frames[index]);
        write_string_unsynchronized("\n", true);
    }
}
#scope_file
werr :: inline (s: string) #no_context {
    write_string(s, to_standard_error=true);
}
werrs :: inline (s: ..string) #no_context {
    write_strings(..s, to_standard_error=true);
}
#scope_module
#if OS == .MACOS || OS == .LINUX || OS == .ANDROID {
    POSIX :: #import "POSIX";
    siginfo_t :: POSIX.siginfo_t;
    libc :: #system_library "c";
    Signal_Handler :: #type (sig: s32) #c_call;
    install_handler :: (sig: s32) #c_call {
        handle_signal(sig, null, null);
    }
    host_signal :: (signal: s32, callback: Signal_Handler) -> Signal_Handler #foreign libc "signal";
    host_exit :: (status: s32) #foreign libc "_exit";
    host_backtrace :: (frames: **void, count: s32) -> s32 #foreign libc "backtrace";
    fatal_signals: [5] s32 = .[11, 4, 8, 5, ifx OS == .MACOS then 10 else 7];
} else #if OS == .WINDOWS {
    kernel32 :: #system_library "kernel32";
    EXCEPTION_RECORD :: struct { ExceptionCode: u32; }
    EXCEPTION_POINTERS :: struct { ExceptionRecord: *EXCEPTION_RECORD; ContextRecord: *void; }
    Exception_Filter :: #type (pointers: *EXCEPTION_POINTERS) -> s32 #c_call;
    SetUnhandledExceptionFilter :: (filter: Exception_Filter) -> Exception_Filter #foreign kernel32;
    ExitProcess :: (code: u32) #foreign kernel32;
    RtlCaptureStackBackTrace :: (skip: u32, count: u32, frames: **void, hash: *u32) -> u16 #foreign kernel32;
    host_backtrace :: (frames: **void, count: s32) -> s32 #no_context {
        return RtlCaptureStackBackTrace(0, cast(u32) count, frames, null);
    }
} else {
    #assert false "Runtime crash handling requires a native host adapter for this target";
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
