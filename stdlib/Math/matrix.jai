// Row-major matrices. Affine Matrix4x3 omits the fixed row [0,0,0,1].
Matrix2 :: struct {
    _11, _12: float;
    _21, _22: float;
    // Views of the same 4 floats (row-major); positional literals fill _11.. above.
    #place _11;
    coef: [2][2] float = ---;
    #place _11;
    v: [2] Vector2 = ---;
    #place _11;
    floats: [4] float = ---;
    Row_Type :: Vector2;
    Column_Type :: Vector2;
    IsMatrixFromMathModule :: true;
}
Matrix2_Identity :: Matrix2.{ _11 = 1, _22 = 1 };
Matrix3 :: struct {
    _11, _12, _13: float;
    _21, _22, _23: float;
    _31, _32, _33: float;
    // Views of the same 9 floats (row-major); positional literals fill _11.. above.
    #place _11;
    coef: [3][3] float = ---;
    #place _11;
    v: [3] Vector3 = ---;
    #place _11;
    floats: [9] float = ---;
    Row_Type :: Vector3;
    Column_Type :: Vector3;
    IsMatrixFromMathModule :: true;
}
Matrix3_Identity :: Matrix3.{ _11 = 1, _22 = 1, _33 = 1 };
Matrix4 :: struct {
    _11, _12, _13, _14: float;
    _21, _22, _23, _24: float;
    _31, _32, _33, _34: float;
    _41, _42, _43, _44: float;
    // Views of the same 16 floats (row-major); positional literals fill _11.. above.
    #place _11;
    coef: [4][4] float = ---;
    #place _11;
    v: [4] Vector4 = ---;
    #place _11;
    floats: [16] float = ---;
    Row_Type :: Vector4;
    Column_Type :: Vector4;
    IsMatrixFromMathModule :: true;
}
Matrix4_Identity :: Matrix4.{ _11 = 1, _22 = 1, _33 = 1, _44 = 1 };
Matrix4x3 :: struct {
    _11, _12, _13, _14: float;
    _21, _22, _23, _24: float;
    _31, _32, _33, _34: float;
    // Views of the same 12 floats (row-major); positional literals fill _11.. above.
    #place _11;
    coef: [3][4] float = ---;
    #place _11;
    v: [3] Vector4 = ---;
    #place _11;
    floats: [12] float = ---;
    Row_Type :: Vector4;
    Column_Type :: Vector3;
    IsMatrixFromMathModule :: true;
}
Matrix4x3_Identity :: Matrix4x3.{ _11 = 1, _22 = 1, _33 = 1 };
AnyMatrix3 :: struct {
    _11, _12, _13: float;
    _21, _22, _23: float;
    _31, _32, _33: float;
}
AnyMatrix4x3 :: struct {
    _11, _12, _13, _14: float;
    _21, _22, _23, _24: float;
    _31, _32, _33, _34: float;
}
AnyMatrix2 :: struct {
    _11, _12: float;
    _21, _22: float;
}
AnyMatrix :: struct {
    IsMatrixFromMathModule :: true;
}
multiply :: (m: Matrix2, v: Vector2) -> Vector2 {
    return .{ m._11 * v.x + m._12 * v.y, m._21 * v.x + m._22 * v.y };
}
operator * :: (m: Matrix2, v: Vector2) -> Vector2 {
    return multiply(m, v);
}
multiply :: (m: Matrix2, n: Matrix2) -> Matrix2 {
    result: Matrix2;
    for r: 0..1 for c : 0..1 for k : 0..1 result.coef[r][c] += m.coef[r][k] * n.coef[k][c];
    return result;
}
operator * :: (a: Matrix2, b: Matrix2) -> Matrix2 {
    return multiply(a, b);
}
operator * :: (m: Matrix3, v: Vector3) -> Vector3 {
    return multiply(m, v);
}
multiply :: (m: Matrix3, n: Matrix3) -> Matrix3 {
    result: Matrix3;
    for r: 0..2 for c : 0..2 for k : 0..2 result.coef[r][c] += m.coef[r][k] * n.coef[k][c];
    return result;
}
operator * :: (a: Matrix3, b: Matrix3) -> Matrix3 {
    return multiply(a, b);
}
multiply :: (m: Matrix4, v: Vector4) -> Vector4 {
    return .{ m._11 * v.x + m._12 * v.y + m._13 * v.z + m._14 * v.w, m._21 * v.x + m._22 * v.y + m._23 * v.z + m._24 * v.w, m._31 * v.x + m._32 * v.y + m._33 * v.z + m._34 * v.w, m._41 * v.x + m._42 * v.y + m._43 * v.z + m._44 * v.w };
}
operator * :: (m: Matrix4, v: Vector4) -> Vector4 {
    return multiply(m, v);
}
multiply :: (m: Matrix4, n: Matrix4) -> Matrix4 {
    result: Matrix4;
    for r: 0..3 for c : 0..3 for k : 0..3 result.coef[r][c] += m.coef[r][k] * n.coef[k][c];
    return result;
}
operator * :: (a: Matrix4, b: Matrix4) -> Matrix4 {
    return multiply(a, b);
}
row :: (m: Matrix4, i: int) -> Vector4 {
    return m.v[i];
}
column :: (m: Matrix4, i: int) -> Vector4 {
    return .{ m.coef[0][i], m.coef[1][i], m.coef[2][i], m.coef[3][i] };
}
multiply :: (m: Matrix4x3, v: Vector4) -> Vector3 {
    return .{ m._11 * v.x + m._12 * v.y + m._13 * v.z + m._14 * v.w, m._21 * v.x + m._22 * v.y + m._23 * v.z + m._24 * v.w, m._31 * v.x + m._32 * v.y + m._33 * v.z + m._34 * v.w };
}
transform_point :: (m: $T/interface AnyMatrix4x3, v: Vector3) -> Vector3 {
    return .{ m._11 * v.x + m._12 * v.y + m._13 * v.z + m._14,
             m._21 * v.x + m._22 * v.y + m._23 * v.z + m._24,
             m._31 * v.x + m._32 * v.y + m._33 * v.z + m._34 };
}
multiply :: (m: $T/interface AnyMatrix3, v: Vector3) -> Vector3 {
    return .{ m._11 * v.x + m._12 * v.y + m._13 * v.z,
             m._21 * v.x + m._22 * v.y + m._23 * v.z,
             m._31 * v.x + m._32 * v.y + m._33 * v.z };
}
transform_vector :: (m: $T/interface AnyMatrix3, v: Vector3) -> Vector3 {
    return multiply(m, v);
}
make_matrix3 :: (m: $T/interface AnyMatrix3) -> Matrix3 #must {
    return .{ _11 = m._11, _12 = m._12, _13 = m._13, _21 = m._21, _22 = m._22, _23 = m._23, _31 = m._31, _32 = m._32, _33 = m._33 };
}
make_matrix4 :: (m: $T/interface AnyMatrix3) -> Matrix4 #must {
    result := Matrix4_Identity;
    result._11 = m._11;
    result._12 = m._12;
    result._13 = m._13;
    result._21 = m._21;
    result._22 = m._22;
    result._23 = m._23;
    result._31 = m._31;
    result._32 = m._32;
    result._33 = m._33;
    #if T == Matrix4 || T == Matrix4x3 {
        result._14 = m._14;
        result._24 = m._24;
        result._34 = m._34;
    }
    #if T == Matrix4 {
        result._41 = m._41;
        result._42 = m._42;
        result._43 = m._43;
        result._44 = m._44;
    }
    return result;
}
make_matrix4 :: (values: ..float) -> Matrix4 #must #deprecated "Use a struct literal instead." {
    result: Matrix4;
    limit := values.count;
    if limit > 16 limit = 16;
    for i: 0..limit - 1 result.coef[i / 4][i % 4] = values[i];
    return result;
}
multiply :: (m: Matrix4, n: Matrix3) -> Matrix4 {
    return multiply(m, make_matrix4(n));
}
multiply :: (m: Matrix4, n: Matrix4x3) -> Matrix4 {
    return multiply(m, make_matrix4(n));
}
multiply :: (m: Matrix4x3, n: Matrix4) -> Matrix4 {
    return multiply(make_matrix4(m), n);
}
multiply :: (m: Matrix4x3, n: Matrix4x3) -> Matrix4x3 {
    combined := multiply(make_matrix4(m), make_matrix4(n));
    return .{ _11 = combined._11, _12 = combined._12, _13 = combined._13, _14 = combined._14, _21 = combined._21, _22 = combined._22, _23 = combined._23, _24 = combined._24, _31 = combined._31, _32 = combined._32, _33 = combined._33, _34 = combined._34 };
}
operator * :: (a: Matrix4, b: Matrix3) -> Matrix4 {
    return multiply(a, b);
}
operator * :: (a: Matrix4, b: Matrix4x3) -> Matrix4 {
    return multiply(a, b);
}
operator * :: (a: Matrix4x3, b: Matrix4) -> Matrix4 {
    return multiply(a, b);
}
operator * :: (a: Matrix4x3, b: Matrix4x3) -> Matrix4x3 {
    return multiply(a, b);
}
operator * :: (a: Matrix2, t: float) -> Matrix2 #symmetric {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] *= t;
    return result;
}
operator + :: (a: Matrix2, b: Matrix2) -> Matrix2 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] += b.coef[r][c];
    return result;
}
operator - :: (a: Matrix2, b: Matrix2) -> Matrix2 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] -= b.coef[r][c];
    return result;
}
operator == :: (a: Matrix2, b: Matrix2) -> bool {
    for r: 0..a.coef.count - 1 for c : 0..a.coef[r].count - 1 if a.coef[r][c] != b.coef[r][c] return false;
    return true;
}
operator * :: (a: Matrix3, t: float) -> Matrix3 #symmetric {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] *= t;
    return result;
}
operator + :: (a: Matrix3, b: Matrix3) -> Matrix3 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] += b.coef[r][c];
    return result;
}
operator - :: (a: Matrix3, b: Matrix3) -> Matrix3 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] -= b.coef[r][c];
    return result;
}
operator == :: (a: Matrix3, b: Matrix3) -> bool {
    for r: 0..a.coef.count - 1 for c : 0..a.coef[r].count - 1 if a.coef[r][c] != b.coef[r][c] return false;
    return true;
}
operator * :: (a: Matrix4, t: float) -> Matrix4 #symmetric {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] *= t;
    return result;
}
operator + :: (a: Matrix4, b: Matrix4) -> Matrix4 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] += b.coef[r][c];
    return result;
}
operator - :: (a: Matrix4, b: Matrix4) -> Matrix4 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] -= b.coef[r][c];
    return result;
}
operator == :: (a: Matrix4, b: Matrix4) -> bool {
    for r: 0..a.coef.count - 1 for c : 0..a.coef[r].count - 1 if a.coef[r][c] != b.coef[r][c] return false;
    return true;
}
operator * :: (a: Matrix4x3, t: float) -> Matrix4x3 #symmetric {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] *= t;
    return result;
}
operator + :: (a: Matrix4x3, b: Matrix4x3) -> Matrix4x3 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] += b.coef[r][c];
    return result;
}
operator - :: (a: Matrix4x3, b: Matrix4x3) -> Matrix4x3 {
    result := a;
    for r: 0..result.coef.count - 1 for c : 0..result.coef[r].count - 1 result.coef[r][c] -= b.coef[r][c];
    return result;
}
operator == :: (a: Matrix4x3, b: Matrix4x3) -> bool {
    for r: 0..a.coef.count - 1 for c : 0..a.coef[r].count - 1 if a.coef[r][c] != b.coef[r][c] return false;
    return true;
}
transpose :: (m: Matrix3) -> Matrix3 #must {
    result: Matrix3;
    for r: 0..2 for c : 0..2 result.coef[r][c] = m.coef[c][r];
    return result;
}
transpose :: (m: *Matrix3) {
    m.* = transpose(m.*);
}
transpose :: (m: Matrix4) -> Matrix4 #must {
    result: Matrix4;
    for r: 0..3 for c : 0..3 result.coef[r][c] = m.coef[c][r];
    return result;
}
transpose :: (m: *Matrix4) {
    m.* = transpose(m.*);
}
make_scale_matrix4 :: (v: Vector3) -> Matrix4 #must {
    return .{ _11 = v.x, _22 = v.y, _33 = v.z, _44 = 1 };
}
scale :: (m: $T/interface AnyMatrix3, s: float) -> T #must {
    result := m;
    scale(*result, s);
    return result;
}
scale :: (m: *$T/interface AnyMatrix3, s: float) {
    scale(m, xyz(s));
}
scale :: (m: $T/interface AnyMatrix3, v: Vector3) -> T #must {
    result := m;
    scale(*result, v);
    return result;
}
scale :: (m: *$T/interface AnyMatrix3, v: Vector3) {
    m._11 *= v.x;
    m._21 *= v.x;
    m._31 *= v.x;
    m._12 *= v.y;
    m._22 *= v.y;
    m._32 *= v.y;
    m._13 *= v.z;
    m._23 *= v.z;
    m._33 *= v.z;
}
make_translation_matrix4 :: (v: Vector3) -> Matrix4 #must {
    result := Matrix4_Identity;
    result._14 = v.x;
    result._24 = v.y;
    result._34 = v.z;
    return result;
}
translate :: (using m: Matrix4, t: Vector3) -> Matrix4 #must {
    result := m;
    translate(*result, t);
    return result;
}
translate :: (using m: *Matrix4, t: Vector3) {
    _14 += t.x;
    _24 += t.y;
    _34 += t.z;
}
rotate :: (m: Matrix3, q: Quaternion) -> Matrix3 #must {
    return m * rotation_matrix(Matrix3, q);
}
rotate :: (m: Matrix4, q: Quaternion) -> Matrix4 #must {
    return m * rotation_matrix(Matrix4, q);
}
// Identity matrix whose upper-left 3x3 block holds the three vectors as rows (or columns).
make_matrix_from_rows :: (xprime: Vector3, yprime: Vector3, zprime: Vector3, $T: Type) -> T #must {
    m := identity_of(T);
    write_basis_block(*m, xprime, yprime, zprime, as_rows = true);
    return m;
}
make_matrix_from_columns :: (xprime: Vector3, yprime: Vector3, zprime: Vector3, $T: Type) -> T #must {
    m := identity_of(T);
    write_basis_block(*m, xprime, yprime, zprime, as_rows = false);
    return m;
}
make_look_at_matrix :: (viewpoint: Vector3, look_at: Vector3, reference_up_vector: Vector3, $x_is_forward := true) -> Matrix4 {
    forward := normalize(look_at - viewpoint, fallback = .{ z = 1 });
    side := normalize(cross(reference_up_vector, forward), fallback = .{ y = 1 });
    up := cross(forward, side);
    result: Matrix4;
    if x_is_forward result = make_matrix_from_rows(forward, side, up);
    else result = make_matrix_from_rows(side, up, -forward);
    transformed := multiply(result, xyzw(viewpoint, 0));
    offset := xyz(-transformed.x, -transformed.y, -transformed.z);
    result._14 = offset.x;
    result._24 = offset.y;
    result._34 = offset.z;
    return result;
}
orthographic_projection_matrix :: (left: float, right: float, bottom: float, top: float, near: float, far: float, depth_range_01 := false) -> Matrix4 {
    width := right - left;
    height := top - bottom;
    depth := far - near;
    result := Matrix4_Identity;
    result._11 = 2 / width;
    result._22 = 2 / height;
    result._14 = -(right + left) / width;
    result._24 = -(top + bottom) / height;
    if depth_range_01 {
        result._33 = -1 / depth;
        result._34 = -near / depth;
    } else {
        result._33 = -2 / depth;
        result._34 = -(far + near) / depth;
    }
    return result;
}
make_frustum_matrix :: (l: float, r: float, b: float, t: float, n: float, f: float, depth_range_01 := false) -> Matrix4 {
    result: Matrix4;
    result._11 = 2 * n / (r - l);
    result._22 = 2 * n / (t - b);
    result._13 = (r + l) / (r - l);
    result._23 = (t + b) / (t - b);
    result._43 = -1;
    if depth_range_01 {
        result._33 = -f / (f - n);
        result._34 = -f * n / (f - n);
    } else {
        result._33 = -(f + n) / (f - n);
        result._34 = -2 * f * n / (f - n);
    }
    return result;
}
make_projection_matrix :: (fov_vertical: float, aspect_ratio_horizontal_over_vertical: float, z_near: float, z_far: float, x_offset := 0.0, y_offset := 0.0, depth_range_01 := false) -> Matrix4 {
    vertical := z_near * tan(fov_vertical * 0.5);
    horizontal := vertical * aspect_ratio_horizontal_over_vertical;
    result := make_frustum_matrix(-horizontal, horizontal, -vertical, vertical, z_near, z_far, depth_range_01);
    result._13 = x_offset;
    result._23 = y_offset;
    return result;
}
lerp :: (a: Matrix3, b: Matrix3, t: float) -> Matrix3 {
    return a * (1 - t) + b * t;
}
identity_of :: ($T: Type) -> T {
    result: T;
    identity(*result);
    return result;
}
identity :: (m: *Matrix2) {
    for r: 0..1 for c : 0..1 {
        m.coef[r][c] = 0;
        if r == c m.coef[r][c] = 1;
    }
}
identity :: (m: *Matrix3) {
    for r: 0..2 for c : 0..2 {
        m.coef[r][c] = 0;
        if r == c m.coef[r][c] = 1;
    }
}
identity :: (m: *Matrix4) {
    for r: 0..3 for c : 0..3 {
        m.coef[r][c] = 0;
        if r == c m.coef[r][c] = 1;
    }
}
identity :: (m: *Matrix4x3) {
    for r: 0..2 for c : 0..3 {
        m.coef[r][c] = 0;
        if r == c m.coef[r][c] = 1;
    }
}
set_rotation :: (using m: *$T/interface AnyMatrix3, q: Quaternion) {
    normalized := normalize(q);
    x := normalized.x;
    y := normalized.y;
    z := normalized.z;
    w := normalized.w;
    _11 = 1 - 2 * (y * y + z * z);
    _12 = 2 * (x * y - z * w);
    _13 = 2 * (x * z + y * w);
    _21 = 2 * (x * y + z * w);
    _22 = 1 - 2 * (x * x + z * z);
    _23 = 2 * (y * z - x * w);
    _31 = 2 * (x * z - y * w);
    _32 = 2 * (y * z + x * w);
    _33 = 1 - 2 * (x * x + y * y);
}
rotation_matrix :: ($T: Type, q: Quaternion) -> T {
    result := identity_of(T);
    set_rotation(*result, q);
    return result;
}
get_rotation :: (using m: $T/interface AnyMatrix3) -> Quaternion {
    trace := _11 + _22 + _33;
    q: Quaternion;
    if trace > 0 {
        divisor := 2 * sqrt(trace + 1);
        q = .{ (_32 - _23) / divisor, (_13 - _31) / divisor, (_21 - _12) / divisor, divisor * 0.25 };
    } else if _11 >= _22 && _11 >= _33 {
        divisor := 2 * sqrt(max(0.0, 1 + _11 - _22 - _33));
        q = .{ divisor * 0.25, (_12 + _21) / divisor, (_13 + _31) / divisor, (_32 - _23) / divisor };
    } else if _22 >= _33 {
        divisor := 2 * sqrt(max(0.0, 1 + _22 - _11 - _33));
        q = .{ (_12 + _21) / divisor, divisor * 0.25, (_23 + _32) / divisor, (_13 - _31) / divisor };
    } else {
        divisor := 2 * sqrt(max(0.0, 1 + _33 - _11 - _22));
        q = .{ (_13 + _31) / divisor, (_23 + _32) / divisor, divisor * 0.25, (_21 - _12) / divisor };
    }
    return normalize(q);
}
// Gauss-Jordan with partial pivoting; calculations use wider working storage.
inverse :: (m: Matrix4) -> Matrix4 #must, bool {
    augmented: [4][8] float64;
    for r: 0..3 {
        for c: 0..3 augmented[r][c] = m.coef[r][c];
        augmented[r][r + 4] = 1;
    }
    for column: 0..3 {
        pivot := column;
        for r: column + 1..3 if abs(augmented[r][column]) > abs(augmented[pivot][column]) pivot = r;
        if augmented[pivot][column] == 0 || !is_finite(augmented[pivot][column]) return Matrix4.{}, false;
        if pivot != column for c: 0..7 {
            temporary := augmented[pivot][c];
            augmented[pivot][c] = augmented[column][c];
            augmented[column][c] = temporary;
        }
        divisor := augmented[column][column];
        for c: 0..7 augmented[column][c] /= divisor;
        for r: 0..3 if r != column {
            factor := augmented[r][column];
            for c: 0..7 augmented[r][c] -= factor * augmented[column][c];
        }
    }
    result: Matrix4;
    for r: 0..3 for c : 0..3 result.coef[r][c] = cast(float) augmented[r][c + 4];
    return result, true;
}
inverse_gaussian_elimination :: (m: Matrix4) -> Matrix4 #must {
    result, success := inverse(m);
    return result;
}
inverse_lengyel :: (m: Matrix4, epsilon := 0.0001) -> Matrix4 #must, bool {
    if abs(determinant(m)) <= epsilon return Matrix4.{}, false;
    result, success := inverse(m);
    return result, success;
}
minor3 :: (m: Matrix4, excluded_row: int, excluded_column: int) -> Matrix3 {
    result: Matrix3;
    target_row := 0;
    for r: 0..3 if r != excluded_row {
        target_column := 0;
        for c: 0..3 if c != excluded_column {
            result.coef[target_row][target_column] = m.coef[r][c];
            target_column += 1;
        }
        target_row += 1;
    }
    return result;
}
determinant3 :: (m: Matrix3) -> float {
    return dot(m.v[0], cross(m.v[1], m.v[2]));
}
determinant :: (m: Matrix4) -> float #must {
    result := 0.0;
    for c: 0..3 {
        term := m.coef[0][c] * determinant3(minor3(m, 0, c));
        if (c & 1) != 0 term = -term;
        result += term;
    }
    return result;
}
adjugate_lengyel :: (m: Matrix4) -> Matrix4 #must {
    result: Matrix4;
    for r: 0..3 for c : 0..3 {
        result.coef[c][r] = determinant3(minor3(m, r, c));
        if ((r + c) & 1) != 0 result.coef[c][r] = -result.coef[c][r];
    }
    return result;
}
adjugate :: adjugate_lengyel;
adjoint_transpose :: (m: Matrix3) -> Matrix3 {
    first := cross(m.v[1], m.v[2]);
    second := cross(m.v[2], m.v[0]);
    third := cross(m.v[0], m.v[1]);
    return .{ _11 = first.x, _12 = first.y, _13 = first.z, _21 = second.x, _22 = second.y, _23 = second.z, _31 = third.x, _32 = third.y, _33 = third.z };
}
inverse :: (a: Matrix3, epsilon := 0.001) -> Matrix3 {
    determinant_value := determinant3(a);
    if abs(determinant_value) <= epsilon return Matrix3_Identity;
    return transpose(adjoint_transpose(a)) * (1 / determinant_value);
}
isometry_inverse :: (m: Matrix4) -> Matrix4 #must {
    result := Matrix4_Identity;
    result._11 = m._11;
    result._12 = m._21;
    result._13 = m._31;
    result._21 = m._12;
    result._22 = m._22;
    result._23 = m._32;
    result._31 = m._13;
    result._32 = m._23;
    result._33 = m._33;
    result._14 = -(result._11 * m._14 + result._12 * m._24 + result._13 * m._34);
    result._24 = -(result._21 * m._14 + result._22 * m._24 + result._23 * m._34);
    result._34 = -(result._31 * m._14 + result._32 * m._24 + result._33 * m._34);
    return result;
}
mat_norm :: (M: Matrix3, tpose: bool) -> float {
    largest := 0.0;
    for r: 0..2 {
        total := 0.0;
        for c: 0..2 {
            if tpose total += abs(M.coef[c][r]);
            else total += abs(M.coef[r][c]);
        }
        largest = max(largest, total);
    }
    return largest;
}
norm_inf :: (M: Matrix3) -> float {
    return mat_norm(M, false);
}
norm_one :: (M: Matrix3) -> float {
    return mat_norm(M, true);
}
make_reflector :: (v: Vector3) -> (u: Vector3) {
    result := v;
    if v.x >= 0 result.x += length(v);
    else result.x -= length(v);
    return normalize(result);
}
reflect_cols :: (M: *Matrix3, u: Vector3) {
    components := float.[u.x, u.y, u.z];
    for c: 0..2 {
        projection := 0.0;
        for r: 0..2 projection += components[r] * M.coef[r][c];
        for r: 0..2 M.coef[r][c] -= 2 * projection * components[r];
    }
}
reflect_rows :: (M: *Matrix3, u: Vector3) {
    for r: 0..2 M.v[r] = M.v[r] - u * (2 * dot(M.v[r], u));
}
polar_decomp :: (M: Matrix3) -> (Q: Matrix3, S: Matrix3, det: float) {
    orthogonal := M;
    determinant_value := determinant3(M);
    if determinant_value == 0 {
        first := normalize(M.v[0], fallback = .{ x = 1 });
        second, third := make_an_orthonormal_basis(first, M.v[1]);
        orthogonal.v[0] = first;
        orthogonal.v[1] = second;
        orthogonal.v[2] = third;
    } else {
        for 0..31 {
            next := (orthogonal + transpose(inverse(orthogonal, 0.0))) * 0.5;
            change := norm_inf(next - orthogonal);
            orthogonal = next;
            if change <= 0.000001 break;
        }
    }
    symmetric := transpose(orthogonal) * M;
    symmetric = (symmetric + transpose(symmetric)) * 0.5;
    return orthogonal, symmetric, determinant_value;
}
make_matrix_from_rows :: (xprime: Vector3, yprime: Vector3, zprime: Vector3) -> Matrix4 #must {
    return make_matrix_from_rows(xprime, yprime, zprime, Matrix4);
}
make_matrix_from_columns :: (xprime: Vector3, yprime: Vector3, zprime: Vector3) -> Matrix4 #must {
    return make_matrix_from_columns(xprime, yprime, zprime, Matrix4);
}

#scope_file
write_basis_block :: (m: *$T, a: Vector3, b: Vector3, c: Vector3, as_rows: bool) {
    basis: [3] Vector3 = ---;
    basis[0], basis[1], basis[2] = a, b, c;
    for i: 0..2 for j : 0..2 {
        if as_rows m.coef[i][j] = basis[i].component[j];
        else m.coef[j][i] = basis[i].component[j];
    }
}
