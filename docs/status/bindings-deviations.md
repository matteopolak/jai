# Bindings implementation deviations

This is an open implementation audit, not a completion claim. Scope: the 34
owned facades, `internal/bindings`, generators and native tests. The exhaustive
declaration ledger is [bindings-coverage.json](../native/bindings-coverage.json).
An emitted declaration or resolved symbol does not establish layout or runtime
correctness. Previously recorded failures remain required work.

## Integration and tools

- **Native SDK heap-pool page-granularity fix.** The new public configurable
  heap regression and independent pristine-C reproducer both hit the SDK's
  active mmap-size assertion with 4 KiB spans/16 KiB pages. The defect is native
  heap-pool byte rounding, independently reproduced without our facade. Owned
  `rpmalloc-heaps/sdk-page-granularity.patch` rounds that mapping to configured
  pages and updates its real span count; existing SDK reserve/unmap machinery
  owns the excess spans. `prepare_rpmalloc.py` verifies pinned source hashes,
  copies to a separate build directory, applies the patch and records all
  provenance hashes. No vendor edit, public shape change, assertion removal or
  configuration substitution is used. Both statistics profiles pass the C
  reproducer under ASan/UBSan. Remaining risk: native reserve/unmap accounting
  across other OS page granularities. Proper fix: audited upstream C correction,
  repin, revalidate and remove the build patch. The original failed run remains
  `.work/rpmalloc-sdk-page-granularity-before-fix.json`.

- **Canonical heap adapter publication and unresolved metadata policies.**
  `internal/bindings/rpmalloc-heaps` now allocates complete reviewed public
  records separately from typed SDK handles and copies actual defined state,
  including all native counters through atomic accessors. No public pointer
  reaches an SDK heap call. SDK unmap notifications retire actual storage
  associations; active operation leases delay reclamation across callbacks.
  Bare pointers retain normal C lifetime constraints, not fabricated generation
  safety after invalid use/storage reuse. The current consistency mechanism
  serializes calls per native profile and republishes the full graph with linear
  association lookup. User callbacks release/reacquire the lease, and frees
  during paused mutations use real SDK deferred-free/statistics primitives.
  Correctness tests include a callback waiting for four actual freeing threads.
  Costs: graph traversal/copy and metadata allocations per discovered object;
  independent heaps are serialized outside callbacks. Proper optimization needs
  explicit native dirty/lifetime notifications and per-object publication.
  Direct public control-field writeback is unsupported by the refreshed reviewed
  contract. Inactive cache/reserve/orphan links and undefined allocation-only
  fields use documented null/zero normalization; no public guarantee is made.
  The latest review exposed two genuine staging defects: list heads previously
  published null prev, and heap predicates included cache/reserve-only ranges.
  Public regressions now require tail-valued prev and active-list ownership;
  the adapter implements both. An actual pre-fix assertion failure is retained
  in the checkpoint evidence. These were production fixes, not oracle changes.
  These are independent safe view policies, not original guarantees or fake
  statistics. All 2,027 counter values compare with actual SDK atomic probes.
  Metadata libc OOM currently reports/aborts; graceful transactional metadata
  exhaustion remains a real gap. Unsupported concurrent/reentrant mutation of
  one SDK heap is diagnosed rather than corrupting its state; arbitrary SDK
  map-callback reentrancy during pool initialization is not promised. Huge
  requests exceeding the SDK u32 page-count representation fail before mapping.
  Native Windows/Linux execution and other option profiles remain outstanding.
  Precise filtered questions and the [implemented design](../native/rpmalloc-heap-adapter-design.md)
  identify proper follow-up rather than hiding these limits.

- **Private profile identity test correction and general compiler question.**
  The initial native-handle ABI test compared an explicitly selected SDK profile
  with an implicit default import. The current compiler assigns distinct nominal
  types to those imports. The test now selects the actual explicit profile and
  retains its identity assertion. An original generic `Example` module reproducer
  is supplied under `tests/native-bindings/compiler-repros/module-default-identity`;
  reviewed language semantics/coordinator must classify it. No compiler changes,
  module exceptions, public type aliases or weakened identity assertions were
  introduced. It is not counted as a passing language regression.

- **Scoped native fixture registration repair.** New rpmalloc public fixtures
  were registered in the source/native lists but initially omitted from the
  scoped runtime module-owner filter. Dedicated two-CPU execution still ran
  them, but the scoped verifier skipped those three programs. The owner filter
  and explicit evidence scopes are now corrected: checkpoint-18 runs all eight
  rpmalloc programs (two private, six public), producing 16 host build/run
  checks. This was a test-registration defect, not public functionality credit;
  earlier ten-check reports are preserved. Future fixture additions must update
  source/runtime registration and owner filtering together; a unified fixture
  manifest is the proper longer-term tooling refactor.

- **Current rpmalloc raw/profile policy and callback corrections.**
  `rpmalloc/context.jai` privately selects raw first-class heaps false because
  the reviewed parameter is genuinely undeclared and the latest user explicitly
  authorizes an independent default-zero policy. No public parameter or
  reference-default guarantee is introduced. Raw first-class functions remain
  unfinished and conditional. Real raw/rewrite wrappers now share a private
  boundary. Statistics-disabled imports use separately compiled, prefixed SDK
  symbols and matching callback/check helpers; native mixed-profile tests verify
  independent ownership. Same-profile imports still share a domain and reject
  overlap; other option profiles remain code gaps. `config()` exposes copied
  mutable module storage with shallow public string pointers; C names have
  separate terminated storage. Concurrent mutation or replacing callbacks while
  allocations remain live is not promised. Reviewed mutation semantics remain
  requested. Refreshed specs invalidated earlier tests for large/negative
  offsets, custom mapping retry and missing-partner errors. Production now
  enforces 0..65535, frees rejected mappings, confines retry to built-in mapping
  and selects both built-ins if either partner is absent. Replacement tests keep
  genuine failures, canaries and lifetime assertions, adding misalignment and
  real cross-thread handoff. Earlier reports remain historical evidence.
  Native C supplies no Jai assertion location: the real bridge call site remains
  a documented substitute. Existing registry/TLS costs remain. Public heap/span
  live-field marshalling is unfinished; no fake snapshots or cross-layout casts
  were added. The [design](../native/rpmalloc-heap-adapter-design.md) records
  traversal, atomic access and callback-lock constraints. All-owned strict lint
  outside supported scope remains incomplete; no exclusions were added.

