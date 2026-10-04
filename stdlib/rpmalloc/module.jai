// Independent declaration normalization; see docs/stdlib/native-bindings.md.
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

rpmalloc_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    heap := allocator_data;
    if mode == .CAPS {
        if old_memory { name := cast(*string) old_memory; name.* = CAPS_VERSION_STRING; }
        return cast(*void) cast(u64) (Allocator_Caps.FREE | .CREATE_HEAP | .ACTUALLY_RESIZE |
                                      .IS_THIS_YOURS | .HINT_I_AM_A_GENERAL_HEAP_ALLOCATOR);
    }
    if mode == .STARTUP {
        if !rp_initialized {
            if rp_initialize_default() != 0 return null;
            rp_allocator_owns_initialization = true;
        }
        rp_allocator_count += 1;
        return native_heap_acquire();
    }
    if mode == .CREATE_HEAP || mode == .THREAD_START return native_heap_acquire();
    if mode == .SHUTDOWN || mode == .DESTROY_HEAP || mode == .THREAD_STOP {
        if heap {
            rp_free_all(heap);
            native_heap_release(heap);
        }
        if mode == .SHUTDOWN {
            rp_allocator_count -= 1;
            if rp_allocator_count == 0 && rp_allocator_owns_initialization rp_finalize();
        }
        return null;
    }
    if mode == .IS_THIS_YOURS return cast(*void) cast(u64) rp_owns(heap, old_memory);
    if mode == .ALLOCATE return rp_allocate(heap, requested_size, 0);
    if mode == .RESIZE return rp_reallocate(heap, old_memory, requested_size, 0, old_size, .{});
    if mode == .FREE {
        rp_free(heap, old_memory);
        return null;
    }
    Basic.assert(false, "Unknown rpmalloc allocator protocol mode");
    return null;
}

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



#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";

#scope_module
Basic :: #import "Basic";
#load "native.jai";
