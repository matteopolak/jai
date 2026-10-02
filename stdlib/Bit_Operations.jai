// Byte-oriented operations also handle signed integer representations.
byte_swap :: (input: $T) -> T #expand {
    result: T = input;
    source := cast(*u8) *input;
    target := cast(*u8) *result;
    index: s64 = 0;
    while index < size_of(T) {
        target[index] = source[size_of(T) - index - 1];
        index += 1;
    }
    return result;
}

byte_swap_in_place :: (input: *$T) #expand {
    left: s64 = 0;
    right := size_of(T) - 1;
    bytes := cast(*u8) input;
    while left < right {
        saved := bytes[left];
        bytes[left] = bytes[right];
        bytes[right] = saved;
        left += 1;
        right -= 1;
    }
}

bit_scan_forward :: (input: $T) -> s32 #expand #no_aoc {
    mask := cast(T) 1;
    position: s32 = 1;
    while position <= size_of(T) * 8 {
        if input & mask return position;
        mask <<= 1;
        position += 1;
    }
    return 0;
}

bit_scan_reverse :: (input: $T) -> s32 #expand #no_aoc {
    mask := cast(T) 1;
    position: s32 = 1;
    last: s32 = 0;
    while position <= size_of(T) * 8 {
        if input & mask last = position;
        mask <<= 1;
        position += 1;
    }
    return last;
}

popcount :: (value: $T) -> s32 #expand #no_aoc {
    count: s32 = 0;
    mask := cast(T) 1;
    position: s32 = 0;
    while position < size_of(T) * 8 {
        if value & mask count += 1;
        mask <<= 1;
        position += 1;
    }
    return count;
}

bits_equal :: inline (a: *void, b: *void, length_in_bytes: s64) -> bool {
    return memcmp(a, b, length_in_bytes) == 0;
}

bits_equal :: inline (a: *$T, b: *T) -> bool {
    return memcmp(a, b, size_of(T)) == 0;
}

first_different_byte :: (a: *void, b: *void, n: u64) -> u64 {
    left := cast(*u8) a;
    right := cast(*u8) b;
    offset: u64 = 0;
    while offset < n {
        if left[offset] != right[offset] return offset;
        offset += 1;
    }
    return n;
}
