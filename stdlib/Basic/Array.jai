// Independently authored array operations. Capacity belongs to the descriptor.
array_copy :: (array: [] $T) -> [] T {
    output, base := NewArray(array.count, T, false);
    for i: 0..array.count-1 output[i] = array[i];
    return output;
}
array_copy :: (array: [..] $T) -> [..] T {
    output: [..]T;
    array_copy(*output, array);
    return output;
}
array_copy :: (dest: *[..] $T, source: [] T) {
    array_resize(dest, source.count, false);
    for i: 0..source.count-1 dest.*[i] = source[i];
}
array_view :: inline (array: [] $T, index: int) -> [] T {
    return array_view(array, index, array.count-index);
}
array_view :: inline (array: [] $T, index: int, count: int) -> [] T {
    assert(index >= 0 && count >= 0 && index+count <= array.count);
    return .{count, array.data+index};
}
array_free :: (array: [] $T) { free(array.data); }
array_free :: (array: [..] $T) {
    if array.data {
        a := array.allocator;
        if !a.proc a = context.allocator;
        free(array.data, a);
    }
}
array_reset :: (array: *[] $T) {
    array_free(array.*);
    array.* = .{};
}
array_reset :: (array: *[..] $T) {
    array_free(array.*);
    array.data = null;
    array.count = 0;
    array.allocated = 0;
}
array_reset_keeping_memory :: inline (array: *[..] $T) { array.count = 0; }
array_reserve :: (array: *[..] $T, capacity: s64) {
    array_reserve(cast(*Resizable_Array) array, capacity, size_of(T));
}
array_reserve :: (array: *Resizable_Array, desired_items: s64, element_size: s64) {
    assert(desired_items >= 0 && element_size > 0);
    if desired_items <= array.allocated return;
    if !array.allocator.proc array.allocator = context.allocator;
    next := max(desired_items, max(8, array.allocated+array.allocated/2));
    block := alloc(next*element_size, array.allocator);
    assert(block != null, "array allocation failed");
    if !block return;
    if array.count > 0 memcpy(block, array.data, array.count*element_size);
    if array.data free(array.data, array.allocator);
    array.data = block;
    array.allocated = next;
}
array_add :: (array: *[..] $T) -> *T #must {
    array_reserve(array, array.count+1);
    result := array.data+array.count;
    Initialize(result);
    array.count += 1;
    return result;
}
array_add :: (array: *[..] $T, item: T) -> *T {
    array_reserve(array, array.count+1);
    result := array.data+array.count;
    result.* = item;
    array.count += 1;
    return result;
}
array_add :: (array: *[..] $T, to_append: ..T) {
    for item: to_append array_add(array, item);
}
array_add_if_unique :: (array: *[..] $T, item: T) -> bool, s64 {
    exists, index := _array_find_index(array.*, item);
    if exists return false, index;
    index = array.count;
    array_add(array, item);
    return true, index;
}
// Order-preserving insert; index == count appends.
array_insert_at :: (array: *[..] $T, item: T, index: int) {
    assert(index >= 0 && index <= array.count, "array_insert_at: index % is outside 0..%", index, array.count);
    array_add(array, item);
    // Bubble the new element from the end down to its slot.
    slot := array.count - 1;
    while slot > index {
        held := array.*[slot - 1];
        array.*[slot - 1] = array.*[slot];
        array.*[slot] = held;
        slot -= 1;
    }
}
array_unordered_remove_by_value :: (array: *[] $T, item: T, $stop_after_first := false) -> s64 {
    removed: s64;
    i: s64;
    while i < array.count {
        if array.*[i] == item {
            array_unordered_remove_by_index(array, i);
            removed += 1;
            #if stop_after_first return removed;
        } else i += 1;
    }
    return removed;
}
array_unordered_remove_by_index :: (array_pointer: *[] $T, index: s64) {
    assert(index >= 0 && index < array_pointer.count);
    last := array_pointer.count - 1;
    if index < last array_pointer.*[index] = array_pointer.*[last];
    array_pointer.count = last;
}
array_unordered_remove_by_index :: (array_pointer: *[..] $T, index: s64) {
    assert(index >= 0 && index < array_pointer.count);
    last := array_pointer.count - 1;
    if index < last array_pointer.*[index] = array_pointer.*[last];
    array_pointer.count = last;
}
array_ordered_remove_by_value :: (array_pointer: *[] $T, item: T) -> bool {
    found, index := array_find(array_pointer.*, item);
    if found array_ordered_remove_by_index(array_pointer, index);
    return found;
}
array_ordered_remove_by_index :: (array_pointer: *[] $T, index: s64) {
    assert(index >= 0 && index < array_pointer.count);
    for i: index..array_pointer.count-2 array_pointer.*[i] = array_pointer.*[i+1];
    array_pointer.count -= 1;
}
array_ordered_remove_by_index :: (array_pointer: *[..] $T, index: s64) {
    assert(index >= 0 && index < array_pointer.count);
    for i: index..array_pointer.count-2 array_pointer.*[i] = array_pointer.*[i+1];
    array_pointer.count -= 1;
}
array_find :: (array: [] $T, item: T) -> bool, s64 {
    return _array_find_index(array,item);
}
_array_find_index :: (array: [] $T, item: T) -> bool, s64 {
    for value, i: array if value == item return true, i;
    return false, -1;
}
peek :: (array: [] $T) -> T { assert(array.count > 0); return array[array.count-1]; }
peek :: (array: [..] $T) -> T { assert(array.count > 0); return array[array.count-1]; }
peek_pointer :: (array: [] $T) -> *T { assert(array.count > 0); return array.data+array.count-1; }
pop :: (array: *[] $T) -> T {
    result := peek(array.*);
    array.count -= 1;
    return result;
}
pop :: (array: *[..] $T) -> T {
    assert(array.count > 0);
    array.count -= 1;
    return array.data[array.count];
}
array_resize :: (array: *[] $T, new_count: s64, $initialize := true) {
    assert(new_count >= 0);
    old := array.*;
    replacement, base := NewArray(new_count, T, initialize);
    for i: 0..min(old.count,new_count)-1 replacement[i] = old[i];
    free(old.data);
    array.* = replacement;
}
array_resize :: (array: *[..] $T, new_count: s64, $initialize := true) {
    assert(new_count >= 0);
    array_reserve(array, new_count);
    #if initialize for i: array.count..new_count-1 Initialize(array.data+i);
    array.count = new_count;
}
maybe_grow :: (array: *Resizable_Array, element_size: s64) {
    array_reserve(array, array.count+1, element_size);
}
array_swap :: (array_a: *[..] $T, array_b: *[..] T) { Swap(array_a,array_b); }
init_range :: (ptr: *$T, begin: s64, end: s64) {
    for i: begin..end-1 Initialize(ptr+i);
}
