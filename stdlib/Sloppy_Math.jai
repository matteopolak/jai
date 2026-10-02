Math :: #import "Math";
DEFAULT_EPSILON :: 0.0001;
is_approximately_zero :: (f: float, epsilon := DEFAULT_EPSILON) -> bool { return Math.abs(f)<=epsilon; }
values_are_close :: (f0: float, f1: float, epsilon := DEFAULT_EPSILON) -> bool { return Math.abs(f0-f1)<=epsilon; }
values_are_close :: (a: Math.Vector2, b: Math.Vector2, epsilon := DEFAULT_EPSILON) -> bool {
    return values_are_close(a.x,b.x,epsilon) && values_are_close(a.y,b.y,epsilon);
}
values_are_close :: (a: Math.Vector3, b: Math.Vector3, epsilon := DEFAULT_EPSILON) -> bool {
    return values_are_close(a.x,b.x,epsilon) && values_are_close(a.y,b.y,epsilon) && values_are_close(a.z,b.z,epsilon);
}
max_of_type :: ($T: Type) -> T {
    #if T==bool return true;
    else #if T==u8 return Math.U8_MAX;
    else #if T==s8 return Math.S8_MAX;
    else #if T==u16 return Math.U16_MAX;
    else #if T==s16 return Math.S16_MAX;
    else #if T==u32 return Math.U32_MAX;
    else #if T==s32 return Math.S32_MAX;
    else #if T==u64 return Math.U64_MAX;
    else #if T==s64 return Math.S64_MAX;
    else #if T==float32 return Math.FLOAT32_MAX;
    else #if T==float64 return Math.FLOAT64_MAX;
    else { #assert false "max_of_type requires a scalar numeric type."; }
}
min_of_type :: ($T: Type) -> T {
    #if T==bool return false;
    else #if T==u8 || T==u16 || T==u32 || T==u64 return 0;
    else #if T==s8 return Math.S8_MIN;
    else #if T==s16 return Math.S16_MIN;
    else #if T==s32 return Math.S32_MIN;
    else #if T==s64 return Math.S64_MIN;
    else #if T==float32 return Math.FLOAT32_MIN;
    else #if T==float64 return Math.FLOAT64_MIN;
    else { #assert false "min_of_type requires a scalar numeric type."; }
}