The older rpmalloc entries below describe historical checkpoints. Their
wide-offset/raw-blocker statements are superseded by the current entry above.

- **Native rpmalloc storage views are not canonical public heaps.** Complete
  SDK source-derived records and all 66 field probes now pass both Mac CPUs;
  six desktop Jai source checks are separate evidence. Public Heap/Span remain
  independently generated reviewed layouts. Heap sizes match but cache/deferred
  offsets differ; public Span is 96 bytes versus native 88. No cross-layout
  pointer cast or fake snapshot is used. Atomic members in private storage
  views are layout-only scalar representations, not atomic operations. A
  header-only SDK export inventory caused duplicate main-thread setter symbols
  in the probe; scanning complete source definitions resolves the cause and
  also enables the real public setter. A new Span-size equality test was an
  incorrect oracle and was corrected using actual C evidence, preserving all
  native field assertions. Both original failures remain indexed. Proper
  remaining fix: canonical field/identity/lifetime marshalling with reviewed
  live-metadata semantics. See [ABI evidence](../native/rpmalloc-heap-abi.md).

- **Public rpmalloc callback bridge and policies needing review.**
  `internal/bindings/rpmalloc-callbacks/bridge.c` owns copied names and mapping
  metadata; public config/ordinary callbacks never alias SDK storage. Full
  signed offset bits round-trip in an owned registry, avoiding native 32-bit
  truncation. Each C thunk establishes an active Jai context. The first
  run without that context genuinely crashed (exit 139); this is repaired and
  preserved in `.work/rpmalloc-callbacks-before-context.json`. Public tests now
  execute four concurrent native threads, retry/decline, config/name stack
  overwrite, wide/signed offsets, matching release and real init failure on both
  Mac CPUs. A subsequent caller-context regression failed with exit 134; a
  reusable TLS bridge now preserves caller fields/writes and nested calls,
  restoring the pointer on return. Native-only callbacks get a fresh default;
  no initializer context survives its frame. Actual thread identity is checked
  across four threads. Configurable size settings are checked against the actual SDK;
  nonconfigurable overrides are ignored as reviewed. Enabled callbacks are
  actual calls, not no-ops. Risks/remaining policies: error locations identify
  the real thunk, pending reference provenance review. Mapping metadata adds one libc
  allocation and spin-lock/linear lookup per native map/unmap. SDK remains
  process-global; overlapping imported owners return EINVAL rather than replacing
  active callbacks. Concurrent imported-profile isolation is incomplete. Context
  enter/restore adds two C calls per native operation. Proper
  fix: reviewed location policy, profile isolation, indexed registry
  optimization after correctness, and canonical heap representation. Callback
  initialization is partial in the ledger, not full rpmalloc completion.

- **Default public rpmalloc profile, incomplete option matrix.**
  `stdlib/rpmalloc/wrappers.jai` now implements real default rewrite lifecycle,
  allocation, thread status and fieldwise statistics conversion. A private
  profile predicate prevents other cache/statistics/assertion options from
  silently executing this native build. Missing implementations remain source
  diagnostics; there is no unsupported assertion or success-returning stub.
  The initial fourteen ledger entries were explicitly partial, with their implemented
  condition, rather than complete across imports. Actual public-only programs
  run on both Mac CPUs; six desktop source checks and scoped strict lint pass.
  That allocation-only checkpoint credited no callback/config/heap behavior;
  the subsequent callback evidence is separately recorded above. The native SDK remains
  process-global, so concurrent distinct import instances are not established;
  lifecycle state is serialized, not an atomic cross-thread initialization API.
  Risks: unsupported nondefault configurations and missing callback ownership,
  no runtime Windows/Linux evidence. Proper fix: profile-isolated native builds
  or a reusable independently authored allocator backend honoring every option,
  plus canonical contextual heap representation and safe callback ownership.
  See [public adapter scope](../native/rpmalloc-public-adapter.md).

- **Private rpmalloc SDK, public implementation still incomplete.** Generated
  all native C functions and full SDK config/statistics storage from complete
  pinned official input. Native heaps are opaque private pointers, never aliases
  of reviewed Jai records. The fixed private C build profile is explicitly
  separate from public module defaults/options. [Details](../native/rpmalloc-native-backend.md)
  record both-CPU SDK execution, all field probes, untouched public failures,
  custom-callback/concurrency coverage limits and the proper remaining public
  implementation. No 80-declaration completion credit is assigned to this work.
  A real alignment experiment failed; the private checked boundary now rejects
  invalid SDK preconditions and preserves output on actual allocation failure.
  Long-term: use/review that validation in real public wrappers and implement
  the distinct Jai context/callback/config/heap semantics without native casts.
  The initial host-only x64 archive failure is fixed by a real universal archive,
  not a search-path/compiler override. General private-unit staging now copies
  dependent test sources without editing bytes/facades or bypassing visibility.
  The pinned SDK's native `thread_collect` body is empty; calling that real
  symbol proves forwarding only, not deferred-collection behavior. Its native
  linker-reference hook is intentionally empty. Neither receives public
  implementation credit. Public collection semantics require proper completion.
  The invalid-alignment raw SDK experiment is classified as an incorrect oracle
  outside its documented caller precondition, not a public compatibility defect;
  the checked helper's safety contract is separate. SDK configuration pointers
  remain borrowed/read-only despite Jai's lack of const qualification. Windows
  SDK/CRT/advapi32 packaging and Linux/Windows runtime evidence remain missing.

