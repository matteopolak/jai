# Canonical callback preview

## What it is

Callback preview validates a call against its canonical procedure signature and available checked source contract without lowering runtime expressions or executing source effects. Lambda overload previews use it to reject invalid nested callback arguments before earlier outer `#run` arguments execute.

## How it works

`procedure_values/preview.rs` checks the callback's calling convention and context, source argument binding, and each argument's contextual conversion. Retained metadata supplies names, defaults, variadic policy, and check-only `#discard` formals independently of runtime ABI slots. Nested lambda arguments are previewed under the parameter's actual procedure type. It returns the signature's real result types; a void call returns an empty result list.

The preview does not reserve a procedure, synthesize a declaration, or infer missing callback parameter types. Operations needing source binding policy report its absence explicitly. A strongly annotated named lambda retains the annotation's genuine checked contract for both preview and runtime binding; its intrinsic lambda parameters remain separate from that outer source policy.

## How to change it

Extend `crates/jai-sema/src/procedure_values/preview.rs` when supporting additional source callback contracts. Keep argument feasibility pure and use the same conversion rules as ordinary binding. Add negative source tests with a counted compiler-effects service so a rejected callback cannot accidentally execute an earlier `#run`.

`polymorphism/integration/arguments.rs` supplies direct procedure result previews and routes indirect source calls through the canonical check. Preserve calling-context checks when extending result preview to void or multiple-result expression contexts.

## Configuration

There are no flags or environment variables. The canonical `ProcedureType` determines parameter types, result types, calling convention, and context requirements.

## Dependencies

This service uses `jai-types` procedure descriptors, the semantic argument description and contextual conversion services, retained source lambda environments, and the shared procedure context checker. It does not invoke the VM or native backend.
