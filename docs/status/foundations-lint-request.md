# Strict lint context/target coverage request

Rebuilt from the latest NEW compiler/linter sources after the refined leak spec
sync. CLI still exposes no target selection; driver.rs still creates host
CompilerOptions. The selected bootstrap and private import rules are preserved;
no alternate prelude or fake public wrapper is used. The two positive pending
API-gap probes are included in the lint inventory too; incomplete bodies there
are genuine missing APIs, not expected-negative fixtures or completed coverage.

After refreshing the NEW compiler to its general BUILD_* host fix, jailint now
reports incomplete semantic coverage instead of silently falling back. That is
useful failure evidence; no old pass is reinterpreted as full semantic coverage.

Two context issues were resolved without suppression:

- The shared context module now owns an inline is_active guard used by all four
  automatic checker hooks. Its import has a genuine named use and still adds
  one canonical inside_memory_debugger field for all Basic configurations.
- Library lint paths must be the byte-identical files under the selected
  JAIC_STDLIB root. Passing original worker paths while JAIC_STDLIB points at
  composed producer staging creates different canonical module identities and
  makes private modules appear to be forbidden application imports. Selecting
  exact staged copies (verified byte-for-byte) preserves privacy and analyzes
  real production code. No substitute module/body is used.

Remaining producer workflow requests:

1. Expose general target selection to jailint (OS/CPU or target triple), so
   Windows-only native files receive Windows semantic analysis. Current CLI
   accepts import dirs but always builds host Options. Host analysis of
   internal/files/windows-{abi,text}.jai and filesystem-windows.jai correctly
   fails on unavailable Windows declarations; hiding those failures is wrong.
2. Provide an explicit mode/workflow for deliberately type-invalid regression
   sources: style/syntax checks still apply, but expected check failure must be
   asserted separately with its exact diagnostic. Current negative scalar and
   cross-only host predicate correctly fail native checking. Do not globally
   ignore incomplete production roots. The foundations driver keeps exact
   compiler-rejection and cross-predicate checks, rather than blessing errors.
3. Supplying -I tests/portable-stdlib/pending resolves the genuine alias probe's
   helper imports. This is a real missing import path, not a fixture substitute.

The complete staged lint command currently reports Windows-target and intentional
negative/cross-only roots as incomplete. It also found a valid unused allocator
parameter in the replacement-interface test: the free callback now checks that
the forwarded allocator procedure is non-null, preserving its exact name and
improving behavior coverage rather than suppressing/renaming it.

The worker does not edit producer Rust. Proper general analyzer/CLI changes
belong to the compiler worker; no module-name/path-specific bypass is requested.
