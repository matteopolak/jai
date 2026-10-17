# Native binding contract questions

## Current shared contract status (2026-10-15)

The refreshed Objective_C helper and rpmalloc configuration sections resolve
the old encoding/validation/class-name/ownership/CAPS/cache/hugepage/advice
questions below. The corrected reviewed page confirms Selector and *void are
the same canonical type and both encode colon. Current Objective_C helper
bodies and immutable Mac SDK tests implement that review; these are no longer
seven active contract blockers.

Current binding work is implementation of remaining rpmalloc configuration
and platform semantics, not waiting for those historical answers. Graph-wide
metadata OOM transactionality remains an explicit implementation limitation;
the reviewed source does not establish a distinct public metadata-OOM policy.
Enabled telemetry still has genuinely unavailable commercial ABI. Android
compiler/device and other native platform verification remain required.

## X11/Android helper review resolved

The 2026-10-15 14:54 UTC inbox update and refreshed X11/Android pages resolve
the ten questions below. All ten names now have authored bodies; the native
command bodies use the full `USE_GLUE_NATIVE_PORT` layout, and foreign command
delegates use the compact external-runtime branch. These old questions are no
longer blockers. Android compiler/SDK device execution remains unavailable;
that verification limitation is distinct from missing behavioral contracts.
Only the fourteen enabled telemetry declarations remain unresolved root names,
due to the explicitly reviewed unavailable commercial SDK ABI.

## Shared Runtime integration resolved

The canonical private Runtime discard hook and its output-lock dependency are
now present in the shared source. Android writes/flush use that same queue
module. The logger consumes discard directly; no forced flush or public API
addition is used. Fresh shared interpreter/native Mac ARM64 O0/O2/sanitizer
host controls pass. Android compiler/device checks remain required, not
contract questions or successful SDK evidence.

Current per-API implementation/verification limits are recorded in
docs/status/bindings-shared-audit.json. The historical Objective_C/rpmalloc
policy questions below have been answered; fourteen enabled telemetry
declarations still require the unavailable commercial ABI.
Historical requests below do not reopen resolved Android/X11/discard questions.

## Historical filtered request, resolved by the above review

Rechecked the entire current `modules/x11.md` and `modules/android.md`,
`docs/spec-review-update.md`, and `docs/worker-inbox.md` after checkpoint
`0488c78`. The clipboard answer is resolved and is not being requested again.
The inbox has no subsequent helper answers. Please return public behavioral
contracts only for these ten signatures; no implementation bodies are needed.

| Procedure | Precise remaining question |
| --- | --- |
| `init_global_display` | Does it open the connection or require an existing one? What atom string does `x_global_non_protocol_atom` represent? Which XIM/XIC/cursor resources must it create, and what happens on failure or a second call? |
| `enable_drag_and_drop` | Are `typelist` strings MIME atom names? Does it write `XdndTypeList` to the target window, or retain a receiver acceptance list elsewhere? What happens to an earlier list and to an empty list? |
| `x_selection_notify_predicate` | Is its exact match `event.type == SelectionNotify`, or does it also filter window/selection/target? Is `arg` ignored; otherwise what public value/layout does it point to? |
| `android_app_read_cmd` | Confirm the foreign declaration is the `USE_GLUE_NATIVE_PORT` branch and the body signature is the compact branch. Where does a compact `Android_App` obtain its command channel, and what is returned for EOF/read failure? |
| `android_app_pre_exec_cmd` | For the compact branch, which commands update which public fields, and where are pending input/window/rectangle values obtained when those fields are absent from the public record? |
| `android_app_post_exec_cmd` | Which compact-branch commands release saved state or acknowledge lifecycle transitions, using which ownership and synchronization rules? |
| `android_file_exists_in_package` | Which asset manager is used when `DEFINE_ANDROID_MAIN_AND_CALL_THIS` is null and no public `android_app` exists? Is a successfully opened zero-length asset considered present? |
| `android_directory_exists_in_package` | Same manager question; can an existing empty asset directory be distinguished from a nonexistent one, and what is the required result in that case? |
| `android_finish_activity_and_exit` | Which activity is selected without the conditional global? Must it call `ANativeActivity_finish` before process exit, and is `status` forwarded unchanged to libc exit? |
| `android_logger` | Does `data` designate a C tag string, a Jai string, another context, or nothing? Specify the tag and the mapping of `Log_Info` to native log priority, including nonterminated message handling. |

Official native app glue semantics can establish the complete SDK record and
its native commands; they do not establish a compact public record's private
association or the asset/logger convenience policies. A compact public pointer
must never be forwarded to the full SDK record. Likewise XDND defines native
properties but does not select this facade's argument/storage policy. No guessed
implementation or unsupported-success stub has been added. All ten remain
missing until the necessary contracts are supplied. Enabled telemetry fourteen
is a separate, confirmed absent-commercial-SDK ABI limitation.

Historical missing interfaces before that review:
Android seven, enabled telemetry fourteen, X11 three. The X11 clipboard release
contract is implemented and tested; its earlier ownership question is resolved
for module allocations freed through the canonical calling allocator domain.
The refreshed page still supplies no behavior for these three distinct helpers:

