# Foundations progress

Stable API completion checkpoint: f972441. The independent shortest-float audit
has been rerun after the current numeric/Pool changes: all 2300 normal power
intervals and minimal precisions pass native O0/O2 and production WASI O0/O2.
The NEW real Flat_Pool producer is now available and integrated read-only with
its private virtual-memory source; the Preamble test no longer uses a simulated
flat-family callback. Actual zero-data CAPS and early-return behavior pass
interpreter, native O0/O2, WASI O0/O2, strict focused lint and all six native
unused-code targets. The unreviewed modules/Pool name heuristic was removed;
canonical Pool procedure identity and documented Flat_Pool CAPS are sufficient
for the actual providers. No producer checkout or bootstrap parameter changed.

Final owned export batch implements the resolved scalar FNV overload, exact
to_s128/to_u128 #modify guards/conversions, and public all-OS CPU.X64 division
exercise. No genuine reviewed API name/overload remains missing in the owned
Basic/String/Hash/File_Utilities scope; portable time/native responsibility and
unspecified edge policies are separately documented. Signed division now uses
private bit conversions, preserving the public guard boundaries.

Verified 47 host cases in interpreter/native O0/O2 and 39 supported WASI cases
in O0/O2. Thirteen inadmissible conversion sources reject specialization.
The x64 diagnostic also passes interpreter and actual x64 native O0/O2 execution,
with independent Python divmod checks on all printed samples and exact callback
count/order assertions. Six native unused-code scopes pass, including the
diagnostic on Linux/macOS/Windows x64. Real unchanged jaifmt CLI/owned check and
focused changed-code/positive-test -D warnings pass.

Refreshed NEW portable Pool into selected staging read-only; the original null-
data CAPS call and mandatory provider gate now pass. Scalar FNV/division original
public-call gates also pass. The full driver exits 1 solely for the preserved
WASI unused File/POSIX.FILE dependency. Current File producer still loads its
Unix FILE backend for WASI; the original minimal ABI-guard request remains.
Latest linter main/driver match the NEW producer byte-for-byte and still provide
only host context. Full lint exits 1 on 20 target-specific/intentional-negative
roots, with no rule findings; no exclusions or configured-bootstrap/private-
import changes hide them. See foundations-lint-request.md for proper owner work.

Earlier checkpoint evidence follows; current resolutions above supersede its
old missing-API/provider statements.

Latest stable checkpoints: ad84008 implements refined leak filters; e3d9052
verifies the real runtime CAPS provider and retains the Pool failure. Current
supported execution is 45 host / 37 WASI cases as detailed below. Remaining
owned contract gaps and producer/lint dependencies are explicit in the audit;
this is not a completed-all-APIs or full-lint success claim.

Stable implementation checkpoint: ad84008, conventional fix(basic) commit for
refined leak matching/trim/lifetime and the four-facade audit. Its full driver
completed all six native unused-code targets; overall status remains failure
for two actual owned API gaps plus the File/POSIX.FILE WASI dependency.

Following checkpoint: the NEW portable runtime CAPS name-out fix was integrated
read-only in selected staging. Normalizing the prior heap source with real
jaifmt proves its only semantic difference is the name-out block; bootstrap
configuration and allocation logic are preserved. Added real default-allocator
borrowed-name/identity assertions, first observed their failure, then verified
interpreter and focused warnings-denied lint success after integration.
The real Pool CAPS source still asserts on null data; its original public-call
reproducer now also runs as a positive failing integration gate in the driver.
Post-integration verification completed: all 45 host interpreter/native O0/O2
and 37 supported WASI O0/O2 cases pass, including the real runtime CAPS check.
Real jaifmt CLI/owned check and focused warnings-denied lint pass. All six native
unused-code target checks pass for the expanded real-provider test. The full
runtime run retains the two required-API failures; Pool was separately rerun
and failed its original assertion before being added to the driver's ledger.
The earlier full cross run additionally retains the unrelated WASI File ABI
failure. No full success is claimed for those failing gates or complete lint.

Refined leak batch: exact name plus case-sensitive source-path matching is now
implemented for leaves, roots and grouping. Root trimming removes only a matching
or null suffix; leaf trimming retains the first matching node. Report-owned
node/group storage survives tracked allocation cleanup and original option-string
mutation. The old module-identity diagnostic is removed. The graph regression
now selects user_site as its retained leaf under the refined inclusive rule.

