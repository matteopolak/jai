# Portable stdlib progress

## Current combined candidate ac9b8723
Deep_Copy timer operations fixed: real SDK calls no longer occur inside optional
assertions. New unconditional 20ms callback regression failed exit5 with the
staged DEFAULT Basic assertions disabled, passed enabled; now both pass
interpreter/native Mac O0/O2 with existing graph/scalar/debug execution and whole
owned strict lint. Format/--check pass. Windows same-source correction remains
native-unverified. No test correction. See portable-deep-copy-timing.md.

Socket actual whole-binding strict lint now PASSES compiler89560db9 together with
real C SDK and Jai resolver interpreter/native ARM64/x64 O0/O2/source checks:
target/socket-whole-lint-refresh.log. Earlier type-query gap is historical.
New four-way inbox split accepted; ASN1/Socket, JKS crypto/readers and APK signing
are now excluded from new portable edits. An uncommitted APK model fixture is
preserved only as pending/apk-signing-model-behavior-candidate.jai; no production
APK signing record edits were made. Exact refreshed inventory/handoff follows.

Post-integration snapshot:4076 owned reviewed rows,3574 complete-source,
455 conservatively partial,47 missing (87.68%source rows; not conformance totals).
Metaprogram_Plugins now complete-source/verified; JKS source moved missing->partial
with NO positive SDK credit. Default uses shared actual loader d4fe5b1 and real
helper facade97eddd4; generalcompiler89560db9 required. Exact scopes/exclusions and
remaining signatures updated, full Focus/corpus still coordinator-owned.

Default now delegates custom/Check factory setup to actual public M_Plugins helper,
removing private CLI-only generator/duplicate context. Live objects/options/order/
replay and real child outputs retained. Full strict lint supplies valid empty-init
program context for the generic module's reviewed deferred obligation, checks every
original owned body, normalizes generated contexts. No stub/filter/assert removal.
Generic aggregate init status used; old early-stop-private behavior unestablished.

Metaprogram_Plugins FULL reviewed parser/initializer workflow now ACTIVE with
source-built general compiler89560db9. Computed imports/parameters, real factory
objects/options/workspace, aggregate status/no-init options, stable factory identity,
empty/name consistency and ordinary module/privacy errors pass interpreter/O0/O2
drivers. Parser native O0/O2 and full context-aware owned strict lint pass. Valid
declared-placeholder/indirect mechanism; no pump/yield/undeclared continuation.
Default actual builds/Check/plugins/lint also pass on new compiler. Exact source/
commands/limits in portable-metaprogram-plugins.md; full Focus/corpus coordinator gate.

JKS generator real SDK workflow source now implemented: reviewed RSA/DSA table,
defaultECcurve/defaultalias/password, actual keytool command/status/output checks
and canonical owned record. Negative SDK/size cases pass interpreter/native O0/O2
and strict lint. Host Java absent; POSITIVE GENERATION UNVERIFIED, source classified
partial/no success credit. Actual-SDK positive fixture ready, no fake keytool or
success file. Existing-target/preflight/partial-output/DN/validity policies and
future atomic publication/native-positive gates documented in portable-jks-generation.md.

Current owned snapshot:4076 reviewed rows,3571 complete-source,456 conservative
partial,49 missing; source-only counts, no conformance inflation. Whole names/
conditions in implementation-remaining.json; missing-module subset33 is smaller.
Only missing Mac Socket row is CMSG_SIZE; six others Android. Focused remaining
contract queue in portable-remaining-contract-requests.md covers CMSG/minimal flow/
instrumentation/MPEG macro/table-walk and crypto details without obsolete broad
questions. Valid deferred plugin source pending general committed capability.

Native lookup audit found/fixed real absolute Mac crash-helper LC_ID_DYLIB in the
producer tree. Now @rpath identity (Linux basename SONAME source configured).
Moved-distribution test compiles and runs actual native OFF/ON crash behavior;
otool verifies selected relocated package rpath, with no original producer helper
dependency. Existing overrides untouched; direct per-helper override absent/TODO.
Libclang copy/default belongs excluded tools owner, no edits. Final production
packaging still coordinator gate. Evidence native-package-red/final.log;
portable-native-package-lookup.md has exact installed-tree/dependency handoff.

Reviewed deferred-body initializer staged in pending/metaprogram-plugins-deferred-init.jai:
declared #placeholder, scoped source fulfillment, typed indirect invocation and
ordinary generated imports. No message pump/yield/undeclared callee. Current
compiler fails placeholder never defined, also seen on new compiler owner's
reference-confirmed independent deferred-body probe. --deferred-candidate records
actual failing positive; no completed-init credit. Compiler owner local fix now
passes its probe, but checkpoint/integration still pending. Rejected direct-call
draft stays separate and is not required semantics.

Four reviewed Android formatter aliases now preserve canonical FormatInt and
nonbaked named parameters/defaults via exact #bake_arguments. All256 values/four
widths, type metadata, unsigned64, padding/minimum/grouping pass interpreter/native
O0/O2 and strict lint. No replacement formatter or extra convenience export.
Direct key negative tests now inspect only false status, not unspecified failed
record fields; real SDK-error cleanup/DSA assertions retained and rerun pass.

Default parent-output phase FIXED using reviewed set_build_options_dc do_output,
preserving parent static output type/name/path and existing dynamic settings.
Parent debugger configuration also uses DC. Both normal/interpreter drivers build
actual native child artifacts, with deletion/recreation proof. Target O0/O2 uses
reviewed -very_debug/-od; native path/callback suites retained. Full default/Check/
options/plugins/replay/errors/parent-state assertions and strict lint pass
target/default-dynamic-options-final.log. No compiler change or CLI subprocess
bypass. Earlier parent-phase dependency note is superseded by this proper API fix.

Direct signing-key workflow now creates real EC/P256 or fixed RSA2048 DER keys
and self-signed certificates. Real SDK cross-parsing, public-key match/signature,
subjects/private permissions/repeated distinct outputs and real SDK failure cleanup
pass interpreter/native O0/O2 plus full scoped strict lint. Canonical key model and
exact signature retained; key_size ignored by reviewed policy. Installed native
crypto CLI required; independent365-day/DER/private-directory policies documented
in portable-direct-signing-key.md. Windows backend explicitly unsupported, no JKS
credit (host Java runtime absent), no existing credentials accessed.

CRITICAL17:45 test-oracle correction: filtered coordinator confirms official Jai
also rejects dynamic-build-source-continuation; source-call timing probe mutates
root options too late and is invalid. Proposed dynamic forward-call suspension
semantics WITHDRAWN, not a compiler requirement. Draft loader marked REJECTED and
kept outside production; actual dynamic loader still missing pending reviewed
valid evaluation boundary. Public positive fixture now avoids root mutation and
has main entry. Parser remains real/verified. No raw reference sources/logs read.

Foundations handoff: current Basic S128 +/- and U128 - are reviewed but missing.
Independent pending/basic-wide-arithmetic.jai fails S128 Add against NEW foundation
composition. General custom base/isa operator control executes exactly once with
correct value in interpreter/native O0/O2 and strict lint, separating missing
library overloads from unsupported compiler claims. Initial unreviewed base-result
type assertion was corrected separately; valid value/call assertions preserved.
No duplicate Apollo operator exports or foundation peer edits. Details
portable-wide-arithmetic-handoff.md.

Metaprogram_Plugins refreshed17:24 contract consumed: canonical record and real
public parser now pass interpreter/native O0/O2 and strict lint. Dynamic loading
IS required. Positive independently authored dynamic.jai + Dynamic_Probe factory
and real initializer candidate are durable; --dynamic-candidate correctly FAILS
unknown initialize_imported_plugins before running the source-adding prefix.
General minimal dynamic-build-source-continuation.jai also fails unknown callee.
Exact compiler suspension/resumption handoff in metaprogram-plugins-dependency-request.md.
No active fake init export, CLI-only restriction or passing-stub credit. Prefix
handling when starting_index>0/plugins occur is a precise remaining review edge.

Default_Allocator optimized-target public heap workflow now implemented with exact
reviewed standard records. Real ownership/resize/free-all/create/destroy/init/finalize
behavior passes Mac x64 interpreter/native O0/O2, 4threads x512cycles, disabled
module assertions,9 invalid-input runs, strict lint and owned formatting. No
cache/stats fiction: immediate release means real zero cached bytes; reviewed
standard global stats are dummy. Per-heap intrusive ownership uses one CAS lock,
with linear ownership lookup: documented performance tradeoff, no stack-address
registry. Exact upper rejection span byte size remains a numeric review question
(independent64KiB margin documented); native other OS pending. Evidence
target/default-allocator-final.log; details portable-default-allocator.md.

Mac Socket five real records activated from refreshed reviewed shapes: addrinfo,
hostent/netent/protoent/servent. Active database closure now matches official C SDK
all field offsets/canonical names/types and real host/protocol/service operations
in interpreter/native ARM64/x64 O0/O2; fixture strict lint and all owned formatting
pass. Resolver native/interpreter and stable regeneration also pass. WHOLE binding
strict lint still fails general type_of(Struct.array_field[0]) compiler semantics;
original declaration/assertions preserved, no substitute or suppression. Evidence
socket-databases-red/final.log and socket-resolver-active.log. This is real active
ABI support with a retained tool/compiler gate, not full Socket conformance.

Recovery tooling now accepts only own checkout target builds or the explicit
launch-assigned CARGO_TARGET_DIR (T7); no searches of other build trees. Shared
selector used by root/mail/channel/crash runners. Fresh mail loopback10 scenarios,
channel4 interpreter/native pairings x2048 packets and native crash backtrace
OFF/ON tests pass (target/mail-after-scramble.log, channels-recovery.log,
crash-recovery.log). No full combined corpus claim. Prior root117 cases/27 runtime
faults/16 compile-rejections ran before the Runtime lock change; retained evidence
is not presented as a post-change full rerun.

Filtered corpus update names Metaprogram_Plugins as Focus's first missing module.
Reviewed public page still lacks parse ownership/grouping/index details and the
loader evaluation boundary for arbitrary runtime-created names. Exact questions
and general added-source timing probe are in metaprogram-plugins-dependency-request.md.
Probe shows added #run runs after active caller returns; not claimed a compiler
bug without reviewed reentrancy guarantee. No CLI-only dispatch restriction,
pointer serialization or placeholder loader added. Module remains missing.

Default Check integration committed d22aa67; fresh recovery run
target/default-metaprogram-recovery.log passes ordinary builds/binding flags,
plugins/options/replay/failures and full owned strict lint. Canonical shared
signing models committed6f20c37 for generator-names. No fake signing functions.

Mail scramble now implements real temporary XOR obfuscation with all reviewed
alphabet characters and cyclic secret handling. Missing export verified first;
all64 key/full-alphabet bijection/round-trip cases, empty input,9 invalid-input
executions and strict lint pass interpreter/native O0/O2. All10 SMTP loopback
cases rerun unchanged. Numeric index ordering lacks explicit reviewed vector;
independent listed-order choice/question documented in portable-mail-questions.md.
No legacy expectation corrected or genuine assertion removed. No TLS/device/
combined-baseline success inferred from these focused host checks.

Canonical signing models requested16:34 are ready: three exact reviewed public
types, canonical names, enum defaults/order, promoted JKS fields and real union
storage. Interpreter/native O0/O2, Linux/Windows source checks, strict lint and
format/--check pass (target/android-signing-model-final.log). No fake signing
functions or real credential reads; model handoff portable-signing-model-handoff.md.
Shared staged File closure now includes NEW platform-io Windows text dependency;
initial source-check guard/missing-import failures fixed through real dependency
composition, not weakened guards. Generator-names exact transferred API names
snapshotted in portable-scope-transfers.json; no further edits to that batch.

