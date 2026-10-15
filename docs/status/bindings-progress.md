# Bindings worker progress

Objective_C helper batch after `5b6ac6f`: all eight missing public helper bodies
now exist, including the newly reviewed runtime-size member-stub generator.
Real x64/ARM64 Mac tests verify native encoding parsing, class/ivar layout,
instance/metaclass dispatch,32-byte return ABI, object release and failed class
cleanup. Full module source/native/privacy sweep has zero applicable failures;
formatting, strict lint, regeneration and68 Python tests pass. Seven helpers
remain conservatively partial for unsupported reflected categories and exact
Jai-specific policy review; no unsupported diagnostic is counted as completed
functionality. Objective_C has0 unresolved declarations,7 partial helpers.
Other-module unresolved count is now28; rpmalloc remains80 partial with its
existing24 verified cache profiles. No profile expansion or benchmark ran.
The framework-path fallback is documented in deviations; combined coordinator
Mac corpus result remains unavailable to this isolated worker. Next: reviewed
D3D string overloads, DXC version helper, then X11 missing helper group.

Heap handle OOM batch after `4fa38d7`: typed canonical HeapView storage is now
reserved before SDK ownership mutation. Reservation OOM returns null/ENOMEM;
actual SDK mapping failure frees the reservation. The original fault injection
aborted (signal6); the same real test now verifies unchanged native heap buckets,
orphan lists, active counts and allocation balance, then successful allocation
and cleanup. Extra allocation/zeroing/free cost on reuse is explicit. Graph and
default-thread metadata OOM still remain fail-fast; full metadata transactions
are not claimed. No new SDK source patch or public shape/type/signature change.

Both rebuilt native scopes passed all native/source/ABI/sanitizer/lint/format
checks, but each correctly failed the stale coverage-ledger hash check. Those
original reports remain intact; regeneration and actual failed-check retries
pass, together with68 Python tests. The final357-check run passes completely and records all shared/private
test-source hashes, including22 positive Mac executions and72 C sanitizer
executions across24 profiles. Fresh static/shared worker builds succeed. All owned scope is still incomplete:0 unresolved/80 partial
rpmalloc declarations and36 other-module unresolved declarations, with the
original18 configuration failures resolved. Native Windows/Linux remain
unverified. Precise option/OOM questions are in
`docs/specs/stdlib/native-bindings-questions.md`.

Thread-cache option batch after `154ff0d`: all four thread/global-cache
selections now use24 real SDK/callback domains, preserving every conditional
public Heap field. Native independent public mirror offsets/sizes pass with
thread cache absent in raw-base, raw-enabled and rewrite layouts, with both
statistics selections. Shared public regressions also exercise real four-thread
free handoff, resize/data retention, heap lifetime and independent domain state.
Universal Mac builds pass. `.work/rpmalloc-cache-matrix-final.json` passes357
checks:66 desktop source checks,22 positive Mac executions,72 C sanitizer
executions across24 profiles,72 C mirror target/layout checks, strict lint,
formatting, regeneration and68 Python tests. Ten expected failure checks retain
actual observed exits. Both private heap selections pass192 configuration
declaration/public-name checks each (all16 public cache/statistics/raw options
on six desktop targets). Earlier original18 failures remain resolved. Fresh worker native static/shared
builder succeeds for all24 domains; its raw-enabled host scope passes349
checks. The ordinary full enabled verifier passes132 source,40 host build/run
and198 privacy checks. This is worker evidence, not final package integration.

Declaration ledger stays0 unresolved/80 partial rpmalloc plus36 other-module
unresolved APIs. Adaptive cache/assertion/validation/page-advice/numeric/huge
and unmap options remain incomplete. Metadata association OOM remains fail-fast;
diagnostic snapshot allocation is transactional. More native domains increase
package/build size, and view copying/serialization remain explicit costs.
Native Windows/Linux and final coordinator integration remain unverified.

Global-cache option batch after `7eafe15`: ENABLE_GLOBAL_CACHE=false now
selects a genuinely separately compiled SDK/callback/ownership domain for each
raw/rewrite/statistics shape. All twelve domains build for both Mac CPUs.
Focused verification passes238 checks:60 desktop source checks,20 positive
Mac executions,36 native C sanitizer executions, strict lint, formatting,
regeneration and67 Python tests, with expected assertion/type failures retained.
Real allocation/resize/free/heap ownership and callback failure rollback pass;
SDK counters show no retained global cache, and default-domain ownership/data
survive independent cache-disabled lifecycle changes. No new SDK source patch.

The ledger remains0 unresolved/80 partial rpmalloc declarations, plus36
other-module unresolved APIs. Thread-cache/adaptive/assertion/page-advice and
numeric options remain incomplete. Heap/span metadata OOM remains fail-fast;
diagnostic snapshot OOM is transactional. Native Windows/Linux and coordinator
package verification remain unverified. Twelve domains increase native package
size; full-view copy and serialization costs remain explicit.

