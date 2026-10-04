# Frontend header grammar

## What it is

The held frontend header bundle preserves callback defaults, omitted procedure annotations, C++ return ABI flags, grouped globals, variadic formals, and record namespace directives as original source facts. It is assembled privately with the earlier literal, reflection, loop, and placement syntax packets; the live compiler has not activated these schemas.

## How it works

A callback type parameter has `ProcedureTypeBinding::Required(TypeSyntax)` or `Defaulted { ty: Option<TypeSyntax>, expression }`. For `major := 0`, the annotation stays absent and the actual default expression remains owned by the binding. For `flags: Flags = .NONE`, both original annotation and default remain available. `annotation()`, `annotation_mut()` and `default()` expose those facts to visitors. A result followed by `=` leaves that token for the enclosing field initializer, preserving existing callback field defaults.

An omitted source parameter annotation becomes `ParameterBinding::Unannotated`; it does not receive an invented type. Baked procedure packs retain their existing baking marker, variadic flag, original annotation and formal ordinal. Record formals gain an explicit variadic flag. Variadic defaults and using procedure packs remain errors.

`#cpp_return_type_is_non_pod` retains its actual directive span on callable and procedure type headers, independently of directive order. Duplicate flags remain errors. This contract changes physical return ABI and type compatibility; source retention alone cannot authorize native lowering.

`FileItem::GlobalGroup` owns a boxed group containing every original name token and span, attributes, and one original initializer recipe. Graph discovery must reserve genuine identities for every name and retain the group while establishing initializer semantics. It must not invent a group owner from the first name or clone initializer effects. The group append helper avoids placing another large `FileItem` temporary in the recursive conditional parser frame.

Record `Import` and `Using` members retain ordinary scoped import and lexical using payloads. Checked lookahead distinguishes `using Flags;` from a promoted field such as `using field: Owner;`, including `using #as` qualifiers.

The [readiness receipt](../artifacts/frontend-header-grammar-readiness.json) records the private patch, baseline hashes, exact commands and consumer inventory. The composed component passes 186 tests, including the existing two MiB nesting guards. It parses 51 of 74 selected unchanged complete source files with zero stale captured original hashes; 18 of the 20 previously failing maintained-library files parse. Remaining maintained failures are the deferred caller context push and a named `#symmetric` procedure policy. These checks do not establish module graph, semantic, native or whole-corpus acceptance.

## How to change it

The [inferred-only alias companion](../artifacts/frontend-inferred-callback-lookahead-readiness.json) also recognizes `Callback :: (value := 40);` without an explicit return arrow. The original default remains a `ProcedureTypeBinding::Defaulted` with no annotation, and the alias retains its defining declaration. Its one-file parser delta applies above the immutable grammar layers; 194 private parser tests pass, including lexical alias retention and grouped scalar constant disambiguation. Semantic default preparation still requires the canonical callback packet's genuine source worklist and captured defining environment.

Extend the private packet in `jai-syntax` first, preserving the original parameter binding, declaration group and directive spans. Coordinate the shared schema window with integration before changing live enums, constructors or registrations. Keep the existing caller-return packet intact.

The bundle reuses the canonical `ProcedureTypeBinding` carrier and checked default parser from the anonymous procedure lane. Its 42-file consumer packet remains separate and held; callback defaults must consume its defining-file preparation proof. Retain its original declaration, file, nominal owner and defining substitution snapshot; a later ambient member map is not equivalent. Every signature visitor must traverse both a present annotation and its default expression. Missing canonical inference facts remain pending or produce a precise diagnostic.

Unannotated and baked pack formals require actual call argument specialization. The current semantic pack producer supports discarded packs and rejects genuine non-discard `Code`, `Type` and scalar packs; parser admission does not remove that semantic boundary. Record pack formal binding, partial application and specialization keys must preserve actual source ordinals.

Global groups need graph discovery, quoted-source budgets and retained initializer jobs together. Record namespace directives need discovery and publication in their original owner, file and lexical prefix. C++ non-POD returns need a checked ABI carrier in canonical type identity and physical call/result lowering. Until those consumers are paired, keep source activation held; do not add ignored exhaustive arms or reuse ordinary ABI identity.

## Configuration

No environment flag enables the held grammar. Global groups reject more than 65,536 names and duplicate names. Existing file and record conditional depth limits remain unchanged. The private proof uses direct `rustc -D warnings` against captured trusted rewrite dependencies and makes no Cargo invocation or main-target claim.

## Dependencies

The syntax component depends on `jai-lexer`, `jai-source`, `jai-types` and `jai-ir`, plus the prior literal/reflection/placement packets. Integration requires module discovery, retained source preparation, callback contracts, generic specialization, compiler quote traversal, and target ABI lowering. Supplied original files are read and parsed only; supplied native compiler assets are never executed or loaded.