- **D3D dependency and compiler staging repair.** Refreshed only safe NEW
  producer compiler sources. Its general forward-overlay fix now passes our
  original storage-sharing regression; no local compiler patch remains.
  Removed unnecessary/inverted module imports and used the existing canonical
  shader-compiler COM definitions, preserving all public types/aliases/vtables.
  [Details](../native/d3d-source-dependencies.md) record the independent general
  imported/local alias lookup bug, real source/privacy improvements, the two
  unresolved convenience overloads, remaining aggregate ABI risks and unavailable
  Windows runtime. The dependency cleanup is permanent architecture, not a
  special-case workaround. The general alias bug still requires compiler repair;
  its assertions stay active. Host strict lint cannot fully compile Windows-only
  roots while the linter lacks target selection; do not count that as a pass.

- **FSEvents public/native field-order mismatch, corrected.** The exact public
  40-byte record remains unchanged. `macOS.FSEventStreamCreate` now copies into
  complete SDK-correct private storage; the function address necessarily differs
  from the native symbol. No heap registry or callback convention conversion is
  introduced. All offset/canary/retain/release/null-context tests and real event
  delivery are active. [Details](../native/fsevents-context.md) record ownership,
  the corrected native-control test assumption, the narrow C SDK scheduling
  deprecation exclusion and optional description-callback coverage limits.
  Long-term: preserve the private adapter unless a reviewed public ABI change
  becomes authorized; audit any newly inventoried context-taking entry point.

- **Linux ARM64 public/kernel stat mismatch.** The three named wrappers now
  preserve the public x64 record/constants while using generated pinned native
  ARM64 syscall definitions and complete private storage, with explicit field
  marshalling. [Full details](../native/linux-arm64-stat.md) cover failure/null
  pointer semantics, zero reserved fields, raw-syscall limitations, fixed stack/
  copy overhead and missing Linux runtime evidence. GNU ARM64 C ABI assertions,
  four Unix source configurations and both macOS runtime programs pass. Proper
  follow-up is real Linux ARM64 execution and continued audit of other raw
  x64 Linux ABI constants/records; no public layout is altered to pass a probe.
- **Current foundation dependency.** NEW foundations now uses a separate
  `internal/basic-context` for its debugger context extension. Staging copies
  that actual producer module; no substitute definition/bootstrap is created.
  The intermediate missing-module failures remain in
  `.work/posix-stat-adapter-final.json`. Current-source retry and actual formatter
  build pass. The earlier invalid octal spelling in the new test was corrected
  to reviewed POSIX permission constants; its failure report is retained.

- **Android POSIX records, resolved source association.** Complete pinned
  official Bionic headers now supply eight target declarations for four
  inventoried records, with per-field and complete C layout assertions on both
  CPUs. No other OS shape is borrowed; explicit reviewed target shapes win.
  See [delegate provenance](../native/android-posix-delegates.md). Android Jai
  compilation/device execution still fails/is unavailable and is not claimed.
  Proper follow-up remains general compiler target support and real device ABI
  tests; source disposition counts do not establish completed native support.
- **ImGui owner tracking and C++ dependency.** The old public-name verifier
  incorrectly asked for a flattened nested method. Qualified owner metadata
  now checks the actual reviewed API, with no invented alias. Real Jai native
  SDK calls pass layout checks, construction, split and SDK-domain cleanup.
  [Details](../native/imgui-nested-methods.md) record explicit C++ runtime
  linkage, constants-only import overhead, Windows evidence limits and the
  general dependency-graph refinement. Other provisional ImGui layouts are
  unchanged and remain required ABI work.

- **iOS helper availability and private host testing.** All three facade
  helpers now obey reviewed iOS-only availability. The old host fixture was
  an invalid target expectation; its public assertions remain active under
  required iOS source checks, which fail on the compiler's unsupported OS.
  An unchanged private unit is placed inside the staged library boundary to
  test the real native shared implementation, without weakening private import
  checks or exporting a test backdoor. Native SDK lookups/cache identity and
  growing-buffer/read-error/process-status behavior are checked independently.
  See [toolchain details](../native/apple-toolchain.md) for process-lifetime
  allocations, failed-log abort policy and unsynchronized cache first use.
  Proper long-term fix: general compiler iOS support and reviewed concurrent
  cache policy followed by real target verification. A private host pass is
  not a public iOS execution pass.
- **NEW File staging and Windows renderer blocker.** Staging now overlays only
  the platform-io owner's File facade, File implementation, Unix/Windows native
  files and windows-text dependency, preserving foundations' File_Utilities
  internals. This removes the stale Unix-only File guard from Windows tests.
  The actual Windows renderer/event test now fails on a general fixed-array
  type-literal issue in NEW producer Unicode. A minimal independent example
  reproduces it; see [compiler blocker](../native/compiler-fixed-array-literal.md).
  Neither producer source nor local compiler was patched to hide the failure.