Allocator/dump milestone after `9106bfb`: all reviewed generic modes and both
rewrite builder forms are implemented. Raw-base generic handles have exact
canonical records even with named heaps disabled, bringing the real native
SDK/callback domain inventory to six. Existing signed/unsigned signatures,
aliases and canonical bootstrap Allocator types remain intact. Immutable native
counter captures permit builder formatting to allocate on this very allocator
outside native leases; real capture-allocation failures roll back and set failed.
Raw output uses an explicit private PRETTY_PRINT true policy and tested off
selection, without a public parameter/default claim.

The 23 original unresolved rpmalloc declarations are now 0 unresolved and 80
partial +31 declared: other native cache/assertion/page-advice/numeric options
are still incomplete, so this is not full profile completion. All original18
configuration failures now pass declaration/public-name checks in both private
heap selections (36 checks each). Default complete verifier: 108 source passes,
32 host build/run passes, 198 privacy passes. Enabled-raw complete verifier:
120 source passes, 36 host build/run passes, 198 privacy passes. All passed.
Final default heap/protocol scope:191 passed checks, including eighteen positive
Mac program executions, real C sanitizer/failure/ABI checks and separate expected
compile/assertion rejections with observed exits retained. Worker native static/
shared host builder succeeds; its host archives pass169 checks. All owned
production formatting and scoped strict lint/regeneration/66 Python tests pass.

No contract/compiler issue blocks these supported allocator/dump profiles. CAPS
exact original spelling remains a narrow review question: the page specifies
stable name storage, implemented with independent `rpmalloc` identity. Heap/span
association metadata OOM remains explicitly fail-fast, despite transactional
diagnostic captures. Serialization/copy/native-domain costs remain documented.
Native Windows/Linux and final package/CI integration remain unverified here.
Other36 unresolved APIs still need precise contracts/SDK evidence. The xxHash
ARM64 repair was reassigned exclusively to native-build-repair; no duplicate
patch, peer write or shared/original checkout cache access occurred. Next bindings
work is genuine remaining native option support and transactional heap metadata.

Raw heap milestone after `78d73e8`: all eleven reviewed raw heap procedures,
nine canonical aliases and the exact conditional raw Heap/Span records now
have a real independent native domain for each statistics setting. The private
false build default remains explicit; configure_rpmalloc.py selects the
otherwise undeclared compile-time option without adding public parameters.
Distinct raw/rewrite public layouts are marshalled field by field; raw atomic
members use actual C atomic storage/publication. Both mirrors retain complete
SDK separation. Checked calloc uses real SDK heap calls, with overflow rollback.

Fresh source-built compiler/lint tools came from the authorized compiler
producer, using own target output and offline locked dependencies; no peer
checkout edits. Raw/default heap scope passes 134 checks, including sixteen
actual Mac executions, 48 desktop source checks, all 66 raw field offset/width
probes in both statistics settings, 2,027 real raw native counters, and eight
host C sanitizer programs. Every owned scoped module/program is strictly linted
with proper program roots, and formatting/regeneration/66 Python tests pass.
The ordinary enabled-raw verifier records 96 source passes/six inventory
failures, 144 privacy passes and 30 host build/run passes. All 18 configuration
name failures remain, with declaration checks passing. Ledger: 3 unresolved,
77 partial and 31 declared rpmalloc entries; other36 remain unresolved.

Two test/backend assumptions were corrected with retained independent evidence:
SDK introspection now occupies a separate archive object from libc/thread
helpers, and raw C error injection selects the actual private SDK instead of
assuming the default domain. The native callback/context/lifetime assertions
remain active. A general lint module-context reproducer and precise questions
are in native-bindings-questions.md; standalone staged programs use --context,
with no exclusions or weakened compiler diagnostics. Metadata OOM remains
fail-fast, and full-graph copying/serialization and extra SDK domains retain
their documented costs. Native Windows/Linux remains unverified.

The latest mailbox now resolves generic allocator mode/result/old_size behavior
and statistics builder appending/no-op contracts. Those three public procedures
and the 18 related configuration failures are next, followed by the newly
reported Windows ARM64 official xxHash intrinsic failure. Exact CAPS name bytes
are still requested because the reviewed page states only "stable name string".

