# Numerics worker status

The implementation pass covers all six assigned modules. Worker verification
passes; canonical dependency and native UI integration gaps remain explicitly
listed below. Final combined-library, corpus and release verification remains
with the coordinator.

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
were staged in this workspace's ignored artifacts. The final run passed **86/86
checks**, including build checks:

- Ten self-checking programs in the interpreter, native O0/O2 on macOS ARM64,
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
popup changes, spinboxes, every picker mode, texture loader failure/cache behavior,
UTF-8 editing and stable composite-widget identities.

Reproduce with:

```sh
python3 tests/numerics/run.py \
  --compiler artifacts/target/debug/jaic --stdlib artifacts/stdlib-fresh
```

Durable evidence is in `artifacts/numerics-verification/results.json`, per-check
logs, `artifacts/fresh-numerics-run.log`, `artifacts/compiler-build-fresh.log`,
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
- Concrete Font/Font_Effects/Texture/NSCursor ABIs are absent from the supplied
  contracts. Contextual opaque callback types support caller renderers; concrete
  ABI/nominal integration remains unverified. Vertical text metrics use a
  16-pixel fallback. The Windows module alias is conditional because the fresh
  binding rejects non-Windows imports.
- Clipboard operations use module-local owned storage; native clipboard
  synchronization is not implemented. Native cursor creation requires caller
  integration. Text editing does not supply native glyph shaping, bidi/grapheme
  layout, or full multiline visual selection/cursor geometry.
- Augmented_Keyframe's documented using base does not establish the #as relation
  required by Color_Interpolation's generic restriction in the current compiler.
  Editor sampling copies canonical Color_Keyframe records; direct generic
  sampling of augmented pointers remains a contract question.
- Simultaneous native multiwindow occlusion/resource lifecycle integration and
  exact unspecified styling/easing/formatting choices have not been verified.
  The local name audit is not a full semantic ABI or compatibility proof.

See [implementation details](../numerics.md) and
[contract questions](../specs/stdlib/numerics-questions.md).
