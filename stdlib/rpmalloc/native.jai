// Independent Jai bridge to the genuine rpmalloc 1.4.4 C API.
// Native build profile: ENABLE_STATISTICS and RPMALLOC_CONFIGURABLE must match,
// RPMALLOC_FIRST_CLASS_HEAPS=1. No native allocator algorithm is replicated here.
#scope_module
Native_Config :: struct {
    memory_map: (size: u64, offset: *u64) -> *void #c_call;
    memory_unmap: (address: *void, size: u64, offset: u64, release: u64) #c_call;
    error_callback: (message: *u8) #c_call;
    map_fail_callback: (size: u64) -> s32 #c_call;
    page_size: u64;
    span_size: u64;
    span_map_count: u64;
    enable_huge_pages: s32;
    page_name: *u8;
    huge_page_name: *u8;
}
Allocation_Record :: struct {
    next: *Allocation_Record;
    memory: *void;
    capacity: u64;
    heap: *void;
}
rp_records: *Allocation_Record;
rp_records_lock: s32;
rp_initialized: bool;
rp_public_config: rpmalloc_config_t;
rp_callback_context: Context;
rp_page_name: *u8;
rp_huge_page_name: *u8;
rp_main_heap: *void;
rp_allocator_count: s64;
rp_allocator_owns_initialization: bool;

