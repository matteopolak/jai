# Iprof/Codex workflow progress

Latest replay uses approved compiler59a69c03 including b0430110. INDEX editing
is resolved: modules-disabled real profiler CLI builds and execution pass at
native Mac O0/O2. Actual edited main also runs in the compiler interpreter via
the public child-workspace plugin lifecycle and #run. Two native -modules builds
still fail on unnamed member-body ownership; inferred enum printing remains a
separately reduced prerequisite. Iprof.message stays partial. All other owned
public APIs retain their verified production implementation.

The dependency snapshot contains byte-identical owned sources and approved
compiler-owned API sources; --stdlib selects it without editing peers or
canonical other-owner modules. The runner verifies owned byte identity before
using that snapshot. The latest precise reductions, commands, generated-code
inspection and integration requirements are in the
[compiler handoff](profiler-codex-compiler-handoff.md).
Earlier checkpoint-specific evidence below is historical where superseded.

This supersedes the records-only audit at 4fe1e621. The synchronized module
contracts are now the oracle; the earlier broad synchronization requests are
resolved. Every reviewed public callable has a production body; the remaining
Iprof automatic-instrumentation gap is a precise compiler editing dependency.

## Implemented workflows

Iprof now records native monotonic zone ticks, propagates self ticks through
distinct zones on each stack chain, calibrates counter rates, updates node
trackers and per-zone rings, and produces real flat/call-graph reports from
temporary_allocator. History stores second moments, seeds the first three
observations, and retains ring cells on clear. Public node/hash helpers follow
the reviewed declared-hash-plus-parent formula, insertion/reset behavior and
persistent-node lifetime. Automatic zones defer their exit and honor a shared
private per-context runtime guard. Report-mode, cursor, frame and selection
operations operate on measured rows. Reports and their highlevel pointers
expire when temporary storage is reset.

The refined report contract places Report_Row times in milliseconds.
Writers now consume those values directly; original owned writer fixtures were
updated to use milliseconds rather than the superseded seconds assumption.
Threshold units are interpreted in the same units as their compared row fields.
The latest refinement confirms these millisecond threshold units.

Codex now has all listed public function names and overloads: typed metrics,
scalar/string helpers, checked v2 reader, dump_file, plugin creation/options,
message collection, communication, final serialization and shutdown. The real
CLI +Codex workflow exports actual compiler file/import/body messages in
received order, replaces duplicate body identities, serializes the canonical
record layouts, patches canonical s16 relative strings in the finished buffer,
and writes the file. Generation timestamps come from the real host clock.
Unknown revision/reserved fields are initialized; the optimization tag remains
non-authoritative because Build_Options supplies no Optimization_Type value.

The reader validates counts, inline string targets/terminators, record indices
and bounds before exposing borrowed views. This is intentional safe behavior
in malformed-input areas where the reviewed implementation establishes no
compatibility guarantee. Generic string get returns a valid count rather than
reproducing the documented missing-count bug. get_short_string honors allocate:
true copies, false borrows. Its source naming mismatch leaves that behavior
unspecified; this independent policy remains explicit.

The new Basic facade forwards its public allocators to internal/basic.
Original real compiler-message evidence showed alloc/realloc/free/copy_string
headers owned by that canonical producer module. Metrics recognize the exact
reviewed public name set in Basic and that independently authored owner,
rather than returning zero for these real public Basic calls.

## Verification and limits

The focused runner has executed the real +Codex child at native Mac O0/O2,
then checked its actual v2 output in interpreter/native O0/O2. It verifies
conditional score/depth, allocation/free counts, source spans and every
truncated prefix of the resulting 10 KiB file. Existing profiler/metrics tests
and new frame/automatic-zone tests passed interpreter/native O0/O2.

Unchanged repository jaifmt builds from source and checks owned formatting.
Strict lint passes the new program fixtures and full scoped module roots with
the approved general context-ordering fix. These checks have no exclusions or
warning suppression. The required automatic-module workflow remains visibly
failing on the newly exposed general editing errors described below.

