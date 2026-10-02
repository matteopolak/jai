// Public numeric contracts; algorithms are authored in the loaded files.
#load "scalar.jai";
#load "vectors.jai";
#load "matrix.jai";
#load "plane.jai";
#load "constants.jai";
Clamp :: (pointer: *$T, low: T, high: T) { pointer.* = clamp(pointer.*, low, high); }
saturate :: (f: float) -> float { return clamp(f, 0.0, 1.0); }
saturate :: (f: float64) -> float64 { return clamp(f, 0.0, 1.0); }
square :: (a: $T) -> T { return a * a; }
Swap :: (a: *$T, b: *T) { temporary:=a.*; a.*=b.*; b.*=temporary; }
Min :: min;
Max :: max;
min :: (a: $T, b: T) -> T { if a<b return a; return b; }
min :: (a: $T, b: T, rest: ..T) -> T { result:=min(a,b); for value: rest result=min(result,value); return result; }
max :: (a: $T, b: T) -> T { if a>b return a; return b; }
max :: (a: $T, b: T, rest: ..T) -> T { result:=max(a,b); for value: rest result=max(result,value); return result; }
clamp :: (value: $T, low: T, high: T) -> T { if value<low return low; if value>high return high; return value; }
make_vector2 :: (x: float, y: float) -> Vector2 { return xy(x,y); }
make_vector3 :: (x: float, y: float, z: float) -> Vector3 { return xyz(x,y,z); }
make_vector4 :: (x: float, y: float, z: float, w: float) -> Vector4 { return xyzw(x,y,z,w); }
Quaternion_Identity :: Quaternion.{w=1};
