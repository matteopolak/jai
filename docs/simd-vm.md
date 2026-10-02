# SIMD virtual execution

The SIMD VM executes canonical checked SIMD blocks as fixed-width numeric registers without host instructions. Register bytes belong to one block and never contain host addresses or survive as source values. Transfers, lane arithmetic and canonical block execution have independent regression tests.

## How it works

Vector transfers use the same allocation identity, lifetime, inherited pointer region, initialization, readonly and byte-budget checks as ordinary VM memory operations. Transfers are 16 or 32 bytes and allow unaligned addresses. A load snapshots the complete checked range before any later store, so overlapping source and destination ranges use the bytes captured by the load.

Numeric loads reject bytes carrying data-pointer, procedure or address-integer provenance. A store writes plain numeric bytes and invalidates provenance only in its destination range; untouched pointer fragments retain their existing provenance. Rejected writes leave the allocation image unchanged.

Float addition rounds each `f32` lane through the shared IEEE value domain, including signed zero, infinities and NaNs. Byte addition wraps each `u8` lane independently, without carrying into its neighbors.

The checked `DebugTrap` and `Arm64DebugTrap` instructions each consume one instruction fuel step and return `Error::RuntimeTrap`. This lets supported x86 `int3` assembly and ARM64 breakpoint bytes stop compile-time execution without raising a host processor trap. A block containing only traps does not depend on the VM memory target; native source ISA validation still belongs to the native backend.

The executor revalidates each block, charges one fuel step for each instruction, and evaluates each memory address exactly once. It also charges arithmetic register width and the complete allocation-image work before a memory transfer, so a tiny vector operation cannot clone a large root object with a tiny fuel budget. Its memory budget includes all declared registers and one replacement snapshot alongside live allocation storage. Stores check the combined budget before installing their new image. Register identities remain local to their validated block.

## How to change it

`crates/jai-vm/src/memory/simd.rs` owns checked register transfers. Reuse `Memory::intrinsic_range`, the byte-image initialization APIs and `Memory::install_intrinsic_image` when extending transfers; bypassing these helpers would lose inherited field bounds, immutable-storage protection or budget checks. Focused memory regressions live in `memory/simd/tests.rs`.

`crates/jai-vm/src/execute/simd.rs` owns lane arithmetic and its tests. Keep the shared `FloatValue` implementation as the authority for floating-point behavior and validate matching register widths before computing a result.

## Configuration

The VM's selected `ByteTarget` supplies target layout. Checked vector execution requires little-endian storage with 64-bit pointers, even when the host processor uses another architecture. Allocation, byte and fuel budgets come from `Limits`; each transfer is bounded to a 128-bit or 256-bit register, and the checked schema caps a block at 256 registers and 4096 instructions. Native target and AVX feature validation belong to the native backend. No SIMD instruction executes on the host processor.

## Dependencies

This implementation depends on checked `jai-ir` SIMD blocks, `jai-types` numeric semantics and target layout, and `jai-vm` virtual memory and provenance-aware `ByteImage` storage. It requires no external service or native library.
