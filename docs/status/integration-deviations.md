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

## Combined refresh eleven audit

- Runtime initializer previously forwarded the prelude constant instead of consuming finalized workspace size. Production allocation.jai rejected nondefault configuration before the fix (artifacts/runtime-config-production-red.log). The canonical internal/runtime now uses the private getter once for size/allocation, retaining cleanup/null/overflow behavior and exactly three public Runtime_Support parameters. Actual production interpreter/native O0/O2 and independently configured zero/131072 child allocations pass the CLI regression; staged overlays are not this evidence.
- Portable plist/Meow/bundle runners implicitly depended on repaired library overlays and peer directories. Removed those dependencies: explicit --jaic/--stdlib selects the combined production tree; their actual native execution is mandatory in the portable native suite on supported hosts. Earlier staging passes remain historical.
- SDL native-pointer proxy identified in refresh ten is removed by bindings 40e37e9. Actual native factory/BMP symbol identity and C observer lifetime assertions replace unsupported proxy callback assumptions. Public RWops 48/native72 and UserEvent8/native32 mismatches remain active unresolved ABI failures. Native regression rerun pending.
- SIMD internal/simd/lanes.jai still writes all-one comparison masks and extracts sign bits; latest reviewed SIMD contract requires scalar bool conversion and truthy-lane masks. Missing load/gather/scatter/looping/horizontal-add contracts are now specified. Owner request recorded; present facade does not establish complete compatibility.
- Compiler managed Windows thread creation ignores nonzero stack/security arguments and unknown flags. Default ordinary thread cases are not evidence for these inputs. Proper fix is actual native option handling or explicit unsupported diagnostics, preserving public signatures. Native CI thread output remains a separate real failure.
- Private ARM64 crash backend is now native-CI verified in twelve OFF/ON/default O0/O2 cases at e8c312d, not inferred from cross-compilation. x64 ON/default fault reports still fail, WGL shared lifecycle still fails, ARM64 real driver is OpenGL1.1 and cannot satisfy3.3; no driver substitution or skip-as-pass is acceptable.
- Linux ARM64 stat wrappers now explicitly marshal pinned128-byte kernel records into the reviewed144-byte public record. Raw x64 syscall constants remain unusable on ARM64. No local Linux execution; record-copy cost and untouched-output native-error behavior need actual Linux CI. Android target support, ImGui remaining layouts, X11 runtime and mobile native SDK execution remain incomplete as detailed by producer reports.

## Refresh twelve producer audit

- File_Watcher31e453e uses real native FSEvents callback queues and SDK-owned contexts, retaining the active public FSEventStreamContext ABI failure. Queue caps, overflow-rescan behavior, trailing-edge debounce, borrowed callback paths, by-value teardown and no recursive teardown/polling are independently chosen policies pending review. macOS only; Linux/Windows imports reject. Native helper relocation/cross-architecture packaging remains unfinished. Its runner's implicit peer/staged overlays must be removed before integrated proof.
- Window37d3839 replaces retiring Mesa drawables with actual native retirement windows/DCs of the exact pixel format. One share-owner surface/context is process-lived; each live renderer adds native handles. Cross-thread destruction and foreign HWND lifecycle remain gaps. ARM64 Mesa source builder is only plan/source-integrity verified here; native driver build/execution remains required. No3.3 fallback or fake GL claim.
- Platform2cdbd9b adds unique x64 DbgHelp sessions and checked private cleanup, original native lifecycle/first-step/named-symbol tests and exact own-output diagnostics. External DbgHelp/filter/error-mode changes require application serialization. x64 trace failure and real interpreter kernel-thread-handle interoperability remain unresolved; new cross-links are not native proof.
- Bindings4137f3c X11 dialog uses fixed geometry/core-font rendering and independently chosen Escape/WM-close policies; long text/accessibility/Unicode shaping and Linux actual execution remain gaps. DXC reflection has a real COM body but D3D12 forward-overlay failures prevent validating it; source declarations/C++ buffer probes are not completed Jai functionality.
- Developer-toolsa553de2: Generate_C_Header supports a documented C11 subset and rejects unsupported reflection shapes. Some emitted layout errors are deferred to mandatory C static assertions; transactional writes, String/Any projections and C++ output remain unfinished. Performance_Report uses actual compiler reports, independent rendering and quadratic stable sorting; actual-Wasm-host timing unsupported. Remaining eight owned modules are absent, not completed.
- Audio7d641f8 originally duplicated portable records/topology/accumulator and exported an unreviewed VBAP helper. Integration retains canonical generated records and one storage instance, adds the reviewed Cached_Ogg_Decoder shape, preserves sample null/bounds diagnostics and magic helper, and hides the new private VBAP helper. Panning tests use the public equivalent with all gain/identity assertions retained. Removed duplicate types unit.
- Audio's provisional squared/clamped gain curve contradicts latest reviewed sound-player.md. Original new0.5 regression failed; proper power-law formula now passes. set_master_volume no longer invents a nonnegative/finite restriction. The480-frame gain ramp is replaced with the reviewed1/30-per-second bound using actual private backend sample rate; uninitialized backend diagnoses rather than fabricating a sample rate. Device initialization has not been implemented, so update_panning backend integration is unfinished and is not counted supported playback. Controlled PCM mixing/panning remain a subset. Final-page clamp, no_overflow behavior, quaternion normalization, channel/mix-level integration and compressed/device lifecycles still need review/implementation. No audible output or all-target runtime proof exists.
## Refresh eleven executed follow-up

- The first full workspace run stopped compiling a new jailint regression because its Options initializer omitted the integrated target/source fields. Added explicit unset/empty options without changing assertions. The restarted suite executes all targets: aggregate697 passed/57 failed/one inherited ignored (includes child-process test output; see raw own log, not a unique-case count),12 failing targets. One failure was a stale expectation that canonical runtime sizes still reject; corrected it to require successful metadata/configured checks, retaining actual allocation and old-consumer rejection suites. Focused plugin/private-lint regressions now pass.
- Strict foundation lint now checks the native-unix #load fragment through its actual File parent, requiring checked-files coverage; this preserves Seek_Type and module identity without changing source imports. The cross-only predicate is checked on cross profiles. One deliberately binding-invalid scalar fixture must separately fail strict lint with its exact diagnostic; its body is not claimed checked. Current source still fails an unused basic-context side-effect import, corrected by the newest pending foundation snapshot. Behavior-only suite passes42 host cases in interpreter/nativeO0/O2,33 WASI casesO0/O2, misuse faults and seven target profiles; this does not replace the lint gate.
- Windows device decoding fixture loaded private internals from application scope. Moved it to stdlib/Input/tests and kept all original packet/callback/bounds assertions. Cross-host Windows interpreter execution then correctly failed unavailable CommandLineToArgvW. Pure packet assertions now execute via #run under each actual target layout, with real Windows program checks retained. This is compile-time decoding evidence, not Windows startup/device execution. Native notifications and issue1 tests remain separate real-Windows gates.
- A renderer attempt used target/window-render-native instead of the builder's actual target/window-native directory. Corrected invocation restores real host codec/clipboard/GL checks. Failed invocation retained; it is not attributed to production implementation.

