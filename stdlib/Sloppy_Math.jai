Math :: #import "Math";
DEFAULT_EPSILON :: 0.0001;
is_approximately_zero :: (f: float, epsilon := DEFAULT_EPSILON) -> bool {
    return Math.abs(f) <= epsilon;
}
values_are_close :: (f0: float, f1: float, epsilon := DEFAULT_EPSILON) -> bool {
    return Math.abs(f0 - f1) <= epsilon;
}
values_are_close :: (a: Math.Vector2, b: Math.Vector2, epsilon := DEFAULT_EPSILON) -> bool {
    return values_are_close(a.x, b.x, epsilon) && values_are_close(a.y, b.y, epsilon);
}
values_are_close :: (a: Math.Vector3, b: Math.Vector3, epsilon := DEFAULT_EPSILON) -> bool {
    return values_are_close(a.x, b.x, epsilon) && values_are_close(a.y, b.y, epsilon) && values_are_close(a.z, b.z, epsilon);
}
// Extremes of a scalar type. Integers are derived from the bit width, so any integer
// type works; for floats, min_of_type is the smallest positive normal value.
max_of_type :: ($T: Type) -> T {
    #if T == float32 return Math.FLOAT32_MAX;
    else #if T == float64 return Math.FLOAT64_MAX;
    else #if T == bool return true;
    else {
        #assert type_info(T).type == .INTEGER "max_of_type only knows bool, integer and float types.";
        // All value bits set: every bit for unsigned types, all but the sign bit otherwise.
        top_bit := (cast(u64) 1) << (value_bits(T) - 1);
        return cast,no_check(T) (top_bit | (top_bit - 1));
    }
}
min_of_type :: ($T: Type) -> T {
    #if T == float32 return Math.FLOAT32_MIN;
    else #if T == float64 return Math.FLOAT64_MIN;
    else #if T == bool return false;
    else {
        #assert type_info(T).type == .INTEGER "min_of_type only knows bool, integer and float types.";
        if value_bits(T) == size_of(T) * 8 return 0;
        // Two's complement minimum: only the sign bit set.
        return cast,no_check(T) ((cast(u64) 1) << value_bits(T));
    }
}

#scope_file
// Bits that carry magnitude: the full width when unsigned, one fewer when signed.
value_bits :: ($T: Type) -> s64 {
    width := size_of(T) * 8;
    if cast,no_check(T) -1 < 0 return width - 1;
    return width;
}
#scope_export
