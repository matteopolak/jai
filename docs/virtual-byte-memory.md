# Virtual byte memory

## What it is

`jai-vm::ByteImage` stores a typed compile-time value using explicit target sizes, offsets, alignment and byte order. It permits integer, float and aggregate aliases to read or modify the same bytes without relying on Rust's host representation.

## How it works

`ByteImage::encode` validates the original value and asks `jai-types::LayoutEngine` for its storage layout. Records use declared field offsets, arrays use the computed stride, packed records retain packed offsets, and union members overlap at offset zero. `ByteImage::from_bytes` represents raw backing storage without typed handle provenance. Initial aggregate padding bytes are zero. Reads reconstruct the requested type; writes first encode a complete patch and validate its bounds, then replace the bytes atomically. A failed write leaves the image unchanged. Boolean encoding uses canonical zero or one. Aliased boolean reads use the low bit, matching the LLVM `i1` storage behavior independently verified by native tests (for example, byte 42 reads false and byte 43 reads true).

Virtual pointers and procedure values have relocation records. `retokenize_handles` atomically replaces complete handle bytes using a caller-supplied stable token provider. Memory uses canonical virtual addresses and procedure identities so equal handles encode equal bytes across allocations and pointer views. The callback must keep distinct identities distinct; null, out-of-width and inconsistent duplicate tokens or callback failures leave the image unchanged. Data-pointer tokens come directly from a validated live allocation's nonrecycled virtual base plus its canonical byte offset. They need no separate interning ledger; retiring temporary frames therefore cannot accumulate historical data keys or raise later retokenization costs. The retained token ledger contains procedure identities only, because sealed code receipts depend on their admitted canonical tokens. Their visible byte tokens are opaque identities, never native addresses. A complete typed write retains the handle. A scalar or byte write overlapping any part of a relocation removes the complete opaque handle, even if the bytes are unchanged. Address provenance outside the written extent remains attached to its original bytes. `read_range` observes bounded raw bytes; `write_range` and `fill_range` invalidate every overlapping handle and union view. `copy_range_from` preserves only complete source relocations and union views and requires matching target policies. `copy_range_within` explicitly provides overlapping `memmove` snapshot semantics; the Memory layer enforcing `memcpy` rejects overlap before calling the copy helper. Every range is validated before mutation. A later pointer read accepts an intact relocation or an unmarked all-zero null value; it rejects a nonzero byte sequence without provenance. Data-pointer and procedure-pointer relocations cannot substitute for each other.

Integer address provenance is a separate interval overlay. A full-width integer view of complete pointer bytes produces a `Number` with the exact pointer origin. An exact typed integer store wider than the target pointer also retains that origin; clipped or overwritten fragments remain derived even when their new extent happens to equal the pointer width. Partial views or copies produce derived provenance with the same memory identity and sorted original allocation IDs. Multiple same-memory origins merge within the configured value budget; incompatible memory identities fail explicitly. Plain integers with identical bits remain plain and never acquire an origin through numeric matching. Typed address-integer stores preserve their original bits and metadata and are not retokenized.

`range_has_provenance` checks initialized bounded ranges. `range_provenance_equivalent` proves byte equality through complete opaque handle identities supplied by a caller callback and equality of the remaining plain bytes, ignoring virtual handle token values. Partial handles and integer address provenance cannot prove portable equality. Runtime `memcmp` can return zero for equal complete pointers or procedures; it rejects other tagged comparisons instead of deriving an ordering from virtual addresses.

Procedure addresses become opaque code pointers only after Memory admits the procedure to its canonical token ledger and certifies its complete byte slot. The sealed receipt records the issuing Memory, exact procedure signature, procedure ID and visible token; standalone procedure encoding has no receipt. A certified slot can be viewed as a pointer or a full-width address integer, and a reboxed pointer slot can recover only the original signature. Complete copies retain this proof; fragments become derived provenance with no data-allocation origins and cannot reconstruct a callable handle by matching bytes. Code pointers never identify readable data storage. Canonical aggregate publication carries validated code receipts from its reference snapshot when aligning handle tokens. Change the certification adapter in `memory/code_images.rs` together with the handle checks in `byte_memory/handles.rs`; no numeric token lookup may substitute for a receipt.

Raw writes and ordinary fills clear provenance only in the written range. `fill_range_number` carries derived provenance from a tagged memset byte. Partial copies preserve the provenance of only the bytes they copy and cannot rebuild an opaque pointer through byte-pattern matching. Float, boolean, enum and sequence-length reinterpretation of address-marked bytes produces `UnsupportedPointerOperation`. Integer-marked storage requires an explicit checked Memory integer-to-pointer conversion; it cannot become an opaque pointer through a byte view.

`concatenate` validates the combined size and target policies before assembling complete images in one pass. `extract_range` copies only its selected bytes and intersecting metadata. Both preserve initialization holes, procedure and complete pointer relocations, selected union views and integer provenance; partial extraction downgrades exact pointer provenance to the original derived allocation set. Metadata stays ordered by physical offset after mutations. Typed handle and integer reads use binary searches, and extraction visits only metadata in its selected range, so a batch of pointer elements does not repeatedly scan the complete image.

