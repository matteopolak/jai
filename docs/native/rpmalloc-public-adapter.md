# Public rpmalloc adapter progress

Raw heap follow-up: eleven raw SDK-backed procedures and nine exact aliases now
execute through their own reviewed public mirror, with actual atomic members
and typed SDK ownership. `configure_rpmalloc.py` supplies the missing source
profile privately; it does not change the public import parameters/default
contract. Raw reflection/alias identity, allocation/calloc, reallocation,
callback-context/lifetime/failure and thread handoff all execute. The independent
raw ABI program checks every reviewed field offset/width and 2,027 native
counters. Six desktop source configurations and both Mac CPUs pass; native
Windows/Linux remains outstanding. Ledger: 3 unresolved and 77 partial rpmalloc
declarations; eighteen configuration-name failures still need generic/dump APIs.
See the [explicit raw profile](rpmalloc-raw-heap-plan.md) for setup and limitations.

The canonical heap and native configurable mapping milestones are committed
as `7fedc8e` and `bc597af`. All eleven rewrite heap procedures have real typed
SDK forwarding and separate complete public records. The public configurable
heap program exposed a pristine SDK page-rounding defect; a hash-checked
build-only C fix preserves the requested public profile and active native
assertions. See the [heap design and verification commands](rpmalloc-heap-adapter-design.md).
Eight actual Mac executions and the separate production-host scope pass;
six public-inventory and eighteen configuration-name failures remain required.

## Canonical heap implementation

All eleven rewrite heap procedures now execute through the canonical C adapter
for both supported statistics profiles. Public Heap/Span records are complete,
separate allocations with exact reviewed layouts; private typed SDK handles
carry native ownership. Real native counters and defined live/cache/reserve
graphs are marshalled, ordinary current-heap allocation stays synchronized,
and native unmap events retire associations. No equal-size public/native cast
is used. See the [implemented design and limits](rpmalloc-heap-adapter-design.md).

New public programs verify allocation/free/realloc, old bytes on failure,
alignment, free-all, current heap, cross-profile ownership, bidirectional thread
handoff, matching free after release, and a callback waiting for four threads
that free on its paused heap. Private probes check 66 public layout fields,
both statistics variants and all 2,027 real native span/size counters. Host
ASan/UBSan covers repeated map/unmap/reuse and genuine acquisition failure.
Native SDK/storage ABI assertions remain active and separate from public tests.

The ledger now retains 23 unresolved and 57 partial rpmalloc entries. Remaining
unresolved entries are the generic allocator procedure, two rewrite dump
variants and twenty raw first-class heap names/views. All eighteen configuration
public-name failures remain required, despite passing declaration checks.
Direct metadata writeback, inactive-field policies, metadata OOM handling,
other native options and unavailable native desktop executions remain explicit
limits. The sections below describe previous checkpoints where superseded.

## Current supported raw/rewrite profiles

The latest user steering authorizes a private raw default-zero policy because
FIRST_CLASS_HEAPS is genuinely absent from the reviewed parameter declarations.
This follows the official C default as an independent implementation choice,
not a reference guarantee. No public parameter was added. Raw heap functions
remain conditional and unfinished. Unlabeled raw heap procedure views now also
retain that condition; they are not unconditional raw exports.

Real raw lifecycle/allocation/statistics wrappers now share a private boundary
with the rewrite facade. Raw calloc, aligned calloc, checked POSIX alignment,
memalign, collection, native statistics-file output and linker reference are
forwarded. The collect/linker-reference SDK bodies are empty upstream; this
forwarding implies no additional behavior. Canonical public aliases preserve
the procedure identity and overload set rather than adding duplicate wrappers.

Both ENABLE_STATISTICS values now have genuine compiled SDK implementations.
The disabled profile has separate library and C symbol names, including its
callback adapter and checked alignment helper. Native mixed-profile programs
verify independent allocation ownership, resize preservation and teardown.
Same-profile imports still share one process SDK domain and reject overlapping
initialization. Other native build options remain unsupported implementation
profiles and are not silently ignored.

