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

get_darwin_version_from_macos_version :: (major: int, minor: int) -> int {
    // macOS 10.13 used Darwin 17; macOS 11 moved to Darwin 20.
    if major == 10 return minor + 4;
    assert(major > 10);
    return major + 9;
}

get_darwin_version_from_ios_version :: (major: int, minor: int) -> int {
    return major + 6;
}