Stable canonical heap implementation: `7fedc8e`; configurable native fix and
durable verification runner: `bc597af`. Follow-up tests now exercise
multi-element full/partial list prev/next links, current-heap replacement with
outstanding allocations, repeated selection of the same current heap, and
configurable heaps across four span sizes and six allocation sizes. They found
a genuine official SDK pool-map alignment defect (4 KiB spans/16 KiB pages).
An independent pristine-C reproducer fails at the SDK mmap assertion; an owned
hash-checked build patch fixes whole-page pool allocation without changing
public layouts/options or disabling assertions. Both statistics profiles pass
that C regression under ASan/UBSan. Post-patch checkpoint-22 passes all 66 heap
scope checks, including eight actual Mac program executions and 24 desktop
source checks; independent SDK/native storage suites pass both CPUs. The actual
production dependency builder succeeds, then checkpoint-23 passes all 58 heap
scope checks against its host archives. All owned production formatting passes;
strict scoped lint/regeneration and 65 Python tests pass. The full rpmalloc
verifier records 72 source passes, six public-inventory failures, 132 privacy
passes and 22 host build/run passes. All 18 configuration public-name failures
remain, with declaration checks passing. Counts stay 23 unresolved/57 partial
rpmalloc and 36 other unresolved declarations. Full native Windows/Linux,
remaining option profiles, metadata exhaustion and remaining public contracts
are required work; no full completion or integration claim is made.
Patch-file context whitespace was subsequently removed with a zero-context
diff; strict pinned input hashes still guard application. Actual preparation
produces byte-identical C source (SHA-256
`35ff487986188f2a605990f3f765c665e352b4e178e9292f3b0a56d01356fff0`).

Canonical heap milestone after `2a18c3c`: all eleven rewrite heap procedures now
have actual private SDK forwarding and complete canonical public Heap/Span
storage, with both supported statistics profiles. Public pointers never reach
SDK heap calls. Real counters/defined graph links are copied through C atomic
accessors; native unmap events retire associations and active-operation leases
protect callback lifetimes/reclamation. Current-heap allocation and thread
finalization use the same boundary. Free during a callback uses SDK deferred-free
primitives/counters; a real callback joins four freeing threads without deadlock.
Further workers allocate on the explicit heap and return allocations after
thread teardown. Mapping failure preserves old allocation bytes; release keeps
allocations valid for matching family free. Native-header u32 page-count
overflow is rejected before mapping. Public records/layouts/identity remain exact.
The latest mailbox review settles allocator-owned field edits/lifetimes and
active-list semantics. New public regressions exposed and corrected head-prev
tail marshalling and cache/reserve exclusion from heap ownership queries.

New evidence: three heap programs (two public, one private ABI/counter) pass all
18 desktop source checks and execute on both Mac CPUs. The private program
checks all 66 public layout fields in both statistics variants and all 2,027
native heap counters against independently compiled SDK atomic getters. Both
statistics C adapter profiles pass host ASan/UBSan churn/retirement/acquisition-
failure tests; canonical C headers compile for all six targets in both profiles.
Scoped strict lint, formatting/regeneration and 65 Python regressions pass.
Existing native SDK/storage ABI suites remain active and pass both CPUs.
Full inventory/configuration checks still fail at genuine remaining APIs.

Ledger: rpmalloc 23 unresolved + 57 partial + 31 declarations; other modules
retain 36 unresolved. Twenty raw first-class heap entries remain conditional
source-profile work; generic allocator and rewrite dump semantics need review.
No full compatibility/integration completion is claimed. Unsupported direct
field writeback and unspecified inactive fields now follow explicit reviewed
contracts. Metadata OOM fail-fast, complete-graph serialization
cost and native SDK callback reentrancy limits are reported in deviations and
precise questions. Native Windows/Linux execution remains outstanding.

Stable implementation commit: `5c6aa17` (raw facade, isolated statistics
profiles and refreshed callback contracts). Follow-up public profile tests now
also verify same-profile raw import rejection preserves an active rewrite
owner, custom-map failure in the no-statistics domain rolls back without
unmap/retry calls, and subsequent real initialization succeeds while the other
statistics domain remains live. Both Mac CPUs and all six source targets pass;
scoped strict lint and 63 Python tests pass. Standard scoped verifier fixture
selection now includes all three new programs: checkpoint-18 has 54 source
passes/six inventory failures, 126 privacy passes and 16 host build/run passes
(two private ABI/SDK plus six public programs). The separate boundary report
records 12 actual two-CPU public executions. All 18 configuration public-name
failures remain; their declaration checks pass. Other36 unresolved declarations
are precisely requested through the questions document after fresh spec review.
The missing canonical heap implementation is explicitly required next code work.

Current public batch after `fc6c681`: real raw lifecycle/allocation/statistics,
calloc/aligned calloc/memalign/checked POSIX alignment, statistics FILE output,
collection and canonical raw aliases now share the rewrite's private boundary.
`config()` returns stable copied mutable storage with reviewed shallow payloads.
Refreshed contract defects fixed: missing partner selects both built-ins,
custom failure does not call OS retry, offsets are bounded to 65535 and rejected
offset/address mappings are released. Earlier contrary test expectations were
incorrect oracles, explicitly corrected with replacement safety assertions.
An independent private raw default false policy is authorized by the latest
user steering; no public parameter or reference-default claim was added.

