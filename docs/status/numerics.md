# Numerics implementation status

In progress. Canonical facades for Math, Sloppy_Math, Float16 and
Color_Interpolation now exist. The first test exercises strict Matrix3 inverse
thresholds, Matrix4 failure identity, normalization by length, scalar categories,
HSV degrees, and all 65,536 half encodings. Interpreter and native O0 passed on
2026-10-14 with the locally source-built fresh peer compiler. This is initial
coverage, not a claim of full six-module completion.

Fresh compiler sources and foundation are copied read-only from peers into this
workspace's ignored `artifacts/`; all builds and integration writes occur there.
`-no_dce` currently fails in the staged foundation at `Basic.Buffer`, unrelated
to the numeric API. Targeted test compilation remains usable.

Both GetRect facades now have canonical record shapes, geometry, rounded drawing,
callback registration, frame/input handling, active-widget lifecycle, occlusion,
state lookup, theme storage, buttons, controls and UTF-8 text editing. The UI
contract test passed in interpreter and native O0 using explicitly marked
dependency fixtures. It checks inclusive edges, margin arithmetic, opposite
top-cut conventions, hash wraparound, drawing callbacks, button presses and
stale-widget deactivation. This is isolated mechanism coverage; canonical peer
Input/Window_Type/Hash_Table integration is still pending.

Color picker/editor state, gradients, interpolation sampling, subwindow callback
submission, popups, resizing and local clipboard serialization are implemented.
The headless UI smoke test exercises these using caller drawing/text callbacks.
The independent Python math/struct oracle supplies 2,415 assertions; interpreter
and native O2 passed. Core, extended numerics, and UI smoke tests ran successfully
as actual wasm64 WASI programs under Node 24. Linux and Windows UI type checks
with unused code included also passed with dependency fixtures.

Scalar elementary functions are independently designed portable algorithms; no
host frexp, ldexp, or cbrt imports are required. UI float parsing uses a private
portable decimal parser rather than the foundation's currently unavailable WASM
strtod binding.

The ignored integration copy removes the foundation's invalid standalone
`Basic.Buffer` alias (the reviewed type is nested under String_Builder). Neither
the peer checkout nor this worker's owned production sources were changed for
that integration correction. With it, full unused-code checking reaches Math
and both UI modules.

Additional edge tests now cover subnormal frexp/ldexp, ties at double underflow,
signed zero, integer powers, full signed bounds, tiny/huge vector norms, numeric
printers, and scientific UI formatting. Interaction tests cover dropdown change
notification and spinbox steps. Both issues were reproduced before correction.
The UI now exposes working circle/HSV/RGB/type-in picker modes, stashed colors,
relative sliders and text entry, interpolation controls, keyframe add/delete,
preview and clipboard sampling controls.

`tests/numerics/run.py --compiler artifacts/target/debug/jaic --stdlib
artifacts/stdlib --quick` passed all 14 checks, including unused-code target
checks for Linux, Windows, macOS and WASM, and an expected overflow assertion
with `Float16(ASSERT_ON_OVERFLOW=true)`. The local inventory presence check
matches 694 inventoried names across the six modules; this is name evidence,
not a claim of semantic ABI verification.

The expanded quick suite now passes all 20 checks. It also exercises every picker
mode and catches composite-widget identity collisions: child controls now derive
their identities from the parent hash. The oracle now contains exactly 3,158
assertions, including exact rational matrix inverses and independent Rodrigues
rotations. Core half tests additionally check every adjacent finite midpoint tie
in both signs. The broad algebra test exercises matrix/vector/quaternion/geometry
overloads and explicit zero-divisor reporting.

Canonical map integration was attempted and failed at the peer Hash.get_hash(u64)
specialization, rather than being silently replaced in production. The test
runner offers --canonical-dependencies for coordinator integration. Full expanded
matrix rerun and final status consolidation are pending; see docs/numerics.md for
the actual remaining ABI/platform limitations.