## Refresh twelve verification refinements

- Actual unchanged jaifmt rebuilt against the combined production library.835 new/changed Jai sources passed format check before relocating the SDL fixture; that fixture separately passes format and strict lint. Workspace clippy/all-targets and actual wasm32 clippy pass; rustfmt exposed one integration runtime test, now formatted.
- SDL3 anonymous aggregate locations used Clang slash paths against Python native Windows paths. A new cross-separator original unit test failed before general normalization; all20 SDL3 Python tests and six-profile generation/idempotence checks now pass, retaining all1486/1488 layout assertions. Native Windows CI rerun remains required.
- SDL RWops regression also needed library-owned placement for private native ABI helpers. Removed its repaired .work library path and select the actual source-built native probe through JAIC_NATIVE_LIBS. Replaced opaque abort checks with the same diagnostic assertions. An initial interpreted run exposed a relative fixture path dependent on program working directory; the test now requires an explicit absolute argument and owns its C string. Actual interpreter/native/default and O2 factory identity, BMP, close observer, error and freesrc checks pass. Full SDK aggregate remains red for original public RWops48/native72 and UserEvent8/native32 assertions; no layout gate was removed.
- Source-built production WASI runtime allocation now executes and passes O0/O2: workspace65536-byte storage, original extent/data identity and last-byte write. This supersedes earlier statements that only a staged backend getter ran under WASM.
- The full portable sweep reports133/134 ordinary cases passing, all10 SMTP/TLS cases and four2048-packet process pairings pass. The plist fixture now prints supported real values; corrected its expected parsed dictionary instead of ignoring extra entries. Its independent plist/native bundle tests already pass. The2300-case interpreter oracle exceeded300 seconds under simultaneous debug suites; retain that failure and rerun with a source-built optimized compiler without dropping interpreter coverage or numerical predicates.
- Windows Shared_Memory_Channel and Socket public backends remain missing and fail the target matrix. File-visitation's symlink oracle uses POSIX.syslink and is Unix-only; Windows filesystem behavior remains required through windows-foundations and native platform CI. That single fixture is not counted as Windows behavior. Full module/target tests retain real missing-backend failures.
- Six skip-list rows named nonexistent files: GetRect_LeftHanded/tests/{geometry-tests,legacy-compatibility-tests,text-interaction-tests}, Simp/tests/{readback-tests,software-render-tests}, Sound_Player/tests/offline-mix. They are absent from the permitted independent baseline and current tree, and the runner reported each invalid ID. Removed these phantom inventory entries only; no actual test, assertion or skip was deleted. All480 original behavior cases remain required; earlier error evidence retained.
- The first refresh12 broad quality invocation enumerated an old moved SDL fixture from HEAD and failed its missing path; it is not a source-format pass. Freeze/commit current paths before retrying. Broad host-only lint still cannot establish target-specific/private fragment coverage; strict target-aware positive subsets and every real failure remain separate.
- An accidental all-lines LSP sweep was stopped after its first four completed files, retaining its partial log; it is not a full pass. The complete639-file sweep uses the established8 sampled nonempty lines per file with full IDE assertions, matching prior broad coverage. New moved fixtures require a follow-up path check. No public application corpus has been inspected or modified.

## Scoped unused-result cleanup

Detected45 unused-binding findings in private UI/archive sources. Removed unused
trailing results, retained underscore discards only when a later result is used,
and preserved every call (all-unused calls remain statements). A follow-up found
one now-unneeded released binding and removed it. No rule suppression, public
signature/default/type/storage or assertion changed. Archive strict lint and
original archive interpreter behavior pass. Nine existing UI suites are running
in interpreter/nativeO0/O2. UI strict lint has no remaining ordinary findings but
still fails its pre-existing default_overall_theme dependency; this is not a
strict lint pass. A minimal original self-address initialization reproducer and
proper lifecycle requirements are in integration-requests.md. The provisional
callback-only candidate passed; it is not falsely cited as a failure.
## Reviewed SDL oracle correction and final refresh12 results

Coordinator's latest explicit policy distinguishes required public prefixes from
complete native values. Corrected the impossible size-equality expectations,
retaining all five full-native records, exact public48/8 sizes/alignments, every
native RWops/User_Event offset/alignment/size, prefix offsets and actual C writes
with canaries. Added a private complete User_Event; no public fields/signatures
changed. Historical failures remain in sdl-sdk-refresh12*.json and earlier logs.
Production SDL verifier now reports zero failures; actual prefix test passes
interpreter/nativeO0/O2 and strict lint. This is host native and six source-target
evidence, not all-platform runtime or safe standalone public-native-value use.
See native/sdl-native-abi.md for extension/dependency rules and the representation
limit. Public callback fields still must not be treated as native C callbacks.

Optimized own-source compiler makes all2300 float oracle rows pass in all five
modes within the existing bound. Full portable134/134 ordinary cases pass; only
six Windows target failures remain (two visualization fixtures and Socket fd-set
on eachCPU). Socket check_fd_set itself is Unix-only per reviewed inventory;
Windows Socket backend is still independently absent and requires its own
reviewed fd_set/loopback fixture. Original target failures retained, no backend
success is claimed. Native fonts/glyph atlas/dynamic font/real GPU text rendering
pass21 additional source/program invocations with the caller's system Arial font,
without copying it into the repository.

Full partial-edit sweep finishes639files/17073edits/2762443assertions/zero failures.
This samples8 nonempty lines per file and exercises all IDE assertions; it is
not full application compilation/runtime. Changed SDL fixtures/private ABI need
the separately scheduled follow-up. Broad quality finishes833files with52/171
failed checks and source_stable=true: ordinary target/body failures remain,
including actual unused results in UI/archive. Those source cleanups are being
verified in the own secondary worktree. No blanket lint suppression was added.

## Refresh13 reviewed merge

Compiler995685c adds general Windows asynchronous unwind attributes and LLVM
synthesis defaults before/after optimization for all definitions. Two linear
sweeps add unbenchmarked compile overhead; no fake frame or optimization disabling.
Real Windows unwind/stack execution is pending. The platform named-fault fixture's
unconditional lookup assertion for a genuine O2 leaf needs ABI-aware correction;
do not manufacture a nonleaf to satisfy it.

