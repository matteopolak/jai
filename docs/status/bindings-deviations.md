# Bindings implementation deviations

This is an open implementation audit, not a completion claim. Scope: the 34
owned facades, `internal/bindings`, generators and native tests. The exhaustive
declaration ledger is [bindings-coverage.json](../native/bindings-coverage.json).
An emitted declaration or resolved symbol does not establish layout or runtime
correctness. Previously recorded failures remain required work.

## Integration and tools

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
  SDL-owned RWops pointers have native storage and can be passed back to SDL.
  Caller-allocated public RWops must not be passed as native records. Whole
  SDL_Event storage is native sized; tests retain native user-event payload
  bytes through its padding. Risks: caller allocation and callback calling
  conventions cannot be made safe by a cast. Proper fix: private complete
  native storage and explicit callback marshalling where the public contract
  permits it, with diagnostics for unrepresentable operations. No native
  undersized-object adapter has yet been claimed implemented.
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
- **POSIX configuration shapes.** Current reviewed macOS x64 ipc_perm is
  emitted. The next x64 failure is itimerval: its public inventory includes
  x64 but its reviewed shape is labeled ARM64 only. The generator deliberately
  does not assume architecture independence. Evidence:
  `.work/current-foundations-retry.json`. Risk: incomplete x64 module checks.
  Proper fix: reviewed missing shape contracts (including remaining ledger
  entries), then regenerate and run native size/offset probes. No guessed
  public layout is counted as implemented.
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
  WGL, NSOpenGL and generic context dispatch still remain required gaps.

- **AppKit contextual facade.** `Objective_C/AppKit/module.jai` implements the
  newly reviewed window enums, nominal prefixes and typed messages. NSView and
  NSScreen are private opaque pointer types, with no asserted instance layout.
  `setTitle` preserves the reviewed id result signature although native
  setTitle: returns void; its value is not validated or promised. This is an
  unresolved return-contract discrepancy, not a fabricated stable value.
  Proper fix: review that result contract, then use the matching native void
  message signature and explicitly specified wrapper result. The NSView frame
  alias is tested against a real initialized AppKit NSView; no window-server
  or displayed-window runtime behavior is claimed. Window-render currently
  imports these contextual names from root Objective_C; it needs the reviewed
  submodule import. No root exports or peer files were changed to bypass that.

- **Open wrappers.** Android glue/assets/context lifecycle, EGL context
  creation, remaining GL platform context creation/debug, X11 global
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
- **iOS host utilities.** Real xcrun SDK discovery is implemented; public
  target guards currently hide get_ios_target_triple on macOS despite host
  tooling use. Existing failing host fixture remains recorded. Proper fix:
  resolve the reviewed guard contract and test both host tools/mobile targets.
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
