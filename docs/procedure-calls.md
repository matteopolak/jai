# Procedure calls

## What it is

Source calls bind typed parameters, named arguments, checked defaults, variadic packs and ordered results. Direct procedures and indirect callback values share one argument binder while retaining their separate source binding metadata.

## How it works

Signatures resolve definition-scope defaults, infer omitted parameter types, and check constants against their parameter types. Binding matches positional arguments by index and named arguments by symbol, rejects duplicates and unknown names, then supplies omitted defaults. Integer arguments use checked implicit conversions; booleans require boolean values. Aggregate, sequence and procedure arguments retain their registered type identities.

Typed calls store explicit expressions in source order with a `ParameterId` destination. The VM and LLVM evaluate those expressions in that order before rearranging values into parameter order. Indirect calls evaluate their callee once. This preserves effects when named arguments reverse their destinations. Constant defaults are materialized from checked values; deferred caller locations use the actual call site, as described in [caller locations](caller-locations.md).

Callback names, defaults and [required-result contracts](result-obligations.md) belong to source bindings rather than canonical ABI type identity. [Procedure values](procedure-values-and-context.md) describes callback annotations, inferred metadata, calling conventions, C promotions and Jai variadic descriptors. [Procedure results](procedure-results.md) describes multiple-result destinations and evaluation order. [Procedure overloads](procedure-overloads.md) covers overload matching and specialization.

## How to change it

Extend `jai-syntax` parameter/call parsing, semantic signature construction and the shared `jai-sema/src/procedure_values/bind_arguments.rs` binder together. Keep evaluation order distinct from parameter order. `calls.rs` selects direct targets; `procedure_values.rs` checks indirect targets against canonical signatures and per-binding metadata. New call forms must also participate in result-use enforcement and source-span propagation.

Arbitrary runtime expressions and references to mutable parameter values are not declaration defaults. Unsupported default forms must receive a diagnostic; never replace them with a zero value. A positional argument after a named argument is rejected except where the declared variadic pack rules explicitly permit it.

## Configuration

There are no feature flags or environment variables for ordinary argument binding. Calling convention and context modifiers, parameter types, defaults, variadic annotations and result contracts come from source declarations. Native target configuration affects ABI lowering.

## Dependencies

The implementation uses `jai-syntax`, definition-scope module and local metadata, `jai-eval` for pure default evaluation, `jai-types` for canonical types and conversions, and checked `jai-ir` calls. Independent VM and native fixtures establish the implemented cases; they do not establish complete standard-library or corpus compatibility. Native tests link freshly generated LLVM objects through independently installed Clang.
