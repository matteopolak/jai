#if ENABLE_THREAD_CACHE {
    SPAN_LARGE_CACHE_COUNT :: LARGE_CLASS_COUNT - 1;
}
// Independent declaration normalization; see docs/stdlib/native-bindings.md.
SMALL_GRANULARITY :: 16;

SMALL_GRANULARITY_SHIFT :: 4;

SMALL_CLASS_COUNT :: 65;

SMALL_SIZE_LIMIT :: SMALL_GRANULARITY * (SMALL_CLASS_COUNT - 1);

MEDIUM_GRANULARITY :: 512;

MEDIUM_GRANULARITY_SHIFT :: 9;

MEDIUM_CLASS_COUNT :: 61;

SIZE_CLASS_COUNT :: SMALL_CLASS_COUNT + MEDIUM_CLASS_COUNT;

LARGE_CLASS_COUNT :: 63;

MEDIUM_SIZE_LIMIT :: SMALL_SIZE_LIMIT + (MEDIUM_GRANULARITY * MEDIUM_CLASS_COUNT);

SPAN_HEADER_SIZE :: 128;

MAX_THREAD_SPAN_CACHE :: 400;

THREAD_SPAN_CACHE_TRANSFER :: 64;

MAX_THREAD_SPAN_LARGE_CACHE :: 100;

THREAD_SPAN_LARGE_CACHE_TRANSFER :: 6;

INVALID_POINTER :: cast(*void) -1;

SIZE_CLASS_LARGE :: SIZE_CLASS_COUNT;

SIZE_CLASS_HUGE :: cast,no_check(u32) -1;

memory_default_span_size :: 64 * 1024;

memory_default_span_size_shift :: 16;

memory_default_span_mask: u64 : ~cast(u64) (memory_default_span_size - 1);

Span :: struct {
    free_list: *void;
    block_count: u32;
    size_class: u32;
    free_list_limit: u32;
    used_count: u32;
    free_list_deferred: *void;
    list_size: u32;
    block_size: u32;

    flags: enum_flags u32 {
        MASTER :: 1;
        SUBSPAN :: 2;
        ALIGNED_BLOCKS :: 4;
        UNMAPPED_MASTER :: 8;
    };

    span_count: u32;
    total_spans: u32;
    offset_from_master: u32;
    remaining_spans: s32;
    align_offset: u32;
    heap: *Heap;
    next: *Span;
    prev: *Span;
}

Heap :: struct {
    owner_thread: u64;
    size_class: [SIZE_CLASS_COUNT] Heap_Size_Class;

    #if ENABLE_THREAD_CACHE {
        span_cache: Span_Cache;
    }

    span_free_deferred: *void;
    full_span_count: s64;
    span_reserve: *Span;
    span_reserve_master: *Span;
    spans_reserved: u32;
    child_count: s32;
    next_heap: *Heap;
    next_orphan: *Heap;
    id: s32;
    finalize: s32;
    master_heap: *Heap;

    #if ENABLE_THREAD_CACHE {

        span_large_cache: [SPAN_LARGE_CACHE_COUNT] Span_Large_Cache;
    }

    full_span: [SIZE_CLASS_COUNT] *Span;
    large_huge_span: *Span;

    #if ENABLE_ADAPTIVE_THREAD_CACHE || ENABLE_STATISTICS {
        span_use: [LARGE_CLASS_COUNT] Span_Use;
    }

    #if ENABLE_STATISTICS {
        size_class_use: [SIZE_CLASS_COUNT + 1] Size_Class_Use;
        thread_to_global: s64;
        global_to_thread: s64;
    }
}

Span_Cache :: struct {
    count: s64;
    span: [MAX_THREAD_SPAN_CACHE] *Span;
}

Span_Large_Cache :: struct {
    count: s64;
    span: [MAX_THREAD_SPAN_LARGE_CACHE] *Span;
}

Heap_Size_Class :: struct {
    free_list: *void;

    partial_span: *Span;

    cache: *Span;
}

