# Target layout caching in VM memory

The VM keeps a private cache of complete target layouts so repeated pointer
projections can read a selected field offset without recalculating the enclosing
record. It retains immutable `Arc<Layout>` roots, bound to one explicit layout
policy and one type-registry identity.

## How it works

A cold request preflights only the root's demanded storage dependencies. Records,
fixed arrays and distinct representations need their by-value dependencies;
pointers and sequence descriptors do not need pointee definitions. The preflight
bounds graph nodes, field edges, temporary traversal state and field offsets
before the underlying `jai-types::LayoutEngine` calculates or clones them.
Distinct representations inherit offsets, so a chain of distinct types cannot
hide repeated large offset arrays. Explicit alignment-list validation and cache
table growth also contribute work.

A dynamic-array descriptor's certified allocator record is a by-value dependency
when the registry has adopted the authentic allocator role. Its element remains
an indirect pointee dependency. Ready roots whose closure contains a dynamic
array retain the allocator-role identity; adopting a role later rejects those
stale facts before consumption. Unrelated primitive, pointer and slice roots
remain reusable. This guard also covers a dynamic array inside a zero-count
fixed array, whose layout closure still demands its element definition.

A successful computation retains only the requested root. An uncached parent
therefore pays for its complete dependency closure even when a child was cached
as another root. Pending definitions, invalid layouts and budget failures retain
no partial result. A hit validates the full `TypeId` against the current registry
and returns a shared layout without visiting the record fields. The canonical
Bool `TypeId` includes its compilation-arena identity and binds the cache to an
append-only registry; completed definitions must remain immutable.

`Memory::prepare_layout` returns consumed work together with its result. VM
execution supplies its actual remaining fuel and charges the returned work before
propagating success, an error or a pending dependency. Failed retries cannot reset
this work. `prepare_pointer_layouts` has an explicit `include_pointee` flag:
address-only operations prepare required projection offsets while access and
stride operations also demand the final pointee layout. `prepared_layout` is a
cache-only accessor and rejects an unprepared root rather than hiding a cold
computation.

The same bounded postorder preflight computes an inline decoded-value shape for each requested root: arrays multiply child counts, ordinary records sum fields, unions select the largest field, and distinct wrappers add one node. The cached root entry includes this fixed-size count and depth fact alongside its shared layout. `prepared_decoded_cells` reads it without scanning fields; copying and swapping use it to precharge aggregate reconstruction. The same root entry retains static codec-layout closure work. `prepared_codec_layout_work` reads this cost without walking definitions before fuel admission. It counts every demanded by-value child edge and every record-field edge, including repeated fields and the element of a zero-count array, while visiting each dependency definition once. Descriptor and pointer layouts leave pointee definitions untouched. The normalized work multiplier matches the codec's former closure preflight; fresh codec engines remain charged even when decoded value counts are tiny. Counts saturate on overflow, and only consumers reject a shape above the value or depth budget. An enormous array of zero-sized records can therefore retain a valid address layout while being too large to read as a value.

Cached root entries and offsets share the cumulative `Memory.value_cells()` budget
with live values and byte images. Releasing an allocation removes its storage
charge but leaves reusable layout facts charged. Transaction snapshots restore
both cached facts and the corresponding cell total. Sharing layout arrays with
`Arc` avoids repeated offset copies without relaxing their retained cell bound.

## How to change it

The helper and independent fixtures are in
`crates/jai-vm/src/memory/layout_cache.rs` and its `layout_cache/tests.rs`
subfolder. Memory owns the cache, and pointer/layout hooks live in `memory.rs`;
selected copy accounting lives in `memory/copy_work.rs`. Execution must prepare
before operations that can need a new root and must charge consumed work even
when preparation reports a dependency.

Add a preflight dependency rule when introducing a new storage-bearing type
kind. Keep it consistent with `jai-types::LayoutEngine`; do not substitute host
sizes or duplicate target layout calculations. Preflight inherited field offsets
before cloning and retain results only after successful complete computation.
Do not inject arbitrary public maps of layouts as trusted ready facts. Preserve
the distinction between a pointer's representation and its pointee's layout.

This cache covers Memory's layout queries. Byte codec traversal and sealed
aggregate snapshot helpers have their own accounting and must not be described
as cache hits merely because the same type exists in Memory's cache.

## Configuration

`ByteTarget.policy` fixes the cache's target layout. `Limits.value_cells` bounds
retained cache cells and temporary layout traversal. VM callers provide remaining
fuel to preparation; standalone Memory operations use a bounded cold-work cap of
`value_cells * 16`, since VM execution fuel is a separate policy. There are no
environment variables, host ABI assumptions or eager registry-wide scans.

## Dependencies

The cache uses `jai-types` for identities, ready definitions and `LayoutEngine`,
the VM's structured errors and limits, and standard-library collections and
`Arc`. It has no external services or dependencies.