- `init_global_display`: enumerate the required atom strings, especially the
  nonstandard `x_global_non_protocol_atom`; specify XIM/XIC/invisible-cursor
  creation, display failure handling and repeated initialization ownership.
- `enable_drag_and_drop`: does each string name a MIME atom, where is its list
  stored (XdndAware, XdndTypeList or private state), and does it replace/append
  existing properties? The native XDND protocol alone does not define this
  convenience procedure's use of its list argument.
- `x_selection_notify_predicate`: is the match only SelectionNotify or also
  requestor/selection/target? What, if anything, does arg point to? Its opaque
  XPointer signature is not enough to safely dereference a guessed record.

At that checkpoint Android still needed its native-app command state/compact-glue association,
asset-manager acquisition when the exported android_app global is conditional,
empty/missing asset-directory semantics, finish/exit order and logger data/tag
policy. Native NDK declarations do not specify those Jai helper conventions.
Enabled telemetry is blocked by the reviewed absent matching commercial SDK
and authoritative tmGetApi ABI; no fake enabled route will be counted.

Current shader update: the refreshed D3D define-slice/COM ownership and DXC
version text contracts are implemented. Earlier grammar/format requests below
are historical, not blockers. Native Windows execution remains required.
Exact-byte blob copies retain any native terminal NUL; please flag if review
intended a separate diagnostic-NUL trimming rule. Private COM failure handling
uses active assertion and cannot continue into invalid native interfaces.

Objective_C follow-up after refreshed member-stub review: all eight helper
bodies now execute for native C-compatible types. The member-stub output and
handle cleanup are implemented; please clarify framework path spelling, since
/System/Library/Frameworks/<framework>/<framework> omits the installed bundle
suffix. We try that path followed by <framework>.framework/<framework>.
Precise remaining encoding questions: how do Selector (alias *void), arbitrary
*void, Class and object pointers map to type codes; what are required encodings
for string/Any/view/resizable-array arguments; what does pointer_depth select?
Are callers owners of each returned encoding string, and must validation use
any error mechanism beyond active assertion? Class naming currently follows
canonical reflected name, collisions return null, and native ivar offsets/size
are validated against the fragile record. Please specify any different naming,
default-initialization or collision contract. These policies are documented
independent support, not inferred reference behavior. D3D/DXC/X11 refreshed
behavior is now implementation work; telemetry14 requires its missing matching
commercial SDK, as explicitly reviewed.

2026-10-15 metadata/profile follow-up after `4fa38d7`: all thread/global cache
selections now execute through real SDK profiles. Heap acquisition reserves
typed canonical handle storage before SDK mutation; reservation OOM returns
null with ENOMEM, and real native acquisition failure releases that reservation.
This is an explicit independent resource policy, not a claimed original OOM
guarantee. Graph/default-thread association exhaustion still reports/aborts.
Please specify whether metadata exhaustion has any public error-callback or
errno requirement; successful public contracts and genuine failures continue.

Precise remaining option contracts: does LINUX_HUGE_PAGES request huge pages
unconditionally, or only enable their use when config.enable_huge_pages is set?
What fallback/error is required when huge pages or MADV_FREE are unavailable?
For nondefault HEAP_ARRAY_SIZE, is physical private hash-table sizing observable
or is equivalent ownership behavior sufficient? Does DEFAULT_SPAN_MAP_COUNT
constrain both callback mapping batches and heap reserve caps, and what values
are valid? The pinned official SDK defines the latter as a compile-time policy
and does not have the Jai LINUX_* switches, so these are not safely inferred
from C macro names. A separate precise combination question: with adaptive
cache=true, thread cache=false and statistics=false, the reviewed public Heap
still has span_use/current/high, but the official SDK disables adaptive counters
when thread caching is absent. What observations are required for these public
fields? Their presence must be preserved; unavailable native counters cannot
be silently replaced by invented statistics. No additional profile is claimed from assumed semantics.

2026-10-15 follow-up: the synchronized generic mode table and builder contract
resolve the allocator-data, old_size, CAPS bit encoding and dump appending/no-op
questions. All reviewed modes and both builder forms now execute for the
supported native profiles; all18 original configuration checks pass. One
precise omission remains: the mailbox says the exact CAPS name was supplied,
but the page says only "the allocator's stable name string" without its bytes.
Please supply its exact spelling/case. All other specified modes can proceed.
Raw PRETTY_PRINT also has no public selection/default; existing actual SDK
text output will be an explicitly documented private true packaging policy,
with an explicit private off selection and retained output-gating tests.

Production integration handoff: the worker's pinned/native profile builder now
builds all24 SDK/callback domains and immutable capture helpers. Please retain
the full identities from `rpmalloc-sdk/provenance.json`, SDK preparation/hash
checks and callback shared-library dependencies in final package builds. The
supplied worker snapshot's root native-libs.json lists only legacy rpmalloc;
no final Windows/package proof is inferred from worker host archives. xxHash
ARM64 is exclusively assigned to native-build-repair, so no duplicate work.

Other36 questions below remain active after rereading the current Objective_C,
X11, D3D compiler and DXC helper contracts. In particular, please supply the
X11 clipboard buffer's allocation/free domain and initialization ownership,
XDND typelist interpretation and selection predicate argument layout; these
four bodies cannot safely infer caller ownership from their public declarations.

