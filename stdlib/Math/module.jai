// Public numeric contracts; algorithms are authored in the loaded files.
#scope_module;
Basic :: #import "Basic";
#scope_export;
#load "scalar.jai";
#load "vectors.jai";
#load "matrix.jai";
#load "plane.jai";
#load "print.jai";
#load "constants.jai";
Clamp :: (pointer: *$T, low: T, high: T) { pointer.* = Basic.clamp(pointer.*, low, high); }
saturate :: (f: float) -> float { return Basic.clamp(f, 0.0, 1.0); }
saturate :: (f: float64) -> float64 { return Basic.clamp(f, 0.0, 1.0); }
square :: (a: $T) -> T { return a * a; }
Swap :: Basic.Swap;
Min :: Basic.min;
Max :: Basic.max;
MyVectors :: Type.[Vector2, Vector3, Vector4, Quaternion];
min :: (a: $T, b: T) -> T { return Basic.min(a,b); }
min :: (a: $T, b: T, rest: ..T) -> T { result:=Basic.min(a,b); for value: rest result=Basic.min(result,value); return result; }
max :: (a: $T, b: T) -> T { return Basic.max(a,b); }
max :: (a: $T, b: T, rest: ..T) -> T { result:=Basic.max(a,b); for value: rest result=Basic.max(result,value); return result; }
clamp :: (value: $T, low: T, high: T) -> T { return Basic.clamp(value,low,high); }
make_vector2 :: (x: float, y: float) -> Vector2 { return xy(x,y); }
make_vector3 :: (x: float, y: float, z: float) -> Vector3 { return xyz(x,y,z); }
make_vector4 :: (x: float, y: float, z: float, w: float) -> Vector4 { return xyzw(x,y,z,w); }
Quaternion_Identity :: Quaternion.{w=1};
