# Numerics canonical integration progress

2026-10-15: resumed from 81036e1. Read only the new integration-clean request
and independent producer sources; quarantined integration and corpus vendored
modules remain forbidden and were not accessed. Current compiler sources copied
and source-built in artifacts/compiler-current and artifacts/current-target.

Canonical integration review reports 8/60, superseding isolated fixture counts as
production evidence. Investigating explicit float32 rounding and adopting the
reviewed Simp/contextual Type_Indicator contract. Current dependency observation:
window-render Window_Type still refers to root Objective_C.NSWindow, while the
new binding defines it in Objective_C/AppKit. Minimal reproducer and handoff next.
Existing numerical assertions will remain intact. Window/input pump is peer-owned.

Milestone: source-built fresh compiler diagnoses required literal narrowing.
Half exact binary32 scale and tie tests now cast deliberately; OKLab retains
double coefficients/intermediates until the final public binary32 components.
Existing assertion thresholds unchanged. Independent oracle generator now casts
its intentionally binary32 quaternion inputs explicitly, retaining expectations.

Canonical Simp Font/Texture/Font_Effects aliases and Type_Indicator binding are
implemented. Empty render_types removed. Actual canonical font metrics and full
Texture storage/loader cache pass a new interpreter regression. Window-render
fixed AppKit during this pass; canonical Window_Type reproducer now succeeds.
Production clipboard calls canonical Clipboard on macOS/Windows.

Staging bug fixed: role overlays copied stale inherited peer files across
ownership boundaries. Overlays now copy only declared owned modules/internal
paths. Production staging uses no fixture, Buffer alias or formatter repairs.
Actual full jaifmt built on this canonical library without tool bootstrap.

Current failures independently reproduced: WASM Basic formatting's missing
localeconv/snprintf/strtod imports, direct float32 interpreter sqrt error,
Windows no_dce Simp filename font/File limitation, macOS x64 POSIX.itimerval,
and unsupported WASM Window_Type/Input. Current baseline suite 64/87 before
remaining precision-test fixes; this is not completion. Next: fresh full suite
and native corrective suite, scoped lint/format, publish exact evidence in docs
and commit reviewed changes locally. No publication to external repositories.

Verified milestone: artifacts/canonical-verification-r2/results.json is 81/99.
All interpreter and native O0/O2 programs pass, including 3,158 oracle assertions;
remaining failures are actual WASM and cross-target dependency gates listed in
numerics-dependency-handoff.md. Native corrective suite without fixture imports:
21/21 (artifacts/canonical-corrective/results.json). Full source-built jaifmt
--check: 61 files, zero changes/errors; scoped current jailint -D warnings: zero
findings, augmented restriction call still rejected/not fully linted. No complete
integration claim. Next checkpoint removes obsolete host-tool staging repairs.
