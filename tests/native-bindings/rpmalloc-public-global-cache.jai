// Reviewed rpmalloc.md ENABLE_GLOBAL_CACHE option, allocator protocol and
// ownership lifetimes. Independent official C cache probes run separately.
#import "Basic";
Default :: #import "rpmalloc";
CachedOff :: #import "rpmalloc"(ENABLE_GLOBAL_CACHE = false);
CachedOffSmall :: #import "rpmalloc"(ENABLE_GLOBAL_CACHE = false, ENABLE_STATISTICS = false);
RawOff :: #import "rpmalloc"(USE_RAW = true, ENABLE_GLOBAL_CACHE = false);
RawOffSmall :: #import "rpmalloc"(USE_RAW = true, ENABLE_GLOBAL_CACHE = false, ENABLE_STATISTICS = false);

#add_context cache_callback_marker: s64;
denied: s64;

deny_map :: (size: s64, offset: *s64) -> *void {
    assert(context.cache_callback_marker == 93);
    assert(size > 0 && offset != null);
    denied += 1;
    return null;
}

deny_unmap :: (address: *void, size: s64, offset: s64, release: s64) {
    assert(false, "a failed mapping must not be unmapped");
}

exercise :: (proc: Allocator_Proc) {
    assert(proc(.STARTUP, 0, 0, null, null) == null);
    heap := proc(.CREATE_HEAP, 0, 0, null, null);

    assert(heap != null);
    slots: [256] *void;
    // Overflow each native cache batch rather than relying on small frees.
    for *slots {
        it.* = proc(.ALLOCATE, 131072, 0, null, heap);
        assert(it.* != null);
        (cast(*u8) it.*)[0] = 39;
        assert(cast(u64) proc(.IS_THIS_YOURS, 0, 0, it.*, heap) == 1);
    }

    for slots {
        assert((cast(*u8) it)[0] == 39);
        assert(proc(.FREE, 0, 0, it, heap) == null);
    }

    assert(proc(.DESTROY_HEAP, 0, 0, null, heap) == null);
    assert(proc(.THREAD_STOP, 0, 0, null, null) == null);
    assert(proc(.THREAD_START, 0, 0, null, null) == null);
    memory := proc(.ALLOCATE, 71, 0, null, null);

    assert(memory != null);
    (cast(*u8) memory)[0] = 81;
    replacement := proc(.RESIZE, 8192, 0, memory, null);

    assert(replacement != null && (cast(*u8) replacement)[0] == 81);
    assert(proc(.FREE, 0, 0, replacement, null) == null);
}

main :: () {
    assert(Default.initialize() == 0);
    memory := Default.rpmalloc(64);

    assert(memory != null);
    (cast(*u8) memory)[0] = 91;
    context.cache_callback_marker = 93;
    config: CachedOff.rpmalloc_config_t;
    config.memory_map = deny_map;
    config.memory_unmap = deny_unmap;
    assert(CachedOff.initialize_config(*config) != 0);
    assert(denied > 0 && !CachedOff.is_initialized());
    assert(Default.is_initialized() && (cast(*u8) memory)[0] == 91);
    exercise(CachedOff.rpmalloc_allocator_proc);
    exercise(CachedOffSmall.rpmalloc_allocator_proc);
    exercise(RawOff.rpmalloc_allocator_proc);
    exercise(RawOffSmall.rpmalloc_allocator_proc);

    guarded: struct {
        before: u64 = 0x123;
        stats: CachedOff.rpmalloc_global_statistics_t;
        after: u64 = 0x456;
    };

    CachedOff.global_statistics(*guarded.stats);
    assert(guarded.before == 0x123 && guarded.after == 0x456);
    assert(guarded.stats.cached == 0);
    assert(guarded.stats.mapped > 0);
    CachedOff.finalize();
    CachedOffSmall.finalize();
    RawOff.finalize();
    RawOffSmall.finalize();
    assert(Default.is_initialized() && (cast(*u8) memory)[0] == 91);
    Default.rpfree(memory);
    Default.finalize();
}
