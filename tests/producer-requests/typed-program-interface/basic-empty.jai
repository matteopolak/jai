B :: #import "Basic"()(MEMORY_DEBUGGER = true, REPLACEMENT_INTERFACE = Hooks, VISUALIZE_MEMORY_DEBUGGER = false);

Hooks :: struct {
    check_alloc :: inline (allocator: Allocator, memory: *void, size: s64) {}
    check_free :: inline (allocator: Allocator, memory: *void) {}
    check_create_heap :: inline (allocator: Allocator) {}
    check_destroy_heap :: inline (allocator: Allocator) {}
}

main :: () {}
