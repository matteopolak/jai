#import "Float16";
#import "Math";
aggregate_cases :: () -> bool {
    v := vector3_float16(make_vector3(1, -2, 0.5));
    back := vector3_float32(v);
    if back != make_vector3(1, -2, 0.5) return false;
    m := Matrix3_Identity;
    m._12 = 0.5;
    m._23 = -2;
    half := matrix3_float16(m);
    if size_of(Matrix3_Float16) != 18 || cast(u16) half.floats[1] != cast(u16) float32_to_float16(0.5) return false;
    restored := matrix3_float32(half);
    if restored != m return false;
    return true;
}
#assert #run aggregate_cases();
