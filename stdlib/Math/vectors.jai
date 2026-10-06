// Row-independent Euclidean vectors with overlapping public views.
Vector2 :: struct {
    x, y: float;
    #place x;
    component: [2] float = ---;
}
Vector3 :: struct {
    x, y, z: float;
    #place x;
    xy: Vector2 = ---;
    #place y;
    yz: Vector2 = ---;
    #place x;
    component: [3] float = ---;
}
Vector4 :: struct {
    x, y, z, w: float;
    #place x;
    xy: Vector2 = ---;
    #place y;
    yz: Vector2 = ---;
    #place z;
    zw: Vector2 = ---;
    #place x;
    xyz: Vector3 = ---;
    #place y;
    yzw: Vector3 = ---;
    #place x;
    component: [4] float = ---;
}
Quaternion :: struct {
    x, y, z: float;
    w := 1.0;
    #place x;
    component: [4] float = ---;
    #place x;
    xyz: Vector3 = ---;
}
Complex :: #type,isa Vector2;
AnyVector2 :: struct {
    x, y: float;
}
operator * :: (a: Complex, b: Complex) -> Complex {
    return .{ a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y };
}
dot :: dot_product;
cross :: cross_product;
rgb :: xyz;
rgba :: xyzw;
xy :: (x: float, y: float) -> Vector2 {
    return .{ x, y };
}
xy :: (x: float) -> Vector2 {
    return .{ x, x };
}
make_vector2 :: (x: float) -> Vector2 {
    return xy(x);
}
dot_product :: (a: Vector2, b: Vector2) -> float {
    return a.x * b.x + a.y * b.y;
}
operator + :: (a: Vector2, b: Vector2) -> Vector2 {
    return .{ a.x + b.x, a.y + b.y };
}
operator - :: (a: Vector2, b: Vector2) -> Vector2 {
    return .{ a.x - b.x, a.y - b.y };
}
operator * :: (a: Vector2, b: Vector2) -> Vector2 {
    return .{ a.x * b.x, a.y * b.y };
}
operator / :: (a: Vector2, b: Vector2) -> Vector2 {
    return .{ a.x / b.x, a.y / b.y };
}
operator - :: (a: Vector2) -> Vector2 {
    return .{ -a.x, -a.y };
}
operator * :: (a: Vector2, k: float) -> Vector2 #symmetric {
    return .{ a.x * k, a.y * k };
}
operator / :: (a: Vector2, k: float) -> Vector2 {
    return .{ a.x / k, a.y / k };
}
operator / :: (k: float, a: Vector2) -> Vector2 {
    return .{ k / a.x, k / a.y };
}
operator == :: (a: Vector2, b: Vector2) -> bool {
    return a.x == b.x && a.y == b.y;
}
min :: (v1: Vector2, v2: Vector2) -> Vector2 {
    return .{ Basic.min(v1.x, v2.x), Basic.min(v1.y, v2.y) };
}
max :: (v1: Vector2, v2: Vector2) -> Vector2 {
    return .{ Basic.max(v1.x, v2.x), Basic.max(v1.y, v2.y) };
}
abs :: (v: Vector2) -> Vector2 {
    return .{ abs(v.x), abs(v.y) };
}
saturate :: (a: Vector2) -> Vector2 {
    return .{ saturate(a.x), saturate(a.y) };
}
length_squared :: (a: Vector2) -> float {
    return dot(a, a);
}
length :: (a: Vector2) -> float {
    return sqrt(length_squared(a));
}
distance_squared :: (a: Vector2, b: Vector2) -> float {
    return length_squared(a - b);
}
distance :: (a: Vector2, b: Vector2) -> float {
    return length(a - b);
}
lerp :: (a: Vector2, b: Vector2, t: float) -> Vector2 {
    return a + (b - a) * t;
}
multiply :: (v: Vector2, f: float) -> Vector2 {
    return v * f;
}
xyz :: (x: float, y: float, z: float) -> Vector3 {
    return .{ x, y, z };
}
xyz :: (x: float) -> Vector3 {
    return .{ x, x, x };
}
make_vector3 :: (x: float) -> Vector3 {
    return xyz(x);
}
dot_product :: (a: Vector3, b: Vector3) -> float {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}
operator + :: (a: Vector3, b: Vector3) -> Vector3 {
    return .{ a.x + b.x, a.y + b.y, a.z + b.z };
}
operator - :: (a: Vector3, b: Vector3) -> Vector3 {
    return .{ a.x - b.x, a.y - b.y, a.z - b.z };
}
operator * :: (a: Vector3, b: Vector3) -> Vector3 {
    return .{ a.x * b.x, a.y * b.y, a.z * b.z };
}
operator / :: (a: Vector3, b: Vector3) -> Vector3 {
    return .{ a.x / b.x, a.y / b.y, a.z / b.z };
}
operator - :: (a: Vector3) -> Vector3 {
    return .{ -a.x, -a.y, -a.z };
}
operator * :: (a: Vector3, k: float) -> Vector3 #symmetric {
    return .{ a.x * k, a.y * k, a.z * k };
}
operator / :: (a: Vector3, k: float) -> Vector3 {
    return .{ a.x / k, a.y / k, a.z / k };
}
operator / :: (k: float, a: Vector3) -> Vector3 {
    return .{ k / a.x, k / a.y, k / a.z };
}
operator == :: (a: Vector3, b: Vector3) -> bool {
    return a.x == b.x && a.y == b.y && a.z == b.z;
}
min :: (v1: Vector3, v2: Vector3) -> Vector3 {
    return .{ Basic.min(v1.x, v2.x), Basic.min(v1.y, v2.y), Basic.min(v1.z, v2.z) };
}
max :: (v1: Vector3, v2: Vector3) -> Vector3 {
    return .{ Basic.max(v1.x, v2.x), Basic.max(v1.y, v2.y), Basic.max(v1.z, v2.z) };
}
abs :: (v: Vector3) -> Vector3 {
    return .{ abs(v.x), abs(v.y), abs(v.z) };
}
saturate :: (a: Vector3) -> Vector3 {
    return .{ saturate(a.x), saturate(a.y), saturate(a.z) };
}
length_squared :: (a: Vector3) -> float {
    return dot(a, a);
}
length :: (a: Vector3) -> float {
    return sqrt(length_squared(a));
}
distance_squared :: (a: Vector3, b: Vector3) -> float {
    return length_squared(a - b);
}
distance :: (a: Vector3, b: Vector3) -> float {
    return length(a - b);
}
lerp :: (a: Vector3, b: Vector3, t: float) -> Vector3 {
    return a + (b - a) * t;
}
multiply :: (v: Vector3, f: float) -> Vector3 {
    return v * f;
}
xyzw :: (x: float, y: float, z: float, w: float) -> Vector4 {
    return .{ x, y, z, w };
}
xyzw :: (x: float) -> Vector4 {
    return .{ x, x, x, x };
}
make_vector4 :: (x: float) -> Vector4 {
    return xyzw(x);
}
dot_product :: (a: Vector4, b: Vector4) -> float {
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
}
operator + :: (a: Vector4, b: Vector4) -> Vector4 {
    return .{ a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w };
}
operator - :: (a: Vector4, b: Vector4) -> Vector4 {
    return .{ a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w };
}
operator * :: (a: Vector4, b: Vector4) -> Vector4 {
    return .{ a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w };
}
operator / :: (a: Vector4, b: Vector4) -> Vector4 {
    return .{ a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w };
}
operator - :: (a: Vector4) -> Vector4 {
    return .{ -a.x, -a.y, -a.z, -a.w };
}
operator * :: (a: Vector4, k: float) -> Vector4 #symmetric {
    return .{ a.x * k, a.y * k, a.z * k, a.w * k };
}
operator / :: (a: Vector4, k: float) -> Vector4 {
    return .{ a.x / k, a.y / k, a.z / k, a.w / k };
}
operator / :: (k: float, a: Vector4) -> Vector4 {
    return .{ k / a.x, k / a.y, k / a.z, k / a.w };
}
operator == :: (a: Vector4, b: Vector4) -> bool {
    return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w;
}
min :: (v1: Vector4, v2: Vector4) -> Vector4 {
    return .{ Basic.min(v1.x, v2.x), Basic.min(v1.y, v2.y), Basic.min(v1.z, v2.z), Basic.min(v1.w, v2.w) };
}
max :: (v1: Vector4, v2: Vector4) -> Vector4 {
    return .{ Basic.max(v1.x, v2.x), Basic.max(v1.y, v2.y), Basic.max(v1.z, v2.z), Basic.max(v1.w, v2.w) };
}
abs :: (v: Vector4) -> Vector4 {
    return .{ abs(v.x), abs(v.y), abs(v.z), abs(v.w) };
}
saturate :: (a: Vector4) -> Vector4 {
    return .{ saturate(a.x), saturate(a.y), saturate(a.z), saturate(a.w) };
}
length_squared :: (a: Vector4) -> float {
    return dot(a, a);
}
length :: (a: Vector4) -> float {
    return sqrt(length_squared(a));
}
distance_squared :: (a: Vector4, b: Vector4) -> float {
    return length_squared(a - b);
}
distance :: (a: Vector4, b: Vector4) -> float {
    return length(a - b);
}
lerp :: (a: Vector4, b: Vector4, t: float) -> Vector4 {
    return a + (b - a) * t;
}
operator * :: (a: Vector3, k: float64) -> Vector3 #symmetric {
    return a * cast(float) k;
}
xyz :: (c: [3] float) -> Vector3 {
    return .{ c[0], c[1], c[2] };
}
make_vector3 :: (c: [3] float) -> Vector3 {
    return xyz(c);
}
xyz :: (using v: Vector2, z: float) -> Vector3 {
    return .{ x, y, z };
}
make_vector3 :: (using v: Vector2, z: float) -> Vector3 {
    return xyz(v, z);
}
xyzw :: (using v: Vector2, z: float, w: float) -> Vector4 {
    return .{ x, y, z, w };
}
xyzw :: (using v: Vector3, w: float) -> Vector4 {
    return .{ x, y, z, w };
}
make_vector4 :: (using v: Vector2, z: float, w: float) -> Vector4 {
    return xyzw(v, z, w);
}
make_vector4 :: (using v: Vector3, w: float) -> Vector4 {
    return xyzw(v, w);
}
lerp :: (a: float, b: float, t: float) -> float {
    return (1 - t) * a + t * b;
}
lerp :: (a: float64, b: float64, t: float64) -> float64 {
    return (1 - t) * a + t * b;
}
lerp :: (a: $R, b: R, t: float) -> R {
    return cast(R) ((1 - t) * cast(float64) a + t * cast(float64) b);
}
normalize :: (v: *$T/MyVectors, epsilon := 0.0, fallback := T.{}) -> float {
    original_length := length(v.*);
    if original_length <= epsilon || !is_finite(original_length) {
        v.* = fallback;
        return original_length;
    }
    for i: 0..v.component.count - 1 v.component[i] /= original_length;
    return original_length;
}
normalize :: (v: $T/MyVectors, epsilon := 0.0, fallback := T.{}) -> T {
    result := v;
    normalize(*result, epsilon, fallback);
    return result;
}
unit_vector :: (v: Vector2) -> Vector2 {
    return normalize(v);
}
unit_vector :: (v: Vector3) -> Vector3 {
    return normalize(v);
}
rotate :: (v: Vector2, theta: float) -> Vector2 {
    cosine := cos(theta);
    sine := sin(theta);
    return .{ cosine * v.x - sine * v.y, sine * v.x + cosine * v.y };
}
rotate :: (v: *Vector2, theta: float) {
    v.* = rotate(v.*, theta);
}
cross_product :: (a: Vector3, b: Vector3) -> Vector3 {
    return .{ a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x };
}
dot_product :: (a: Quaternion, b: Quaternion) -> float {
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
}
length_squared :: (a: Quaternion) -> float {
    return dot(a, a);
}
length :: (a: Quaternion) -> float {
    return sqrt(length_squared(a));
}
operator + :: (a: Quaternion, b: Quaternion) -> Quaternion {
    return .{ a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w };
}
operator - :: (a: Quaternion, b: Quaternion) -> Quaternion {
    return .{ a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w };
}
operator - :: (using a: Quaternion) -> Quaternion {
    return .{ -x, -y, -z, -w };
}
operator * :: (a: Quaternion, k: float) -> Quaternion #symmetric {
    return .{ a.x * k, a.y * k, a.z * k, a.w * k };
}
operator == :: (a: Quaternion, b: Quaternion) -> bool {
    return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w;
}
operator * :: (m: Quaternion, a: Quaternion) -> Quaternion {
    vector := m.xyz * a.w + a.xyz * m.w + cross(m.xyz, a.xyz);
    return .{ vector.x, vector.y, vector.z, m.w * a.w - dot(m.xyz, a.xyz) };
}
conjugate :: (using q: Quaternion) -> Quaternion {
    return .{ -x, -y, -z, w };
}
normalize_or_identity :: (using q: *Quaternion) -> float {
    return normalize(q, 0.0, Quaternion_Identity);
}
lerp :: (a: Quaternion, b: Quaternion, t: float) -> Quaternion {
    target := b;
    if dot(a, b) < 0 target = -target;
    return a + (target - a) * t;
}
nlerp :: (p0: Quaternion, p1: Quaternion, fraction: float) -> Quaternion {
    return normalize(lerp(p0, p1, fraction));
}
slerp :: (start: Quaternion, end: Quaternion, t: float) -> Quaternion {
    a := start;
    b := end;
    target := b;
    cosine := dot(a, b);
    if cosine < 0 {
        target = -target;
        cosine = -cosine;
    }
    if cosine >= 0.9995 return nlerp(a, target, t);
    angle := acos(Basic.clamp(cosine, -1.0, 1.0));
    inverse_sine := 1 / sin(angle);
    return a * (sin((1 - t) * angle) * inverse_sine) + target * (sin(t * angle) * inverse_sine);
}
set_from_axis_and_angle :: (using q: *Quaternion, axis: Vector3, angle: float) {
    normalized_axis := normalize(axis);
    vector := normalized_axis * sin(angle * 0.5);
    q.* = .{ vector.x, vector.y, vector.z, cos(angle * 0.5) };
}
set_from_axis_and_angle :: (q: *Quaternion, x: float, y: float, z: float, theta: float) {
    set_from_axis_and_angle(q, xyz(x, y, z), theta);
}
get_axis_and_angle :: (using q: Quaternion) -> x: float64, y: float64, z: float64, theta: float64 {
    normalized := normalize(q);
    cosine := Basic.clamp(cast(float64) normalized.w, -1.0, 1.0);
    sine := sqrt(1 - cosine * cosine);
    if sine < 1e-12 return 1, 0, 0, 0;
    return normalized.x / sine, normalized.y / sine, normalized.z / sine, 2 * acos(cosine);
}
rotate :: (v: Vector3, q: Quaternion) -> Vector3 {
    rotated := q * Quaternion.{ v.x, v.y, v.z, 0 } * conjugate(q);
    return rotated.xyz;
}
rotate :: (v: *Vector3, q: Quaternion) {
    v.* = rotate(v.*, q);
}
make_an_orthonormal_basis :: (x_axis: Vector3) -> (y_axis: Vector3, z_axis: Vector3) {
    auxiliary := xyz(0, 0, 1);
    if abs(x_axis.z) > 0.75 auxiliary = xyz(0, 1, 0);
    return make_an_orthonormal_basis(x_axis, auxiliary);
}
make_an_orthonormal_basis :: (x_axis: Vector3, approximate_axis: Vector3) -> (y_axis: Vector3, z_axis: Vector3) {
    x := normalize(x_axis, fallback = .{ x = 1 });
    y := cross(approximate_axis, x);
    if length_squared(y) == 0 {
        auxiliary := xyz(0, 1, 0);
        if abs(x.y) > 0.75 auxiliary = xyz(0, 0, 1);
        y = cross(auxiliary, x);
    }
    y = normalize(y);
    return y, normalize(cross(x, y));
}
