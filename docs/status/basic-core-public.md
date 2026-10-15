# Focused Basic/Math public compatibility status

Actual host: Mac arm64. Approved independent compiler substrate: candidate8b134bdb,
read only as the explicitly authorized tree, staged locally and source-built in
isolated artifacts/T7. No peer compiler, prelude, lifecycle or committed
Extensions source is edited.

| Gate | Actual result |
| --- | --- |
| Seven focused programs, interpreter/native O0/O2 | 35/35 build/execution commands pass |
| Four new public-API test roots, strict lint | 4/4 pass; combined runner39/39 |
| Changed Basic context/types/printers and integer/Vector2 sources | Contextual strict lint passes without suppressions |
| Changed Jai source/test formatting | Actual source-built jaifmt `--check` passes |
| Previously blocking Http client lint context and independent controls | 18/18 pass on the approved compiler substrate |

Implemented: a genuine Context.print_style field owned by one unparameterized
module, canonical shared formatter types, actual printer consumption, and an
ownership-safe callback ABI bridge preserving ENABLE_ASSERT-dependent builder
layouts. Tests verify exactly one reflected field across configured Basic
instances, context-copy isolation, canonical type names, integer/float/array
styles, explicit cross-instance formatter values, custom callbacks with prefix
inspection and5000-byte output, declining callbacks, and actual Math printer
hook integration. Callback/builder allocations are counted and fully released.

Reviewed S128 +/-, U128 subtraction, inherited Apollo arithmetic and Vector2
scalar/componentwise operators are implemented. Tests cover carry/borrow,
negative values, bit-boundary wrap, real monotonic-time expressions, both scalar
positions, and IEEE signed-zero division. Pointer/string free and Hash_Table
supported key scenarios already pass on the substrate, including real recorded
allocator ownership and explicit hash/equality callbacks for record keys.
No unsupported Basic exports or allocator named arguments were added.

Replay: `python3 tests/portable-stdlib/check-core-public.py`. Actual command
outputs and failures, if any, are retained in
artifacts/core-public-verification/results.json. Architecture and callback
copy/allocation costs are documented in
[the feature report](../features/basic-public-context.md).

Remaining dependencies: the portable-time owner retains clocks/calendars and
conversion bodies; no scaffolding integration is performed here. The compiler
owner supplies the approved checkpoint; no general compiler rule is weakened.
Signed128 overflow policy and cross-configuration raw callback-buffer identity
have [explicit precision questions](../specs/questions/basic-core-public.md).
The implemented policy is modular limb arithmetic and typed callback adaptation,
not raw layout interchange. Cross-platform runtime, full public corpus and final
integration/release certification remain coordinator work.
