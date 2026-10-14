# Independent integration deviations audit

Role: replacement integration worker. This report is open; merged snapshots do not imply completed stdlib support. Producer reports were read for compiler, portable stdlib, foundations, bindings, numerics, window/render, LSP and SDL3. Direct code inspection and combined-tree verification are in progress.

The whole-tree lint finding in `internal/net/socket.jai:check_fd_set` exposed an
unused destination pointer and acceptance of null sets. A new original fixture
fails before the fix. Validation now requires a nonnull destination as well as
the descriptor range; FD_ISSET returns zero for null instead of reading it, and
mutators retain their assertion. Descriptor-edge/null/bit operations pass
interpreter/native O0/O2 and scoped warnings-denied lint. Names/signatures are
unchanged; no warning suppression or dummy parameter read was added. This is
independently chosen defensive validation where the reviewed inventory leaves
invalid-pointer behavior unspecified, not evidence of any reference body.

Browser fixture corrections are documented with exact API reasons in
tools/legacy-contract-audit.md. No logger/Thread/IDE assertion was disabled.
Initial corrections used invalid foreign-variable syntax; those failing runs
are retained, and the compiler's supported #elsewhere syntax is used. C bridge
coverage does not claim POSIX or Basic.exit support on Wasm. Whole-tree quality
606-source run is stable and retains 34/152 failed checks; the earlier run that
raced a source edit is explicitly not stable. Subsequent Socket scope lint
supersedes its one ordinary warning, not the incomplete-compilation failures.

## Production boundary correction and fifth refresh

Filtered coordinator CI feedback for candidate 159ca65 records real Windows
x64/arm64 File interpreter/native O0/O2 and signed-wheel interpreter/native
passes. The overall Windows workflow failed; Process/Thread/System/crash and
other module gaps remain. The reviewed CI candidate is merged with each File
step placed before the broad test commands. No run was dispatched here, and
these results do not establish native rendering/font/Focus compatibility.

The formatter fuzz replay exposed File selecting POSIX on Wasm. The POSIX guard
remains strict. `internal/files/wasi-libc/module.jai` declares the existing
preserved WASI extension's opaque C stream/directory ABI. Shared stream code
selects that private boundary on Wasm; it uses actual directory open/close to
verify an already-existing directory without assuming a host stat layout.
Effect/tradeoff: existence checks require readable directory capabilities and
one extra open/close, returning false if verification/cleanup fails. This is a
documented supported capability limit; a direct stat adapter could avoid those
extra operations if profiling or clarified contracts require it. The unchanged
File fixture passes Wasm interpreter and actual WASI O0/O2; formatter saved
regressions pass. New sources pass actual repository format/check and complete
jailint warnings denied. Normal CI now runs this File Wasm gate; no fake host
imports, Extensions edits or missing-import traps were used.

The crash/startup Python runner still implicitly copied `Compiler` and
`internal/compiler-api` from a sibling NEW compiler worker when given a production
stdlib. The isolated sanitized worktree exposed that read/copy assumption. Earlier
aggregate startup passes are not accepted as proof of a run without overlays.
The three previously noticed changed files matched approved compiler 890329b when
audited, but the tool did not pin or hash the sibling snapshot. No quarantined/
reference source was accessed; this was unapproved NEW-source staging. Both copies
and the default sibling-path option are removed. A nonmutation regression passes,
and actual ON/OFF native crash checks pass with the integrated facades alone.
The complete portable runner then passes 95/95 plus real fault/rejection/SMTP/
channel/startup checks without overlays. The mocked unit test proves only input
nonmutation; it is not native/runtime support evidence.

Approved portable c8d1f5d, foundations a11c0c8 and platform-io eb5d83d are merged
in a second sanitized worktree while the previous 558-file sweep remained frozen.
The sweep completed 14,835 edits/2,600,590 assertions with the same startup failure.

