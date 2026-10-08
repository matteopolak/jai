# Math, random numbers and color/float helpers

## What it is

`Math` (scalars, vectors, matrices, quaternions, planes, projection helpers), two random-number modules (`Random`, `PCG`), and small numeric helpers: `Sloppy_Math` (approximate comparisons), `Srgb` (transfer functions), `Float16` (IEEE binary16 conversion).

## How it works

`stdlib/Math/module.jai` loads `scalar.jai`, `vectors.jai`, `matrix.jai`, `plane.jai`, `print.jai` and `constants.jai`.

Types: `Vector2/3/4`, `Matrix2/3/4/4x3`, `Quaternion` (`Quaternion_Identity` is `.{w=1}`), `Plane3`, and `AnyVector2`/`AnyMatrix*` shape helpers. Scalar functions include `sqrt`, `sin`/`cos`/`tan`, `atan2`, `pow`, `floor`/`ceil`/`round`, `clamp`, `lerp`, `abs`, `min`/`max`, `isnan`/`isinf`, bit casts (`float32_bits`) and `frexp`/`ldexp`. Vector and matrix helpers include `dot_product`, `cross_product`, `length`, `normalize`, `inverse`, `transpose`, `determinant`, `rotation_matrix`, `make_look_at_matrix`, `make_projection_matrix`, `orthographic_projection_matrix`, `slerp`/`nlerp`, `transform_point`.

`print.jai` provides `math_struct_printer` and `print_matrix`. `Basic` calls `context.print_style.struct_printer` first for every struct, so assigning `math_struct_printer` there prints vectors as `(x, y, z)` and matrices as rows.

Matrices declare their elements first (`_11, _12, ...`, row-major) and expose `v`, `coef` and `floats` as `#place _11` views, so positional literals such as `Matrix2.{c, -s, s, c}` fill the elements. They also have `Row_Type`, `Column_Type` and the `IsMatrixFromMathModule` marker. `Complex` is a `Vector2` type with complex multiplication; `PI` and `TAU` are `float32`, `PI64`/`TAU64` are `float64`. The module imports `Basic` privately (`#scope_module`), so `Math` does not export a `Basic` name.

`Random` is an explicit-state 128-bit multiplicative generator. `Random_State` has `low`/`high` words; `random_get(*state)` returns the high word as `u64`. The float32 draws take the low 24 bits of a draw: `random_get_zero_to_one` divides them by `2^24 - 1` (so 1 is possible), `random_get_zero_to_one_open` by `2^24`, and `random_get_within_range(min, max)` is `min + (max - min) * fraction`. The unqualified forms (`random_seed`, `random_get`, `random_get_zero_to_one`, `random_get_within_range`) use `context.random_state`. `PCG` is the separate PCG XSH-RR 64/32 generator with a module-global state: `random_get() -> u32`, `random_get_within_bound(bound)` (unbiased), `random_get_zero_to_one`, `random_seed`. Import only one of them unqualified, since the names collide.

`Srgb` has `srgb_to_linear`/`linear_to_srgb` for scalars and `Vector3`, plus `_fast` variants. `Float16` converts with round-to-nearest-even (`float_to_half_fast3`, `half_to_float_fast4`). `Sloppy_Math` provides `is_approximately_zero` and friends with `DEFAULT_EPSILON :: 0.0001`.

```jai
#import "Basic";
#import "Math";

main :: () {
    v := Vector3.{3, 4, 0};
    print("% %\n", length(v), sqrt(2.0));   // 5 1.414214
}
```

## How to change it

- Keep struct layouts (`Vector3` is three floats, `Matrix4` is row-major with `coef[4][4]`) stable; shader and renderer code depends on them.
- Add a scalar function to `scalar.jai`, vector forms to `vectors.jai`. Prefer `#must` on pure functions as the existing ones do.
- Tests live next to the code (`stdlib/Math/tests`, `Random/tests`, `PCG/tests`, `Float16/tests`, `Srgb/tests`, `Sloppy_Math/tests`, run by the sweep's `modules` set), plus `tests/stdlib/math-vector-views.jai`.

## Configuration

None. `Random` state lives in `context.random_state`; `PCG` state is a module global (`pcg32_state`).

## Dependencies

`Basic` for printing and asserts; `Srgb` and `Float16` import `Math`. The scalar functions are implemented in Jai (float64 bodies with float32 wrappers), not through libm.
