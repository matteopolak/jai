// Authored scalar operations share the checked compare_and_swap primitive.
atomic_read :: (pointer: *$T) -> T #expand {
    zero: T;
    _, observed := compare_and_swap(pointer, zero, zero);
    return observed;
}

atomic_swap :: (dest: *$T, new_value: T) -> (old_value: T) {
    old := atomic_read(dest);
    while true {
        success, observed := compare_and_swap(dest, old, new_value);
        if success return old;
        old = observed;
    }
}

atomic_write :: (pointer: *$T, new_value: T) #expand {
    atomic_swap(pointer, new_value);
}

atomic_add :: (dest: *$T, to_add: $I) -> T {
    old := atomic_read(dest);
    while true {
        replacement := old + cast,trunc(T) to_add;
        success, observed := compare_and_swap(dest, old, replacement);
        if success return old;
        old = observed;
    }
    return old;
}

atomic_increment :: (dest: *$T) {
    atomic_add(dest, 1);
}

atomic_decrement :: (dest: *$T) -> bool {
    old := atomic_add(dest, -1);
    return old == 1;
}

atomic_and :: (dest: *$T, value: T) {
    old := atomic_read(dest);
    while true {
        success, observed := compare_and_swap(dest, old, old & value);
        if success return;
        old = observed;
    }
}

atomic_or :: (dest: *$T, value: T) {
    old := atomic_read(dest);
    while true {
        success, observed := compare_and_swap(dest, old, old | value);
        if success return;
        old = observed;
    }
}

atomic_xor :: (dest: *$T, value: $I) {
    old := atomic_read(dest);
    while true {
        success, observed := compare_and_swap(dest, old, old ^ cast,trunc(T) value);
        if success return;
        old = observed;
    }
}

atomic_bit_test_and_set :: (dest: *$T, $$i: s64) -> bool {
    assert(i >= 0 && i < size_of(T) * 8);
    mask := (cast(T) 1) << i;
    old := atomic_read(dest);
    while true {
        success, observed := compare_and_swap(dest, old, old | mask);
        if success return (old & mask) != 0;
        old = observed;
    }
    return false;
}

IsAtomicScalar :: (T: Type) -> bool #compile_time {
    bytes := size_of(T);
    if bytes != 1 && bytes != 2 && bytes != 4 && bytes != 8 return false;
    info := type_info(T);
    while info.type == .VARIANT info = (cast(*Type_Info_Variant) info).variant_of;
    return info.type == .INTEGER || info.type == .ENUM || info.type == .BOOL ||
           info.type == .FLOAT || info.type == .POINTER || info.type == .PROCEDURE;
}

compare_and_swap2 :: (dest: *void, old_value_1: $T1_64, old_value_2: $T2_64,
    new_value_1: T1_64, new_value_2: T2_64) -> bool
    #deprecated "Nobody is using this and it is currently x64-only so... yeah." {
    #assert size_of(T1_64) == 8 && size_of(T2_64) == 8;
    #if OS == .LINUX && CPU == .X64 {
        pair: [2] u64;
        replacement: [2] u64;
        memcpy(*pair, *old_value_1, 8);
        memcpy(*pair[1], *old_value_2, 8);
        memcpy(*replacement, *new_value_1, 8);
        memcpy(*replacement[1], *new_value_2, 8);
        return native_compare_exchange(16, dest, *pair, *replacement, 5, 5);
    } else {
        assert(false, "compare_and_swap2 requires the Linux system libatomic provider");
        return false;
    }
}

#scope_file
#import "Basic";

#if OS == .LINUX && CPU == .X64 {
    atomic_library :: #system_library "atomic";

    native_compare_exchange :: (size: u64, dest: *void, expected: *void,
        replacement: *void, success_order: s32, failure_order: s32) -> bool
        #foreign atomic_library "__atomic_compare_exchange";
}

integer_for_size :: (size: s64, signed := false) -> Type, exists: bool = true #compile_time {
    if signed {
        if size == 1 return s8, true;
        if size == 2 return s16, true;
        if size == 4 return s32, true;
        if size == 8 return s64, true;
    } else {
        if size == 1 return u8, true;
        if size == 2 return u16, true;
        if size == 4 return u32, true;
        if size == 8 return u64, true;
    }
    return void, false;
}

IsSigned :: (type: Type) -> bool #compile_time {
    info := type_info(type);
    while info.type == .VARIANT info = (cast(*Type_Info_Variant) info).variant_of;
    if info.type == .ENUM info = (cast(*Type_Info_Enum) info).internal_type;
    if info.type != .INTEGER return false;
    return (cast(*Type_Info_Integer) info).signed;
}