Portable2355943 now matches settled SIMD truth-based comparison/mask, byte-offset
load/gather/scatter, looping indices and full horizontal pairs. It preserves
reviewed source defects in docs rather than emulating uninitialized results.
Scalar-left noncommutative symmetric policy remains unresolved. Pool CAPS and
runtime heap static names follow the reviewed null-data query contract. Adopted
private runtime transport matches the integration protocol; kept our canonical
initializer and deleted startup wrapper rather than reintroducing superseded
paths. New standalone runtime test runner now selects production --stdlib and
source-built --jaic, without repaired overlays or byte-equality staging demands.

Nine existing UI suites pass45 interpreter/nativeO0/O2 invocations after unused
result cleanup; archive original behavior and strict lint pass. UI has no remaining
ordinary lint finding but its pre-existing circular global diagnostic remains.
LSP parse-refactor test referenced three absent legacy flat library paths.
It now scans actual independent autorun/plugin/bundle implementation units with
the same every-line/range edit parsing assertions and >10 offered actions.
All21 refactor tests pass; no missing Example_Plugin export was invented.

Authorized candidatea78721d only changes native ARM64 Mesa developer-shell/isolated
pinned Python setup and documentation. Integrated those workflow changes without
push/dispatch or superseding coordinator's long-running native build.

## LSP project-settings notification timing

The resilience fixture discarded didOpen responses, then required the sole
malformed-project notification specifically at completion. Current semantic
project discovery correctly emits it earlier while opening the main document.
The test now collects config-open/main-open/completion messages, still requires
exactly one jai.toml unknown-setting diagnostic and requires no repeat on a
second completion. All four resilience tests pass. No server diagnostic is
suppressed, no malformed configuration is accepted, and no assertion is skipped.
## Refresh14 code audit before merge

- Compiler3084377 transfers a real std::thread kernel handle into GThread and
  exposes it as the scheduler key; native naming/HRESULT/LocalFree are genuine.
  Duplicate suspension/resumption explicitly rejects unsupported alias scheduling.
  Ordinary duplicate waits/exit queries remain native, while managed queries use
  scheduler completion/result. Source thread_main returns Rust unit after recording
  the Jai result, so native duplicate exit-code/completion equivalence is not yet
  established; full native entry/alias lifecycle needs a proper compiler fix.
  Existing unfinished-worker parking retains OS workers after VM teardown, though
  owned handle references close. This is a resource/lifetime gap, not complete
  Windows thread interoperability. Native runtime regression is still required.
- Portable Flat_Pool uses real generic mmap/mprotect or VirtualAlloc operations,
  public256MiB defaults, page rounding and OR reset flags. Commit failure returns
  null with no cursor advance. Page-size queries per commitment and allocation
  prefix ownership are independent policies; Android/console validation missing.
  Windows_Utf8 uses real Kernel32 two-pass conversion, active allocator, explicit
  failure cleanup and flags0 native replacement policy. Host source checks do not
  establish Windows execution.
- New clock-calendar.jai places clock_gettime inside assert. Basic's reviewed
  disabled assert discards its argument, which would silently return epoch/zero
  under ENABLE_ASSERT=false. Flat-pool.fini similarly puts essential unmap inside
  assert. These avoidable side effects must move outside assertion evaluation;
  retain diagnostics and native failure handling. Production red regression and
  correction are required before the time increment is counted supported.

Refresh14 correction: clock queries and Flat_Pool release now execute outside
optional assertion arguments. Native query failure returns APOLLO_TIME_INVALID
after the diagnostic, rather than fabricating a zero clock if assertions return
or are disabled. Failed unmap retains pool ownership fields for diagnosis/retry.
The original time-assert-disabled regression failed against the actual combined
production library at its realtime lower-bound assertion; the same interpreter
case passes after correction. Native O0/O2 and strict tool reruns remain pending.
Flat_Pool imports the default Basic instance, so no claim is made that its old
release defect was reached through a public disabled-assert configuration.
- Foundationad84008 resolves path-fragment matching and report-owned lifetimes;
  scalar FNV and unsigned-division exercise remain actual positive API failures.
  Do not reclassify those as accepted negatives. Revised fields/guards still
  require latest reviewed contracts and producer implementation.
- Bindings204f6f6's BMP close adapter preserves the SDL-owned stream pointer and
  C convention while converting full64-bit nonzero freesrc to native1. Its
  function address necessarily differs from the SDK symbol; only the actual file
  factory retains symbol identity. This is a documented ABI boundary, not a
  reintroduced stream proxy/context registry. Update the earlier invalid BMP
  address-identity expectation while keeping all stream/lifetime assertions and
  adding high-bit close flags. DXC source/ownership/COM checks remain blocked at
  public D3D forward overlays and need real Windows execution, not private-unit
  passes counted as public support.

## Refresh14 editor recovery and verification corrections

Source scope lookup used strict import admission even while collecting IDE facts.
An unrelated missing anonymous import hid an otherwise valid overload reexport.
lookup_import now retains/deduplicates the real diagnostic and continues
independent lookup only with editor facts enabled. Direct admission and ordinary
CLI lookup remain strict. Existing links regression retains the missing-module
error, canonical aliases, nested reexport and all other links. It distinguishes
one selected call overload from both overloads at an uncalled alias; resolving
calls exposed the old two-target expectation as incorrect.

Member completion uses the existing compiled_before cache when all source
before the receiver and every other open file match, retaining current symbol
offset adjustment. Changed declarations still trigger compilation. All three
links and all24 semantic tests pass; full recovery/privacy suites remain next.

Browser jai/source test formerly required a #load token in the public Basic
facade, which now uses canonical imported aliases. It decodes JSON and requires
byte-exact complete current facade content, using existing pinned serde_json
solely as a test dependency. No runtime dependency or library overlay is added.
The focused browser source test passes; complete browser suite still has a
genuine WASM Thread backend gap.

Foundation lint stopped before behavior tests on required positive API
failures (scalar FNV and division diagnostic). The runner correction retains
each failed target and missing coverage as final failures while continuing other
targets and behavior checks. An independently executed behavior/cross run of
unchanged production code also preserves both positive failures. Neither run is
called a full strict-lint pass.

## Native check safety and private runtime transport

Avoidable guard suppression is removed: LLVM no longer gates function null
checks on the presence of an optional public export. A checked file-private
compiler/runtime hook supplies genuine reason/operand/location diagnostics;
ordinary exports and private imports remain strict. Runtime-disabled guards
explicitly trap. Missing/malformed hook failures now propagate; no silently
ignored lookup/body error is accepted. Full rationale/evidence and concurrent
output-fragment tradeoff: ../compiler/private-native-checks.md.
Existing native diagnostic/pointer-invalidation/arithmetic suites and new
runtime-disabled O0/O2 regression pass; strict scoped Jai lint and workspace
clippy pass. Broad full suite is still running, no production-wide green claim.

