// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
#module_parameters (
    HEAP_ARRAY_SIZE         := 47,
    DEFAULT_SPAN_MAP_COUNT  := 64,
    GLOBAL_CACHE_MULTIPLIER := 8,

    ENABLE_THREAD_CACHE := true,
    ENABLE_GLOBAL_CACHE := true,

    ENABLE_STATISTICS    := true,
    ENABLE_ASSERTS       := true,
    ENABLE_VALIDATE_ARGS := true,

    LINUX_FREE_ADVICE : enum { DONTNEED; FREE; } = .DONTNEED,

    CONFIGURABLE                 := false,

    ENABLE_ADAPTIVE_THREAD_CACHE := false,
    LINUX_HUGE_PAGES             := false,

    USE_RAW                      := false,

    DISABLE_UNMAP                := false,
    ENABLE_UNLIMITED_CACHE       := false
)();

rpmalloc_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_module_rpmalloc_allocator_proc_1";

#scope_module

CAPS_VERSION_STRING :: "rpmalloc 1.4.4";

#if !USE_RAW
    #load "rpmalloc.jai";
else
    #load "rpmalloc.raw.jai";

#if USE_RAW && ENABLE_ASSERTS
    || OS == .LINUX && LINUX_HUGE_PAGES {
    basic :: #import "Basic";
}

#if OS == .LINUX && LINUX_HUGE_PAGES {
    File :: #import "File";
}

#scope_file
codec_adapter :: #system_library "jai_rpmalloc_adapter";

#if USE_RAW {
    #assert false "Raw rpmalloc adapter profile has an unresolved FIRST_CLASS_HEAPS contract.";
}

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