Statistics-enabled/disabled SDK profiles now compile with separate exported
symbols and matching callback/check helpers. Six public programs pass 36 desktop
source checks and execute on both Mac CPUs (12 actual programs, 24 build/run
checks). Cases include real callbacks/failures, config ownership, alignment,
zeroing, output/statistics canaries, mixed domains and four-thread bidirectional
allocation handoff across worker thread teardown. The production dependency
builder and its actual host archives also run callback, raw and mixed-profile
programs. SDK/storage native ABI assertions pass both CPUs, separately from
public evidence. All-owned production formatting/regeneration and supported
scoped strict lint pass; 63 Python regressions pass. Broader target lint and
Windows/Linux native execution remain incomplete.

Ledger: rpmalloc 34 unresolved + 46 partial + 31 declared; other modules retain
36 unresolved. Six inventory views resolve through existing exact canonical
aliases, rather than extra procedure bodies. All 18 configuration declaration
checks now pass, but all 18 public-name checks still fail at unfinished generic
allocator/dump APIs. No configuration failure was removed or called complete.
Public heap/span field/identity/lifetime marshalling is not implemented by this
batch; no public pointers cross native ABI. Its independent typed-association
plan addresses atomic fields, graph identity, uninitialized reserved headers,
stale cache links, ownership predicates and callback-safe locking:
`docs/native/rpmalloc-heap-adapter-design.md`. This is actual remaining code work,
not another missing native shape request. Precise remaining behavior questions
are in `docs/specs/stdlib/native-bindings-questions.md`; other36 contracts remain
required. Full integration/corpus/release verification remains coordinator-owned.

Earlier checkpoint descriptions below are historical and superseded where the
refreshed contract and current implementation differ.

Native storage/source-export follow-up after `d8c9eb4`: all seven native
heap/span/cache/counter records and 66 field offsets/widths now pass actual C
ABI programs on both Mac CPUs, plus six desktop Jai source checks. Complete C
source scanning retains SDK exports omitted from its header; the real public
set_main_thread wrapper now executes in both public CPU programs. SDK native
test invokes all 35 actual entry points. Separate heap-disabled/enabled record
and export profiles are preserved. Heap has equal public/native size with
different offsets; public Span is 96 bytes versus native 88. An incorrect new
Span equality oracle and the initial probe duplicate-symbol failure are
preserved and separately classified. No public fields were changed and no
public heap crosses C ABI. Reviewed mode-specific procedure views are now
guarded by USE_RAW, preventing raw-only names from becoming rewrite requirements.
Current ledger: 64 unresolved + 16 partial rpmalloc entries, other 36 unresolved.
60 generator/staging tests pass; source/native/tool evidence remains separate.
Checkpoint-13 scoped result: 36 source passed, six missing-public-name failures,
96 privacy passed and ten native build/run checks passed, including two explicitly
private SDK/ABI programs. All 18 rpmalloc configuration failures remain active
(raw default heap flag and nondefault statistics implementation); no failure
baseline was reduced. All owned formatter/regeneration checks and supported
scoped strict lint pass. Current native SDK/public allocation programs execute
the source-only main-thread setter on both CPUs. Full integration and other
modules' remaining failures are not retested or declared complete by this scope.

Callback/configuration follow-up after `a476d25`: public initialize_config now
marshals to a private SDK-correct config, owns copied native naming bytes and
retains full signed offset bits in a synchronized private mapping registry.
No public C-incompatible record is cast. A genuine first callback crash was
diagnosed and fixed by establishing a Jai context in every C thunk. A further
field-preservation regression led to a reusable TLS native-call frame: callbacks
inherit the actual active caller context, nested frames restore it, and native-only
entries get a fresh default. Four-thread identity and caller writes are tested.
NEW callback tests cover retry/decline, failed init, stack/name overwrite,
config canaries, wide/signed offsets, real error callback and four concurrent
native threads. A separate CONFIGURABLE test verifies native size settings.
Both programs execute on both Mac CPUs; all six desktop source checks, scoped
strict lint, formatting and regeneration pass. Production dependency builder
and actual host archive also execute callbacks. Complete rewrite AND raw
contextual records now generate from reviewed prose, preserving distinct cache
order and conditions; 56 generator/staging tests pass. Raw default remains
blocked by the omitted first-class-heap flag; generated raw records are not
raw runtime evidence. Ledger: 65 unresolved + 15 partial rpmalloc entries;
other 36 unresolved declarations remain. Exact error-location policy,
profile isolation, raw/heaps/nondefault options remain open. Full integration,
Linux/Windows native and release verification are not claimed.
Latest scoped checkpoint-12: 30 source passed/six missing-public-name failures,
96 privacy passed and eight native build/run checks passed (including private
SDK). Caller-context helper compiles for all six C desktop targets. Actual
production formatter rebuilt on current NEW foundations; all owned roots,
internals/tests and both regeneration checks pass. Supported scoped strict lint
and C warnings/formatting pass. The earlier exit-139 and exit-134 regressions
remain indexed separately; neither assertion was removed.

