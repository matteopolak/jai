# Independent integration deviations audit

Role: replacement integration worker. This report is open; merged snapshots do not imply completed stdlib support. Producer reports were read for compiler, portable stdlib, foundations, bindings, numerics, window/render, LSP and SDL3. Direct code inspection and combined-tree verification are in progress.

| Location | Observable effect / rationale | Evidence and risk | Proper fix |
| --- | --- | --- | --- |
| Producer test overlays and numerics tool bootstrap helpers | Reported passes use independently staged peer sources; numerics includes fixture Input/Window/Hash and host tool helpers. These are not integrated production proof. | Producer handoffs/status documents. Snapshot drift and ABI/identity errors can escape those passes. | Run unchanged tools and canonical-dependency suites against this production tree; retain staging evidence separately. |
| `stdlib/SDL/declarations.jai` | Reviewed public RWops/UserEvent shapes differ from native SDK storage. | Bindings report records 48/8-byte public versus 72/32-byte native records; active layout test remains failing. Undersized foreign calls risk memory corruption. | Complete private native storage and safe marshalling/diagnostics while preserving public contracts. Audit every affected foreign call. |
| Native binding aggregate layouts and open wrappers | D3D/ImGui/Darwin/rpmalloc ABI gaps and incomplete GL/X11/Objective-C/mobile/telemetry helpers remain. | `status/bindings-deviations.md` and declaration ledger. Emitted declarations do not prove ABI safety or runtime support. | Resolve reviewed shapes, implement complete forwarding/adapters and run pinned native probes on each target. |
| Basic formatting/configuration | Style-storage choice, missing generic-default reflection, unresolved rendering details, libc shortest-float search and ENABLE_ASSERT propagation remain. | `status/foundations-deviations.md`; latest Basic reviewed parameters need independent integration. Layout mismatch, locale/race/performance and incomplete compatibility risks. | Propagate reviewed parameters generally, emit real reflection defaults, resolve questions and improve measured conversion. |
| Portable runtime/platform modules | Native crash helper is pinned for process lifetime, build-tree deployment unverified, signal/alternate-stack ownership not restored; optimized allocator/platform/contract gaps remain. | `status/stdlib-deviations.md`, portable ledger/gaps. Existing staging tests do not verify packaging or all platforms. | Package relocatable native helper, review lifetime/ownership, implement missing branches and execute native targets. |
| `stdlib/internal/numerics` and UI facades | Missing concrete font/texture integration is diagnosed; current contextual types and editor sampling copies require audit. Rank-deficient math/UI/text/cursor/clipboard limitations remain. | `status/numerics.md`, corrective plan; fixture tests do not prove canonical integration. | Use combined Input/Window/Hash/Simp canonical types, real font metrics/texture ownership; retain explicit unsupported diagnostics pending contracts. |
| Window/render backends | GL constructors/framebuffer rendering and native Linux GUI/device/Windows tests remain incomplete. | `window-render-handoff.md`, coverage ledger. Physical hardware behavior cannot be established by typechecks. | Implement reviewed missing contracts and execute real native/device tests. |
| IDE recovery and verification | Fresh unterminated opaque regions are conservative; malformed statements are omitted only in IDE mode. Producer corpus has baseline errors despite passing edit probes. | `tools/lsp-validation-0171.md`. Recovery success is not application typecheck success. | Preserve strict compiler diagnostics and separate IDE selected-source admission; rerun against combined code. |
| SDL3 target coverage | Real native arm64 macOS evidence only; five native platforms/device APIs and integrated formatting pending. | `plans/sdl3-work-log.md`. Cross-layout checks are not runtime verification. | Build pinned native dependencies and execute all CI targets; run real integrated tools and normalized regeneration. |
| Full original public corpus | Local vendor implementations are opaque/forbidden inputs; original full-corpus verification cannot run here. | Explicit isolation instruction. Omitting vendor-free staging or claiming full pass would hide compatibility gaps. | Coordinator runs original corpus externally, returns filtered failures/minimal independent reproducers; local permitted staging records provenance. |
| Native verification / release | Windows, macOS x64 and hardware runtime unavailable locally; Focus manual acceptance outstanding. | No CI dispatched or releases modified here. | Coordinator reviews temporary `codex/cleanroom-integration` CI, executes real targets and Focus acceptance before v0.17.1. |

Avoidable integration workarounds will be removed and recorded with original reproducer and fresh results. This audit does not claim that no other deviations remain.

## Refreshed production checkpoints

The compiler, portable, numerics and window/render checkpoints in
`docs/integration-refresh.json` are merged. Earlier findings below remain historical
evidence and are superseded only where stated here.

