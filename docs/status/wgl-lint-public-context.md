# WGL lint through public contexts — 2026-10-16

Filtered coordinator feedback for Windows x64 MSVC940 job117173045723 reports
production renderer interpreter/O2 success followed by owned-WGL-lint failure:
private rendering/window files were submitted as independent lint roots. This
checkpoint changes only the WGL runner's lint selection and coverage accounting.
It does not establish a new Windows runtime pass.

`tools/window_render_wgl_ci.py` now makes two strict lint invocations against the
actual `--stdlib` selection. The public invocation selects the eight canonical
module entries, Gamepad/SDL_Input_Map's entry, and the same four WGL programs.
Jailint follows their transitive `#load` sources. Selecting entries instead of
directories avoids treating unrelated Mac-only module tests as Windows programs;
those tests remain owned by their appropriate Mac catalogue gates.

The private invocation requests the existing window-contexts, lifecycle,
native-fields and windows-devices sources using the unchanged
`tests/window-render/windows-render-events.jai` as `--context`. That program
imports public Window_Creation, Input and Simp, which reach those internals with
their real library provenance. No application imports private modules. No public
exports, privacy permissions, production sources or compiler behavior changed.

Both invocations retain `-D warnings`, require fresh `--manifest` files, and use
foundations' existing `cleanroom_lint_contexts.checked_coverage` protocol.
Missing/malformed manifests, incomplete checks, denied findings and any unvisited
required entry/private file fail the overall runner. Complete/partial/unvisited
coverage is retained in results.json and filtered summary.json. Existing driver
PE/hash/deployment/loaded-identity checks, native diagnostics, readback assertions,
lifecycle tests and signed-wheel/modifier event-pump tests are unchanged. All four
programs still execute in interpreter/native O0/O2, with native builds required.

## Verification and initial findings

Evidence lives under
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/window-render/target/wgl-lint-context-repair/`.
`qualification.json` contains exact source-built jailint commands and manifests.
Windows MSVC x64 and ARM64 source checks each pass both jobs with no stderr,
43 complete visited public/load sources and four complete visited private sources.
Every required file is covered. These are host source checks, not Windows native
execution. No GUI/native lease was acquired for this batch.

The original two regression assertions failed before the new context/coverage
helpers existed. An initial public-directory attempt failed on Mac-only
Window_Creation/tests/macos-{events,window}.jai with
`Objective_C/AppKit requires macOS`; canonical production entry selection resolved
that incorrect root selection. The local source-built linter accepts a direct
private root through its library-origin wrapper, unlike the reported CI checker;
that initial probe is retained in `privacy-initial.json` and is not reported as
an expected rejection. The actual application-private-import negative reproducer
is rejected on both target CPUs (`privacy.json`). The revised runner relies on
neither direct private root permission nor a tool-specific privacy workaround.

Two new deterministic runner tests pass, including missing/malformed, denied,
partial and unvisited coverage failures. Foundations' six coverage-protocol tests
also pass. Ruff strict checking passes for both changed Python files. Ruff formats
the new helper/runner sections and the complete new test file; repeat checks are
idempotent. Pre-existing runner formatting outside this delta is retained.
No Jai source changed, so this batch introduces no new Jai formatting surface.

## Integration handoff

Foundations owns the general context strategy, runner/catalogue and coverage
protocol. This patch consumes that strategy without editing its implementation,
manifest or tests. Integration remains the sole Git index owner. Apply only the
new `wgl-public-context.patch` and review `handoff.json` in the T7 evidence directory.
The next normal Windows CI run must execute the actual WGL driver/renderer suite
and both strict lint jobs; host checking does not replace that gate.

`input-runtime-evidence.json` accompanies the patch and references the accepted
Mac Input nine-pass receipt, source pin, native asset hashes and released-slot
receipt. Its three interpreter/O0/O2 fixtures include persistent caller storage
over 300 temporary-reset/scribble frames. Those results are already accepted;
this export does not replay their source patch or rerun their GUI tests. Mac
runtime evidence does not establish Windows/Linux runtime coverage. Release
publication remains held.
