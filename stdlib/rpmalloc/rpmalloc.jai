#if ENABLE_THREAD_CACHE { SPAN_LARGE_CACHE_COUNT :: LARGE_CLASS_COUNT - 1; }
// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
SMALL_GRANULARITY       :: 16;

SMALL_GRANULARITY_SHIFT :: 4;

SMALL_CLASS_COUNT       :: 65;

SMALL_SIZE_LIMIT        :: SMALL_GRANULARITY * (SMALL_CLASS_COUNT - 1);

MEDIUM_GRANULARITY       :: 512;

MEDIUM_GRANULARITY_SHIFT :: 9;

MEDIUM_CLASS_COUNT       :: 61;

SIZE_CLASS_COUNT  :: SMALL_CLASS_COUNT + MEDIUM_CLASS_COUNT;

LARGE_CLASS_COUNT :: 63;

MEDIUM_SIZE_LIMIT :: SMALL_SIZE_LIMIT + (MEDIUM_GRANULARITY * MEDIUM_CLASS_COUNT);

SPAN_HEADER_SIZE  :: 128;

MAX_THREAD_SPAN_CACHE            :: 400;

THREAD_SPAN_CACHE_TRANSFER       :: 64;

MAX_THREAD_SPAN_LARGE_CACHE      :: 100;

THREAD_SPAN_LARGE_CACHE_TRANSFER :: 6;

INVALID_POINTER :: cast(*void) -1;

SIZE_CLASS_LARGE :: SIZE_CLASS_COUNT;

SIZE_CLASS_HUGE :: cast,no_check(u32) -1;

memory_default_span_size :: 64 * 1024;

memory_default_span_size_shift :: 16;

memory_default_span_mask : u64 : ~cast(u64)(memory_default_span_size - 1);

Span :: struct {
    free_list : *void;
    block_count : u32;
    size_class : u32;
    free_list_limit : u32;
    used_count : u32;
    free_list_deferred : *void;
    list_size : u32;
    block_size : u32;

    flags : enum_flags u32 {
        MASTER ::          1;
        SUBSPAN ::         2;
        ALIGNED_BLOCKS ::  4;
        UNMAPPED_MASTER :: 8;
    };

    span_count : u32;
    total_spans : u32;
    offset_from_master : u32;
    remaining_spans : s32;
    align_offset : u32;
    heap : *Heap;
    next : *Span;
    prev : *Span;
}

Heap :: struct {
    owner_thread : u64;
    size_class : [SIZE_CLASS_COUNT] Heap_Size_Class;

    #if ENABLE_THREAD_CACHE {
        span_cache : Span_Cache;
    }

    span_free_deferred : *void;
    full_span_count : s64;
    span_reserve : *Span;
    span_reserve_master : *Span;
    spans_reserved : u32;
    child_count : s32;
    next_heap : *Heap;
    next_orphan : *Heap;
    id : s32;
    finalize : s32;
    master_heap : *Heap;

    #if ENABLE_THREAD_CACHE {

        span_large_cache : [SPAN_LARGE_CACHE_COUNT] Span_Large_Cache;
    }

    full_span : [SIZE_CLASS_COUNT] *Span;
    large_huge_span : *Span;

    #if ENABLE_ADAPTIVE_THREAD_CACHE || ENABLE_STATISTICS {
        span_use : [LARGE_CLASS_COUNT] Span_Use;
    }

    #if ENABLE_STATISTICS {
        size_class_use : [SIZE_CLASS_COUNT + 1] Size_Class_Use;
        thread_to_global : s64;
        global_to_thread : s64;
    }
}

Span_Cache :: struct {
    count : s64;
    span : [MAX_THREAD_SPAN_CACHE] *Span;
}

Span_Large_Cache :: struct {
    count : s64;
    span : [MAX_THREAD_SPAN_LARGE_CACHE] *Span;
}

Heap_Size_Class :: struct {
    free_list : *void;

    partial_span : *Span;

    cache : *Span;
}

Size_Class :: struct {
    block_size :  u32;
    block_count : u16;
    class_idx :   u16;
}

Global_Cache :: struct {
    lock :  s32;
    count : u32;

    #if ENABLE_STATISTICS {
        insert_count : s64;
        extract_count : s64;
    }

    span : [GLOBAL_CACHE_MULTIPLIER * MAX_THREAD_SPAN_CACHE] *Span;

    overflow : *Span;
}