- **Android EGL constructor, unverified target.** The new real native route
  chooses an ES2 RGBA8/depth24 window config, halves requested MSAA toward zero,
  initializes EGL, creates context/surface and makes it current. Those default
  profile/format priorities are independent policy; the reviewed interface
  specifies no version parameter or ranking. Native failure returns the partial
  `EGL_Info`, retaining any failed-cleanup handles. Display initialization is
  shared: failure does not call eglTerminate and disrupt another EGL client;
  caller lifetime management remains necessary. Binding the ES API is a thread
  side effect even on later failure. `egl_create_surface` uses the official NDK
  private geometry prototype, preserving the public camera-context alias/enum.
  The ordinary compiler rejects Android targets, so neither type checking nor
  device execution is claimed. The device exercise requires a real native
  window; its invalid-input main alone is not native constructor evidence.
  Proper long-term fix: reviewed default/failure ownership policy and general
  compiler Android support, followed by real device/API/ABI tests. No target
  constant overrides or native SDK mock are used to manufacture a pass.

- **SDL RWops adapter removed after reviewed contract clarification.** The
  earlier custom-stream adapter changed SDK pointer identity and introduced
  default-context/copy policies not established by the current reviewed spec.
  `SDL/wrappers.jai` no longer contains that owner, registry, or callback bridge;
  the factory binds to its real symbol and the BMP loader now applies only the
  documented scalar close-flag adapter. The 48-byte
  public prefix cannot be used as a complete native value or Jai callback table.
  Supported SDK-owned pointers remain safe to pass back to SDL. The private
  complete native record is used only for explicit C ABI access/probes. Tests
  now check symbol identity, real file operations, BMP decode, native close
  lifetime on success/failure and both freesrc modes. Historical custom-table
  passes are retained as historical evidence only. Proper long-term resolution
  of standalone public record mismatch requires a reviewed API change; no
  public fields/signatures are changed here. Exact public-prefix and complete
  private native layout tests remain active under the corrected reviewed oracle.
- **X11 helper policy and native evidence.** The independently authored simple
  window helper creates an unmapped borderless Xlib window at (0,0), using the
  parent's screen pixels; parent 0 selects the default root. It sets both the
  legacy name and explicit-length UTF-8 EWMH name. The attention helper sends
  the EWMH ADD request to that window's actual screen root; it does not pretend
  the window manager acknowledged the asynchronous hint. Invalid attention
  handles / failed native request allocation abort; normal server errors keep
  the existing handler. Linux source checks pass; a real X server runtime test
  is supplied but unavailable on this host. Exact toolkit decoration/map policy
  is unspecified; proper follow-up is reviewed policy plus Linux native CI.
  Text panels/buttons use independently chosen black/white styling and the
  server's default core font. Text panels wrap byte characters and newlines,
  clip to the requested rectangle, and measure each character once; they do
  not promise Unicode shaping absent a reviewed font/text contract. Buttons
  invert foreground/background when pressed and center the label. Their GC
  and queried font information are independently owned/freed, so the default
  GC is unchanged. Unrepresentable X11 16-bit clip coordinates/dimensions abort.
  The X-server test now draws both states and reads native pixels; execution
  still requires Linux/X11 and is not counted as a host pass.

- **2026-10-14 update: formatter dependency resolved.** Refreshing the safe
  producer compiler incorporates its general scratch-context initializer fix.
  The actual formatter now builds unpatched against current NEW foundations;
  staging includes their new `internal/native-path`. Previous trial evidence
  below is historical, not the active production tooling route. Current strict
  lint of GL/POSIX/WGL internals/all native tests passes without exclusions.
- **Distinct shape availability.** Reviewed POSIX shape sections deduplicate
  identical CPU shapes. The parser now associates a sole per-OS CPU shape with
  that OS's declared CPUs, retaining distinct variants. This relies on the
  reviewed distinct-shape inventory contract and latest explicit review; no C
  SDK layout is substituted into the public API. Remaining eight Android
  declarations have no same-OS shape, and remain unresolved. Proper long-term
  spec representation: list every availability condition beside shared shapes
  to avoid implicit association. Host sizes/offsets/getitimer and four desktop
  POSIX source/public matrices pass; Android native verification is unavailable.
- **WGL format/default policy and Windows evidence.** See
  [WGL implementation](../native/wgl-context.md) for complete location, selected
  defaults, fallback ranking, cleanup abort policy, pixel-format side effect and
  unpreserved last-error details. These choices are independently authored where
  the oracle leaves private policy open. Windows x64/ARM64 source checks pass;
  native Windows test execution and layout probes remain required. Proper fix
  for any stricter behavior requirement is a reviewed contract and real Windows
  CI, not altered public handles/signatures or fabricated host evidence.

- **Current formatter compiler regression.** After refreshing the latest NEW
  compiler and foundations, building the actual formatter ICEs because three
  scratch contexts bypass the new context-slot initializer. This is distinct
  from the resolved print/exit blockers. A general original reproducer and
  three-site setter patch are in `docs/native`; the trial passes native and
  interpreter checks, scoped rustfmt/clippy, and builds the actual formatter
  against current foundations. All owned Jai formatting/regeneration checks
  then pass with that formatter. The canonical compiler and source were
  restored; its current hash is recorded in the regression document. This is
  an explicit compiler proposal dependency, not a fixture formatter or an
  unreported production compiler fix. Proper fix: integrate the general
  initialization invariant and rerun the ordinary formatter build. Evidence:
  [context-probing regression](../native/compiler-context-probe.md) and
  `.work/latest-format-regeneration.json`. Staging also now includes the
  foundation-owned `internal/basic-interface` dependency introduced by the
  current Basic module parameters; no facade aliases or bootstrap copies were
  invented to bypass it.

