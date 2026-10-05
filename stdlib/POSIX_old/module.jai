// POSIX_old: the earlier POSIX module layout, kept for programs that still import it.
#assert(OS == .LINUX || OS == .ANDROID || OS == .MACOS);
#if OS != .ANDROID {
    #load "POSIX.jai";
    #load "libc_bindings.jai";
}
#if OS == .LINUX {
    #load "bindings/linux/epoll.jai";
    #load "bindings/linux/io_uring.jai";
    #load "bindings/linux/pthread.jai";
    #load "bindings/linux/resource.jai";
} else #if OS == .ANDROID {
    GNU_ENV :: true;
    OS_Error_Code :: #type,isa s32;
    __locale_t :: struct {};
    __errno_location :: () -> *OS_Error_Code #foreign libc "__errno";
    libc :: #system_library "libc";
    #if CPU == .ARM64 {
        #load "bindings/android/arm64/base.jai";
        #load "bindings/android/arm64/pthread.jai";
    } else {
        #load "bindings/android/x64/base.jai";
        #load "bindings/android/x64/pthread.jai";
    }
} else #if OS == .MACOS {
    #load "bindings/macos/pthread.jai";
    #load "bindings/macos/resource.jai";
    #load "bindings/macos/sysctl.jai";
}

#scope_export
#load "../POSIX/errno.jai";