`config()` now returns mutable module-owned storage with stable pointer identity.
Initialization copies the record and shallow-copies its string pointers exactly
as reviewed. The private C bridge separately owns terminated naming copies.
This does not promise safe concurrent mutation or replacing ownership callbacks
while mappings remain live; further mutation behavior is recorded for review.

Refreshed reviewed contracts supersede the earlier callback tests below:
if either map/unmap partner is missing, BOTH built-ins are selected. Custom map
failure returns null without calling the OS retry callback. Custom offsets
must be in 0..65535; rejected mappings are released through their matching
callback before failure. The registry preserves paired values without choosing
units. Earlier wide/signed-offset, custom-retry and partner-rejection assertions
were incorrect oracles and were replaced with bounded-offset, rejection-cleanup
and built-in fallback tests. Their previous execution remains historical evidence.

Six NEW public programs source-check across six desktop targets and execute
on both Mac CPUs: rewrite allocation, rewrite callbacks, configurable init,
raw allocation, raw callbacks and mixed statistics profiles. They test config
storage identity/shallow payloads, genuine failures, statistics canaries,
matching frees, nested contexts and four real threads. The callback program
also hands caller allocations to workers and frees worker allocations after
their thread finalization. Independent SDK/storage ABI assertions remain active.
New public tests still require independent review.

Current ledger: 34 unresolved and 46 partially implemented rpmalloc entries,
plus 31 declarations. Six inventory views newly resolve through their exact
canonical aliases; profile limitations still prevent completion credit. All
18 configuration failures remain active at unfinished public APIs even though
all 18 declaration configurations now compile. Every public heap/span operation,
generic allocator procedure, rewrite dump builder and other options remain
required work. See the [heap adapter design](rpmalloc-heap-adapter-design.md).

## Historical checkpoints before the refreshed contract

The following describes earlier work and evidence; statements superseded above
are not the current API or implementation policy.

The default rewrite facade now has real lifecycle, allocation and statistics
procedures. The independently authored test imports only `rpmalloc` and `Basic`:
it initializes through the public API, grows ordinary/aligned allocations,
checks preserved bytes, frees in the matching domain, reads real counters with
canaries, and tears down thread/global state. Negative signed-size rejection
is an independent safety boundary, not a claim about unspecified reference
failure details. No native SDK initialization is hidden in this test.

The reviewed contextual rewrite and raw Heap/Span/cache/counter records are generated in
`stdlib/rpmalloc/context.jai`, in exact field order and with conditional fields.
They remain private nominal types. They are not aliases or casts of native
SDK heaps, and heap operations remain unfinished. Raw-only public aliases are
now guarded by USE_RAW; aggregate declarations retain their own shape guards.

The native archive has one verified cache/statistics/assertion profile. These
procedures are emitted only for matching options: HEAP_ARRAY_SIZE 47,
DEFAULT_SPAN_MAP_COUNT 64, GLOBAL_CACHE_MULTIPLIER 8, thread/global caches,
statistics/assertions/argument validation enabled, adaptive/unlimited caches,
huge pages and disabled unmapping off, and DONTNEED advice. Both CONFIGURABLE
settings support configuration through the private callback/name/offset adapter.
Nonmatching options retain missing-implementation diagnostics;
they never silently execute the default archive. The ledger labels these 16
entries **partially_implemented**, not complete across module configurations.

Remaining production work includes raw mode, every heap operation,
allocator-procedure integration, dump builders and
nondefault native profiles. Native errno is not mirrored into the public
variable; its update/thread-storage contract is recorded as unclear. The archive is
process-global; distinct concurrently initialized import instances need proper
isolation before mixed-profile behavior can be claimed. An overlapping import
is rejected with EINVAL before replacing callbacks or touching the active domain;
finalizing the inactive import leaves the owner intact. Public initialization
and finalization require serialized lifecycle use. No raw or heap success is
inferred from these tests.