- **Staged GL SDK integration repairs.** The real CGL/GL program was initially
  blocked by two peer AppKit imports and missing compiler reflection flags.
  Current NEW window sources now contain the correct imports, so that staging
  repair and its active patch were removed. The general compiler proposal is
  supplied under `docs/native`, with an original standalone reproducer. Only
  owned test copies were changed. The trial compiler passed
  scoped rustfmt/clippy, native/interpreter metadata checks and real OpenGL
  shader/buffer checks. This is SDK validation, not production integration.
  The default compiler source and binary were restored, its exact original
  hash checked, and its failing reproducer rerun. Restoration required updating
  the restored source mtime before rebuilding, since copy2's older mtime let
  Cargo initially reuse the trial artifact; the final restored failure proves
  that stale reuse is no longer present. No successful default integration is
  inferred from the trial. Evidence and long-term fixes:
  [GL SDK validation](../native/gl-sdk-validation.md). Coordinator must review
  and integrate the general fix and actual peer imports. The proposed compiler
  temporarily tracks one erasure boolean per reflected field while generating
  metadata; it adds no program runtime cost. Future compiler metadata transforms
  should carry their semantic flags alongside transformed fields.

- **Current verification scope.** The broad current-foundations report is
  `.work/latest-production-sources-worker.json`: 65 failed/unimplemented
  checks, including 13 privacy checks blocked before their required diagnostic.
  It precedes the final GLX/alias additions; subsequent scoped reports retain
  their own staged hashes and do not overwrite its failures. The expanded
  `.work/privacy-desktop-matrix.json` checks all six desktop configurations:
  40 pass, 14 fail before the required diagnostic, and 24 lie outside explicit
  reviewed module targets. The privacy-only mode avoids repeating native
  suites while retaining this entire matrix; normal verification also runs
  it. Proper fix: resolve the actual POSIX/D3D dependency failures and rerun,
  rather than treating an unrelated import error as a privacy pass.

- **Source staging (`tools/native_bindings/verify.py`).** Tests copy NEW peer
  sources into durable isolated trees, with one foundation prelude. Earlier
  evidence used a frozen independently authored foundation because current
  Basic had a stale top-level Buffer alias. That is staging evidence, not
  production integration. Current staging now overlays the designated
  foundations worker's Basic/String/Hash/File_Utilities and their internals;
  it removes the stale Buffer and formatter exit/print blockers. Evidence:
  `.work/current-foundations-retry.json` and
  `.work/formatter-current-foundations.json`. Risk: peer snapshots can change
  independently. Proper fix: coordinator integrates the owned modules into one
  production tree and reruns the suites; preserve source hashes in each report.
- **Formatting regeneration.** Raw spec text does not follow repository
  formatting. `generate.py` and `vendor_context.py` now accept `--formatter`
  to normalize with the actual source-built repository jaifmt before writing
  or comparing. Both formatted regeneration checks passed. Raw generation is
  retained for generator unit tests and bootstrap; use the formatter option
  for checked-in output. Risk: omission regenerates unformatted files; proper
  fix is a production developer command that builds the tools and always
  supplies that option. No formatter rules are disabled.
- **Coverage scanner repair.** The authored-body scanner previously could
  consume a later record's opening brace after a foreign prototype. It now
  respects declaration terminators, ignores quoted delimiters and rejects
  foreign headers even without semicolons. An original regression failed
  before the fix and now passes. AppKit supplemental metadata only scans the
  public section, so helper prototypes are not listed as public implemented
  members. This is a repaired false-coverage cause, not a retained workaround.
  Proper longer-term validation is compiler AST-backed signature/body
  inspection once the integrated dependency tree can be analyzed completely.
- **Lint isolation.** Earlier all-at-once jailint terminated with a bus signal;
  per-directory invocations retain all rules and warnings-as-errors. Evidence:
  `.work/bindings-lint-reviewed.json`. This avoids accumulated tool state, not
  a lint exclusion. Proper fix: investigate tool memory/lifetime handling and
  rerun the full integrated lint command. Current per-directory results are
  recorded separately in `.work/current-owned-quality.json`.

## ABI gaps and native availability

- **SDL WM-info adapter.** `internal/bindings/sdl-native` retains the complete
  pinned SDK's 64-byte native union and signed native discriminator. The
  public `SDL_GetWindowWMInfo` is now a `#c_call` wrapper, with the exact public
  argument/result types, forwarding to a private foreign declaration with the
  original library symbol. Its procedure address therefore belongs to the
  adapter, not directly to SDL's symbol; this is required to prevent writing
  native storage into the smaller public record. It copies only the reviewed
  per-platform fields after checking the subsystem. Other subsystems return
  SDL_FALSE with a real SDL error, leaving the output untouched. This is an
  explicit representational limitation (e.g. Wayland cannot fit the X11
  public branch), not a fabricated successful handle. Proper long-term fix:
  retain marshalling, pin/package the production native SDK/runtime, and test
  each platform/subsystem; extending public fields requires reviewed API
  changes and is not done here. Evidence: real hidden Cocoa window plus error
  propagation and public-record canaries in `sdl-wm.jai`, and independent
  C sizes/offsets/union-storage checks from the pinned official 2.32.70 SDK.
  The native source is loaded directly for the ABI unit comparison; this
  does not create public facade exports. Runtime build/run succeeded; Windows
  and Linux runtime coverage remains required. Stack storage adds a bounded
  72-byte native record per call; no heap allocation or global registry is
  introduced. Historical RWops/UserEvent full-size failures remain in prior
  evidence; current tests distinguish public prefixes from complete native ABI.

