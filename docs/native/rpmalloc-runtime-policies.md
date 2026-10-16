# Private rpmalloc runtime policy boundary

The reviewed public records retain their exact field order and conditional
layout. The facade owns public Heap/Span objects; SDK calls use private native
objects. Neither equal record sizes nor a public pointer is an ABI identity.

The retained-span policy now routes actual POSIX `madvise` calls through the
private unmap adapter. DONTNEED and FREE select their exact native values for
partial decommit. Full release and caller-provided unmap callbacks keep their
existing native ownership route. A rejected kernel request reports the actual
error through the configured callback without trying a different advice.
Mac ARM64 immutable receipt `advice-le_lze7v` passes both native optimization
levels, six desktop source targets, strict context lint and formatting. It also
checks that the effective SDK span-map count reaches the module-owned public
configuration. This is not native Linux/Windows evidence.

## Numeric dimensions

Positive HEAP_ARRAY_SIZE, DEFAULT_SPAN_MAP_COUNT and GLOBAL_CACHE_MULTIPLIER
are reviewed public module parameters. A finite list of native builds cannot
cover that domain. The adapter therefore keeps their values as private runtime
configuration of an existing native storage/ABI domain. The first controls the
heap lookup table, the second the SDK fallback batch, and the third actual
global span-pointer capacity. No public fields or parameters are added.

The conditional `sdk-runtime-dimensions.patch` changes only private heap bucket
and global span-pointer arrays into allocated storage, calls the adapter's
transactional preparation before SDK initialization, adjusts table clearing,
and makes failed-init finalize safe. Without the private runtime macro the
pinned SDK preserves its original arrays and initialization. Public SDK
function signatures and Heap/Span storage types remain unchanged. Patch and
original input SHA-256 values are enforced in `prepare_rpmalloc.py`; preparation
writes the exact bytes it verified. Independently prepared output hashes must
match. The page-granularity repair remains separately pinned.

Preparation checks native count/byte representability and obtains all new
storage before publishing it. A failure returns ENOMEM and preserves old active
dimensions/storage; it cannot change a running allocator. A successful later
initialization frees/replaces the previous drained tables. Typed domains now
release drained tables at domain retirement, after outstanding thread-slot
references are released. Per-initialization metadata allocation/copy costs are
explicit; there is no performance claim.

Unrepresentable huge positive parameters fail with ENOMEM at initialization as
an independent resource policy, rather than a new compile-time numeric range
or a promised original failure mode. Native span counts/cache counts are
32-bit and mapping bytes must fit size_t. The former simultaneous-import EINVAL
restriction was a compatibility defect, superseded by the reviewed independent
module-instance contract and the typed domain implementation below. Private ABI
version7 rejects stale native bridge artifacts before ownership mutation.

Removal plan: replace the conditional SDK preparation patch with an upstream
SDK storage/configuration extension when one offers equivalent transactional
tables and capacities without changing public compatibility shapes. Keep pin
verification, independent SDK storage probes and public ownership/rollback
tests through that migration. Do not remove the patch by silently reverting
nondefault module parameters to native defaults.

## Independent module domains and live configuration

Each public instance supplies its nominal rpmalloc_config_t Type to a private
rpmalloc-domain module. Exact repeated imports share that type and storage;
different argument lists, including an explicitly supplied default, retain
separate typed state. Code and native ABI profiles remain shared. There is no
address-keyed public-object registry, new public field, or per-numeric-value
library matrix.

The generated sdk-domains.patch moves the pinned SDK's complete35 mutable
global families, conditionally including statistics/cache fields and Windows
FLS, into the private Domain. A separate generator audits the official C AST
under five host conditional configurations and rejects unowned mutable native
state. Native heap/span types remain the actual SDK types; public Heap/Span
values still use the canonical ownership adapter. Domains also own callback
mapping records, native sizing/policy, leases and facade graph metadata.

Per-thread typed slots retain Domain references and the actual native thread
heap. Explicit thread finalization releases the heap association; finalization
retires the instance independently while another instance remains usable.
Generation checks invalidate inactive thread associations, and metadata stays
alive until its last reference exits. POSIX key creation and initializer slot
reservation return failure transactionally; later graph/default-thread metadata
OOM remains an explicit fail-fast limitation. No graph-wide rollback is claimed.

