# Canonical heap adapter design

## Implemented canonical boundary

`internal/bindings/rpmalloc-heaps/bridge.c` now owns separate complete public
Heap/Span records and typed private SDK associations. All eleven reviewed
rewrite heap procedures execute real SDK operations for the supported native
profiles, with both statistics settings. Ordinary allocation/free/current-heap
and thread-finalization paths share the same synchronization and publication
boundary, so making a canonical heap current does not bypass its metadata.
SDK heap pointers only reach SDK calls after private association resolution.
Public records retain the generated reviewed layout and reflected names.

The SDK is included unchanged from its verified pinned C source in the adapter
translation unit. This permits actual C atomic loads and checked heap acquisition
without copying an assumed private layout or invoking the SDK acquire function's
unchecked success assumption. Every defined heap scalar/counter and live span
list/cache entry is copied field by field. Heap links resolve to canonical
records of the same live SDK graph. Public layout probes measure all 66 fields
and both statistics profiles; the independent SDK probe compares all 2,027
span/size counters with native atomic reads. Public and native pointers differ.

Native unmap events retire associations before memory is released. Explicit
active-operation leases delay metadata reclamation across paused callbacks;
retired metadata is reclaimed when outstanding operations finish. Association
lifetime follows actual SDK storage lifetime, not a heuristic that an address
still denotes the same object. Heap release ends its ownership lease while
SDK allocations remain freeable through the matching family. Allocator
finalization rejects outstanding adapter operations before destroying storage.
Bare public pointers follow C lifetime rules: no guarantee is made that a
caller can use an invalid retired pointer after storage reuse. Reacquiring a
still-live SDK heap object preserves that object's canonical record identity.

The current consistent-publication strategy serializes public calls per SDK
profile and refreshes the complete live graph. The lease is released before
ordinary Jai callbacks and restored afterwards. Frees during a paused heap
mutation use actual SDK deferred-free primitives and SDK statistics updates;
recursive/concurrent mutation of the same heap is diagnosed. A real four-thread
callback waits for those frees, then completes allocation without deadlock.
Further workers allocate on the explicit heap, finalize their own threads,
and hand allocations back to the caller. No initializer context is retained.

## Open policies and implementation limitations

The refreshed reviewed contract establishes allocator-owned Heap/Span fields:
direct client writes have no supported writeback behavior. API operations
publish real SDK state; direct edits are replaced at the next publication.
Only live, quiescent observations are supported. Current-heap replacement
ends the previous heap handle's lifetime as required by the reviewed contract.

Undefined/inactive native data is normalized safely: unoccupied cache slots
and inactive reserve/orphan links are null; reserve
headers are represented from the actual reserve range; allocation-only fields
of cached/reserved/huge headers that the SDK does not initialize are zero.
This is an independent canonical-view policy, not a reference guarantee or
fabricated statistics. All statistics fields come from actual native counters.
Partial/full list heads retain the required tail-valued prev link. Ownership
queries include only current partial/full/large/huge list membership, tracked
separately from cache/reserve and deferred-free views. is_in_span compares a
live span's mapped range. Neither predicate validates an allocated block start.
Inactive cache contents and inactive reserve links have no public guarantee.

The native header stores huge-allocation page counts in u32. Unrepresentable
requests fail before mapping/reallocation, preserving the old allocation.
Metadata libc allocation failure currently reports an error and aborts;
transactional preallocation/rollback for metadata exhaustion remains required
before claiming graceful failure for every resource path. Linear association
lookup and full graph publication impose real memory/performance costs. The
proper optimization is explicit dirty/lifetime notifications and per-object
publication with consistent native synchronization, not stale cached counters.
Arbitrary allocation reentrancy during SDK pool initialization is not promised;
the SDK itself can hold its native global lock while calling a map provider.
Native Windows/Linux execution and other build profiles remain incomplete.

## Original architectural requirements

This is an independent implementation plan, not completed behavior. The user
authorizes canonical public handles. Generated public records retain exact
nominal names, fields, conditions and dimensions. SDK Heap has the same size
but different offsets; public Span is 96 bytes versus SDK 88. Never forward a
public Heap/Span as a native pointer. Existing native assertions remain active.

Use typed heap and span associations. Each owns its canonical public record,
native handle, allocator domain and lifecycle generation. Validate identity
before C calls; never inspect an arbitrary caller pointer as native metadata.
Public links point to canonical records, preserving cycles and storage identity.
Retire records according to real native storage lifetime and end ownership
leases on release. Keep span membership outside SDK headers so
ownership predicates can safely reject arbitrary addresses. Realloc changes
associations only after SDK success, preserving original ownership on failure.

Marshal every defined scalar, counter and pointer field. Atomic members require
real C atomic accessors, not scalar reads through layout-only Jai storage views.
Ordinary operations on a heap made current must refresh its facade too. Partial
counter snapshots, native pointer arrays and permanently zero nested records
are not acceptable implementations.

The permitted pinned C source shows a key traversal constraint: reserved spans
and unused cache slots need not contain initialized headers. The reviewed
partial/full list head's prev link identifies the tail. Recursively following every
pointer-shaped field could read invalid or unmapped memory. Traverse defined
live lists and occupied cache ranges; distinguish reserved storage from
initialized headers. Preserve defined field semantics without publishing a
placeholder graph. This is remaining code work, not missing external SDK evidence.

Separate association synchronization from exclusive heap mutation and native
atomic deferred-free handling. Do not hold a global SDK-call lock across Jai
callbacks: a callback waiting for another thread could deadlock, and independent
heaps would be serialized. Snapshotting non-atomic fields must not race owner
writes. Support sequential handoff and matching cross-thread frees. Current-heap
replacement must account for the native operation releasing the previous heap.

Required NEW public tests: canonical identity/reflection; all defined fields
and graph links; allocation/free/free-all/realloc failure; alignment; arbitrary
ownership queries; stale/foreign-domain rejection; thread handoff/deferred free;
current-heap replacement; callback failure and cleanup. Private probes compare
all applicable field offsets and atomic accessors with canaries. Source-check
six desktop targets and execute actual Mac programs; unavailable Windows/Linux
native evidence remains incomplete. Other profiles need their own SDK layouts.