- Autorun uses real COMPLETE/workspace execution and errors. A transient argv
  array works around the compiler's lost mixed scalar/spread variadic prefix;
  original repro remains failing. CLI plugin orchestration calls an unreviewed
  helper and remains incomplete. Proper fix: general variadic segment binding and
  separately designed internal plugin orchestration, not invented public exports.
- Basic has all five parameters, real live allocation/heap ownership and exact
  replacement hooks. Metadata lookup is linear; raw default allocations avoid
  recursive instrumentation; temporary bump objects are not individually tracked.
  Unknown frees from other Basic configurations are allowed. Visualization is a
  real logger snapshot/counter transport, not a native GUI/remote protocol. Wider
  leak scanning, raw/runtime allocation coverage and reviewed transport remain open.
- Module-parameter defaults incorrectly resolved in the module namespace, losing
  file-private helpers. A new original non-Basic regression fails before and all
  40 module cases pass after binding expression homes to the declaring file.
  Basic's contextual constraint alias is now file-private as reviewed. Its old
  positive fixture incorrectly accessed that private name; privacy assertions and
  a rejection fixture replace that access while selected public Hooks identity
  and every allocation/callback assertion remain. Unused structural interface
  validation is still a real failing mandatory gate; no library-name check added.
- File has actual Win32 UTF-16 handles, 64-bit seek/read/write, mappings and checked
  cleanup retry, with shared convenience code over native backends. Host interpreter/
  O0/O2 and Windows x64/arm64 all-code checks pass. No Windows runtime claim. Native
  path namespace/length, known-folder identity and borrowed-wrapper policies remain
  independently chosen as recorded in platform-io questions/deviations.
- Windows font filename loading now delegates to the real File backend; its stale
  unsupported guard is removed for Windows. x64/arm64 all-code tests pass; native
  Windows FreeType/font execution remains required. Window runner now passes all
  128 source/program invocations; this includes target checks, not 128 native runs.
- One numerics run used the host's Python 3.9 and could not generate its cbrt oracle.
  Failure evidence is retained. Rerunning with installed Python 3.15 gives 107/123;
  no oracle approximation or assertion change was introduced.

Latest checkpoints: compiler 890329b, portable 8a0d40c, foundations 44cca8b,
bindings a565ab0, numerics 4acc846 and window 7fc1d6a are merged. Generic
metadata now unblocks all 24 host/19 WASI foundation cases at O0/O2; portable
production passes 92/92 ordinary cases plus faults/rejections and real SMTP/
shared-channel/process/startup integration. Real AppKit, window/event/clipboard
and GL texture/shader host tests pass. Safe caller-owned SDL2 RWops marshalling,
full lint/platform support, genuine compiler/IDE failures and opaque external
corpus remain open. Earlier rows below describe initial historical findings;
explicit refresh sections supersede resolved entries.

Correction: Basic.log is explicitly reviewed and missing. Its failing legacy
tests are genuine coverage; it is not an unreviewed convenience. Only stale
implementation-location assertions have been migrated, preserving both overload
and re-export navigation assertions. The latter reveals a separate real recovery
failure, retained in requests.

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
| Native verification / release | Windows, macOS x64 and hardware runtime unavailable locally; coordinator Focus checks outstanding, human review optional. | No CI dispatched or releases modified here; publication is on hold. | Coordinator reviews temporary branch CI, executes real targets and Focus checks before any publication decision. |

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

### Third refresh

- Approved compiler 890329b supplies canonical shared source generic descriptors
  and evaluated instance defaults. Required/unbound shared defaults retain explicit
  null type/-1 offset; instance defaults evaluate real prior bindings. This is an
  independent encoding using existing fields, awaiting compatibility review.
  It adds read-only metadata storage; failures propagate rather than dropping
  arguments. All foundation metadata/default-elision assertions now pass.
- Performance reports carry actual host timings, run/polymorph records and IR
  counts. This compiler has no bytecode inlining/dedup pass, so those transformation
  counts are zero. Anonymous run thunks may have null headers; actual wasm32 compiler
  hosts reject unavailable timing rather than manufacture durations. Browser clock
  support and anonymous-callee contract remain open.
