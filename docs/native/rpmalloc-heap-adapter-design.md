# Canonical heap adapter design

This is an independent implementation plan, not completed behavior. The user
authorizes canonical public handles. Generated public records retain exact
nominal names, fields, conditions and dimensions. SDK Heap has the same size
but different offsets; public Span is 96 bytes versus SDK 88. Never forward a
public Heap/Span as a native pointer. Existing native assertions remain active.

Use typed heap and span associations. Each owns its canonical public record,
native handle, allocator domain and lifecycle generation. Validate identity
before C calls; never inspect an arbitrary caller pointer as native metadata.
Public links point to canonical records, preserving cycles and storage identity.
Retire records on release/free-all/finalize as appropriate; prevent stale-handle
reuse. Keep allocation ownership and span membership outside SDK headers so
ownership predicates can safely reject arbitrary addresses. Realloc changes
associations only after SDK success, preserving original ownership on failure.

Marshal every defined scalar, counter and pointer field. Atomic members require
real C atomic accessors, not scalar reads through layout-only Jai storage views.
Ordinary operations on a heap made current must refresh its facade too. Partial
counter snapshots, native pointer arrays and permanently zero nested records
are not acceptable implementations.

The permitted pinned C source shows a key traversal constraint: reserved spans
and unused cache slots need not contain initialized headers, and a list head's
prev link can retain an irrelevant prior value. Recursively following every
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
