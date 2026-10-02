# Shared type registry

## What it is

`jai-types` provides a program-owned registry for scalar, aggregate and procedure type identities. The aggregate registry is infrastructure for semantic resolution; its descriptors do not mean the compiler already accepts aggregate source programs.

## How it works

`TypeRegistry` interns structural types: equal pointers, array sizes, slices and procedure signatures receive the same `TypeId`. Records and enums receive fresh nominal identities when their declarations are reserved. Semantic name resolution must reserve each declaration once and map its `DeclarationId` to that type; spelling and field shape never establish nominal equality. Ordinary aliases reuse a type identity.

Reserve records before resolving fields so pointer-recursive definitions can refer to each other. Complete each definition once, then consume the builder with `freeze`. Freezing rejects incomplete definitions and cycles through by-value fields or fixed arrays. Pointers, slices, dynamic arrays and procedure references break those size dependencies. An iterative worklist handles deep dependency graphs without recursive Rust calls.

IDs retain their registry identity. APIs reject IDs from another registry, even when their numeric indices coincide. Frozen `Types` owns immutable descriptors shared by later passes. Checked integer values preserve their exact enum representation; duplicate numeric enum aliases are permitted.

Both mutable and frozen registries expose `scalar(ScalarType)` for the same Boolean/integer builtin IDs. Freezing retains those IDs explicitly, so scalar IR views can join the shared type registry without depending on builtin arena indices or rebuilding a canonical map.

Definition validation is transactional: a rejected field or enum value leaves the reservation available for a corrected definition. Unions require finite by-value members just like structs. Regression tests include a 20,000-record forward dependency chain, so the freeze walker must traverse the whole graph before any record is complete.

Procedure identity includes ordered parameter/result types, calling convention and context behavior. Names, defaults, visibility and source locations belong to declaration metadata outside the registry. Field names and initialization plans likewise belong to semantic declarations; the registry records ordered runtime field types. Layout stays in the [target layout engine](type-layout.md).

## How to change it

Add canonical forms to `TypeKind` and validate their constituent IDs before interning. Add nominal forms through reservation and completion, with explicit finite-size dependency edges. Keep invalid or incomplete states inside the mutable builder. Extend tests for identity, cross-registry rejection, recursion and completion before consumers rely on a new form.

The existing scalar semantic IR still uses its narrower integer/Boolean types. Its migration must consume this registry through checked expressions and places, rather than adding a parallel aggregate storage system. Runtime floats, records, enums, pointers and metatype values remain pending language work.

## Configuration

The registry has no environment settings. One builder owns one compilation program; imported module instances share it while retaining distinct nominal declarations. `Void` and the currently compile-time-only `Type` descriptor cannot occupy runtime storage. Target-specific sizes and alignments come from layout policy rather than this registry.

## Dependencies

`jai-types` and the Rust standard library. Future consumers are semantic resolution, constant evaluation, target layout and the LLVM backend.
