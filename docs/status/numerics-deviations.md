# Numerics deviations register

Review scope: six owned modules, internal/numerics, generators/staging and owned
tests. Deviations remain. This is not complete coordinator acceptance.

| Location | Observable effect / rationale | Evidence and bug/performance risk | Proper long-term fix |
| --- | --- | --- | --- |
| math_scalar float32 wrappers | Promote to float64 and narrow because direct interpreter intrinsics are incorrect | intrinsic_f32_reproducer: sqrt32(9) bits 737832588 versus 1077936128; native O0 correct. Slower and potentially double-rounded | General compiler width/return fix, then native/interpreter/IEEE regression |
| Portable scalar/vector/matrix/quaternion algorithms | Series/range reduction, scalar arithmetic, Jacobi polar null-space completions and coherent unspecified degeneracies | 3,572 independent oracle assertions and exhaustive half tests establish tolerances/invariants, not correct rounding or SIMD performance equivalence | Improve against independent high-precision/exact oracles; clarify unspecified choices without relaxing assertions |
| ui_text metrics | em uses em_width; height uses character_height; baseline centers absolute ascent/descent plus y_offset_for_centering with handedness | Canonical rendering regression passes. Exact placement formula/descender sign unspecified | Reviewed exact formula if required; retain real canonical fields |
| ui_context Type_Indicator | Four exact supplied aliases; metric helpers currently need corresponding Font fields | Direct my_draw_text can use opaque fonts; label alignment can instantiate em even with finite baseline. Real distinct alternate types/storage/callbacks are tested. LH spec lacks GetRect's contextual paragraph | Clarify alternate metrics and mirrored LH parameter; do not invent mandatory hooks |
| ui_core Texture/state caches | Stable process-lifetime storage, no eviction/disposal API | Growing unique assets/identities retain storage/resources; pointers must remain valid. Caller test renderer proves storage/cache, not GPU uploads | Reviewed disposal/allocator/context contract; safe backend-context destruction and pointer lifetime |
| ui_core failed loaders | Canonical failure calls Simp.texture_destroy then frees; alternate loader owns partial native cleanup | Failure tests pass with full canonical Texture; alternate cleanup remains an ownership assumption | Reviewed alternate destruction semantics and coordinator native GPU acceptance |
| UI styling/assets/formatting | Empty nine asset slots, caller artwork, independent palettes, requested default font size16; scientific display outside roughly 1e-6..9e15 | No embedded assets promised. Size16 is a request, not fabricated measurement. Exact style/text equivalence unclaimed | Clarify externally required defaults; caller assets and canonical formatting |
| ui_text editing | Scalar UTF-8 without bidi/grapheme shaping/full multiline visual selection | Stateful/capacity tests pass; renderer handles glyph drawing | Reviewed layout/shaping and native visual acceptance |
| ui_geometry/editor rendering | Rounded corner segments capped at256, color ring64 segments, time-view preview256 samples; equal-color triangles can use degenerate quads | Bounded CPU/draw work; large shapes/gradients/previews may be coarser than ideal. Logical scissor requires renderer query or native callbacks for actual raster clipping | Reviewed quality/error budget, adaptive tessellation and native visual/clipping acceptance |
| ui_widgets scrolling | One scalar axis; vertical wins when both flags set. Wheel records normalize signed delta by absolute typical delta (zero scale means1), expire each frame and are consumed once by eligible region | Signed/fractional/accumulated/cancelled/legacy pulses tested. Exact speed/combined-axis policy unspecified; UNKNOWN axis is forwarded to callbacks, not inferred as vertical | Reviewed axis/speed contract; canonical event schema currently has no axis field |
| production clipboard | Canonical Clipboard on macOS/Windows; Linux/WASM explicit unsupported | User clipboard never overwritten by tests; production global clipboard not exercised here | Canonical owner native/selection acceptance and proper WASM host contract |
| platform_clipboard | Isolated macOS named-pasteboard OS test oracle only, no production UI import | Two native clients O0/O2 pass; duplicate Windows backend removed. This is not production-global Clipboard proof | Move safe native oracle into canonical owner's suite when an isolation seam exists |
| platform_cursors | Retained AppKit/shared Windows handles; macOS15 diagonals, earlier macOS/Linux/WASM caller callback | Repeated public initialization/callback precedence pass on macOS; Windows runtime unverified | Canonical native lifetime/artwork integration and Windows CI |
| GetRect Windows alias | Conditional export because Windows binding rejects other targets | Inventory lists unqualified alias; visibility differs off Windows | Clarify condition or platform-neutral binding namespace |
| ui_context NSCursor | Private opaque borrowed pointer identity; no canonical defining class shape is supplied | No allocation/dereference is invented; external nominal/reflection identity remains unverified if an AppKit NSCursor type is later provided | Reviewed defining class and canonical alias; retain native retain/release ownership |
| ui_editor augmented sampling | Canonical keyframe copies instead of direct generic augmented pointers | Extra copy/allocation; using-base restriction still rejected | General compiler/spec relation decision without altering reviewed public shape |
| canonical WASM Input/Window_Type | Default UI has no reviewed native WASM handle | UI builds/full target fail without fixture aliases; numerical WASM now passes with canonical portable Basic | Native window/input owner must define supported WASM contract |
| cross-target dependencies | Windows Simp filename-font/File gate; macOS x64 POSIX.itimerval | Full no_dce failures retained. Numeric-only Linux/macOS/WASM checks pass; Windows numeric check passes with required foundation helpers | Producer-owned backend/ABI fixes and target reruns |
| test/lint coverage | Augmented call rejected, body not fully linted; direct intrinsic interpreter assertion intentionally fails in handoff reproducer | Zero lint findings is not complete coverage. Interpreter assertion can exit0; runner requires success markers and no assertion output | General compiler fixes, full rerun; retain failures |