Private transport audit correction: the first full safety run completed with
706 aggregate passes/53 failures/one inherited ignored test, including six new
failures caused by requiring the extension in minimal custom runtimes. That
requirement exceeded the reviewed public contract. Absence now uses an explicit
native trap fallback; malformed/present hooks still diagnose. Original50module,
four runtime-config and five library-root cases plus two new strict transport
cases pass. No tests were weakened. Production's real private reporter remains
present; native guard/diagnostic tests retain their assertions. The full run's
failure evidence is preserved at secondary artifacts/workspace-native-checks.log.


## Reviewed-test migration checkpoint (2026-10-15, integration role)

Explicit user-authorized replacement retires143 inherited stdlib compatibility
fixtures plus one tracked object artifact, preserves328 source/assets (296
compiler including37 helper modules,14 native including one MPEG asset,9
Extensions,9 graphics). Per-file hashes/reasons and consumer changes are recorded
in stdlib-test-migration.json. No stdlib/Extensions implementation was changed.

Operational Rust/Python/Node/workflow/release-fixture/PGO reads use new paths.
Legacy skip and numeric coverage baselines are removed by authorization;
reachability is informational and cannot establish functionality completion.
Standard CI runs reviewed contracts, compiler/Extensions/ABI/graphics/module
catalogue and separate NEW producer suites against actual production. Windows
ARM64 graphics execution follows actual Mesa build; pinned PyYAML6.0.3 added to
its isolated environment. These workflow edits are prepared, not CI-executed.

Executed evidence:6 catalogue/negative-runner unit tests PASS; precise Hash
privacy rejection and positive baseline PASS through contract and aggregate
runners; sweep negative PASS; native C++ hidden-result-pointer original fixture
PASS O0/O2; C structs-by-value real C test PASS with explicit overlay assertions.
Source-built unchanged jaifmt rewrite/check PASS59 contract/adapted ABI files.
Strict positive-contract jailint originally FAIL49files: two legitimate fixture
lint findings corrected (assert actual first locator, remove redundant alias);
storage-time missing seconds_since_init requires pending portable checkpoint,
not a tool repair. Original failure evidence retained.

Audit/risk/long-term work: retired generator wrappers are no longer compatibility
gates; full reviewed tooling coverage remains incomplete. C++ regression disables
only Clang's return-type-c-linkage warning because an intentionally C-named
C++ non-POD return tests ABI; native result/value assertions remain strict.
Ordered-atomics compiler regression now declares own intrinsic protocol directly,
retaining LLVM order checks plus exact result; no unreviewed Atomics API added.
Long-double presentation casts narrow only formatter arguments, retaining every
wide C ABI/precision comparison; generator-only tail is retired. Struct overlay
formatting no longer assumes an omitted reflected field, while all scalar/array
overlay values are asserted.

Remaining verification: full replacement catalogue and producer/native/browser/
Rust workspace checks still required after pending stable merges. Generic
module fixtures requiring font/SDK helper arguments need actual preparation;
their failures remain visible, no fabricated inputs/pass substitution. Some
producer drivers/builders remain macOS/POSIX-specific; source matrices do not
establish native Windows/Linux execution. Browser reports explicit unavailable
foreign/native SDK cases separately, never passed. Root contract coverage is
bounded, not equivalent to deleted suite or complete reviewed API coverage.
Coordinator alone runs opaque original public corpus, Focus and ordinary native
CI. Release/publication remains held. No push/dispatch performed.


Portable0c09ce4 audited/merged as5eb5149: primitive private clock kernels preserve
configured Basic canonical Apollo_Time; real first-call CAS elapsed storage,
native CPUID/mask queries and actual Windows mapping/extent/cleanup bodies.
Preserved prior Windows thread completion/readback/assertions and production-only
test drivers over incoming staging overlays. Retained old native Meow regression
plus both NEW producer vectors against production (no peer copies). Public Basic
Buffer remains removed; nested builder type retained. Calendar normalization/
sentinel/assertion and Pool unmapping-option gaps have precise public reproducers
in integration-requests.md. Windows native runtime remains unverified.

New independently spec-authored storage-time and scalar-Hash nativeO0 cases PASS.
Formatter case initially FAIL only because its manifest still expected ok after
reviewer added print_bytes: actual4 ab newline agrees exactly with basic.md line521.
Manifest now includes those bytes, retaining all formatter assertions. This is a
test harness oracle correction, no production change. Original failure log is
artifacts/integration-clean/reviewed-foundations-O0.log. Complete rerun pending.


Audio11bc663 source audit/integration: real SDK-owned C output/byte accounting,
queue/seek decode, phase-independent locks and bounded256frame mixing are
present. Existing canonical records/topology/accumulator retained over duplicate
producer types/storage; retired decoder list now lives only with synchronized
cache. Private VBAP helper remains file-local, using reviewed greatest-minimum
selection; superseded first-containing-arc path removed. Gain step reads actual
initialized backend sampling rate and asserts positive, with no invented1Hz
fallback. Producer verifier accepts explicit production compiler/linter/library/
native paths and performs actual Windows target lint.

Panning test setup correction: producer test called a nonpublic helper; earlier
integration adapted it to a public helper before a backend existed. With real
backend, that helper correctly routes an uninitialized output as stereo, so the
old isolated6channel expectation is invalid setup. Exact unit-direction VBAP
assertion is moved (and strengthens other-channel-zero assertions) into the
existing controlled-output fixture only after actual6/8channel native init.
No private export invented; stereo panning/topology identity tests remain. Actual
multichannel execution is still required, never counted from this source edit.

Detected operational-assertion risk: player.jai shutdown join, decode-queue.jai
join/wait, vorbis.jai open/seek actions occur inside assertion arguments. Sound
currently imports default asserted Basic, but this pattern risks disappearing
actions under future/default check changes and unsafe continuation on join/seek
failure. Exact owner follow-through requested in integration-requests.md; not
called completed error-path support. Native close failure retains C callback
storage but Jai can drop its handle if caller assertion handling continues:
potential resource leak; proper retryable ownership or unconditional fatal
diagnostic needed. Audio's source-present213rows are not integration-certified
complete. OS hardware/focus/hotplug, Linux/Windows execution, spatial numeric
choices, one-worker throughput, per-device snapshot retention and package
adoption limits remain as enumerated in producer audio-deviations.md. No fake
audio/clipboard/font/native success substituted.


