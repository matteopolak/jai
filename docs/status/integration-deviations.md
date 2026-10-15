# Independent integration deviations audit

## Refresh-ten rejected SDL adapter

Bindings `fddae00` was inspected directly. Its RWFromFile proxy changes SDL-owned
native object identity and installs ordinary Jai callback pointers into an object
that native C clients would interpret as SDL_RWops. It is not safe native
interoperability; its BMP wrapper additionally fabricates a default callback
context with no reviewed capture policy. Integration rejects those two adapter
entries and retains direct foreign factory/BMP calls on actual SDL-owned native
pointers. No C receives a 48-byte Jai-created object from our supported helpers.
Custom/copy callback records remain outside the supported native ABI contract.
The safe WM-info adapter and other new binding work are retained. Generator
metadata is regenerated from this actual composition; proxy-only test successes
are not counted as production evidence. Exact reproducer/required owner action
are in integration-requests.md. Public RWops/UserEvent layout gaps remain visible.

## Native linking and test-oracle audit

- Production native dependency `xxhash070` was missing from
  `tools/native-libs.json`, despite the reviewed xxHash facade needing its 0.7.0
  state ABI. The default source-build manifest now includes the same hash-pinned
  official C inputs and license as the binding verifier. Host static/shared and
  Windows x64 MinGW static builds pass; the original allocation-memory interpreter
  fixture now passes. This does not establish native Windows execution or complete
  packaging of every other binding dependency.
- `tools/format_platform_io.py` invokes actual jailint with warnings denied on
  all positive owned files across four supported profiles and requires manifest
  coverage. Its one deliberately invalid input,
  `tests/platform-io/negative/windows-runtime-configuration-conflict.jai`, is
  separately required to exit 1 with the exact compiler rejection and no ordinary
  lint findings on both Windows CPUs. Its body cannot compile; no semantic-body
  coverage is claimed. All 42 positive owned files are covered. This narrow test
  classification preserves both the strict compiler diagnostic and positive lint
  gate; no rule or application privacy policy is disabled.
- The 2300-row `float-power-sweep.jai` is an auxiliary numerical oracle program,
  not an `ok`-output fixture. The portable runner now routes it to the mandatory
  exact-rational validator with a 300-second bound, retaining interpreter execution
  and native/WASI O0/O2 when selected. All five modes actually pass. Its former
  45-second generic-output failure is retained; no numeric assertion was weakened.

- `tools/native_bindings/config.py` incorrectly mapped the Windows private `gl`
  and `gdi` library tokens to nonexistent DLL/import-library names. The generator
  now selects opengl32/gdi32, retaining public foreign signatures and token names.
  Generated Windows sources pass regeneration/idempotence; public signed-wheel
  renderer fixtures now actually cross-link x64 O0/O2. These are PE builds, not
  Windows execution or ARM64 link/runtime evidence.
- `stdlib/Adpcm/module.jai` exported five aggregate field names as nonexistent
  module globals. Reviewed Adpcm lists these only as record members. Removing
  the invalid aliases retains every real public declaration and record field;
  both Windows no-DCE profiles pass and a negative public-scope regression is
  retained. This corrects the facade rather than inventing fake global storage.
- `tests/portable-stdlib/unmapping-allocator.jai` now uses a precise native C
  memset/signal oracle in each isolated fork child. Guarded intrinsics and foreign
  fault containment correctly turn invalid writes into interpreter errors, so
  they cannot serve as the native-signal oracle. Restoring default SIGBUS/SIGSEGV
  disposition only in the child preserves all original mandatory signal, lifetime,
  allocation-failure and concurrent cleanup assertions. Interpreter and native
  O0/O2 pass; separate compiler tests require guarded intrinsic errors.
- The native signal setup revealed macOS `POSIX.signal`'s reviewed three-argument
  declaration does not match the native two-argument C ABI. The fixture declares
  the official C ABI privately; it does not claim the public facade safe or fixed.
  Binding ownership/review must resolve a safe public adapter/diagnostic without
  guessing meanings for unknown parameters. This ABI gap remains visible.
