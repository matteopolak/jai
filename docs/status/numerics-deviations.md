# Numerics deviations register

Review scope: six owned modules, private internal/numerics, generators, owned
tests and staging/tool scripts. This report is in progress during corrective
integration; historical pass counts are not production integration claims.

| Location | Observable effect / rationale | Evidence and risk | Proper fix |
| --- | --- | --- | --- |
| internal/numerics/render_types and ui_context | Empty contextual Font/Texture records substitute for missing earlier contracts; now superseded by reviewed Simp and Type_Indicator | Existing tests cannot establish external identity or layout; unsafe if allocated | Remove and bind exact canonical aliases; underway |
| ui_text em/text_size/baseline; ui_core require_texture | Explicit metric/Texture ABI traps left incomplete facilities rather than fabricated data | Previous negative tests prove only diagnostics; real canonical mechanisms now available | Replace with canonical font fields and real Texture storage; underway |
| tests/numerics/dependencies | Input/Window_Type/Hash_Table fixtures isolate algorithms; not production integration | Prior 93/93 count depended on fixtures | Use canonical producer modules, preserve old evidence separately |
| tools/stage_numerics.py formatter-bootstrap and buffer repair | Host-only Basic/File_Utilities implementations and alias repair enabled tooling | Not canonical dependency integration; potential divergent filesystem semantics | Retry current foundations and remove unnecessary repairs |
| tools/numerics-format-driver.jai | Fallback wrapper around unchanged repository formatter engine | Engine check alone was not full CLI check; later full CLI did pass | Prefer source-built full jaifmt with canonical foundation |
| math_scalar float32 wrappers | Promote scalar operations to float64 then explicitly narrow because earlier interpreter intrinsics failed | Potential double rounding and slower execution; earlier own numerical/oracle tests | Recheck latest intrinsic semantics with original reproducer; use correct general compiler support |
| ui_editor augmented sampling | Copies canonical Color_Keyframe records rather than directly sampling augmented pointers | Generic using restriction was rejected; extra allocation/copy and direct-call gap | General compiler/spec restriction decision with original reproducer |
| platform_clipboard | Real macOS/Windows native backends; Linux/WASM explicit unsupported transport | Windows runtime unverified; Linux selection-serving integration absent | Canonical Clipboard when supported, or proper native selection transport; coordinate owner |
| platform_cursors | Native macOS15 diagonals; earlier macOS/Linux/WASM need caller callback | Explicit platform failure; Windows handles not runtime-tested | Canonical platform integration and supported cursor artwork/lifecycle |
| ui_core assets/themes | Empty embedded asset slots, independently chosen palettes and 16-pixel default font request | Assets are caller-provided by reviewed contract; chosen default size is not a measured font metric | Preserve caller assets; clarify unspecified defaults if compatibility requires |
| ui_text | UTF-8 scalar editing without glyph shaping/bidi/grapheme and full multiline selection geometry | Reduced visual editing semantics; caller renderer handles glyph drawing | Integrate reviewed canonical glyph/layout mechanisms where available |
| portable math/geometry/color algorithms | Series/range reduction, Jacobi polar null-space completion and unspecified degenerate choices | Numerical tolerance rather than correct-rounding proof; speed/accuracy tradeoffs | Independent oracle/IEEE tests; improve errors without lowering assertions |
| test/lint scope | Generic reproducer failed compilation and could not be fully linted | Zero findings was not complete lint coverage | Resolve general restriction and rerun all owned code |
| canonical dependencies | Current Window_Type uses root Objective_C.NSWindow; AppKit defines canonical NSWindow | Blocks default GetRect/Simp on macOS; no peer changes permitted | Original dependency reproducer and owner fix, not facade special cases |
| WASM dependencies | Canonical Basic formatting imports host localeconv/snprintf/strtod per new integration request | Missing env imports prevent execution even for integer formatting | Foundation/compiler-owned portable path or real WASM host ABI; reproduce and hand off |

No blanket lint suppression, disabled numerical assertions or reference-derived
implementation is authorized. Remaining entries will be refined with current
commands, outcomes and any newly discovered workaround before handoff.

## Current corrective resolution (supersedes historical rows above)

- Empty render_types is deleted; canonical Simp aliases and Type_Indicator now
  bind real types. Metric/Texture ABI traps are removed. Canonical font fields
  supply metrics; full initialized Texture storage goes to the caller loader.
  Evidence: canonical_rendering interpreter and O0/O2 in canonical-verification-r2.
  Remaining risk: exact baseline policy unspecified; alternate fonts without
  matching fields cannot use metric helpers. Clarify reviewed alternate contract.
- Production clipboard now delegates to canonical Clipboard on macOS/Windows.
  Private named-pasteboard code remains an isolated native transport test oracle,
  not proof that the production global clipboard path ran. Tests never overwrite
  the user clipboard. Linux/WASM remain explicit unsupported backends.
- No fixtures or staging repairs enter canonical-current. Role overlays were
  fixed to exclude stale inherited peer dependencies. Previous broad copying
  could silently replace current Basic with an old peer snapshot; initial logs
  are retained, current source hashes are manifest-recorded. Proper fix applied:
  ownership-filtered overlays, not symbol-specific source edits.
- Required precision casts preserve half ties, exact 2^-24 scaling and binary32
  oracle inputs. OKLab computes coefficients/intermediates in float64 then
  explicitly rounds public components. Numeric tolerances/assertions unchanged.
- Direct float32 intrinsic reproducer still fails interpreter sqrt32(9), bits
  737832588 versus expected 1077936128; native O0 returns correct bits. Therefore
  promotion wrappers remain necessary. Compiler-owned general width fix required.
- AppKit Window_Type import is fixed by its owner; current reproducer succeeds.
  Actual WASM and target failures are recorded in dependency handoff; no fake
  libc imports or disabled target checks are used.
- Font/Texture allocation tests use caller test renderers and resource IDs, not
  an actual GPU context. Concrete layout/identity and callback behavior are
  verified; native GPU/window/input acceptance remains window-render/coordinator.
- Successful Texture cache entries have process lifetime with no public disposal
  hook in this inventory; unbounded unique assets retain storage/resources.
  Clarify cache lifecycle before adding destruction outside a valid GL context.
- GetRect's Windows alias remains conditional because native Windows bindings
  reject other targets; inventory lists an unqualified alias. This visibility
  deviation requires spec clarification or a platform-neutral binding namespace.
- Current full canonical suite is 81/99, not complete production integration.
  Native corrective suite is 21/21 without fixture imports. Generic reproducer
  remains a compile failure and incomplete lint coverage. Historical isolated
  counts are not reused as completion evidence.
