# Compile-time sequences

## What it is

The compile-time VM evaluates fixed arrays and string, slice, and dynamic-array descriptors. Their data fields contain checked virtual pointers rather than host addresses.

## How it works

A view of a fixed-array variable aliases its existing storage. Mutating that array is visible through the view. A view of a static array expression uses an immutable allocation that survives procedure return. The VM pools these allocations by their language type and value, matching the backend's typed constant pooling. Empty views have a null data pointer.

For a loaded fixed-array place, `.count` comes from its checked array type, and `.data`, `ArrayToSlice`, and `ArrayView` use its existing address. These operations resolve the place once and do not load, clone, or initialize its elements. They therefore work for uninitialized arrays, allow writes through a view before other elements are initialized, and keep metadata queries independent of array width. Reading an element still requires its own bytes to be initialized.

String storage contains a count and a data pointer. Literal bytes live in a separate immutable allocation; changing a string variable's descriptor cannot change bytes reached through an earlier data pointer. The VM pools identical literal bytes, rejects writes through their data pointers, and uses a null pointer for an empty string. Descriptors constructed from a mutable byte array retain that array's storage and bounds.

String, slice, and dynamic-array descriptors retain signed `i64` count fields, and dynamic arrays also retain signed allocated fields. Construction, assignment, field stores, and field reads preserve negative counts, null data, and count/capacity combinations. This matches native descriptor storage: reading `view.count` does not inspect `view.data`. Indexing, spreading, string byte comparison, and owned-byte materialization validate the fields they actually use. Negative counts fail checked indexing; unchecked indexing still uses the real backing bounds. Converting a negative count to a byte-copy or materialization size fails with `CheckedCast`, and a positive nonempty access through null data fails with `NullPointer`.

The literal pool belongs to `VmState`, so it survives transfers between compatible procedure-provider snapshots. Failed and pending executions roll back newly allocated backing and pool entries along with other virtual memory changes.

Compiler effects and constant publication use `Vm::materialize_value` or `Vm::materialize_values` to copy string views into owned bytes. These methods recurse through arrays, records, unions, and distinct values. They validate pointer provenance and bounds before copying and preserve arbitrary bytes, including NUL and non-UTF-8 bytes. Slice and pointer identities remain virtual pointers.

Stored aggregate snapshots retain raw bytes, initialization masks, and inactive union metadata alongside their active semantic value. Field access, array indexing, and distinct unwrapping preserve selected snapshots. Sequence metadata reads inspect the array's semantic shape, while its backing allocation retains the complete snapshot. Materialization unwraps a snapshot only after its complete, initialized image exactly matches a canonical encoding of the semantic value; otherwise publication fails rather than discarding hidden bytes or provenance. This proof consumes storage and semantic traversal budgets before encoding.

Dynamic arrays retain a typed allocator payload when the type registry has bound
the genuine allocator role. Their default payload is that nominal record's zero
value, with its declared procedure and data pointer fields. An absent payload is
reserved for registries without that role. Copies, storage normalization,
materialization, and temporary-escape checks traverse the payload; stored-image
carriers keep allocator masks and procedure/data receipts intact.

The proof resolves canonical opaque handles through one borrowed token map from the existing image. This keeps many pointer fields proportional to their total metadata size instead of searching every prior relocation for each field. Missing handles or inconsistent repeated tokens fail before the canonical image changes.

Each checked index expression retains its `CheckMode`. Enabled checks enforce the descriptor's logical count. Disabled checks can read beyond that count when the referenced backing allocation still contains the element; they retain virtual allocation bounds, provenance, and negative-index checks. A fixed-array value has no storage beyond its declared elements.

Reads charge the value and pointer metadata they copy. A read through a byte or union view also charges the first conversion of its entire backing allocation into a byte image. Later reads use that cached image and charge only the selected bytes and metadata. Zero-sized aggregates are charged by their type's expanded value count, since a zero byte extent can still decode many elements. Literal pooling charges hashing and allocation clones even when the literal's address is reused. Pool growth also charges a cached memory-cell bound before rehashing earlier value keys. Creating a string data pointer uses the known byte allocation address without copying its bytes.

Zero values and record defaults also charge their expanded value count before constructing the aggregate. A `[100000]Empty` default consumes 100001 nodes even though its target storage has no bytes. The preflight memoizes type shapes and multiplies array counts without visiting each element. A union's default selects only its first field, and incomplete selected types remain pending dependencies. A bound dynamic descriptor includes its allocator record in this preflight: the descriptor, allocator record, procedure, and data pointer consume four nodes; an unbound descriptor consumes one. The descriptor's element type is not traversed because zeroing it allocates no elements.