The raw heap profile now has real reviewed canonical records, atomic publication
and all eleven SDK-backed procedures. `configure_rpmalloc.py` supplies the
otherwise undeclared selection through a private build module (false default),
not an extra public import parameter. Twenty previously unresolved conditional
procedure/alias entries are now implemented for this explicit source profile.

Original general lint reproducer:
`stdlib/Bindings_Generator/tests/driven/sdk/compiler-repros/lint-module-context/modules/Example/module.jai`.
Linting that module alone freezes bootstrap Context before its #add_context;
normal main compilation and explicit `jailint --context main.jai main.jai`
work. Proper long-term lint fix: load the target module/context additions before
finishing/bootstrap layout, preserving lazy required-parameter initialization.
The private SDK error fixture is a standalone program inside staged stdlib for
private imports; it now uses the existing --context program root option. No
fixture body, assertion, lint rule or compiler/module special case was removed.

Canonical heap follow-up: eleven rewrite heap APIs and SDK-backed field/graph
marshalling now execute. The refreshed reviewed heap-state section resolves
direct-write support, inactive fields, handle lifetime, tail-valued list-head
prev links and active-list ownership predicates. The adapter now implements
those contracts; earlier questions below are retained as historical requests,
not current blockers. Remaining narrowly scoped questions are callback-time
metadata visibility and metadata-allocation exhaustion policy.

Historical requests resolved by the refreshed reviewed page:

- Which Heap/Span fields, if any, may a caller write to control the allocator?
  Specify valid invariants and when writes take effect. Current views publish
  actual SDK state and do not blindly copy arbitrary control fields into C.
- Are unused cache slots, inactive reserve/orphan links and allocation-only
  fields of reserved/cached/huge spans defined? Current safe policy normalizes
  them to null/zero and constructs reserved-span metadata from its real range.
- Does a list head's prev link mean null, tail, or an unspecified inactive value?
  Canonical live list heads now point prev to their tail.
- Do heap_is_this_yours/is_in_span test storage ranges (including cache/reserve
  and interior addresses) or only current user allocations? Is post-free
  membership specified? Current heap predicates use active-list ranges only.
- What is the permitted use of a heap handle after release, and metadata
  visibility inside callbacks during an unfinished SDK operation? Matching
  global free after release works; ownership-mutating use of a released lease
  is diagnosed. All normal calls publish real native state before returning.
- Should internal metadata allocation exhaustion return allocation failure,
  call an error callback, or terminate? Current metadata OOM is fail-fast;
  mapping/allocation/reallocation failures and old-allocation preservation are
  real and tested, including acquisition failure in the SDK-private test.

Resolved module identity question: the reviewed language module contract requires
different written argument lists to produce distinct module instances even when
their effective defaults match. Original independent regression:
`stdlib/Bindings_Generator/tests/driven/sdk/compiler-repros/module-default-identity/main.jai`.
It now checks distinct implicit/explicit types and global storage, plus repeated
identical-list type/storage identity. The private native-handle ABI test correctly
selects its actual explicit SDK profile. Effective-default normalization would
violate this contract; no compiler/path/module-name exception is appropriate.

Current rpmalloc follow-up after refreshed review and explicit user policy:
config-copy/shallow payload/storage identity, missing-partner fallback and offset
range now have real implementations and tests. Raw first-class default false
is an explicit independent packaging policy authorized by the user, not a
reference claim or new public parameter. Earlier questions below on those
points remain historical context rather than current blockers.

Please narrowly review the remaining observable contracts: whether mutating
returned config changes callbacks/names after initialization and what ownership
preconditions apply; native-error assertion-location substitution; generic
allocator mode/data/CAPS/query encoding; public errno update/thread storage;
and rewrite dump-builder output/disabled-mode behavior. Canonical heap graph
marshalling remains genuine code work under the user's managed-handle
authorization, not a request for more native layouts or a reason to stop other
APIs. Plan: `docs/native/rpmalloc-heap-adapter-design.md`.

Other remaining public-only review requests after rereading refreshed pages:

- `dxc_get_version_string`: exact text components/separators, returned storage
  lifetime/freeing and behavior when version COM queries fail. IDxcVersionInfo
  ABI is available; the Jai helper's text/ownership contract is not specified.
- D3DCompile/D3DCompileFromFile string overloads: grammar for each []string
  define (name-only versus name/value separators), duplicate/empty entries,
  returned bytecode/error string ownership and inclusion of terminal NUL.
  Existing native COM/foreign bindings remain usable and are separate work.
- Objective_C's eight helpers: class naming/registration and parent/isa layout
  rules; generated stub text; supported reflected types, encoding grammar and
  error behavior; method validation and implicit self/selector conventions.
  Apple runtime ABI availability does not specify these Jai conventions.
- X11's four state helpers: clipboard allocation/free domain, global atom/cursor
  initialization policy, accepted drag type-list strings and selection
  predicate XPointer argument layout/matching rules.
- Android's seven helpers: app command pipe/synchronization/lifetime ownership
  for the public reduced App record, asset-manager acquisition and empty-dir
  versus missing-dir behavior, finish/exit order/status, and logger formatting.
  General Android target support remains a separate compiler gap.
