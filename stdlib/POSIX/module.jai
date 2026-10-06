// POSIX: libc declarations shared by the Unix targets, plus per-platform bindings below.
// Layouts and constants that depend on the CPU branch on every supported CPU and stop the build
// on any other (tests/abi/manifest.txt checks them against each host's headers). The browser
// target (OS == .WASM) uses the Linux x86-64 layouts; the interpreter's sandbox host implements
// the libc subset in crates/jaic/src/interp/sandbox.rs.
#assert(OS == .LINUX || OS == .ANDROID || OS == .MACOS || OS == .WASM);
OS_Error_Code :: #type,isa s32;
size_t :: u64;
ssize_t :: s64;
off_t :: s64;
#if OS == .LINUX || OS == .WASM {
    #load "bindings/linux/base.jai";
    #load "bindings/linux/stdio.jai";
    #load "bindings/linux/stdlib.jai";
    #load "bindings/linux/syscall.jai";
    #load "bindings/linux/pthread.jai";
    #load "bindings/linux/resource.jai";
}
else #if OS == .MACOS {
    SYSCALL_MACH_BASE :: 0x1000000;
    SYSCALL_UNIX_BASE :: 0x2000000;
    #if CPU == .ARM64 {
        #load "bindings/macos/arm64/base.jai";
        #load "bindings/macos/arm64/stdio.jai";
        #load "bindings/macos/arm64/stdlib.jai";
        #load "bindings/macos/arm64/syscall.jai";
        #load "bindings/macos/arm64/pthread.jai";
        #load "bindings/macos/arm64/resource.jai";
        #load "bindings/macos/arm64/sysctl.jai";
    } else #if CPU == .X64 {
        #load "bindings/macos/x64/base.jai";
        #load "bindings/macos/x64/stdio.jai";
        #load "bindings/macos/x64/stdlib.jai";
        #load "bindings/macos/x64/syscall.jai";
        #load "bindings/macos/x64/pthread.jai";
        #load "bindings/macos/x64/resource.jai";
        #load "bindings/macos/x64/sysctl.jai";
    } else {
        #assert false "POSIX: no macOS bindings for this CPU";
    }
}
else #if OS == .ANDROID {
    #if CPU == .ARM64 {
        #load "bindings/android/arm64/base.jai";
        #load "bindings/android/arm64/stdio.jai";
        #load "bindings/android/arm64/stdlib.jai";
        #load "bindings/android/arm64/syscall.jai";
        #load "bindings/android/arm64/pthread.jai";
        #load "bindings/android/arm64/resource.jai";
    } else #if CPU == .X64 {
        #load "bindings/android/x64/base.jai";
        #load "bindings/android/x64/stdio.jai";
        #load "bindings/android/x64/stdlib.jai";
        #load "bindings/android/x64/syscall.jai";
        #load "bindings/android/x64/pthread.jai";
        #load "bindings/android/x64/resource.jai";
    } else {
        #assert false "POSIX: no Android bindings for this CPU";
    }
}
#if OS == .LINUX || OS == .ANDROID || OS == .WASM {
    #scope_file
    __WCOREFLAG :: 0x80;
    __W_CONTINUED :: 0xffff;
    #scope_export
} else #if OS == .MACOS {
    #scope_file
    #scope_export
}
strsignal :: (sig: s32) -> *u8 #foreign libc;
#scope_file
libc :: #system_library "libc";

#scope_export
#load "errno.jai";

#scope_export
#load "file-mode-wait.jai";