Default_Metaprogram normal workflow now passes real Check-enabled builds after
adopting reviewed CHECK_BINDINGS module parameter/persistent factory and exact
NEW tools dependency closure. Both binding flags/default help/version, no_check,
custom plugins/replay/options/failure tests and FULL owned strict lint pass.
Test harness correction preserves every build/assertion: callable fixtures invoked
by normal added #run input; standalone linter no longer executes an invalid
zero-argument build. Empty/no_check-only input still exits1. No CLI bypass or
module-specific compiler change. Evidence target/default-metaprogram-check-integrated.log.
X64/debugger/current-workspace command-line compiler dependencies remain separately
recorded; no native other-OS or combined-baseline claim.

Inventory update after explicit16:14 transfer: executable_formats excluded in full
(507 declaration/condition rows in this inventory), with zero completion credit.
Current own denominator4129 rows:3559 complete-source,442 conservatively partial,
128 missing;86.2% source rows. Complete names/conditions, remaining exact signatures,
head/timestamp, committed/draft counts and effort/dependency estimates are in
implementation-remaining.json. Runtime discard now committed ca8570d; binding
patch is validated zero-context unified diff (git apply --unidiff-zero) against
own staged unchanged NEW producer copy. No peer edits. Latest SDK/default review
just arrived and will replace corresponding stale contract questions.

Runtime15:24 request implemented: private canonical Android pending-byte queue
and discard_pending_output hook, shared real CAS lock and reviewed Android-only
flush facade. Actual host stdout/stderr tests prove pending bytes are discarded
without emission while normal line/forced/capacity flush and desktop output work.
Interpreter/native O0/O2, full scoped strict lint and format/--check pass. Exact
NEW binding patch pending/android-logger-discard.patch prepared, no peer write;
binding adoption/Android compiler/device remain pending. No public discard export
invented. Fine Android sink/force policy unestablished and honestly documented in
portable-runtime-output-discard.md; no native Android success claimed.

Test oracle correction: original target-command-line probe used get_toplevel
getter whose scope is not reviewed. The corrected selected-workspace
pending/workspace-target-options-command-line.jai instead reads
get_build_options().compile_time_command_line and fails its genuine assertion,
confirming selected-workspace readback defect under the actual guaranteed
contract. Original failure evidence remains; no compiler patch made here.

Fresh assigned-scope inventory published at docs/status/implementation-remaining.json:
4636 reviewed declaration/overload/condition/nested-procedure rows across62 owned
module pages; source classification3559 complete,448 partial,629 missing (76.77%
complete source rows, NOT conformance/runtime percentage). Includes exact names,
committed/draft split, head/timestamp, verification gates and disjoint transfer
estimates. Most absent rows are501 executable_formats headers/constants/parsers
plus88 Android/toolchain rows; earlier95 only covered four largely-unimplemented
module groups and was never an exhaustive denominator. Partial counts are
conservative module/source audit states, not448 fabricated missing bodies. Native
foreign ABI declarations count as implementation, with runtime verification
separate; missing bodies/shape/dependencies never count complete. Reserved roles,
Basic except owned time, and Windows peer backends excluded. Runtime private
discard is a passing host-tested DRAFT in this inventory; source handoff follows.

Default build ownership replay fixed: shutdown used by-value array_free, leaving
the public plugin descriptor pointing at freed allocation. New public build-twice
fixture reproduced stale count/data; cleanup now uses Basic.array_reset. Two real
target/plugin lifecycles run in one module, descriptor cleared after each. Focused
workflow/replay passes, format/--check passes; strict lint still explicitly fails
only missing Check.get_plugin. Evidence target/default-build-twice-red.log and
default-metaprogram-workflow.log. No caller/address tracking workaround.

The combined production library now includes shared Basic print context and reviewed integer/Vector2 arithmetic, all508 executable-format declaration rows, and dependent generator template/signature handling. Basic focused39/39 and original CodeView/template interpreter/native O0 checks pass in this worktree. Declaration coverage is not functionality completion: missing modules and platform/runtime gaps below remain. The prior complete workspace53ecb3d3 was852 passed/2failed/1ignored; catalogue081ecbff had13interpreter/12native failed executions including the180s interpreted Json timeout. Current complete measurement is tracked separately in [mac-current-baseline.json](mac-current-baseline.json); no green aggregate is inferred.

## Combined candidate ad575d16

The latest combined candidate adds Default_Metaprogram, Example_Plugin and
Project_Generator: 131 physical facades plus canonical Preload mapped to the
single prelude, 132/135 reviewed module pages available. Minimal_Metaprogram,
Metaprogram_Plugins and linux_build remain missing, as does the supplementary
pl_mpeg table. Availability is not completion: zero exhaustive module
certifications. Default Check integration, Project compile-time executable-path
query, profiler hooks and generator helper inventories retain explicit gaps.

Stable native ARM64 workspace replay at ad575d16 records 840 passing tests, two failures, one inherited ignore; the exact machine report retains
the failed WASI tour and 186 target-ledger differences. The current 414-case
catalogue is still running. Counts below refer to older snapshots.

## Native Mac candidate measurement, 2026-10-15

Candidate `integration/thread-fixtures` at `90fea8ab84fa881b96a327d2bb117541e83429b4`
includes approved Extensions migration plus the assertion lifecycle repair,
ARM64 xxHash, production rpmalloc profiles, data/resources, forward enums and
filtered storage reexports. Unsupported live `::` aliases were not merged.
The following supersedes refresh23's Extensions hold and missing Mac ABI claims:
original complete Mac C ABI passes; production allocator default 169/169 and
selected raw 187/187 pass, with default private configuration restored.

One complete stable Mac workspace run: 822 passed, seven failed, one inherited
ignored. Current 408-case catalogue: interpreter 327 passed/76 failed/five precise
negative passes; native ARM64 O0 320 passed/76 failed/seven compile-time-only/five
negative passes. Exact commands and all failure names/classifications are in
[the baseline report](mac-integration-baseline.json). Missing native Debug helper
is a prerequisite failure; missing Default_Metaprogram is functionality, not a
test skip. Reviewed-contract migrations and unused-code target ledger differences
remain required. No Windows/Linux native or full public corpus success is claimed.
Inventory remains 129/135 facades, six missing plus one supplementary table, zero
exhaustive module certifications. Public corpus and Focus remain coordinator-owned.

## Integration refresh23

Consumed producer OIDs are current in integration-refresh.json. Compiler6080ff0a
general enum fix and portableb174fa22 are merged; data/resourceb1c6b1a5 is consumed
through only its five scoped producer commits. Actual production data runner
passes host/WASI/SDK wire consumers and strict target lint/checks. Windows native
resource/discovery/+Icon effects are now registered in ordinary x64/ARM64 CI,
prepared but unexecuted locally. Inventory129/135 present, six missing modules
plus one supporting constant table; zero exhaustive whole-module certifications.

Proper mutable Socket reexports and anonymous filtered import registration fix
the actual storage/visibility defect without changing immutable declarations.
All52 module regressions and7 enum core/backend tests pass. Production resolver
passes interpreter/native both Mac CPUs O0/O2/strict lint, original SDK storage
identity and real numeric address resolution. Full ABI retains missing Mac
hostent shape failure. Default-profile production allocator sweep passes71 checks;
raw/options/other native OS remain gaps. Earlier full workspace810/10/one ignored
is superseded only by focused fixes until the next complete run.

Extensions6b0f2229 is available but separate pending coordinator resolution of the
standing preserve-Extensions instruction versus mailbox scope. Existing failures
remain enabled. Full quality/catalogue/current-head partial-edit/native/opaque
corpus verification remains next. No push/dispatch/publication performed.

## Integration refresh18: durable verified checkpoint

Reviewable combined source/test head1f2a3e02e36dfb0be6e19275b24dad14435aef94.
Private assertion transport29ec8f9, merge corrections and production VBAP scope
5dc7b14 retained. Approved CIe223538, SDL30b2dc3c, audio498046b, bindingsfc6c681,
toolingaf8b5f4 and portableeab3383 are merged. Exact consumed source/provenance in
integration-refresh.json; newer ready heads remain queued, not counted consumed.

Actual production results:54publiccontracts interpreter/nativeO0/O2 PASS;
audio27fixtures allthreehostmodes/sixdesktopbodychecks/strictformatlint/privacy
PASS with real silent2/6/8SDKstreams; tooling39fixtures/C/C++consumers PASS;
window188invocations PASS after actual source-built GL/clipboard probes.
Focused compiler/native migrations PASS: diagnostics25, IDElayout4, optimizer2,
selector3/805runtimepairs, browser assertion1, namespace fix1, callback/deadlock1,
native stored-Cprocedure1 and caller-backtrace1. Optimizer address-escape growth
fix and native NSThread selector forwarding are proper production fixes.
Workspace Rustfmt and warnings-denied clippy PASS after this batch.

Broad immutable prior run755aggregatePASS27FAIL/one inheritedignored, sevenfailed
targets. Quality1107format/checkPASS but56/190strictlintgatesFAIL,source_stable=true.
Four producer gates foundations/portable/platform/numerics FAIL; corrective
numerics-native25/25PASS. Pool value-return lifetime registry is a genuine
foundations/portable blocker with active-owner reproducer; no assertions weakened.
Full binding source matrix18failures retained; actual scopedrpmalloc native
programs pass but public heaps/raw/options incomplete. All-dependencySDKretry
againfails officialX.org connectionreset; pinned hashes unchanged.

Current partial-edit run1086ownfiles is still running; no corpus/vendor sources
selected and no success claim. Compiler's proper target/context lint checkpoint
4de36d6 is now ready; integration will consume it and classify real positive,
negative, platform and loaded-fragment contexts without skip baselines. Newer
stable producer heads and local reviewedCIcache change are queued. Native
ARM64WindowsMesa build remains coordinator-owned/active; no overlapping push.
Release HOLD; no publishing/push/dispatch by this worker. Remaining module
inventory135modulepages:124facadespresent/11missing plus one supplement,
zero whole-module certification. Full opaque public corpus/Focus remain external.


## Integration refresh17: production fixes under review

Committed combined producer head: 7aec510. The integration assertion transport
fix is verified and ready for a scoped checkpoint: four private protocol/body
cases and four CLI scenarios pass; existing 51 module, two native-check and four
runtime-configuration tests pass. Whole-workspace clippy with warnings denied
passes. All 54 reviewed public fixtures pass interpreter/native O0/native O2
(including declared precise negative cases, not 54 native runtime effects).
Actual SDL verification: 30 target, 24 privacy, 299 symbol checks and nine
native/interpreter phases pass against the production library and source-built
SDK probes. No source overlays were used.

The prior broad run retains 742 aggregate passes/32 failures/one inherited
ignored result. Jaifmt/check passed for 1052 owned files; strict lint failed
58/187 gates. Those are not green integration results. New scoped formatting
passes; full-fragment-context audio lint remains under investigation. Windows
x64/ARM64 compiler builds now pass in filtered coordinator CI e223538; downstream
native platform/window checks and SDL3 newline reproducibility remain red.
Full opaque public corpus and Focus execution remain coordinator responsibilities.
No publishing, push, dispatch or release action was performed. Next: commit
reviewed general fixes, merge approved native repair checkpoints, run all new
producer suites and resolve remaining compiler/ABI/lint failures.


## Replacement integration: combined refresh-nine checkpoint

Reviewable implementation head: `9cd757a` (no push/dispatch/publication by this
worker). Merged manifest snapshots: compiler `2f36a1e`, foundations `cc089d7`,
portable stdlib `846781b`, window/render `9b5877d`, platform I/O `c3e2ff2`, retaining
previous approved bindings/numerics/LSP/SDL3 and safe CI candidate `767130b`.
Latest coordinator Basic/GL/SDL contracts are preserved in `4fe1aa4`.

Own combined compiler/LSP/jailint and unchanged real jaifmt source builds pass.
Core run: 155 compiler units, 50 module regressions, 2 production runtime option
regressions, 25 LSP units, 15 auto-import cases and 11 jailint units pass.
General interpreter memcpy/memset fault-safety and memcmp error semantics were
fixed after original protected-memory children reproduced crashes/fabricated
results; red evidence is retained. The current auto-import signature suite passes,
so the producer's alias-doc failure is not reproduced on this combined snapshot.

