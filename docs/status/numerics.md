# Numerics worker status

**Not complete / coordinator handoff not accepted.** All six modules have
implementations, but inventory coverage and fixture tests do not establish full
production compatibility. Corrective review removed local clipboard substitution,
invented font metrics and unsafe opaque Texture allocation. Canonical ABI and
platform gaps below prevent a completion claim. Final integration, corpus and
release verification remains with the coordinator.

| Module | Inventoried names | Delivered mechanisms |
| --- | ---: | --- |
| Math | 155 | Portable scalars, IEEE classification, vectors, matrices/inverses, quaternions, planes, projections, polar decomposition, printers |
| Sloppy_Math | 4 | Inclusive absolute comparisons and numeric bounds |
| Float16 | 16 | Nearest-even IEEE conversions, vector/matrix storage and conversions, overflow assertion parameter |
| Color_Interpolation | 13 | Sampling policies, gamma 2.2, degree HSV, shortest arcs, OKLab and interpolation geometry |
| GetRect | 254 | Geometry, drawing callbacks, frames/input, persistent state, active-widget lifecycle, occlusion, themes, controls, UTF-8 editing, color picker/editor and subwindows |
| GetRect_LeftHanded | 252 | Corresponding mechanisms with opposite vertical cuts/winding and the reviewed variant-specific signatures/shapes |

All 694 public inventory names are present. Canonical nominal names and overlays
are retained; private helpers are not facade exports. Mutable UI globals are
declared directly in facade-loaded sources. Extensions and bootstrap sources
were not changed. No other checkout was modified and no publication was performed.

## Actual verification

On 2026-10-14, the latest fresh peer Rust compiler was copied and source-built
locally against LLVM 23. Fresh foundation/binding sources and these six modules
were staged in this workspace's ignored artifacts. The corrective run passed
**93/93 checks**, including build checks:

- Eleven self-checking programs in the interpreter, native O0/O2 on macOS ARM64,
  and actual wasm64 WASI execution under Node 24.
- Unused-code target checks for Linux, Windows, macOS and WASM, plus explicit
  x64 checks for Linux, Windows and macOS.
- Expected half-overflow assertion failures in interpreter, native O0/O2 and WASM.
- Local public-name inventory checking and independent oracle generation.

The independent oracle contains **3,158 assertions** from Python math/IEEE struct,
exact rational matrix inversion, and Rodrigues rotations. Core tests additionally
cover all 65,536 half encodings and all adjacent finite-half midpoint ties in both
signs. Algebra tests cover generic/explicit overloads, strict Matrix3 thresholds,
exact tiny Matrix4 pivots, IEEE subnormal edges, quaternion/plane/projection
invariants and zero-divisor reporting. UI tests exercise lifecycle callbacks,
popup changes, spinboxes, every picker mode, UTF-8 editing and stable composite
widget identities. Opaque-token texture cache tests are no longer counted as
supported behavior: the substitute was removed, and an explicit missing-ABI
diagnostic is tested separately.

Reproduce with:

```sh
python3 tests/numerics/run.py \
  --compiler artifacts/target/debug/jaic --stdlib artifacts/stdlib-fresh
```

Durable evidence is in `artifacts/numerics-verification/results.json`, per-check
logs, `artifacts/corrective-numerics-run.log`, `artifacts/compiler-build-fresh.log`,
`artifacts/numerics-compiler-provenance.json`, and
`artifacts/numerics-staging.json`. The earlier verified source/compiler/results
were preserved separately before rebuilding the newer peer compiler.

## Actual gaps

- Canonical Input and Window_Type implementations are not yet available from the
  peer foundation. Canonical Hash_Table integration was attempted and fails
  because fresh Hash lacks get_hash(u64). The isolated UI tests therefore use
  explicitly marked dependency fixtures; these are not production replacements.
  `--canonical-dependencies` removes them for coordinator integration.
- The staging copy explicitly removes the invalid standalone Basic.Buffer alias;
  the reviewed Buffer is nested under String_Builder. This repair is recorded and
  does not alter the peer checkout or this worker's owned production modules.
- Concrete Font/Font_Effects/Texture defining ABIs are absent from the supplied
  contracts. Shared contextual types preserve identity between both UI variants,
  but integration with the external defining module is unverified. Font metrics
  and Texture allocation now diagnose unavailable contracts; no invented height
  or opaque allocation is returned. Caller prepare/draw callbacks work with an
  explicit finite theme baseline and zero em padding. The Windows alias remains
  conditional because the fresh binding rejects non-Windows imports.
- Native macOS clipboard synchronization and cursor retain/release are tested.
  Windows Unicode clipboard and shared cursors compile under target checks but
  have not run on Windows. Linux/WASM native clipboard/cursors are explicitly
  unsupported; caller cursor callbacks work. Older macOS systems need a caller
  callback for diagonal cursors. No native glyph shaping, bidi/grapheme layout,
  or full multiline visual selection/cursor geometry is provided.
- Augmented_Keyframe's documented using base does not establish the #as relation
  required by Color_Interpolation's generic restriction in the current compiler.
  Editor sampling copies canonical Color_Keyframe records; direct generic
  sampling of augmented pointers remains a contract question.
- Simultaneous native multiwindow occlusion/resource lifecycle integration and
  exact unspecified styling/easing/formatting choices have not been verified.
  The local name audit is not a full semantic ABI or compatibility proof.

See [implementation details](../numerics.md) and
[contract questions](../specs/stdlib/numerics-questions.md).

## Corrective review evidence

See [corrective review](numerics-corrective-plan.md) for actual native checks,
repository formatting/lint commands, generation order, canonical dependency and
compiler handoffs. The unmodified full jaifmt CLI now builds using isolated local
tool-bootstrap helpers, and its actual scoped --check passes on 55 owned files.
Jailint reports zero findings but explicitly cannot lint the failed generic
restriction reproducer body; that is not complete lint coverage.