Previous 2026-10-15 public implementation after `dd4dfcb`: default rewrite now has 14
real lifecycle/allocation/statistics entries, classified **partial** because
nondefault profiles and raw mode remain unfinished. The new public-only test
uses public initialization and teardown, preserved ordinary/aligned realloc
bytes, matching frees, actual nonzero counters and canaries. Both Mac CPUs run
successfully; six desktop source configurations, actual formatter, scoped
strict lint and regeneration pass. Generator tests: 53 passed. Complete reviewed
rewrite Heap/Span/context records stay private; no native heap pointer is cast
to them. Raw-only aliases are now mode-guarded. Current rpmalloc ledger: 66
unresolved + 14 partial; other unresolved scope remains 36. This is real public
progress, not completion or a reduction of the remaining configuration gate.
New test is discovered by standard native verification; independent review
remains pending. Nonmatching profiles intentionally remain missing code rather
than receiving default native semantics. Next: safe callback/config lifetime,
profile isolation/options, and proper canonical heap adapters. New detailed
scope is `docs/native/rpmalloc-public-adapter.md`.

Previous 2026-10-15 verification checkpoint: `1ef2ea6` contains the complete private SDK
backend and checked boundary. Stronger follow-up tests require nonzero actual
thread allocation/free totals and valid per-class current/peak counters; both
Mac CPUs and the production-builder archive pass. Latest full owned matrix:
322 source checks passed / 16 failed / 70 unsupported; privacy 120 passed /
72 unsupported; 58 native build/run checks passed / one unsupported; symbols
1200 passed. Counts include explicit private/compiler units. Configuration
failures remain 36; public unresolved declarations remain 116, including all
80 rpmalloc public entries. Complete owned formatting and regeneration pass;
scoped supported strict lint passes, Windows target-context and active alias
compiler repro lint failures remain documented. Generator tests: 52 passed.
All original failing evidence remains separately classified. Extensions unchanged.

Next required work: implement both public allocator variants/callback/heap/config
semantics and options; resolve enabled telemetry's matching SDK acquisition ABI;
remaining X11 ownership/state helpers, Objective-C helper contracts, D3D shader
convenience overloads and DXC version helper; compiler mobile-target and strict
Unicode/alias blockers; real Linux/Windows SDK/runtime and other aggregate ABI
verification. Filtered questions are in the role's questions document. The fresh
official telemetry lookup did not establish a loader prototype; no SDK version
substitution, contact/authentication or enabled no-op body was introduced.

Private rpmalloc SDK batch: generated all 34 real native C entry points and
complete config/statistics records from the pinned official header; native heap
types stay private and never alias public Jai records. Six desktop C/header and
private Jai source checks are separate from actual x64/ARM64 host execution.
The private unit exercises every SDK function, allocation/data/alignment/heap
lifecycle/statistics I/O and 40 field probes. An invalid-alignment failure led
to a real private checked adapter with unchanged-output/error tests, not a
disabled assertion. Production native dependency build, scoped formatter and
strict lint pass. Public rpmalloc's 80 unresolved declarations and all its
configuration failures remain open. See `docs/native/rpmalloc-native-backend.md`.

Stable preceding checkpoints: `d12f302` FSEvents native marshalling;
`3afe321` SDL public-prefix/private-native oracle; `ea57dd9` canonical D3D imports.
Broader checkpoint-8 verification before this private SDK batch: 316 source
checks passed, 16 failed, 70 unsupported; 56 native build/run checks passed,
one mobile public facade unsupported; privacy 120 passed/72 unsupported;
1200 symbols resolved. Configuration failures: 36, down from 40 by real D3D
debug repairs. Native counts include explicitly labeled private/compiler units,
not that many native public programs. 116 public declarations remain unresolved.

Direct3D batch: safe producer refresh resolves general forward overlays; the
independent storage-sharing regression builds/runs. Corrected acyclic canonical
interface imports unblock D3D11/12, D3D compiler, DXC and Aftermath Windows source
checks, including full public DXC compile/reflection. D3D11/12 debug configurations
now pass: configuration failures reduced from 40 to 36 by actual code/dependency
repairs. No public records/types changed, no compiler patches/peer edits.
The 116 unresolved declarations remain required. Windows native runtime is not
claimed. A separate general imported/local alias-resolution failure has an
active minimal repro; strict whole Windows render source still hits producer
Unicode's fixed-array literal bug. See `docs/native/d3d-source-dependencies.md`.

SDL policy batch: exact public 48/8-byte prefix contracts are now independently
asserted, alongside complete private native RWops/User_Event sizes and all
top-level field offsets. No public layout or callback ABI changed. Native event
push/poll now checks window ID, code, two distinct data pointers and surrounding
canaries. Pointer identity, file/BMP/close/freesrc/WM canary tests remain active;
current scoped host verification has zero failures. Historical full-size
comparison failures remain in prior evidence and are classified as invalid
oracles, distinct from real safety bugs. Linux/Windows native execution remains
required. Evidence: `.work/sdl-policy-native-current.json`.