Full workspace, native/cross platform-I/O, strict lint regression and production
library suites are running. Foundation helper implementations conflict with newly
settled contracts; exact active-owner request is in integration-requests.md. Native
Windows/macOS x64 CI, opaque vendor corpus and coordinator Focus remain external
gates, with no full-platform success claim. Publication remains held.

## Replacement integration current checkpoint

Seventh-refresh combined source checkpoint 294f42f is stable and available for
coordinator review while the next approved heads are prepared. Actual combined
foundation host/WASI and all seven target gates pass. Exact shortest-float audit
passes 2300 intervals in each native/WASI O0/O2 mode. Rebuilt native window test
dependencies plus the expanded production runner pass 155/155 invocations,
including actual host GL rendering/depth/stencil/BC4/readback. Five platform
contracts and arguments pass host interpreter/O0/O2 and all requested target
checks; public Windows Process and all fixtures cross-link x64 O0/O2. Native
Windows System/Thread/Process/WGL execution still requires CI. Release held;
worker has not pushed or dispatched any workflow. Compiler/portable/foundation/
window newer approved heads are now queued; full final-tree evidence is pending.

Sixth-refresh source checkpoint d9aa140: seven producer merges plus safe editor
CI fix, latest Windows contracts and general private-interface/startup fixes.
Workspace 631/68 pass/fail (59 suites), foundations 27 host/21 WASI plus strict
rejections pass; macOS x64 timeval remains. Portable 101 ordinary cases pass, with
target verification failure retained. Four platform contracts and arguments pass
host interpreter/O0/O2; private Process source checks require no staging. Real
GL SDK checks pass except unavailable debug callback capability. Window 145 pass/
four failures, numerics 126/143. Quality 663 format/check pass; 38/155 gates fail.
Seventh approved snapshots are available and are being integrated. All previous
checkpoint paragraphs below are historical, not current-tree certification.

Fifth refresh source checkpoint 33f0c42: approved c8d1f5d portable, a11c0c8 foundations and eb5d83d
platform-io are merged, together with reviewed CI candidate 159ca65. Latest
general integration fix 2fff11c supplies the real private WASI file ABI; the
POSIX guard and Extensions are intact. All ten fuzz regression targets pass;
unchanged File contracts pass host interpreter/native O0/O2 and Wasm interpreter/
real WASI O0/O2. Portable production 96/96 plus faults/SMTP/channels/startup passes
without the removed implicit sibling compiler overlay. The overlay discovery is
fully disclosed in integration-deviations.md. Foundations 26 host/21 WASI cases
pass O0/O2; macOS x64 timeval and unused-interface validation still fail gates.
All 45 public contracts pass interpreter/native. Verbose scoped File lint and
format/check, workspace clippy warnings denied and Rust formatting pass.

Coordinator-filtered real Windows x64/arm64 File and signed-wheel native checks
pass; overall CI fails other runtime/platform/module checks. No full Windows
rendering or Focus claim. Full LSP sweep finishes 558 files/14,835 edits/2,600,590
assertions with one startup recovery failure. Twelve affected sources pass 317
edits/33,577 assertions; three Socket sources pass 81 edits/5,698 assertions.
Workspace 619 passed/68 failed/one inherited ignored; original stdlib 479 cases:
interpreter 270/209 and native 263/208 plus eight compile-time-only. Quality scope: 607 files
format/check passes, 34/152 gates fail (61 incomplete compilations, zero ordinary
findings). Actual wasm32 formatter passes 24 golden cases, broader engine fails
unsupported Thread. Windows editor/font source support now includes the real File
import, with both CPUs -no_dce green; final affected checks run against this head.
Exact results are in tools/cleanroom-integration.md. Inventory is 102/135 facades, 33 missing plus one
supporting table; no module is certified exhaustively complete.

The paragraphs below retain previous checkpoint evidence, superseded where the
current fifth-refresh report states a new result.

All eight initial producers plus approved refreshed compiler 890329b, portable
8a0d40c, foundations 44cca8b, bindings a565ab0, numerics 4acc846 and window 7fc1d6a
are merged. Stable source fixes include fault-safe probes, strict module parameters,
typed array preservation, binary32 intrinsics, reflected alignment/callback markers,
scratch context initialization and canonical alias completion. No peer writes,
subagents, reference binaries, corpus vendor reads, push or publication occurred.

Current production evidence: 45 reviewed contract cases pass interpreter/native;
11 language cases pass; portable 92/92 plus faults/rejections/SMTP/channels/parent/
startup pass. Foundations 24 host/19 WASI cases pass O0/O2, six unused-code targets
pass and macOS x64 fails POSIX.timeval. Numerics 107/123. Fourteen macOS window
cases pass interpreter/O0/O2, including real windows/events/clipboard/fonts and
actual GL upload/readback/shaders. Windows File-dependent checks still fail.
SDL WM-info and AppKit native tests pass; RWops/UserEvent mismatch asserts fail.

Full workspace: 612 passed/73 failed/one inherited ignored, 55 suites and 14 failed
targets. Original stdlib sweep: 479 cases, interpreter 269/210 pass/fail; native
262/209 plus eight compile-time-only. These failures remain. Source-stable quality
scope 587 files: formatter/check pass, 33/148 checks fail; combined lint one finding
and 56 incomplete compilations/396 programs. Rust formatting and native/browser
clippy warnings denied pass. Full bindings/compiler/lexer/SDL3 regeneration passes.

Broad prior partial edits: 537 files/14,257 edits/2,563,157 assertions, one startup
recovery failure; focused retry retains it. Latest refreshed 558-file sweep is
running. Native Windows/macOS x64/Linux/device and full opaque public corpus/Focus
remain coordinator gates. See cleanroom-integration.md, integration-requests.md,
integration-deviations.md and legacy-contract-audit.md for exact commands/reasons.
Platform-io now owns Windows File completion; no duplicated implementation begun.

Test-only OID correction: removed obsolete android-oid-count expected assertion
after refreshed whole-record equality. Positive android-oid now verifies all12
slots and count bytes for -1/13/s64 extrema without count-based indexing. Public
spec establishes the oracle; no production guard restored or assertion disabled.
Focused strict lint/format pass; broad rerun follows. Original expected-fault
failure preserved target/android-sdk-asn1-active-full.log; portable-asn1.md details.

macOS addrinfo review consumed: generated canonical shape/facade candidate retained
in pending/socket-macos-addrinfo.patch. Native SDK C layout+numeric resolver passes
ARM64/x64. Jai full fixture and strict lint fail known general forward-enum
ADDRCONFIG dependency; independent reduction pending/socket-ai-forward-enum.jai
fails LATER. Candidate activation also fails existing cmsg-layout; preserved
target/android-sdk-asn1-socket-full.log. Active source restored; no enum reordering,
assertion removal or missing-API credit. Isolated generation/gate keeps failures
visible and active public API unchanged pending compiler fix. Details:
portable-socket-resolver.md. Active full regression rerun pending.

SDK/startup milestone: real exact directory precedence/warnings and platform-tools
executable discovery, durable allocator-owned cache, explicit per-call start-server
and failure retention. Main/cache:10 interpreter/native runs; verbosity:3; actual
default-assert true/false startup:10 with verification separately enabled. Linux
both-CPU source checks and strict lint pass: target/adb-sdk-final.log. Newly composed
foundation is read-only input/staged only. Conventional-existing-home branch and
native Windows/real SDK/device remain unverified, documented in portable-adb.md.
Missing152 ->151; no declaration-only credit or native Android generation claim.

ADB review correction milestone: temporary version/device views+array, exact
version lines, malformed-device diagnostics, double-quote-only shell wrapping,
compression conflicts, first PID+warning/-1 failure, empty commands and launch0
fixed. Five interpreter/native modes, verbosity/Linux checks/strict lint pass
(target/adb-reviewed-policies-final.log). Harness copy-mode defect found/fixed:
earlier malformed-output coverage was launch failure, now actual parser runs.
Test corrections are separate; docs/portable-adb.md preserves exact evidence.
SDK discovery/cache/server startup remains open, no new inventory row credited.

Refreshed ASN.1 review consumed: full-record OID equality, trailing-period text,
immutable one-element known array and supported nonnegative/single-tag domain
corrected. Actual ASN1_Value + both read overloads and u32LE-prefixed borrowed
block now implemented. Five programs pass interpreter/native ARM64+x64 O0/O2;
four pure programs source-check Linux/Windows both CPUs; strict lint passes.
517 INTEGER/183 OID vectors retained with corrected reviewed-domain expectations.
Test corrections are explicit in portable-asn1.md, separate from production fixes.
Missing156 ->152. ADB refreshed discovery/start-server/quoting/storage/PID policies
are still pending correction; older ADB pass counts do not prove those contracts.

Manifest flags milestone: canonical reviewed s32 enum_flags plus actual16-name
pipe parser, duplicates ORed, invalid components diagnosed without partial result.
All16 single/256 pair cases and7 malformed cases pass interpreter/native both
CPUs O0/O2, Linux/Windows both-CPU source checks and strict lint. Independent
fine-policy questions are explicit in portable-android-values.md. No native
Android/manifest generation or test-oracle correction claim. Missing158 ->156.

Java host milestone: exact JAVA_ENV_NAME/find_java_bin_path_from_environment
implemented, including copied environment value, argv-safe native launcher probe,
real status/failure cleanup and Windows Unicode environment source backend.
Thirty interpreter/native ARM64+x64 O0/O2 configurations plus Linux both-CPU
checks and strict changed-code lint pass: target/android-java-final.log.
No real JVM/SDK/device or native Windows verification claim. Test corrections
(absolute fixture path due CLI cwd, interpreter argument separator) are separate
from production code; see docs/portable-java-discovery.md. Missing rows160 ->158.

Latest app-lifecycle milestone: stop_app/is_app_running/android_is_app_installed
implemented via actual Process/ADB commands; missing row inventory163 ->160.
All five interpreter/native ARM64+x64 O0/O2 modes, verbosity, Linux both-CPU
checking and changed strict lint pass (target/adb-apps-final.log). Memory tracking
returns to zero. PID syntax is now decimal-only and validates every process ID.
No test-oracle corrections, no device/Windows execution claim. Exact supported
failure policies and remaining fine-review questions: docs/portable-adb.md.


Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior Jai implementations used. Extensions and corpus preserved.

Current implementation checkpoints: ASN1 fff40be, Registry1f1e568, ADB4fc510a, System049154a; time e81f1a5, SHA1579458, ISA c45ee67, critical Pool/Thread d6db68f. Opaque-pointer handoff:338a4a8. Pool/Unix Thread
critical corrections are committed: field-only Pool guard, no registry,
allocator/options preserved by reset/release, genuine returned leak report fixed.
Every owned essential Thread SDK operation now executes outside optional asserts;
error logging and native ownership retention are explicit. All ten configurations/
fixtures pass interpreter, host ARM64 and translated x64 native O0/O2 (50 runs),
including the unchanged NEW foundations report and audio reproducer. Both default
assertion settings pass focused strict lint and Linux x64/ARM64 source checks.
Evidence: target/lifecycle-all-green.log; original failures retained separately.
The draft invalid locked-mutex oracle and staging corrections are documented
separately from production fixes. Native Linux/Windows/Android execution, forced
join failures and group transactional fault recovery are not claimed. Windows
Thread is untouched. Digest sources preserved through the critical checkpoint are committed separately
as1579458; all three provisional Performance_Report files stay excluded.
Broad regression subsequently passes112 cases (including pending digest fixture),
27 expected faults and16 compile negatives plus IPC/SMTP/Linux+Windows source
checks. Original Basic.exit staging dependency error is retained at
target/lifecycle-full.log; private libc abort now implements the documented
conservative fatal group policy without requiring a foundation export.

