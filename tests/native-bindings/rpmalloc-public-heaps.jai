// Public oracle: reviewed rpmalloc.md heap signatures/contextual records.
// Behavioral assertions cover ownership and real allocation, not SDK internals.
#import "Basic";
RPM :: #import "rpmalloc";
Small :: #import "rpmalloc"(ENABLE_STATISTICS = false);

main :: () {
    assert(RPM.initialize() == 0);
    assert(Small.initialize() == 0);
    first := RPM.heap_acquire();
    second := RPM.heap_acquire();

    assert(first != null && second != null && first != second);
    assert(type_info(type_of(first.*)).name == "Heap");
    memory := RPM.heap_alloc(first, 301);

    assert(memory != null);
    assert(RPM.heap_is_this_yours(first, memory));
    assert(!RPM.heap_is_this_yours(first, cast(*void) 123));
    (cast(*u8) memory)[0] = 47;
    small := Small.heap_acquire();

    assert(small != null && type_info(type_of(small.*)).name == "Heap");
    other := Small.heap_alloc(small, 301);

    assert(other != null && !RPM.heap_is_this_yours(first, other));
    assert(!Small.heap_is_this_yours(small, memory));
    small_span_found: bool;

    for 0..125 {
        span := small.size_class[it].partial_span;
        if span && Small.is_in_span(other, span) {
            assert(span.heap == small && span.block_size >= 301);
            small_span_found = true;
        }
    }

    assert(small_span_found);
    Small.heap_free(small, other);
    Small.heap_release(small);
    Small.finalize();
    replacement := RPM.heap_realloc(first, memory, 801, .{});

    assert(replacement != null && (cast(*u8) replacement)[0] == 47);
    assert(RPM.heap_realloc(first, replacement, -1, .{}) == null);
    assert(RPM.heap_realloc(first, replacement, 0x4000_0000_0000_0000, .{}) == null);
    assert((cast(*u8) replacement)[0] == 47);
    span_found: bool;

    for 0..125 {
        span := first.size_class[it].partial_span;
        if span && RPM.is_in_span(replacement, span) {
            assert(type_info(type_of(span.*)).name == "Span");
            assert(span.heap == first && span.block_count > 0 && span.block_size >= 801);
            tail := span;
            while tail.next tail = tail.next;

            assert(span.prev == tail);
            assert(span.free_list_limit <= span.block_count);
            assert(!RPM.is_in_span(cast(*void) 123, span));
            span_found = true;
        }
    }

    assert(span_found);
    current_allocations: s64;
    for 0..126 current_allocations += first.size_class_use[it].alloc_current;

    assert(current_allocations > 0);
    RPM.heap_free(first, replacement);
    memory = RPM.heap_aligned_alloc(second, 64, 321);
    assert(memory != null && (cast(u64) memory & 63) == 0);
    (cast(*u8) memory)[0] = 91;
    memory = RPM.heap_aligned_realloc(second, memory, 64, 1024, .{});
    assert(memory != null && (cast(*u8) memory)[0] == 91);
    RPM.heap_free_all(second);
    cached_memory := RPM.heap_alloc(second, 100_000);

    assert(cached_memory != null && RPM.heap_is_this_yours(second, cached_memory));
    RPM.heap_free(second, cached_memory);
    // Query only: never dereference the former allocation. Cache/reserve-only
    // ranges are excluded by the reviewed active-list ownership contract.
    assert(!RPM.heap_is_this_yours(second, cached_memory));
    memory = RPM.heap_alloc(second, 4096);
    assert(memory != null);
    RPM.heap_free(second, memory);
    RPM.heap_release(second);
    RPM.heap_thread_set_current(first);
    memory = RPM.rpmalloc(512);
    assert(memory != null && RPM.heap_is_this_yours(first, memory));
    RPM.rpfree(memory);
    RPM.heap_release(first);
    RPM.thread_initialize();
    RPM.finalize();
}