Sequence indexing supports zero-sized elements by validating the backing pointer and retaining its address for every index. Logical count checks still apply. General pointer arithmetic requires a nonzero element stride. Caller-owned variadic backing follows the rules in [compile-time variadic packs](compile-time-variadic-packs.md).

## How to change it

Descriptor access, indexing, view creation, and literal pooling live in `crates/jai-vm/src/execute/sequences.rs`. Owned-byte materialization lives in `crates/jai-vm/src/execute/materialize.rs`. Add independent checked-IR regressions in `crates/jai-vm/src/sequence_regressions.rs` when changing aliasing, lifetime, or evaluation order.

Normalize ordinary values with `normalize_storage_value` before putting them in virtual storage. The immutable string byte allocations must keep their owned-byte representation; normalizing those allocations would create descriptors whose backing recursively needs another descriptor. Resolve a load's place once before extracting a sequence descriptor so pointer and index expressions execute once.

Keep descriptor type validation separate from use-time extent checks. `Value::validate` checks descriptor shape and element types; `checked_sequence_count` converts a signed count only when a consumer needs a nonnegative size. The byte codec and virtual-memory field helpers must round-trip signed fields without checking backing extent. A loop can inspect a negative captured count and run zero iterations without accessing data.

Use `crate::value::allocator_schema` to revalidate the registry's sealed role
before constructing or projecting allocator state. `default_sequence_allocator`
uses the same charged zero constructor as record defaults; adopting a payload
validates the exact nominal allocator type and preserves its original carrier.
The standalone allocator extraction and adoption wrappers currently serve the
checked-IR regression tests; production descriptor access uses ordinary typed
record fields. Keep these helpers test-only until a production consumer needs
their certified subobject projection.
Do not replace the allocator with an invented pair of opaque pointers. Its
subtree must remain part of value-cell, zero-shape, decode-work, and lifetime
accounting even when the array's count is zero.

When adding a descriptor field, update checked IR field validation, virtual-memory field projection, sequence construction, and the source/backend implementations together. Data pointers must retain their original allocation identity across descriptor reassignment.

Preserve the direct loaded-fixed-array branches in `sequence_field` and `array_view`. Routing them through `sequence_parts` would read the complete array before producing metadata and would incorrectly reject uninitialized storage. Do not synthesize an array value to represent an address-only query; use the checked type's count and the resolved place's real allocation.

Preflight reads with `Memory::load_work_cost` before loading or cloning data. Its implementation in `memory/copy_work.rs` borrows structural values and image metadata, and does not initialize images. Keep cold backing costs separate from warm selected reads so indexing a large array remains proportional to the accessed elements.

Prepare required target layouts through `Vm::prepare_layout` or `prepare_pointer_layouts` before memory access, allocation, or copy preflight. These wrappers charge the actual cold traversal against remaining fuel, including failed and pending attempts. Read the completed fact through `Memory::prepared_layout`; constructing another layout engine after preparation would repeat uncharged work. Address-only casts omit the final pointee layout, while indexing and byte reads require it. See [the demanded layout cache](target-layout-cache.md) for retention and dependency rules.

Preflight writes with `store_work_cost` before staging changes. Partial stores clone the root value or byte image, including zero-sized aggregate elements. Their bound also includes the root byte extent because an incoming address-derived integer can require image conversion even through an ordinary integer place. Complete replacements charge the old structural root clone without an unrelated byte-image charge.

Construct execution defaults through `Vm::zero_value` in `execute/budgets.rs`, which calls `Memory::zero_value_work_cost` before `constants::zero`. Apply this to new zero-expanding expression or constant paths; calling the constructor directly bypasses fuel accounting. Keep shape memoization's depth bound and first-field union behavior aligned with the constructor.

## Configuration

`jai_vm::Limits` controls fuel, evaluation depth, allocation count, and value cells. Literal allocations count toward memory limits. Materialization bounds total output cells and traversal work before allocating copies; the batch method shares one budget across all arguments. The compiler-effect boundary also charges this work against the execution's remaining fuel.

## Dependencies

This implementation depends on `jai-ir` sequence expressions and checked places, `jai-types` type identities and descriptor element types, and `jai-vm` virtual memory, execution transactions, and `VmState`. It does not load native libraries or expose host addresses.