Realloc_Flags :: enum_flags u32 {

    NO_PRESERVE :: 1;

    GROW_OR_FAIL :: 2;
}

initialize :: () -> s32 #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_initialize_1";

finalize :: () #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_finalize_1";

initialize_config :: (config: *rpmalloc_config_t) -> s32 #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_initialize_config_1";

is_initialized :: () -> bool #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_is_initialized_1";

thread_initialize :: () #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_thread_initialize_1";

thread_finalize :: (release_caches: bool) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_thread_finalize_1";

is_thread_initialized :: () -> bool #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_is_thread_initialized_1";

set_main_thread :: () #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_set_main_thread_1";

config :: () -> *rpmalloc_config_t #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_config_1";

rpmalloc :: (size: s64) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_rpmalloc_1";

rpfree :: (ptr: *void) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_rpfree_1";

rprealloc :: (ptr: *void, size: s64) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_rprealloc_1";

rpaligned_realloc :: (ptr: *void, alignment: s64, size: s64, oldsize: s64, flags: Realloc_Flags) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_rpaligned_realloc_1";

rpaligned_alloc :: (alignment: s64, size: s64) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_rpaligned_alloc_1";

usable_size :: (ptr: *void) -> s64 #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_usable_size_1";

thread_statistics :: (stats: *rpmalloc_thread_statistics_t) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_thread_statistics_1";

global_statistics :: (stats: *rpmalloc_global_statistics_t) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_global_statistics_1";

#if ENABLE_STATISTICS {
    dump_statistics :: (builder: *$T ) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_dump_statistics_1";
} else {
    dump_statistics :: (builder: *void) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_dump_statistics_2";
}

heap_acquire :: () -> *Heap #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_acquire_1";

heap_release :: (heap: *Heap) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_release_1";

heap_is_this_yours :: (heap: *Heap, memory: *void) -> bool #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_is_this_yours_1";

is_in_span :: (memory: *void, span: *Span) -> bool #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_is_in_span_1";

heap_alloc :: (heap: *Heap, size: s64) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_alloc_1";

heap_aligned_alloc :: (heap: *Heap, alignment: s64, size: s64) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_aligned_alloc_1";

heap_realloc :: (heap: *Heap, ptr: *void, size: s64, flags: Realloc_Flags) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_realloc_1";

heap_aligned_realloc :: (heap: *Heap, ptr: *void, alignment: s64, size: s64, flags: Realloc_Flags) -> *void #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_aligned_realloc_1";

heap_free :: (heap: *Heap, ptr: *void) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_free_1";

heap_free_all :: (heap: *Heap) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_free_all_1";

heap_thread_set_current :: (heap: *Heap) #foreign codec_adapter "jai_stdlib_rpmalloc_rpmalloc_heap_thread_set_current_1";

errno : enum s32 {
    SUCCESS ::  0;
    ENOMEM ::  12;
    EINVAL ::  22;
};

rpmalloc_global_statistics_t :: struct {
	mapped:          s64;
    mapped_peak:     s64;
    cached:          s64;
    huge_alloc:      s64;
    huge_alloc_peak: s64;
    mapped_total:    s64;
    unmapped_total:  s64;
}

rpmalloc_thread_statistics_t :: struct {
    sizecache:        s64;
    spancache:        s64;
    thread_to_global: s64;
    global_to_thread: s64;

	span_use : [64] struct {
	    current:       s64;
	    peak:          s64;
	    to_global:     s64;
	    from_global:   s64;
	    to_cache:      s64;
	    from_cache:    s64;
	    to_reserved:   s64;
	    from_reserved: s64;
	    map_calls:     s64;
	};

	size_use : [128] struct {
	    alloc_current:       s64;
	    alloc_peak:          s64;
	    alloc_total:         s64;
	    free_total:          s64;
	    spans_to_cache:      s64;
	    spans_from_cache:    s64;
	    spans_from_reserved: s64;
	    map_calls:           s64;
	};
}

rpmalloc_config_t :: struct {

	memory_map : #type (size: s64, offset: *s64) -> *void;

	memory_unmap : #type (address: *void, size: s64, offset: s64, release: s64) -> ();

    error_callback : #type (message: string, location: Source_Code_Location) -> ();

	map_fail_callback : #type (size: s64) -> s32;

    page_size: s64;

    span_size: s64;

    span_map_count: s64;

	enable_huge_pages: bool;

	page_name: string;
	huge_page_name: string;
}

#scope_file
codec_adapter :: #system_library "jai_rpmalloc_adapter";
