# Independent numerics and UI implementation

Math, Sloppy_Math, Float16, Color_Interpolation, GetRect and GetRect_LeftHanded
are implemented from reviewed specs and independent sources. Shared algorithms
live in internal/numerics; facade aliases retain canonical names, overloads and
layouts. UI globals are declared in facade-loaded sources to preserve storage
identity. Default rendering types are canonical Simp.Dynamic_Font, Texture and
Font_Effects; windows alias Window_Creation.Window_Type. Type_Indicator supplies
the four alternate contextual types. No empty render_types substitute remains.
`ui_init()` without a `Draw_Procs` installs Simp-backed callbacks when Type_Indicator
is void (the pointer image keeps its native fallback); an explicit `procs` replaces them.

Math uses row-major matrices and column vectors. Matrix3 inverse rejects the
strict determinant interval and returns input on failure. Matrix4 Gaussian
inverse rejects exact zero pivots and returns identity on failure. The separate
adjugate inverse honors its reviewed epsilon. Polar decomposition uses a Jacobi
Gram eigensystem with independent orthogonal null-space completion.

Portable frexp/ldexp and transcendental range reduction/series avoid unavailable
host C math imports. Length uses scaling; normalize compares actual length with
epsilon. Float32 intrinsic wrappers still promote/narrow because a minimal
current interpreter intrinsic test fails; native direct intrinsics pass. This is
a documented compiler workaround, not a correct-rounding/performance claim.

Vector and quaternion normalization retain a private float64 norm through division
to avoid subnormal rounding and finite-input overflow. Public lengths and epsilon
comparison still use their canonical binary32 result. Zero unit vectors remain
unchanged, including signed zeros; maximum-range and subnormal cases are tested.

Half conversion rounds integer significands once to nearest-even across normal,
subnormal, tie and overflow boundaries. Tests cover all 65,536 half encodings and
adjacent finite-half midpoint ties in both signs. Explicit casts mark intended
binary32 values. OKLab retains float64 coefficients/intermediates until public
binary32 storage. Color sampling follows the inclusive grid, degree HSV, gamma2.2,
shortest arcs, wrapping, duplicate and empty/one-slot policies.

UI mechanisms include persistent state, callbacks/deactivation, input, clipping,
occlusion, geometry, themes, controls, text editing, popups, color picker/editor
and subwindows. Left-handed geometry/winding differs as reviewed. Text metrics
use real canonical font fields; full initialized Texture storage goes to loaders
and successful entries are cached. Alternate types are tested with distinct font,
effects and texture records and independent module-instance globals.

Clipboard uses canonical Clipboard on macOS/Windows. Named-pasteboard native tests
are an isolated OS oracle, never production-global clipboard proof. Cursors use
native retained/shared handles with repeated initialization and caller callback
precedence. No embedded asset payload is promised; callers supply assets/renderers.
Actual native GPU/window/input-pump acceptance belongs to the window-render owner
and coordinator, including issue1 wheel/event propagation.

UI numeric input now uses canonical correctly rounded conversion with full
consumption checking. Requested decimal precision uses canonical FormatFloat;
the old seventeen-digit parser and twelve-decimal cap are removed. Programmatic
text append diagnoses overflow; interactive capacity rejection reports and leaves
text/result flags unchanged. Numerical assertions were not relaxed.

Canonical MOUSE_WHEEL records now preserve signed/fractional deltas and accumulate
within a frame. Eligible scroll regions consume them once using normal clipping/
occlusion hit testing; frame reset prevents stale pulses. Keyboard wheel pulses
remain supported. Unknown horizontal axis semantics remain an explicit question;
this consumer work does not implement or replace the native event pump.
Text shortcut dispatch reads canonical key_code independently of the pressed flag;
Ctrl/Cmd+A/release cases are tested without clipboard side effects. Cursor pointer
types share one native-helper identity across both variants.

Verification uses a fresh locally source-built Rust compiler and canonical producer
staging, no fixtures or source repairs. Source/manifest/log commands, actual results
and remaining target failures are in [status](status/numerics.md) and
[progress](status/numerics-progress.md). The independent Python oracle has 3,572
assertions, including libm cube-root OKLab comparisons, rational matrix inversion,
Rodrigues rotations and IEEE struct conversions. Actual interpreter/native O0/O2
and feasible WASM runs are required, as are root-config jaifmt/jailint and stable
regeneration. No Extensions, peer checkout or compiler source was modified.

All remaining reductions, assumptions and performance tradeoffs are enumerated
in [deviations](status/numerics-deviations.md); precise unresolved contracts are in
[questions](specs/stdlib/numerics-questions.md). These prevent an unqualified full
compatibility/production acceptance claim.
