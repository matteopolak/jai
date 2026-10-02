# Discarded parameters

## What it is

`#discard` is a formal parameter evaluation contract. Calling expressions still undergo type checking, but discarded arguments produce no runtime evaluation or ABI slot and the procedure body cannot read their formals.

## How it works

```jai
assert :: (#discard condition: bool, #discard message := "") #expand {}
assert(expensive_check());
```

The supplied Basic module uses this form when assertions are disabled. The changelog describes the reason: `expensive_check()` must not run merely to call an empty assertion implementation.

`ParameterEvaluation::{Evaluate, Discard}` is retained on each source `Parameter` and `ProcedureTypeParameter`. It is independent of the declared type, defaults, variadic policy, and canonical storage signature. Checked source signatures must preserve all formals while ABI construction compacts the evaluated subset. Macro binding and ordinary call binding share the same contract; parser acceptance alone does not prove that execution obeys it.

Checked `Signature.parameters` retains discarded formals and their actual canonical types. `source_variadic` indexes this source list; the canonical `ProcedureType` describes only evaluated ABI slots. Call binding checks every supplied discarded expression with the pure argument descriptor and builtin domain checks, then emits only evaluated arguments. Discarded defaults retain requiredness through `ParameterDefault::Discarded`; header checking verifies the source initializer in its defining scope without executing it. Discarded variadic elements and spreads create no pack storage.

Concrete callback binding preflights discarded source slots before emitting any evaluated argument. An invalid discarded argument therefore cannot trigger an earlier evaluated `#run` while the compiler is binding the call. This uses the same source-position, named-argument and variadic checks as pure callback preview, while ordinary evaluated arguments retain their regular checking and execution path.

Required or optional parameter baking can retain a checked value in the specialization identity. `#discard` still makes that source formal unreadable in the body, including when baking removes the formal from the specialized source signature. Reading, taking its address, assigning to it, or asking for `type_of` diagnoses the discarded formal; the private specialization fact does not become a body value.

Procedure-type annotations with discarded formals retain an immutable `CheckedSourceProcedureType` proof containing the full source formal types. Its constructor verifies that filtering `Evaluate` produces the exact canonical parameters, calling convention, context mode, and runtime variadic descriptor. An annotation containing only evaluated formals already has its complete type proof in the canonical signature. The private ledger keys the original file or lexical procedure and scopes, original annotation node, specialization substitution, and target layout policy. `ContractSyntax` retains that origin and the proof across alias expansion, record fields, containers, and returned callbacks. An imported private nominal or a checked array count is consumed from its original producer proof; it is not resolved again in the caller's scope.

Pure checks of nested callback calls use the same source parameter metadata, including names, requiredness, dropped types, and source packs. If an inferred conditional callback combines different source evaluation policies at the same ABI, its call requires an explicit annotation; selecting one branch's policy silently would change which arguments execute.

Anonymous discarded `#run` procedures use a source statement fact pass. Returns, primitive declarations and assignments, blocks, conditions, and expression calls are checked without creating expression IR or executing the VM. The anonymous procedure has its own implicit context, including when its caller uses the C convention. Enclosing runtime storage remains an illegal capture, and a deferred body cannot return from its enclosing procedure. Statement forms lacking a pure rule report a located pending diagnostic. A quoted `Code` body keeps the language's deferred checking rules.

Annotations in this fact pass and discarded casts use ready named types and structural type construction. Fixed-array counts consume ready immutable scalar facts; a fresh count `#run` or nominal application reports that its source metadata is not ready. This prevents type checking from executing an expression whose source argument is discarded. Structural procedure casts retain the same full source formal proof as ordinary annotation producers, including discarded types and names.

An external data declaration inside an anonymous discarded `#run` checks its name and ready annotation, then reports pending provider metadata. The fact pass does not invent an external storage identity, initializer, or host read capability. Supporting this statement requires a pure checked external-provider fact adapter before it can bind a readable source value.

Discarded calls with context overrides check the actual source context field paths and types, duplicate overrides, and allocator shorthand without constructing a context copy or evaluating override expressions. The pure callback binder uses an already checked canonical type together with its retained source contract; canonical ABI slots alone cannot describe discarded argument positions.

## How to change it

`jai-syntax/src/parameter_evaluation.rs` parses the prefix and owns source grammar tests. `procedures.rs` attaches the policy before reading the formal name and annotation. Keep source spans inclusive of `#discard`; duplicate prefixes, result-slot use, and misplaced directives are errors.

The semantic procedure-signature and macro owners must preserve this policy through generic specialization, aliases, callback bindings, named arguments, defaults, and variadic forwarding. A discarded formal needs a checked unreadable binding, rather than an initialized temporary. Tests should use observable argument effects to distinguish omitted evaluation from merely ignored results.

`jai-sema/src/discarded_parameters` owns compatibility, builtin expression domains, and the anonymous-run statement fact pass. `procedure_values/bind_arguments.rs` separates source positions from compact runtime IDs; `preview.rs` supplies the corresponding pure callback check. Annotation producers in local and graph type resolution must record every checked source formal before erasure. Extend `source_annotations.rs` and `contracts/syntax.rs` together when adding environments, so proof lookup always uses retained defining identity.

`jai-sema/tests/discarded-parameters.rs` covers observable runtime and `#run` effects, defaults, named aliases, variadic packs, imported private types, source-policy differences at equal ABI, and unreadable formals. The matching `jai-codegen/tests/procedure_values.rs` fixtures compare VM results with freshly emitted and linked native programs.

## Configuration

There is no parser flag that changes the policy. Build parameters can select an assertion declaration through a source conditional, but the selected declaration's explicit evaluation metadata determines call behavior. The legacy scalar parser rejects `#discard` until checked source signatures are available.

## Dependencies

The source contract uses `jai-syntax` procedure metadata, `jai-source` spans, checked call/signature binding, macro expansion, and canonical ABI construction. It adds no external library and executes no supplied native compiler artifact.
