# Callable aliases in overload groups

## What it is

A constant alias to a procedure can join an existing overload group. This supports declarations such as `print :: print_to_builder;` alongside ordinary `print` procedures without creating a wrapper procedure or changing the target's declaration identity.

## How it works

The module loader defers conflicting declarations or imported links when both are callable candidates and at least one is a constant with a name or qualified-name initializer. This is a pending classification, not a promise that the alias is callable. Proven procedure and prototype declarations can merge directly, including imported candidates; ordinary scalar and type collisions retain their errors.

The loader resolves ready alias families before publishing semantic condition or case requests, and retries after registering dependencies. A target from a later import or load remains pending until discovery supplies it. Pure scalar guards can still select their loads during this phase. Final module publication rejects unresolved targets. Forward references, alias chains, module qualification and private visibility follow normal graph lookup. Cycles, scalar targets and type targets fail at the original alias declaration. A successful overload set contains deduplicated original procedure or prototype declaration IDs. Constant alias declarations remain in the source arena for semantic annotation and metadata checks.

Module-local and exported membership are merged separately, so adding a private alias does not export it. An explicit alias or imported callable group retains its original target declarations. Those candidates join only the importing destination's overload family, and each target's body and defaults continue to use its defining file.

## How to change it

Graph classification and finalization live in `jai-modules/src/loader/callable_aliases.rs`. Preserve both discovery-time readiness and final validation. Resolve a queued family with its exact destination scope and name: different private and export families can temporarily share the same first procedure declaration. Binding equality alone would leak private candidates. Resolve pending target families before publishing their consumers, and retain every original declaration. Broader alias expressions need an actual checked semantic contract; do not admit arbitrary constants by name alone.

Semantic callable selection lives in `jai-sema/src/modules/scope.rs`, `modules/scope/imports.rs`, and procedure-constant alias preparation. Preserve the target signature, default arguments, defining environment and checked source annotations. The graph proof does not mint a new procedure or authorize a foreign provider.

Eleven focused graph regressions pass, covering forward targets, exported/private membership, explicit qualified targets, invalid scalar/type targets, cycles, private-member rejection, a 6,000-link alias chain, multiple queued declarations, pending target families, pure conditional loads, and imports reached after a guard. Full Basic and File acceptance remain separate source and runtime gates.

`jai-sema/tests/callable-alias-groups.rs` checks named/default arguments, private imported default environments, reuse of the original generic specialization, and a compile time guard reached before module finalization. It also loads the unchanged reference `Basic/Print.jai` when available and checks the retained discovery graph for the actual `print` and `print_to_builder` procedure declarations while retaining its alias constant. Unrelated source using requests may still be pending. The corresponding native fixtures in `jai-codegen/tests/procedure_values.rs` compare the VM result with freshly compiled application output. The reference graph check does not check or execute the full Basic implementation.

## Configuration

There are no feature flags. The usual module search paths and source visibility affect resolution. Run the focused graph tests with `cargo test -p jai-modules --lib callable_alias --locked`.

## Dependencies

The source declaration arena, typed module/file/declaration IDs, ordinary graph lookup, overload sets, and the semantic procedure-signature and source-contract registries. No original executable or native library is needed.
