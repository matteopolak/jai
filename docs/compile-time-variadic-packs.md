# Compile-time variadic packs

## What it is

The compile-time VM implements mixed scalar and spread arguments for Jai variadic procedures with checked IR `SequenceConcat`. It builds a contiguous slice whose temporary storage belongs to the caller.

## How it works

Each pack part is evaluated in source order. A scalar becomes one element; a spread copies the referenced slice immediately, before the next part runs. For example, spreading `numbers`, then calling a later argument that modifies `numbers`, retains the earlier bytes in the pack. Loaded scalar aggregates also use their original byte image so inactive union bytes and padding survive the copy.

Resumable execution lowers pack parts to private typed nodes. Its `PackState` accepts only already computed values or places and retains completed snapshots while a later argument waits for a dependency. Resuming continues at that argument; it never reevaluates earlier expressions or rereads their source backing. Final assembly uses the same byte, metadata, and caller allocation limits as synchronous execution.

The VM concatenates the snapshots once and installs the final image in aligned virtual memory. Copies preserve initialization masks, union views, procedure handles, virtual pointers, and address-integer provenance. They do not convert an address-derived integer into an ordinary integer. Nonempty spreads require a live local backing allocation covering their requested bytes. Empty packs have null data; nonempty packs of zero-sized elements use a nonnull sentinel and support indexing at zero stride.

Before a snapshot creates its source byte image, the VM charges the full backing extent, retained value cells, and possible opaque-handle token-table growth. A one-element spread into a large cold allocation therefore pays for that allocation's initial conversion. Once cached, a snapshot copies only its selected range and incurs no repeated full-allocation charge. Final image installation also bounds token-table rehash work when metadata is present.

Descriptor count fields are signed. Building or storing a descriptor preserves negative counts and null data; spreading checks the count when it uses the elements. A negative spread count fails with `CheckedCast`. A positive nonempty spread with null data fails with `NullPointer`, and copies beyond real backing fail a bounds check.

A procedure frame owns its final pack buffers until the frame returns. A callee may return a slice into its caller's pack while that caller remains live. Returning a frame's own buffer, directly or through an aggregate, descriptor, or address-derived integer, fails with `SequenceTemporaryEscape`. Stored aggregate carriers also inspect allocation origins in inactive bytes, so selecting a smaller union field cannot hide the temporary's lifetime. Integer origin tracking catches this even when arithmetic moves the numeric bits outside the original allocation. Top-level `evaluate_call` packs remain live through result validation and are released before the transaction finishes. Failure and pending work in synchronous execution roll back buffers and accounting; resumable execution retains them until it resumes, finishes, or is cancelled.

## How to change it

`crates/jai-vm/src/execute/sequence_concat.rs` handles ordered snapshots, allocation charges, construction, and return escape checks. `execute/sequences.rs` contains the sequence-specific zero-stride index helper. The execution frame and root transaction in `execute.rs` own temporary roots and call the escape validator before releasing storage.

`execute/resumable/plan/expressions.rs` lowers checked pack trees without borrowing source expressions. `execute/resumable/pack.rs` captures computed operands, and the continuation machine stores that pack state between tasks. Keep capture immediately after each part completes rather than deferring all copies to final assembly.

Keep loaded places resolved once, and preserve raw metadata when adding a copy path. Use `ByteImage::extract_range` for selected source bytes and `ByteImage::concatenate` for the final image; copying through a structural union value discards bytes outside its selected field. Add checked-IR regressions in `crates/jai-vm/src/sequence_concat_regressions.rs` and source/native parity cases in `crates/jai-codegen/tests/sequences.rs`.

Call `Memory::sequence_snapshot_work_cost` before snapshotting; selected byte and metadata charges remain the caller's responsibility. Charge `retokenize_work_cost` before installing a final image carrying metadata. These helpers use cached allocation sizes and borrow image state without first performing the copies they are meant to bound.

Prepare the element layout before creating pack state, then obtain its size and alignment through the cache-only `Memory::prepared_layout`. Prepare source pointer layouts before snapshot preflight and destination layouts before allocation. Cold traversal consumes remaining execution fuel even when a layout dependency is pending. Both synchronous packs and retained resumable packs use the same [demanded layout cache](target-layout-cache.md); repeated warm packs must not rebuild a wide element layout.

Only a checked Jai variadic call argument may contain `SequenceConcat`. Changes to pack shape, lifetime, or accounting must update `jai-ir` validation, source lowering, and native code generation together.

## Configuration

`jai_ir::MAX_SEQUENCE_TEMP_BYTES` is a shared hard limit of 1 MiB per caller frame, or per top-level call transaction. Charges accumulate across repeated calls in that frame. Every nonempty spread snapshot and final buffer costs `max(bytes, 1) + max(alignment, 16) - 1 + 64`, using `sequence_temp_allocation_charge`; empty allocations cost zero. The allowance includes native alignment padding and temporary allocation metadata so VM and native limits agree.

VM `Limits` additionally bound fuel, evaluation depth, allocations, and value cells. Each snapshot consumes fuel for its bytes and metadata cells before the next part runs. The final assembly charges its bytes and metadata before cloning them. Metadata cells include address origin IDs, complete relocations, and union views, so many origins attached to a small integer still consume proportional fuel. Retained snapshots share a cumulative metadata cell allowance. Escape validation independently bounds its visited values and integer origins before allocating traversal storage. There are no environment variables specific to this feature.

## Dependencies

The implementation depends on `jai-ir` pack validation and shared allocation constants, `jai-types` target layouts, virtual memory's sequence buffer APIs, and `ByteImage` metadata-preserving copies. Native parity uses `crates/jai-codegen/src/sequence_packs.rs`; virtual execution does not load native code.