Machine ISA continuation: all eight remaining reviewed public macros now emit
real instructions through NEW compiler mechanisms; native O0/O2 and source-built
x64 interpreter pass, both optional RNG capability errors pass, focused strict
target-aware lint and macOS/Linux/Windows x64 body checks pass. Actual SDK CPUID
lacks both RNG features, so capable-hardware execution remains a CI gate. Generic
fence/prefetch original probes now emit real opcodes versus official C intrinsics.
386 owned files pass formatting/check, including preserved pending digests; whole
strict lint remains a separate failed gate. No source compiler edits or fake ISA
results. Full task remains unfinished; missing public surface inventory now names246
rows after the two real digest APIs. Next: opaque-pointer compiler handoff and
remaining portable APIs after the critical/ISA/digest/time checkpoints.

Post-f044252 work: get_machine_options_x86 now implements the reviewed generic
#modify API as a checked in-place projection of actual Compiler.Build_Options
byte storage. Interpreter/native O0/O2 verify storage identity, live feature edits
and untouched trailing bytes; focused strict x64 lint passes. No synthetic
instruction wrappers added. Windows shared-channel backend has
actual native-call source/body checks and Unix
regression evidence; no native Windows pass claimed. Latest rebuilt compiler
still rejects the original general field-array element-type, forward-enum and
workspace-hook reproducers. Continue Windows Socket and remaining public APIs.

Previously verified checkpoint: POSIX native crash diagnostics and runtime startup
flag integration. Native C builds with `-Wall -Wextra -Werror`. Actual protected
memory faults and raised SIGSEGV terminate with preserved signals and a native
stack in interpreter/native execution. Four worker threads independently initialize
and clean up stacks. Build_Options ON/OFF workspace tests pass native execution.
All 175 owned Jai files pass repo jaifmt --check and jailint -D warnings. The
expanded regression passes 58 interpreter/native cases, ten SMTP scenarios,
four parent-lifetime scenarios, four expected faults in both execution modes,
Xar reverse rejection, startup ON/OFF and selected Linux/Windows target checks.

Previously verified checkpoint: classic Zip_File_Directory parsing and ownership,
including malformed second-record cleanup under a counting allocator. The full
focused run now passes 59 interpreter/native cases and six expected faults in
both modes, retaining the SMTP, parent-lifetime, startup and target checks above.
All 181 owned Jai files pass jaifmt --check and jailint -D warnings. The ZIP field
and extension contract gaps are documented, not asserted as established behavior.

Previously verified checkpoint: CAS-based Atomics arithmetic/bitwise operations and
the exact alias declarations. The three alias intrinsics lack source-compiler
lowering; the original pending reproducer and handoff are documented. Full focused
regression passes 61 interpreter/native cases, seven expected faults in both
modes, two compile-time rejections, all prior SMTP/startup/parent checks and selected
Linux/Windows checks. All 188 owned Jai files pass format/lint. Four-worker tests
verify prior-value uniqueness, bit claims and zero-reaching decrement behavior.

Previously verified checkpoint: partial Deep_Copy scalar/string/resizable-array
operations, callback/preallocated/reused-map cases and conditional debug globals.
General graph support is blocked by reflected struct alignment 0 (versus 8),
reproduced in interpreter/native with retained assertions. It is not counted as
completed graph functionality. Full focused regression passes 63 cases in both
modes, nine expected faults in both modes, two compile-time rejections and prior
SMTP/startup/parent/target checks. All 197 owned Jai files pass format/lint.

Previously verified checkpoint: Unix BuildCpp C/C++ compile/link/archive/object and
macOS universal outputs. Native executable and dynamically loaded function return
the expected results; stale archive members disappear on rebuild; missing tool,
invalid C and wrong-target objects report real errors after cleanup. Full focused
regression passes 64 interpreter/native cases, nine runtime faults in both modes,
five compile-time rejections, and prior SMTP/startup/parent/target checks. All
203 owned Jai files pass format/lint. The runner requires zero C-helper intermediate
directories and preserves previous output after failed compilation.

Previously verified checkpoint: Treemap stable nodes, weights/sort, hierarchy,
callback borders, cached squarified geometry and shared-boundary growth fix.
Full regression passes 65 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections and prior integration checks. All 209 owned
Jai files pass format/lint; delegated Math is copied only into the integration
root. Meow is blocked by the canonical register macro compiler reproducer;
no replacement public type/hash routine was invented.

Previously verified checkpoint: Unix Shared_Memory_Channel SPSC transport, ownership,
real wrap/full/corruption/max-packet behavior and captured allocator cleanup.
Full regression passes 66 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections, four interprocess pairings with 2,048 packets
each, and prior SMTP/startup/parent/target checks. All 215 owned Jai files pass
format/lint; Linux x64/arm64 channel code is separately compile-checked. Wire
details and Windows/Linux-execution gaps remain explicit. Two early failed runs
left unjournaled PID-named objects; no global deletion was attempted. Subsequent
tests journal and check cleanup of only their recorded resources.

Previously verified checkpoint: Unix Autorun helpers and real COMPLETE lifecycle,
including native child argument forwarding, repeated direct execution, NO_OUTPUT
skip and real runtime launch/exit failure logs. Full regression passes 67 cases
in both modes plus prior faults/rejections/SMTP/IPC/startup/parent/target checks.
All 220 owned Jai files pass format/lint. Compiler mixed-spread loss and CLI use
of a non-oracle helper are retained as pending reproducers; no convenience export
or surrogate callback module parameter was added.

Previously verified checkpoint: MPEG canonical buffers, checked
bit/VLC/start-code/file helpers, all reviewed immutable tables, six pixel aliases
and integer IDCT. Full focused regression passes 70 interpreter/native cases,
11 expected runtime faults in both modes, five compile-time rejections, ten SMTP
scenarios, four 2,048-packet process pairings and prior startup/parent checks.
Linux and selected Windows checks pass; Windows MPEG is explicitly excluded after
an observed failure at the existing File Unix guard. All 230 owned Jai files pass
source-built jaifmt --check and jailint -D warnings; table regeneration is byte
idempotent.

Previously verified increment: canonical Video lifecycle/frame storage, transactional
headers/matrices and allocation retry/lifetime checks; motion/vector wrapping and
half-pixel prediction; entropy/dequantization/slice/frame reconstruction. Independent
constant intra stream and all ten red I/P frames in the authorized fixture's
elementary payload decode, including rewind and pixel checks, in both modes.
Full regression passes 73 cases in both modes, 13 runtime faults in both modes,
five compile-time rejections and prior SMTP/IPC/startup/parent/target checks.
Final review then added missing/overlapping coverage and reference validation:
all six MPEG positives and four MPEG faults pass interpreter/native, with Linux
x64 checks. The new missing-region fault retains its completeness assertion.
All 239 owned Jai files pass format/lint. B-picture prediction is directly tested;
full B/AC stream fixtures and dimension/rate transitions remain incomplete.
Continue program-stream demux, audio and Plm before remaining owned modules.

Previously verified increment: MPEG-1 Layer II unprotected audio, canonical Audio/Samples,
headers/quantizers/scalefactors and real interleaved synthesis. Independent silence
and sixteen mono 440 Hz tone frames pass channel/amplitude/frequency/count/rewind
checks in both modes. Direct matrix versus licensed public C bases differs by at
most 9.44472552e-7; this is algorithm verification, not API authority. Whole-table
addressing preserves canonical quantizer pointers; the original direct-index
lifetime and qualified aggregate-write gaps remain pending. CRC and format changes
reject explicitly; stereo stream fixtures remain pending. Compiler rebuilt from
current independent sources with --locked, private target. Full regression passes
74 interpreter/native cases, 16 faults in both modes, six compile-time rejections,
and prior SMTP/IPC/startup/parent/target checks. All 248 owned Jai files pass
jaifmt --check and jailint -D warnings. Continue demux/Plm.

Previously verified increment: MPEG-1 program-stream parsing and canonical Plm/Packet
lifecycle, callbacks, enable/loop flags and real linear seeks. Full clip decodes
ten video/sixteen audio frames without extracted payloads. Bytewise append input,
borrowed buffer/file ownership and 240-frame file refills pass in both modes;
tracking reports zero allocations after program cleanup. Full regression passes
75 interpreter/native cases, 18 faults in both modes, six compile-time rejections
and prior integration/target checks. A final retained buffer assertion then fixed
signaled end bounds after compaction; changed MPEG buffer/video/program cases are
rechecked independently. Existing own MPEG regression passes interpreter/native.
All 252 owned Jai files pass jaifmt --check and jailint -D warnings.
Seeking/count/resume policies and bounded buffering require review; MPEG-2,
unbounded PES, CRC/format changes, macros and compiler constant gaps remain.

Previously verified increment: original intra-coded B-order and nonconstant horizontal
AC fixtures; fixed EOF loss of the pending reference following trailing B output.
The retained test now yields luma 80/120/160 in display order, with correct times
and rewind. No-delay B input rejects; real I/P frames pass no-delay mode. Full
regression passes 76 interpreter/native cases, 19 faults in both modes, six
compile-time rejections and prior integration/target checks. All 254 owned Jai
files pass jaifmt --check and jailint -D warnings. Inter-predicted B, stereo, CRC,
format transitions and unresolved public contracts remain; continue these.

Previously verified increment: nonzero stereo/dual/joint Layer II fixtures with distinct
channel gains. Fixed joint shared-sample reconstruction to retain both scalefactors;
raw quantized values are decoded once and scaled separately. The temporary replay
path is removed. Two frames and rewind pass per mode. Full regression passes
77 interpreter/native cases, 19 faults in both modes, six compile-time rejections
and prior integration/target checks. File backend formatting is now excluded under
platform-io ownership; all 254 files in the narrowed scope pass format/lint.
CRC and remaining codec contracts are next; broader portable scope remains active.

Previously verified increment: source-compiler integration now runs exact atomic
aliases, original caller-scope cleanup, reflected alignment and cyclic/shared
Deep_Copy graphs. Five former pending regressions are promoted, retaining all
assertions. Remap_Context's exact lexical macro passes nested/early-return checks.
Mixed spreads pass and Autorun's extra argv allocation is removed. Full regression
passes 82 interpreter/native cases, 19 faults in both modes, six compile-time
rejections and prior integration/target checks. All 254 owned Jai files pass
format/lint. Constructor/constant-index/qualified-array-write/workspace/widened-bitwise
gaps remain. Scalar register rejection is now a proper category diagnostic, not
evidence against supported SIMD registers; Meow remains unfinished pending a valid
probe and implementation. Continue protected MPEG audio and remaining modules.

Previously verified increment: protected Layer II frames compute/validate actual
header/allocation/scfsi CRC, preserving canonical Audio ABI with private captured
metadata. Two protected joint-stereo frames plus rewind pass; flipping the wire
checksum produces a checked mismatch before synthesis. Tracking verifies metadata
cleanup. Parsed-header identity is required for frame decoding; copied/manual
records and registry cost are explicit deviations awaiting contract review.
Full regression passes 82 interpreter/native cases, 19 faults in both modes,
six compile-time rejections and all prior worker integration/target checks.
All 254 owned Jai files pass source-built jaifmt --check and jailint -D warnings.
Continue valid SIMD register verification, Meow/SIMD and remaining owned modules.

Previously verified increment: all reviewed Meow exports execute real calico hashing,
register mixing/lane extraction, incremental state and diagnostics. Live mutable
array identity/edits are checked. 317 source-built native C cases verify one-shot,
fragmented streaming, both 128-byte outputs, tails/blocks/page offsets and custom
tables/seeds; interpreter/native O0/O2 pass. The original scalar register probe
is preserved as a category rejection; valid operands pass. Ancillary scratch/dump/
store/state-byte contracts and portable performance remain honest limitations.
Full worker regression passes 86 interpreter/native cases, 20 faults in both modes,
eight compile-time rejections and prior SMTP/IPC/startup/parent/target checks.
All 265 owned Jai files pass format/lint. Existing own Meow x64 assertions pass in
both modes with an explicit NEW-foundation target overlay; no peer writes or
production integration claim. Continue SIMD and remaining owned modules.

