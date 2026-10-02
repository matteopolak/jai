# Math and numeric modules

## What it is

`stdlib/Math` provides independently authored scalar mathematics, vector/quaternion arithmetic, row-major matrices, and planes. `Float16`, `Srgb`, `Sloppy_Math`, `Random`, `PCG`, `Machine_X64`, and the geometry portion of both GetRect modules build on these source APIs.

The maintained OpenJai public contract is the default where available: `Math.PI`/`TAU` retain their full literals, `Quaternion.w` defaults to zero, vectors store plain float32 coordinates, vector constructors accept each coordinate, and `GetRect.Rect` stores four float64 fields. Named parameters follow the maintained contract (`value`, `base`/`exponent`, and `axis`/`angle`). `Quaternion_Identity` explicitly supplies `{w=1}`; `PI32`/`TAU32` provide single-precision constants. Authored historical overlays and printer integration are isolated under `stdlib/legacy/Math`; that version remains blocked by the frozen compiler's `#place` parser and is not a fully verified historical replacement.

## How it works

Scalar math stays in Jai. `floor` masks fractional IEEE bits; `frexp` handles subnormals by scaling before extracting exponent bits; `ldexp` scales in bounded exponent chunks. `sqrt` normalizes the input and uses Newton iteration. `log` uses the odd-power series after significand normalization, `exp` reduces by log(2), and trigonometric functions use reduction and convergent series. Float32 overloads call float64 calculations and round on return. Choose explicitly typed float64 arguments when testing the double overloads.

NaNs and infinities are classified from IEEE bits. Domain violations produce NaN; `log(0)` produces negative infinity; `sqrt` and `sin` preserve signed zero. `round` rounds halfway cases away from zero. `fmod_cycling` follows the divisor's sign, and division by zero returns infinity. The transcendental functions are software approximations: ordinary finite input goldens are tested, but they have no certified ULP bound or correctly-rounded guarantee. Large-angle reduction uses the stored floating value of tau, so its accuracy decreases at very large magnitudes. Matrix inverse uses partial-pivot Gauss–Jordan elimination; singular Matrix4 returns `(zero_matrix, false)`. Singular Matrix3 returns identity. Polar decomposition uses iterative orthogonalization; rank-deficient inputs obtain a constructed orthonormal basis.

Default vectors and quaternions have separate coordinate fields. Matrix unions expose maintained named coefficients, `coef`, and `v` views over the same storage. Matrix4x3 has three rows of four coefficients and an implied final `[0,0,0,1]` row. Modern Math owns its min/max/clamp helpers and has no Basic import. Legacy vector aliases (`xy`, `yz`, `xyz`, `component`) use historical `#place` declarations. Its printers recognize known declared matrix/vector types and use Basic's string builder; arbitrary user matrix types are not dynamically recognized. Several historical generic/interface entry points remain unverified even where modern concrete matrix operations have passed behavior checks.

Float16 conversion preserves signed zero and infinities, propagates NaN payload bits while quieting NaNs on conversion to half, and rounds to nearest with ties to even. Half subnormals are normalized explicitly. The vector/matrix wrappers use the same scalar conversion bodies. `Matrix3_Float16` uses an actual union for the nine named fields and `floats` array; it keeps the public overlapping layout without `#place`. sRGB uses the transfer equation and preserves Vector4 alpha. The `*_fast` entry points calculate the same transfer equation; `*_pow2` and `*_sqrt` expose their stated approximate transfer curves.

Random's serialized `low`/`high` state advances by the documented 128-bit multiplicative factor, computed with an independently authored base-65536 schoolbook product. A scalar seed sets `low=1, high=seed`; aggregate seeding ensures an odd low word. Its context convenience forms delegate to explicit-state procedures, but the frozen compiler cannot yet evaluate the exact aggregate context initializer. Closed interval functions include one, and open interval functions exclude one. PCG implements the XSH-RR output permutation with modulo-2^64 state advance and rejection sampling for unbiased bounds. Explicit-state functions avoid shared default state; PCG's convenience forms use a module-global state. A PCG bound must be positive: zero executes Jai's existing `int3` debug trap. This preserves an actual invalid-input failure without adding an unrelated Basic dependency.