## Removed or resolved

- Empty render_types and Font/Texture ABI traps removed. Canonical Simp and
  Window_Creation aliases, real metrics and full initialized Texture storage.
- Half ties/exact 2^-24 and binary32 oracle inputs cast deliberately. OKLab
  retains float64 intermediates until final components; assertions unchanged.
- UI 17-digit parser and twelve-decimal cap removed. Canonical conversion now
  preserves rounding/subnormals/signed zero, rejects trailing junk, and honors
  requested formatting precision. Before/after logs: decimal-precision-before,
  decimal-format-before, decimal-format-after.
- Ignored text-capacity results removed. Programmatic append diagnoses overflow;
  interactive rejection reports and preserves state; invalid Unicode scalars
  diagnosed. Before/after text-capacity logs and current regressions retained.
- Input/Window_Type/Hash_Table fixture sources deleted. Runners require canonical
  dependencies; historical fixture counts are not production completion.
  The old explicit canonical CLI flag is accepted, but no fixture branch remains.
- Host-tool Basic/File_Utilities repairs, Buffer alias repair, alternate formatter
  driver and staging repair options deleted. Full jaifmt builds canonically.
- Stale inherited peer files no longer overwrite their actual owners. Role
  filters include required windows-text/windows-abi helpers. Copy/hash uses the
  same source bytes; owned directories replaced to remove superseded files.
  Initial bad-stage evidence retained; current manifests have no repairs.
- Window-render owner fixed AppKit during this pass. Independent reproducer now
  passes; no peer checkout changed.
- Foundation owner supplied portable formatting/parsing during this pass.
  Actual WASM numeric/oracle tests pass; core imports standard WASI only. Earlier
  missing localeconv/snprintf/strtod evidence is retained as resolved.

No weakened assertions/lint/CI, subagents, quarantined inputs, reference source,
vendored corpus bodies, credentials, publication or peer writes were used.