Known workarounds and incomplete behavior are recorded in
[deviations](stdlib-deviations.md), [gaps](../portable-stdlib-gaps.md) and the
module ledger. Next: finish regression/checkpoint, then continue remaining owned
portable modules using reviewed specifications. Full corpus/release integration
remains the coordinator's responsibility.

## Replacement integration checkpoint

All eight manifest snapshots merged in separate commits, ending at `6822bc1`.
Combined compiler/LSP/jailint source build and unchanged jaifmt O2 build against
production `stdlib` exited zero. Workspace tests and direct audit are in progress;
no full integration pass is claimed. See [integration evidence](../tools/cleanroom-integration.md).
# Replacement integration checkpoint: compiler widths and reflection

Latest replacement integration update: compiler 890329b and portable 8a0d40c are
merged (413518b, 04d4611), retaining independent context/marker/width/probe fixes.
Production generic metadata now unblocks all 24 foundation host cases and all 19
WASI cases at O0/O2; six unused-code target profiles pass, macOS x64 still fails
POSIX.timeval. Strict lint remains failing on host-inapplicable Windows roots,
and those exit-zero incomplete compilations are now rejected explicitly.
All 45 reviewed contract cases pass interpreter and native. Real shared channels
transfer 2,048 byte-checked packets in each of four interpreted/native process
pairings. Corrected Mail import passes ten real SMTP/MIME cases. Original runtime
configuration fixture is retained as an explicit rejection case; its temporary
storage assertions separately pass with the configured runtime in interpreter/
native O0/O2. This is supported integration evidence, not release completion.
Committed bindings still lack AppKit and safe SDL2 mismatched-record marshalling;
full original corpus remains coordinator-only. Basic.log is reviewed and missing,
correcting the earlier integration classification. No publication/CI dispatch.

Role: replacement integration worker. Approved refreshed compiler/portable/
numerics/window snapshots merged. Durable compiler fixes: `16b66d8` floating
intrinsic widths and `2d839cd` reflected struct alignment/graph regression.
Original binary32, alignment and Deep_Copy graph tests pass interpreter/native
O0/O2 against production; workspace clippy warnings denied passes. Numerics
production suite now 40/83, preserving missing-AppKit/platform/Wasm failures.
Windows signed-wheel public regression passes x64 all-code typechecking; native
CI remains required. Reviewed contracts/regenerated POSIX shapes committed in
`7a89c1d`; next macOS x64 failure is timeval shape selection, not itimerval.
Broader refreshed workspace/portable/quality checks are running. Coordinator
requests and deviations remain in the integration documents; no push or CI
dispatch performed.



## Windows producer startup checkpoint

# Portable stdlib progress

Platform-io cc07c00 update: actual Windows x64/ARM64 Platform interpreter/native
O0/O2 steps passed; full jobs failed. The startup failure without `--` is isolated
and fixed in the compiler executable-query adapter, with independent red/green
regressions and strict SDK/native-CI hooks. ARM64 default crash selection remains
an explicit narrow review request; public defaults/diagnostics are preserved.
Platform-io Windows Thread SDK effects/result checks are independent of optional
assertions; failed close/resume retains ownership. Public caller-disabled lifecycle
and protected real-thread-handle failure/retry tests are scheduled in the native
runner. Local host suite, cross checks/builds, formatter and 51-file strict lint
pass. Windows execution and internal Basic(false) configuration audit are pending;
Unix/generic operations remain portable-owner work. See platform progress.

Platform-io e223538 review: six O0 mismatches were genuine Jai guard interception,
two O2 mismatches stale export-alias symbol expectations. Added independent C
PAGE_NOACCESS fault helper and separate retained O0 guard cases without changing
production guards. Six parser tests and 50-file format/strict four-target lint
pass; new native SEH matrix still awaits both-CPU CI. See platform progress.

Platform-io checkpoints: 2cdbd9b cleanup/diagnostic gates; 7eb81e8 generic Windows
unwind metadata and bounded iterator. Separate Windows wait-error safety mapping
and exact SDK-negative logging assertions are added; new native confirmation and
the interpreter real-thread-handle/compiler handoff remain pending.

Platform-io continuation after 2cdbd9b: implemented generic Windows async unwind
metadata after an original O2 fixture exposed missing required .pdata entries;
19 LLVM unit tests/clippy and fresh PE metadata checks pass. Corrected bounded
x64 frame iteration with initial-repeat/skip/recursion/cycle unit coverage.
Actual x64 fault/thread output request and native verification remain pending;
earlier ARM64 12-case native positives stay intact. See platform progress/deviations.

Platform-io e8c312d: private ARM64 native startup/fault OFF/ON/default O0/O2 now
passes all 12 cases. x64 four enabled faults and interpreter thread output on both
CPUs remain open, with exact own-output request pending. Added private x64 session
isolation/runtime cleanup, original SDK walk/lifecycle probes, named-frame quality
tests and exact result capture. Local host/cross checks and strict 49-file lint
pass; new native behavior is not claimed verified. See
[current follow-up](../platform-io-e8c312d-follow-up.md).

Platform-io 0100a1f follow-up: actual signed-wheel/argv tests pass on both Windows
CPUs; ARM64 Platform passes. x64's interpreter PE assertion wrongly treated tagged
procedure IDs/heap globals as native image sections. Shared tests now use real SDK
probes, preserve native compiled-symbol O0/O2 assertions separately, and check
actual repeated handler installation. Host/cross checks and strict 46-file lint
pass; new fixtures/private ARM64 backend still need native CI with --windows-crash.
See [section-query evidence](../platform-io-section-query-regression.md).

Platform-io cc07c00 update: actual Windows x64/ARM64 Platform interpreter/native
O0/O2 steps passed; full jobs failed. The startup failure without `--` is isolated
and fixed in the compiler executable-query adapter, with independent red/green
regressions and strict SDK/native-CI hooks. Coordinator direction now authorizes
a private ARM64 native exception backend, implemented with unchanged ON/AUTO
defaults; public x64 callback diagnostics remain. Strict lint covers 45 owned Jai
files. New backend/native argv execution still requires coordinator Windows CI.
See [startup findings](../platform-io-startup-regressions.md).

Platform-io role continuation: public Windows Process records/adapter landed in
`700f07e`; reviewed x64 crash facade (`2b1d623`) and generic strict-lint/IDE repairs (`27b719c`) are now
implemented. Four-target strict lint covers all 42 owned sources; host interpreter/
O0/O2 and Windows source/cross-link checks pass. Later Windows native CI remains
required. See [platform progress](platform-io-progress.md) for exact commands and
[deviations](platform-io-deviations.md) for limitations and dependency staging.

Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior implementations used. Extensions and corpus preserved.

Latest committed checkpoint: `04205ed`, stable Treemap hierarchy/layout. Earlier
checkpoints cover foundations, Unix process/thread/files/system, codecs,
allocators, Soa, Xar, command/text parsing and reviewed protocol schemas; consult
[module ledger](../portable-stdlib-ledger.md) for exact partial/remaining scope.

Previously verified checkpoint: POSIX native crash diagnostics and runtime startup
flag integration. Native C builds with `-Wall -Wextra -Werror`. Actual protected
memory faults and raised SIGSEGV terminate with preserved signals and a native
stack in interpreter/native execution. Four worker threads independently initialize
and clean up stacks. Build_Options ON/OFF workspace tests pass native execution.
All 175 owned Jai files pass repo jaifmt --check and jailint -D warnings. The
expanded regression passes 58 interpreter/native cases, ten SMTP scenarios,
four parent-lifetime scenarios, four expected faults in both execution modes,
Xar reverse rejection, startup ON/OFF and selected Linux/Windows target checks.

Previously verified checkpoint: classic Zip_File_Directory parsing and ownership,
including malformed second-record cleanup under a counting allocator. The full
focused run now passes 59 interpreter/native cases and six expected faults in
both modes, retaining the SMTP, parent-lifetime, startup and target checks above.
All 181 owned Jai files pass jaifmt --check and jailint -D warnings. The ZIP field
and extension contract gaps are documented, not asserted as established behavior.

Previously verified checkpoint: CAS-based Atomics arithmetic/bitwise operations and
the exact alias declarations. The three alias intrinsics lack source-compiler
lowering; the original pending reproducer and handoff are documented. Full focused
regression passes 61 interpreter/native cases, seven expected faults in both
modes, two compile-time rejections, all prior SMTP/startup/parent checks and selected
Linux/Windows checks. All 188 owned Jai files pass format/lint. Four-worker tests
verify prior-value uniqueness, bit claims and zero-reaching decrement behavior.

Previously verified checkpoint: partial Deep_Copy scalar/string/resizable-array
operations, callback/preallocated/reused-map cases and conditional debug globals.
General graph support is blocked by reflected struct alignment 0 (versus 8),
reproduced in interpreter/native with retained assertions. It is not counted as
completed graph functionality. Full focused regression passes 63 cases in both
modes, nine expected faults in both modes, two compile-time rejections and prior
SMTP/startup/parent/target checks. All 197 owned Jai files pass format/lint.

Previously verified checkpoint: Unix BuildCpp C/C++ compile/link/archive/object and
macOS universal outputs. Native executable and dynamically loaded function return
the expected results; stale archive members disappear on rebuild; missing tool,
invalid C and wrong-target objects report real errors after cleanup. Full focused
regression passes 64 interpreter/native cases, nine runtime faults in both modes,
five compile-time rejections, and prior SMTP/startup/parent/target checks. All
203 owned Jai files pass format/lint. The runner requires zero C-helper intermediate
directories and preserves previous output after failed compilation.

Previously verified checkpoint: Treemap stable nodes, weights/sort, hierarchy,
callback borders, cached squarified geometry and shared-boundary growth fix.
Full regression passes 65 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections and prior integration checks. All 209 owned
Jai files pass format/lint; delegated Math is copied only into the integration
root. Meow is blocked by the canonical register macro compiler reproducer;
no replacement public type/hash routine was invented.

Current verified checkpoint: Unix Shared_Memory_Channel SPSC transport, ownership,
real wrap/full/corruption/max-packet behavior and captured allocator cleanup.
Full regression passes 66 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections, four interprocess pairings with 2,048 packets
each, and prior SMTP/startup/parent/target checks. All 215 owned Jai files pass
format/lint; Linux x64/arm64 channel code is separately compile-checked. Wire
details and Windows/Linux-execution gaps remain explicit. Two early failed runs
left unjournaled PID-named objects; no global deletion was attempted. Subsequent
tests journal and check cleanup of only their recorded resources.

Known workarounds and incomplete behavior are recorded in
[deviations](stdlib-deviations.md), [gaps](../portable-stdlib-gaps.md) and the
module ledger. Next: finish regression/checkpoint, then continue remaining owned
portable modules using reviewed specifications. Full corpus/release integration
remains the coordinator's responsibility.

Current verified increment: canonical SIMD value aggregates and supported scalar kernels pass interpreter/native, including all comparison forms, 64-lane masks, wrap, unaligned stores and reflected names. No allocation or ISA dependency; scalar min/max delegates to Basic. Load's missing result header and offsets/looping/interleaving contracts remain unresolved. Full suite passes 87 positive cases in both modes, 20 expected faults in both modes, eight compile rejections and prior SMTP/IPC/startup/parent/target checks. Source-built formatter/linter pass all 269 owned Jai files. Review records distinguish implementation mask/FP/overflow policies from reference facts. Continue executable-format containers and remaining modules.
Previously verified increment: canonical SIMD value aggregates and supported scalar kernels pass interpreter/native, including all comparison forms, 64-lane masks, wrap, unaligned stores and reflected names. No allocation or ISA dependency; scalar min/max delegates to Basic. Load's missing result header and offsets/looping/interleaving contracts remain unresolved. Full suite passes 87 positive cases in both modes, 20 expected faults in both modes, eight compile rejections and prior SMTP/IPC/startup/parent/target checks. Source-built formatter/linter pass all 269 owned Jai files. Review records distinguish implementation mask/FP/overflow policies from reference facts. Continue executable-format containers and remaining modules.