- **SDL public prefixes (`stdlib/SDL/declarations.jai`).** Reviewed RWops is
  48 bytes and UserEvent 8; pinned SDL 2.0.1 native records are 72 and 32 on
  the tested 64-bit host. Public fields remain exact. Per refreshed
  `docs/sdl-layout-verification-policy.md`, `sdl-layout.jai` now asserts exact
  public sizes/offsets separately from complete private native sizes/all offsets.
  The prior full-size equality oracle was invalid; its failing evidence is
  preserved, not counted as a repaired native-value interchangeability contract.
  Refreshed review explicitly supports SDK-owned pointers and does not support
  constructed/copied Jai callback tables. The factory preserves SDK pointer and
  symbol identity; the BMP scalar adapter preserves stream identity. No public record is allocated/passed
  as native RWops. Whole SDL_Event storage remains native-sized and user-event
  payload bytes retain genuine native round-trip coverage. Risk: dereferencing
  public callback fields as Jai procedures is incompatible with native C.
  Proper long-term fix for standalone shape mismatch requires a reviewed API
  change. Full-value interchangeability remains unsupported. Private C storage
  includes native-only fields; real event window ID/code/two-pointer round trips
  now also retain surrounding canary coverage. Current host checks pass; six
  desktop source checks remain distinct from pending Linux/Windows runtime.
- **Other provisional SDK layouts.** D3D anonymous overlays, ray-instance
  packed fields, ImFontGlyph and some Darwin packed records have public shapes
  that are incomplete or conflict with native layouts. Bitfield helpers
  perform actual extraction/update but do not establish aggregate ABI
  compatibility. Some D3D overlays also require general compiler support for
  inherited/forward overlay anchors. Evidence: broad/configuration reports
  and questions document. Risk: native memory corruption if such records are
  passed directly. Proper fix: resolve general compiler semantics, compare
  complete pinned native layouts, and marshal incompatible public records;
  never reorder public fields to make a probe pass.
- **POSIX configuration shapes, corrected.** The distinct-shape association
  repair emits all macOS x64 reviewed aggregates/enums. Both macOS CPUs now
  execute source-built C/Jai size/offset/getitimer and ordinary POSIX runtime
  tests successfully (`.work/posix-sdk-both-cpus.json`); x64 uses OS translation
  on this ARM64 host. Eight Android declarations still lack a same-OS shape.
  No cross-OS layout is guessed. Earlier missing-x64-shape assumptions and
  failure reports are historical; they are not current blockers.
- **Native dependencies.** `.work/native` contains actual source-built pinned
  libraries, plus documented installed Apple/FreeType/Curl/SDL runtimes. These
  are development inputs, not release packaging. NVTT member declarations
  come from its complete pinned public header, with six target symbol checks,
  but no NVTT runtime was built. Windows D3D/DXC/Aftermath, enabled telemetry,
  and mobile SDK/runtime tests remain unavailable or incomplete. Proper fix:
  build/package pinned production dependencies and exercise real platforms.
  Never replace them with fake SDK entry points.
- **Arithmetic/bridge probes.** D3D arithmetic tests compile actual selected
  SDK macros; they are private unit evidence, not a Windows runtime test.
  ImGui symbol-only cross-target checks do not test C++ object layout. Real
  host ImGui tests build full SDK units and use a real libffi bridge. External
  headers use `-isystem` while owned probe code uses warnings-as-errors.
  Risks: vendor/target ABI differences remain outside these probes. Proper
  fix: complete native target tests and explicit aggregate ABI adapters.

## Reduced or unresolved behavior

- **NSOpenGL constructors.** Both overloads now allocate real AppKit pixel
  formats/contexts, report actual native samples, preserve the caller's current
  context and attach a supplied window's native content view. The internal
  pointer-only NSOpenGLContext type has one canonical identity across GL module
  configurations and is not a facade export. Versionless core creation prefers
  4.1 then 3.2; pre-3.0 requests use the legacy profile; 3.1/3.2 use the 3.2
  profile; 3.3/4.0/4.1 use the 4.1 profile. MSAA is reduced toward zero if a
  format is unavailable. These selection priorities are independent policies
  where the reviewed declaration does not specify exact fallback order.
  Pixel formats request 24 color bits, 8 alpha bits, 24 depth bits and double
  buffering; these are explicit native format requirements, not fabricated
  reported values, but exact default-format policy still needs contract review.
  Unsupported profile/version combinations and debug-context creation
  diagnose and return null; NSOpenGL exposes no debug creation attribute.
  This is a genuine native API limitation, not an ignored debug flag. Proper
  fix: review exact default/fallback policy and validate other Mac hardware.
  Evidence: real core/legacy contexts, CGL sample-count comparison, hidden
  Cocoa window attachment, context-current preservation, canonical type
  identity, unsupported-request assertions and SDK resource teardown in
  `tests/native-bindings/nsgl.jai`, run with the unpatched current compiler.
  NSOpenGL.h is pinned in the native SDK identity document. The earlier staged
  AppKit import repair is no longer needed with current NEW peer sources.

- **GLX context creation.** The GL wrapper now implements real legacy and ARB
  creation, chooses an RGBA window configuration matching the existing native
  window visual, reports its actual sample count, and releases enumeration
  buffers/visual descriptions. It reads the canonical exported X11 display;
  a missing display returns null rather than silently opening another owned
  connection. Requested debug/profile features require their real extensions
  and entry point. Native X errors use the caller's existing error handler;
  no process-global handler replacement or error swallowing is introduced.
  Making current and eventual context destruction remain caller-owned.
  Evidence: Linux x64/ARM64 no-DCE instantiations with default and modern
  arguments. There is no host Linux GLX server/runtime test; source checks are
  not native success claims. Proper fix: native Linux server/context tests and
  explicit reviewed global-display initialization/error/lifecycle contracts.
  Private missing GLX C prototypes come from the pinned complete official
  libglvnd v1.7.0 header; corrected X11 library spellings are GLX and X11.
  WGL and generic context dispatch still remain required gaps.