Latest FSEvents batch: exact public context layout retained; all fields marshal
into private SDK order at `FSEventStreamCreate`. Real host lifetime/canary/null
context and filesystem callback delivery pass. Producer FileWatcher is untouched.
Both supported macOS source configurations and private-export checks pass;
the scoped matrix has zero failures (`.work/fsevents-native-current.json`).
Two-CPU native execution and production tool results are recorded separately in
`.work/fsevents-both-cpus-tools.json`. Generator regression suite now has 45 tests.
This is an ABI repair, not a reduction of the 116 unresolved declaration or 40
configuration-failure inventories. Next: apply reviewed SDL prefix/native-record
verification policy, then remaining supported desktop wrappers and D3D repro.

Active implementation; full integration/corpus/release verification remains
coordinator-owned. POSIX/WGL checkpoint: `79af73e`; safe SDL/iOS/X11 checkpoint:
`fddae00`.

2026-10-14 current batch:

- Fixed distinct-shape association with per-CPU inventory availability. A sole
  shape within an OS is shared by that OS's declared CPUs; distinct CPU shapes
  remain separate. No borrowing across OS boundaries. 35 generator regressions
  pass. POSIX unresolved declarations reduced from 67 to 8 by emitting actual
  reviewed records/enums, including all missing macOS x64 declarations.
- Implemented `GL.wgl_create_context` through private native WGL setup. It
  bootstraps driver functions on the target display, selects/reuses a window
  pixel format, queries actual multisampling, creates/shares real contexts and
  restores the previously current context. Windows x64/ARM64 source checks
  pass; native Windows execution remains required, not claimed.
- Refreshed only safe producer `../compiler`; ordinary compiler/linter build
  passes. The actual `jaifmt/main.jai` now builds against current foundations
  without a compiler patch. Added foundations' new `internal/native-path` to
  staging. Strict lint of GL/POSIX/new WGL internals/all native tests passes.
- New host public C SDK probe passes seven POSIX sizes and seven offsets, plus
  a real `getitimer` call. POSIX declaration/public-name checks pass on both
  Linux CPUs and both macOS CPUs. Linux cross-target checks are source evidence.
- Both macOS CPUs now execute source-built C/Jai ABI and ordinary POSIX tests:
  all 12 checks pass, with x64 running through OS translation on this ARM64
  host. Evidence: `.work/posix-sdk-both-cpus.json`.
- Safe SDL RWops adapters preserve the public 48-byte record and Jai callback
  ABI. Complete private C storage, custom UNKNOWN tagging, range checks and a
  synchronized live-address registry prevent native overreads and copied-file
  callback overreads. Real BMP/custom-stream/canary/file/close/copy tests pass;
  original RWops/UserEvent ABI mismatch assertions remain active failures.
- Four X11 window/UI helpers have real bodies and Linux source checks. Real
  X-server drawing/pixel tests are supplied but not executed on this host.
- Android EGL has a real ES2/config/MSAA/context/surface implementation with
  checked native calls and retained failure handles. Neither Android type
  checking nor device execution is claimed while the compiler rejects its OS.
- All iOS helpers now obey iOS-only public visibility. Eighteen desktop absence
  checks and the private native SDK/pipe/cache unit pass; two required iOS CPU
  source checks still fail on unsupported compiler targets.

Evidence: `.work/posix-wgl-current.json` retains the initial WGL array-literal
failure; that syntax was corrected and both Windows CPU checks pass afterward.
Expanded current runtime/matrix report: `.work/posix-wgl-native-current.json`.
That report has six failures, all public-name checks for the unresolved generic
GL helper; every recorded native build/run passes, including real GL shaders,
NSOpenGL, POSIX and procedure-reflection regressions with the ordinary compiler.
All 40 production formatting/regeneration/regression/strict-lint checks pass;
full commands/results: `.work/production-owned-tool-checks.json`.
Native C probe: `tests/native-bindings/posix_abi_probe.c`; executable regression:
`tests/native-bindings/posix-abi.jai`. Native SDL mismatch tests stay active.

Next: finish broad format/lint and current matrix, then remaining owned wrappers
and configuration gaps. Eight Android shape associations, general GL dispatcher,
rpmalloc, enabled telemetry, Objective-C class helpers, D3D/DXC convenience
wrappers and X11 helpers remain required. See deviations/questions for exact
limitations; declaration counts are not a claim of native completeness.

