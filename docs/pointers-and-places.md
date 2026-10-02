# Pointers and places

## What it is

Pointer values retain their pointee `TypeId`; places describe addressable local,
global, record-field, indexed, and indirect storage. The semantic resolver,
checked IR, virtual machine, and LLVM backend share these identities.

## How it works

`*value` takes a place's address and `pointer.*` denotes the pointed-to place.
The parenthesized operator forms `(.*) pointer` and `(.*)(pointer)` construct
the same typed dereference, including for assignment targets. They bind at unary
precedence and evaluate the pointer operand once; see
[source forms from recent projects](project-source-forms.md).
For a type-valued operand, `*Pair` constructs a pointer type instead; reflection
can therefore inspect `size_of(*Pair)` without accessing runtime storage.
`null` has no inferred pointee type and acquires one from a pointer declaration,
argument, return, cast, or comparison. Pointer equality compares identity;
conditions test whether the pointer is non-null. Logical operators preserve
short-circuit evaluation. `ifx` pointer branches retain contextual types, so
`p: *int = ifx ready then *value else null;` selects a pointer without evaluating
the unused branch.

Pointer addition and subtraction scale an integer offset by the target element
stride. Void-pointer arithmetic uses a checked byte view and retains the void
pointer type after offsets. Subtracting matching pointers returns a signed element distance;
one-past array pointers may be compared or subtracted and cannot be read.
The VM uses allocation handles and typed projection paths, so these
operations never manufacture or dereference a Rust host address. It checks
allocation bounds, lifetime, and the actual storage type before access. LLVM
uses native pointers and typed GEP instructions through the small `jai-llvm`
bridge. Indexed arrays, slices, dynamic arrays, and strings check bounds by default.
An explicit source opt-out can omit the native index/count check; VM allocation
and lifetime checks remain active. Native pointer dereferences and pointer indexing trap
on null; raw native pointers do not carry allocation bounds or lifetime metadata.

Explicit pointer casts change the pointee view while preserving allocation
identity, including casts to and from `*void`. The VM still requires valid
typed storage before dereferencing. Same-width integer and floating views
preserve scalar bits on reads and writes. Allocation-relative byte views use
the configured target byte order, field offsets, and alignment; byte-pointer
offsets advance one byte, and writes remain visible through other aliases.
Opaque pointer slots retain relocations instead of host-address bytes.
Passing or assigning a typed pointer to `*void` performs implicit erasure;
recovering a typed view requires an explicit cast, including contextual `xx`.
The selected LLVM boolean storage is `i1`; byte aliases read its low bit in both
engines, so writing byte `42` reads as false and `43` reads as true.
Explicit pointer/integer casts use target-width native addresses and typed
virtual-address provenance in the VM. See
[pointer integer conversions](pointer-integer-conversions.md) for narrowing,
unknown-address, and compile-time publication boundaries.

Address computations and index expressions retain source order. Assignment
targets must remain addressable; temporary record values and string bytes do
not provide mutable storage. Compound stores must capture the target address
once before evaluating the right operand.

## How to change it

Extend `jai-sema/src/pointers.rs` for source rules and
`jai-codegen/src/pointers.rs` for native operations. Changes to pointer or place
nodes also require `jai-ir` verification and matching `jai-vm` execution.
Keep storage identity separate from loaded value snapshots. Reinterpreting a
pointer must not weaken VM allocation provenance or lifetime checks.
Indirect native loads and stores use conservative alignment unless the place
retains stronger provenance, which keeps pointers to packed fields valid.
Run `cargo test -p jai-sema --lib pointers::tests` for source typing and checked
VM failures, and `cargo test -p jai-codegen --test pointers` for source-to-native
and VM agreement. The native suite selects the real LLVM target before semantic
resolution, compiles fresh fixtures, and executes only generated programs.

The supplied `Preload.jai` is static source evidence for typed pointers and null
initializers. Pinned `jaison/typed.jai` and `generic.jai` demonstrate pointer
view casts, including checked pointer reinterpretation; Focus `session.jai`
casts typed storage to byte pointers. No supplied compiler or native library is
executed to establish behavior. Conservative unsupported cases are diagnosed
instead of borrowing host representation assumptions.

## Configuration

Pointee layout and stride come from the selected target `LayoutPolicy` and LLVM
data layout. VM byte views use `ByteTarget`, including explicit endianness;
the default VM profile is little-endian LP64. There are no pointer-specific
environment variables. The VM's
allocation limits and execution fuel apply to indirect access as to other
operations.

## Dependencies

This feature depends on `jai-types` identities and layout, `jai-ir` place and
expression verification, `jai-vm` typed memory, Inkwell, and the audited
`jai-llvm` builder bridge. Foreign pointer arguments additionally depend on
the selected calling convention's ABI lowering.