- A local empty-C-argv runtime proposal was tested and saved under ignored own
  artifacts, then removed from the source tree because the active platform owner
  is implementing the interpreter hook fix. It is not production proof; zero-arg
  Windows startup remains a coordinator-reported failure pending that checkpoint.

## Production strict-lint field type correction

The merged producer IDE layout ordering fix was insufficient for
`tests/platform-io/layout-contract.jai`: actual jailint and a new production-library
Rust regression retained a circular INFO_SIZE dependency. Bare/type-qualified
`type_of(field)` was requesting the whole containing record layout. General field
type resolution now evaluates the declaration's annotation or inferred initializer
without requesting later field offsets, sharing the same type inference routine
with actual layout. Selected static branches and modified-struct declarations keep
their original scope. Inherited/generated members retain the existing resolver.
Genuine recursive sizes still reject. The original source/assertions remain intact;
155 units, 50 module, three layout and four IDE regressions pass. Temporary general
cycle tracing was removed before commit. Actual strict lint of the original layout
fixture now passes. No diagnostic, visibility or rule was suppressed.

Role: replacement integration worker. This report is open; merged snapshots do not imply completed stdlib support. Producer reports were read for compiler, portable stdlib, foundations, bindings, numerics, window/render, LSP and SDL3. Direct code inspection and combined-tree verification are in progress.

## Sixth approved refresh audit

Compiler 5d0bf33, portable 803f84a, foundations 49c937b, bindings b8e492b,
numerics 441385d, window 31ded39 and platform-io 658498a are merged separately.
Every changed producer handoff/status/deviation report was read; unchanged LSP/
SDL3 reports were already reviewed. The safe CI editor fix 767130b is merged.
New coordinator-reviewed Process/System/runtime contracts are preserved. Prior
fifth-refresh evidence below is historical, not proof of this combined snapshot.

- New interface validation resolved patterns in module scope, losing private
  contextual contracts. The actual unchanged formatter failed. An original
  non-Basic test fails before and passes afterward with default/valid/invalid
  bindings and preserved privacy. Pattern evaluation now uses declaring file
  scope; all 41 module and interface/variadic core cases pass. No API helper is
  exposed or library name checked.
- New mixed variadic lowering makes the original Process/Autorun prefix reproducer
  pass. Autorun's temporary argv assembly is removed; direct mixed packs pass
  real workspace child execution interpreter/native O2. The original assertions
  are promoted into the ordinary portable runner. Dynamic native packs still
  use caller storage/continuation retention as reported by the compiler producer;
  its standalone memcpy harness is not production runtime evidence.
- Private Windows Process verification formerly wrote a temporary public module
  into a staged stdlib. It now compiles the real engine through a permanent
  library-owned Process test entry; the superseded facade fixture is removed.
  Both Windows CPUs pass all-code checking without source mutation or relaxed
  application privacy. Public Windows Process adapters remain unimplemented;
  their newly reviewed shapes are now available to the active platform owner.
- The old Windows startup positive fixture conflicted with the configured runtime.
  Its complete source remains a required negative check on both CPUs. A proper
  library-owned backend entry checks actual startup independently. Latest review
  makes native crash backtraces x64-only and meaningful for system entry; ARM64
  now diagnoses that limitation and embedding does not enable a handler. Two
  production-library compiler tests pass, including explicit initializer use.
  Private SDK marshalling does not establish completed public crash-handler ABI.
- Native Windows command-line pointer storage now uses size_of(*u8), removing
  an unnecessary hardcoded eight-byte allocation multiplier. Wider System/
  Thread/native SEH behavior needs actual new CI; previous File/wheel CI results
  are scoped to its older candidate. CRT suspended-thread interpretation and
  event/OVERLAPPED interoperation remain genuine compiler requests.
- File's Wasm check remains an explicit File contract CI gate. The expanded
  platform runner supports selecting contract cases; omitted selection still
  runs all contracts. Unsupported System/Thread Wasm imports are not silently
  filtered from an all-case run. This preserves the original File gate while
  Windows native CI continues to request all platform contracts.