rp_lock :: () {
    while true {
        locked, _ := compare_and_swap(*rp_records_lock, 0, 1);
        if locked return;
    }
}
rp_unlock :: () {
    compare_and_swap(*rp_records_lock, 1, 0);
}
rp_record :: (memory: *void, heap: *void) {
    if !memory return;
    record := cast(*Allocation_Record) native_allocate(size_of(Allocation_Record));
    Basic.assert(record != null, "Unable to allocate rpmalloc ownership record");
    record.memory = memory;
    record.capacity = native_usable_size(memory);
    record.heap = heap;
    rp_lock();
    record.next = rp_records;
    rp_records = record;
    rp_unlock();
}
rp_forget :: (memory: *void) {
    if !memory return;
    rp_lock();
    link := *rp_records;
    while link.* {
        record := link.*;
        if record.memory == memory {
            link.* = record.next;
            native_free(record);
            break;
        }
        link = *record.next;
    }
    rp_unlock();
}
rp_owns :: (heap: *void, memory: *void) -> bool {
    if !memory return false;
    address := cast(u64) memory;
    rp_lock();
    defer rp_unlock();
    record := rp_records;
    while record {
        first := cast(u64) record.memory;
        if record.heap == heap && address >= first && address - first < record.capacity return true;
        record = record.next;
    }
    return false;
}
rp_allocate :: (heap: *void, size: s64, alignment: s64) -> *void {
    if size < 0 || alignment < 0 return null;
    result: *void;
    if heap {
        if alignment != 0 result = native_heap_aligned_allocate(heap, cast(u64) alignment, cast(u64) size);
        else result = native_heap_allocate(heap, cast(u64) size);
    } else {
        if alignment != 0 result = native_aligned_allocate(cast(u64) alignment, cast(u64) size);
        else result = native_allocate(cast(u64) size);
    }
    rp_record(result, heap);
    return result;
}
rp_callocate :: (heap: *void, count: u64, size: u64, alignment: u64) -> *void {
    if count != 0 && size > cast(u64) S64_MAX / count return null;
    result := rp_allocate(heap, cast(s64) (count * size), cast(s64) alignment);
    if result Basic.memset(result, 0, cast(s64) (count * size));
    return result;
}
rp_reallocate :: (heap: *void, memory: *void, size: s64, alignment: s64, oldsize: s64, flags: Realloc_Flags) -> *void {
    if size < 0 || alignment < 0 || oldsize < 0 return null;
    result: *void;
    if heap {
        if alignment != 0 result = native_heap_aligned_reallocate(heap, memory, cast(u64) alignment, cast(u64) size, cast(u32) flags);
        else result = native_heap_reallocate(heap, memory, cast(u64) size, cast(u32) flags);
    } else {
        if alignment != 0 || flags != .{} result = native_aligned_reallocate(memory, cast(u64) alignment, cast(u64) size, cast(u64) oldsize, cast(u32) flags);
        else result = native_reallocate(memory, cast(u64) size);
    }
    // Failed realloc preserves the original block; size zero is native free.
    if result || size == 0 {
        rp_forget(memory);
        rp_record(result, heap);
    }
    return result;
}
rp_free :: (heap: *void, memory: *void) {
    rp_forget(memory);
    if heap native_heap_free(heap, memory);
    else native_free(memory);
}
rp_free_all :: (heap: *void) {
    rp_lock();
    link := *rp_records;
    while link.* {
        record := link.*;
        if record.heap == heap {
            link.* = record.next;
            native_free(record);
        } else link = *record.next;
    }
    rp_unlock();
    native_heap_free_all(heap);
}
rp_initialize_default :: () -> s32 {
    result := native_initialize();
    if result == 0 rp_initialized = true;
    return result;
}
rp_initialize_config :: (config: *rpmalloc_config_t) -> s32 {
    if !config return rp_initialize_default();
    rp_public_config = config.*;
    rp_callback_context = context;
    native: Native_Config;
    if config.memory_map native.memory_map = rp_map_callback;
    if config.memory_unmap native.memory_unmap = rp_unmap_callback;
    if config.error_callback native.error_callback = rp_error_callback;
    if config.map_fail_callback native.map_fail_callback = rp_map_fail_callback;
    native.page_size = cast(u64) config.page_size;
    native.span_size = cast(u64) config.span_size;
    native.span_map_count = cast(u64) config.span_map_count;
    native.enable_huge_pages = cast(s32) config.enable_huge_pages;
    rp_page_name = Basic.to_c_string(config.page_name);
    rp_huge_page_name = Basic.to_c_string(config.huge_page_name);
    native.page_name = rp_page_name;
    native.huge_page_name = rp_huge_page_name;
    result := native_initialize_config(*native);
    if result == 0 rp_initialized = true;
    else {
        Basic.free(rp_page_name, rp_callback_context.allocator);
        Basic.free(rp_huge_page_name, rp_callback_context.allocator);
        rp_page_name = null;
        rp_huge_page_name = null;
    }
    return result;
}
rp_get_config :: () -> *rpmalloc_config_t {
    native := native_config();
    rp_public_config.page_size = cast(type_of(rp_public_config.page_size)) native.page_size;
    rp_public_config.span_size = cast(type_of(rp_public_config.span_size)) native.span_size;
    rp_public_config.span_map_count = cast(type_of(rp_public_config.span_map_count)) native.span_map_count;
    rp_public_config.enable_huge_pages = cast(type_of(rp_public_config.enable_huge_pages)) native.enable_huge_pages;
    return *rp_public_config;
}
rp_finalize :: () {
    rp_lock();
    while rp_records {
        record := rp_records;
        rp_records = record.next;
        native_free(record);
    }
    rp_unlock();
    native_finalize();
    rp_initialized = false;
    rp_main_heap = null;
    if rp_page_name Basic.free(rp_page_name, rp_callback_context.allocator);
    if rp_huge_page_name Basic.free(rp_huge_page_name, rp_callback_context.allocator);
    rp_page_name = null;
    rp_huge_page_name = null;
    rp_allocator_owns_initialization = false;
}
rp_set_main_thread :: () {
    if !rp_main_heap rp_main_heap = native_heap_acquire();
    native_heap_thread_set_current(rp_main_heap);
}
rp_map_callback :: (size: u64, offset: *u64) -> *void #c_call {
    push_context rp_callback_context {
    return rp_public_config.memory_map(cast(type_of(rp_public_config.page_size)) size, cast(*type_of(rp_public_config.page_size)) offset);
    }
}
rp_unmap_callback :: (address: *void, size: u64, offset: u64, release: u64) #c_call {
    push_context rp_callback_context {
    rp_public_config.memory_unmap(address, cast(type_of(rp_public_config.page_size)) size,
                                   cast(type_of(rp_public_config.page_size)) offset,
                                   cast(type_of(rp_public_config.page_size)) release);
    }
}
rp_error_callback :: (message: *u8) #c_call {
    push_context rp_callback_context {
    length: s64;
    while message[length] != 0 length += 1;
    text: string = .{length, message};
    #if USE_RAW rp_public_config.error_callback(text);
    else rp_public_config.error_callback(text, .{});
    }
}
rp_map_fail_callback :: (size: u64) -> s32 #c_call {
    push_context rp_callback_context {
    return rp_public_config.map_fail_callback(cast(type_of(rp_public_config.page_size)) size);
    }
}

