# Anonymous source procedures

## What it is

Full procedure expressions retain an explicit source signature and a real body, for example `(value:s32)->s32 #c_call { return value+2; }`. The parser preserves the actual source signature and the semantic binder publishes an ordinary checked procedure value.

## How it works

`CallableHeaderSyntax` owns parameters, results, calling convention, context, deprecation and notes once. A source procedure adds body policies and a body; a prototype instead has its external/intrinsic/compiler binding and has no body or invented source-body policies. Named procedures attach a real source name and operator identity to the same source payload used by anonymous expressions.

The semantic header preview produces checked components without inventing a procedure ID or executing defaults. Ready annotation facts establish the canonical signature; unresolved effectful annotations retain readiness requirements. Only then does reservation assign a real anonymous procedure ID from its source span and canonical type. Completing that identity binds source defaults and callback/result contracts.

Named and anonymous bodies share the concrete child resolver. It preserves defining scopes, parameter evaluation policies, named results, context, checks, debug policy, notes, alignments and compile-time pending channels. Anonymous source receipts keep their original location and no declared name. Runtime local captures are rejected by the existing storage-owner checks; ordinary constants and global storage remain available.

## How to change it

The syntax helpers are `source-procedures`, `source-procedure-headers` and `anonymous-procedures`. The semantic factors are `local-declarations/source-headers` and `local-declarations/source-bodies`. Both named and anonymous consumers use those helpers. Do not convert a full procedure expression into a short lambda or a fabricated named declaration: both would lose actual source metadata.

Keep source registration, deprecation, phase/demand guards and publication outside the common body helper. Merge child compile-time pending work on success and failure. Changes to the header must update named source and genuinely bodyless prototype constructors together. Ownership moves must read the shared payload explicitly; forwarding field access cannot introduce another authoritative copy.

The retained private candidate passed 176 syntax library tests, three authored parser tests, six source/VM test functions and four native test functions. Nine authored fixtures returned 42 at O0 and O2 with VM agreement. Those results establish the private snapshot, not the current integrated compiler. The current integrated source/VM suite passes ten tests. It additionally covers actual nominal record and pointer identities in both aggregate globals and aggregate constants, direct procedure globals, reads and writes of global storage, discarded anonymous defaults, and negative runtime-parameter/record captures. Same-layout records with different nominal identities remain incompatible callback parameters. Native parity and quotation-budget gates are recorded separately.

The private candidate still failed a global aggregate initializer containing an anonymous callback in the early scalar defaults evaluator. Such initializers need retained jobs with the actual declaration, file, expected type and reserved global identity; they bind after header readiness. Pure callback checks reuse the statement-preview service with ordered result metadata and named/discarded formal facts. An invalid capture must fail before an earlier effectful `#run` argument. Unsupported pure preview rules, including using formals, retain precise diagnostics. Local authored tests do not establish complete acceptance of the unchanged Focus or graphics-project sources. The original Focus listener declarations use aggregate constants (`listener :: Listener.{...}`), so global initializer tests alone are insufficient. The whole unchanged listener files and their containing module are probed separately; the saved [b1b82044 baseline](../artifacts/anonymous-procedures-original-focus-b1b82044.json) records preactivation parser failures and verifies their source hashes.

The source syntax represents a named `Procedure` as `{name, operator, source}`, a bodyless `ProcedurePrototype` as `{name, header, binding, span}`, and a full expression as `ExpressionKind::AnonymousProcedure(Box<SourceProcedureSyntax>)`. New constructors, including synthetic modifier procedures and authored prototype fixtures, must move parameters and results into their single header owner. Semantic expression lowering, pure callback previews, deferred declaration classification and aggregate expected-type lowering handle the new expression. Quotation admission visits the entire anonymous source header and body before retaining a clone; named and anonymous source payloads share that visitor, preserving the existing limits. Bodies remain lexical declaration owners and are deliberately not evaluated during dependency classification. The existing checked runtime procedure-value IR remains authoritative; no parallel anonymous runtime representation is introduced.

## Configuration

There is no feature flag. Existing target layout, compile-time effect policy, safety and optimization settings continue to apply to real checked bodies.

## Dependencies

The syntax procedure parser, the canonical `jai-types` procedure registry, lexical declaration identities, source callback contracts, the concrete body resolver, source-run receipts, checked `jai-ir` procedures, VM execution and native ABI lowering.
