# Pointer integer conversions

## What it is

Explicit pointer/integer casts expose target-width addresses while retaining a
safe virtual-memory representation in the VM. Integer-left pointer addition
has a separate IR node so both operands run in their written order.

## How it works

Native conversion uses LLVM's pointer/integer instructions. A pointer cast to
an integer of the same width preserves its bits, including a signed target;
a wider integer receives a zero extension. Checked narrowing verifies that
the address fits the destination, while unchecked narrowing truncates it.
An integer converted to a wider pointer sign-extends or zero-extends according
to the integer's type. Checked conversion from a wider integer verifies the
unsigned pointer-width range; unchecked conversion discards high bits.

The VM reserves aligned, monotonic virtual regions for allocations. A virtual
address is the region base plus the pointer's byte offset, which preserves
relative byte distances and proven alignment without using a Rust host
address. Its integer representation carries typed `AddressProvenance`; plain
integers do not acquire provenance by matching the same numeric bits. Inverse
casts retain allocation bounds and lifetime checks. Plain zero produces null;
unknown nonzero integers produce `UnsupportedPointerOperation`. Identity casts
and proven in-region address-plus-byte-offset operations preserve an invertible
pointer origin. Arbitrary address bit operations retain derived metadata but
cannot establish a native address, so their inverse casts are unsupported,
including when their virtual result happens to be zero.

Address-derived integer metadata survives integer stores, aggregate copies,
union views, and byte-memory operations. Proven same-allocation address
subtraction and known-alignment remainders may become ordinary numeric values.
Other derived integers cannot be published by `#run` as native constants;
materialization rejects them before transactional effects commit. This avoids
publishing a virtual address that native code could mistake for a real address.
Using an absolute-address-derived number as an index, pointer offset, or other
execution parameter is also unsupported: discarding its metadata there could
turn a virtual-address-dependent selection into an ordinary published value.

VM addresses deliberately differ from native absolute addresses. A nonnull
pointer narrowed to an integer is explicitly unsupported by the VM because
its virtual address cannot establish whether the native address would fit.
Native integer pointer sentinels are supported, but their unknown addresses
remain outside VM execution. These boundaries are incomplete compatibility,
not a promise to reproduce arbitrary native address manipulation.

`offset() + pointer()` evaluates the integer call first. Typed pointer offsets
scale by the target element stride. `*void` offsets and differences use byte
stride, lowering through a checked `*u8` view; offset results retain `*void`.

## How to change it

Source conversion rules live in `jai-sema/src/pointer_conversions.rs` and
pointer operators in `pointers.rs`. Native conversions live in
`jai-codegen/src/pointer_conversions.rs`. Changes also require IR kind/type
verification and VM `Number`, address-region, byte-image, and materialization
handling. Never replace address provenance with a numeric-token heuristic.

The static Ivo examples `12.7_struct_align.jai` and `18.2_static_arrays.jai`
show pointer-to-integer alignment checks. Focus `src/build_system.jai` uses
integer byte addresses. No supplied compiler, native library, or object is
executed as reference evidence.
Focus `modules/Simp/bitmap.jai` offsets the result of `alloc` and subtracts two
such pointers; the supplied Basic `alloc` signature returns `*void`. This
source evidence establishes byte arithmetic without introducing an unsized
GEP or weakening the IR's sized-pointee rules.

## Configuration

The selected LLVM data layout determines native pointer width. The VM uses
`ByteTarget.policy`, including pointer width, alignment, and byte order.
Source literal casts use the selected semantic target layout; the fallback
profile is LP64. No pointer-conversion-specific environment variables exist.

## Dependencies

This feature depends on `jai-types` integer normalization and target layout,
`jai-ir` conversion and ordered-offset nodes, VM typed provenance and byte
memory, source `#run` publication, Inkwell's safe conversion builders, and the
`jai-llvm` checked GEP bridge.