Previously verified increment: executable_formats supplies canonical archive records, bounded classic/GNU/COFF/BSD parsers, real symbol indexes and universal signature detection. Original wire fixtures and a freshly compiled C/ar archive pass, including malformed index/string/header/padding checks and tracked zero-live cleanup. Universal records await missing Arch_File shape; thin/64-bit indexes reject. Full worker suite passes 88 interpreter/native cases plus all prior 20 faults/eight rejections/integration/target checks. All 272 then-owned Jai files passed formatting/lint after removing one unused test import. Next audio sample/mixing foundations and remaining modules; full task remains unfinished.

Previously verified increment: Sound_Player has nineteen canonical common records/enums, real sample arithmetic and magic reads, exact reviewed mutable arc initializers and shared accumulator/selected-arc/retired-decoder storage. Cross-import mutation, ABI/defaults and two checked safety faults pass. Full suite passes 89 interpreter/native cases, 22 expected faults in both modes, eight compile rejections and prior SMTP/IPC/startup/parent/target checks. All 279 owned Jai files pass format/lint; Sound/SIMD generators reproduce exactly. Playback/backends/panning/resampling/compressed decode remain unfinished, with detailed contracts and no fake success. Continue portable bundle/tool helpers and remaining scope.

Current verified increment: all reviewed MacOS_Bundler procedures now perform real macOS bundle/icon operations and portable scalar XML writing. Interpreter/native tests run copied script executables, both resource modes including hidden files, optional plist omission, actual sips/iconutil ten-size round trips, invalid image/missing executable diagnostics and cleanup. XML independently validates with Python/plutil; NEW foundations execute finite-real output and reject nonfinite values. Newly required basic-context was added to both plist/Meow overlays after actual staging failure; both rerun successfully. Full suite passes 90 positive interpreter/native cases, 22 faults/eight rejections and prior integration/target checks. All 284 owned Jai files pass format/lint. Copy/name/Any/partial-output policies are explicit review limits. Continue real file watching and remaining portable modules.

Next increment in progress: File_Watcher native lifecycle/event queue. Verified NEW FSEventStreamContext ABI regression against official SDK; preserved failed assertion, no peer edit or zero-value workaround. Generic nested callback specialization probe passes interpreter, so it is not a compiler gap. Watcher execution remains unimplemented at this checkpoint.

## Integration refresh eleven milestone

All eleven approved producer checkpoints and authorized native-CI candidatee8c312d are merged. Rejected SDL proxy removed; canonical runtime size protocol adopted with real production interpreter/native allocation regression passing. Broad combined source verification is next; latest additional producer heads remain pending, overall integration is unfinished. See tools/cleanroom-integration.md and status/integration-deviations.md for exact scope and unresolved native failures.
Verified watcher increment: exact macOS File_Watcher facade executes SDK-native callback queues, real create/modify/remove/rename, typed dispatch, trailing-edge coalescing, recursive filtering and overflow rescan in interpreter/native modes. Captured allocator cleanup returns zero under a changed polling context. Native backend executes under ASan/UBSan plus actual owned-allocation tracking, including failure/overflow. All 289 owned Jai files pass format/lint. No Windows/Linux support or binding-ABI repair claim; reviewed-policy/packaging limits documented. SIMD's newly updated reviewed page resolves prior gaps and requires 1/0 comparison lanes/truth-based masks; correcting those and finishing its remaining operations is next. Existing full suite's 90-case result predates that new oracle update and is not a claim against the revised SIMD contract.

Integration eleven verification: full workspace executed after fixing new lint-test configuration; underlying57 failures retained and classified separately, canonical runtime stale-negative expectation corrected with real allocation coverage retained. Foundation behavior suite passes all42 host/33WASI cases and seven target profiles; strict lint still exposes pending side-effect import repair. Renderer real host cases pass, private packet test placement corrected; full rerun next. Newer producer/source-native fixes are integrated in secondary worktree pending combined source freeze.

## Combined refresh twelve reviewable checkpoint

All latest named producer snapshots including audio7d641f8 and developer-tools
a553de2 are integrated at d485811 plus current scoped integration repairs.
Actual production tools build; all835 then-new Jai sources format-check.
Foundation43host/35WASI behavior plus seven profiles and strict116-file union
passes. Platform49-file strict lint passes. Window167 invocations pass.
Four controlled audio cases and actual C-header/performance tests pass with
strict tooling. SDL native pointer/lifetime tests pass; public48/72 and8/32
layout failures remain. SIMD newly settled contracts and Windows Socket/shared
memory remain owner gaps. Full workspace/original suites retain real failures;
639-file LSP sweep and optimized float retry are running.
Exact commands/results are at tools/cleanroom-integration.md. Coordinator may
review this committed source for the next normal temporary native CI candidate,
including WGL retirement/x64 cleanup and SDL3 Windows path repair. It is not a
green integration or release approval. No push/dispatch/publication performed.

Refresh12 final milestone: full639-file LSP sweep17073edits/2762443assertions,
zero failures; genuine caller-font cases21extra invocations pass. Optimized
compiler float oracle passes all five modes; ordinary portable134/134 pass with
six Windows target failures retained. Latest SDL policy now verifies exact public
prefixes and complete private records separately, every offset/alignment and C
write canaries; actual SDK aggregate zero failures, no public layout/API change.
Historical mismatch evidence remains. New manifest13 compiler-unwind and portable
SIMD/CAPS checkpoints await integration; UI/archive actual lint fixes are in
secondary verification. Publication held, nativeCI/corpus/Focus coordinator-only.
Current verified SIMD oracle increment: all reviewed exports now execute scalar value kernels. Added unaligned contiguous load, byte gather/scatter (negative/repeated offsets and later-lane overwrite), i*STEP indexes and complete interleaved pair sums. Corrected prior all-ones/MSB choices to the updated oracle's 1/0 comparison values and truth masks; source defects remain documented. Interpreter/native focused tests and byte-identical regeneration pass. Full worker regression again passes 90 cases in both modes, 22 faults, eight compile rejections and prior SMTP/IPC/startup/parent/Linux+Windows target checks. All 289 owned Jai files pass format/lint. Watcher focused native/sanitizer checks remain separately verified. Continue compiler performance/report and remaining portable scope.

Runtime/CAPS checkpoint: exact three-boolean Runtime_Support now consumes the private settled compiler configuration. Actual root allocations 0/65536/131072 pass interpreter/native O0/O2; independent child 0/131072 native executions pass. Pool CAPS accepts required null data, delivers persistent name and exact flags; runtime heap name delivered. Full suite passes 92 cases in both modes, 22 faults/eight rejections and prior integration/target checks; 283 narrowed owned files pass format/lint. Audio/tools ownership excluded. Three provisional Performance_Report files remain uncommitted, enumerated in portable-runtime-configuration.md; no completion claim. Continue public time/calendar and containers; Flat_Pool defaults still missing from oracle.

Refresh13 source milestone: compiler995685c async Windows unwind, portable2355943
settled SIMD/PoolCAPS/runtime adoption and foundation3d218cb reports are merged,
plus authorized native ARM64 CI environment fixes. UI/archive unused bindings
removed with calls/result positions preserved; nine UI suites45invocations and
archive behavior pass. All21 LSP refactor tests pass against current independent
implementation paths. UI strict lint still has a genuine circular initialization
diagnostic; minimal related self-address repro and lifecycle request recorded.
New production builds/unwind/runtime/SIMD/regeneration/quality checks are next.
Time/CAPS family checkpoint: to_apollo now scales exact binary significands into signed two-word femtoseconds, including large finite durations. POSIX timespec/realtime/monotonic/UTC-local calendar APIs execute genuine native queries and zero-based calendar conversions. Full suite passes 93 interpreter/native cases, 22 faults/eight rejections and prior integration/Linux+Windows checks; time test also executes native O2. Extended CAPS contract to temporary/C-fallback/overwriting/unmapping allocators before instance access; all four allocation suites pass interpreter/native O0/O2. 285 owned files pass format/check/strict lint. Android CLI target rejected as unsupported, no Android validation claim. Detailed per-public-time API gaps and policy review in portable-time.md. Continue container/platform backlog; unresolved Flat_Pool defaults and startup clock origin recorded, no fabricated exports.

Flat_Pool/container checkpoint: canonical Flat_Pool and real native get/reset/fini/mode core pass interpreter/native O0/O2 with explicit OS reservations, including actual shared-readonly mprotect failure preserving cursor/commit state. Public init/example and unspecified global overwrite remain missing, not counted complete. Hash_Table existing duplicate copies/removal now have 128-duplicate, rehash/copy lifetime, captured-owner cleanup, tombstone/counter and NEW scalar-default regressions. Full suite passes 95 cases both modes, 23 faults both modes, eight compile rejections and existing integration/target checks. Formatter/check/strict lint pass 290 owned files. First new fault expectation omission caused runner KeyError; registered exact diagnostic and rerun passed, original log retained. Continue remaining portable/platform APIs; no audio/tooling changes.

Refreshed Flat_Pool oracle adopted immediately after inbox read: both inferred module parameters, exact inferred init default256MiB, page rounding, lazy get, global OR local stamping and real example added. Normal/capacity tests now call public init; interpreter tests pass configured/default extents, all four stamp combinations, zero-byte reservation, reinit and STARTUP/SHUTDOWN. Full95-case suite and strict lint running; old unresolved-default reports superseded. Windows_Utf8 changes remain durable and uncommitted with both Windows CPU ABI/body checks and host strict lint previously passing, native execution still unavailable.

Flat_Pool initialization rerun complete:95 cases/23 faults both modes plus eight rejections and prior integration/target checks pass; dedicated Flat_Pool native O2 passes;293 owned files pass formatting/check/strict lint. Refreshed reserve/default/overwrite gaps are resolved, not remaining blockers. POSIX-host implementation now exercises all reviewed procedures; Windows/console backend and Android target-validation gaps remain.

Windows_Utf8 checkpoint: both reviewed procedures have real Kernel32 conversion, correct explicit/default termination and failure cleanup. Original Windows fixture covers non-BMP/embedded-NUL/empty/native-invalid/allocation-failure cases, and both CPU bodies/ABI type-check. Actual Windows execution remains unavailable and unclaimed; dedicated runner requires Windows for --native. All293 owned files pass format/check/strict lint. Provisional Performance_Report remains uncommitted/excluded. Continue remaining portable/time/backend work after inbox review.

Virtual-memory backend checkpoint: shared private reservation/commit/release/page-size operations preserve real POSIX execution and add Windows VirtualAlloc/VirtualFree. Full Flat_Pool fixture now type-checks Windows x64/ARM64 including initialization/default/overwrite/lifecycle, rather than record-only checks. Actual Windows execution remains unverified. Full95-case/23-fault interpreter/native suite and prior eight rejections/integration/target checks pass; dedicated native O2 passes; all294 owned files pass format/check/strict lint. Continue portable time gaps and remaining modules after inbox review.

FILETIME checkpoint: exact canonical Windows wrappers call real private two-word arithmetic. Production-source unit executes host interpreter/native O0/O2 across Unix/1601 epochs, unsigned64 boundaries, invalid/pre-epoch/overflow and sub-tick cases. Windows x64/ARM64 wrappers/ABI fixtures type-check; actual Windows runtime still unverified. Full96-case/23-fault both-mode suite plus prior rejection/integration/target checks passes;297 owned files pass formatting/check/strict lint. Continue native Windows clock exports and remaining portable APIs after inbox review.

Windows clocks checkpoint: public realtime uses actual Kernel32 FILETIME, monotonic uses typed QPC with atomic frequency caching and exact private integer scaling. Both Windows CPU fixture bodies type-check. Production-source counter unit executes host interpreter/native O0/O2 including full signed64/fractional/invalid/monotonic vectors. Actual Windows calls/cache race remain unverified. Full97 positive/23 fault both-mode suite plus eight rejections/prior integration/target checks passes;300 owned files pass format/check/strict lint. Remaining time gaps: seconds_since_init origin/hook, calendar text/ConvertToApollo caller scope and native Windows calendars. Continue remaining portable scope with inbox checks.

