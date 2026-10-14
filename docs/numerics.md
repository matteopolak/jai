# Independent numerics and UI implementation

The six public modules are Math, Sloppy_Math, Float16, Color_Interpolation,
GetRect and GetRect_LeftHanded. Their reviewed inventories define compatibility.
Algorithms and shared mechanisms live under `stdlib/internal/numerics`.
Facade aliases retain canonical record names and overload sets. UI mutable globals
are declared directly in the facade's loaded sources, preserving storage identity.
No bootstrap definitions or Extensions sources are modified.

Math uses row-major matrices and column vectors. Matrix3 inversion computes
cofactors and applies the strict documented determinant interval. Matrix4 inverse
uses partial-pivot Gaussian elimination with exact zero pivot rejection and the
documented identity failure result. The separate adjugate path is independently
implemented. Polar decomposition uses a Jacobi eigensystem of the Gram matrix
with orthogonal null-space completion. Singular completions are independent
choices, not claims about an unspecified reference algorithm.

Scalar elementary functions use independent portable range reduction and series,
plus compiler intrinsics for sqrt, sin, cos, floor and ceil. Integer powers use
exponentiation by squaring. frexp manipulates IEEE exponents; ldexp scales in
bounded chunks. No native frexp, ldexp or cbrt imports are needed. These routines
are tested against independent numeric oracles with stated tolerances; no general
correct-rounding claim is made. Length calculations scale components to avoid
avoidable underflow/overflow. Normalization compares the resulting length with
epsilon, then applies the specified fallback.

Float16 conversion rounds integer significands once to nearest-even, including
subnormal and overflow boundaries. Sign, zero and infinity categories are
preserved; NaNs preserve sign and a nonzero payload while being quieted. The
ASSERT_ON_OVERFLOW parameter is forwarded through the public facade. Tests cover
all half encodings, all adjacent finite-half midpoint ties in both signs, and
independent Python `struct` conversion samples.

Color interpolation follows the reviewed inclusive sampling grid, gamma 2.2,
degree HSV and shortest hue arcs, cyclic last-to-first segments, unit denominators
for duplicate times, empty-key/output policies, and one-output-slot bypass. RGB
and alpha may extrapolate; OKLab inverse conversion clamps RGB. The editor keeps
source keyframes and samples separately.

The UI implements persistent state, active-widget callbacks and stale-state
deactivation, per-frame input, clipping/occlusion, rounded geometry, themes,
buttons, checkbox/radio controls, popup dropdowns, sliders with spinboxes and
relative dragging, numeric/text entry, scroll/split regions, subwindow callbacks,
color picker modes and stashes, and editable/sampleable color animations.
Control-click adds a keyframe, Delete removes the nearest hovered keyframe, and
right-click opens its picker. Rounding uses floor(value + 0.5). The left-handed
module reverses vertical cuts and drawing winding. If only quads are registered,
rounded triangles use degenerate quads rather than dropping the rounded geometry.

Applications supply drawing, text preparation, texture loading, mouse queries
and cursor callbacks. Failed texture loads return null. No built-in image/font
payloads are supplied; the nine resource-data slots are empty. Opaque texture
tokens allow a caller renderer to keep native resources in its own map.

## Verification

Only locally source-built compiler/program execution is used. The peer compiler
Rust sources were copied into `artifacts/compiler-source` and built with:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm \
CARGO_TARGET_DIR="$PWD/artifacts/target" \
cargo build --manifest-path artifacts/compiler-source/Cargo.toml -p jaic-cli --locked
python3 tools/stage_numerics.py --repair-foundation-buffer-alias
python3 tests/numerics/run.py \
  --compiler artifacts/target/debug/jaic --stdlib artifacts/stdlib
```

The staging script writes only this workspace's ignored artifacts and records
source hashes and any explicit integration repair. Its Buffer repair removes
an invalid standalone alias; the reviewed Basic.Buffer is actually nested under
String_Builder. It does not modify a peer checkout.

The suite runs interpreter, native O0/O2, actual wasm64 WASI under Node, target
unused-code checks, half overflow assertions and public contract fixtures. Logs
and machine-readable results remain under `artifacts/numerics-verification`.
The independent oracle uses Python math, IEEE struct conversions, exact rational
matrix inverses and Rodrigues rotations. Test success requires both a zero exit
status and an explicit success marker, with no assertion failure output.
Use `--canonical-dependencies` to remove the marked UI fixtures when the peer
foundation is ready; missing canonical dependencies then fail normally.

## Actual gaps and integration boundaries

- Canonical Input and Window_Type sources are not yet available from the peer
  foundation. UI tests use explicitly marked record fixtures. Their results do
  not prove native window/input ABI integration. The peer Hash_Table integration
  additionally fails because its fresh Hash implementation currently lacks scalar
  get_hash(u64); the UI tests use a marked map fixture.
- Font, Font_Effects, Texture and NSCursor concrete defining ABIs are not supplied
  by these specs. The UI uses contextual opaque callback types. Text preparation
  provides horizontal measurement; vertical font metrics use a 16-pixel fallback.
  Concrete renderer/font ABI compatibility remains unverified.
- Clipboard operations currently use an owned module-local clipboard. Native
  system clipboard synchronization is not implemented. Native cursor creation
  requires the caller callback; init_pointers asserts if that integration is absent.
  These are limitations, not completed native integrations.
- Text editing supports UTF-8 scalar boundaries, selection, history, completion,
  and input events. It does not implement grapheme shaping, bidi layout or full
  multiline visual cursor/selection geometry. No native glyph renderer is supplied.
- UI styling, easing, exact textual formatting, degenerate HSV choices and
  rank-deficient polar completions use documented independent choices where the
  reviewed contract leaves behavior open. Scroll regions use one axis per scalar
  scroll value, choosing vertical when both direction flags are set. Per-window
  event delivery is supported, but simultaneous native multiwindow occlusion and
  resource lifecycle integration have not been verified.
- The public inventory name checker is a local source check. Final semantic API,
  corpus, release and combined-library verification belongs to the coordinator.

Open contract issues are maintained in [numerics questions](specs/stdlib/numerics-questions.md).