Runtime `Type` storage is a target-sized descriptor pointer. `None` encodes as zero and can round-trip without a bound reflection header. A nonnull descriptor requires `TypeView::runtime_type_header()` and uses the ordinary data-pointer relocation, so pointer aliases, integer provenance, complete copies and canonical retokenization follow the same rules. Decoding recovers only the header pointer; Memory separately validates its descriptor identity and represented type. Raw nonzero bytes cannot fabricate a `Type` value.

Native pointer constant capsules are normalized by the VM importer against `ByteTarget.policy.pointer().size` before byte encoding. A target-normalized zero becomes a real typed null with no relocation or address provenance. A nonzero numeric capsule has no virtual allocation or code receipt and produces a structured unsupported-pointer error; encoding never fabricates either identity. Checked narrowing preserves its checked-cast failure, while truncation can become null on a narrow target.

A union image remembers its active member for reconstructing the whole union; typed stores can update that view through `note_union_field`, and `read_union_field` can explicitly reconstruct another member from its overlapping bytes. `StringView`, slice and dynamic-array descriptors store target-layout counts and virtual pointer relocations. Descriptor handle encoding uses the explicit pointer layout and known element type directly; it does not require an unrelated structural pointer type to have been interned in the registry. Owned strings require conversion to a backing-storage descriptor before encoding. Descriptor count and allocated fields are signed `s64` storage. Negative values, null pointers with nonempty counts and count greater than allocated can round-trip as descriptor fields; indexing and other consumers validate them when used. When the registry adopts the certified Preload allocator role, the final dynamic-array descriptor field stores that nominal procedure/data record. The codec uses its exact field types and target offsets; complete procedure and data relocations remain distinct and preserve their receipts through descriptor copies. A partially initialized allocator is copied as a sealed storage carrier, so its unwritten slots remain unreadable. The allocator projection limits pointer casts to the allocator subregion. Without the certified role, descriptors retain the legacy all-zero opaque tail and reject nonzero, uninitialized or address-marked allocator internals.

Partially initialized storage has a private byte initialization mask. A projected
typed field write into an object declared with `---` creates a bounded image and
marks only the written extent. Scalar and handle reads require initialized bytes;
aggregate reconstruction checks its semantic fields while leaving padding
unknown. This supports formatter code that writes each field of an `Any`
descriptor before copying or passing it. Raw range reads reject holes, copies
and overlapping moves preserve holes and relocations, and fills initialize their
exact range. Copying an opaque union image retains its chosen member and does not
invent bytes for its inactive alternatives.

Ordinary typed copies use the sealed VM `StoredAggregate` carrier when an image
load contains a union, including unions nested in records, arrays or distinct
representations. The carrier holds the active semantic value and a shared,
immutable snapshot of the selected byte extent. Subsequent stores encode that
snapshot directly; they preserve initialized inactive bytes, initialization holes,
union views and complete or partial address provenance. For example, writing
`small:u8 = 42` over `wide:u64 = 0x1122334455667788` and copying the whole union
keeps the inactive wide value `0x112233445566772a` under the default little-endian
target. It does not reconstruct the destination from `small` alone.

`Value::semantic()` and the carrier's read-only semantic accessor are for kind
inspection. Keep the carrier for assignment, parameters, returns and literal
backing keys. Use `field`, `with_field` and `representation` for typed projections
and construction so nested snapshots survive. Equality and hashing include bytes,
initialization, target and all metadata; equal active fields do not imply equal
storage. A carrier cannot be fabricated through its public API.

Native constant publication requires `publication_semantic` to prove that a fresh
semantic encoding exactly matches the snapshot, including metadata and canonical
handle tokens. Holes, noncanonical inactive bytes and inactive address origins
produce `UnsupportedPointerOperation`; there is no lossy semantic fallback. The
proof accepts canonical union storage and does not change ordinary VM copy
semantics. The normal VM materialization path performs this proof before the
source adapter publishes a native value.

## How to change it

Initialization checks and fixtures live in `src/byte_memory/initialization.rs`.
Keep these checks on pointer and procedure relocation reads as well as numerical
reads. Do not make placeholder bytes readable by zero filling an uninitialized
object. `bytes()` is a backing-image inspection accessor; runtime reads must use
the typed or checked range APIs.