- Binary32 intrinsic interpretation was decoding operands as binary64. A direct
  `sqrt(float32(9))` reproducer failed before the fix. Interpreter operations now
  use the IR result width; semantic checking rejects inconsistent unary signatures.
  Five Math promotion wrappers were removed in favor of real float32 intrinsics.
  The direct test passes interpreter/native O0/O2. This removes the precision and
  performance workaround without inventing an additional public intrinsic name.
- Reflected struct alignment was zero although layout knew the correct value.
  `sema/typeinfo.rs` now exports completed layout alignment; ordinary, packed,
  aligned and generic regression cases pass. Original Deep_Copy graph assertions
  pass interpreter/native O0/O2 and are promoted into the ordinary portable suite.
  Deep_Copy policy gaps in `docs/portable-deep-copy.md` still apply.
- Numerics now uses canonical Simp font/texture/effect identities, real font fields
  and texture storage, and implements Type_Indicator alternatives. Canonical
  production checks improve from 8/60 to 40/83; the expanded suite still fails for
  absent AppKit, unsupported target backends and Wasm libc formatting imports.
  Its native NSCursor identity and platform paths require further binding audit.
- Real compiler atomics replace the prior integration gap. Five focused core and
  four LLVM tests pass, including native O0/O2 and Wasm shared-memory contention.
  Sequentially consistent implementations may exceed requested weaker ordering;
  this is a documented performance policy, not a lock-free guarantee on every ABI.
- Public Windows wheel propagation now passes Windows x64 all-code typechecking.
  Native execution on x64/arm64 remains required. New private helper fixtures
  outside library-owned test directories fail strict privacy; move those tests or
  exercise public APIs rather than weakening imports.
- Reviewed POSIX.itimerval macOS x64/Android x64 shapes were regenerated with the
  actual formatter. macOS x64 then fails unknown timeval: its inventory says x64
  but the supplied shape section is ARM64-only. No cross-architecture layout is
  guessed. AppKit remains absent from the committed bindings snapshot.
- Four new portable modules increase declaration presence; Atomics, BuildCpp,
  Deep_Copy and Zip_File_Directory are not counted complete merely by presence.
- The original full-corpus and unavailable native/device verification remain
  coordinator work. Latest guidance makes human Focus acceptance optional;
  coordinator Focus build/launch and signed-wheel testing are still required.
  Release workflow execution/publication remains on hold.
- Direct inspection found Unix probe descriptors leaked at probing-thread exit,
  and failed fcntl setup was ignored. The per-thread channel now closes through
  ownership cleanup; failed nonblocking/close-on-exec setup closes both ends and
  rejects the transfer. Linux source compilation and native macOS protection tests
  are checked separately; Linux execution remains external verification.
- IDE facade aliases were classified as constants even after resolving to an
  overload set. Completion now classifies resolved procedure values/sets correctly
  and resolves simple exported aliases with normal compiler visibility checks.
  An independent alias regression fails before/passes after; the semantic suite
  improves from three failures to one. Querying facade metadata may resolve more
  aliases than before; partial-edit timing is checked without changing coverage.

## Direct audit findings and corrections

### Second refresh and source audit

- Compiler ec7e23e, foundations 44cca8b, portable 04205ed and window e7e719a
  are integrated. Context cleanup's runtime slots and stable deferred boundaries
  replace the earlier compile-time pointer selection. The merge retains IDE-only
  independent-statement recovery and strict compilation failures; no invalid
  recovered body becomes executable. Nine core context and one native/Wasm O0/O2
  backend regressions pass after scratch initialization correction (8cfb5a7).
- Reflection hiding procedure member types lost the required 0x8 marker. The
  source/member type is now retained and only the descriptor type is hidden;
  metadata keeps the marker and real storage offset. Focused red/green regression
  and the original procedure fixture pass. Canonical GL driver execution is still
  blocked by AppKit; it is not counted as verified by the marker test.
- Foundations now implements default ENABLE_ASSERT=true, conditional nested Buffer
  layout, assert discard and temporary overwrite stamping. Exact original integer
  arithmetic replaces libc numeric formatting/parsing on all targets. Deliberate
  shortest-float precision searching and limb allocations cost performance;
  stamping a retained page's unused tail may add bandwidth. These costs and
  remaining style-storage/punctuation/scan contracts are preserved in the producer
  deviations report. REPLACEMENT_INTERFACE/enabled debugging remain unfinished,
  although the latest contract is specified; the old missing-shape diagnostic is
  stale and must be replaced by real implementation, not treated as an oracle gap.
- The foundation checkpoint depends on generic parameter-default metadata absent
  from the committed compiler checkpoint. Production assertions fail in two
  positive tests, including native/Wasm. No empty/default metadata is fabricated.
  WASI executes 34/38 O0/O2 checks with real WASI imports only; the four failures
  are those two metadata cases. Producer 19/19 staged claims are not production
  proof for this snapshot.
