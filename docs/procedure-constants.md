# Procedure constants

## What it is

Procedure constants are immutable references to checked source procedures or prototypes. They can initialize global callbacks, aggregate fields, and declaration defaults without converting a function address into a data pointer.

## How it works

`ConstantKind::Procedure(ProcedureId)` identifies the target; its enclosing `ConstantValue.ty` is the canonical procedure signature. That signature includes parameter and result types, calling convention, context mode, and variadic representation. Parameter names, defaults and [required-result annotations](result-obligations.md) belong to the source binding and do not change ABI identity.

```jai
answer :: () -> int { return 42; }
Holder :: struct { callback: () -> int = answer; }
callback: () -> int = answer;
main :: () -> int { value: Holder; return value.callback(); }
```

Source headers must register procedure identities and signature facts before inferred callback fields or defaults are resolved. Default evaluation looks up typed values by their defining `DeclarationId`, preserving imported scopes and preventing equal-spelled declarations from being confused.

Positional aggregates such as `Allocator.{allocator_proc, null}` preserve each typed initializer and apply field defaults to omitted trailing fields. An inferred callback field or global keeps the defining procedure's argument names and defaults; an explicit callback annotation supplies its own names.

IR publication verifies every nested procedure constant against the actual body/prototype signature ledger. A type-shaped value alone cannot prove that its `ProcedureId` exists or has the declared signature. The VM keeps the procedure identity and signature directly. Native lowering declares demanded functions before constructing global or context initializers, then emits their addresses from the identity-indexed function map.

Global and context procedure constants are native reachability roots. Constants nested inside arrays, records, distinct values, unions, or static object graphs also retain their targets, including descriptor graphs carried by runtime `Type` values. Foreign callbacks retain external prototypes. Bodyless `#compiler` requests and explicitly `#compile_time` bodies cannot be reached through runtime callback storage; the VM can execute a compile-time-only body's actual implementation.

## How to change it

Update the constant node in `jai-ir/src/storage.rs`, conversion in `expressions.rs`, and both shape and environment verification when extending the representation. Keep procedure identity distinct from data-pointer provenance, and never substitute a null value when a declaration has a nonnull default.

Source default evaluation lives in `jai-sema/src/modules/aggregates/defaults.rs`; local literal constants share `Resolver::literal_constant`. `BakedValue` keys include both canonical type and procedure identity. Persistent compile-time replay metadata uses the source declaration origin and captured substitution rather than serializing a transient numeric procedure index. A captured runtime `Type` constant records its represented source type and exact primitive layout sizes/alignments so changed workspace target options cannot reuse the same replay key.

Update `jai-vm/src/constants.rs`, `jai-codegen/src/aggregates.rs`, and `native_reachability.rs` together. LLVM emission must resolve through the declared function map; reconstructing a symbol name from source spelling loses foreign symbols and exports.

## Configuration

There are no additional environment variables. The declared callback signature controls ABI/context compatibility; a cast must retain that exact canonical signature. Omitting a callback initializer still produces a typed null default.

Run source parity fixtures with `RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo test --offline -j1 -p jai-codegen --test procedure_values`. The native tests compile fresh objects from the independent compiler and link them with the installed LLVM toolchain.

## Dependencies

This feature depends on `jai-types` canonical procedure types, module declaration identities, checked IR publication, VM procedure providers, and LLVM function declarations. Foreign constants preserve library/prototype metadata without loading a reference native library.