- Enabled telemetry's fourteen helpers: matching public SDK acquisition ABI,
  DLL identities and arena/capture defaults for the reviewed tuple. Existing
  table declarations and official marketing material cannot substitute for a
  loader prototype. No proprietary bodies or another SDK ABI will be invented.

Only reviewed specifications establish Jai compatibility. This document tracks
unclear contracts and implementation limitations without treating legacy tests
or previous library behavior as evidence.

## Conditional and contextual declarations

- NSOpenGL constructors now implement real native profile/format/context
  creation and actual sample reporting. Please specify exact versionless
  default profile and MSAA/version fallback priorities if these are observable
  compatibility requirements. Current independent policy prefers 4.1 then
  3.2 core, reduces unavailable MSAA toward zero, and returns null with a
  diagnostic for unsupported profiles/versions or debug-context creation
  (which the native NSOpenGL API cannot request). The native SDK tests cover
  supported core/legacy creation, view attachment, lifetime and actual samples;
  policy equivalence is not inferred from old tests.

- Current AppKit contextual contracts are implemented in
  `Objective_C/AppKit`, with NSView/NSScreen opaque pointer-only types private
  to that facade. Current NEW window-render sources now import the reviewed
  AppKit submodule. Root exports were not expanded and no peer source was
  modified by this worker.
- Resolved by current review: AppKit `NSWindow.setTitle` has an intentionally
  unspecified `id` result that callers must ignore. The wrapper now calls the
  native void selector with its actual ABI, and its string side effect is
  tested against the real Cocoa title getter, including UTF-8 text. No native
  undefined return register is read.
- The supplied macOS x64 ipc_perm and newly reviewed x64 itimerval shapes are
  emitted, including the Android x64 itimerval variant. Generator same-OS
  association and explicit official header delegates now cover every POSIX
  source shape. Android target/runtime verification remains required.

- Resolved POSIX variant association: a sole same-OS published shape covers
  both inventoried CPUs after current review; distinct CPU shapes stay separate.
  Explicit reviewed shapes take precedence over native delegates, including
  reviewed public/native ABI discrepancies that require private adapters.
- rpmalloc: current review supplies complete private `Heap`/`Span` contextual
  record contracts. These are implementation work, not missing source shapes.
  Raw and rewrite configurations expose different callback types/statistics;
  neither can simply alias native C config/heap storage. The omitted private
  first-class-heaps default still needs clarification; complete native C SDK
  input is already pinned.
  Current prose establishes raw-only alias association; generator now guards
  those aliases and keeps rewrite Heap private. Please specify the omitted
  raw first-class-heap default, public config() normalization/ownership, error
  callback Source_Code_Location provenance for native errors, and map offset
  units/range. The pinned C backend stores offsets in a 32-bit span member and
  its OS unmap path shifts them by three; the public API uses signed 64-bit
  offsets. Native defaults are not authority for these Jai observable details.
  Public default lifecycle/allocation/statistics now execute; complete contextual
  heap data and option profiles remain genuine code work rather than shape gaps.
  Callback initialization now executes using copied config/names and an owned
  wide-offset registry; it assumes no public offset units. Please specify
  any special native-only callback context policy beyond normal C interoperability,
  and whether contextual heap/span pointers must
  identify in-band live allocator metadata or permit canonical managed handles.
  Native and reviewed public heap/span field orders differ even where sizes
  match; opaque native pointer aliases and stale fabricated field snapshots are
  not acceptable resolutions.
  Synchronous callbacks now preserve the actual calling Jai context through a
  thread-local native-call frame; fields, writes and nested restoration are
  tested. Native-only entries use a fresh default context without retaining an
  expired initializer frame.
  Please also specify rpmalloc_allocator_proc behavior for every Allocator_Mode,
  allocator_data ownership/type, CAPS and IS_THIS_YOURS return encoding, and the
  public errno variable's update/reset/thread-storage contract. Null/error
  returns are genuine in current default wrappers; errno mirroring and generic
  allocator modes are not counted as implemented by those bodies.
- GL: the broader and default GL_Procedures records are separate configurations.
  Preserve target-conditional fields inside their parent record; never flatten
  those function pointers into module exports.
- Metal/Objective_C: member method signatures omit bodies. Selector spellings
  and struct return conventions need public Apple header checks before emitting
  message forwarding calls.
- NVTT: complete Compressor/Surface/CubeSurface member APIs require the pinned
  native 2.1.0 headers, as expressly permitted by the specification. Console
  target declarations are unavailable and will not be invented.
  The header is now pinned at `fa6ebda53f1be0bb40513057d13b154771344528`.
  Its const/non-const `CubeSurface.face` overloads erase to one Jai signature
  (both native symbols are retained);
  exact reflected overload behavior needs clarification. Some separately
  published methods (for example `setRGBMThreshold`) are absent from this tag,
  despite the same version identity. Existing reviewed declarations are kept;
  their native symbol availability is not established.
- telemetry3: disabled no-ops are explicitly specified. Enabled Windows mode
  requires real SDK table calls and dynamic loading; it must not share no-op
  bodies with disabled mode.

## Verification limitations

