# Compile-time address integers

## What it is

The VM represents explicit pointer-to-integer conversions as typed `Number` values with address provenance. This supports address roundtrips and byte aliases without treating a host pointer or an arbitrary integer literal as a compile-time allocation.

## How it works

Each allocation receives a monotonic virtual region aligned to its target type and requested storage alignment. Pointer bytes are the region base plus the target-layout projection offset. Regions are never reused, including after transaction rollback, and target pointer width bounds reservations. Procedure relocations use separate opaque virtual identities.

`Value::AddressInteger(Number)` carries either an exact pointer identity or a derived set of allocation identities. Ordinary integers remain `Value::Int`, even when their bits happen to equal a virtual address. Arithmetic, typed storage, aggregate copies, inactive union views, and partial byte copies preserve genuine provenance. Splitting and recombining bytes produces derived provenance rather than reconstructing pointer authority.

An explicit inverse cast accepts an exact pointer identity whose target-width bits still match its live allocation. Affine addition or subtraction of a plain byte offset retains that identity only inside the original bounds. A plain zero converts to null; an unknown nonzero integer and an arbitrary transformed address fail with `UnsupportedPointerOperation`. Tagged values do not become null merely because a transformation produced zero bits. Leading-header downcasts still require the proven containing allocation type.

The VM can remove address dependence when it proves the common allocation base cancels: subtraction of two addresses in the same allocation, or a power-of-two alignment residue guaranteed by the allocation alignment. Relative results can be published as constants. Absolute or otherwise transformed addresses remain tagged and are rejected before constant publication and effect commit. Index, offset, count, range, floating conversion, and other scalar consumers must retain or explicitly reject those tags instead of reading only their numeric bits.

Target-width pointer conversions preserve same-width bits and source signedness during extension. A nonnull pointer cast to a narrower integer is explicitly unsupported in the VM because its virtual numeric range cannot prove the range of a native address. Native checked/unchecked conversions retain their actual target semantics. This is a precise compile-time boundary, not a claim that virtual addresses can be embedded in native constants.

## How to change it

`number.rs` owns the provenance model; `execute/numbers.rs` proves portable differences and affine identities. `memory/addresses.rs` performs target-width conversions and region checks. `byte_memory/provenance.rs` tracks metadata through storage and copies. New scalar consumers should use `Number::portable_integer()` when they require a target-independent ordinary integer. New publication paths must recursively reject unresolved address integers while the VM transaction is still open.

Keep provenance attached to typed values and byte ranges. Do not infer it from numeric values, guess it from address ranges, or restore authority after partial copies. Tests should cover identical literal bits, tagged stores/copies/union views, affine roundtrips, dangling identities, rollback, and rejected address-dependent control.

## Configuration

`ByteTarget` determines pointer width, layout, and byte order. Requested local/global alignment comes from `StorageAlignments`. `Limits` bounds allocations, value cells, provenance origin sets, nesting, and work; origin traversal is charged to fuel. No environment variables or host address APIs configure this model.

## Dependencies

The implementation uses `jai-types` target layouts and integer casts, `jai-ir` checked cast/arithmetic nodes and storage metadata, and the VM memory, transaction, and byte-image modules. Source constant publication consumes the VM's validation callback before compiler effects are committed.