Bindingsa476d25 audit/merge: FSEvents public context order is marshalled to a
complete SDK Context (s64version theninfo andCcallbacks); SDK copies synchronously,
native retain/release manage info. Public signatures/types unchanged. D3D canonical
dependency imports replace wrong d3d_compiler direction; no compiler symbol/path
bypass. rpmalloc has separate generated pinned native SDK records and reviewed
private contextual Heap/Span records; default-profile wrappers call actual native
alloc/realloc/free and copy full native statistics field-by-field into public
layouts.14 procedures are partial across configurations, not80 complete APIs.
Unsupported raw/heaps/callback/config/profiles still diagnose rather than silently
using the default archive. Native global state across module instances remains a
lifecycle/isolation gap; only default profile MacCPU execution reported by producer,
not Windows/Linux. Pending callback crash repair is not in this stable checkpoint.

Incoming native-bindings/sdl-layout fixture duplicates our relocated canonical
stdlib/SDL/tests/sdl-layout.jai. Keep the canonical fixture: every new public/native
field offset/size assertion is already covered there, with additional native
alignment and guarded payload writes. Remove duplicate stale relative .work probe
path; actualSDK event push/poll payload canaries from producer sdl.jai retained.
Public48/8byte prefixes and complete private native sizes are distinct reviewed
contracts. Scalar64bitclose normalization/factory identity remains. Historical
invalid full-size oracle evidence stays; no undersized Ccall or public ABI change
substituted. Actual combined native SDK rerun remains required.

Producer status tail still lists older116unresolved/80rpmalloc, while new coverage
ledger marks partial default wrappers; source inventory is not functionality
certification. Strict target lint/configuration/native execution gaps remain.
Private test placement must remain byte-identical inputs and not library repair;
production-source stability/cleanup and bindings generator idempotence need rerun.


Tooling9b6c482 audited/merged scope: source-built official libclang C/Jai ABI,
CXIndexOptions u16bitfield/size24/pointer8,16, cursor/types/strings/callback models,
finite numeric macro probes and enum groups, CodeView/DWARF subsets, kernel-
mediated Debug readability. No reference compiler/std bodies used. Public native
model ordering comes from independent responsibility groups; aggregate/enum/ABI
order preserved. Public version21 remains reviewed compatibility constant while
actual official SDK23 supplies the supported native backend; exact header/native
source hashes are recorded, not full21SDK conformance.

Removed avoidable host-specific test/build setup: official SDK prefix now uses
explicit DEVELOPER_TOOLS_LLVM_PREFIX, compiler LLVM_SYS_231_PREFIX or actual
llvm-config; missing SDK diagnoses. Shared native fixtures use real macOS dylib/
Linux PICso flags/names, retaining identical C ABI/behavior assertions. No hardcoded
Homebrew path or Linux-as-macOS command remains. Native Windows tooling is still
unsupported, explicit builder diagnostic; source target checks are separate.

Unfinished/reduced behavior remains producer-reported: Bindings_Generator supports
one C header/library, rejects unsupported C++bridges/bitfields/variadic callback
mutations/string/function/nonfinite macros and options; macro probes reparse per
macro (callbacks can double cost), include snapshots not atomic; no fabricated
constants. Header generation rejects unsupported overlays/multiple returns/etc,
layout mismatch may surface at Ccompile rather than pregeneration. Its runtime
support-descriptor fixtures still use reviewed test-only records and are not
production bootstrap identity proof. Rewrite uses byte coordinates/quadratic
sorting, skips unwritable string inputs and has non-atomic write TOCTOU risk.
Print_Vars byte widths/eager temporary storage and Performance_Report quadratic
sorting are deliberate. Debug has bounded little-endian DWARF32 subset, real
readability kernel syscalls, unsupported architectures/backends remain explicit.
Iprof has caller-supplied reports only, no fabricated instrumentation/samples;
Codex metadata and Check semantics remain subsets. Full1630declaration inventory
is not full behavior support. Producer tests independently authored but separate
root review remains pending. All current production/Jai/native/ABI/regeneration/
lint verification remains required; no staged producer pass counts integrated.


Window1f66dc1 integrated as8e920639. Real Meson child-discovery and LLVMcache
receipt/configuration/corruption/partial-install tests:8PASS in prepared local
venv with Meson1.8.3/Mako1.3.10/MarkupSafe3.0.3/packaging25.0/PyYAML6.0.3.
First invocation with bare systemPython failed because Meson was absent;
dependency setup corrected and original failure retained, no assertion weakened.
This is host build-tool regression evidence, not ARM64Windows driver execution.
Cache hashes selected public SDK/compiler/tool binaries and installed LLVM tree,
rejects symlinks/stale/partial changes, persists completedLLVM before Mesa; no
driver cache reused. Hashing full SDK/tool trees costs startupI/O deliberately.

Filtered coordinatorCI9d87e76 reports fuzzPASS and SDL3Linux/macOSfourCPUsPASS.
WindowsSDL3 stops beforeCcompile at hardcodedVSdiscovery (SDLowner fixing).
Windowscompilerlink stops at kernelbase.lib SDKattribute (compilerowner fixing),
so follow-onruntime steps are not independent behavior failures. ARM64Mesa source
download timed out beforebuild; no native driver evidence from that attempt.
No rawvendorCIlogs read and no release/push/dispatch performed.


Portable41a015a source audit/integration: actual Winsock startup/error/option/
keepalive/close calls, correct native millisecond policy, direct foreignFD_ISSET
identity and descriptor-array semantics. Preserved existing POSIX nullcheck safety
in moved backend; no lost FD_CLR/word-width assertions. Windows helper drivers
now accept explicit actualcompiler/productionstdlib and do not copy partial
producer overlays. Native Windows execution remains required; no runtime success
from body checks. Signed ioctl output uses realu32encoding thenuncheckedbitcast
tos32; typed wordlocals avoid producer-reported cast/shift-width observation,
whose exact language precedence needs oracle review before calling it a compiler
defect. No special symbol/path lowering. Missing CMSG/bitfield/native shape families
remain explicit. Native close failure is logged then invalidates caller handle,
with documented resource risk per wrapperpolicy; not silently counted success.


Refresh17 production verification completed against7aec510: fullworkspace85
result summaries742aggregatepass/32fail/one inheritedignored, ninefailedtargets;
counts include child-process summaries, not unique tests.1052ownedJai format/
check PASS; strictlint58/187checksFAIL, source_stable=true. Full root contract
batch52/54PASS initially: duplicateBase64local(valid) is a fixture syntax error,
and Sound.skip_this_output_channel was accidentally moved into file-private scope
during integrationhelper relocation. Both corrected without changing assertions
or addingexports; original failures retained. DuplicatecompleteSDL.User_Event from
two independent ABI patches caused SDLsource checks to fail; one identical layout
now retained. Root implementation regression, not an invalid ABI oracle.