Current source ledger: 28,397 declared, 1,262 forwarded, 547 generated bodies,
45 manual bodies, 120 unresolved, one duplicate. Manual includes unverified
Android code; no native completion is inferred. Configurations still have 58
required failures. The intermediate broad matrix recorded 1,200 symbols passed,
45 native checks passed and two native failures (invalid host iOS expectation
and retained SDL layout mismatch). It preceded the iOS fix and straddled an
X11 fixture update; two X11 source failures are an incoherent intermediate
snapshot, not current source results. Preserve `.work/current-owned-full.json`;
rerun a stable fresh snapshot before reporting final broad counts.
Current reports: `.work/checkpoint-2-production-tools.json` (40 passed),
`.work/sdl-rwops-native-final.json`, `.work/ios-sdk-paths-current.json`,
`.work/adapter-privacy-current.json`, `.work/windows-render-current.json`.
The actual Windows renderer remains blocked by the independent fixed-array
literal reproducer in NEW producer Unicode, after integrating the File owner.

Subsequent reviewed progress:

- Eight Android POSIX records now come from complete pinned official Bionic
  headers, with all field sizes/offsets and record sizes/alignments asserted
  for both C targets. Explicit reviewed target shapes always take precedence;
  no new names or cross-OS guessed layouts. POSIX has zero unresolved source
  declarations; Android Jai/device verification remains unavailable/required.
- Fixed generic nested C++ member ownership tracking. `TextFilter.TextRange.split`
  replaces the invalid flattened verifier expectation, preserving the API.
  Added a real Jai-to-SDK native constructor/split test with three sizes/five
  offsets checked first. Added the missing C++ runtime dependency, shared by
  ImGui/NVTT/meshoptimizer with platform-correct default native runtimes.
- SDK-focused matrix: 50 source checks, 10 native checks, 549 symbols passed;
  zero failures. Both macOS CPU ABI/runtime probes still pass. All 41 current
  production tool checks and 41 Python regressions pass.

Evidence: `.work/sdk-delegates-and-cpp-current.json`,
`.work/posix-sdk-delegates-both-cpus.json`, `.work/checkpoint-3-production-tools.json`,
`.work/android-posix-header-regeneration.json`.
Stable checkpoint-2 full report is `.work/stable-checkpoint-2-full.json`:
240 source checks passed/36 failed, 47 native passed/one retained SDL ABI failure,
96 privacy passed/two blocked by D3D, 1,200 symbols passed. It predates the six
corrected ImGui namespace checks, which now pass in the scoped report.

Next stable checkpoint: Linux ARM64 `stat`, `lstat`, and `fstat` now use a
private 128-byte kernel record and real target syscall numbers from pinned
official Linux UAPI headers, then copy successful results into the unchanged
144-byte public record. Null buffers and failures retain native error behavior;
failed operations leave the public output unchanged. General LP64 C record
translation is shared with the Android delegate instead of duplicated.

Evidence: `.work/checkpoint-4-tool-checks.json` has six successful production
format/strict-lint/regeneration/regression commands, including 43 Python tests.
`.work/posix-stat-current-foundations.json` passes four Unix source targets and
host native regressions. `.work/posix-stat-sdk-both-cpus.json` passes all 16
macOS C-oracle/build/runtime checks on both CPUs. Linux ARM64 headers/layouts
are cross-compiled and every field asserted; Linux ARM64 execution is still
required and is not inferred from macOS execution. The current NEW foundations
dependency `internal/basic-context` is staged; the actual formatter was rebuilt
successfully against it without a compiler patch.

Ledger: 28,397 declared, 1,262 forwarded, 544 generated bodies, 48 manual
bodies, 120 unresolved and one duplicate. This reclassifies three existing
unsafe stat forwarders as real adapters; it does not manufacture a coverage
increase. The 58 configuration failures and retained SDL public ABI mismatch
remain required work. Next: remaining reviewed wrappers and refreshed compiler
configuration verification.

Refreshed reviewed GL behavior now supports the exact generic current-context
wrapper. It creates real WGL/GLX/NSOpenGL contexts, attaches the macOS view and
makes the context current, retaining the reviewed native caller lifetime model.
Six desktop source targets, all eighteen GL alternative configurations, and
eight host native build/run checks pass (`.work/gl-dispatch-current.json`,
`.work/gl-dispatch-configurations.json`). The complete configuration matrix now
has **40 failures**, reduced from 58 by actual GL implementation. D3D forward
overlay, rpmalloc, enabled telemetry and mobile target failures remain required.

Refreshed SDL review explicitly requires actual SDK-owned RWops pointer
identity and does not support Jai-created callback tables. Removed the prior
custom owner/registry/context adapter, restored real native foreign symbols,
and replaced unsupported custom-table tests with symbol identity, genuine file
operations, BMP success/failure, exact native close counts and both freesrc
modes. `.work/sdl-native-pointer-current.json`: twelve source, seven native,
twenty-four privacy and 299 symbol checks pass. The one retained native failure
is the unchanged public RWops/UserEvent ABI mismatch test.