- **AppKit contextual facade.** `Objective_C/AppKit/module.jai` implements the
  newly reviewed window enums, nominal prefixes and typed messages. NSView and
  NSScreen are private opaque pointer types, with no asserted instance layout.
  Current review resolved setTitle: its id result is intentionally unspecified
  and must be ignored. The wrapper now dispatches the actual native void ABI
  and returns the existing receiver under that unspecified signature, rather
  than reading an undefined return register. Real UTF-8 title assignment is
  checked against the Cocoa getter. The NSView frame alias is tested on a real
  NSView, including procedure identity. Current NEW window sources use the
  correct AppKit import; no root exports or peer files were changed here.
  Hidden-window/context attachment is tested, but displayed rendering and
  full interactive window lifecycle remain coordinator integration work.

- **Open wrappers.** Android glue/assets/context lifecycle, EGL context
  creation, remaining WGL/generic GL context creation, X11 global
  display/clipboard/DnD/widgets, Objective-C class generation/encoding,
  D3D/DXC convenience compilation, rpmalloc rewrite/raw paths and enabled
  telemetry still contain unresolved ledger entries. No placeholder body is
  treated as support. Exact signatures and unresolved reasons remain in the
  ledger and questions document. Observable effect: required APIs are missing
  or blocked. Proper fix: implement their reviewed contracts with real SDK
  forwarding, ownership and error handling; rerun all configurations.
- **rpmalloc ABI.** The reviewed Jai configuration callbacks and heap fields
  differ from pinned native C declarations. Direct aliases would be unsafe;
  none are used to claim runtime support. RPMALLOC_FIRST_CLASS_HEAPS defaults
  and variant-dependent aliases need review/integration. Proper fix: a real
  allocator implementation or complete callback/configuration adapters and
  native runtime tests, preserving storage identity and canonical type names.
- **Failure policies.** Native buffer allocation/conversion, invalid GUID
  input, and X11 allocation helpers abort where their public return contracts
  cannot carry errors and exact malformed-input behavior remains unspecified.
  Locations: `internal/bindings/native`, Windows/macOS/X11 wrappers. These are
  explicit failures, not fabricated success, but may differ from unreviewed
  failure semantics. Proper fix: reviewed failure contracts and focused
  regressions. Risks include process termination on malformed input/OOM.
- **GL loading.** Loader only replaces non-null procedures and only sets
  supported flags true; this preserves caller-owned storage but reload/reset
  behavior is not established by the available contract. Two-pass resolution
  is required for indexed extension queries. Proper fix: review reload/error
  semantics and test real contexts on each platform. Current version parsing
  uses native sscanf and accepts suffixes; strict trailing-text behavior is
  still an open question.
- **GL debug output.** The helper implements real core/KHR/ARB installation,
  synchronous output, all-message controls, checked native logging and native
  break-on-error traps. Unsupported/missing loaded debug implementations
  diagnose and abort rather than silently succeeding. This failure policy and
  exact diagnostic text remain independently chosen where review supplies no
  more specific behavior. Synchronous callbacks and flushing each message
  trade performance for immediate diagnostics. Context flags travel as a
  stable valid private object address, with no heap allocation or mutable
  global mode. Source checks pass on Linux/Windows; the host driver's native
  enumeration lacks these debug extensions, so callback runtime evidence is
  unavailable, not passed. Proper fix: reviewed diagnostics policy and native
  supported-driver tests, including actual trap/resume behavior. Extension
  detection currently rescans the native extension list for each reflected
  flag; this may slow large-table startup. A private per-load token index can
  improve it while retaining the public loader's existing-storage semantics.
- **GL output strings.** `_glGetActiveAttrib` and `_glGetActiveUniform` forward
  a string's data as caller-owned writable storage, preserving all native
  output parameters and the requested buffer size. Oversized requests abort
  instead of writing past the string's capacity. Passing read-only text as
  output storage is invalid. Source checks instantiate both procedures for
  Linux/Windows x64/ARM64; macOS remains blocked by the peer window import.
  No real GL-context output test has passed. Proper fix: integrated window
  dependencies and real-context tests, plus review of invalid-buffer failure
  policy. The bounds guard is a deliberate safety policy, not evidence of
  reference behavior for invalid calls.
- **Objective-C ABI/ownership.** Typed message forwarding uses stret on x64
  for results larger than 16 bytes; other target result classes need native
  coverage. The reviewed release helper has an unspecified return value;
  callers must not chain it. Runtime object lifetimes remain caller-owned.
  Proper fix: target-complete native method ABI tests and checked selector
  mappings, without substituting private helpers as public exports.
- **iOS host utilities, corrected.** The reviewed target guard applies to all
  three exports. The former host public invocation was invalid; native host
  behavior is now tested through a clearly labeled private implementation unit.
  The unchanged public fixture remains checked on both required iOS CPUs.
- **Intermediate matrix snapshot.** `.work/current-owned-full.json` staged
  source before X11 UI bodies were added while its source-regression fixture
  was subsequently updated. Its two missing-UI source failures are retained
  as an incoherent intermediate snapshot; do not treat that report as final
  current-tree verification. Fresh scoped checks pass both Linux CPUs. Proper
  workflow is freeze code/fixtures before a fresh complete verification run.
- **Mobile checks.** Current compiler CLI rejects Android/iOS targets in
  configuration tests. Rejection is recorded as failure, not unsupported
  success. Proper fix belongs to the compiler worker: general target support
  and native SDK validation; bindings must retain conditional declarations.
