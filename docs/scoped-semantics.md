# Scoped semantic resolution

## What it is

`jai-sema` resolves a `jai-modules::ModuleGraph` into checked scalar procedures and storage while retaining the graph's declaration and file boundaries. Imported libraries do not need their own `main`.

## How it works

`resolve_library(&graph)` returns a checked `Library` with procedures, global storage, one frozen `Types` registry and a `DeclarationId` lookup for procedures. `resolve_graph(&graph)` checks the same declarations and returns an executable `Program` after validating the application's entry point. That entry point must belong to the graph's root module, take no parameters and return `int` or `void`; an imported `main` cannot become the application's entry point.

Top-level constant values, global places and procedure metadata are keyed by `DeclarationId`. Symbols identify source spellings only. Each procedure body and each default or initializer resolves names from its declaration's `FileInstanceId`, using `ModuleGraph::lookup` for unqualified and qualified paths. Consequently two modules may declare the same spelling without sharing a procedure or storage slot. Reexports retain the original declaration identity. Lexical variables and constants shadow namespace roots.

```jai
Math :: #import "Math";
OFFSET :: 100;
main :: () -> int { return Math.answer(); }
```

```jai
// Math.jai
OFFSET :: 5;
answer :: (amount := OFFSET) -> int {
    LOCAL :: OFFSET;
    return amount + LOCAL;
}
```

The default for `amount` resolves to Math's `OFFSET`, regardless of the caller's `OFFSET`. Named, positional and default arguments use the same binder for both qualified and unqualified calls. Supplied arguments remain in source evaluation order while their parameter IDs identify destination slots.

An iterative constant dependency worklist follows graph declaration identities, including namespace paths. It detects cycles at the reference that closes the cycle. Block constants additionally use lexical scopes and can refer to defining-module constants, qualified imported constants and forward block constants. `jai-eval::evaluate_paths` binds every branch before executing arithmetic, retaining the existing short-circuit evaluation behavior. Mutable storage, procedure calls and aggregate expressions cannot yet supply compile-time values.

Graph privacy remains authoritative: module exports are the only members reachable through an imported namespace; module-private names remain inside that module; file-private names remain in their defining file. Semantic diagnostics wrap source-local spans with that file's source ID, including errors inside imported bodies and defaults.

## How to change it

Extend `crates/jai-sema/src/modules.rs` when adding new top-level declaration kinds or graph-level resolution phases. `modules/scope.rs` owns lookup adapters, and `modules/constants.rs` owns the dependency worklist. Store new metadata by `DeclarationId`; resolve its syntax through its defining file rather than through a caller environment. `FileScope` adapts graph bindings for the shared scalar body resolver in `lib.rs`, the call binder in `calls.rs` and block constants in `declarations.rs`.

The graph currently rejects parameterized imports and module parameter declarations explicitly. Record and enum declaration lowering, unresolved aggregate type annotations and aggregate expressions are also explicit semantic errors until their typed lowering exists. Do not skip these declarations or fabricate a library entry point to make checking succeed. The legacy `resolve(&syntax::Module)` and `jai-eval::evaluate` APIs remain compatible for independent single-file scalar callers.

Fixtures in `modules/tests.rs` cover equal spellings across modules, storage and procedure identities, qualified constants, defining-file defaults, mixed block constant dependencies, privacy, local namespace shadowing, imported diagnostics and application entry ownership. Native acceptance must use the checked `Program` and ordinary backend execution; these semantic tests do not establish native module behavior by themselves.

## Configuration

Semantic resolution adds no environment variables or flags. Import search directories and source dependency discovery belong to `jai-modules::GraphOptions`; the driver decides whether a request checks a library or builds an application.

## Dependencies

`jai-modules` owns source/module graphs and visibility. `jai-source` supplies declaration identities and source-aware diagnostics. `jai-syntax` supplies per-file ASTs and namespace paths. `jai-eval` evaluates scalar constants. `jai-types` supplies the shared registry, and `jai-sema`'s existing checked IR carries procedures, places and control flow to `jai-codegen`.