Windows uses a private FLS slot as its sole attached-slot owner, with a separate
pending list before attachment/after explicit stop. FLS callbacks select the
exact passed slot, including callbacks invoked by FlsFree for another fiber;
global finalization retires metadata without finalizing already freed SDK heaps.
This follows the official [FlsFree contract](https://learn.microsoft.com/en-us/windows/win32/api/fibersapi/nf-fibersapi-flsfree).
Windows native execution is still required; desktop Jai source checks cannot
verify this C/OS lifecycle.

The copied public configuration now exposes callable typed default map/unmap
procedures whenever either input member is missing. Error/failure callbacks
remain null by default; names remain empty. Fixed private SDK thunks read the
current instance's public callbacks at each use, preserving caller context and
the native mapping offset bookkeeping. Later sizing writes do not reconfigure
derived native sizes. Callers remain responsible for compatible callback pairs,
backing storage lifetime and avoiding concurrent mutation.

The independently pinned sdk-live-config.patch obtains an owned NUL copy from
the current name provider at each Linux/Android native naming operation and
frees that copy afterward. Host probes exercise the same provider, including
borrowed-byte mutation, but do not establish Linux kernel naming behavior.
Replacing either SDK patch requires an equivalent upstream instance/config
extension and the same independent ownership, callback and storage checks.

Per-heap reserve is min(effective mapping batch, DEFAULT_SPAN_MAP_COUNT).
Surplus can enter the separate global reserve; there is no global reserve cap.
Independent actual SDK probes test both derived limits and surplus storage.

Historical receipts below retain their original scope. They are not evidence
for the newly reviewed live-field or simultaneous-instance contracts. Current
domain/live-config receipts are recorded in bindings-shared-audit.json.

Numeric receipt `dimensions-4_e_f222` passes all32 rows, including two separately
prepared SDK output identities, actual private storage/capacity probes, public
interpreter/native O0/O2, SDK/Jai address+undefined sanitizers, six desktop source
targets, strict lint/format and immutable source/SDK hashes. The SDK probe
redirects first/second metadata requests to real libc overflowing `calloc`
requests, checks actual null/ENOMEM, retained old tables/dimensions and recovery.
Its `-fno-builtin-calloc` flag preserves the observed failure call: an independent
LLVM23 standalone C reduction demonstrates that a builtin otherwise eliminates
the unused failing allocation and invalidates errno observation. Production
allocators use normal compiler options; no production exception is added.
Other native platforms remain unverified. Graph metadata OOM transactionality
remains separate work; the default-thread/graph adapter still reports and aborts
on metadata exhaustion. Do not confuse successful transactional table/handle
reservation tests with a graph-wide OOM guarantee.

## Retention, Linux discovery and adaptive accounting

The separately hash-pinned `sdk-runtime-policies.patch` selects unlimited cache
overflow and default OS unmap policy at runtime within the existing private
SDK domains. Caller-provided unmap callbacks retain their actual SDK route.
Disabled default OS unmapping deliberately retains those mappings even through
finalization; it is not an allocator leak repair or a promise to reclaim them.
Native SDK accounting retains its own semantics, distinct from kernel residency.
The independent C probe observes and forwards actual munmap calls. With the
same 320 allocations it sees220 early releases for bounded caching, 0 for
unlimited caching (release at finalization), and 0 total releases with unmapping
disabled. Public cache counters change consistently; no statistics are cached
or invented by the facade. Receipt `dimensions-4udni0zt` passes 71 rows, including
original public callback/name/context/concurrency and configurable regressions.

For Linux, the patch gates automatic `/proc/meminfo` inspection by the reviewed
LINUX_HUGE_PAGES option. Explicit page sizes bypass discovery. It uses ordinary
mmap flags and does not request MAP_HUGETLB or retry a failed huge mapping with
different flags. Effective SDK page/span/map/huge values reach public config
storage. These Linux bodies have source evidence; actual Linux execution and
failure probes remain required. Mac native tests establish only that the Linux
option leaves Mac discovery policy unchanged.

Statistics already supplies native span current/high accounting. Adaptive plus
statistics-off requires an actual native layout with that accounting present;
the generator adds only those required storage identities, preserving every
existing default native name. 120 possible domains are described; this is not
120 native executions. The three required domains used by the adaptive fixture
are built and tested. Public Heap/Span_Use remain canonical spec-derived records,
copied from actual native fields. `no-thread-asyj6j4f` passes 26 rows including
all 63 SDK current/high comparisons, public size, raw/rewrite/statistics variants,
interpreter/O0/O2/sanitizers, six desktop source targets, lint/format.

Removal plan for the policy patch is an upstream SDK runtime-policy extension
that preserves these exact branch semantics. Keep actual OS/callback/failure
and statistics tests; replacing it with the vendor platform-preferred advice,
MAP_HUGETLB fallback or default retention would regress reviewed behavior.
The obsolete public-body configuration predicate has been removed. Verification
and metadata-OOM limitations are recorded per API instead of hiding supported
procedures behind a conservative whole-module condition.