Machine_X64 blocker confirmed: original leaf0 vendor assertion fails interpreter and native x64. Independently compiled C SDK counterpart executes real CPUID and returns vendor/maxleaf. No Machine module fake0 fallback added; minimal reproducer and generic lowering handoff in portable-machine-gaps.md. All301 owned Jai files still pass format/check/lint, pending case explicitly failing not counted green. New inbox resolves seconds_since_init as first-call baseline; implement next, superseding prior origin questions.

Elapsed checkpoint verified: exact seconds_since_init lazily captures the FIRST CALL origin per refreshed oracle, with private CAS-safe shared publication. Ordinary before/after sleep, eight-thread first-use and actual-macOS compile-time-to-runtime reset all execute interpreter/native O0/O2. Windows ARM64 body checks pass, with actual Windows execution unclaimed. Full98-case/23-fault both-mode suite plus eight rejections/prior integration/target checks passes;305 owned files pass format/check/strict lint. Prior origin questions now resolved. Next review remaining portable contracts/Basic numeric guard updates without duplicating peer work.


Parameterized time integration in progress: NEW foundation integer guards already exist and remain that producer's work. Focused composition exposed/fixed default-vs-configured Apollo_Time nominal return mismatch using primitive private word pairs. It also exposed real native clock queries disappearing inside ENABLE_ASSERT=false discarded assertions; queries now always execute, with independent operational diagnostics and explicit invalid results for continuing handlers. Configured real wall-clock/delayed-elapsed tests pass NEW composition interpreter/native O0/O2 and Windows body checks. Full own suite99 cases/23 faults passes both modes. Rebuilt strict jailint correctly rejects inputs outside configured library root; runner now maps byte-identical owned files into staged root. Shared Hash facade/scalar file is excluded by ownership, current portable MD5/Meow retained over peer snapshot. Final mapped lint pending; old failure logs retained.

Machine CPU-query increment verified: canonical records and200 reviewed feature values, all352 mask positions, real vendor/eleven-register CPUID and unknown-vendor fallback execute. Native O0/O2 matches official-header C oracle; original vendor probe now passes both optimizations and is promoted unchanged. Actual x64 compile-time interpreter assertions and strict lint pass using a newly source-built x64 jailint. macOS/Linux/Windows x64 body checks pass; ARM64 interpreter explicitly diagnoses. All313 owned files format/check; full strict lint still fails (all three configured groups attempted), with genuine general field-array/enum-forward compiler reproducers retained. Runtime settled root0/65536/131072 and child0/131072 allocation rerun also passes actual interpreter/native checks. Details and exact remaining instruction/options exports: portable-machine-gaps.md. Next: remaining portable scope and general compiler/linter integration; no full completion claim.

Pool safety increment: original positive-INT64_MAX request reached backing allocator as negative; checked private/public overhead now rejects unrepresentable extents before forwarding. Real supplied-allocator failure preserves live contents/cursor/bookkeeping and release reaches zero live blocks. Interpreter/native O0/O2 and focused strict lint pass. Full100 positives/23 faults both modes/ten compile negatives plus integration/target checks pass; four new Unicode/ADPCM typed-constant write rejections pass separately and enter required list (now14). All318 owned files format/check; full strict lint remains failed for recorded compiler/configuration/intentional-negative categories, no suppression. Exact Pool API inventory and unmapping specialization question are in portable-pool.md. Next: continue owned backlog and coordinator-facing semantic/dependency gaps.

Windows calendar increment: exact to_calendar/calendar_to_apollo now use real Kernel32 UTC and dynamic-DST Ex APIs; both CPU bodies and configured Basic instances check. Native Windows execution remains unverified, and host lint leaves Windows branches inactive because jailint has no target selector. Production Gregorian validation executes a400-year cycle plus native O2. Full101 positives/23 faults both modes/all14 compile negatives and prior integration/target checks pass;322 owned files format/check. NEW foundation regeneration/interpreter/native O0/O2 and configured strict lint pass; full strict lint still fails with preserved diagnostics and no suppressions. Native ABI/minimum-Windows/ambiguity policies and precise remaining time APIs are documented in portable-time.md/deviations. Next: remaining owned backlog and general target-aware lint/compiler integration; no task-completion claim.

## Integrated safety/test migration evidence (historical checkpoint)

Refresh14 integrated source checkpoint ee4de74 includes all five updated stable
producer snapshots. Rebuilt production compiler/lint/LSP and unchanged jaifmt;
860Jai format/check and full Rust formatting pass. SDL SDK/prefix/high-bit lifetime
verification passes. Full workspace704aggregatepass/54fail/ninefailedtargets;
full483stdlib cases interp281/202, native274/201 plus8compiletimeonly, zeroskips.
Broad strict quality51/174 failures; source hashes stable. Foundations behavior
and seven source profiles run separately; scalarFNV/division remain genuine
required failures. New general IDE import-recovery/cache fixes and exact browser
source test pass focused27+1tests in secondary; full regression review next.
Publication held; nativeWindows/corpus/Focus coordinator-only.

Integration safety checkpoint: private native reporting hook and unconditional
configured null guards implemented independently. Six native failure categories,
assembly division/nonfatal cast continuation, stale-null-after-store checks,
all arithmetic OFF/NONFATAL/FATAL cases, and runtime-disabled O0/O2 checks pass.
Hook remains private with an exact negative import diagnostic; strict owned Jai
lint and workspace clippy pass. Full compiler/LSP suite is running against the
immutable implementation. New safe coordinator snapshots are now available and
will be audited/merged after this gate; previous missing foundation APIs are
reported implemented upstream, not yet counted as integrated.

Private protocol correction retained exact public compatibility: custom/minimal
Runtime_Support need not implement an extra private hook. Missing extensions use
explicit guard traps; invalid present hooks remain hard errors. Original59
module/config/lint-root tests and two new validation cases pass. First broad
safety run's53failures include the six now-fixed admission errors and genuine/
legacy issues still awaiting reviewed classification; do not extrapolate a new
full-suite total. Updated coordinator snapshots are ready for merge next.


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
Native TCP accessor increment after41a015a:36 reviewed macOS getters/setters now execute against actual Apple SDK C bitfield layouts. All256 whole-record pairs match interpreter and actual host/x64 native O0/O2; x64 C output independently matches host C output. Active implementation/fixture strict lint passes, generation is stable and334 owned files format/check. Full102-case/23-fault/14-negative suite plus prior integration/target checks passes; whole strict lint remains failed. Fixture source-relative path repair preserves failure evidence and all assertions. Exact completed/missing public families and SDK provenance: portable-socket-fields.md. Continue Windows scope and Linux/Android native field helpers, then remaining portable modules.

Windows scope-ID increment: four exact accessors implement 28/4-bit overlay semantics. Public #run assertions pass Windows x64/ARM64; production word kernels pass host interpreter/native O2 and strict lint. Full103 positives/23 faults/14 negatives and integration/target checks pass (target/socket-scope-full-regression.log);339 owned files pass formatting/check. Native Windows remains pending; whole strict lint remains failed, including target configuration for the Windows-only fixture. Widening-shift compiler reproducer: tests/portable-stdlib/pending/widened-bitwise.jai expected8000; shifted high byte lost. SDK FIONBIO expected0x8004667e, original actual0x8004007e; assertion retained.

Pool/Linux increment:104-case full regression passes after classifying the Windows unmapping fixture failure as an unavailable platform backend. Only this genuinely Unix-only test joins the existing platform scope list; every host assertion and Linux check remains. Original target failure retained at target/pool-policy-full2.log. Native Windows allocator support is not claimed. Whole strict lint fails at target/pool-socket-whole-lint.log; focused Pool passes target/pool-policy-final-strict.log.

Calendar increment: two exact public text APIs now use real temporary storage;
POSIX normalization/-1 collision/output error and Windows input/DST policies
follow refreshed review. Full106 positives/23 checked faults in both modes/14
compile negatives plus prior integration and target checks pass
(target/calendar-complete-suite.log). NEW foundation stable regeneration and five
time roots pass interpreter/native O0/O2 (target/calendar-foundation-final.log).
Both Windows CPU body checks pass (target/calendar-windows-final.log); native
Windows remains unverified. Active calendar implementation/test strict lint
passes (target/calendar-active-strict.log);347 owned Jai files format/check.
Whole strict lint remains failed at target/calendar-whole-strict.log.
ConvertToApollo alone remains the named time API gap: exact no-result #expand
header conflicts with value contract/current compiler. Original general
reproducer and precise reviewer/compiler question recorded; no fake export.

Windows Registry increment: seven native procedures/two scalar aliases/fourteen
access constants source-check both CPUs and regenerate byte-identically.
Non-Windows public import/privacy test passes actual interpreter/native.
Full107 positives/23 faults/14 negatives plus prior integration/target checks pass
(target/registry-full.log).352 owned Jai files pass format/check. Native Registry
execution and active Windows strict lint remain unexecuted/blocked; private ABI
lint fails honest Windows requirement, CLI has no target selector. Ten predefined
pseudo-handles remain absent pending reviewed64-bit extension conflict with SDK.
Exact API list, test-only setup/cleanup and failures: portable-windows-registry.md.

Shared TCP increment:22 Android accessors now share actual Linux implementation,
with per-platform export validation and four Linux-only scale helpers. Official
bionic header65536-word C probes pass host ARM64/translated x64; Android CLI still
rejects target selection, so no Android Jai/native pass. Linux x64/ARM64 public
#run bodies pass; macOS36 native SDK record pairs rerun host+x64 O0/O2 successfully.
Full107 positives/23 faults/14 negatives and integration/target checks pass
(target/socket-tcp-unix-full.log).352 owned files format/check; whole strict lint
still fails (target/socket-tcp-unix-whole-lint.log). Superseded Linux-only files
removed. All reviewed bitfield variants now have real source bodies; remaining
Socket CMSG algorithms/native shapes/reflection and native platform gates remain.

Ancillary increment: four exact CMSG procedures match4097 actual host native SDK
vectors in interpreter/native O0/O2 (host ARM64/translated x64). Linux/macOS both
CPU public #run assertions pass. Root layout/extreme-size/privacy regression plus
two checked size faults added. Full108 positives/25 checked faults in both modes/
14 compile negatives plus prior integration/target checks pass
(target/socket-cmsg-full.log).359 owned files format/check; active CMSG roots and
positive fixtures strict lint pass. Whole strict lint still fails at
target/socket-cmsg-whole-lint.log. Only CMSG_SIZE remains the missing ancillary
helper, with fine invalid-extent semantics still questioned; native Linux/
Android and target-aware lint remain pending. Exact inventory: portable-socket-cmsg.md.

Android host tooling increment: exact x64/ARM64 JNI directory names pass host interpreter/native, Linux/Windows checks and focused strict lint. Unsupported custom CPU diagnostics pass both modes.109 positives/26 faults/14 negatives and integration checks pass;363 owned files format/check, whole strict lint still fails. Missing API inventory regenerates identically with253 declaration/overload/nested rows; no functionality credited to those rows. Parent Android/native bindings and excluded modules are untouched.

Watcher safety increment: source-built private close_v2 reports actual error plus
released state; retained objects remain retryable, released objects cannot be
double-closed. Failed registration reuses metadata;4097 real file-as-directory
failures have bounded retained allocation counts and zero captured allocations
after teardown. Native C tests execute SDK EBUSY retention/retry and real SDK
EDEADLK error-channel injection under ASan/UBSan. Public event and six-error
continuing-handler fixtures pass interpreter and actual host ARM64/translated
x64 native O0/O2 (target/watcher-close-reuse-matrix.log). Universal library and
translated executable architecture checked. Focused strict lint passes;365 owned
Jai files format/check. Whole strict lint still fails; original generic-pointer
default constraint reproducer preserved, no API changed to hide it. Last broad
109-positive/26-fault/14-negative suite passed at target/watcher-close-full.log;
later watcher-only changes reran the dedicated full native matrix. Linux/Windows
watcher backends and full integrated CI remain unfinished. Detailed test triage/
private-protocol limits and source deployment prerequisite: portable-file-watcher.md.

