# Default allocator heap workflow

The optimized-target facade now exposes the reviewed standard Heap/Span/size-class
and statistics layouts, allocator value/default-heap storage and all lifecycle,
allocation, resize, ownership and bulk-free operations. Fallback targets retain
the existing C-runtime-only interface and capabilities. No statistics-enabled
variant has been invented for the standard module.

This independently designed backend tracks owned C allocations in per-heap
intrusive lists behind one real CAS lock. Public Heap addresses remain stable;
the bookkeeping is allocated with the heap, never keyed to caller stack addresses.
Realloc failure retains the old pointer/list entry; successful movement reconnects
both neighbors. Ownership queries compare live pointers without dereferencing an
unrecognized pointer. Heap bulk-free preserves the heap handle for reuse; destroy
and finalize release owned blocks and metadata. Initial initialization failure
returns null rather than treating a failed default-heap creation as a bad caller.

The backend deliberately releases blocks immediately. Therefore real cached-size
and cached-span counts are zero; this is not fabricated cache accounting. The
standard global statistics aggregate is explicitly documented as dummy by the
reviewed API. Allocation lookup is linear in live blocks; all heaps share a lock.
This favors a small auditable correct implementation over independent span caches.
Future performance work can replace private lists with indexed ownership and
per-heap locking/caches while retaining this public layout and behavior.

`python3 -B tools/check_portable_default_allocator.py` uses the actual Mac x64
target for interpreter/native O0/O2. It tests initialization/reinitialization,
capabilities, canonical records, two distinct heaps, 16-byte-aligned allocations
of zero through129bytes, grow/shrink with byte preservation, failed huge resize
retention, unrelated heap ownership, bulk-free/reuse, teardown, standard statistics,
4threads x512 shared-heap allocation/resize/free cycles, disabled module assertions
and argument validation, and9 invalid-pointer/extent/heap assertion executions.
Full owned target-aware strict lint and formatting pass. Initial missing branch
failure is retained in target/default-allocator-red.log; passing evidence is
target/default-allocator-final.log. These tests do not pretend to force real
system memory exhaustion or prove native Linux/Windows behavior.

Remaining exact numeric review: the spec defines the validated upper limit in
terms of one memory span but does not give that span's byte size. This backend
currently uses a64KiB rejection margin below signed64max, additionally guarding
its own allocation-header size overflow. Such immense requests cannot fit any
supported host address space; failed allocations return null. This private
numeric policy is not claimed as reviewed reference evidence; confirm the exact
margin before claiming boundary-level equivalence. Public Heap member arrays are
retained exactly but unused by this independent noncaching algorithm. Finalization
and caller-invalid argument handling follow documented safe ownership policies;
callers must not free/finalize heaps concurrently with their outstanding use.
