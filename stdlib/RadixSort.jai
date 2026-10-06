// RadixSort: sorts a rank (index) array for u32/u64/float input without moving the data. Ranks come from a
// stable merge; `valid_ranks` lets a re-sort start from the previous order.
#scope_file
#import "Basic";
#scope_export

RadixSort :: struct {
    ranks: [] u32;
    ranks2: [] u32;
    valid_ranks: bool;
    allocator: Allocator;
}
reset :: (using radix: *RadixSort) {
    valid_ranks = false;
}
resize :: (using radix: *RadixSort, new_size: u32) {
    if ranks.count == new_size return;
    if !allocator.proc allocator = context.allocator;
    replacement := NewArray(new_size, u32,, allocator);
    scratch := NewArray(new_size, u32,, allocator);
    if ranks.data free(ranks.data, allocator = allocator);
    if ranks2.data free(ranks2.data, allocator = allocator);
    ranks = replacement;
    ranks2 = scratch;
    valid_ranks = false;
}
free_resources :: (using radix: *RadixSort) {
    if ranks.data free(ranks.data, allocator = allocator);
    if ranks2.data free(ranks2.data, allocator = allocator);
    ranks = .{};
    ranks2 = .{};
    valid_ranks = false;
}
operator [] :: (using radix: RadixSort, i: int) -> u32 {
    assert(i >= 0 && i < ranks.count);
    return ranks[i];
}
rank :: (using radix: *RadixSort, i: int) -> u32 {
    assert(i >= 0 && i < ranks.count);
    return ranks[i];
}
sort :: (using radix: *RadixSort, input: *u32, count: u32) {
    _merge_ranks(radix, input, count);
}
sort :: (using radix: *RadixSort, input: *u64, count: u32) {
    _merge_ranks(radix, input, count);
}
sort :: (using radix: *RadixSort, input: *float, count: u32) {
    _merge_ranks(radix, input, count);
}
sort :: (using radix: *RadixSort, input: [] u32) {
    sort(radix, input.data, cast(u32) input.count);
}
sort :: (using radix: *RadixSort, input: [] u64) {
    sort(radix, input.data, cast(u32) input.count);
}
sort :: (using radix: *RadixSort, input: [] float) {
    sort(radix, input.data, cast(u32) input.count);
}
reorder :: (input: *[..] $T, radix: RadixSort) {
    assert(input.count == radix.ranks.count && radix.valid_ranks);
    result: [..] T;
    result.allocator = input.allocator;
    array_resize(*result, input.count, false);
    for i: 0..input.count - 1 result[i] = input.*[radix.ranks[i]];
    array_reset(input);
    input.* = result;
}
radix_tests :: () {
    data := u32.[8, 3, 3, 0, 9];
    sorter: RadixSort;
    defer free_resources(*sorter);
    sort(*sorter, data);
    assert(sorter[0] == 3 && sorter[1] == 1 && sorter[2] == 2);
    sort(*sorter, data);
    assert(sorter[1] == 1 && sorter[2] == 2);
} @test

#scope_file
_take_left :: (a: $T, b: T) -> bool {
    #if T == float {
        if a != a return b != b;
        if b != b return true;
    }
    return a <= b;
}
_merge_ranks :: (radix: *RadixSort, input: *$T, count: u32) {
    if input == null || count == 0 return;
    resize(radix, count);
    if !radix.valid_ranks {
        for i: 0..cast(int) count - 1 radix.ranks[i] = cast(u32) i;
    }
    width: s64 = 1;
    while width < count {
        base: s64 = 0;
        while base < count {
            middle := min(base + width, cast(s64) count);
            end := min(middle + width, cast(s64) count);
            left := base;
            right := middle;
            output := base;
            while output < end {
                if right == end || (left < middle && _take_left(input[radix.ranks[left]], input[radix.ranks[right]])) {
                    radix.ranks2[output] = radix.ranks[left];
                    left += 1;
                } else {
                    radix.ranks2[output] = radix.ranks[right];
                    right += 1;
                }
                output += 1;
            }
            base = end;
        }
        original := radix.ranks;
        radix.ranks = radix.ranks2;
        radix.ranks2 = original;
        width *= 2;
    }
    radix.valid_ranks = true;
}
