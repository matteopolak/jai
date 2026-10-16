# rpmalloc metadata reservation and failure behavior

Private ABI8 replaces graph/default-thread metadata OOM aborts on valid allocator
lifecycles. Public records, procedure signatures, canonical identities and native
heap/span layouts are unchanged. A stale ABI7 helper is rejected before mutation;
integration must rebuild matching helpers before its combined runtime batch.

The actual pinned SDK creates heaps in pools and maps normal/huge/aligned spans.
The independently generated sixth SDK patch reserves typed HeapView/SpanView
capacity before those ownership transitions. Heap reservations precede consuming
global reserve spans or mapping a new heap pool. All four native mapping sites
reserve span capacity before invoking the real mapping path. Failed metadata
allocation cancels the reservation, preserves existing capacity, sets ENOMEM and
lets the SDK/public failure path return null or failed initialization. It does
not invoke a fake SDK result or migrate an existing allocation.

Successful mappings bind all potential physical span headers to their reserved
typed views without reading uninitialized headers. Successful heap creation binds
all actual native heaps after initialization. This retains capacity for currently
unused reserve/cache headers that can later become observable without another
mapping. Publication therefore allocates nothing and cannot expose an incomplete
graph because a late metadata allocation failed.

Full native unmap retires the backing associations, including failed-initialization
cleanup before the regular unmap adapter is installed. Partial retained-page
advice invalidates observations but keeps the mapping's header capacity. Quiescent
retirement returns typed nodes to reusable pools. Chunks retain peak metadata
capacity until instance finalization; there is no per-numeric-value library matrix,
public-object address registry or stale cached statistic. Earlier graph copying
costs remain, and reserving heap-pool metadata earlier increases startup memory
pressure. No performance claim or benchmark is made.

Each public operation supplies a stack-owned private scope. A thread without a
persistent SDK heap can perform actual cross-thread free/read operations without
allocating a TLS association. Thread initialization promotes that borrowed scope
to an owned persistent slot; slot or OS-key failure leaves the thread uninitialized
with ENOMEM and permits retry. Redirects preserve nested scope identity through
promotion. Typed references protect independent domains and nested finalization.
The private scope protocol is asserted as 80 bytes in Jai and C, with native Mac
ARM64 execution and full Mac x64 C source checks. Windows FLS and Linux native
execution remain required; six-desktop Jai checks are source evidence only.

Capability queries run before allocator-domain setup and require no metadata.
Global/thread initialization and teardown must still follow the reviewed lifecycle;
this does not define arbitrary operations on an uninitialized or finalized heap.
Private pool-exhaustion assertions now diagnose an implementation invariant breach,
not a recoverable metadata allocation path. Factory, table, graph-capacity and
persistent-slot allocation failures have actual failure/retry controls.

The diagnostic builder path also now leaves the correct operation scope before
formatting its immutable counter capture. Capture OOM sets builder.failed and
preserves existing stored bytes/length. Formatting can grow a builder using the
same allocator without retaining the native lease. Native fault tests use real
libc overflow rejection. A separate native-only Darwin observer exercises public
initialization, allocation/realloc preservation, thread handoff and capture errors;
its private fixture DSO is built at the recorded test path, not distributed as a
relocatable SDK package. Interpreter fault injection is excluded because its main
image belongs to the compiler; ordinary interpreter regressions remain active.
C address/undefined sanitizers independently exercise metadata failures and retry.

The original graph OOM red and subsequent probe/fixture setup failures are retained
in own T7 receipts. Two new test assumptions were corrected: foreign frees can be
deferred until owner-thread finalization, and failed-builder string conversion
does not establish preserved-text access. Actual mapped accounting after draining
and direct stored-byte/length assertions remain active.

The pinned patch is reproduced with zero fuzz and independently regenerated from
the official C source. Its removal requires an upstream ownership/reservation hook
with equivalent failure guarantees, retaining independent SDK ABI, native OOM,
callback, concurrency, lifetime, public identity and privacy tests. Current exact
receipts and ready file hashes are in bindings-shared-audit.json. This is not a
full corpus or other-platform native completion claim.
