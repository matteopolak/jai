# Numerics implementation status

**Incomplete canonical acceptance.** Current canonical run is **126/143**;
seventeen failures remain in native-window/target dependencies. All twenty main
programs pass interpreter and native macOS ARM64 O0/O2. Core, algebra, precision,
3,572-assertion independent oracle, IEEE normalization/absolute-value cases,
public contract and overflow diagnostics also
execute in actual WASM. Core WASM imports only standard WASI functions.

All six reviewed module inventories are present (694 names): Math155,
Sloppy_Math4, Float16_16, Color_Interpolation13, GetRect254, LeftHanded252.
Name coverage is not a semantic compatibility proof. Canonical aliases preserve
actual Simp font/effects/Texture identities and full storage. Both variants bind
Type_Indicator; a distinct alternate renderer test verifies callbacks, storage
and independent instance globals. Empty render_types and metric/Texture traps,
approximate UI parsing/precision cap, test dependency fixtures and tool repairs
are removed. Existing numerical assertions/tolerances remain intact.

Native corrective suite: **25/25**, including isolated macOS clipboard oracle,
native/public cursor lifecycle, required-font/loader/capacity diagnostics and
reproduction of the still-rejected augmented generic restriction. Diagnostic
success is not implemented augmented functionality or global Clipboard proof.

## Reproduction and evidence

Source-built compiler/jailint: artifacts/current-target/debug, copied permitted
Rust sources under artifacts/compiler-current. Build evidence:
artifacts/current-compiler-build.log.

```sh
python3 tools/stage_numerics.py --destination artifacts/canonical-numeric-final \
  --compiler-library ../compiler/stdlib --foundations ../foundations/stdlib \
  --window-render ../window-render/stdlib \
  --manifest artifacts/canonical-numeric-final-manifest.json
python3 tests/numerics/run.py --compiler artifacts/current-target/debug/jaic \
  --stdlib artifacts/canonical-numeric-final --output artifacts/canonical-verification-numeric-final
python3 tests/numerics/corrective.py --stdlib artifacts/canonical-numeric-final \
  --output artifacts/canonical-corrective-numeric-final
```

Staging copies only independent producer-owned overlays and records exact source
bytes/hashes; manifest repairs is empty. No fixtures or source edits repair
dependencies. Current outputs: canonical-suite-numeric-final.log,
canonical-verification-numeric-final/results.json, canonical-corrective-numeric-final.log,
canonical-corrective-numeric-final/results.json, canonical-wasm-imports.json, and the
matching staging manifest under artifacts. Earlier failed runs remain preserved.

Actual full source-built repository jaifmt --check with root config passes
**62 files, zero changes/errors/ignored files**. Scoped source-built jailint
-D warnings reports zero findings; augmented_generic_reproducer's rejected call
is explicitly not fully linted. Evidence: artifacts/canonical-jaifmt-numeric-final.log,
canonical-lint-numeric-final.log and canonical-jaifmt-build-stable.log.
Both generators are byte-idempotent, and staged owned production files are
byte-identical. No Extensions or compiler source was modified.

## Remaining gates

- Thirteen UI-containing WASM builds plus WASM full-target check fail because
  canonical Window_Type/Input has no reviewed WASM native handle. No invented
  handle or fixture bypass is used.
- Windows full-target checks (default CPU and x64) reach Simp's explicit
  filename-font/File unsupported gate. Numerical-only Windows target checking
  succeeds after required foundation Windows helper integration.
- macOS x64 full-target check reaches missing POSIX.itimerval. Linux/native
  macOS full-target checks succeed. Native Windows/Linux execution is not claimed.
- Direct float32 interpreter intrinsics remain wrong; Math promotion wrappers
  are retained with a minimal original reproducer. Native direct intrinsic test
  succeeds. Generic using-base restriction still needs compiler/spec decision.
- Native GPU/window/input-pump acceptance, including issue1 wheel/event delivery,
  belongs to the window-render owner/coordinator. Clipboard global state is not
  overwritten by this worker's tests.
- Exact alternate-font metrics, baseline policy, resource cache disposal,
  remaining visual-editing reductions and visibility assumptions are listed in
  [deviations](numerics-deviations.md) and [questions](../specs/stdlib/numerics-questions.md).

See [progress](numerics-progress.md) and
[original dependency reproducers](numerics-dependency-handoff.md).
No completion, corpus, CI or release acceptance is asserted.
