# Procedure source queries

## What it is

`#this` identifies the actual enclosing source definition, and `#procedure_name` obtains a statically known procedure's declared name. The source query adapters and authored fixtures are staged; their expression parser and integration hooks have not yet been activated.

## How it works

Local headers and anonymous procedure binding retain source identities independently of debug output. A named identity records its actual procedure, complete canonical signature, original source location, and declared symbol. Aliases follow their target identity. An anonymous identity keeps its original location and has no invented source name.

Inside a real procedure, `#this` is its checked procedure value. Inside a record definition, it denotes that actual reserved nominal type. Procedure headers and record parameter lists forbid the query to avoid a circular signature dependency. Data-scope identity needs its own typed representation before that source form can be supported.

`#procedure_name()` is equivalent to `#procedure_name(#this)`. The source contract evaluates it after macro expansion, so a macro used in `worker` obtains `worker` rather than the macro's declaration name. `reference/CHANGELOG.txt` records this at line 4069, and `reference/how_to/050_this.jai` demonstrates passing the embedding procedure through a profile macro.

An explicit operand must identify one statically known procedure. A ready procedure alias preserves its target's original name; ambiguous overloads, runtime callback storage, and operands that would execute a call remain errors. A pending local shadow cannot fall through to a same-spelled module procedure. The query does not run its operand or manufacture a callable identity from its type.

A pure contextual lambda preview may know the lambda's complete expected signature before a real procedure has been reserved. It exposes only that type fact for `#this`; it cannot emit a caller procedure value or invent a name. Inferred signatures remain unavailable until their actual results are checked.

## How to change it

`crates/jai-sema/src/procedure_queries.rs` owns query checking and lowering. Local source facts live in `local_declarations/procedure_sources.rs`; the staged module adapter follows genuine declaration and specialization origins. Update the expression parser, runtime binder, pure argument descriptions, dependency walkers, and semantic constant classifier together when activating the source leaves.

Preserve the real `expression_owner` guard for runtime values. Keep pure lambda preview facts separate from it, and restore preview context on every result. Extend tests with imported aliases, overload ambiguity, anonymous procedures, local shadows, original quote locations, and macro caller identity. The three staged authored fixtures cover recursive calls, declared names through aliases, and embedding procedure names; they each expect 42 once the adapters are activated.

## Configuration

These directives require no environment variables or flags. Debug suppression does not remove source identity. Their type and source-readiness dependencies use the ordinary semantic pipeline; unsupported or pending metadata cannot become a guessed name or procedure ID.

## Dependencies

The queries rely on `jai-syntax` source expressions, `jai-source` symbols and locations, checked `jai-types` signatures and nominal identities, semantic source identity registries, contextual lambda preview, and ordinary procedure-value IR. They introduce no external service or library.
