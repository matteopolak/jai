size_t :: u64;
FIRST_CLASS_HEAPS :: true;
_int :: s32;
char :: u8;
ptrdiff_t :: s64;
uintptr_t :: u64;
uint16_t :: u16;
int32_t :: s32;
int64_t :: s64;
uint32_t :: u32;
atomic32_t :: s32;
atomic64_t :: s64;
atomicptr_t :: *void;
#if OS == .WINDOWS {
    PLATFORM_WINDOWS :: true;
} else {
    PLATFORM_WINDOWS :: false;
}
#if ENABLE_ADAPTIVE_THREAD_CACHE || ENABLE_STATISTICS {
    span_use_t :: struct {

        current: atomic32_t;

        high: atomic32_t;
        #if ENABLE_STATISTICS {

            spans_deferred: atomic32_t;

            spans_to_global: atomic32_t;

            spans_from_global: atomic32_t;

            spans_to_cache: atomic32_t;

            spans_from_cache: atomic32_t;

            spans_to_reserved: atomic32_t;

            spans_from_reserved: atomic32_t;

            spans_map_calls: atomic32_t;
        }
    }
}
#if ENABLE_STATISTICS {
    size_class_use_t :: struct {

        alloc_current: atomic32_t;

        alloc_peak: int32_t;

        alloc_total: atomic32_t;

        free_total: atomic32_t;

        spans_current: atomic32_t;

        spans_peak: int32_t;

        spans_to_cache: atomic32_t;

        spans_from_cache: atomic32_t;

        spans_from_reserved: atomic32_t;

        spans_map_calls: atomic32_t;
        unused: int32_t;
    }
}
// Independent declaration normalization; see docs/stdlib/native-bindings.md.
RPMALLOC_FIRST_CLASS_HEAPS :: FIRST_CLASS_HEAPS;

WIN32_LEAN_AND_MEAN :: PLATFORM_WINDOWS;

MAP_UNINITIALIZED :: 0;

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

THREAD_SPAN_CACHE_TRANSFER: u64 : 64;

MAX_THREAD_SPAN_LARGE_CACHE :: 100;

THREAD_SPAN_LARGE_CACHE_TRANSFER :: 6;

INVALID_POINTER: *void : cast(*void) cast,no_check(uintptr_t) -1;

SIZE_CLASS_LARGE :: SIZE_CLASS_COUNT;

SIZE_CLASS_HUGE :: cast,no_check(uint32_t) -1;

SPAN_FLAG_MASTER: u32 : 1;

SPAN_FLAG_SUBSPAN: u32 : 2;

SPAN_FLAG_ALIGNED_BLOCKS: u32 : 4;

SPAN_FLAG_UNMAPPED_MASTER: u32 : 8;

BUILD_DYNAMIC_LINK :: true;

MAP_FAILED: *void : cast(*void) -1;

span_t :: struct {

    free_list: *void;

    block_count: u32;

    size_class: u32;

    free_list_limit: u32;

    used_count: u32;

    free_list_deferred: atomicptr_t;

    list_size: u32;

    block_size: u32;

    flags: u32;

    span_count: u32;

    total_spans: u32;

    offset_from_master: u32;

    remaining_spans: atomic32_t;

    align_offset: u32;

    heap: *heap_t;

    next: *span_t;

    prev: *span_t;
}

span_cache_t :: struct {
    count: size_t;
    span: [MAX_THREAD_SPAN_CACHE] *span_t;
}

span_large_cache_t :: struct {
    count: size_t;
    span: [MAX_THREAD_SPAN_LARGE_CACHE] *span_t;
}

heap_size_class_t :: struct {

    free_list: *void;

    partial_span: *span_t;

    cache: *span_t;
}

heap_t :: struct {

    owner_thread: u64;

    size_class: [SIZE_CLASS_COUNT] heap_size_class_t;
    #if ENABLE_THREAD_CACHE {

        span_cache: span_cache_t;
    }

    span_free_deferred: atomicptr_t;

    full_span_count: size_t;

    span_reserve: *span_t;

    span_reserve_master: *span_t;

    spans_reserved: u32;

    child_count: atomic32_t;

    next_heap: *heap_t;

    next_orphan: *heap_t;

    id: int32_t;

    finalize: _int;

    master_heap: *heap_t;
    #if ENABLE_THREAD_CACHE {

        span_large_cache: [LARGE_CLASS_COUNT - 1] span_large_cache_t;
    }
    #if RPMALLOC_FIRST_CLASS_HEAPS {

        full_span: [SIZE_CLASS_COUNT] *span_t;

        large_huge_span: *span_t;
    }
    #if ENABLE_ADAPTIVE_THREAD_CACHE || ENABLE_STATISTICS {

        span_use: [LARGE_CLASS_COUNT] span_use_t;
    }
    #if ENABLE_STATISTICS {

        size_class_use: [SIZE_CLASS_COUNT + 1] size_class_use_t;

        thread_to_global: atomic64_t;

        global_to_thread: atomic64_t;
    }
}

