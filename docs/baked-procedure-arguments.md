# Baked procedure arguments

## What it is

`#bake_arguments` retains constant bindings to named formals of an original source callable. The staged ordinary-procedure adapter constructs a checked callable with the remaining parameters and a body that calls the original target.

## How it works

The syntax producer preserves the callee, named argument expressions, and original source spans. Semantic bindings retain the originating declaration and defining file or lexical scope, the original formal ordinal, and each checked typed constant. A specialized generic target also retains the projection from its remaining signature to the full source header.

Each checked partial expression keeps the callee use's remaining parameter names, defaults, and result obligations, including metadata introduced by a callback cast. Baking matches those actual names while retaining the corresponding original source ordinal. The wrapper's direct call uses the original target's runtime `ParameterId` positions, including slots before and after a baked value, and preserves its calling convention and context mode. Discarded source formals have no runtime slot. The common procedure allocator reserves the wrapper, and ordinary IR publication verifies its actual body and signature.

```jai
multiply :: (a: float, b: float) -> float { return a * b; }
negative :: #bake_arguments multiply(b = -9);
```

Canonical wrapper keys include the original declaration, actual target signature, normalized constants, and executable callback policy. A checked callback cast can carry result obligations beyond its ABI type. Those per-use contracts must remain attached to the partial expression's actual producer; they cannot be recovered from the erased procedure constant or folded into a required-result-sensitive executable key. Constant declarations retain this checked producer policy under their original graph or local declaration identity. A narrowly checked closed binding can extract the constant procedure value, but extraction never discovers policy from that value or its interned constant identity.

The retained declaration policy also records its actual defining procedure's body revision. Strengthening that body's callback bindings refreshes the declaration's exact policy in its original environment, verifies that its checked constant value is unchanged, and preserves cached explicit `#run` results. A stored body failure remains terminal even when its revision token has not changed. The generic worklist retains a checked per-body invalidation revision; unrelated body changes do not refresh a declaration policy. Selected constant arguments retain their checked producer alongside the value for the same reason.

Callable cast constants retain the checked annotation policy under their actual declaration, just like partial constants. Named indirect calls carry that original source binding through argument defaults and returned callback contracts; an interned procedure value alone cannot reconstruct names or obligations.

The integrated parser and semantic context register the ordinary wrapper adapters together with source expression dispatch, constant previews, and callback producer transport. Source acceptance is checked with the ordinary baked argument fixtures; record template aliases retain their separate original record binder requirements.

A typed constant calls through its checked declaration contract even when its value is a generated procedure wrapper. Default arguments and result obligations belong to that original declaration; the shared physical procedure signature does not replace them.

File-level partial constants use this same original-scope semantic binder before publishing their value. Sending them through value-only compile-time materialization would discard their declaration contract.

## How to change it

`procedure_values/baked_arguments.rs` owns argument validation and real wrapper construction. The module and local `baked_sources.rs` adapters recover genuine source identities. Keep source dispatch and constant-preview consumers registered together. Never replace the original target with a smaller fabricated procedure identity or a bodyless prototype.

Parameterized-record partial aliases use `parameterized/partial_arguments.rs` to associate remaining arguments with original record formal identities. Their producer must capture typed values in the alias's defining environment and feed the original record binder in source order. Record modifiers run before the final specialization reservation; a partial alias must not turn an unapplied template into a runtime type. Readonly literal targets use a proof from the successful original application, retaining initial and accepted keys separately; see [parameterized records](parameterized-records.md).

Use the source fixtures in `tests/ordinary_baked_arguments.rs` when activating the path. They cover a middle baked argument, defining-scope constants, erased generic `Type` formals, cast names/defaults/obligations sharing one wrapper, C callbacks, implicit context, partial record aliases, per-use returned callback obligations, and a local baked constant refreshed inside a reused generic body. A helper unit test checks original runtime-slot projection; source and VM acceptance still require the integrated fixture run.

## Configuration

There are no new environment variables. Existing constant depth/cell limits and VM execution limits apply. The staged adapter rejects variadic targets until their original source-pack binding is retained.

## Dependencies

This feature uses `jai-syntax` source arguments, `jai-modules` declaration/file identities, canonical `jai-types` procedure signatures, normalized `polymorphism::BakedValue` constants, checked `jai-ir` procedure publication, and callback source contracts. VM/native consumers execute the resulting ordinary checked wrapper body.
