# Shared type registry

## What it is

`jai-types` provides a program-owned registry for scalar, aggregate and procedure type identities. The aggregate registry is infrastructure for semantic resolution; its descriptors do not mean the compiler already accepts aggregate source programs.

## How it works

`TypeRegistry` interns structural types: equal pointers, array sizes, slices and procedure signatures receive the same `TypeId`. Records, enums and distinct variants receive fresh nominal identities when their declarations are reserved. Semantic name resolution must reserve each declaration once and map its `DeclarationId` to that type; spelling and field shape never establish nominal equality. Ordinary aliases reuse a type identity.

Reserve records before resolving fields so pointer-recursive definitions can refer to each other. Complete each definition once, then consume the builder with `freeze`. Freezing rejects incomplete definitions and cycles through by-value fields, fixed arrays or distinct representations. Pointers, slices, dynamic arrays and procedure references break those size dependencies. An iterative worklist handles deep dependency graphs without recursive Rust calls.

IDs retain their registry identity. APIs reject IDs from another registry, even when their numeric indices coincide. Frozen `Types` owns immutable descriptors shared by later passes. Checked integer values preserve their exact enum representation; duplicate numeric enum aliases are permitted.

Both mutable and frozen registries expose `scalar(ScalarType)` and `float(FloatType)` for the same Boolean/integer and float builtin IDs. Freezing retains those IDs explicitly, so scalar IR views can join the shared type registry without depending on builtin arena indices or rebuilding a canonical map. Float value operations and bit identities are documented in [typed float values](float-values.md).

`TypeView::lookup(&TypeKind)` retrieves an already interned structural type in constant time. Freezing moves the validated canonical map into `Types`, so immutable place construction can recover an existing pointer or sequence type without scanning descriptors or creating an ID from an index. Foreign constituent IDs and uninterned forms return `None`. Nominal record, enum and distinct declarations intentionally have no canonical entry; retain their declaration's `TypeId` and check it with `kind` instead.

`lookup_procedure(&ProcedureType)` also retrieves an existing signature without
mutating the registry. Mutable and frozen views use the same signature map;
the parameter types, results, convention, context, and variadic metadata all
participate in equality. This permits read-only callback matching while keeping
actual signature construction in `TypeRegistry::procedure`. An uninterned
signature or any foreign constituent identity returns `None`.

The universal `Any` type has one lazy identity per compilation. `reserve_any()` returns the same `TypeKind::Any(RecordId)` reservation on repeated calls. `any_type()` returns `None` until reservation and `Some(id)` afterward; descriptor readiness is still checked through `record_storage_definition`. `define_any(id, header_type)` requires a completed local struct descriptor and fixes the storage fields to `[*header_type, *void]` with default record layout. Failed header checks leave the reservation available for a corrected definition. The caller supplies the real reflection header identity; the registry does not synthesize a `Type_Info` declaration or resolve it by spelling. Its canonical lookup entry is the explicit universal builtin, independent of ordinary record declarations.

Runtime `Type` values hold a descriptor pointer and use the selected target's pointer size. The checked reflection catalog explicitly calls `bind_runtime_type_header(header)` once with its completed nominal struct. Repeating the same binding succeeds; foreign, pending, non-struct and different-header attempts fail without changing the relation. Freezing preserves that header identity. `RuntimeTypeSchema::from_view` provides an opaque proof containing the metatype, exact header and canonical pointer-to-header IDs; it reports `Incomplete(Type)` until the relation exists. Neither source spelling nor an equal-shaped record can establish this relation. The proof contains identities, not an address encoding. See [type values](type-values.md) for runtime storage and reflection materialization.

`TypeKind::record_storage_id` and `record_storage_definition` cover both ordinary records and Any storage. `record_definition` retains its nominal-record contract. Field identities and owner checks work for both storage forms, so an equal-shaped user record does not acquire universal conversion behavior or exchange Any field IDs. Any also keeps its semantic tag when classifying procedure calls. Its pointer fields participate in the existing layout and dependency worklists; a descriptor header containing Any has finite storage because the return edge is a pointer. The borrowed payload and lifetime rules are handled by the [universal value proof](any-values.md), checked IR and execution consumers.

Definition validation is transactional: a rejected field or enum value leaves the reservation available for a corrected definition. Unions require finite by-value members just like structs. Regression tests include a 20,000-record forward dependency chain, so the freeze walker must traverse the whole graph before any record is complete.

`TypeView` gives read-only access to either a mutable `TypeRegistry` or frozen `Types`. Its `kind`, `lookup`, builtin accessors and nominal/procedure queries use the same arena-owned IDs. The `*_definition` convenience methods accept the enclosing `TypeId` and check its kind. `procedure_type` avoids shadowing the existing mutable `procedure(signature)` constructor. A reserved record, enum or distinct variant returns `TypeError::Incomplete` with its owning type ID. A completed descriptor may still refer to another pending type, so callers must query dependencies as their work demands. Unrelated pending definitions do not prevent reading a ready signature or record. This supports demand-driven semantic and compile-time consumers; the trait itself does not implement a scheduler or virtual machine. Final consumers still receive the single frozen `Types` owned by their program.