#scope_module
rp_upstream :: #system_library "rpmalloc";
native_initialize :: () -> s32 #foreign rp_upstream "rpmalloc_initialize";
native_initialize_config :: (config: *Native_Config) -> s32 #foreign rp_upstream "rpmalloc_initialize_config";
native_config :: () -> *Native_Config #foreign rp_upstream "rpmalloc_config";
native_finalize :: () #foreign rp_upstream "rpmalloc_finalize";
native_thread_initialize :: () #foreign rp_upstream "rpmalloc_thread_initialize";
native_thread_finalize :: (release_caches: s32) #foreign rp_upstream "rpmalloc_thread_finalize";
native_thread_is_initialized :: () -> s32 #foreign rp_upstream "rpmalloc_is_thread_initialized";
native_thread_collect :: () #foreign rp_upstream "rpmalloc_thread_collect";
native_allocate :: (size: u64) -> *void #foreign rp_upstream "rpmalloc";
native_free :: (memory: *void) #foreign rp_upstream "rpfree";
native_reallocate :: (memory: *void, size: u64) -> *void #foreign rp_upstream "rprealloc";
native_aligned_allocate :: (alignment: u64, size: u64) -> *void #foreign rp_upstream "rpaligned_alloc";
native_aligned_reallocate :: (memory: *void, alignment: u64, size: u64, oldsize: u64, flags: u32) -> *void #foreign rp_upstream "rpaligned_realloc";
native_usable_size :: (memory: *void) -> u64 #foreign rp_upstream "rpmalloc_usable_size";
native_thread_statistics :: (stats: *rpmalloc_thread_statistics_t) #foreign rp_upstream "rpmalloc_thread_statistics";
native_global_statistics :: (stats: *rpmalloc_global_statistics_t) #foreign rp_upstream "rpmalloc_global_statistics";
native_dump_statistics :: (stream: *void) #foreign rp_upstream "rpmalloc_dump_statistics";
native_posix_memalign :: (memory: **void, alignment: u64, size: u64) -> s32 #foreign rp_upstream "rpposix_memalign";
native_heap_acquire :: () -> *void #foreign rp_upstream "rpmalloc_heap_acquire";
native_heap_release :: (heap: *void) #foreign rp_upstream "rpmalloc_heap_release";
native_heap_allocate :: (heap: *void, size: u64) -> *void #foreign rp_upstream "rpmalloc_heap_alloc";
native_heap_aligned_allocate :: (heap: *void, alignment: u64, size: u64) -> *void #foreign rp_upstream "rpmalloc_heap_aligned_alloc";
native_heap_reallocate :: (heap: *void, memory: *void, size: u64, flags: u32) -> *void #foreign rp_upstream "rpmalloc_heap_realloc";
native_heap_aligned_reallocate :: (heap: *void, memory: *void, alignment: u64, size: u64, flags: u32) -> *void #foreign rp_upstream "rpmalloc_heap_aligned_realloc";
native_heap_free :: (heap: *void, memory: *void) #foreign rp_upstream "rpmalloc_heap_free";
native_heap_free_all :: (heap: *void) #foreign rp_upstream "rpmalloc_heap_free_all";
native_heap_thread_set_current :: (heap: *void) #foreign rp_upstream "rpmalloc_heap_thread_set_current";