- MPEG currently supports real buffer/bit/VLC/pixel/IDCT operations only; demux/
  decode is unfinished. Its official MIT C algorithm input has a pinned SHA256,
  not a Jai implementation or API oracle. The upstream header remains byte-
  identical including whitespace; only that third-party header is excluded from
  owned-source whitespace checks. A qualified Basic constructor workaround,
  widened checked IDCT arithmetic and native contract questions remain reported.
  Its Windows test exclusion predates File completion and must be removed here.
- Native GL/AppKit source pins and context policies, widened IEEE norm arithmetic,
  font process-lifetime registries/borrowed data, retained root share context,
  incomplete Windows/Linux close cleanup and unsupported GL texture/debug routes
  remain as specified in producer reports. No fake metrics, texture or clipboard
  backend was introduced. Actual new host driver execution is required before
  accepting their staged results.
- The first removal of the private-process staging wrapper left a malformed
  Python finally indentation. py_compile and the runner failed explicitly; the
  failure is retained. The repaired runner passes host contracts/private source
  checking. No failed native/interpreter case is counted from the syntax-failing
  invocation. Lint still rejects incomplete compilation rather than accepting
  its quiet exit-zero behavior.

The inherited target matrix discovered only top-level modules, omitting four
nested public facades: Objective_C/AppKit, Android/AAudio, Android/EGL and
Gamepad/SDL_Input_Map. An original synthetic-directory regression failed before
the general recursive discovery fix and passes afterward. The actual seven-
profile unused-code matrix is rerun with these modules. Its old expected-error
inventory remains unchanged and failing rather than being expanded to bless
real failures. Only the canonical private implementation root is excluded from
application imports; its code remains checked through importing facades. This
is stronger coverage, not a production pass from the synthetic directory test.
The first standalone matrix overlapped a workspace invocation using the inherited
fixed scratch directory. No target source-read failure was observed, but those
matrix outputs are superseded by an isolated rerun. Scratch directories now
include the invoking process ID, preventing concurrent verification from deleting
another run's generated entries; assertions/expectations and coverage are intact.

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

The final numeric failure review caught an incomplete Windows font integration:
`loaded-fonts.jai` allowed Windows filename loading, but Simp's File import was
still Unix-only. Both guards now agree, with real File operations preserved.
The original editor all-code failure is retained; x64/arm64 editor and public
font all-code regressions now pass. The window runner adds these checks, rather
than relying on its earlier reachable-code-only source checks. One first runner
attempt selected the loaded font test fragment directly and failed its missing
imports; it is corrected to the existing complete font-public wrapper, with the
failure retained. Complete scoped lint and formatting pass; actual native
Windows FreeType/font execution is still required. No fixture module replaced
File/Simp/Input or native metrics/texture storage.

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
# Refresh-nine safety finding: interpreter memory intrinsics

`crates/jaic/src/interp/mod.rs` still used unchecked host `ptr::copy` and
`write_bytes` for interpreted memcpy/memset after only a null-address check.
`interp/probe.rs::compare` ordered unreadable ranges as ordinary byte values.
An original child-isolated mmap/mprotect regression against combined production
sources reproduced signal 10 for both writes/copies and a fabricated -1 comparison
(`artifacts/integration-clean/memory-intrinsics-red.log`). This can crash the
compiler and misrepresent invalid program memory. The required general fix is
bounded fault-safe copying/filling/comparison through the existing kernel backend,
with explicit interpreter errors and overlap-preserving copy semantics. Implemented
using 4 KiB scratch buffers and the existing kernel transfer backend. All 155 core
unit tests now pass, including child-isolated protected transfers, unchanged
mmap/mprotect regressions, overlapping multi-chunk copies and zero-length calls.
The Windows VirtualProtect branch is present but awaits actual Windows CI.
Kernel transfers add system-call overhead per chunk; benchmark/optimize batching
without reinstating unchecked copies. Prior guarded-probe tests alone did not
establish intrinsic safety. `read_vec` also uses fallible capacity reservation;
this is not a guarantee against physical-memory exhaustion.

The merged strict module-argument check initially reported a missing required
argument before an unknown supplied name. General validation now declares the
complete header, validates supplied names/duplicates, then rejects omitted ordinary
parameters; late program parameters remain supported. All 50 module regressions
and both production runtime configuration regressions pass without test changes.
