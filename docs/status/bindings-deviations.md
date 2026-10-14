# Bindings implementation deviations

This is an open implementation audit, not a completion claim. Scope: the 34
owned facades, `internal/bindings`, generators and native tests. The exhaustive
declaration ledger is [bindings-coverage.json](../native/bindings-coverage.json).
An emitted declaration or resolved symbol does not establish layout or runtime
correctness. Previously recorded failures remain required work.

## Integration and tools

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

- **SDL RWops adapters (active implementation).** `SDL/wrappers.jai` now uses
  complete private desktop `sdl-native.RWops` storage and typed C callbacks for
  BMP decoding. `SDL_RWFromFile` allocates a public-prefix wrapper with native
  ownership kept after that prefix; public callbacks independently forward file
  operations with count/origin/result range checks. No native C code receives
  the public 48-byte record. Observable tradeoff: each file handle has a small
  extra wrapper allocation and each callback has an extra forwarding call.
  A private live-handle registry guarded by real SDL atomics prevents copied
  public callbacks from reading private storage past a copied record. Copies
  are rejected with a real SDL error, preserving the original live stream.
  Lookup is linear in live file handles; a private hash map is the proper
  performance refinement if high handle counts matter. Closing a handle while
  another thread uses that same handle remains outside the native file API's
  lifetime contract; different-handle registry access is synchronized.
  The original public native entry point is a C function with no hidden Jai
  context, while public RWops callbacks require one. The adapter deliberately
  supplies a default `#Context` to those callbacks; a caller's pushed context
  cannot cross that C ABI. This policy is explicit in the regression and remains
  a contract question, not claimed reference context behavior. Proper long-term
  solution: reviewed context/ownership semantics or an explicit context-bearing
  supported interface, without changing the existing API. Native sizes/offsets,
  custom streams/canaries, real BMP decoding, file read/write/close and copied
  callback rejection tests pass on the host. Public RWops/UserEvent mismatch
  tests remain active failures.
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
  introduced. RWops/UserEvent discrepancy tests remain unchanged and failing.

- **SDL public prefixes (`stdlib/SDL/declarations.jai`).** Reviewed RWops is
  48 bytes and UserEvent 8; pinned SDL 2.0.1 native records are 72 and 32 on
  the tested 64-bit host. Public fields remain exact. The active
  `tests/native-bindings/sdl-layout.jai` intentionally reports the actual
  mismatch and fails; it has not been disabled or changed to accept it.
  Native storage now remains behind public callback wrappers; BMP calls marshal
  both native-file and caller-owned public streams through complete private
  C records. Public records are never passed as native RWops. Whole
  SDL_Event storage is native sized; tests retain native user-event payload
  bytes through its padding. Risks: caller allocation and callback calling
  conventions cannot be made safe by a cast. Proper fix: private complete
  native storage and explicit callback marshalling where the public contract
  permits it, with diagnostics for unrepresentable operations. The current
  adapter passes real custom-stream and file-stream tests; default-context
  policy and copied-record restrictions are documented above. The public
  shape mismatch itself remains intentionally visible in the original probe.
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
