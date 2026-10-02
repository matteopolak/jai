# Canonical allocator schema

## What it is

The checked allocator schema identifies the actual Preload allocator's nominal record, mode enum, procedure signature and storage fields. Dynamic-array allocator projections must use this adopted type rather than create a structurally similar record.

## How it works

The source binder in `jai-sema/src/modules/allocator_schema.rs` obtains `Allocator` and `Allocator_Mode` from the selected Preload module's export table, then verifies that their declaration IDs belong to that module. It checks source `proc`/`data` field order and all eleven operation names before binding the sealed type proof. Application lookalikes and reexports from other modules cannot designate this role. Minimal bootstrap schemas may omit both declarations; omitting only one produces a located diagnostic.

`AllocatorSchema::validate` certifies a completed two-field struct. Its first field is the Jai procedure `(Allocator_Mode, s64, s64, *void, *void) -> *void` with implicit Context; the second is `*void`. The mode enum retains the eleven signed 64-bit operations from `ALLOCATE` through `CAPS`. Rust callers use `AllocatorMode` and `AllocatorField` for these choices.

The source binder must select the authentic Preload declarations before calling `TypeRegistry::bind_allocator`. Shape validation alone does not adopt an allocator role. Binding is idempotent for the same checked nominal identity and rejects a competing identity. Invalid, incomplete and foreign-arena inputs leave the role unchanged. `TypeView::allocator_schema` and frozen `Types` retain the same sealed proof and owner-bound field IDs.

Target storage is checked against the caller's `LayoutPolicy`: two pointer slots at offsets zero and one pointer width. Procedure values keep their actual Jai calling convention. This schema does not grant native execution or implement an allocator procedure.

Native caller-frame variadic return checks traverse the embedded allocator using its certified record type and the dynamic descriptor's actual fourth-field offset. A pointer hidden in allocator `data` receives the same escape check as descriptor `data`; neither a code pointer nor a guessed pair of pointer slots substitutes for the schema.

## How to change it

The schema and operations live in `jai-types/src/allocator.rs`; explicit registry adoption and freezing live in `registry.rs`. New source operations require corresponding typed modes and enum-contract tests. Changes to the allocator procedure require coordinated Preload, sequence, reflection and backend updates.

Source integration must preserve selected Preload declaration identities and field names. A local record named `Allocator`, or a matching layout in another module, must not replace the adopted role. Six core tests cover explicit adoption and freezing, pointer32/64 layouts, foreign/incomplete identities, ABI and parameter mismatches, invalid mode/storage, and equivalent empty layout metadata. Full source and dynamic-array projection acceptance are separate integration gates.

## Configuration

There are no feature flags. The selected Preload source controls adoption; the selected target layout controls pointer storage. Before authentic source adoption the role is absent, including in bootstrap-disabled compilations.

Run `cargo test -p jai-types allocator --locked` for the focused schema tests.

## Dependencies

The canonical type registry, nominal record and enum IDs, checked procedure signatures, owner-bound field descriptors, target layout engine, and the semantic Preload source binder. No external package or original executable is used.
