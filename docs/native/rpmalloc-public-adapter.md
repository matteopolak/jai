# Public rpmalloc adapter progress

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
they never silently execute the default archive. The ledger labels these 15
entries **partially_implemented**, not complete across module configurations.

Remaining production work includes raw mode, every heap operation,
allocator-procedure integration, main-thread tracking, dump builders and
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