Latest NEW compiler/linter sources were copied read-only into durable own staging
and rebuilt; unchanged real jaifmt rebuilt at O2. All 45 host cases pass
interpreter/native O0/O2; all 37 supported production WASI cases pass O0/O2.
New String contract coverage includes views, split variants, parser consumption,
narrowing, partial scan outputs and escaped-percent behavior. Focused changed
production/tests pass -D warnings; complete lint retains seven incomplete roots:
three host-inapplicable Windows files, two expected-invalid/cross-only fixtures,
and two actual positive API gaps. CLI still has no target option. No exclusions
or bootstrap/private-import changes hide those failures.

Full four-facade audit found genuine missing scalar fnv1a_hash overload and
test_unsigned_division export. Original pending public-call probes reject and
are positive required-API gates in the driver, not accepted negative tests.
Exact FNV word/byte and division platform/random callback behavior are requested
in foundations-questions.md; wide-conversion guards remain a precise question.
WASI unused File ABI and Windows/WASI channel transport are producer dependencies.

Stable owned checkpoint: 5c5e27b (array aliasing, canonical debugger context
usage and strict verification evidence). The final expanded driver completed
43 interpreter/native O0/O2 cases, 35 production WASI O0/O2 cases, exact misuse
termination/rejection gates and all six native unused-code scopes. Its overall
exit remains 1 for the preserved WASI File/POSIX.FILE dependency. Full lint
likewise exits 1 for its five documented incomplete semantic roots, with no
remaining rule findings. Focused changed production roots/positive tests pass
-D warnings. The unchanged real jaifmt was rebuilt after the array fix; owned
--check and stdin idempotence pass. All 13 unchanged LSP auto_import tests pass.

Continuation after f9cd1c3: fixed bulk array self-append/interior-view append
across allocator moves, plus overlapping array_copy. A moving allocator poisons
old storage; its original regression failed before implementation and now
passes interpreter/native O0/O2 and production WASI O0/O2. Nonoverlapping
copies retain memcpy and no new public convenience API was introduced.
The suite now has 43 host and 35 supported WASI cases. Current unchanged LSP
auto_import suite passes all 13 tests, resolving the previous alias-signature
documentation failure. A remaining wide-conversion #modify contract gap is
explicitly recorded in the audit/questions rather than hidden by name coverage.

General host/target fix is integrated read-only from NEW compiler sources.
The genuine predicate and Preamble now PASS production WASI O0/O2. All 42
host cases pass interpreter/native O0/O2; all 34 supported WASI cases pass both
levels, including exact status-1 misuse. Six native unused-code targets pass;
WASI unused-code still FAILS the independent File/POSIX.FILE producer dependency.
Shortest float intervals/minimality all 2300 cases pass in native/WASI O0/O2.

The newer linter now exposes incomplete semantic coverage. Correct library
context requires exact byte-verified paths under the selected staged stdlib,
plus the pending fixture import path; the driver now enforces that identity.
A valid unused allocator test parameter now has a real non-null procedure check.
Shared context owns its inline guard rather than an unused side-effect import.
Full strict lint remains blocked by Windows-only roots on a host-only CLI and
intentional negative/cross-only fixtures; see foundations-lint-request.md.
No blanket suppression, ignored stderr or false lint success is claimed.

## Historical checkpoints

The evidence below records earlier snapshots; current resolutions above
supersede their old blocker/status statements.

Next batch after 841b417: actual version-2 visualization backend replaces the
old text snapshot, with real Shared_Memory_Channel packets, deduplication,
alloc/free history, 500ms connection retry, 250ms update throttling, explicit
frame mode, failed-reservation preservation and reader reconnection. Original
interpreter/native O0/O2 tests validate wire sizes/counts/IDs and queue pressure.
get_capabilities now implements the synchronized name-out ABI and preserves
allocator name storage identity. Preamble native scoping/logger restoration,
reentrancy/exclusions and real first-use indexed debugger initialization pass.
One canonical #add_context flag module serves all Basic configurations.

Latest verification: all 42 host cases pass all three modes; 33 WASI cases pass
both optimization modes. Preamble's additional WASI case FAILS as required by
the current compiler defect: BUILD_OS/BUILD_CPU alias the target, so cross-target
early return never happens. Independent host-target-predicate also fails;
see foundations-preamble-request.md. This is not counted as correct cross
behavior. Real jaifmt CLI/owned check and strict lint pass. All six native target
unused-code checks pass; the independent WASI File/POSIX.FILE failure remains.
No failures/assertions were weakened. Module-qualified leak filters still
diagnose missing source/module mapping. All ordinary owned declaration names
are now present; these remaining behavior/dependency gaps are not completion.
Pending Pool CAPS name-out source reproduces its producer assertion with null
allocator_data. The native Preamble test also proves allocations performed
inside its protected scope are not recursively registered. Native O0/O2 retests
cover that addition and empty-string deduplication/cleanup in the real channel.

