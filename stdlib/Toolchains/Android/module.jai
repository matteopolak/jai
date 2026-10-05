// Android NDK discovery for metaprograms: target triples and the NDK's
// toolchain and sysroot paths. Build and bindings-generator scripts import it
// to target Android; nothing here runs unless they ask for Android.
#module_parameters () (SDK_LEVEL := 34, ENABLE_ARM_LSE := true);

ANDROID_SDK_LEVEL :: SDK_LEVEL;

NDK_Paths :: struct {
    root:      string;   // $NDK_HOME
    toolchain: string;   // <root>/toolchains/llvm/prebuilt/<host>
    sysroot:   string;   // <toolchain>/sysroot
}

// "aarch64-linux-android" and "aarch64-linux-android34" (the SDK level appended).
get_android_target_triple :: (cpu: CPU_Tag) -> triple: string, triple_with_sdk: string {
    triple: string;
    if cpu == .ARM64      triple = "aarch64-linux-android";
    else if cpu == .X64   triple = "x86_64-linux-android";
    else assert(false, "Android supports only x64 and arm64, not %", cpu);
    return triple, tprint("%0%", triple, SDK_LEVEL);
}

// The NDK named by NDK_HOME (or ANDROID_NDK_HOME).
get_ndk_paths :: () -> NDK_Paths {
    root := environment_variable("NDK_HOME");
    if !root root = environment_variable("ANDROID_NDK_HOME");
    assert(root.count > 0, "Point NDK_HOME or ANDROID_NDK_HOME at an Android NDK");

    // The NDK ships x86_64 host binaries for every desktop OS (Apple silicon runs them translated).
    #if OS == .WINDOWS      HOST :: "windows-x86_64";
    else #if OS == .MACOS   HOST :: "darwin-x86_64";
    else                    HOST :: "linux-x86_64";

    paths: NDK_Paths;
    paths.root = root;
    paths.toolchain = tprint("%/toolchains/llvm/prebuilt/%", root, HOST);
    assert(file_exists(paths.toolchain), "No NDK toolchain at '%'", paths.toolchain);
    paths.sysroot = tprint("%/sysroot", paths.toolchain);
    return paths;
}

// The NDK's C headers: the shared include directory and the target-specific one.
get_ndk_libc_paths :: (cpu: CPU_Tag) -> libc_path: string, libc_platform_path: string {
    triple := get_android_target_triple(cpu);
    include := tprint("%/usr/include", get_ndk_paths().sysroot);
    return include, tprint("%/%", include, triple);
}

#scope_module

#import "Basic";
#import "File";
#import "String";

environment_variable :: (name: string) -> string {
    #if OS == .WINDOWS {
        value := getenv(temp_c_string(name));
    } else {
        value := POSIX.getenv(temp_c_string(name));
    }
    if !value return "";
    return copy_string(to_string(value));
}

#if OS == .WINDOWS {
    #import "Windows";
} else {
    POSIX :: #import "POSIX";
}
