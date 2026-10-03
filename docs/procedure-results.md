# Procedure results

## What it is

Procedures return an ordered list of typed results. Multiple declarations and assignments consume those results without introducing a tuple value or evaluating a call repeatedly.

## How it works

The signature stores each result's type, optional source name, checked constant default, and source result-use contract. Named returns bind to result positions while their expressions run in source order. The resolver captures supplied values before returning the ordered list, so cleanup execution cannot change a returned aggregate snapshot.

`a, b := pair()` lowers to one `CallResults` with two private temporary destinations, followed by stores into the declared locals. `a, b = b, a` captures both destination addresses and both source values before either destination is written. Compound assignments also capture the original destination values before evaluating the supplied results. A destination named `_` discards its result while preserving the producing expression's execution.

Result counts and types must match. There is no implicit tuple type. Ordinary expression calls require zero or one result; several results require a result binding except when an expression statement discards only optional results. [Required procedure results](result-obligations.md) describes `#must` obligations for calls and `_` destinations. Named returns reject duplicate names and positional values after a named value. Missing results require a checked default.

Mixed declarations use an `=` marker on each existing destination: `result=, command := start_command()`. Unmarked names declare locals. The typed syntax distinguishes new bindings from existing places, so the resolver captures existing addresses and all results before declaring names or writing destinations. A type annotation applies to new bindings; existing destinations retain their declared types. Discards still participate in result positions and result-use checks.

The per-result colon form declares only marked slots: `success:, plugins_to_create:, args = parse_plugin_arguments(args)`. Here `success` and `plugins_to_create` are new inferred locals, while `args` is an existing destination. Both spellings lower to the same checked destination enum and preserve evaluation order; new names remain unavailable to the producing expression.

Lexical constant result groups retain one initializer and an ordered list of names: `IS_INTEGER, SIGNED, BITS :: #run is_integer_type(T);`. Each name owns a lexical declaration identity and projects an output from one shared compile-time call transaction. Result count, discard obligations and every output type are checked before commit; binding retries reuse the cached result vector. Current groups require a direct or qualified `#run` call initializer.

After the first named projection executes, the resolver materializes and publishes every named sibling into its registered declaration entry together. Otherwise each newly bound projection changes the lexical cache key and can execute the initializer again. Siblings are selected by their shared registered declaration object in the defining frame; separate shadowed groups keep independent executions. Discard-only groups still execute through the checked result provider.

## How to change it

The shared call argument binder lives in `crates/jai-sema/src/procedure_values/bind_arguments.rs`; `results.rs` consumes its checked call and signature. Keep one call execution separate from the individual result destinations. Extend indirect multiple-result calls through the same checked signature contract rather than constructing one call expression per result.

Return binding lives in `cleanup.rs`. Keep source evaluation order separate from signature order. Preserve snapshots before deferred cleanups and before assignment writes, especially when source and destination places overlap.

Mixed binding lives in `results/mixed.rs`; preserve the callback contract metadata when moving a captured result into its final destination. Newly declared names must not become visible while resolving the producing expressions.

An existing callback binding keeps its established source annotation, including optional result use, when receiving a callback with a different source contract. Copy that contract to the captured destination address as well; use the incoming callback contract only when the existing binding has no established contract.

Constant group projections live in `local_declarations/constant_results.rs`. Keep one lexical identity per name and one common compile-time transaction per initializer; validate every output before publishing any binding. Use the shared source execution provider and effect cache so binding retries cannot repeat effects.

Keep sibling publication atomic: construct all named bindings before updating declaration entries, and preserve each entry's scope watermark. Do not remove lexical capture facts from the general run cache to make projection keys match. `jai-codegen/tests/constant_results.rs` checks execution counts, forward references and shadowed groups through the actual generated native program and interpreter.

## Configuration

No additional flags or environment variables are required. Procedure result declarations and their optional names/defaults determine binding behavior.

## Dependencies

The feature uses `jai-syntax` result and assignment syntax, `jai-types` canonical procedure signatures, scoped declaration metadata from `jai-modules`, and `jai-ir` typed places, `CallResults`, and `ReturnValues`. The native backend and compile-time interpreter consume the same checked result list.