GetRect geometry uses an upward-positive y axis, and LeftHanded uses a downward-positive y axis. Slicing accepts a separate margin. Containment includes the starting edges and excludes the far edges; disjoint intersections have zero extents. `get_quad` returns four corners and optionally rounds positions to pixel coordinates. Rendering, events, themes, and widgets are owned by the separate UI fragments.

Machine_X64 preserves the vendor enum, 11 feature leaves, and 200 named feature-bit positions. Feature tests/set/clear manipulate this packed layout. Processor-query and instruction primitives require the checked compiler/VM/native operation catalog. Ten hardware public APIs are still absent from the published module; their prepared real wrappers are withheld pending activation of genuine checked primitives. Their integration status is recorded in the coverage receipt.

## How to change it

Scalar limits live in `Math/constants.jai`; algorithms live in `Math/scalar.jai`. Vector/operator code is in `vectors.jai`, transforms and decomposition in `matrix.jai`, and plane operations in `plane.jai`. Extend the shared `Float16/conversion.jai` and `Srgb/transfer.jai` bodies rather than duplicating conversion logic in wrappers. Keep IEEE edge-case tests when changing bit arithmetic. Any new approximation needs its own error measurements before its precision is documented.

Random's explicit-state implementation is in `Random/generator.jai`, and PCG's raw transition is in `PCG/transition.jai`. Sequence changes affect serialized states and replay behavior; preserve the checked vectors. GetRect coordinate behavior belongs in each module entry, and UI work belongs in its `ui.jai` fragment. Feature enum positions in Machine_X64 form an ABI and must retain their numeric values.

## Configuration

Modules have no external numeric-library configuration. `Sloppy_Math.DEFAULT_EPSILON` is `0.0001`; matrix inversion and normalization accept explicit epsilon/fallback arguments. Projection functions select the `[-1,1]` or `[0,1]` depth range. `GetRect` retains the optional `Type_Indicator` module parameter.

Source-only verification selects authored sources explicitly:

```sh
JAI_RS_MODULE_PATH="$PWD/stdlib" JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off path/to/frozen/jai-rs check-library stdlib/Math/tests/scalar-tests.jai
```

`Math/tests/scalar-tests.jai` includes IEEE edge-case goldens and exhaustive half-pattern checks in 1024-value compile-time chunks. `Math/tests/vector-matrix-tests.jai` checks vectors, quaternion rotation/interpolation, and Matrix4 inversion. Float16's aggregate tests check vector conversion and overlapping matrix storage. Sloppy_Math checks integer limits and epsilon closeness. Srgb checks transfer thresholds and inverse pairs. Random checks sequence vectors, state replay, and intervals; PCG additionally checks bounded outputs and module-global replay. Machine_X64 checks packed leaf operations. Geometry tests exercise both coordinate conventions when renderer dependencies are checkable.

The final source-only receipt uses the immutable `9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d` CLI snapshot, with runtime support disabled. Its binary hash and the exact authored source hashes before and after verification are recorded in the coverage JSON. `build_inputs_verified=false`: these results identify that binary and those inputs, not a freshly verified build of current Rust sources. Earlier `b1b820…` evidence is retained separately. Compile-time assertions execute authored bodies; a deliberately wrong sqrt result failed a prior negative-control run. No native program or supplied original compiler was executed.

## Dependencies

Default Math and PCG are import-free. Legacy Math printers use authored Basic; Random's default forms extend the authored context. Float16, Sloppy_Math, Srgb, and GetRect geometry use Math. GetRect also imports Basic and its UI fragments use the independently authored drawing/input stack. Full GetRect checking currently reaches an unsupported GL directive, so geometry assertions are not claimed as executed. Hardware operations require real x86 support in the compiler backend and an explicit VM capability policy. These modules do not load the supplied original compiler, original native modules, or libc math libraries. Current evidence and unresolved integration blockers are in `stdlib/.coverage/math-numeric.json`.