Current producer compiler and linter were rebuilt from safe NEW sources.
Production formatter rebuilt unchanged and complete owned formatting/regeneration
and 43 Python tests pass. Refreshed jailint now rejects incomplete roots rather
than reporting a misleading pass. The broad retry records 25 successful commands
and 16 incomplete lint scopes (native target guards, private-root import context,
and real declaration gaps). Fresh-staged host GL/SDL/POSIX and changed native
tests pass strict lint. Full target-aware lint is still required; no suppression
or alternate target constant was introduced. See native/lint-target-context.md.

Source ledger: 28,399 declared, 1,262 forwarded, 544 generated bodies, 47 manual,
119 unresolved, one duplicate. Broad source/native matrix is running against a
stable staged snapshot; scoped results above are not full integration evidence.

Stable full checkpoint-5 completed: 262 source passed/24 failed, 51 native
build/run passed/one retained SDL layout failure/one unsupported public iOS
host case, 96 privacy passed/two blocked by D3D, 1,200 symbols passed. All
required failures remain active. Evidence: `.work/stable-checkpoint-5-full.json`.

Subsequent work: X11 modal message box now has native UI/event handling for
all seven styles, keyboard/button/WM-close/destruction paths and other-window
event preservation. Both Linux CPUs source-check the real-server automated
test; Linux native execution is still required. Private helpers remain hidden.
Pinned complete official X.Org protocol header assertions pass both C targets.
Formatting/regeneration/43 Python tests pass; strict lint still reports the
real host target guard instead of claiming Linux bodies visited.

`DXC_Reflect` now has a real checked COM forwarding body and an actual native
DXC compile/reflection test. Its Jai source is blocked before body validation
by the general D3D12 forward-overlay issue; no source/native DXC pass is claimed.
Complete pinned Microsoft SDK headers/source confirm native buffer handling;
SDK buffer/COM scalar layout assertions pass both macOS C++ CPU compilations.
These host adapter probes are not Windows ABI/runtime execution. Ledger now
records 49 manual authored bodies and 117 unresolved; unverified authored code
is explicitly not completed functionality. Next: remaining DXC compile helper
and supported reviewed convenience work; compiler/target/native gaps stay open.

Next batch: `DXC_Compile` has complete real SDK routing, checked HRESULTs,
include handling, native diagnostic bytes, owned result copying and COM cleanup.
Its private compile route and strict UTF-16 conversion each source-check both
Windows CPUs. The pure argument serialization unit builds/runs on the host and
passes production strict lint. The public DXC program still fails at unchanged
D3D12 forward overlays; native Windows execution and target-aware lint are not
claimed. Declaration source is shared rather than replacing SDK interfaces with
test sketches. Native HLSL/SPIR-V and invalid-source executable tests stay active.
Evidence: `.work/dxc-final-source-and-units.json`,
`.work/dxc-compile-production-tools.json`, native/dxc-compilation.md.

A new actual SDL native regression found 64-bit freesrc truncation to C int:
`0x1_0000_0000` failed to close a genuine SDK file. A thin scalar adapter now
normalizes every public nonzero flag to native 1, keeping the same SDK-owned
pointer. The native before report has two failures; after repair only the
original record layout failure remains. Actual BMP/file/close-lifetime tests
pass. Factory symbol identity is unchanged; loader adapter address difference
is documented. No custom callback/owner registry returned.

Formatting, regeneration, 44 Python regressions and strict host SDL/serializer
lint pass (`.work/checkpoint-7-production-tools.json`). Latest SDK C++ buffer
and interface-header layout assertions pass both host CPU compilations. Strict
Windows lint still reports actual target guards in the fully staged dependency
tree. Current root ledger: 28,398 declared, 1,262 forwarded, 544 generated,
51 manual authored, 116 unresolved, one duplicate. Counts do not imply native
completion. Full matrix/configuration reruns are running against a stable
current snapshot; preceding full result remains explicitly historical.

Current stable reruns completed (`.work/checkpoint-7-full.json`,
`.work/checkpoint-7-configurations.json`): 268 source passed/26 failed,
53 native build/run passed/one retained SDL layout failure, 102 privacy
passed/ten blocked by D3D, and 1,200 symbols passed. Configurations retain
40 failures. Totals include explicitly labeled private SDK/argv units, not
extra public API/native Windows claims. Two added source failures are the
required public DXC executable on both Windows CPUs, blocked at D3D12; eight
added privacy failures expose that existing dependency blocker. Six new X11
private helper privacy checks pass. No required checks were removed to improve
totals.

Latest implementation commit: `854405b`, after `4137f3c`, `40e37e9` and
`1afd394`. Remaining declarations: rpmalloc 80, enabled telemetry 14,
Objective_C 8, Android 7, X11 4, d3d_compiler 2, DXC version string 1.
Additional declared/native ABI discrepancies, target-aware lint and unavailable
native executions remain required. Questions/deviations distinguish missing
contracts from code/compiler work; the scope is not reported complete.