The private C callback adapter copies naming bytes into its own libc storage,
keeps ordinary Jai callbacks in a copied private config and uses a reusable
thread-local caller-context bridge. Synchronous native calls borrow their active
Jai caller's context and restore the previous pointer on every return, including
nested calls. Native-only callbacks establish a fresh default context. The
initializer's stack/context is never retained after its call. A synchronized owned-map registry retains
the full public offset bits outside the SDK's 32-bit span header; SDK offsets
are zero and full-release callbacks recover the exact original public offset.
The registry interprets no offset units. Allocation and failed initialization
return real failure; retry callbacks can request another map attempt. Partial
unmaps preserve native callback behavior. Map addresses are validated against
the actual span alignment before entering SDK allocation structures.

The callback program executes real four-thread allocation, stack config/name
overwrite, retry and decline, paired-callback rejection, wide and signed offset
round-trips, error routing and all-map release. The separate configurable
program checks actual native page/span/map settings and rejects invalid
power-of-two requests. Both pass natively on both Mac CPUs and source-check on
all six desktop configurations. The production dependency builder and its host
archive also execute the callback program. These are NEW tests derived from
the reviewed contract and independent safety obligations; separate public
contract review remains pending. Existing native SDK field/canary tests remain
active alongside these public tests.

Remaining callback policy review: native errors have no Jai source location;
the current thunk passes its real bridge call site. Exact desired error
provenance remains a question, not a claim of reference equivalence. Context
regressions check caller-added fields and writes, nested restoration, native-only
fresh contexts and actual thread identity on four native threads. The generic
TLS helper also compiles for six C desktop targets. Enter/restore currently add
two small C calls per native operation. The map registry uses a spin lock and
linear range lookup per native map/unmap, with one libc metadata allocation per
map. It adds no work to allocations served by existing spans. Proper
optimization is an indexed interval registry after correctness review.

Verification: `.work/rpmalloc-public-allocation-verification.json` records six
desktop source checks, real macOS x64 and arm64 programs, actual production
formatting, scoped strict lint and regeneration. Windows/Linux source checks
are not native execution. The standard `verify.py --module rpmalloc --runtime`
also discovers this new spec-derived public test alongside the independent
native SDK/layout tests; required missing-public-name checks remain active.
`.work/rpmalloc-public-callbacks-verification.json` records both callback/config
programs across targets/CPUs; `.work/rpmalloc-production-callbacks-verification.json`
records the actual production builder. The scoped standard checkpoint-11
retains six missing-public-name failures (currently config()), alongside 30
passing source, 66 privacy and eight native build/run checks. Counts include
the private SDK program; they are not eight public native programs. Full owned
production formatting and both generators pass in the checkpoint-11 format
report. The initial callback crash remains indexed separately.
The final context-preservation follow-up is checkpoint-12: 30 source passed,
six missing-public-name failures, 96 privacy passed and eight native build/run
checks passed. Complete owned formatting/regeneration pass in checkpoint-12;
both initial context defects remain indexed as failing evidence.
Independent public-contract review remains pending. No inherited stdlib test
oracle is required or reinstated by this change.

The context generator (`rpmalloc_context.py`) consumes complete reviewed prose,
expands shared-width fields and preserves all conditional associations. It
rejects untyped trailing members and changed record families. Raw counter and
span overrides come from the reviewed text, not a native heap cast. Raw caches
precede conditional full spans; rewrite full spans precede caches. Raw default
import remains blocked by the omitted private first-class-heap option. Complete
record generation is not execution evidence or permission to pick a native
default for that missing Jai contract.

The actual source-only SDK main-thread export is now retained and the public
set_main_thread wrapper calls it; both CPU allocation programs exercise that
route. Complete native heap/span storage and 66 field probes are documented in
[heap ABI evidence](rpmalloc-heap-abi.md). This proves private layouts and public
storage separation, not public heap operation completion.
