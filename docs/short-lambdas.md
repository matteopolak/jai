# Short lambdas

## What it is

A short lambda is a source procedure expression, such as `(key) => get_hash(key)`, `(a, b) => a == b`, or `value => { consume(value); }`. Its parameters remain unresolved syntax until a call or an expected procedure type supplies their types.

## How it works

The lexer already recognizes `=>`. The parser distinguishes a lambda header from a parenthesized expression by finding the matching `)` and checking the following token; a bare identifier followed by `=>` is a single unannotated parameter. It retains parameter names, optional annotations, and an explicit expression or statement-block body with original spans. A named `HashKey :: (key) => get_hash(key);` remains a constant declaration initialized by a procedure expression.

Semantic lowering resolves parameters from a canonical expected procedure signature, explicit annotations, or checked call argument types. It checks the source body in a child lexical resolver and infers expression results from their checked types when no expected result exists. Runtime `Type` results use the existing canonical reflection descriptor. Contextual block bodies use ordinary statement checking and return-flow validation; a block without value returns can infer a void signature. A value-returning block requires an expected result signature. The emitted value references a real `ProcedureId`; the same checked procedure arena supplies its body to the VM and LLVM backend.

Direct calls resolve annotations in the lambda's defining environment, then validate arguments in the caller's environment before materializing the body. An annotation supplies the context for null, leading-dot enum members, aggregate literals, and nested lambda arguments. Unannotated parameters use the argument's ordinary context-free type. Argument evaluation still follows source order through the ordinary callback binder.

An explicitly annotated lambda constant uses that annotation's checked source contract when called. Parameter names, check-only `#discard` formals, and result-use obligations belong to the annotated binding; the actual lambda body keeps its own parameter names and canonical runtime slots. The shared indirect binder consumes the contract directly, preserving erased argument policy without inventing formal types from the ABI.

Anonymous procedure identity includes its defining lexical scope, source span, and specialization signature. Contextual signatures and inferred parameter signatures use distinct cache keys, even when their canonical type happens to match. This keeps retries stable while allowing the same source expression to have distinct typed specializations. Lambdas retain lexical constants and types. True procedures reject outer runtime storage. The pinned [local-procedure example](../corpus/upstream/Ivo-Balbaert--The_Way_to_Jai/examples/17/17.2_local_procs.jai) explicitly records the original compiler's closure rejection; this implementation keeps that source-located diagnostic and the existing procedure ABI.

Source reflection retains the original lambda location and checked canonical procedure type without inventing a procedure name. An expected signature is available before checking the body; an inferred signature is recorded after its actual result is known. Pure recursive `#this` checking receives only that expected type and source span, with no runtime procedure identity. Actual body lowering uses its allocated procedure identity. This metadata is independent of debug emission.

Named module lambdas retain their original constant `DeclarationId` and defining file, while local and specialized-record namespace lambdas retain their lexical source environments. Unannotated module alias chains resolve to that original source. The readiness scheduler keeps these roots and pure aliases latent, but checks dependent calls and `#run` recipes normally. Standalone calls specialize the source before ordinary constant lookup, then use the existing result-discard binder. Recursive inferred bodies receive a diagnostic before re-entering the same unfinished procedure.

Callback overload selection previews source bodies in each concrete canonical callback context before lowering any source arguments. It validates parameter annotations, builtin expression domains, result conversion, lexical captures, and call context. Block preview uses the original statements and separate type facts for declarations, assignments, conditionals, while loops, deferred code, and return flow; it emits no IR and schedules no procedure body. Other statement forms need their own pure preview rule and currently receive a source diagnostic. Lexical safety overrides are restored after each nested check. A dependent callback such as `(T,T)->$R` first obtains `T` from the other arguments, checks the lambda body with those actual parameter types, and infers `R` from its checked result. Zero-result body calls infer canonical `void`. Named dependent callbacks use the same preview in their retained definition environment. [Canonical callback preview](callback-preview.md) checks nested positional indirect calls. Callback parameters whose types remain underdetermined receive explicit diagnostics.

Pure annotation preview constructs structural types from existing named types and immutable scalar facts. It does not evaluate fresh `#run` array counts or instantiate new nominal source declarations; those require ready declaration metadata. Procedure annotation proofs retain the original formal types, including discarded slots. Preview scopes, implicit context availability, source-header facts, and expression-owner authorization are restored on every result. A preview cannot materialize the caller's `#this` value or authorize a captured expression as the caller's procedure. Inferred block returns use the same numeric joins as conditional expressions, retaining weak integer ranges until the final type is selected. All-weak integer returns retain the canonical `s64` default; a range beyond that default needs an actual expected result type, such as a `(int)->u64` callback.

## How to change it

`crates/jai-syntax/src/short_lambdas.rs` owns syntax and source spans. `crates/jai-sema/src/short_lambdas.rs` owns contextual parameters, result inference, and body lowering. Its `block_preview` and `annotations` helpers check source feasibility without materializing values. Lexical source identity and the shared procedure allocator live in `local_declarations`; ordinary callback calls use `procedure_values` and its canonical signature contract.

Run the `short_lambdas` integration tests in `jai-sema` for source diagnostics and effect-free preview. The same test target in `jai-codegen` runs independently authored programs in the VM and freshly emitted native executables at O0 and O2.

Do not turn an unresolved parameter into a default integer type or invent a module declaration for a lexical procedure. Extend callable discovery through its defining source environment before adding new named or record-member forms. Runtime closure support would be a deliberate language extension; require reference-language evidence and an explicit environment representation, lifetime policy, and ABI across semantic IR, VM, and native lowering before changing capture rejection.

Variadic and multiple-result contextual signatures require a precise diagnostic until their source syntax and result binding are implemented. Preserve `ShortLambdaBodyKind::Block` as actual statement syntax when extending block inference; do not insert a placeholder expression. A procedure constant annotation supplies parameter and result context in its defining environment, for example `add: (u8)->(u16) : value => cast(u16)value + 2;`. A scalar annotation cannot describe a lambda procedure.

## Configuration

No environment variables or flags configure lambda inference. An expected callback signature determines calling convention, implicit context mode, parameter types, and result type. Uncontextualized typed expressions use the ordinary Jai calling convention and implicit context mode.

## Dependencies

Short lambdas rely on `jai-lexer`, source symbols and spans from `jai-source`, canonical `ProcedureType` identities from `jai-types`, lexical declarations from `jai-sema`, and ordinary procedure values and bodies in `jai-ir`. Execution uses the existing `jai-vm` and LLVM procedure backends.