Size_Class :: struct {
    block_size: u32;
    block_count: u16;
    class_idx: u16;
}

Global_Cache :: struct {
    lock: s32;
    count: u32;

    #if ENABLE_STATISTICS {
        insert_count: s64;
        extract_count: s64;
    }

    span: [GLOBAL_CACHE_MULTIPLIER * MAX_THREAD_SPAN_CACHE] *Span;

    overflow: *Span;
}

#if ENABLE_ADAPTIVE_THREAD_CACHE || ENABLE_STATISTICS {
    Span_Use :: struct {
        current: s32;
        high: s32;
        #if ENABLE_STATISTICS {
            spans_deferred: s32;
            spans_to_global: s32;
            spans_from_global: s32;
            spans_to_cache: s32;
            spans_from_cache: s32;
            spans_to_reserved: s32;
            spans_from_reserved: s32;
            spans_map_calls: s32;
        }
    }
}
#if ENABLE_STATISTICS {
    Size_Class_Use :: struct {
        alloc_current: s32;
        alloc_peak: s32;
        alloc_total: s32;
        free_total: s32;
        spans_current: s32;
        spans_peak: s32;
        spans_to_cache: s32;
        spans_from_cache: s32;
        spans_from_reserved: s32;
        spans_map_calls: s32;
        unused: s32;
    }
}

Realloc_Flags :: enum_flags u32 {

    NO_PRESERVE :: 1;

    GROW_OR_FAIL :: 2;
}

initialize :: () -> s32 {
    return rp_initialize_default();
}

finalize :: () {
    rp_finalize();
}

initialize_config :: (config: *rpmalloc_config_t) -> s32 {
    return rp_initialize_config(config);
}

is_initialized :: () -> bool {
    return rp_initialized;
}

thread_initialize :: () {
    native_thread_initialize();
}

thread_finalize :: (release_caches: bool) {
    native_thread_finalize(cast(s32) release_caches);
}

is_thread_initialized :: () -> bool {
    return native_thread_is_initialized() != 0;
}

set_main_thread :: () {
    rp_set_main_thread();
}

config :: () -> *rpmalloc_config_t {
    return rp_get_config();
}

rpmalloc :: (size: s64) -> *void {
    return rp_allocate(null, size, 0);
}

rpfree :: (ptr: *void) {
    rp_free(null, ptr);
}

rprealloc :: (ptr: *void, size: s64) -> *void {
    return rp_reallocate(null, ptr, size, 0, 0, .{});
}

rpaligned_realloc :: (ptr: *void, alignment: s64, size: s64, oldsize: s64, flags: Realloc_Flags) -> *void {
    return rp_reallocate(null, ptr, size, alignment, oldsize, flags);
}

rpaligned_alloc :: (alignment: s64, size: s64) -> *void {
    return rp_allocate(null, size, alignment);
}

usable_size :: (ptr: *void) -> s64 {
    return cast(s64) native_usable_size(ptr);
}

thread_statistics :: (stats: *rpmalloc_thread_statistics_t) {
    native_thread_statistics(stats);
}

global_statistics :: (stats: *rpmalloc_global_statistics_t) {
    native_global_statistics(stats);
}