The codec and provenance rules live in `crates/jai-vm/src/byte_memory.rs`; the independent fixtures are in `src/byte_memory/tests.rs`. Handle encoding and atomic retokenization live in `src/byte_memory/handles.rs`, with tests in its `handles/tests.rs` subfolder. Raw range operations and their tests live in `src/byte_memory/ranges.rs` and `src/byte_memory/ranges/tests.rs`. Portable range equality proofs live in `src/byte_memory/comparison.rs` and `src/byte_memory/comparison/tests.rs`; callbacks must compare canonical identities and must not compare virtual token bits. Address interval handling and its independent fixtures live in `src/byte_memory/provenance.rs` and its `provenance/tests.rs` subfolder. Metadata accounting and its regressions live in `src/byte_memory/metadata.rs` and `src/byte_memory/metadata/tests.rs`. Preflight the final metadata footprint before cloning origin arrays or mutating storage. Keep provenance spans disjoint and restore metadata ordering after mutations; the binary-search read and extraction helpers depend on this invariant. Add a codec arm when introducing a new VM value representation. Obtain layout from `LayoutEngine` instead of copying host sizes or calculating aggregate offsets manually. Preserve relocation records when copying handles; raw byte writes must invalidate overlapping records.

The Memory integration must preserve allocation identity and use allocation-relative byte offsets for casts, projections and pointer arithmetic. Reconstruct root values from the same image after alias writes. Never turn a visible token into a host address or reconstruct a virtual handle solely from its integer bits.

Aggregate snapshot handling lives in `stored_aggregate.rs` and
`memory/stored_aggregates.rs`. Extend those helpers when adding aggregate value
forms. Keep the constructor private, retain initialization and provenance in
encoding, and preflight selected storage and metadata cells before cloning.
Memory rejects foreign-memory provenance even in inactive snapshot bytes. The
independent Memory fixtures cover ordinary copies, nested projections, complete
handles, partial origins, holes, publication and equality. Carrier cells include
both the semantic tree and selected snapshot bytes/metadata; `Arc` sharing reduces
physical copies without relaxing the configured value-cell bound.

## Configuration

The allocator payload is enabled only by the registry's explicit certified
`AllocatorSchema` role. Extend that schema, descriptor codec, selected allocator
projection and cached decoded/codec closure facts together; structural record
lookalikes must not substitute for the nominal role. Allocator initialization
masks remain part of ordinary descriptor copies and field reads validate only
their selected storage.

`ByteTarget` contains `LayoutPolicy` and `Endian`. Its default explicitly selects LP64 with little-endian byte order. `ByteTarget::from(&BuildTarget)` preserves the driver's selected layout and byte order. Callers can supply a different policy and byte order when selecting another target; an existing image rejects operations using a different target. `encode` and `from_bytes` also take a byte/value bound. Encoding charges every supplied value; decoding shares a remaining value-cell budget across the entire reconstructed aggregate, including zero-sized arrays and decoded address origin IDs. The codec caps nested value traversal at 128 levels. The same bound applies to each image's total provenance origin IDs, complete relocation records, union views and every dynamic projection entry retained by a pointer. Each derived provenance span costs at least one metadata cell, including code-address fragments with an empty data-allocation origin set. This charges the retained interval record without changing `Number.origin_count()` or granting any pointer recovery authority. Range writes, splits, copies and typed integer encoding all use that span cost before mutation. `Pointer::metadata_cells()` counts its path entries; `Number::metadata_cells()` adds those entries to semantic origin IDs without changing `origin_count()`. Typed values charge paths in ordinary pointers, slices, strings, dynamic arrays and runtime Type descriptors. Encoding accounts separately for the independent pointer clones retained by provenance and relocation records before constructing either clone. Decoding reserves pointer metadata before cloning a recovered handle. Projection paths retain a hard 256-entry cap even when the configured evaluation depth is larger. Batch assembly validates metadata before cloning it; writes and copies charge every retained fragment, so splitting an interval cannot duplicate a large origin set beyond the budget. `ByteImage::metadata_cells()` exposes this work to bulk-operation fuel accounting in addition to byte work. A partial pointer extraction drops the projection path when it becomes derived allocation provenance, so it charges only metadata actually retained. `range_metadata_work(offset, bytes)` validates bounds and borrows metadata in the selected range without cloning an image; Memory uses it to charge tagged reads while plain scalar ranges have zero metadata work. Bounds and invalid layouts produce structured VM errors before storage is changed.

Memory also charges cached image bytes and metadata against the shared live `value_cells` limit. Creating a lazy image must fit alongside existing allocations; failure leaves that allocation uncached. Release removes the allocation and its image charge. Demanded target layout facts retain a separate charge after allocation release so later accesses can reuse their validated offsets; transaction rollback restores the earlier layout and image caches and their charges. Tight storage-budget fixtures should prepare the exact layouts they need, reserve their measured retained charge separately, and compare failed mutations against the post-setup baseline. This prevents many individually bounded images or layout facts from bypassing the cumulative memory limit.

For example, encoding `u64(0x1122334455667788)` under the default target produces `88 77 66 55 44 33 22 11`. Writing a `u8(0xaa)` at offset two changes the reconstructed integer to `0x1122334455aa7788`.

## Dependencies

The codec uses `jai-types` for the type registry and target layout, `jai-ir` procedure identifiers carried by VM values, and the VM's typed `Value`, opaque `Pointer` and error definitions. It exposes no host addresses and performs no foreign calls, file access or operating-system effects.
