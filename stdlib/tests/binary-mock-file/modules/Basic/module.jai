// Test-only bounded arena; never installed as the replacement Basic module.
#add_context allocator: Allocator;
heap: [512] u8;
heap_used: s64;
alloc :: (size: s64) -> *void {
    if size < 0 || size > heap.count - heap_used return null;
    result := heap.data + heap_used;
    heap_used += size;
    return result;
}
alloc_string :: (count: int) -> string {
    if count <= 0 return "";
    bytes := cast(*u8) alloc(count);
    if !bytes return "";
    return .{ count, bytes };
}
// Arena memory is reclaimed with the witness process.
free :: (memory: *void) {}
free :: (memory: string) {}