- Unix shared-memory channels use real POSIX objects/native atomic storage, checked
  native mapping extent and captured creator allocator. All four interpreter/native
  process pairings pass 2,048 byte-checked packets each. Windows is unsupported;
  Linux execution, wire-format compatibility, pause/reconnect and failed-cleanup
  retry policies remain unverified. Absolute cursors, eight-byte framing/alignment,
  256-byte header and logical-size/name policies are independently selected and
  documented in portable-shared-memory.md. No original-wire interoperability claim.
- Shared-channel early failed producer tests left two unjournaled PID-named OS
  objects. Later tests journal/unlink only proven owned names and check cleanup;
  no global namespace sweep was attempted. Historical objects are not claimed gone.
- The runtime storage fixture is split into a positive configured-instance test
  and the complete original conflicting-import source as a required negative case.
  All original storage assertions remain. This corrects startup configuration
  alignment without silently accepting conflicting flags or claiming alternate
  runtime-instance behavior is specified.
- The new exchange-contention unit test was updated for the integrated intrinsic
  dispatch signature's floating-result metadata argument. Its full prior-value
  sum assertion and all 80,000 exchanges remain unchanged; no test overlay repair.
- Current presence is 101/135 facades, 34 absent, plus one constant-table supplement.
  Integration-certified complete modules: zero; this worker has not certified all
  reviewed behaviors/targets of any module. Supported subsets are measured by the
  actual suites, never by export counts or staged passes.

### Fourth refresh: native integration

- Bindings a565ab0, numerics 4acc846 and window 7fc1d6a are merged. AppKit, GLX
  constructors, public native windows, Keymap, shaders and mipmaps are real code.
  Numerics fixture Input/Window/Hash modules, duplicate Windows clipboard and
  formatter repair helpers are deleted. Canonical numerics passes 107/123.
- All 14 exercised macOS window cases pass interpreter/native O0/O2, including
  windows/events, clipboard, glyph coverage, texture upload/readback and shaders.
  Linux-target interpreter cases pass; Linux X server/GLX/device execution remains
  unavailable. Windows failures remain at the genuine File backend dependency.
- The staged compiler/patch path is removed. window_render_compiler.py builds this
  integrated checkout directly; staged repairs are not production evidence.
- SDL WM-info marshals complete private native storage into the exact public
  prefix, rejecting unrepresentable subsystems with real SDL errors and leaving
  failed output untouched. Adapter address differs from native-symbol address:
  an explicit safety tradeoff. Real canary/error/hidden-window tests pass. The new
  native SDK probe was omitted from the build selector; integration registers its
  pinned source closure, builds it and moves the private test under SDL/tests.
  Original ABI assertions are unchanged. Native test dependencies now use explicit
  library directories rather than worker-specific .work paths.
- SDL2 layout still fails RWops 48/72 and UserEvent 8/32. Caller-owned RWops and
  callback marshalling remain unsafe/unfinished; WM-info does not resolve them.
  Objective-C/AppKit host native tests pass. SetTitle's id/native-void result is
  unspecified as reviewed; no stable value is claimed. Provisional D3D/Darwin/
  ImGui/rpmalloc layouts and other native branches remain risks in the binding ledger.
- Direct audit: x11-events.jai uses a 64-byte XLookupString buffer and publishes
  non-control bytes as code points, a limited legacy-byte input path. Its
  set_custom_cursor_handling body performs no operation; the flag has no effect
  on Linux. Proper fixes are real native committed-text/context and cursor policy
  integration, followed by Linux runtime tests.
- Direct audit: gl-shaders.jai always prepends desktop GLSL 330; reviewed GLES
  300 es remains absent. Windows File/font support and reviewed retained-memory
  font/cache/atlas lifetimes are unfinished. Real glyph-kernel/GPU-driver passes
  do not establish public Dynamic_Font text rendering.
- Broad bindings retain 65 failed/unimplemented desktop and 58 alternative/mobile
  checks. Thirty-five Python tests pass. Symbols/cross-layout/GPU-export checks
  are not native/device execution.

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
