# Native record storage

## What it is

Named struct and `Any` LLVM values retain semantic fields and explicit interior
and tail padding. Known padding bytes survive whole loads, stores, copies,
captures, and internal direct or indirect procedure arguments and results.

## How it works

Every named struct requires selected target data. Its physical LLVM body contains
a zero-sized alignment carrier and a packed typed payload. Byte arrays cover
layout gaps, while semantic `FieldId` identities map to payload indices or
selected-target byte offsets. Physical carrier and padding members never become
source members, C ABI leaves, or DWARF members.

Complete ordinary construction zeros backing before applying initializers.
`OrderedRecord` validates every nominal path, terminal type, offset, and extent
before emitting an initializer. It then evaluates and stores each journal entry
before evaluating the next, preserving repeated and interleaved overlapping
writes. `OrderedRecordBacking::Uninitialized` skips backing initialization.

The storage-cast completeness guard remains in place. Explicit padding satisfies
it because all bytes are physical value members; genuinely implicit padding still
fails. A raw Place source copies actual bytes without loading unread tail bytes.
Record constants keep typed pointer and procedure relocations. The common record
constant adapter can return a layout-equivalent anonymous physical initializer for
a nested procedure-bearing union. Direct nonzero union StaticData recipes remain
rejected by the sealed StaticData builder.

Before constructing a record LLVM body, lowering checks its aggregate extent
against the selected pointer address space. In particular, two `[2147483648]u8`
fields are rejected on ILP32 even though each field is individually admissible.
Placed foreign by-value records are rejected recursively through record, array,
and distinct storage edges until alias-aware C ABI classification is proven.
Pointer edges remain opaque and admissible.

## How to change it

Change `types.rs`, `records.rs`, `aggregates.rs`, and `static_data.rs` together.
`TypeLowerer::record_constant` requires exact canonical constant field types;
`record_field_path` validates the actual nominal owner before returning the
physical payload path. Never use source ordinals as outer LLVM indices.

Keep C ABI classification and debug members based on semantic field types and
selected offsets. Extend ordered constant recipes separately from ordinary record
maps: a final map cannot reconstruct an original `a=1, b=2, a=42` journal.
Partially overwriting a relocation requires a checked representability rule.

The focused native fixtures are `canonical_storage`, `canonical_type_paths`,
`foreign_abi`, `foreign_custom_records`, and `static_layouts`, plus the lowerer and
ABI library tests. Execute freshly generated objects with installed Clang at O0
and O2; cross-target object classification establishes no cross-target execution.
The private prototype's recorded 32 tests are prior evidence, not a receipt for
the current integrated compiler.

## Configuration

Use the repository pinned nightly toolchain, installed LLVM 22, offline locked
Cargo, and `CARGO_INCREMENTAL=0`. The integration owner serializes the shared
Cargo target. Private checks require at least 2 GiB free disk space and must not
create duplicate giant caches. There are no feature switches or new dependencies.

## Dependencies

Storage uses `jai-types` nominal layout, checked `jai-ir` expressions, Inkwell,
LLVM TargetData, and the authored `jai-llvm` typed GEP and debug bridge. Native
checks compile authored C and freshly generated objects with trusted installed
LLVM and the system SDK. Supplied compiler, linker, object, or library artifacts
are never used.