Current continuation after cc089d7: newest Basic behavioral sync is implemented
for sequence quoting, hexadecimal byte/newline output, copying consumption,
empty enum ranges/zero field miss, empty logging suppression, scalar predicate
and variadic/clamp guards, allocator ownership, shrinking slice reallocations,
temporary stack strings and exact low-level stack output. Real leak reports now
track baseline/exemptions, scan compiler global segments, combine interior
pointers/cycles, trim/group traces, preserve owned snapshots and release them.
Visualizer mode skips both scans and includes pre-baseline allocations.

37 host interpreter/native O0/O2 and 31 production WASI O0/O2 cases pass after
safe File producer refresh, with real unchanged jaifmt CLI/check and strict lint.
Unknown allocation misuse exits exactly status 1 natively and in production
WASI even with ENABLE_ASSERT false. Windows unused-code dependency was resolved
through read-only NEW platform-io File sources; WASI -no_dce still fails the
producer's POSIX.FILE dependency. Original minimal repro and requests are in
foundations-dependencies.md. No check was weakened; six native target reruns
pass Linux x64/arm64, macOS x64/arm64 and Windows x64/arm64. Actual channel
backend and tests are now being implemented;
old textual visualization is not counted as the reviewed transport.

Continuing all owned Basic scope: sequence/byte output, prefix consumer,
using-member field lookup, reflected enum ranges/highest, slice array_resize,
and all five stack-trace declarations now have real independent implementations.
The expanded 34-case host interpreter/native O0/O2 and 28-case production WASI
O0/O2 suite passes, including six runtime assertion cases, all seven unused-code
targets, unchanged real jaifmt CLI/owned format check and strict lint. No tests
or errors were skipped. Precise pending edge/presentation contracts are in the
questions/deviations docs. Next: real leak-report service and remaining scalar,
allocator and visualization APIs. The NEW Compiler already supplies reviewed
get_runtime_info/global data segments, allowing real global-root scanning.

Stable checkpoint: 9a64f00 contains logging, numeric/enum reflection, original
regressions and the Basic API audit. Actual unchanged NEW producer auto-import
ranking now PASSES: Basic and Math are both found in the required order.
The initial isolated staging lacked Math/used older LSP source; read-only NEW
producer/numerics refresh resolved that dependency. Full auto_import.rs passes
12/13, retaining the failure of print alias signature documentation. General
original facade/helper reproducer and proper compiler/LSP request are recorded
in docs/status/foundations-lsp-request.md; no Rust or peer file was changed.
Latest source-built compiler/jaifmt/lint/core rerun PASSES after refresh:
30 host cases in three modes, 24 WASI cases in two modes, five runtime
assertion cases, strict configuration/visibility rejection gates, and all
seven unused-code targets. Windows target programs are checked, not executed.
The independent alias probe passes interpreter/native O0/O2 and production
WASI O0/O2, plus actual format check/strict lint. Refreshed compiler also passes
the independent 2300-case shortest interval/minimality audit in all four modes.
The alias probe is now an explicit interpreter gate in the owned runner, and
its facade/helper/probe files are included in the owned format/lint inventory.

Current Basic public-surface batch: both log overloads and both log_error
overloads now dispatch real formatted messages through the active logger,
preserving caller/explicit location, source identifier, data, section identity,
flags and user flags. Added integer range/saturating clamping and three enum
reflection helpers with width-correct values and canonical reflected views.
Original missing-export tests first rejected, then pass. No legacy expectations
or tool sources were changed. Public surface audit: docs/foundations-api-audit.md.

Verification completed: all 30 positive interpreter/native O0/O2 cases and
24 supported production WASI O0/O2 cases pass; unchanged real jaifmt rebuild,
CLI/idempotence/owned --check and source-built jailint -D warnings pass. Cross
target checks pass Linux x64/arm64, macOS x64/arm64, Windows x64/arm64 and
WASM64 after read-only refresh of safe producer bindings. This resolves the
previous macOS x64 itimerval binding blocker without a local binding patch.
Actual auto-import/corpus CI remains coordinator verification. Logging policy
and precise remaining helper contracts are recorded rather than fabricated.