Use only the assigned Cargo target:
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target`.
All source and authoritative test output stay in this local worktree.
No peer implementation, bootstrap, shared dependency manifest or Extensions
source was changed.

## General compiler/linter request

The original module-root Context reproduction passes with the authorized
compiler-owner context-ordering fix e9affab7. The exact approved NEW checkpoint
114dda87 includes that fix and now also exposes ordinary called library bodies.
Its original Basic.alloc interception probe passes. Compiler sources are built
unchanged in an owned local snapshot using the assigned external target.

Current editing failures and original reductions are documented in the
[compiler handoff](profiler-codex-compiler-handoff.md). No module-specific
compiler bypass or alternative fake context is supplied.

## Automatic instrumentation, hooks and renderer checkpoint

Every reviewed public callable name now has a production implementation:
52 Iprof names and 17 Codex names (overloads and conditional forms coalesced).
The current owned inventory covers139 public names /144 declaration variants;
Iprof.message remains partial at the producer editing boundary described
below; its implementation and -modules parser are present.

Iprof's real CLI plugin uses canonical compiler callbacks and typed records,
prepends deferred zone scopes with public AST editing/printing, marks generated
helpers live, and inserts zone initialization during TYPECHECKED_ALL_WE_CAN.
Entry selection uses configured entry_point_name as well as explicit flags.
The minimum size uses the compiler's actual Typechecked.subexpressions count.
A boundary regression compiles native O0/O2 children at exactly that count and
one above it; the leaf is included only at the inclusive boundary. The entry
point is always retained. Early returns run zone_end before final reporting.

add_hook forwards caller parameter and argument text into real compiler-added
wrappers. Tests execute both native child levels, verify11 callback effects
and Unicode filename / line+1 forwarding. The standard per-frame/editor wrappers
are generated at the late phase. The reviewed private configuration fields are
not reachable through the canonical public plugin base, so those default
optional wrappers have no client call. No public setter, cast or option is
invented for the unavailable private configuration.

Basic exclusions now match the reviewed temporary_allocator_proc and IsScalar
names. Canonical independent producer implementation modules are recognized as
their facade owners when applying exclusions. Imported user modules are
instrumented with direct context._Iprof guarded macro calls; their measured
CSV rows appeared only with -modules on the earlier e9affab7 producer. The
114dda87 producer exposes called Basic bodies, but editing those and anonymous
member bodies fails in the canonical compiler API. No body is reconstructed
or filtered out to hide that failure.

The GUI Config uses canonical Math vectors and all reviewed defaults.
draw renders actual report rows via client callbacks; draw_graph renders actual
zone/frame histories, cursor markers and animated scales. Default callbacks
emit the specified unset diagnostics. History-disabled configurations show an
explicit disabled-history label and continue rendering current report rows.
Graphics exports and Zone_History obey their reviewed module conditions.
Runtime/drawing/reporting guards prevent automatic callback instrumentation
from mutating profiler structures while those structures are consumed.

Node and tracker allocation now uses the canonical persistent Pool, with a
captured default backing allocator. Raw timing, recursive aggregation and
temporary-storage reset regressions verify actual lifetime and effects.
Public zone_infos metadata survives private plugin shutdown until the next
successful session replaces it using its recorded owner. Concurrent instances
of one configured module are rejected; serial sessions are verified. The
reviewed interface does not specify concurrent plugin-instance policy.

Codex now serializes num_expressions directly from compiler metadata, rather
than recounting a tree that omits the body root. The lifecycle test checks exact
agreement. Conditionals distinguish braced nesting from else-if chains using
public source spans; real compiler fixtures cover ordinary, chained, ifx,
switch/case rounding and static forms. All six short-count types, sticky
errors, owned/borrowed payloads and empty destination failure are exercised.
Explicit empty export paths are not silently replaced by default output names.

## Remaining integration work and verification limits

The authoritative local command/outcome report is
target/profiler-codex-checks.json. It records source hashes, actual exits and
outputs; complete remains false while a required check fails. All source,
reports and Git state are local. Only Cargo output uses the assigned T7 target.

The full scoped runner retains its strict module-root checks. The private
runtime guard now uses real macro getter/setter expansions from one canonical
context module. This gives the import an actual role, passes unused-import
lint, and ensures the guard itself has no automatically instrumentable runtime
procedure boundary. Generated client setup still references the same field.
No marker-only import use or diagnostic suppression is added.

With114dda87, the original Basic body interception probe passes. Real automatic
module builds expose two compiler-owned failures: exported anonymous struct
member bodies lack modifiable ownership, and unchanged Basic.alloc cannot
round-trip its enum argument through Program_Print. The strengthened main input
also exposes invalid printed index syntax `(memory [] 0)` even without
`-modules`. Original independent member, enum-call and indexed-body reductions
are in tests/developer-tools/compiler-requests and the compiler handoff.
Required O0/O2 workflow failures stay failures. The runner exits nonzero after
continuing independent checks; it never executes a stale child after a failed
build. These remain producer dependencies of Iprof.message; other runtime,
reporting, graphics and hook workflows are independently tested.

Codex's lifecycle fixture now checks serialized procedure count against the
exact unique body pointers received from the canonical compiler stream, instead
of assuming the former three main-only bodies. It delivers each message twice
to retain the duplicate-identity regression. This accommodates the corrected
producer while strengthening exact export completeness verification.

Native Windows/Linux remain later execution requirements. Existing target
checks are source-only evidence. This checkpoint does not expand optional
platform, profile or performance matrices.

Shared tooling integration must replace two obsolete expected Codex metric
rejections with the positive reviewed behavior tests. The other tooling owner's
runner is not edited here.

## Verified checkpoint c6a1c083

The114dda87 replay reached all189 recorded commands. All21 cases passed the
interpreter and native Mac O0/O2; actual hook and size-boundary children, all16
configuration children, both independent native C wire-consumer checks, owned
format checks and full module-root warnings-denied lint passed. Six intentional
option/scalar rejection commands matched their required diagnostics. Four
required automatic CLI builds failed (O0/O2 with modules on/off), so the final
runner exit is1 and complete=false. No failed command is counted as completed
functionality. Native Windows/Linux remain pending; their existing checks are
source-only. Original failure reductions were formatted and replayed separately.

The owned inventory remains138 complete/1partial/0missing public names out of139.
The sole partial name is Iprof.message at the exact compiler editing boundaries
above; Codex has no remaining identified API gap. All52 Iprof and17 Codex public
callable names have real production bodies. No public behavioral contract is
currently blocking other owned implementation work. Compiler-owner corrections
are needed before automatic instrumentation can complete its required module
and general indexed-body workflow replay.
