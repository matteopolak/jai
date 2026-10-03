# Runtime parameter defaults

An omitted parameter can read a mutable global or the active implicit context. The compiler retains a checked storage recipe instead of evaluating that read as a declaration constant. This supports defaults such as `allocator := context.allocator` without freezing the allocator at compilation time.

## How it works

`modules/runtime_defaults` recognizes bounded name/member paths in the declaration's file. Type-only headers use the existing annotation `type_of` machinery to obtain the canonical type without evaluating the global initializer. An inferred implicit-Context formal can precede Context formation: its header retains the actual declaration, defining file, formal ordinal, original expression span and immutable source. Independent headers continue; after every selected bootstrap and graph `#add_context` field has formed the canonical schema, the original header is retried and its default becomes a normal checked runtime read. No parameter type or Context field is guessed. Complete headers retain the global declaration identity or the implicit context's canonical record type, checked pointer dereferences and exact field IDs. The source extent remains available for diagnostics.

The AST's `Context` root can represent the implicit context even when its spelling has no interned symbol. The recipe uses the actual context schema directly in that case. A declared source name `context` still follows ordinary defining-scope lookup and shadow rules.

Local procedure and record-method header completion uses the retained definition environment to recognize the same global/context recipes. Lexical declarations and scoped aliases are checked before file bindings, so a local variable with the same spelling cannot be replaced by a global read. Runtime local storage remains an unsupported captured default; static local constants keep ordinary constant defaults. Type-only method headers do not materialize these reads.

Pure local candidate previews use immutable ready bindings. A reserved inner declaration or pending using alias stops lookup rather than exposing an outer global. A known annotation type alone is not evidence that an expression reads storage: the preview must retain the actual ready place before it can create a read recipe. Initializer resolution belongs to selected header completion.

The argument binder lowers a recipe only when its parameter is omitted, after overload selection. Supplied arguments retain their source evaluation order; omitted reads follow them in parameter order. The recipe becomes an ordinary checked IR load, so VM and native execution use current storage. Callback aliases retain the recipe. A caller's similarly named local or global cannot change its defining global.

Implicit-context recipes use the active context directly. A `push_context` changes the value they read. Generated `,,` context-call helpers defer omitted context reads until their overrides are installed. Explicit arguments still evaluate in the caller's context. Source bindings named `context` are checked in the default's defining file; they do not acquire implicit-context behavior.

Generic previews retain the recipe's type with no fabricated constant. Selected specializations retain the same recipe. A runtime read cannot satisfy a baked parameter. Callback policy equality and replay keys include its semantic root, field steps and type; the diagnostic source span is not a semantic value.

Local generic operator previews use a separate read-only builder over ready lexical bindings and field metadata. It does not complete declarations or queue compile-time effects. A pending inner declaration blocks lookup of a similarly named outer global; imported roots retain their original graph identities.

The successful argument binder also returns an internal map of omitted recipes keyed by their actual runtime parameter IDs. Context-call helpers consume that map after baked arguments and discarded formals have been removed. They do not reconstruct parameter destinations from the original source argument list.

## How to change it

Extend `jai-sema/src/modules/runtime_defaults.rs` and the sealed read proof in `jai-sema/src/runtime_defaults.rs` together. New expressions must capture actual defining bindings and preserve evaluation timing. Do not route mutable reads through the scalar evaluator, an eager `#run`, or immutable record defaults.

The current recipe supports global/context storage paths and checked implicit pointer dereferences. It requires an exact parameter type; conversions and general call/arithmetic recipes need additional checked semantic operations. An unannotated implicit-context parameter in an early header waits for the full canonical schema through `procedure_headers/context_readiness`. Preserve its original parameter occurrence when changing header ordering. The retry follows `context::build` and precedes field/global initializer preparation; a missing field remains a source error at that original default. Context construction cycles retain their actual failure rather than publishing an incomplete schema. Local captured defaults require their own lifetime and binding proof.

Update generic descriptions, selected specialization emission, callback policy equality, stable replay encoding and context-call deferral when adding recipe kinds. Keep the ready-only builder in `runtime_defaults/ready.rs` separate from complete expression resolution. Keep storage-path and field-traversal budgets aligned with type-query limits.

## Configuration

There are no feature environment flags. Storage paths are limited to 256 steps; module field lookup limits traversal to 65,536 visited nodes/fields. Ready local previews use the canonical field-metadata APIs. Existing VM execution, storage and fuel limits apply to the resulting load. Native tests use the installed LLVM/Clang selected by `LLVM_SYS_221_PREFIX` and the [native test tool selector](native-test-tools.md).

## Dependencies and validation

The feature uses the module graph's declaration identities, canonical record metadata, annotation type queries, the place registry and existing VM/LLVM load paths. It adds no IR node or host allocation policy. All eleven `jai-sema/tests/runtime-defaults.rs` groups pass, covering changed globals, callback aliases, lexical shadows, two contexts, overrides, source argument effects, generic defaults and precise source errors. All seven `jai-sema/tests/local-runtime-defaults.rs` groups pass, covering nested procedures, local record methods and aliases, promoted global fields, implicit context, inference, and local capture rejection.

All six `jai-codegen/tests/runtime_defaults.rs` groups pass with freshly generated native programs at O0 and O2. Five also execute in the VM; the sixth links a self-written C consumer and proves that the foreign ABI receives the allocator's current value. The native fixtures use independently installed Clang and never link original native artifacts.

The authentic compatibility trigger is `corpus/upstream/withlang-dev--open-jai/modules/Basic/module.jai:130`, where the foreign prototype `alloc` defaults its allocator from the declared mutable `context: Context`. The hash-verified `a19b4808` checker snapshot reported the scalar evaluator's aggregate diagnostic there. A subsequent source-only check with the immutable `0ea2d968` snapshot advances to line 168, where the foreign `to_calendar` result names an unresolved `Calendar` type. The unchanged module still fails checking at that later diagnostic.

[The frozen probe receipt](../artifacts/open-jai-basic-runtime-default-check.json) records the exact compiler hash, command, source configuration, environment hash and diagnostic output hash. All 586 `.jai` files across the two configured module roots matched before and after the check; that inventory is a conservative input set rather than a claim that every file was loaded. No build, link or original native artifact execution occurred. This establishes source-check progress beyond the original default, alongside the authored runtime tests above, rather than full Basic or application acceptance.

The Context-header readiness extension is staged against commit `123f1c3`. Its three additional source regressions cover a configured Runtime_Support bootstrap (entry, initialization and backtrace all disabled), inferred reads under `push_context`, and a missing original member. These new regressions have not been compiled or executed yet; the earlier validation above remains separate.