Default assertion CLI reproducer exitsSIGABRT under-interp because NEW runtime
calls realC.abort while the old compiler hook expected an obsolete private name.
Proper correction: optional file-private runtime assertion transport selects the
actual callback procedure by identity and validates exact canonical location/
string/bool/Jai-context signature plus ordinary native body. Interpreter installs
its existing structured fault operation for that procedure; native code retains
the real Jai body. Custom callbacks execute unchanged; no public export/module
parameter or filename/symbol-specific library bypass. Native reporter discovery
shares the general private-extension resolver; obsolete name-based assertion
hook removed. Private runtime_entry is #no_debug, suppressing only bootstrap
frames through existing semantic metadata, not display-name filtering. Source
CLI regression (default/compile-time assertions and custom continuation) PASS;
three protocolprivacy/validation cases plus51module/two nativehook/fourruntime
configuration cases PASS. Full diagnostic/native regression rerun pending.

NativeSDK fulldependencysetup FAIL at stale GitHub X11mirror tag404. Manifest
already pins officialX.org1.8.12 release+header hashes; builder now verifies/
extracts release beforeusing per-file bytes, preserving both hashes and all-input
validation. Three transport/cache/corruption units PASS. Full retry hit official
server connectionreset: stillFAILED, not called a productiondependency pass.
Scoped actualSDLprobe builds PASS; scoped actualrpmallocSDK/statlayout/FSEvents
probe builds PASS. One ownedFSEventsprobe warning uses deprecated but public
ScheduleWithRunLoop API; no warning suppression applied, not a-Werror pass.
FutureSDK removal risk remains; retain ABIcoverage and add modern dispatch-path
coverage with an explicit narrow deprecation policy. Source archive cache also
needs complete transitive-header tree integrity validation beyond current pinned
primary files; no source-wide SDKconformance inferred from scoped builds.

Refresh17 final focused results: four private interpreter protocol tests now
include proof that the native callback body still typechecks; four CLI scenarios
cover default/compile-time faults, explicit #no_debug unwinding and custom
continuation. Existing module/native-hook/runtime-config60 tests passed before
the fourth protocol case was added. Workspace clippy warnings-denied PASS.
All54 public contracts PASS interpreter/nativeO0/nativeO2, including precise
negative checks (not54 distinct native runtime effects). Scoped formatter/check
PASS after rebuilding actual unchanged jaifmt. A fragment-only audio lint attempt
failed missing its loaded-module constants; failure retained and context-complete
run required. No incomplete lint is called success.

Native verifier found stale relocated SDLfixture paths before execution.
General canonical module-owned test resolution replaces filename-specific routing;
three input-placement tests prove fixture ownership and exception-safe restoration
of existing sources/removal of temporary dependency directories. Runtime checks
now restore private placement on failure/success; no private exports promoted,
fixture bytes unchanged. RealSDLverify PASS30target/24privacy/299symbol/nine
native-interpreter phases using actualproductionstdlib/source-builtSDK. Full
all-dependency validation remains blocked by officialX.org connectionreset.

Root Audio contract setup was corrected to provide actual loaded in-memory PCM
when testing successful buffer bounds, as required by reviewed Sound_Player:
default UNINITIALIZED/no-storage data cannot establish successful buffer bounds.
Default-value assertions remain before the mutation; bounds checks now assert
actual backing-storage identity. Original failure evidence retained.

Follow-up to refresh17 SDK/cache and audio lint entries: avoidable transitive
archive cache gap removed by extracting the entire hash-verified archive afresh
on each preparation, then replacing the cache tree. Modified transitive headers
and injected extras are covered by a regression. Deliberate extractionI/O
tradeoff; future optimization can compare complete verified manifests, never
only primary headers. Seven transport/placement regressionsPASS. OfficialX.org
network failure remains; no full-pin build success.

Context-complete audio lint exposed duplicate get_magic4 implementations from
integration, with identical signature/bounds/encoding; retained samples.jai
version with stronger diagnostic and removed loading.jai duplicate. Actual
scoped loaded-fragment/runtime/SDL/contract lint nowPASS with warnings denied.
Whole-tree58failedlintgates remain historical/currentuntilrerun, not declared
resolved. Default Audio publicskip helper visibility andSDLUser_Event duplicate
are included in the integration correction checkpoint, not producer blame.

## Refresh18 producer and independent integration audit

Consumed source snapshots: portable eab3383, bindings fc6c681, audio498046b,
developer-tools af8b5f4, SDL3 0b2dc3c, coordinator CI e223538. Compiler native
repairs6904b4a/049e997 and cast observations were integrated through approved CI
cherry-picks, retaining our private assertion transport29ec8f9. Every producer
progress/deviation/handoff report was read; implementation inspection additionally
found the following integration defects or limits. Later ready checkpoints are
queued, not credited here. Extensions outside SDL3 remain byte-identical.

- internal/audio/panning.jai: integration had also privatized reviewed public
  add_vbap_gain_for_direction while moving its body. Restored the existing
  signature/body to public scope; no new API. Source/signature fixtures now
  execute. Audio manifest now explicitly includes our perceptual power-law
  regression, rather than bypassing strict discovery. Actual27cases PASS
  interpreter/nativeO0/O2, six-target bodies, owned format/lint and three privacy
  checks. Real silent SDK2/6/8streams opened in all required modes; no physical
  channel placement/latency or Linux/Windows runtime claim.
- audio lifecycle/native adapters: essential waits/seeks/joins are unconditional,
  failed close ownership retained/retried and unavailable state no longer
  reports initialized. Injected failures surround genuine SDK resources, distinct
  from OS-generated failure/hotplug proof. Owned-audio assertion-disabled copy
  staging does not establish a globally configured production library; real
  Thread assertion dependency remains open with active owners.
- rpmalloc callback-context/rpmalloc-callbacks: per-call TLS context frames,
  copied native names and synchronized signed-offset mapping metadata are real
  adapters; no public record cast into C. Process-global SDK, spin-lock/linear
  registry/malloc per mapping and two C frame calls per operation are deliberate
  lifetime/performance costs. Error-location policy/profile isolation remain
  limited. Full canonical public heap/span operations remain missing; native
  field-layout probes are not API completion. Production scoped SDK build PASS;
  verifier36source/96privacy/tennative phases PASS plus six missing-public-name
  failures retained. Nondefault/raw configurations remain required gaps.
- developer-tools clang/model/MSF/debug: actual39fixtures/C/C++ consumers PASS
  on host, real MSF stream tools and Windows cross-built Debug ABI separate.
  Hardcoded producer LLVM prefix replaced with existing general configured LLVM
  discovery; new shared C fixtures use platform shared-library flags. Windows
  Debug cross helper remains macOS-hosted MinGWx64 only; Linux/Windows fullhost
  orchestration not certified. Scalar aliases/locations/null-C++ diagnostics do
  not establish full1630-declaration support. MSF wire subset supports only
  validated sizes/streams; staged byte-copy wire tests are private-unit evidence.
