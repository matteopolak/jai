# Typed constant annotations

## What it is

Constant declarations retain a full `TypeSyntax` annotation and check their initializer against its canonical `TypeId`. Named aliases, floating-point types, records, arrays, strings, and procedure values use the same annotation machinery as other typed declarations.

Record members also accept `TRUE:s32:1;` and named annotations such as `NONE:Word:41;`. The second colon creates a constant member rather than an instance storage field. Ordinary `value:s32=9;` members retain their field layout and initialization behavior. The record parser retains the same annotated constant syntax used by file and local declarations.

## How it works

The parser preserves the original annotation in `ConstantDeclaration.ty`. For example, `Word :: u16; answer: Word : 42;` resolves `Word` in the declaration's defining scope before checking the integer range. The annotation is not replaced with a scalar spelling or guessed from the initializer.

Graph preparation first follows primitive aliases by declaration identity in each alias's defining file. Their canonical type facts are available when array counts or other value-dependent type declarations need a constant. Annotations that depend on nominal or aggregate types resolve after aliases and enum declarations are available. Primitive constants retain their checked integer, boolean, or float value; decimal expressions round at the declared float width. The declaration identity also records the canonical type fact for read-only annotation queries and record-field inference.

Record, array, and string literal constants bind with the annotation as their contextual type after record definitions and defaults are ready. Their dependency declarations materialize first, using the existing constant depth and cell budgets. Checked aggregate constants remain immutable values; accessing a field does not create writable storage.

Local annotations resolve through `lexical_annotation`, including actual local shadows. Procedure annotations retain the original declaration environment and callback contract proof. Deferred `#run` initializers receive the resolved expected type without changing their effect or readiness scheduling. Compile-only Code values use their metadata registry rather than a runtime constant representation.

Pure graph evaluators accept their existing builtin scalar bridge. An annotation that needs semantic type resolution produces a pending semantic request; it is not discarded or cloned into an import consumer's scope. Read-only `type_of` queries resolve explicit constant annotations without evaluating their initializer.

The source regression suite is `crates/jai-sema/tests/typed_constant_annotations.rs`. Its 17 passing cases exercise aliases, contextual literals, callbacks, local shadows, checked range failures, incompatible initializers, immutable aggregate constants, array-count dependencies, header queries, and typed `#run` publication. `crates/jai-codegen/tests/typed_constant_annotations.rs` checks the same typed-value path through actual native object emission: a mixed packed-record, array, string, distinct-value, float, and callback fixture produces 42 in both the VM and newly linked executables at O0 and O2.

## How to change it

Update the shared `TypeSyntax` resolver rather than adding new spelling checks to constant evaluation. Keep original annotations available for callback contract validation; canonical runtime types alone do not preserve every source-level obligation.

Primitive startup evaluation lives in `modules/constants.rs`; semantic phase ordering lives in `modules/prepared_session.rs`; aggregate literal binding lives in `modules/sequence_constants.rs`. Local constants and compile-time publication have separate adapters. When adding another compile-only domain, use its metadata representation instead of forcing it through `ConstantValue`.

## Configuration

There is no annotation-specific flag. The selected target and layout policy still govern target-dependent types and compile-time values. Existing compiler constant depth/cell limits and VM compile-time limits apply.

```sh
CARGO_INCREMENTAL=0 RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo test -p jai-sema --test typed_constant_annotations --offline --locked -j1
CARGO_INCREMENTAL=0 RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo test -p jai-codegen --test typed_constant_annotations --offline --locked -j1
```

## Dependencies

`jai-syntax` retains annotation syntax; `jai-modules` retains declaration and source identities; `jai-types` provides canonical types; `jai-eval` checks primitive expressions and contextual float rounding. Semantic literal/default handling, the callback proof ledger, compile-only metadata registries, and the compile-time VM supply checked values. Native lowering consumes the existing checked constants and does not need another IR expression variant.
