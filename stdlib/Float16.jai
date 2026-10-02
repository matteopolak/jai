// IEEE binary16 conversion, round to nearest with ties to even.
#import "Math";
#load "Float16/conversion.jai";
Vector3_Float16 :: struct { x, y, z: Float16; }
Matrix3_Float16 :: struct {
    union {
        struct {
            _11,_12,_13: Float16;
            _21,_22,_23: Float16;
            _31,_32,_33: Float16;
        }
        floats: [9] Float16;
    }
}
vector3_float32 :: (v: Vector3_Float16) -> Vector3 { return xyz(float16_to_float32(v.x),float16_to_float32(v.y),float16_to_float32(v.z)); }
vector3_float16 :: (v: Vector3) -> Vector3_Float16 { return .{float32_to_float16(v.x),float32_to_float16(v.y),float32_to_float16(v.z)}; }
matrix3_float32 :: (s: Matrix3_Float16) -> Matrix3 {
    result: Matrix3;
    for i: 0..8 result.coef[i/3][i%3]=float16_to_float32(s.floats[i]);
    return result;
}
matrix3_float16 :: (s: Matrix3) -> Matrix3_Float16 {
    result: Matrix3_Float16;
    for i: 0..8 result.floats[i]=float32_to_float16(s.coef[i/3][i%3]);
    return result;
}
