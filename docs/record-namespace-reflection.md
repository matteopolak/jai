# Record namespace reflection

## What it is

Record reflection describes physical fields and checked type declarations in a nominal namespace. Type constants now have real immutable `Type` storage and reflection rows; general scalar/procedure namespace constants and interleaved source-member ledgers remain separate integration work.

## How it works

The selected original member sequence is the source of order, names, notes, and locations. A compile-time conditional, case, or inserted declaration can change this sequence, so reflection must consume the same successful selected snapshot as layout and ordered construction. Sorting spans or iterating a namespace map cannot reconstruct that order.

A physical member retains its canonical `FieldId`, declared type, and target byte offset. A namespace declaration retains its actual source declaration identity and a checked declared type. Scalar constants need their original annotation or pure source expression facts: their value alone does not establish the declaration's type. A nested type occupies a runtime `Type` pointer cell with a certified descriptor identity. A procedure constant uses its actual published procedure and complete signature.

The source `Type_Info_Struct_Member` contract distinguishes these storage roles. A constant has the constant flag, no physical instance offset, and an offset into `Type_Info_Struct.constant_storage`. Physical fields have their target instance offsets and no constant-storage offset. Notes and imported, using, and `#as` flags retain their checked source facts.

Constant storage must remain a heterogeneous typed backing object. Its computed target layout supplies each cell's byte offset; procedure and type cells retain relocations to their actual targets. A checked byte view exposes the backing through the source `[]u8` field without flattening pointers into guessed integers or changing the underlying cells. The staged byte-view proof binds the object, canonical backing type, target policy, and exact range.

The implemented Type namespace subset reads the original checked `source_member_names` and their canonical `BakedValue::Type` bindings. It accepts the namespace only when every non-field entry has such a binding. Unknown, pending, scalar and method entries retain the unsupported-members diagnostic. This includes the actual nested `Array_Type` and `Flags` enums in the adopted Preload schema; their spelling does not exempt them from storage.

Each accepted row has the source name, canonical `Type` descriptor, constant flag `1`, and target offset into `constant_storage`. The backing is a fixed array of actual `Type` relocation cells. A certified byte view spans its complete selected-target layout. Descriptor validation independently checks the array identity, cell count and type, every represented descriptor, exact offsets, byte range, policy and reflection row. These rows follow the physical fields and retain namespace declaration order within this supported subset.

Descriptor publication validates the source member identity, declared type, storage recipe, and referenced descriptor headers before minting runtime `Type` identity. Incomplete signatures, initializers, or selected namespaces remain real dependencies. An unsupported declaration cannot disappear from an otherwise successful descriptor.

Record reflection policy affects the immutable description. `NO_TYPE_INFO` omits members; `PROCEDURES_ARE_VOID_POINTERS` changes a reflected procedure edge while preserving its actual field or constant-cell type and layout. Previously published snapshots retain their policy. A later committed change requires a new descriptor recipe before final native publication.

That revision must preserve nominal runtime `Type` equality across snapshots. The current comparison uses descriptor addresses, so a replacement header cannot acquire a new semantic identity merely because its payload changed. Ordinary pointer equality and the final native descriptor-address mapping need separate checks.

## How to change it

The shared selected-source snapshot belongs to record materialization and local declaration registration. Extend it with actual canonical field or declaration identities at successful source selection, and reuse its captured defining environment for type and value preparation. Do not derive a new capture from debug output or the eventual caller.

`jai-types` owns immutable member descriptions and physical type checks. Semantic preparation owns source declaration and callable readiness. `jai-ir` owns checked constant recipes and static backing/address proofs. `jai-sema/src/reflection/storage.rs` serializes those facts into the adopted descriptor schema; the VM and native emitter consume the same typed storage relationship.

`ReflectionMetadata::record_type_constants` accepts a complete checked Type-only namespace and removes its unsupported-member marker. Do not call it with a filtered list. Extend the source adapter and immutable graph model together for other constant kinds; the payload validator must continue checking their actual typed relocation cells before publication.

Keep source eligibility distinct from storage dependencies when adding runtime-info tables. A backing record or descriptor array does not become a source-visible table row merely because reflection interns it. Extend tests with interleaved fields, nested types, constants, and procedures, then exercise actual VM and native byte offsets under both pointer widths.

## Configuration

The selected target layout and byte order govern backing offsets and relocations. Source reflection settings use the canonical monotone record policy; the source textual flag values are 8, 16, and 32. Metadata and static-storage budgets still apply when `NO_SIZE_COMPLAINT` suppresses a size warning. There are no environment variables for namespace reflection.

## Dependencies

This feature uses original `jai-syntax` member trees, `jai-source` provenance, canonical `jai-types` fields and signatures, semantic declaration readiness, static-data publication, the VM memory model, and native target layout. It introduces no external service or library.
