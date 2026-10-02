# Aggregate type resolution

## What it is

`Nominals` resolves graph declarations into the common type registry before procedure bodies are checked. Records, enums, and named distinct type variants have identities tied to their graph `DeclarationId`; transparent aliases refer to the target `TypeId`.

## How it works

Record identities are reserved before field dependencies are resolved, allowing a field such as `next: *Node`. Enum representations resolve to an integer type, including through an alias, before the enum identity is reserved. Names always resolve through the declaration's defining `FileInstanceId`, so equal names in different module instances remain distinct.

Definite syntax such as `Width :: u32` is a type alias. Ambiguous constants such as `Alias :: Other` or `Pointer :: *Other` become aliases when their dependency chain denotes a type; `Copy :: Number` remains a scalar constant when `Number` denotes a scalar value. `define_aliases` runs after scalar array-count dependencies become available. Cyclic aliases produce a diagnostic at the declaration that closes the cycle.

`Handle :: #type,distinct u32` reserves a separate nominal identity, while `Alias :: Handle` reuses that identity. `#type,isa` also reserves a separate identity and records its one-way relationship to the base representation. Both variants inherit their base storage layout; recording this metadata alone does not implement all runtime coercions and operators. Anonymous variants require a named alias until syntax-owned anonymous type identities are implemented. The supplied `180_type_variants.jai` documents literal conversion, explicit conversion, and `isa` ancestry rules.

Record metadata retains field declaration order, nominal `FieldId`, resolved field type, defining file, and the original field syntax. This lets later checking evaluate defaults in the correct scope. Pure enum constants and their aliases are checked before record shapes; a separate declaration-to-value-type map preserves their nominal type during field inference. These facts are not type aliases and do not enter the type-declaration namespace. Direct and nested enum-member defaults also preserve their enum type. Other inferred field types use the appropriate typed or scalar constant evaluator.

[Anonymous record and enum fields](inline-types.md) reserve identities from their source file, span, and enclosing record instance. They share named-record materialization through a borrowed source body, retain real field metadata and defaults, and leave reflection names absent. An anonymous field's identity stays stable while forward member bindings become ready.

Record layout syntax is checked in `modules/aggregates/layout.rs`. Field `#align` constants can override natural alignment, including reductions; record `#align` supplies a minimum alignment. `#no_padding` selects packed field defaults, while explicit field alignments remain effective. The target layout engine rounds final size to the resulting record alignment. The target-bound LLVM backend implements this storage policy with typed packed payloads, explicit padding, and alignment-aware field accesses. Foreign C aggregate classification supports custom layouts on the implemented Apple ARM64 and Linux System V x86-64 targets, with [independent C layout and marshaling checks](native-custom-record-abi.md). `#type_info_none` reports a diagnostic until reflection metadata suppression is implemented.

Enums retain their integer representation, flags status, ordered values, and member names. Initializers can refer to earlier members by plain name or by the enum's own qualified name. `#specified` requires every member to have an explicit initializer. Ordinary automatic values increment; flag values start at one and double. Explicit flag combinations are accepted, but automatic continuation after a nonpositive or combined value is rejected because that progression is not implemented. A terminal maximum value does not need a representable successor.

## How to change it

Edit `crates/jai-sema/src/modules/aggregates/types.rs` for reservation, alias classification, structural resolution, and metadata construction. Layout directive checking lives in `layout.rs`; alignment expressions must use the same supplied constant evaluator as array counts. Extend `types/tests.rs` alongside it for graph-to-registry checks. Tests cover identity across module namespaces, self pointers, aliases, enum scopes, cycle diagnostics, layout constraints, and terminal enum limits; they do not demonstrate native execution.

Keep reservation separate from definition. Resolving a self pointer must reuse the reserved record identity rather than allocate another nominal type. Alias dependencies must switch to the target declaration's defining file. Array counts must use the supplied constant evaluator so module parameters and scalar constants share the same scope rules.

`using` record fields are validated after all records have definitions; promotion edges must contain record values, remain acyclic, and expose no conflicting names. The [using fields](using-fields.md) document describes identity-path lookup. Unsubstituted type variables are rejected before structural resolution. Enum default initialization policy belongs to value construction rather than metadata reservation; metadata alone does not establish whether a nonzero first member should be a default.

## Configuration

There are no environment variables or resolver-specific flags. Graph import paths and module arguments determine which declarations and constants are visible. `TypeSyntax` selects pointer, fixed-array, slice, dynamic-array, or procedure structure; the array-count callback supplies compile-time integer values.

## Dependencies

The resolver depends on `jai-modules` for graph identity and lookup, `jai-syntax` for unresolved declarations, `jai-source` for source-aware diagnostics, `jai-eval` for scalar enum expressions, and `jai-types` for nominal reservation, structural interning, and typed field descriptors. Procedure-body checking and value construction consume the resulting metadata.
