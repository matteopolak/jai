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

Pending: more IEEE/extreme numeric cases, declaration/parameter review, complete
native O0/O2 and target matrix reruns, and final honest gap classification.
