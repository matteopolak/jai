# Generic allocator protocol and diagnostic snapshots

The refreshed reviewed rpmalloc mode table is the API oracle. The callback uses
the single canonical bootstrap `Allocator_Mode`, `Allocator_Caps`, `Allocator`
and `Allocator_Proc`; no replacement records or extra public parameters exist.
`old_size` is ignored. The supported modes execute actual initialization,
thread lifecycle, default/explicit heap allocation/free/resize and ownership
queries. CREATE_HEAP returns an acquired canonical heap; DESTROY_HEAP asserts
on null. CAPS writes stable name storage when requested and returns the exact
reviewed pointer-encoded flags, deliberately excluding IS_THIS_YOURS. Invalid
modes reach the active assertion mechanism and return null if it returns.
STARTUP ignores the initialization result as explicitly required by review;
allocation/resize still return null when that import has not initialized.

The stable name is independently chosen as `rpmalloc`; the reviewed page gives
no exact spelling despite the mailbox's summary, so this precise question
remains recorded. No original spelling guarantee is claimed. Its immutable
bytes and stored string live for the program and survive repeated CAPS calls.

## Six real native domains and exact public records

Raw's named first-class heap API is conditional, but its generic CREATE_HEAP
mode is reviewed independently. Even with named heaps disabled, its public
Heap alias has an exact reviewed record shape without full-list fields. The
typed SDK adapter now has three public record profiles (rewrite, raw without
named heaps, raw with named heaps), each compiled with statistics on/off.
Neither public shape is cast into SDK storage. Private full/large-list tracking
continues to serve real ownership queries when those links are not public fields.

`rpmalloc_profiles.py` owns all six SDK/callback/facade symbol domains and real
compiler flags. The pinned native SDK's first-class capability is enabled to
implement the generic protocol; that does not expose the disabled public names.
All aliases retain canonical names/layout/visibility. The raw-base ABI program
checks every reachable field against independent C mirror measurements and
compares its public pointer with a distinct typed private SDK handle.

## Builder diagnostic capture

The enabled rewrite builder API statically requires Basic.String_Builder and
appends; disabled statistics expands to the explicitly reviewed empty operation.
Diagnostic text is independently organized and is not a serialization format.
It covers each native heap's real id/owner/full/reserve/transfer counters and
all nonzero span/size-class counters, plus real native global mapping/cache
statistics. Zero classes are omitted, not replaced with fabricated totals.

Formatting can allocate through this very allocator. `heap-snapshot.inc`
therefore captures immutable compact counter arrays and native global statistics
under the existing native operation lease, then releases the lease before Basic
formats any text. Formatting never follows captured live span pointers. Capture
allocation failures roll back both allocations and set builder.failed; formatter
growth failure remains visible through the builder's own failed state. All bool
formatter results are handled. This new transactional capture does not solve
the accepted heap/span association allocator's separate fail-fast metadata OOM.

Raw file output is gated by statistics and an explicit private PRETTY_PRINT
setting. Review establishes no public type/default/selection mechanism for that
name. The independent packaging default is true, preserving this implementation's
real native text output. `configure_rpmalloc.py --stdlib <owned-package>
--pretty-print false` selects the reviewed empty output case without inventing
a public import parameter. Both gates have actual native output tests.

## Evidence and limits

Public tests cover all modes, exact capabilities/name storage canaries, supplied
and default heaps, ignored old_size, full/large/huge ownership ranges, four-thread
handoff, lifecycle effects, preserving failed realloc and null-result modes.
Builder tests retain existing bytes, check append/no-op behavior, deny real growth
and format using a builder allocated on this allocator. Independent C tests
inject actual libc capture allocation failures at both points, check rollback,
compare counters with pinned SDK atomics, prove capture immutability after frees,
and verify all metadata is released at finalization under ASan/UBSan.

Wrong builder types fail source checks on six desktop configurations. Invalid
mode/default-heap destruction execute and fail at genuine assertions; reports
retain actual observed exits and validate the intended diagnostic. They are
negative evidence, distinct from positive native programs. New scoped code is
formatted and strictly linted, including each staged standalone program under
lint's explicit --context root.

All 18 originally failing source configuration checks now pass with declarations
and public names, in both private heap selections. This is not full platform or
option completion: other cache/assertion/page-advice/numeric option combinations
still lack faithful native domains. The ledger retains 80 partial entries rather
than relabeling supported defaults as full completion. Heap/span metadata OOM,
linear ownership lookup/full graph copying/serialization, and native Windows/Linux
verification remain explicit limits. The worker native dependency builder builds
real static/shared host SDKs; final toolchain package/native CI integration belongs
to the coordinator, not to these staged source/native proofs.