Verified numeric follow-up: exact normal powers of two have asymmetric
rounding intervals, and nearest-decimal-only shortest search could emit one
extra significant digit. Original float64 2^-1017 / float32 2^-96 regressions
failed, then passed after trying the decimal ceiling at the same precision.
An independent Fraction-based audit verified all 2300 normal IEEE power-of-two
intervals and minimal significant precision in native O0/O2 and production
WASI O0/O2. No reference implementation is involved. The final ordinary
27-case interpreter/native and 21-case production WASI suite passes against
this correction, including real tool/lint and strict parameter rejection gates.
Affected unused-code checks pass all six independently supported targets;
macOS x64 retains the previously recorded binding blocker.

Current implementation checkpoints: 44cca8b (portable conversion/configuration)
and a11c0c8 (five-parameter debugger interface/direct binary32 rounding), followed
by 1b1cb39 (native-path safety, private helpers, canaries and strict argument gates).
All 26 positive cases pass interpreter/native O0/O2; five runtime rejection
cases assert as required; all 21 supported production WASI cases pass O0/O2
with non-WASI imports rejected. Real unchanged jaifmt builds at O2, its CLI
and owned --check pass, and scoped source-built jailint -D warnings passes.
Latest default/custom debugger tests include real heap allocation/destruction,
failed resize preservation, mixed-configuration address reuse and frame counts.

Unused-module-interface rejection is now fixed in NEW producer sources and
passes the required gate; valid default/custom interfaces still pass.
Unknown parameters are now rejected for system/stdlib and headerless modules
through general NEW producer validation. Both required rejection tests return
the expected exact-argument diagnostics. Current library declares exactly the
reviewed constraints/parameters; no Basic-specific substitute check is added.
Six targets pass unused-code checks including every newly affected case.
macOS x64 retains the peer POSIX itimerval blocker. No target was disabled.
NEW producer interface validation has now landed; own source rebuild/retest is
in progress. A related forbidden compatibility bypass remains in modules.rs:
unknown parameter rejection is exempted for system/stdlib modules. Original
negative/basic-unknown-parameter supplies an undeclared flag to real Basic.
Required general fix: validate exact declared named/positional arguments for
every module, with no system-module/name/path exemptions; reject arguments for
modules that declare no parameters too. Keep first/program parameter semantics.
No Basic-specific workaround or invented parameter will be added here.
Producer now contains general exact-argument validation after module
declarations, without the system-module exemption. Rebuilding read-only copies
and retesting unknown stdlib/headerless parameters before claiming resolved.
Additional owned filesystem regression found POSIX embedded-NUL paths acted
on their valid prefix; shared native-path validation now rejects them before
query/copy/rename/traversal/cwd calls. Sentinel content/cwd preservation test
passes initially; full host and cross checks follow.

Final run: all 27 host cases and all 21 supported production WASI cases pass,
including required interface/unknown-argument rejection gates. Real unchanged
jaifmt O2 build/CLI/check and source-built jailint -D warnings pass. Affected
unused-code cases pass Linux x64/arm64, macOS arm64, Windows x64/arm64 and wasm64;
macOS x64 still fails peer POSIX itimerval. No peer writes, reference input,
stdlib/Extensions changes or publication occurred.

Next: coordinator can integrate reviewed checkpoints and rerun full corpus/native
CI; binding owner must resolve macOS x64 itimerval, with Windows runtime still
pending. New helper visibility is now
module-private, and original canary tests fill/grow inline storage in both
assert layouts, including combined debug/stamping/discard configuration. Remaining
formatter/style/visualizer contract questions stay in the focused questions;
Windows runtime and final corpus/release verification remain coordinator-owned.

## Prior milestones and failure evidence

Current committed checkpoints: 9d2c6bd, 2db13bf (formatter and original tests).

Active work: reviewed Basic configuration propagation, enabled/disabled builder
layout and assert discard, temporary-storage stamping, generic type-name default
elision, and production portable float formatting/parsing for WASM.

New tests: basic-configuration and wasm-basic-minimal. First verify the current
failures, then implement. NEW integration-clean request confirms unavailable
localeconv/snprintf/strtod imports; no quarantined integration source is used.

Plan: exact binary/decimal conversion with private arbitrary-precision integers,
shared by formatting and parsing on all targets, avoiding native env imports.
Retain existing public format semantics and compare original boundary vectors
in interpreter/native O0/O2/WASM. Refresh only NEW producer compiler sources in
durable own staging. Keep unchanged real jaifmt and warnings-denied scoped lint.