size_class_t :: struct {

    block_size: u32;

    block_count: uint16_t;

    class_idx: uint16_t;
}

global_cache_t :: struct {

    lock: atomic32_t;

    count: u32;
    #if ENABLE_STATISTICS {

        insert_count: size_t;

        extract_count: size_t;
    }

    span: [GLOBAL_CACHE_MULTIPLIER * MAX_THREAD_SPAN_CACHE] *span_t;

    overflow: *span_t;
}

rpmalloc_initialize :: () -> _int {
    return rp_initialize_default();
}

rpmalloc_is_initialized :: () -> bool {
    return rp_initialized;
}

rpmalloc_initialize_config :: (config: *rpmalloc_config_t) -> _int {
    return rp_initialize_config(config);
}

rpmalloc_finalize :: () {
    rp_finalize();
}

rpmalloc_thread_initialize :: () {
    native_thread_initialize();
}

rpmalloc_thread_finalize :: (release_caches: _int) {
    native_thread_finalize(cast(s32) release_caches);
}

rpmalloc_is_thread_initialized :: () -> bool {
    return native_thread_is_initialized() != 0;
}

rpmalloc_config :: () -> *rpmalloc_config_t {
    return rp_get_config();
}

rpmalloc :: (size: size_t) -> *void {
    return rp_allocate(null, cast(s64) size, 0);
}

rpfree :: (ptr: *void) {
    rp_free(null, ptr);
}

rpcalloc :: (num: size_t, size: size_t) -> *void {
    return rp_callocate(null, num, size, 0);
}

rprealloc :: (ptr: *void, size: size_t) -> *void {
    return rp_reallocate(null, ptr, cast(s64) size, 0, 0, .{});
}

rpaligned_realloc :: (ptr: *void, alignment: size_t, size: size_t, oldsize: size_t, flags: Realloc_Flags) -> *void {
    return rp_reallocate(null, ptr, cast(s64) size, cast(s64) alignment, cast(s64) oldsize, flags);
}

rpaligned_alloc :: (alignment: size_t, size: size_t) -> *void {
    return rp_allocate(null, cast(s64) size, cast(s64) alignment);
}

rpaligned_calloc :: (alignment: size_t, num: size_t, size: size_t) -> *void {
    return rp_callocate(null, num, size, alignment);
}

rpmemalign :: (alignment: size_t, size: size_t) -> *void {
    return rp_allocate(null, cast(s64) size, cast(s64) alignment);
}

rpposix_memalign :: (memptr: **void, alignment: size_t, size: size_t) -> _int {
    result := native_posix_memalign(memptr, alignment, size);
    if result == 0 rp_record(memptr.*, null);
    return result;
}

rpmalloc_usable_size :: (ptr: *void) -> size_t {
    return native_usable_size(ptr);
}

rpmalloc_thread_collect :: () {
    native_thread_collect();
}

rpmalloc_thread_statistics :: (stats: *rpmalloc_thread_statistics_t) {
    native_thread_statistics(stats);
}

rpmalloc_global_statistics :: (stats: *rpmalloc_global_statistics_t) {
    native_global_statistics(stats);
}

rpmalloc_dump_statistics :: (file: *void) {
    native_dump_statistics(file);
}

