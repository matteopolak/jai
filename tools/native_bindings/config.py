"""Native library spelling and private dependency scope for public facades.

These are packaging choices. Public ABI declarations come from the specs.
"""
IMPORTS = {
    'd3d11': ['Windows', 'dxgi'], 'd3d12': ['Windows', 'dxgi', 'd3d11'],
    'd3d_compiler': ['Windows', 'd3d11'], 'dxc_compiler': ['Windows', 'd3d12'],
    'dxgi': ['Windows'], 'Linux': ['POSIX'], 'Metal': ['Objective_C', 'macOS'],
    'Objective_C': [], 'macOS': ['POSIX'], 'nvidia_aftermath': ['Windows', 'd3d12'],
    'nvtt': ['Windows'], 'X11': ['POSIX'], 'Android': ['POSIX'],
    'Android/AAudio': [], 'Android/EGL': ['Android'],
    'Vulkan': [],
}
LIBRARIES = {
    'xxh_vendor': 'xxhash070', 'lib_stb_vorbis': 'stb_vorbis',
    'liblz4': 'lz4', 'meshopt_lib': 'meshoptimizer', 'libcurl': 'curl',
    'libfreetype': 'freetype', 'freetype': 'freetype', 'libvulkan': 'vulkan',
    'libnvtt': 'nvtt', 'libSystem': 'System', 'libobjc': 'objc',
    'libc': 'c', 'libm': 'm', 'libdl': 'dl', 'libpthread': 'pthread',
    'liblog': 'log', 'libandroid': 'android', 'libaaudio': 'aaudio',
    'libEGL': 'EGL', 'libmediandk': 'mediandk', 'libcamera2ndk': 'camera2ndk',
}
PARAMETERS = {
    'd3d11': '#module_parameters(INCLUDE_DEBUG_BINDINGS := false)();',
    'd3d12': '#module_parameters(INCLUDE_DEBUG_BINDINGS := false)();',
    'dxc_compiler': '#module_parameters(NINTENDO_SUPPORT := false)();',
    'GL': '#module_parameters(DUMP_GL_ERRORS := false, ENABLE_ALL_EXTENSIONS := false, DEFAULT_MSAA: s32 = 4)();',
    'telemetry3': '#module_parameters(ENABLED := false)();',
}
PRIVATE = {
    'meshoptimizer': '#if OS != .WINDOWS { #library,system,link_always "c++"; }',
    'xxHash': '''binding_XXH_versionNumber :: () -> u32 #foreign xxh_vendor "XXH_versionNumber";
binding_XXH32 :: (input: *void, len: u64, seed: u32) -> u32 #foreign xxh_vendor "XXH32";
binding_XXH64 :: (input: *void, len: u64, seed: u64) -> u64 #foreign xxh_vendor "XXH64";
binding_XXH32_reset :: (state: *XXH32_state_t, seed: u32) -> s32 #foreign xxh_vendor "XXH32_reset";
binding_XXH64_reset :: (state: *XXH64_state_t, seed: u64) -> s32 #foreign xxh_vendor "XXH64_reset";
binding_XXH32_update :: (state: *XXH32_state_t, input: *void, len: u64) -> s32 #foreign xxh_vendor "XXH32_update";
binding_XXH64_update :: (state: *XXH64_state_t, input: *void, len: u64) -> s32 #foreign xxh_vendor "XXH64_update";
binding_XXH32_digest :: (state: *XXH32_state_t) -> u32 #foreign xxh_vendor "XXH32_digest";
binding_XXH64_digest :: (state: *XXH64_state_t) -> u64 #foreign xxh_vendor "XXH64_digest";
binding_abort :: () #foreign libc "abort";''',
    'stb_image': 'FILE :: struct {};',
    'stb_vorbis': 'FILE :: struct {};',
    'Curl': 'FILE :: struct {};\ntime_t :: s64;\nNative :: #import "internal/bindings/native";',
    'dxc_compiler': 'IMalloc :: struct {};\nIStream :: struct {};\nBSTR :: *u16;',
    'freetype': 'ptrdiff_t :: s64;',
    'Objective_C': 'ptrdiff_t :: s64;',
    'POSIX': '''U128 :: [2]u64;
#if OS == .MACOS || OS == .IOS {
    binding_errno_address :: () -> *s32 #foreign libc "__error";
} else #if OS == .ANDROID {
    binding_errno_address :: () -> *s32 #foreign libc "__errno";
} else {
    binding_errno_address :: () -> *s32 #foreign libc "__errno_location";
}''',
}
TARGETS = {
    'Windows': 'OS == .WINDOWS', 'd3d11': 'OS == .WINDOWS',
    'd3d12': 'OS == .WINDOWS', 'd3d_compiler': 'OS == .WINDOWS',
    'dxc_compiler': 'OS == .WINDOWS', 'dxgi': 'OS == .WINDOWS',
    'Linux': 'OS == .LINUX', 'X11': 'OS == .LINUX',
    'POSIX': 'OS == .LINUX || OS == .MACOS || OS == .ANDROID || OS == .IOS',
    'Vulkan': 'OS == .WINDOWS || OS == .LINUX',
    'macOS': 'OS == .MACOS', 'Metal': 'OS == .MACOS',
    'Objective_C': 'OS == .MACOS || OS == .IOS',
    'Android': 'OS == .ANDROID', 'Android/AAudio': 'OS == .ANDROID',
    'Android/EGL': 'OS == .ANDROID', 'nvidia_aftermath': 'OS == .WINDOWS',
}
