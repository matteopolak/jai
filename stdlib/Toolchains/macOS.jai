// Pure target naming. SDK discovery requires an independent process provider.
#import "Basic";

get_macos_target_triple :: (cpu: CPU_Tag) -> string {
    if cpu == .ARM64 return "arm64-apple-darwin";
    return "x86_64-apple-darwin";
}

get_macos_target_triple :: (cpu: CPU_Tag, major: int, minor: int) -> string {
    version := get_darwin_version_from_macos_version(major, minor);
    return sprint("%0%", get_macos_target_triple(cpu), version);
}

// Darwin kernel majors: macOS 10.x shipped Darwin x+4 (10.13 had 17), and from macOS 11 on
// the Darwin major is the macOS major plus 9 (11 has 20). iOS N ships with Darwin N+6.
get_darwin_version_from_macos_version :: (major: int, minor: int) -> int {
    assert(major >= 10, "no Darwin version is known for macOS %.%", major, minor);
    if major > 10 return major + 9;
    return minor + 4;
}

get_darwin_version_from_ios_version :: (major: int, minor: int) -> int {
    DARWIN_AHEAD_OF_IOS :: 6;
    return major + DARWIN_AHEAD_OF_IOS;
}

// The macOS SDK to compile and generate bindings against: $MACOS_SDK_PATH, or
// what `xcrun --show-sdk-path` reports for the selected Xcode or Command Line Tools.
get_macos_sdk_path :: () -> string, bool {
    if cached_macos_sdk_path return cached_macos_sdk_path, true;

    #if OS != .WINDOWS {
        from_env := getenv("MACOS_SDK_PATH");
        if from_env && from_env[0] {
            cached_macos_sdk_path = copy_string(to_string(from_env));
            return cached_macos_sdk_path, true;
        }
    }

    result, output := run_command("xcrun", "--show-sdk-path", capture_and_return_output = true);
    path := trim(output);
    if result.exit_code != 0 || !path {
        log_error("Could not determine the macOS SDK path with xcrun (exit code %). Set MACOS_SDK_PATH.", result.exit_code);
        return "", false;
    }
    cached_macos_sdk_path = copy_string(path);
    return cached_macos_sdk_path, true;
}

#scope_file

cached_macos_sdk_path: string;

#import "Process";
#import "String";
#if OS != .WINDOWS #import "POSIX";