- **Varargs overhead.** `internal/bindings/varargs` allocates native argument
  storage and uses libffi for dynamic Any arguments, promoting C scalar types
  and terminating strings. This is real forwarding, with measured correctness
  rather than a fabricated format result, but has allocation/dispatch cost.
  Proper optimization: compiler-supported general C vararg lowering after
  semantic/ABI regression coverage; retain rejection of unsupported values.

No completion claim is made for the outstanding declaration, configuration,
layout, privacy or runtime failures. Coordinator review must inspect both
this report and the machine-readable evidence before production integration.

- **Generic GL convenience lifetime and Linux result policy.** Current review
  now defines this helper, superseding the old unresolved-handle question.
  `stdlib/GL/wrappers.jai` creates a real context and makes it current; successful
  resources remain native caller-owned with no additional public storage or
  destroy export. This can leak if callers cannot recover/release native
  handles, an inherent void convenience API limitation. Windows make-current
  failure performs checked cleanup and logs; macOS attaches and sends the real
  void selector. Linux ignores wanted_msaa and does not inspect glXMakeCurrents
  return, explicitly required by reviewed behavior, rather than counted as an
  unreviewed ignored error. Proper controlled-lifetime usage is the existing
  platform constructor/native destroy APIs. macOS native current-context/view
  and release tests pass; Windows/Linux native execution remains required.

- **Refreshed production linter exposes incomplete roots.** The current safe
  producer tool now correctly fails incomplete compilation. Broad lint of
  Windows/Linux/mobile modules on macOS and direct private module roots fails
  their real guards/visibility rules; rpmalloc/D3D also retain code/semantic
  gaps. The CLI currently has no target-selection option. Earlier all-zero
  lint evidence is historical for the earlier tool, not current complete
  semantic lint coverage. Initial refreshed invocation also omitted the stdlib
  environment; retry corrects that ordinary invocation mistake. Reports and a
  minimal target/root reproducer are in native/lint-target-context.md. Risk:
  unvisited bodies may still contain lint findings. Proper fix is general
  target-aware module-root traversal in jailint, followed by all target runs,
  plus actual remaining declaration fixes. No rule/global suppression,
  visibility relaxation, compiler hack or fake target is used as a substitute.

- **X11 modal presentation and execution boundary.** The new real
  `x_message_box` uses independently chosen fixed geometry, core-font clipped
  text, first-button focus and documented Escape/WM-close choices because the
  public signatures specify button styles/responses but no exact UI policy.
  It preserves other windows' events, accepts real mouse/keyboard/close events
  and releases its actual window/optional connection. Risk: long/non-ASCII
  messages and exact dismissal expectations need stronger reviewed contracts;
  no scrolling/Unicode shaping claim is made. Proper longer-term solution is
  reviewed UI policy plus accessible text layout/scrolling. The seven-style
  automated regression requires isolated Linux Xvfb without a reparenting WM;
  the event injector currently searches root children. Both Linux CPUs source
  check, but Linux native execution and semantic lint remain required. Initial
  source trial used nonpublic `IsViewable` and exposed the compiler's incomplete
  infinite-loop return analysis; fixed by a private officially pinned protocol
  constant with active C assertions and a real DestroyNotify exit path. No
  fabricated post-loop success value or compiler special case was introduced.

- **DXC reflection body not yet Jai-source/native verified.** The real COM
  route and executable regression are present, but the required Windows checks
  stop in the existing D3D12 forward overlay before this body is validated.
  Complete official native SDK headers/source and host adapter layout probes
  establish SDK buffer requirements only; they cannot substitute for Jai
  source, strict lint or Windows execution. Risk: body/lowering issues remain
  possible until those checks run. Proper fix is producer forward-overlay
  support followed by the actual Windows SDK executable and ABI validation.
  No fake COM objects, mock compiler/blob, altered D3D record order, test-only
  compiler patch or native success claim was introduced.

- **DXC compile ownership/performance and source boundary.** Each native compile
  creates independent compiler/utility/include-handler objects, copies UTF-8
  arguments and owns separate UTF-16 argument storage. This avoids shared SDK
  mutable/context lifetime and costs allocations/factory calls. Proper
  optimization is measured per-thread reuse after SDK thread-safety review.
  Native compilation and argument conversion source-check both Windows CPUs;
  the host pure serializer builds/runs and passes strict lint. Full public
  checks still stop at unchanged D3D12 forward overlays; Windows native and
  target-aware lint remain required. Private SDK routing reuses the single
  complete generated declaration schema, with no reduced fake interface or
  public type identity change. Its unused D3D12 import was removed while public
  reflection retains the canonical import. Private units are placed unchanged
  in the real staged dependency tree. DXIL debug embedding and empty-name/entry
  native defaults are explicit independent policies requiring review if exact
  differences matter. Header/private-unit passes do not prove public DXC runtime.

- **SDL scalar close flag ABI repair.** Public `freesrc: int` is 64-bit; the
  complete native SDK accepts a 32-bit C int. Before repair, a real file passed
  with `0x1_0000_0000` stayed open because native SDL saw zero. `SDL_LoadBMP_RW`
  now forwards the identical SDK-owned pointer and native 0/1 from the full
  public flag. The factory stays the actual SDK symbol. Observable tradeoff:
  the loader function address belongs to the scalar adapter, with unchanged
  public types/names/convention and stream identity. No layout expansion,
  owner registry, custom callback context or new export is introduced.
  Before/after native reports preserve the failure and successful repair;
  original RWops/UserEvent size assertions still fail. Proper long-term
  standalone shape/callback resolution requires reviewed API changes; this
  scalar conversion is the safe boundary required by the existing contract.