- SDL3 generated files: narrow LF attributes and UTF8byte writes remove actual
  CRLFhash failure, not a platform hash exemption. 31generator/nativehelper
  unitsPASS locally; prior real sixprofile/SDK producer evidence distinct.
  Native Windows compile/runtime and all95GPU operations remain CI gates.
- portable Pool registry: active source keys first-use by Pool address; returning
  Leak_Report by value leaves a stale record and later allocator-null fault.
  Original foundations assertions retained; exact active-owner request supplied.
  No caller-address patch/layout change/value-return prohibition accepted.
  Calendar native normalization/text and Socket CMSG/TCP/Windows scope bodies
  integrated, but selected Unix test classification is not Windows runtime proof.
  Registry constants/ConvertToApollo remain missing despite settled review.
  Android ABI naming is tooling only; compiler Android target unavailable.
  Full source/native/strictlint coverage for253 missing public rows is absent.
- jaic-llvm/partition.rs: address escape prevented counting single-caller bodies
  in inline-growth estimates, exposed by unchanged optimized_split regression
  after runtime procedure metadata gained address references. Conservatively
  account for sole direct callers regardless of additional address references;
  noinline cuts now bound that expansion. Existing two optimizer result/IR
  regressionsPASS. Possible extra conservative noinline cuts are a performance
  tradeoff; benchmark after correctness, do not infer native speedup.
- Objective_C forwarding: general scanner now follows explicit native #foreign
  aliases and checks every discovered literal, replacing obsolete old-layout
  count thresholds. This exposed genuine NSThread native selector typo.
  Generator uses official Foundation header spelling, retaining public API;
  three alias/arity/runtime tests PASS with805 distinct native method pairs.
  No baseline exception added. Dynamic selectors/local receiver class inference
  remain explicit test limitations, not full Objective_C completion.
- corrected compiler test oracles: LSP accepts both direct Math namespace import
  and reviewed Codex.Math reexport, applies both edits and checks no errors.
  Null Any boxing now tests compiler address/type representation directly rather
  than obsolete printer abort behavior; explicit null read still diagnoses.
  CLI color tests remove inherited NO_COLOR before forcing color; actual NO_COLOR
  precedence test retained. New private allocation path and actual cycle/assertion
  diagnostics replace old path/wording expectations. Full diagnostics25PASS,
  LSP namespace PASS, IDElayout4PASS and browser assertion transport PASS.
  No compiler error relaxed or production fake default introduced.

Actual broad evidence retained: workspace755aggregatePASS/27FAIL/one inherited
ignored, sevenfailedtargets. Production quality1107formatted/checkPASS,
strictlint56/190failed, source_stable=true. Catalogue394cases: interpreter306/
83pass-fail, native300/82 plus7compile-only, WASMinterp237/130, WASInative230/130
plus7compile-only; eachmode five precise negatives separate. WASM native-only22
unavailable each, not passes. Catalogue dependencies were incomplete; specialized
SDK/font runners are required and many compiler/stdlib gaps remain real. Window
first158/18failed because real test probes not built; after source-building own
window-native, production188invocationsPASS with real hostGL/clipboard/fonts.
No failed initial run hidden. New fullpartial-edit sweep1086ownfiles running,
excluding all public corpus/vendor directories. Opaque applicationcorpus/Focus/
crosshardware remain coordinator gates; no publication/push/dispatch occurred.

Refresh18 retained regression migration follow-up:
- tests/extensions/extensions-long-double.jai explicitly casts only presentation
  arguments to float64 and checks type identity directly. All wide arithmetic,
  mantissa/rounding/range/reflection/C-varargs assertions remain; four wide target
  interpreter scenarios PASS. Basic's current formatter supports IEEE32/64
  rather than arbitrary extension floats; this is an explicit capability gap,
  not a production narrowing implementation or full wide-formatting claim.
- c-callback-threads fixtures follow reviewed thread_deinit completion precondition
  for positive lifecycle calls. The compiler deadlock fixture now uses direct
  documented SDK thread create/join signatures and condition-variable waits:
  public thread_is_done is timed polling and macOS public Semaphore uses opaque
  libdispatch waits, so those do not prove scheduler-blocked-state diagnostics.
  Two attempted polling/dispatch variants stalled and were terminated explicitly;
  original logs retained. Neither is a passed test. Actual kernel-wait variant
  PASS preserves both immediate Jai join deadlock and C-callback grace timing,
  exact positive outputs and native callback execution. A60-second watchdog
  now kills/states a hard failure on reporting stalls, never accepting timeout.
  Missing C compilers fail both touched Ccallback tests instead of optional skip.
  Native Windows/Linux execution of the new SDK fixture remains CI-required;
  current supported hosts/targets are64bit, pthread_t/uintptr ABI accordingly.
  No fake handle, unreviewed Thread export or native callback adapter added.
- backtrace caller regression removes unreviewed Debug.USE_GRAPHICS parameter;
  exact same frame-depth/deallocation assertions PASS nativeO0/O2.
- unsupported Compiler requests use current precise scope/user-segment/type-table/
  custom-link precondition diagnostics and reviewed one-argument link completion
  signature, still require every case to fail. Six-case CLI test PASS.
- broad source compile/lint/matrix failures remain. The25diagnostics,4IDElayout,
  namespace edit resolution, browser negative assertion, two optimizer tests,
  three selector tests and focused native callbacks/backtrace are actual focused
  results only. No new all-workspace total inferred from them.

All private source/header/probe substitutions remain labeled. Source pins,
C ABI guards, native foreign errors, public visibility and old failure evidence
are retained. No global lint suppression, test disable or release action.

Native custom-link/crash gate follow-up: retained two actual custom-link cases
now set the reviewed Message_Phase.linker_exit_code then call the one-argument
completion API. All original object-count/path/IR/frame-pointer/native execution/
missing-completion/failure assertions remain; failure runs a real child exit3
rather than inventing a native linker result. Both tests PASS. Variadic array
append/spread is retained unchanged; an attempted ordinary slice append was
correctly rejected because the reviewed overload is variadic, not a slice API.
No compiler workaround or unreviewed overload was introduced.

Crash-option/minimum-OS fixture now raises actual POSIX SIGSEGV through the SDK,
rather than assuming a guarded constant null store reaches the OS signal handler.
It checks native stack presence exactly when enabled, actual frame addresses and
crash message, plus unchanged Mach-O minimum12.0. Native host gatePASS.
Original explicit-null guard tests/protected mmap/mprotect regressions remain.
The old expected 'fatal runtime signal' wording belonged to replaced private
reporting; current native stack assertions test observable behavior, not a fake
signal/no_abc bypass. Cross-native Windows/Linux gate remains required.

