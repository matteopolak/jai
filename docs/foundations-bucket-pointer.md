# Bucket_Array flattened pointer indexing

Bucket_Array now implements and exports the reviewed public function:
operator *[] :: (using array: Bucket_Array, index: int) -> *array.type.

The internal body checks that index is nonnegative, divides/modulos it by
items_per_bucket, checks that the resulting bucket exists and the slot is
occupied, then returns bucket.data.data + slot_index. It neither allocates nor
copies an element. The returned pointer addresses canonical bucket storage.

The facade adds only using,only(.["*[]"]) from its existing internal module.
There is no helper alias, internal-name filter, new type/module parameter,
alternate storage or type-home-scope compiler lookup. The existing constructor
defaults, generic identities, fields, allocator paths, locator lookup, removal,
reset and loop implementations are unchanged. A saved before-source comparison
proves that removing the new operator/import yields the original bytes.

## Physical slots, holes and lifetime

The index is bucket_index * items_per_bucket + slot_index. It is not a rank
among live items. Removing a slot leaves a hole: indexing that hole asserts,
while later occupied slots keep their original indexes and addresses. An
occupied physical index may be equal to or greater than the array's live count.
The implementation deliberately does not use live count as its index bound.

Ordinary indexed reads/writes and address-taking route through the reviewed
pointer-index operator rules. A write reaches the original element, not a copy.
Existing bucket pointers stay stable when a later bucket is appended. Reusing
a removed slot returns the same physical address for its new value; reset
invalidates the storage as before. Invalid negative/missing-bucket/hole indexes
are asserted before accessing the corresponding storage.

No new configuration or native dependency is added. The general pointer
dispatch/compiler work is owned by the compiler/integrator, with fb7 production
hunks integrated in bbc962fe. This library change relies on that proper dispatch
and the reviewed public operator-filter semantics; it adds no compiler bypass.

## Focused evidence

Run source/core verification from the shared tree:

~~~sh
python3 -B tests/portable-stdlib/bucket-pointer/verify.py
~~~

Fresh own source-built jaic/jailint and full Rust source guards are pinned in
the receipt. Core checks execute original #assert procedures with borrowed
stack buckets; no CLI interpreter program, native Jai executable, GUI or native
fault process runs. These checks exercise the actual production operator.

Before the edit, addresses.jai failed with cannot index Bucket_Array while the
independent locator-helper/address control passed. Those receipts remain under
foundations/bucket-pointer-wo5boy0x. The final receipt is
foundations/bucket-pointer-proof-denln8ex/results.json:
26 source/core commands, all matching their required outcomes, including eight
required negatives, real repository source-built jaifmt format/check, seven
positive contextual warnings-denied lint checks and a complete two-production-
file lint context with no unvisited/incomplete files.

Compile-time positives cover scalar and record values, both iteration-pointer
configurations, exact first/last slot addresses across buckets, whole-value
writes, pointer reads and canonical repeated-import type identity. Appending a
third bucket retains prior pointers. Actual removal/reuse checks verify physical
slots after holes, locator/address identity and dense iteration remaining
independent of physical indexing. Public glyph-filter reexport works. Type-only
and private named reexports cannot invoke the operator; their types remain
canonical and the private facade implementation alias stays hidden.

Five negative #assert programs retain actual operator assertion failures for a
removed hole, negative index, past-bucket index, empty array and maximum signed
index. The other three negatives preserve type-only/private reexport rejection
and private Impl visibility. No errors/assertions are ignored or counted as
successful indexing. The unchanged bucket-array-remove fixture also passes
source checking; its runtime removal/allocator assertions are not counted as
executed in this batch.

A first successful receipt precedes a small empty-array fixture correction.
The next run caught concurrent compiler source changes at its final source
guard and remains failed in bucket-pointer-proof-2b8lt9tf. Rebuilding/replaying
on the new shared compiler produced the final matched-source receipt above;
no stale tool result is projected onto the new source.

## Native pending and integration

Root's full-workspace/native lease is still active. Native O0/O2 execution is
explicitly pending and no native completion is claimed. After explicit lease
release/grant, this worker can run verify.py --native, or the integrator can
execute the same six real behavior fixtures in its own pinned namespace.
Every native fixture has a runtime main with actual assertions; the pure
type/privacy fixture is excluded from native behavior counts. The heap-workflow
fixture adds real allocation across three buckets, pointer/field mutation,
removal, reuse and reset; it is source-checked now and runtime-pending.

The only production paths are stdlib/internal/collections/bucket-array.jai and
stdlib/Bucket_Array/module.jai. The exact source/test/doc/spec hashes, source
guard results, compiler identities and pending native plan are recorded in
[the ready handoff](status/foundations-bucket-pointer.json).
The reviewed bucket-array page is reviewer-owned and must accompany the
coherent integration batch; this worker did not modify it.

No Basic predicates/clock/configuration, unrelated library implementation,
compiler, peer checkout, Extensions, Git/index or remote operation changed.
This one reviewed missing API is implemented with source/core evidence; it
does not claim a full corpus or native matrix result.
