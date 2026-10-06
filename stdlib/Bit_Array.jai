// A fixed-size array of bits stored in 64-bit slots.

Bit_Array :: struct {
    slots: [] s64;
    count: int;

    allocator: Allocator;
}

// Allocates zeroed storage for `count` bits (from `array.allocator`, else the context's).
init_bit_array :: (array: *Bit_Array, count: int) {
    assert(count >= 0);
    array.count = count;
    if array.allocator.proc == null array.allocator = context.allocator;
    words_needed := count / 64;
    if count % 64 words_needed += 1;
    array.slots = Basic.NewArray(words_needed, s64,, array.allocator);
}

make_bit_array :: (count: int) -> Bit_Array #must {
    result: Bit_Array;
    init_bit_array(*result, count);
    return result;
}

deinit :: (array: *Bit_Array) {
    if array.slots.data Basic.free(array.slots.data,, array.allocator);
    array.slots = .[];
    array.count = 0;
}

set_bit :: (array: *Bit_Array, i: int) {
    assert(i >= 0 && i < array.count);
    array.slots[i >> 6] |= bit_mask(i);
}

clear_bit :: (array: *Bit_Array, i: int) {
    assert(i >= 0 && i < array.count);
    array.slots[i >> 6] &= ~bit_mask(i);
}

toggle_bit :: (array: *Bit_Array, i: int) {
    assert(i >= 0 && i < array.count);
    array.slots[i >> 6] ^= bit_mask(i);
}

set_bit_to :: (array: *Bit_Array, i: int, value: bool) {
    assert(i >= 0 && i < array.count);
    array.slots[i >> 6] = set_bits(array.slots[i >> 6], bit_mask(i), value);
}

operator [] :: (a: Bit_Array, i: int) -> bool {
    assert(i >= 0 && i < a.count);
    return (a.slots[i >> 6] & bit_mask(i)) != 0;
}

operator []= :: (a: *Bit_Array, i: int, value: bool) {
    set_bit_to(a, i, value);
}

clear_all_bits :: (array: *Bit_Array) {
    for *array.slots it.* = 0;
}

set_all_bits :: (array: *Bit_Array) {
    for *array.slots it.* = -1;
    mask_tail(array);
}

toggle_all_bits :: (array: *Bit_Array) {
    for *array.slots it.* = ~it.*;
    mask_tail(array);
}

for_expansion :: (array: *Bit_Array, body: Code, flags: For_Flags) #expand {
    #assert !(flags & .POINTER) "Bit_Array does not support iteration by pointer";
    cursor := 0;
    #if flags & .REVERSE cursor = array.count - 1;
    while cursor >= 0 && cursor < array.count {
        `it_index := cursor;
        `it := (array.*)[cursor];
        #insert (remove = {
            clear_bit(array, cursor);
        }) body;
        #if flags & .REVERSE cursor -= 1;
        else cursor += 1;
    }
}

// for_expansion variants that skip bits of the other value: `for :only_set flags { ... }`.
only_set :: #bake_arguments only_set_or_unset(target_value = true);
only_unset :: #bake_arguments only_set_or_unset(target_value = false);

set_bits :: inline (w: s64, m: s64, b: bool) -> s64 {
    if b return w | m;
    return w & ~m;
}

#scope_file

Basic :: #import "Basic";
assert :: Basic.assert;

bit_mask :: inline (i: int) -> s64 {
    return 1 << (i & 63);
}

// Bits past `count` in the last slot stay clear.
mask_tail :: (array: *Bit_Array) {
    tail := array.count & 63;
    if tail && array.slots.count array.slots[array.slots.count - 1] &= (1 << tail) - 1;
}

only_set_or_unset :: (array: *Bit_Array, body: Code, flags: For_Flags, target_value: bool) #expand {
    #assert !(flags & .POINTER) "Bit_Array does not support iteration by pointer";
    cursor := 0;
    #if flags & .REVERSE cursor = array.count - 1;
    while cursor >= 0 && cursor < array.count {
        if (array.*)[cursor] == target_value {
            `it := target_value;
            `it_index := cursor;
            #insert (remove = {
                set_bit_to(array, cursor, !target_value);
            }) body;
        }
        #if flags & .REVERSE cursor -= 1;
        else cursor += 1;
    }
}