#if ENABLE_STATISTICS {
    dump_statistics :: (builder: *$T) {
        stats: rpmalloc_global_statistics_t;
        per_thread: rpmalloc_thread_statistics_t;
        native_global_statistics(*stats);
        native_thread_statistics(*per_thread);
        Basic.print_to_builder(builder, "rpmalloc: mapped=% peak=% cached=% huge=% huge_peak=% mapped_total=% unmapped_total=%\n",
                                stats.mapped, stats.mapped_peak, stats.cached, stats.huge_alloc,
                                stats.huge_alloc_peak, stats.mapped_total, stats.unmapped_total);
        Basic.print_to_builder(builder, "thread: sizecache=% spancache=% to_global=% from_global=%\n",
                                per_thread.sizecache, per_thread.spancache,
                                per_thread.thread_to_global, per_thread.global_to_thread);
        for span_index: 0..63 {
            entry := per_thread.span_use[span_index];
            if entry.current != 0 || entry.peak != 0
                Basic.print_to_builder(builder, "span %: current=% peak=% mapped=%\n", span_index, entry.current, entry.peak, entry.map_calls);
        }
        for size_index: 0..127 {
            entry := per_thread.size_use[size_index];
            if entry.alloc_total != 0
                Basic.print_to_builder(builder, "size class %: current=% peak=% allocs=% frees=%\n",
                                        size_index, entry.alloc_current, entry.alloc_peak, entry.alloc_total, entry.free_total);
        }
    }
} else {
    dump_statistics :: (builder: *void) {
        #assert !ENABLE_STATISTICS "Statistics output is intentionally disabled in this build profile.";
    }
}

heap_acquire :: () -> *Heap {
    return cast(*Heap) native_heap_acquire();
}

heap_release :: (heap: *Heap) {
    native_heap_release(heap);
}

heap_is_this_yours :: (heap: *Heap, memory: *void) -> bool {
    return rp_owns(heap, memory);
}

is_in_span :: (memory: *void, span: *Span) -> bool {
    if !span || !memory return false;
    first := cast(u64) span;
    address := cast(u64) memory;
    span_bytes := cast(u64) span.span_count * native_config().span_size;
    return address >= first && address - first < span_bytes;
}

heap_alloc :: (heap: *Heap, size: s64) -> *void {
    return rp_allocate(heap, size, 0);
}

heap_aligned_alloc :: (heap: *Heap, alignment: s64, size: s64) -> *void {
    return rp_allocate(heap, size, alignment);
}

heap_realloc :: (heap: *Heap, ptr: *void, size: s64, flags: Realloc_Flags) -> *void {
    return rp_reallocate(heap, ptr, size, 0, 0, flags);
}

heap_aligned_realloc :: (heap: *Heap, ptr: *void, alignment: s64, size: s64, flags: Realloc_Flags) -> *void {
    return rp_reallocate(heap, ptr, size, alignment, 0, flags);
}

heap_free :: (heap: *Heap, ptr: *void) {
    rp_free(heap, ptr);
}

heap_free_all :: (heap: *Heap) {
    rp_free_all(heap);
}

heap_thread_set_current :: (heap: *Heap) {
    native_heap_thread_set_current(heap);
}

errno: enum s32 {
    SUCCESS :: 0;
    ENOMEM :: 12;
    EINVAL :: 22;
};

rpmalloc_global_statistics_t :: struct {
    mapped: s64;
    mapped_peak: s64;
    cached: s64;
    huge_alloc: s64;
    huge_alloc_peak: s64;
    mapped_total: s64;
    unmapped_total: s64;
}

rpmalloc_thread_statistics_t :: struct {
    sizecache: s64;
    spancache: s64;
    thread_to_global: s64;
    global_to_thread: s64;

    span_use: [64] struct {
        current: s64;
        peak: s64;
        to_global: s64;
        from_global: s64;
        to_cache: s64;
        from_cache: s64;
        to_reserved: s64;
        from_reserved: s64;
        map_calls: s64;
    };

    size_use: [128] struct {
        alloc_current: s64;
        alloc_peak: s64;
        alloc_total: s64;
        free_total: s64;
        spans_to_cache: s64;
        spans_from_cache: s64;
        spans_from_reserved: s64;
        map_calls: s64;
    };
}

rpmalloc_config_t :: struct {

    memory_map: #type (size: s64, offset: *s64) -> *void;

    memory_unmap: #type (address: *void, size: s64, offset: s64, release: s64) -> ();

    error_callback: #type (message: string, location: Source_Code_Location) -> ();

    map_fail_callback: #type (size: s64) -> s32;

    page_size: s64;

    span_size: s64;

    span_map_count: s64;

    enable_huge_pages: bool;

    page_name: string;
    huge_page_name: string;
}