#if RPMALLOC_FIRST_CLASS_HEAPS {

    rpmalloc_heap_acquire :: () -> *rpmalloc_heap_t {
        return cast(*rpmalloc_heap_t) native_heap_acquire();
    }

    rpmalloc_heap_release :: (heap: *rpmalloc_heap_t) {
        native_heap_release(heap);
    }

    rpmalloc_heap_alloc :: (heap: *rpmalloc_heap_t, size: size_t) -> *void {
        return rp_allocate(heap, cast(s64) size, 0);
    }

    rpmalloc_heap_aligned_alloc :: (heap: *rpmalloc_heap_t, alignment: size_t, size: size_t) -> *void {
        return rp_allocate(heap, cast(s64) size, cast(s64) alignment);
    }

    rpmalloc_heap_calloc :: (heap: *rpmalloc_heap_t, num: size_t, size: size_t) -> *void {
        return rp_callocate(heap, num, size, 0);
    }

    rpmalloc_heap_aligned_calloc :: (heap: *rpmalloc_heap_t, alignment: size_t, num: size_t, size: size_t) -> *void {
        return rp_callocate(heap, num, size, alignment);
    }

    rpmalloc_heap_realloc :: (heap: *rpmalloc_heap_t, ptr: *void, size: size_t, flags: Realloc_Flags) -> *void {
        return rp_reallocate(heap, ptr, cast(s64) size, 0, 0, flags);
    }

    rpmalloc_heap_aligned_realloc :: (heap: *rpmalloc_heap_t, ptr: *void, alignment: size_t, size: size_t, flags: Realloc_Flags) -> *void {
        return rp_reallocate(heap, ptr, cast(s64) size, cast(s64) alignment, 0, flags);
    }

    rpmalloc_heap_free :: (heap: *rpmalloc_heap_t, ptr: *void) {
        rp_free(heap, ptr);
    }

    rpmalloc_heap_free_all :: (heap: *rpmalloc_heap_t) {
        rp_free_all(heap);
    }

    rpmalloc_heap_thread_set_current :: (heap: *rpmalloc_heap_t) {
        native_heap_thread_set_current(heap);
    }

}

ENABLE_OVERRIDE :: false;

rpmalloc_linker_reference :: () {
    native_config();
}

RPMALLOC_CONFIGURABLE :: CONFIGURABLE;

Realloc_Flags :: enum_flags u32 {
    NO_PRESERVE :: 1;
    GROW_OR_FAIL :: 2;
}

rpmalloc_global_statistics_t :: struct {

    mapped: size_t;

    mapped_peak: size_t;

    cached: size_t;

    huge_alloc: size_t;

    huge_alloc_peak: size_t;

    mapped_total: size_t;

    unmapped_total: size_t;
}

rpmalloc_thread_statistics_t :: struct {

    sizecache: size_t;

    spancache: size_t;

    thread_to_global: size_t;

    global_to_thread: size_t;

    span_use: [64] struct {

        current: size_t;

        peak: size_t;

        to_global: size_t;

        from_global: size_t;

        to_cache: size_t;

        from_cache: size_t;

        to_reserved: size_t;

        from_reserved: size_t;

        map_calls: size_t;
    };

    size_use: [128] struct {

        alloc_current: size_t;

        alloc_peak: size_t;

        alloc_total: size_t;

        free_total: size_t;

        spans_to_cache: size_t;

        spans_from_cache: size_t;

        spans_from_reserved: size_t;

        map_calls: size_t;
    };
}

rpmalloc_config_t :: struct {

    memory_map: #type (size: size_t, offset: *size_t) -> *void;

    memory_unmap: #type (address: *void, size: size_t, offset: size_t, release: size_t) -> ();

    error_callback: #type (message: string) -> ();

    map_fail_callback: #type (size: size_t) -> _int;

    page_size: size_t;

    span_size: size_t;

    span_map_count: size_t;

    enable_huge_pages: _int;

    page_name: string;
    huge_page_name: string;
}

#if RPMALLOC_FIRST_CLASS_HEAPS {
    rpmalloc_heap_t :: heap_t;
}

rpmalloc_thread_finalize :: (release_caches: bool) {
    native_thread_finalize(cast(s32) release_caches);
}

Heap :: heap_t;

initialize :: rpmalloc_initialize;
initialize_config :: rpmalloc_initialize_config;
finalize :: rpmalloc_finalize;
is_initialized :: rpmalloc_is_initialized;
thread_initialize :: rpmalloc_thread_initialize;
thread_finalize :: rpmalloc_thread_finalize;
is_thread_initialized :: rpmalloc_is_thread_initialized;
set_main_thread :: rpmalloc_set_main_thread;
config :: rpmalloc_config;
usable_size :: rpmalloc_usable_size;
thread_statistics :: rpmalloc_thread_statistics;
global_statistics :: rpmalloc_global_statistics;
dump_statistics :: rpmalloc_dump_statistics;
#if RPMALLOC_FIRST_CLASS_HEAPS {
    heap_acquire :: rpmalloc_heap_acquire;
    heap_release :: rpmalloc_heap_release;
    heap_alloc :: rpmalloc_heap_alloc;
    heap_aligned_alloc :: rpmalloc_heap_aligned_alloc;
    heap_realloc :: rpmalloc_heap_realloc;
    heap_aligned_realloc :: rpmalloc_heap_aligned_realloc;
    heap_free :: rpmalloc_heap_free;
    heap_free_all :: rpmalloc_heap_free_all;
    heap_thread_set_current :: rpmalloc_heap_thread_set_current;
}


// Main-thread designation uses the genuine first-class heap API.
rpmalloc_set_main_thread :: () {
    rp_set_main_thread();
}
