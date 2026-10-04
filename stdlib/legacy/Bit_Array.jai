// Historical signed-word descriptor; independently authored per-bit traversal.
#scope_file
#import "Basic";
#scope_export

Bit_Array :: struct {
    slots: []s64;
    count: int;
    allocator: Allocator;
}

init_bit_array :: (array: *Bit_Array, count: int) {
    assert(count >= 0 && array.slots.data == null);
    if !array.allocator.proc array.allocator = context.allocator;
    words := count / 64;
    if count % 64 != 0 words += 1;
    array.slots = NewArray(words, s64, allocator=array.allocator);
    array.count = count;
}
make_bit_array :: (count: int) -> Bit_Array #must {
    result: Bit_Array;
    init_bit_array(*result, count);
    return result;
}
deinit :: (using array: *Bit_Array) {
    if slots.data free(slots.data, allocator=allocator);
    slots = .{};
    count = 0;
}
set_bit :: (using array: *Bit_Array, i: int) {
    assert(i >= 0 && i < count);
    slots[i / 64] = set_bits(slots[i / 64], _bit_mask(i), true);
}
clear_bit :: (using array: *Bit_Array, i: int) {
    assert(i >= 0 && i < count);
    slots[i / 64] = set_bits(slots[i / 64], _bit_mask(i), false);
}
toggle_bit :: (using array: *Bit_Array, i: int) {
    assert(i >= 0 && i < count);
    slots[i / 64] ^= _bit_mask(i);
}
set_bit_to :: (using array: *Bit_Array, i: int, value: bool) {
    assert(i >= 0 && i < count);
    slots[i / 64] = set_bits(slots[i / 64], _bit_mask(i), value);
}
operator [] :: (a: Bit_Array, i: int) -> bool {
    assert(i >= 0 && i < a.count);
    return (a.slots[i / 64] & _bit_mask(i)) != 0;
}
operator []= :: inline (a: *Bit_Array, i: int, value: bool) { set_bit_to(a, i, value); }
clear_all_bits :: (using array: *Bit_Array) { for *slot: slots slot.* = 0; }
set_all_bits :: (using array: *Bit_Array) { for *slot: slots slot.* = -1; }
toggle_all_bits :: (using array: *Bit_Array) { for *slot: slots slot.* = ~slot.*; }

for_expansion :: (array: *Bit_Array, body: Code, flags: For_Flags) #expand {
    #assert(flags == 0);
    cursor: int = 0;
    while cursor < array.count {
        `it_index := cursor;
        `it := (<<array)[cursor];
        cursor += 1;
        #insert (remove=#assert(false)) body;
    }
}
only_set :: #bake_arguments only_set_or_unset(target_value=true);
only_unset :: #bake_arguments only_set_or_unset(target_value=false);

#scope_file
_bit_mask :: (index: int) -> s64 {
    return cast,no_check(s64)(cast(u64)1 << (index % 64));
}
set_bits :: inline (w: s64, m: s64, b: bool) -> s64 {
    if b return w | m;
    return w & ~m;
}
only_set_or_unset :: (array: *Bit_Array, body: Code, flags: For_Flags, target_value: bool) #expand {
    #assert(flags == 0);
    cursor: int = 0;
    while cursor < array.count {
        index := cursor;
        cursor += 1;
        if (<<array)[index] != target_value continue;
        `it_index := index;
        `it := target_value;
        #insert (remove=#assert(false)) body;
    }
}