Milestones: Basic default/on/off propagation and discard pass; portable float
formatting runs in production WASI without env imports; exact parser boundary
vectors pass. Refreshed NEW compiler now supplies generic parameter defaults;
real default-elision/type-name regressions pass, including dependent defaults.
Temporary stamping on/off and pre-free overflow payload checks pass.

New compiler blocker: refreshed compiler panics building unchanged real jaifmt
at lower.rs:236 `context storage`. Stack goes through check_expr_no_emit,
arg_cost, emit_call_inner. Minimal original reproducer:
tests/portable-stdlib/pending/context-overload-probe.jai. Scratch FnCtx creation
sets `context` directly without initializing the new context slot; proper
general fix must initialize all scratch/lambda/struct contexts through the
context-state API, not special-case Basic/jaifmt. Compiler ownership requested.
No producer Rust or peer checkout is modified. Previous real jaifmt remains
available for scoped formatting, but no successful latest build is claimed.
Producer now contains the general context-slot initialization repair in all
three identified sites. Copying NEW Rust sources read-only and rebuilding in
own durable staging; next step is rerun the minimal reproducer, actual real
jaifmt build, lint and full host/WASI suite before claiming this resolved.
Retest: minimal reproducer passes; unchanged real jaifmt/main.jai builds at O2;
its CLI checks and scoped --check pass; source-built jailint -D warnings passes
the exact owned inventory including new numeric/configuration sources and tests.
The compiler context regression is resolved through NEW producer sources.
Host interpreter/native O0/O2 has passed the enabled/disabled Basic configuration
and temporary stamping cases; full numeric/property/WASI run continues.
Completed: all 24 positive host cases passed interpreter/native O0/O2; five
invalid formatter/ensured-range cases asserted in all three modes. All 19
supported production WASI cases passed O0/O2 with only real WASI imports.
Includes numeric boundary/property tests, generic defaults, both assert layouts
and discard behavior, and temporary overwrite on/off/overflow freeing.
Real jaifmt build/CLI/check and scoped warnings-denied jailint pass. Cross-target
unused-code verification and reviewed checkpoint commit are next.
Unused-code results: Linux x64/arm64, macOS arm64, Windows x64/arm64 and wasm64
pass with all new cases. Refreshed bindings resolved the previous ipc_perm
error, but macOS x64 now fails POSIX p_realtimer: unknown itimerval (line3422).
Runner retains overall failure and continues independent targets. This matches
the NEW integration-clean request; no binding layout is guessed or edited.

Memory_Debugger_Interface defining shape still absent; no invented replacement
interface will be added. Enabled debugger configuration must diagnose this
remaining unsupported contract rather than silently ignore it.
Latest spec synchronization now supplies the four inline interface hooks and
default sentinel selection. This resolves the interface-shape question. Next
batch implements the exact fifth parameter and real debugger notification
routing; the current explicit unsupported guard will be removed, not retained
as a stale contract gap.
Exact five parameters now propagate through the public/private modules and a
single canonical four-hook interface declaration. Custom replacement alias
identity and real allocation/reallocation/free/heap notifications pass initial
tests. Default debugger has real allocator ownership/live allocation records,
synchronized updates, and visualization-on/off frame counters/logger snapshots;
default production WASI runs with no env imports. No unsupported-interface guard
remains. Memory debugger/heap support is now being expanded in the owned runner.

New general compiler request: $I/interface constraints on module parameters
are accepted without structural validation when the parameter is unused. Own
pending/module-interface-constraint.jai with -I tests/portable-stdlib/pending
currently succeeds for Broken with no run method. Required: validate all
declared interface members/signatures during parameter binding, preserving
normal lazy body checking; no Basic-specific assertions or API weakening.
All 26 host cases now pass interpreter/native O0/O2 and all 21 supported
production WASI cases pass O0/O2, including real heap state/block allocation
and default/custom debug notification, ownership diagnostics and visualization
flag effects. Real unchanged jaifmt build/CLI/check and warnings-denied scoped
jailint pass. The general unused-interface rejection is now a required runner
gate: current compiler wrongly accepts it, so no overall full-pass claim.
Compiler declaration site: sema/modules.rs declare_module_parameter strips
poly type syntax; retain/evaluate its interface constraint against each provided
or default value, including type-valued struct interfaces, before body use.