- Nonverbose jailint can return zero after incomplete compilation. The foundation
  runner now requires verbose complete compilation and exposes three Windows-only
  files compiled as macOS roots. Full integrated lint retains these failures.
  No tool-only library patch, rule suppression or positive-suite deletion is used.
- Mail unnecessarily requested a second executable startup configuration just to
  use one_time_init. It now imports the configured runtime normally. Real loopback
  SMTP/MIME plain/HTML/auth/reject/TLS cases pass interpreter/native (ten cases).
  Explicit application runtime-flag conflicts remain diagnosed and questioned.
- Treemap has real stable buckets, weight traversal and squarified geometry.
  Zero default borders/east-north/half-open flush policy were chosen before review;
  latest specs now settle these and require an owner conformance update. Same-count
  weight changes still require display dirty/force; deep traversal is recursive.
- Cocoa native event pumping/notification observers are real; observers and
  cursor-policy registries retain process lifetime without public teardown. Raw
  committed text is supported policy; IME composition is outside the reviewed API,
  not a missing compatibility promise. Drag/drop/touch and other platform paths
  remain unfinished. Glyph-atlas kernel uses actual FreeType coverage/metrics,
  but public Dynamic_Font ownership/layout and GPU text rendering remain absent.
- Two additional private-helper fixtures were moved into library-owned test
  directories. Actual driver tests remain enabled. The production window runner
  aggregates failures and never executes a stale binary after failed compilation.
- New scope contains 100 of 135 module/bootstrap facades, 35 absent plus one
  supporting constant-table page. Presence is only a declaration inventory;
  it does not count complete modules or imply runtime/ABI conformance.

- Removed the bundled-module unknown-parameter exemption in `crates/jaic/src/sema/modules.rs` and added general named/positional validation, including parameterless modules. Removed the fourth public Runtime_Support parameter; the build option remains a compiler target constant. Explicit runtime arguments no longer disappear. Original regressions failed before correction; all 39 module regressions pass afterward.
- `interp/probe.rs` cached mapping checks previously preceded raw copies/slice reads. Strengthening the original mmap/mprotect test to omit manual invalidation reproduced SIGBUS. Actual transfers now use Mach APIs, kernel pipe copying, Windows process-memory APIs or bounds-checked Wasm memory. All five probe tests pass. Comparison now snapshots both ranges, with allocation/copy overhead rather than unchecked in-place slices; this is a deliberate safety tradeoff. Windows/Linux native execution remains CI-required; mapping/protection changes may produce partial failed transfers, never a claimed atomic snapshot. Proper optimization: measured fault-safe chunked transfer without losing invalid-range ordering.
- IDE admission is now restricted to the exact explicitly selected source entry. Application internal imports and strict CLI entry rejection remain tested; no blanket source-policy weakening.
- Direct source audit confirms unresolved GetRect contextual empty records in `internal/numerics/render_types/module.jai`, absent Type_Indicator parameter, and metric/require_texture traps. Latest reviewed specs now provide Simp contextual identities; these are avoidable gaps, requested from numerics owner, not accepted functionality.
- Combined canonical numerics suite: 8/60 checks pass. Precision diagnostics, missing AppKit/unsupported Wasm Window_Type, and native C formatting imports are retained as failures. Foundations host runtime/format/lint passes, macOS x64 unused-code fails missing POSIX.itimerval. No platform skip list was changed.

- Original stdlib runner contained stale skip-list entries and aborted before available fixtures. It now retains each as a fatal inventory error and executes all 473 available tests first. Result: interpreter 258 pass/215 fail; native 250 pass/215 fail/eight compile-time-only. No skip entry/assertion/coverage was removed.
- Source-built quality check formatted and checked all 493 integrated new Jai files successfully. Verbose warnings-denied lint has 37/136 failed directory checks, mostly unsupported host targets, incomplete source inclusion and real API gaps; failures are retained in quality.json. No exit-zero partial compilation is counted as clean. Direct thread lint findings were corrected: unused CAS-success outputs for atomic reads are explicit discarded bindings, shutdown is documented idempotent, and duplicate thread-completion recording now asserts. Real thread lifetime/group/condition/shutdown tests pass interpreter/native.
- Bindings production runner now supports --stdlib with no peer staging, and records source/tool hashes. Full desktop/source/API sweep has 57 failed/unimplemented checks; alternatives/mobile configuration sweep has 58 failures. Unsupported-target results remain separate and are not runtime passes.
- SDL3 real integrated host tests pass ABI/headless/callback/entry, all 1,329 runtime exports and artifact hashes; GPU audit checks 95 exports, not GPU execution. Eighteen Python tests pass after creating their documented scratch parent. Regeneration currently detects stale contracts-macos-x64.jsonl; this remains open rather than accepting drift.
- Canonical Bootstrap Preload alias maps to prelude/module.jai. Inventory: 135 module spec pages plus one supporting table page; 95 module/bootstrap entries present, 40 missing. Presence never implies completed functionality.
