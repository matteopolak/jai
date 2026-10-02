# Record self types

## What it is

`#this` in a record field type denotes that record's actual nominal type. For a parameterized record it denotes the concrete instance being defined, so `Node(int)` and `Node(u8)` retain different pointer types.

## How it works

The parser retains `TypeSyntax::This`, including beneath pointer, array, and descriptor constructors. Record materialization reserves a canonical `TypeId` before resolving fields and supplies that identity through an explicit annotation context. Anonymous and local records use their own reserved identity rather than their containing record's identity.

```jai
Node :: struct(T: Type) { next: *#this; value: T; }
```

The context restores its previous owner after every field resolution, including errors. Procedure type headers and record parameter declarations enter a forbidden context that nested annotations cannot reopen. A standalone `#this` type fails with an enclosing-record diagnostic. A self reference by value still fails the registry's normal recursive-storage checks.

The nine passing source tests in `crates/jai-sema/tests/record_self_types.rs` cover ordinary, generic, anonymous, and local identity, incompatible instances, recursion, and forbidden contexts. They also check that a procedure annotation can reference a separately defined self-referential record without inheriting its field context. The native fixture in `crates/jai-codegen/tests/record_self_types.rs` produces 42 through the VM and newly emitted native executables at O0 and O2. Parser tests live in `crates/jai-syntax/tests/self-type-annotations.rs`.

## How to change it

The annotation context lives in `modules/aggregates/parameterized/self_type.rs`. Keep owner selection at actual record-field resolution sites in `materialize.rs` and `local_declarations/records.rs`. Do not derive a self type from a printed name or create another nominal identity.

Procedure annotation helpers must retain their forbidden context while resolving nested types. Expression-level `#this` has a separate source-expression producer and should not be substituted for this type leaf.

## Configuration

There is no feature flag. The selected target determines storage as usual; a pointer to `#this` has the existing target pointer layout.

```sh
CARGO_INCREMENTAL=0 RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo test -p jai-sema --test record_self_types --offline --locked -j1
CARGO_INCREMENTAL=0 RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo test -p jai-codegen --test record_self_types --offline --locked -j1
```

## Dependencies

`jai-syntax` preserves the source type leaf. The nominal registry, record specializations, and lexical declaration arenas supply existing identities. Pointer checking, VM memory, and native lowering consume the resulting ordinary checked pointer types.
