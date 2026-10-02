# Lexical using directives

## What it is

A lexical `using` introduces selected names from a target into the surrounding scope. The source AST retains the target and its selection policy; field, parameter, and named-import promotion metadata are separate integration points.

## How it works

`UsingDirective` stores an expression target, a `UsingSelection`, and the original source span. The selection is `All`, `Only`, `Except`, or `Map`. Explicit selector names retain interned spelling identities and individual spans, while a computed name-list retains its original expression tree. These are different source forms rather than names guessed from expression text.

`Only` and `Except` filter the target's actual member list; selector names that are absent from the target are harmless. The supplied `044_using_advanced` tutorial explicitly documents this behavior. Bare repeated namespace promotion may reuse identical static bindings, while modified publications retain ordinary name-conflict checks.

```jai
using Operator_Type;
using,except(preserve_debug_info) build_options.llvm_options;
using,only(.["+", "-", "*"]) Basic;
using,except #run skipped_names() instance;
using,map(prefix_with_gl) procs;
using buffer := get_current_buffer(builder);
```

The supplied `044_using_advanced` tutorial defines computed name lists and mapping procedures. The Compiler source uses enum names and an `except` list on a nested field target. Vk-Engine uses a string array to select module operators. Promotion must preserve checked declaration identities or actual storage paths, with normal scope/conflict rules; it must not copy a mutable field's value into a disconnected local variable.

The checked discovery route retains original directives as session-owned `FileUsingRequest` values. The semantic preparation evaluates computed name lists and mapper procedures through the typed VM/readiness provider. Returned `[]string` selectors are consumed while their VM memory remains live, with shared materialization budgets; they are not disguised as native slice constants. Host-fed mapper names enter VM storage through typed descriptor normalization.

`FileUsingDecision` returns actual namespace/static-member bindings, selected source operator declarations, or `UsingAlias { source, destination }` pairs for lexical place/member promotion. Graph publication validates canonical destination identifiers, source identities and namespace privacy, then interns destinations in the session spelling table. Colliding multirow publication rolls back binding/overload changes. New names refer to original declaration IDs or checked source members; runtime fields retain actual storage places.

Semantic body consumption matches the defining file, directive span, owner declaration, and specialization. It applies canonical bindings and original-to-destination aliases to actual checked target members without reexecuting the computed selector or mapper. Lexical frames retain the selected original operator declaration IDs; token lookup uses the nearest frame's selected IDs. Prefix preparation publishes static bindings and reserves unavailable place aliases before resolving local declarations, preventing accidental global fallback. Actual statement execution establishes the alias's storage and preserves its target setup.

Production file and statement dispatch now retain `using` directives after named-import detection. Graph traversal creates checked requests in the defining file and lexical frames. An unresolved lexical promotion blocks scalar lookup of later names, so it cannot accidentally select a same-spelled global; published aliases remain local to that frame. `GraphDiscovery::retain_using` also supports staging an original AST request directly. Public AST/request availability alone does not establish executable support for every promotion form. Unsupported cases produce located diagnostics.

For a lexical target declared earlier in the source, Using preparation checks the original declaration and allocates its typed storage plan. It does not execute the runtime initializer during discovery. Ordinary source-condition requests retain their runtime-value restrictions. This distinction lets a field alias use its actual record type without treating a runtime value as a compile-time constant.

Declaration-prefixed `using` retains the original child declaration and exact target name span. File children enter the ordinary declaration arena; lexical children remain original statement AST in `UsingDeclarationSource`. Discovery checks a runtime child's typed storage plan without running its initializer, and body lowering executes that initializer once before establishing the aliases. Static children resolve through their actual lexical declaration registry. File-level runtime fields use a graph-owned `SourceStorageMemberId` registry. Each immutable entry retains its actual global declaration and full source field path. Semantic discovery proves the canonical typed field chain before returning a storage-member decision; body and imported namespace hydration resolve that path into the original global place. Published aliases can cross module boundaries without exposing the private owner name. Pointer paths require a stable capture route and reject when that route is unavailable.

Builtin array iterator targets derive their element type from the original enclosing loop and its retained body frame. Their promoted fields preserve the iterator's storage policy. Custom iteration protocols require checked protocol metadata; unsupported protocol targets produce a diagnostic. A stallable `#run` name-list currently rejects with a live-result continuation diagnostic, since a returned slice must remain backed by its owning VM.

Run `cargo test -p jai-syntax --lib using_parser` for the common grammar, `cargo test -p jai-sema --lib using_discovery` for typed request evaluation/publication, and `cargo test -p jai-sema --test using-source` for actual parsed sources and mutable field aliases. The graph's request tests check canonical destinations, namespace privacy, transactional collisions, and lexical alias isolation.

The child declaration sees the source environment before its own promotion. A mapped static member can therefore use an outer constant while later declarations see the mapped result. Earlier nested procedures keep their earlier bindings; later procedures cannot silently replace a runtime place capture with a same-spelled file constant. A nested wrapper may shadow an outer target name, and leaving that scope restores the outer binding. `using-prefix-environments.rs` exercises these rules through actual VM execution and renders rejected captures from their retained source locations.

## How to change it

`jai-syntax/src/using_syntax.rs` defines the typed source contract. `using_parser.rs` parses the common target/filter grammar; statement and file dispatch connect it after named-import detection. The helper's regressions cover genuine Compiler/Vk forms, computed lists, mapper expressions, padded selector spellings, and malformed selectors. Explicit selector names can be keyword spellings; computed selectors retain normal expression rules.

The semantic owner is `jai-sema/src/using_directives.rs` and its selection/evaluation/discovery helpers. `jai-sema/src/modules/using_discovery.rs` evaluates retained source requests during normal preparation; `jai-modules/src/using_requests.rs` validates and publishes their canonical responses. The driver prioritizes these typed requests before unresolved-name/fixed-point failure. When extending declaration-prefixed `using`, preserve the same selection on field, parameter, and import AST metadata instead of discarding it or changing a filtered import into an ordinary standalone directive. File-level requests must retain defining-file origin and actual namespace/operator identities.

## Configuration

No syntax flag or environment variable enables promotion. Existing lexical scope, visibility, compile-time limits, and target facts control checked binding and evaluation. Storage-member paths are limited to 128 source fields; registry IDs belong to one graph session.

## Dependencies

The feature uses original source spans and symbols, expression AST, graph namespace/export lookup, checked place and declaration registries, and the typed compile-time evaluator. It adds no external service or library and executes no supplied compiler artifact.