The generated coverage ledger describes declaration generation, not successful
integration. The stable checkpoint-7 batch records 268 passing source checks and
26 failures, 53 passing native build/run checks and one retained SDL layout
failure, 102 passing privacy checks and ten blocked by D3D. Added required
DXC executable/private-helper checks expand coverage without hiding failures;
private units are not public/native Windows proof. All 1,200 recorded
symbols pass. Forty full configuration checks still fail. Refreshed strict
lint exposes sixteen incomplete target/private-root/declaration scopes; previous
all-zero lint evidence is historical. These counts are scoped worker evidence,
not full integration or completion. Missing SDK runtimes do not establish
compatibility and do not permit fake declarations.

## Concrete specification discrepancies found during implementation

- Windows: `XBOX_GUID :: GUID.` and `GUID_DEVINTERFACE_HID :: GUID.` omit their
  aggregate initializer payloads in the preceding spec revision. The current
  reviewed page now provides both complete values; that declaration gap is
  closed. `uid`'s handling of malformed GUID strings is not
  described; supported canonical strings can be implemented independently.
- Resolved POSIX generation association rather than requesting additional
  source shapes: all macOS x64/Android x64 reviewed aggregate variants are
  emitted. Android native delegates are pinned where expressly required.
  `U128` is private native integer storage for aligned two-u64 lanes.
- D3D11/D3D12/ImGui: some published bitfield aggregate lists contain both
  `__bitfield` storage and additional apparent scalar fields without explicit
  placement. These need layout review against official C headers before any
  native ABI conformance claim. D3D11's contextual MIDL protection-flags record
  also lacks a concrete shape in the page.
- MojoShader: signatures and record fields reference enum types absent from
  both its public inventory and shape lists. Fetching the pinned official C
  header can supply private contextual ABI enum definitions; adding those names
  as public Jai exports would invent an API.
