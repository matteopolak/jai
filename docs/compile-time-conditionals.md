# Compile-time conditionals

## What it is

Procedure and block `#if` select source statements during semantic resolution. Both source branches must parse, but only the selected branch binds names, checks types, schedules runs, or generates executable IR.

## How it works

The parser retains `CompileTimeIf { condition, then_body, else_body }` and the original statement byte ranges. It accepts braces, a single statement, and `else #if` chains. This follows the supplied `reference/how_to/095_static_if.jai`: the braces “do not create subscopes,” and inactive bodies still require valid syntax.

The resolver registers unconditional declarative names before evaluating guards so forward local constants remain visible. A finite worklist retries an unresolved guard after another selection supplies declarations; when no selection progresses, it reports the original failure. A guard binds in its defining file, module instance, and lexical environment. Its typed expression is converted to a condition, checked for runtime storage and implicit calls across all operands, then evaluated by the checked Rust VM with compiler effects disabled. Explicit `#run` operands use the ordinary checked procedure readiness phase and materialize their results first; pending dependencies and execution failures remain real compilation diagnostics.

Scoped imports supply guards only after their source position. Selection temporarily applies each visited import, resets that environment for retries, and restores it before normal lowering. Selected declarations keep the import environment at their source position, including imports introduced by a preceding selected branch.

Standalone `using` prefixes apply their checked publication during the same source walk. Selection consumes the published names and operators without rerunning a mapper or runtime target. Pending runtime aliases still shadow file constants, so an unresolved local name cannot accidentally select a branch using a same-named file value. Prefix snapshots restore these facts between retries and lexical scopes.

Type queries remain constant without reading runtime storage. A pending explicitly typed fixed array's `.count` comes from its declared type, so selecting a branch does not execute its initializer. Local enum expressions with contextual members, including target tag comparisons, use typed constant evaluation and retain their nominal identity. Procedure values require only their signature metadata. Constant global addresses and their field or constant-index projections use the current place snapshot and selected VM byte target; runtime loads and local addresses remain inadmissible. Global metadata is supplied only when a guard needs it, keeping unrelated global initialization out of ordinary scalar and target conditions.

Selected statements retain their original wrappers and are spliced into the enclosing block. Selected declarations are registered in that lexical scope, so names can be used after the conditional. Inactive declarations never reserve types, procedure identities, or variable names. Splicing also preserves enclosing loop control, return reachability, and deferred cleanup: a selected `defer` executes when the enclosing scope exits. No runtime `If` or new IR variant represents the selection.

Pure constant diagnostics use an active quotation's retained source identity before falling back to the defining file. A failing expression inserted from another file therefore reports its original source in both current-scope and explicit-scope insertion modes.

Promoted record construction can use ordered expression bindings to retain each initializer's original evaluation position. The purity walk checks every binding producer before its body, including producers whose resulting field is not read by the guard. The owned VM proof then verifies each bound reference's procedure owner, lexical scope, and type before evaluation. A hidden runtime load or implicit call in another field therefore cannot bypass guard purity.

```jai
main :: () -> int {
    #if ENABLED { answer := 42; }
    else { answer := missing_runtime_name; }
    ENABLED :: true;
    return answer;
}
```

Target values `OS`, `BUILD_OS`, `CPU`, and `BUILD_CPU` use the explicitly selected graph target. They keep the nominal identity and assigned member values of the designated Preload source enums. An isolated frontend with bootstrap disabled may supply those enums in its defining scope. Ordinary lexical declarations and module parameters retain normal shadowing. Missing target facts or source tag schemas produce diagnostics rather than host-derived defaults.

## How to change it

Extend `jai-syntax/src/statement_conditionals.rs` for syntax and `jai-sema/src/compile_time_conditionals.rs` for selection or permitted constant operations. Keep purity traversal exhaustive when adding expression IR variants. Register declarations before binding guards, preserve original source spans, and never pre-bind an inactive branch. `local_declarations.rs` separates declaration registration from eager resolution for this purpose; other callers retain the combined wrapper.

`modules/target_values.rs` supplies source target values; enum constant classification routes expressions referencing them through typed constant evaluation. Keep source enum identity separate from numeric tag spelling. The semantic tests exercise Windows, Linux, and macOS selection with the complete authored compiler prelude; native tests execute only independent source and newly emitted host objects.

## Configuration

`ModuleGraph` target facts and `ResolveOptions.target` must agree. `ResolveOptions.compile_time_limits` bounds pure guard evaluation and explicit runs. Module instance parameters and normal file/private constants remain part of the defining environment. The feature introduces no environment variables.

## Dependencies

`jai-syntax`, `jai-modules`, `jai-source`, `jai-types`, `jai-ir`, and `jai-vm`. Native verification additionally uses the existing LLVM backend and configured host Clang. Reference compiler binaries, native objects, and libraries are neither executed nor loaded.