Machine spin-hint increment: exact pause macro now emits real native instructions
and passes C-intrinsic/no-call baseline comparison O0/O2 (0 baseline,1/2 public,
8 C static instruction counts). Actual x64 compile-time interpreter/strict lint
and three OS x64 body checks pass; interpreter hint models no fixed delay/order.
Existing CPU/projection suite and full109 positives/26 faults/14 negatives plus
integration/target checks pass (target/machine-pause-full.log).371 owned Jai files
format/check; whole strict lint still fails. New original prefetch/fence native
probes emit0 instructions against C1 each, and their dependency checker fails
explicitly (target/machine-instruction-dependencies.log). Those APIs remain absent,
not fabricated completion. Eight instruction APIs/native platforms remain gaps.

Android OID increment: canonical type/counted equality, exact Sun OID and typed
JKS constants tested across all prefix counts/differences/inactive tails/copy
independence; global writes reject. Native O2 and focused strict lint pass.
Full110 positives/27 checked faults/16 compile negatives and prior integration/
Linux+Windows checks pass (target/android-oid-full.log).376 owned Jai files
format/check; full strict lint remains a failed gate. Review numeric JKS values
preserved, incorrect byte-swap rationale questioned without invented correction.
Exact largely-unimplemented public inventory now248 rows; no signing/DER/device
completion credited. Native platform and compiler gaps remain named separately.

Integration worker checkpoint: generic partial-edit directive regression reproduced the two refresh18 failures; statement-boundary probe isolation now passes all three edit harness tests, affected-file retry (38 edits/1,448 assertions), scoped Rustfmt and LSP Clippy with warnings denied. Full owned-source rerun is pending. Seven-target context lint finished 343 runs with 19 denied/incomplete runs and 891 uncovered owned files; gate remains failed. Next: integrate stable compiler ISA/generic-pointee, Pool/Thread and native build checkpoints, preserving latest reviewed specs.

Digest continuation: reviewed Android/Toolchain.sha1/sha256 now return real fixed
20/32-byte digests from independent scalar Jai compression/padding code. All270
native hashlib vectors pass interpreter and host ARM64/translated x64 O0/O2,
including padding boundaries, embedded NUL/unaligned input and million-a.
Focused strict lint and both Linux/Windows CPU body checks pass. Invalid signed
length independently logs then asserts in interpreter/native O2 (both exit-6);
registered as a separate safety fault, not a reference invalid-input guarantee.
Signing/key/APK/ASN.1 decoding/device operations remain missing, not credited.
No credentials, auth, device or native crypto implementation bodies accessed.
Final digest/ISA regression:112 positives,28 expected faults and16 compile
rejections pass in the broad runner, with real SMTP/IPC/runtime configuration
and Linux/Windows source checks (target/sha-machine-full-final.log). The critical
50-execution lifecycle matrix is independently rerun after the compiler rebuild
and passes again (target/lifecycle-final-compiler.log).387 owned Jai files pass
format/check; focused new production/test strict lint passes. Full owned lint
and native platform CI remain separately open.

Resolved time continuation: exact ConvertToApollo no-result #expand now uses
caller-scoped return into an Apollo_Time procedure. Signed full-width scaling,
argument single evaluation and caller defer cleanup pass interpreter/ARM64+x64
native O0/O2 in both own and NEW foundations compositions. Focused strict lint
passes; existing six time/calendar fixtures pass interpreter/native O0/O2 and
configured Windows source checks. The stale ordinary macro value-expression
probe is retained and explicitly classified as superseded for this API, not a
required compatibility oracle or an established compiler gap. No public result
annotation, compiler special case, fake value or peer write.

Integration worker refresh20: compiler093712a, portablee81f1a5, developer4f87fd6, WGL387efe2 and fuzz172558a merged; exact consumed manifest updated.15 machine/generic-pointer tests plus9 literal/intrinsic regressions PASS. Production-source Pool/leak/Thread matrix50 actual interpreter/ARM64+x64 native O0/O2 executions PASS without overlays; disabled optional assertions proven by real Mach handler counts and unchanged library hashes. Developer56 fixtures/native SDK checks PASS; fuzz12 PASS; Mesa helper16 PASS. Full lint and broad suites remain open; forward enum dependencies reproduce Socket failure and are precisely requested. SDL3b4d6859/WGL3ced6c4 objects missing locally, safe-ref refresh requested. Full1091-file frozen owned-source partial-edit sweep running.

Integration worker refresh21: full frozen e2f9e22 partial-edit sweep PASS1091 files/28912 edits/3310574 assertions, no failed files. Current code has subsequent changes, so final integrated sweep still needed. SDL3 pinned native SDK rebuild plus four relocated C/C++ consumers PASS; helper40/Mesa19 PASS. CI2fa2bc2 merged; coordinator reports SDL3 six-target/fuzz green, broader Windows failures remain. Five prior native failures individually repaired/PASS (ABI/allocation, Windows runtime, stdin, empty workspaces, stack traces). General canonical preload workspace #compiler dispatch repaired, private helper NoDebug and real assertion frame locations implemented. Full prior workspace792PASS/16FAIL/1ignored retained; no inferred new full-pass claim. Concise compiler/integration-refresh21-requests.md sent via durable handoff; f92f10e9/78d73e86 safe objects still need refresh. Expanded target lint diagnostic interrupted for legitimate edits; stable rerun required.

Integration worker refresh21 follow-up:54 contracts now PASS49 positives+5 precise negatives per interpreter/nativeO0 after fixing catalogue stdout/stderr separation and strengthening compile-only/timeout checks;9 protocol tests PASS.394-case broad diagnostic has313/308 positive passes and76/74 failures, not final stable proof. Foundation leak reports/graphs pass; canonical visualization channel remains failed with actual SDK EEXIST, unique-channel create/map/release succeeds, existing owner untouched. Six portable MPEG asset references repaired without data/assertion changes; intended PTS fault now reached. Wide public helper tests PASSinterp/nativeO0/O2; signed-byte conversion rejection retained independently. Public Protocol comparator and macOS addrinfo are genuine missing API/precision gaps, with earlier mistaken addrinfo classification corrected. Stable newer compiler/bindings/window snapshots still need sanitized ref import.

Registry continuation reaches an exact general compiler blocker, not a stale
contract question: positive pointer constants hit the constant freezer heuristic
and diagnose unknown-size memory. Original module-independent reproducer
pending/opaque-pointer-constant.jai fails host and Windows x64/ARM64 checking
with exit1. General opaque address-bit versus owned-memory provenance support
belongs to compiler; no whitelist/sign-extension/mutable workaround used.
Ten reviewed handles remain INCOMPLETE. Six candidate production/generator/test
files remain durable UNCOMMITTED/excluded, enumerated in portable-opaque-pointer-constants.md.
Three provisional Performance_Report files remain independently excluded.
Known committed functionality is preserved in checkpoints; candidate Registry
checking currently fails and is not claimed green.246 largely unimplemented
public rows remain plus partial/platform/compiler gaps, listed per API in linked
module documents.

System counter continuation: reviewed inline read_cpu_counter and x64 public
M64 module alias implemented in owned Unix backend. x64 calls actual RDTSC;
non-x64 Unix returns native CLOCK_MONOTONIC_RAW.tv_nsec, not generic CPU cycles
or accumulated time.64 real bracketed samples and existing System regressions
pass interpreter/ARM64+x64 native O0/O2. Strict target-aware lint passes both
CPUs on macOS/Linux. SDK calls are outside optional assertions and failures log.
The new fixture retains host/Linux checks and is explicitly unavailable under
this Unix-only facade on Windows; peer Windows backend is not edited or claimed.
Evidence and policy: portable-system-counter.md.
Final System/time broad regression passes114 positives/28 expected faults/16
compile rejections plus actual SMTP/IPC/runtime and Linux/Windows source checks
(target/system-time-final-full.log).390 owned files pass format/check. Registry
candidate failure remains independently documented, not counted as passing
module functionality by that broad test total.

Latest inbox ownership split adopted: Ico_File, Icon, Windows_Resources, Subtitles
and Simple_Package now belong to the new independent data worker. No production
code or pending implementation overlapped those five. Public/private/test
formatting scope excludes them, ledger marks delegated, missing-row generator
removes only the assigned modules. Current retained missing inventory is191
rows, reduced from246 solely by transfer of55 rows, not implementation credit.
Regeneration is byte-stable; current390 owned files still pass formatting/check.
Compiler-dependent Registry/toolchain scope and six uncommitted Registry candidate
files remain ours. No data-worker checkout access or mutation occurred.

ADB host subsystem:15 reviewed public declarations implemented, including live
path/serial/verbose storage, three canonical records/enums and nine command/
query/transfer procedures. Source-built native SDK-protocol fixture passes real
process/argv/output/exit/parser/quoting/allocator-cleanup tests in interpreter and
ARM64+x64 native O0/O2. Strict scoped lint and Linux both-CPU checking pass;
unrelated Windows digests retain their source checks after dependency isolation.
Actual SDK is absent from PATH, no daemon/device/auth commands executed, and
Windows ADB depends on peer Process integration.191 retained missing rows become
176; fine ownership/escaping/serial policies are explicitly recorded as review
questions, not assumed reference behavior. README-linked portable-adb.md contains
exact evidence and remaining higher-level/build/install gaps.
Registry original reproducer is committed at tests/portable-stdlib/pending/opaque-pointer-constant.jai;
NEW compiler raw-pointer handoff is now available and will be rebuilt/validated next.

Registry compiler handoff consumed: local --locked source rebuild repairs the
exact committed opaque-pointer and default-generic-pointer probes. Opaque pointer
probe executes interpreter/ARM64+x64 native O0/O2; Registry all33 declarations
source-check/strictly lint Windows x64+ARM64, with immutable write rejection.
Six retained candidates now become verified checkpoint inputs. Native Windows
API calls remain unexecuted; public zero-extension is preserved despite SDK
sign-extension discrepancy. First new lint staging failed private-source access
and was fixed with byte-identical JAIC_STDLIB paths, no capability relaxation.
Evidence: registry-handles-verified-final.log and opaque-pointer-constant-execution.log.

ASN.1 primitive checkpoint-ready batch:13 more reviewed declarations implemented,
including canonical enums/union tag/type alias and real tag/length/s64/OID/dotted
string plus checked binary integer/block cursor operations.517 INTEGER and183
OID vectors plus shape/overlay/alias/eight integer type/both-endian and seven
malformed-cursor tests pass interpreter/ARM64+x64 native O0/O2. Both Linux/Windows
CPUs source-check; scoped strict lint passes.176 retained rows become163.
Unreviewed ASN1_Value content/value_data, printer/depth, prefix-width and accepted
generic type/invalid-input semantics are precise reviewer questions, not guessed
completion. No crypto/key/device/native SDK verification is inferred.
Broad post-compiler/ADB/Registry/ASN.1 regression passes115 positives with
28 expected faults and16 compile rejections plus prior SMTP/IPC/runtime and
Linux/Windows target checks (adb-registry-asn1-full.log).402 owned files pass
format/check. Native Windows Registry/device SDK remain unverified, no fake
platform results. ASN.1 first-combined OID values beyond64 bits are tested, not
rejected merely because a temporary u64 would overflow.

Integration worker refresh22: stable compiler457dc048, bindings9106bfb6,
portablecc63d8d6, developer3b3ff6e5 and window39404f30 are merged. Full combined
workspace run is810 passes/10 failures/one inherited ignored; failures remain
required gates. Real public allocator heap interpreter/native and relocated SDK
execution pass after matching static/shared construction;70 bindings Python
tests pass. Complete production heap sweep and quality reruns remain next.
Latest reviewed macOS addrinfo generated; compiler6080ff0a enum fix and approved
portable-data checkpoint are newly available and will integrate next. Extensions
dependency work remains assigned to its owner. No push/CI dispatch/publication.