`field(record_type, ordinal)` returns a checked `FieldDescriptor { id, ty }`. Its opaque `FieldId` binds the ordinal to a nominal `RecordId`, including the compilation arena. `field_type(id)` recovers its declared type; `validate_field(base_type, id)` also verifies the base record owns that field. Equal-shaped records cannot exchange field IDs. The descriptor retains only runtime field type/identity: source names, visibility, defaults and locations remain declaration metadata. Reverse owner IDs let both views validate fields in constant time before reading an ordinal.

`define_record_with_placements` also constructs owner-bound field identities inside the transactional definition operation. Its anchors select strictly earlier fields of the actual reservation, and `RecordLayout.field_placements` retains them after freezing. Direct layout metadata checks those same owners before publication. See [record placement layout](record-placement-layout.md) for cursor arithmetic and the separate source/storage integration boundary.

```rust,ignore
let view: &dyn jai_types::TypeView = &registry;
let field = view.field(record_type, 0)?;
assert_eq!(view.validate_field(record_type, field.id)?, field.ty);
```

Procedure identity includes ordered parameter/result types, calling convention and context behavior. Names, defaults, visibility and source locations belong to declaration metadata outside the registry. Field names and initialization plans likewise belong to semantic declarations; the registry records ordered runtime field types. Layout stays in the [target layout engine](type-layout.md).

Distinct variants use `reserve_distinct(DistinctKind)` followed by `define_distinct(type_id, representation)`. `TypeKind::Distinct(DistinctId)` and the ready `distinct_definition(type_id)` preserve the wrapper's nominal identity; their descriptor contains only `kind` and `representation`. `DistinctKind::Distinct` records strict wrappers such as `#type,distinct u32`. `IsA` records `#type,isa` variants whose semantic conversion policy allows decay toward their base. Equal representations do not make wrappers equal, and reading representation must not turn an arbitrary wrapper into an implicitly interchangeable scalar. Initialization, explicit casts and allowed directional decay belong to the semantic checker and checked IR. Layout follows the representation without changing its outer type ID.

The inspected `reference/how_to/180_type_variants.jai` demonstrates numeric literals and same-wrapper arithmetic for strict variants, one-way `isa` chains, distinct arrays and nominal record wrappers. Recent sgpu uses `#type,distinct u64` for GPU addresses; Vk-Engine wraps both `u64` and its `UUID` record. The registry therefore does not restrict representations to scalars. Definitions reject compile-time-only/no-storage representations and foreign IDs transactionally. Representation cycles are by-value cycles; a wrapper represented by a pointer to itself remains finite. Tests also cover a 10,000-wrapper forward chain.

`ProcedureType::variadic` participates in canonical signature identity. `Variadic::None` is an ordinary signature. `C { fixed_parameters }` excludes the source pack from stored parameters and records the fixed ABI count; the registry requires C convention and a count matching `parameters.len()`. `Jai { parameter, element }` keeps a `Slice(element)` pack slot at the source parameter index; the registry checks the index, element arena and exact slice type. Later named/default parameters can remain after this slot; their names/default behavior stays declaration metadata. Invalid pack metadata never enters the canonical map. The calling convention determines representation rather than the shared `args: ..T` source spelling.

Pinned Focus source establishes both forms: Objective-C `objc_msgSend` has a foreign `..Any` pack, `IMP` is a `#c_call` variadic type, and `panic` has a Jai pack followed by a named default `exit_code`. The older print tutorial demonstrates forwarding with `..args`. Metadata alone does not implement `Any` boxing, default promotions, pack construction or foreign calls; those require checker, interpreter and backend support with separate acceptance evidence.

## How to change it

Add canonical forms to `TypeKind` and validate their constituent IDs before interning. Add nominal forms through reservation and completion, with explicit finite-size dependency edges. Keep invalid or incomplete states inside the mutable builder. Extend tests for identity, cross-registry rejection, recursion and completion before consumers rely on a new form.

New descriptor queries must work through `TypeView` for both builder and frozen storage. Preserve reservation owner IDs through `freeze`, and construct field IDs only through checked registry queries. An incomplete result means the caller should wait for the declaration dependency; it must not guess a field type or copy a partial definition into another registry. Test views before completion, after corrected definitions and after freezing, including foreign IDs and unrelated nominal owners.

The narrower integer/Boolean `ScalarType` remains a convenience for domain operators; richer types use arena-owned IDs. Consume this registry through checked expressions and places rather than adding a parallel aggregate storage system. Source, interpreter, native execution and foreign ABI acceptance are tracked separately from descriptor support.

## Configuration

The registry has no environment settings. One builder owns one compilation program; imported module instances share it while retaining distinct nominal declarations. `Void` and captured `Code` cannot occupy runtime storage. Target-specific sizes and alignments come from layout policy rather than this registry. Runtime Type storage requires the explicitly adopted reflection catalog; an unrelated Any declaration does not supply that relation.

## Dependencies

`jai-types` and the Rust standard library. Future consumers are semantic resolution, constant evaluation, target layout and the LLVM backend.