- telemetry3: the table shape is published, but the `tmGetApi` entry function
  signature, DLL naming and arena/capture configuration need a reviewed public
  contract or accessible official SDK header. The vendor's public product page
  does not provide that header. Enabled mode remains unresolved; disabled
  no-ops are the only implemented no-op configuration.
  Rechecked the official [public vendor product page](https://www.radgametools.com/telemetry.htm)
  on 2026-10-15: its product/FAQ/features/history links did not establish that
  loader prototype or provide the matching native header; evaluation is offered
  through vendor contact. No contact/authentication was attempted. Filtered
  reviewer follow-up: specify the exact native SDK acquisition function ABI,
  matching library names and arena/capture defaults for the reviewed API tuple
  2022/5/23/51766. Do not infer those from another SDK version or replace enabled
  paths with disabled-mode no-ops.
- The xxHash vendor update functions reject a null pointer even for zero
  bytes. Public empty updates now leave the streaming state unchanged without
  calling the vendor. Nonempty vendor errors abort instead of being silently
  discarded by the public void signatures.
- Direct3D: the general forward-overlay compiler issue is now resolved by the
  refreshed safe producer and the standalone `forward-overlay.jai` test passes.
  Corrected private dependency imports now preserve canonical shader compiler
  interface types. Separately, `D3D11_VIDEO_PROCESSOR_OUTPUT_VIEW_DESC` and
  `D3D12_ROOT_PARAMETER` list overlays before their target anchors, and place
  discriminator fields after their payloads. The native SDK layouts put those
  discriminators first. Reordering to pass the compiler would silently change
  reflected member order and could still retain the wrong ABI; these layouts
  require SDK-correct private marshalling where practical; the reviewed public
  shapes must stay exact. Passing source type checks does not establish C ABI.
  `docs/native/d3d-source-dependencies.md` records a remaining general alias
  lookup bug with a minimal independent three-file reproducer.
- X11: `XNClientWindow`, `XNFocusWindow`, and `XNInputStyle` are inventoried as
  `.data` without the string operands. The operands are now recovered from
  pinned official libX11 1.8.12 headers and recorded with their native provenance.
- Resolved iOS availability: all three helpers are iOS-only exports. Real
  host SDK lookup is tested through their private native toolchain unit; no
  desktop helper export or weakened target absence check is introduced.
- Android: native and rewrite glue procedures are listed with matching names
  and parameter sets but lack explicit inventory configuration labels. Their
  native-vs-rewrite availability must follow `USE_GLUE_NATIVE_PORT`; lifecycle
  state ownership for the compact rewrite remains unresolved. Asset helpers
  also refer to activity state whose public global is conditional on the main
  callback option.
- Curl/ImGui string-format wrappers do not document whether their format syntax
  is Jai formatting or C formatting. Curl currently supports the native C
  format contract with real dynamic ABI forwarding; reference equivalence of
  additional formatting semantics is not claimed.
- The source-built compiler CLI currently rejects `-os ios` and `-os android`
  (accepted OS names: linux, windows, macos, wasm). This prevents direct source
  verification of the Android facades and iOS conditions. Desktop unsupported
  guards do not count as their implementation verification.
- Metal's framework-level iOS availability and macOS-only native entry points
  need target metadata beyond the unconditioned public inventory. Native SDK
  availability must be reviewed before an iOS symbol-conformance claim.
- macOS's contextual `Block` parameter is represented privately by a pointer to
  the reviewed Objective_C block basic prefix. Native block parameters have
  this pointer ABI, but the missing contextual reflected type contract remains
  unspecified.
- rpmalloc: the pinned public native C header defaults first-class heaps to
  zero, while the repository's native packaging enables them. Neither choice
  establishes the omitted private Jai `RPMALLOC_FIRST_CLASS_HEAPS` default.
  The reviewed raw config callbacks use Jai strings/implicit context and page
  names use Jai strings; these are not the native C config ABI. The published
  private heap/span member order also differs from the pinned native C source.
  Directly casting these records into that allocator would be incorrect. Public
  supported raw and rewrite runtime profiles now execute through a complete
  pinned private C SDK backend with two-CPU execution and generated probes.
  Checked alignment preserves output on failure; callback/config/statistics
  marshalling now executes. Public heap graph/field marshalling and other build
  options remain code work. No heap/config native alias shortcut was introduced.
  The pinned native SDK's `rpmalloc_thread_collect` body is empty, so forwarding
  that symbol does not establish public deferred-collection semantics. See
  `docs/native/rpmalloc-native-backend.md` for exact scope and retained failures.
- GL: `_glGetActiveAttrib` and `_glGetActiveUniform` take `$$name: string`
  where the native API writes an output name buffer. Required writable storage
  and copy-back behavior are unspecified. Context helpers now have real WGL,
  GLX and NSOpenGL paths with separate source/native evidence; that previous
  implementation blocker is resolved.
- X11: ownership of the two clipboard buffers, custom global atom identities,
  the selection predicate's opaque argument are not established by the
  signatures. The modal message box now has a real independent event/UI
  implementation; exact geometry/focus/dismissal policy remains unspecified
  and Linux execution remains required. Remaining stateful helpers need those
  contracts; implemented Xlib drawing requests retain the native asynchronous
  error handler rather than treating their unspecified integer returns as
  server status codes.
- SDL: the reviewed `SDL_RWops` shape is a 48-byte callback/type prefix, while
  the pinned official SDL 2.0.1 record is 72 bytes on the host. Its hidden union
  is absent, and the listed callback types omit C calling-convention markers.
  `SDL_UserEvent` similarly lists only type/timestamp (8 bytes) versus the
  native 32-byte record with window ID, code, and two payload pointers. The full
  SDL_Event union remains 56 bytes and passes native event transfer, but the
  standalone record layouts do not match full SDK records. The reviewed SDL
  policy replaces impossible full-size equality with exact public-prefix AND
  complete private-native checks; those and pointer/close/freesrc/event safety
  tests remain active. Earlier failing equalities remain historical evidence.
  Adding public fields or treating prefixes as complete records is forbidden.

## Resolved current independent integration blocker (historical)

The current foundation's `Basic.Buffer` alias has no corresponding exported
member in `internal/basic`; this prevents even an lz4-only current-foundation
check. An earlier inherited `#overlay (implementation_data)` diagnostic changed
after rebuilding the compiler worker's current Rust sources. No other worker's
checkout was modified. The isolated binding tests retain a previously staged
copy of the NEW independent foundation and record that boundary explicitly.
Current staging uses refreshed NEW foundations, including basic-interface and
native-path; the ordinary producer compiler builds the real formatter.

## Remaining platform context/shape contracts

- Resolved by refreshed SDL review: RWFromFile returns the actual SDK-owned
  native pointer. Custom Jai callback tables and copied incomplete records are
  unsupported. Removed the prior wrapper/context/copy policies, retaining
  native pointer/close lifetime behavior and unchanged ABI mismatch assertions.
- Android EGL's versionless helper now has an independently authored ES2,
  RGBA8/depth24, MSAA-halving implementation. Confirm default profile/ranking
  and partial failure ownership if exact choices are required. Native source
  forwarding is present; compiler target rejection prevents type/device checks.
- iOS helper availability is fixed to the reviewed iOS-only condition. Host
  tests cover the private native implementation separately; no host convenience
  export is invented. Concurrent first-use cache behavior remains unspecified.

- Resolved by refreshed GL review: `gl_create_context` creates/attaches and
  makes the native context current without returning ownership handles. The
  exact generic signature is implemented using target-native window handles;
  lifetime remains the native callers responsibility. Linux intentionally does
  not check glXMakeCurrent according to this reviewed convenience contract.
- POSIX sole same-OS distinct shapes now cover both declared CPUs, following
  latest review. Android iovec/pollfd/timeval/sched_param are now supplied by
  explicit complete pinned Bionic C header delegates with active target C ABI
  assertions; no cross-OS Jai shape is guessed. Android Jai/device checks still
  require general compiler target support.
- WGL default format/ranking policy is documented in native/wgl-context.md.
  If exact observable fallback order is required, it needs an explicit reviewed
  contract; current source checks do not replace native Windows verification.

- DXC compilation now has a real SDK route and source-checked Windows private
  implementation. Profile version text is concatenated verbatim; empty source
  or entry names use SDK defaults; requested DXIL debug information is embedded.
  Clarify these corners if exact choices beyond the reviewed controls matter.
  The version-string helper still lacks a specified output format, lifetime and
  failure policy; vendor custom-version strings are not automatically the Jai
  helper's contract. Public reflection/source and native Windows verification
  remain required despite private route/header/unit passes.
- SDL nonzero freesrc semantics now include values above the native C-int range:
  a scalar ABI adapter fixes a proven real-file close failure at 2^32. It keeps
  the actual SDK pointer and public 64-bit parameter, with native 0/1 conversion.
  Its function address differs from the SDK symbol; no public alias or record
  layout is changed. Standalone public record/callback incompatibility remains
  explicit and the original assertions remain active.

## Numeric reserve wording clarification (2026-10-16)

Reviewed rpmalloc.md says DEFAULT_SPAN_MAP_COUNT also caps the *global*
reserve count. Official pinned C e4393ff stores this cap in per-heap reserve
count; surplus mapped spans may instead enter the global reserve. Is the
reviewed observable obligation a global cap, a per-heap cap, or simply the
fallback/effective map-batch behavior? Numeric fallback/table/cache capacity
implementation continues independently; no guessed global truncation or
unmapping is introduced. Please return the specific public reserve observable
and the relevant tested configuration if a global cap is intended.

## Mutable configuration callback fields (2026-10-16)

The reviewed page specifies a copied, mutable module-owned config pointer and
selection of both built-in callbacks when either supplied callback is absent.
It does not explicitly describe the resulting public callback field values or
whether edits after initialization are supported. Please clarify two narrow
observations: (1) must config().memory_map/memory_unmap expose callable built-in
Jai callback values after default initialization, or retain the copied null
values while the private backend selects its built-ins? (2) may callers replace
these callbacks or map_fail_callback through config() after initialization and
have subsequent mapping operations use them? Current native selection is made
at initialization, while installed public callback thunks read the retained
module record dynamically. No public callback names or unsupported dynamic
rewiring are invented while the supported selection/lifetime tests continue.

### Reviewed resolution: reserve and mutable configuration

The current rpmalloc.md resolves both questions above. The reserve cap is
per-heap min(effective batch, DEFAULT_SPAN_MAP_COUNT), with separate uncapped
global reserve. The owned public config exposes callable default map/unmap
values if either input partner is absent; default error/failure callbacks remain
null and names empty. Later callback/name reads use live values; sizing writes
do not reconfigure native state. Compatible pairs, backing/code lifetime and
absence of concurrent mutation remain caller obligations. These are no longer
contract blockers. Independent native probes/public regressions and the typed
instance implementation are documented in docs/native/rpmalloc-runtime-policies.md.

The reviewed instance contract also requires simultaneous independent imports,
including differing argument lists with equal effective defaults. Old EINVAL
shared-domain rejection is a defect, not an accepted compatibility policy.
Current source uses per-nominal-owner typed native domains; repeated exact
imports retain canonical storage. Windows/Linux/Android native verification and
graph metadata OOM rollback remain separate limits, not unanswered contracts.


## Corpus-confirmed missing AppKit public surface (2026-10-16)

ACCESS.json hash-verified shader src/backend.jai and Forbear forbear.jai both
lexically import Objective_C/AppKit. Current approved contextual page covers
NSWindow/NSResponder only; the actual facade matches that limited inventory.
This is a missing reviewed AppKit surface rather than a compiler/import defect.
Please provide canonical records/superclass using fields, complete methods and
parameter names/defaults, enums/constants/availability for NSApplication,
NSOpenGLContext, NSOpenGLPixelFormat, NSView and NSScreen, including application
activation/event-loop and OpenGL view/format APIs. Related observed names include
NSApplicationActivationPolicyRegular, NSOpenGLPixelFormatAttribute/PFA/profile
constants, NSEventMaskAny and NSDefaultRunLoopMode, plus init_app_kit. Application
calls establish consumer needs, not the reference API; native SDK headers do not
establish Jai nominal layouts or convenience overloads. No extra root
Objective_C exports will be added.

Independent reduction pending/objc-appkit-public-classes.jai captures just both
missing class identities and repeat import compatibility, without guessing
record fields or allocating SDK instances. Existing GL private NSOpenGLContext
identity also needs to converge on the reviewed canonical AppKit class once
provided; a public alias to an unrelated opaque record is not a correct repair.
Allocator rollback work continues while this narrow review is pending.

## AppKit follow-up contract resolution (2026-10-16)

The extended public surface is documented in `modules/appkit.md` in both the
review tree and shared worker tree. It includes the full prefixed window-style
and backing-store enum members; event types/masks and modifier flags; application
presentation/activation declarations; Cocoa `NSDefaultRunLoopMode`; `NSView`
backing-coordinate methods and remaining declared selectors; `NSScreen` and
`NSEvent` members; `init_app_kit` effects; and the AppKit nominal OpenGL context
identity used by GL. These facts are static source-derived; no reference
compiler or AppKit runtime was executed. AppKit remains macOS-only and does not
add names to root `Objective_C`. The documented `NSView.convertPoint` source
quirk and external Cocoa constant value are explicit uncertainty boundaries.

## AppKit native ABI follow-up (implementation batch)

Delivered appkit.md now resolves native-void/public-id slots, public menus, bare NSDictionary and all CG window-level globals; no old whole-surface blocker remains. Implemented exact typed forwarding and real runtime initializer. Remaining narrow question from unchanged hash-verified Forbear: are NSResponder.super and NSWindow.responder declared using/#as, and with which exact flags? Current contextual page states field names only. Without those flags, the exact six-argument initWithContentRect(self:id,...,screen) rejects *NSWindow from objc_alloc. No alternate overload or compiler/module exception has been added. Native UI/GL lease and x64 execution are verification gates, not missing bodies.

Resolved in current objective-c.md: NSResponder uses `using #as super: NSObject`; NSWindow uses `using #as responder: NSResponder`. Implemented both exact directives with unchanged layouts and no extra overload. The independent window-to-id/screen-initializer reduction now passes, and the unchanged ACCESS-hash-verified Forbear forbear.jai -check passes with the fresh source-built bindings compiler. Earlier pending whole-surface/return/CG/inheritance questions are resolved. Remaining AppKit limits are the four reviewed SDK receiver quirks, UI/GL serialized runtime verification and x64 native execution, not absent implementations.


## Bindings: beec sgpu/Metal narrow contract request (SDK/corpus evidence)

Consumed safe producer-handoffs/current-repair-batch/corpus-beec9491-reference-dispositions.json from authorized clean handoff root. Both prior official failures remain evidence, not obsolete dispositions. Hash-verified admitted sgpu examples/utils/macos_window.jai:28 calls NSWindow.setCollectionBehavior with NSWindowCollectionBehaviorFullScreenPrimary | NSWindowCollectionBehaviorManaged and imports Objective_C/AppKit at67. Current public enum declares ONLY short FullScreenPrimary/Managed, matching objective-c.md prose; appkit.md omits collection-behavior enumeration. Official current NSWindow.h declares full prefixed names/values and does not deprecate these members. Reviewer: please specify exact NSWindowCollectionBehavior member names/using export form for ALL13 currently reviewed values, and whether short names are actually public; no convenience aliases will be guessed.

Current metal.md MTLCommandEncoder declares endEncoding +6 other base methods, but allfour derived MTLRender/Blit/Compute/ParallelRenderCommandEncoder member inventories omit any using/#as base field. Generated records consequently have no inherited methods. Official SDK declares allfour protocols <MTLCommandEncoder>; native endEncoding selector exists on protocol. Reviewer: please deliver exact public embedded-field name/type/using/#as/layout for these four records (or exact repeated methods if that is the public design), and whether MTLCommandEncoder itself embeds NSObject. This prevents a symbol-specific endEncoding copy from hiding a general inheritance omission. No native layout fields or extra public APIs will be inferred from SDK protocol inheritance alone.

Independent source/SDK reductions being captured under own bindings T7; no production changes until exact reviewed public surface is established. UI-builder bundled demo/modules excluded by ACCESS.json; only admitted demo sources +safe filtered first diagnostic used. No excluded module/body inspection. Native/GUI lease expired and will not be reused; compile-only SDK controls now. POSIX integration31 proof acknowledged, no repeat.


## Resolved beec AppKit/Metal exact public surface

Reviewer delivered exactly13 prefixed using NSWindowCollectionBehavior members, no short aliases/newerSDKconstants; implemented exact canonical enum. ONLY Render has first field using #as mtlcommandencder: MTLCommandEncoder; base and otherthree wrappers have no storedfields/NSObject. Implemented by preserving general using/#as promotion with no compiler patch. Generic spec parser now joins same-target simple field fence/member inventory, rejects conflicting fields, and leaves anonymous/alternate/other-target shapes intact. Five independent parser tests and whole-reviewed-page effect audit confirm only Metal changes. SDK protocol inheritance is broader than Jai public inheritance;21 other-wrapper methods remain deliberately absent by reviewed contract, not unresolved assigned bodies.

Actual ARM64 O0/O2/ASan+UBSan offscreen SDK Render test exercises allseven inherited operations, pointer/field identity and real command-buffer completion; flags match all13 SDK values, retained AppKit/Metal ABI checks remain active. No GUI/window/nativefault execution. Remaining original application acceptance requires coordinator-only excluded Vulkan_With_VMA/Pixel_Maker dependencies; own admitted-source replays reach those honest frontiers without app edits, fake modules or private body access. Final exact receipts/manifests are in own ready_appkit_metal_surface_checkpoint. Mac x64 source/SDK checks do not establish x64 native execution; unrelated unavailable-platform/telemetry gaps remain.


## RESOLVED GL debug-output capability/state/filter contract

Reviewed gl.md+inbox establish core4.3 thenARB only; unsupported includingKHR-only returnswithoutcallback, noabort. Sharedcapturedlogger/data/flag and exactthreefilters implemented generally; no oldreferencebody consulted. Missingpointerwithreportedcapability remainsUNSPECIFIED and no newpublicfallback wasinvented. Remainingproof is supporteddriver synchronization/errorbreak and nativeotherplatforms, not missingunsupportedbehavior. ExistingrealSDKcallbacktest now injects nonfiltered THIRD_PARTY/PERFORMANCE; unavailable actualdriverdebugsupport remainsrequiredunavailableverification, neverfakepass. RootactualMacFocusSDKsmoke requestedafterstablewrapperhash664d473f; no originalFocusRuntime/vendorbodyaccess.