## Refresh19 audit and exact remaining gates

At7dc08ed reviewed fullworkspace:767aggregatePASS16FAIL/oneinheritedignored,
fourfailedtargets. Partial-edit1086ownfiles finished28772edits3285512assertions,
two reproducible recovery failures (SDLwrappers tailtyping and valid changed
#add_context scope); full ownreport retained and precise requests supplied.
No public corpus/vendor directories were read. Actual source-built RustWASM
modulebuildPASS; realNode scripting gateFAIL at tour's native-only Thread import.
ReferenceThread targetguard remains strict. Basic.exit is reviewed POSIX/Windows,
so unchanged Extensions.Args/Io have a WASI integration dependency; do not invent
prelude/global exports or weaken POSIXguards to hide it. Proper own-WASI extension/
backend or supported tool integration requires an explicit reviewed design.

Independent compiler ISA audit confirms severe preexisting substitutes in
crates/jaic/src/sema/asm.rs: RDRAND andRDSEED share scrambled CycleCounter output
and fabricate CF=1; RDTSCP AUX is hardcoded0. These are not real instructions/
entropy/serialization and cannot count as support. Risk: false entropy/status,
wrong CPU-ID/timing and ordering. Proper fix: separate actual ISA IR/backend/
interpreter operations with CPUfeature checks/carry failure/realTSC_AUX and honest
unsupported diagnostics. Compiler owner is actively implementing this general
fix; CPUID's separate real implementation remains tested. No new workaround
accepted or synthetic instruction credited. Await stable committed replacement.

Target/context compiler4de36d6 integrated with one shared Options clone/target
selector; obsolete parallel target fields removed. Existing --os/--cpu aliases,
WasmCPU spelling, additional programsource injection and checked-files output
remain supported. --manifest records complete/incomplete contexts and actual
visited/unvisitedfiles. All jailint unit/CLI/rule/newtarget cases PASS aftermerge;
38 producer cases plus preserved root features, no incomplete-check success.
Root runtime-configuration regression still selects production library when
available, preserving isolatedfallback only for producer-only dependencies.
Strictprivate imports/configuredmodule bindings and childworkspaces remain.
Full lint runner must adopt these contexts; old56/190failure report remains,
no green whole-tree claim from scoped tests.

FSEvents verifier source-placement fix preserved private imports, then actual
native build caught producer .work-relative testlibrary dependency. Fixture now
uses system-library lookup via explicitrealSDK directory. Original failure
retained; corrected native rerun pending. This is private ABI test input placement,
not a repaired productionlibrary overlay or completed public watcher proof.

Pool reviewed refinement now rejects set_allocators based solely on non-null
block_allocator.proc and preserves descriptor/options across reset/release.
Earlier first-use-history interpretation/addressregistry is superseded and
avoidable; portableowner must remove it at the representation layer, preserving
by-value returns and publiclayout. Original leakreport fault retained. No fresh
caller-address registry or extra public marker accepted.

### Integration worker: partial-edit harness probe isolation

Location: `crates/jai-language-server/examples/support/edit_coverage.rs`. Previously the synthetic tail declaration directly followed edited input; valid truncated directives could consume it and invalidate the claim that it was independent. Observable effect: two refresh18 failures, reproduced by the new generic test. Fix: an empty statement separates the probe from the original source, outside all edit ranges; all source cuts and typed/symbol/definition/completion/token/hint checks remain. Risk: probe construction is synthetic and cannot certify every recovery situation; original source scope-change checks remain independent, and the full sweep must rerun. No missing assertions are accepted. This is a corrected test construction, not production compiler support or a corpus pass.

### Integration worker refresh20 production-source and producer audit

Pool: removed the entire address-keyed use registry at `internal/allocation/pool.jai`; exact reviewed non-null allocator-field guard now survives reset/release and ordinary by-value returns. Original leak-report and new ownership tests actually pass on the production tree. Thread: essential Unix SDK calls are unconditional; successful join/semaphore cleanup flags retain ownership on failure. Windows checks/handle ownership remain preserved through the merge. Partial group initialization/clock failure remains explicitly fatal because these void APIs cannot return usable partial state; group work-list destruction is not transactional. This is documented producer behavior, not a tested recoverable failure guarantee. Proper follow-up is transactional lifecycle cleanup and real native platform failure testing.

`tools/check_integrated_lifecycles.py` replaces staged Basic-default rewriting for integration proof with reviewed Compiler.remap_import and a test module reexporting canonical public Basic(false). All50 actual interpreter/ARM64/x64 O0/O2 executions pass, including real Mach destruction failure, exactly0 versus1 optional assertion-handler calls and retained cleanup state. All production Jai source hashes remain unchanged. Initial harness mistakes (anonymous imports do not reexport; CLI CPU selection needed a triple; -check forbids child executable output) are retained in separate failure logs; corrected use of named using imports and -interp implements the actual public mechanisms. No production body was copied/repaired.

Compiler ISA audit: implemented batch now emits/executes real timestamp/AUX/random/CF/fences/prefetch/PAUSE; all15 focused integrated tests plus9 floating-literal/intrinsic regressions pass. This ARM64 host cannot execute x64 ISA directly; capable RNG hardware and native Windows/Linux execution remain unverified. Interpreter CPUID probes add serialization/overhead; raw native callers remain responsible for CPU/OS capability. Existing unrelated synthetic rdpid/xgetbv/MXCSR and unsupported cache operations remain explicit gaps. General forward enum dependencies remain a real Socket blocker, with a new original reproducer and owner request.

Developer producer audit:56 real fixtures pass on the combined library, actualC/C++ round trips/scoped lint included;1176 SDK layout/enum comparisons and360 symbol resolutions are distinct from invocation coverage. C++ bridge accepts only supported external global declarators; configured SDK compiler paths need destination regeneration. MSF7/4096-page copying and finite binding equivalence retain explicit subsets, malformed-input safety policies and allocation/quadratic traversal costs. Iprof history storage/stack inspection are implemented; actual timing/instrumentation remains absent. Source SDK23 execution does not certify SDK21/platform runtime.

WGL helper387efe2 enables actual Windows targets and validates mapped driver images/dependencies;16 infrastructure unit tests pass here, no native Windows renderer pass inferred. Optional SDK-search-path repair and SDL3 Windows CMake layout repair are approved but missing from available refs, requested precisely. Fuzz separate lock metadata is integrated;12 locked/offline harness/replay tests pass. Release workflow remains tag/manual only; ordinary integration branch push triggers read-only tests/artifact workflows, with no publication authorized. Historical release rebuild wording in release.yml is incompatible with the current hold and is not authority to execute it.
