# Baked macro targets

## What it is

`#bake_arguments` binds named constant arguments on an existing source callable. Supplied Bit_Array uses it to define `only_set` and `only_unset` from the original four-parameter `only_set_or_unset` expansion.

The source parser helper and checked macro binder are prepared in narrow modules. Public expression activation and target registration remain pending; these helpers alone do not establish source acceptance or execution of a baked alias.

The isolated component checkpoint `artifacts/component-checkpoints/baked-argument-parser-20261002T135343Z/validation.json` records three passing parser-helper tests. It retains the captured source hashes, exact snapshot-only registration migration, locked validation inputs, logs, and own test executable hashes. This proves the prepared helper's span and application-boundary behavior; it does not establish live expression activation, semantic binding, or iterator execution.

A second isolated checkpoint, `artifacts/component-checkpoints/baked-collection-syntax-20261002T135906Z/validation.json`, activates the proposed AST and prefix only in its retained snapshot. Two tests pass: the complete unchanged supplied Bit_Array file parses with both actual aliases and all four original target formals retained, and the qualified prefix preserves its source ranges. The integrated compiler still needs live consumers, semantic alias binding, and execution validation.

## How it works

The syntax payload retains the actual callee expression, ordinary named argument sources, complete call range, and directive range. It preserves computed or qualified targets so semantic checking can diagnose unsupported targets without discarding their source. Parsing stops after the binding argument list, leaving a later invocation or binary operand to ordinary expression parsing.

The semantic binder keeps the original parameter index and checked binding for every supplied argument. Formal annotations resolve in the original expansion's defining environment; values resolve in the alias's defining environment. Ordinary values require typed constant conversion. Type arguments keep their canonical TypeId, and Code arguments keep an explicit captured Code identity. Duplicate names, unknown formals, runtime values, spreads, discarded parameters, and unsupported packs produce located errors.

Protocol selection must retain the genuine expansion identity and full original source procedure. It derives the remaining source, Code, and flags formals from the actual bound indices. It must not rewrite the header into a three-parameter procedure or allocate a runtime wrapper for a source expansion.

Alias resolution retains the actual module or lexical declaration identity before selecting the underlying macro. Its cycle stack checks those identities and shares the existing expansion depth budget; aliases cannot evade the limit by postponing macro selection. Every source-environment switch and stack entry must restore on both success and a located error.

The pending consumer bundle at `artifacts/pending-components/baked-target-adapters-20261002T152817Z/` retains eleven captured source files and an exact patch. It stages original-index bindings, protocol selection, and source-alias resolution without live registration. Module aliases use an isolated definition resolver with empty caller frames and the genuine defining file; lexical aliases use their retained declaration environment. Verified formal names shadow outer captured names, while unrelated definition facts remain intact. Rustfmt parsed this bundle; it has not been compiled and provides no baked-alias execution evidence.

## How to change it

`jai-syntax/src/baked_arguments.rs` owns the prepared source payload and prefix helper. `jai-sema/src/metaprogram/baked_expansions.rs` owns named constant binding. Target registration belongs to the Code registry and genuine module or local declaration lookup; ordinary macro argument binding and custom iteration must both consume the same retained target metadata.

Keep alias lookup in its defining lexical environment, including imported namespaces and captured generic substitutions. Check active source branches after binding constants. Bit_Array's active unset branch assigns to a by-value iterator, conflicting with the modern constant-reference contract described by the pinned looping tutorial; a dormant body or a successful set-only test cannot establish unset execution.

## Configuration

No new compiler flags are planned. Existing source checking policy, constant conversion limits, macro cycle limits, defining file scopes, and captured Code rules apply.

## Dependencies

`jai-syntax` retains source expressions and call arguments. The semantic formal annotation resolver and constant interner retain canonical types and constant values. The existing macro capture registry and pure protocol matcher retain definition identity and lexical substitutions. Runtime acceptance uses the Rust VM and LLVM backend on programs generated by this compiler.
