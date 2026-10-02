# Scoped imports

Procedure and block bodies can import a source module under a lexical alias, through `using`, or anonymously. The imported source enters the canonical module graph while its names remain in the importing body's scope.

## How it works

`ScopedImportDeclaration` preserves the same literal target, import mode and argument syntax as a file import, with the complete original statement span. The graph constructs a real source location from the defining file and records a `ScopedImportEdge`. `scoped_import(file, span)` retrieves the canonical `ModuleId`; loading the dependency never adds the alias or its exports to file or module bindings.

The graph discovers imports through nested bodies and selected compile-time branches. Literal conditions, file/module constants, target facts and lexical scalar constant chains can select a branch during discovery. Local declarations keep whole-block visibility and resolve in their defining lexical depth. Inactive branches never resolve their targets, so a missing module there is harmless. Runtime branches contain independent lexical bodies and both bodies' source dependencies are discovered. A pending guard suspends its own branch while independent later imports continue to load.

Lexical constant annotations retain their complete type syntax. Scalar annotations can participate in pure discovery casts; nominal and other non-scalar annotations defer to semantic selection in the original declaration environment rather than being interpreted as an untyped scalar or rebound in a caller's scope.

Named projections of a multi-result constant declaration also reserve their actual lexical names before its `#run` result is available. Discard slots add no name or runtime shadow. The retained request contains the original result group and initializer, so a same-named file constant cannot select an import branch in its place. `jai-modules/tests/scoped-result-shadows.rs` checks that suspension and source identity.

Compile-time case tables follow the same rule. Pure scalar selectors and labels can choose an arm during graph discovery; `#through` adds only its actual successor bodies. Typed or specialization-dependent selectors retain the original body-free case header for semantic selection, including every original label span. Unresolved tables reserve possible lexical names and continue independent source dependencies without loading their unselected arms. A pending anonymous or `using` import also holds outer-name lookup until its real exports are known; same-block declarations still take precedence. This prevents a file constant or namespace from prematurely selecting a branch that a local import will shadow. `jai-modules/tests/scoped_cases.rs` checks these cases, fall-through deduplication, anonymous field selection, and suspension followed by a real chosen-arm response.

Anonymous record members retain their original child record tree and source spans. Discovery enters that actual child's lexical namespace when visiting its methods and conditions; it does not invent a name or publish child constants and methods in the enclosing namespace. It selects child layout conditions before checking parent method guards, then promotes only active physical field names as runtime shadows. An unresolved layout reserves possible field names without claiming runtime storage, while an inactive field never hides a file constant. Physical field identities and member paths remain owned by semantic record layout.

`jai-modules/tests/anonymous_imports.rs` checks child constant shadowing without changing sibling guards, selected methods inside nested anonymous records, active and inactive field promotion, and deferred guards retaining their original anonymous AST, runtime names, defining declaration, and source span. It also checks that inactive child fields do not shadow outer constants and that unresolved layout or method guards do not prevent independent method imports from loading. The seven fixtures passed on 2026-10-02. These are source graph checks; they do not execute the methods or establish native record layout.

Canonical import requests use the ordinary module request binder, including ordered instance arguments, program parameter reservations and cycle checks. Imported declarations keep their defining file, privacy, global storage and callback identities. `lookup_module` traverses exports only; private callbacks can execute through exported aliases without becoming accessible to the importer.

The semantic resolver keeps lexical namespace and imported declaration bindings. `using` members provide a fallback beneath actual local declarations. Procedures and overloads retain graph declaration identities instead of selecting a procedure before argument matching. Nested scopes restore their surrounding bindings on exit.

Checked standalone `using` directives share the source-position environment used by local imports. Later constants, procedure headers, and deferred bodies capture only the preceding checked publications, including selected operator declaration IDs. Prefix selection consumes published graph bindings without rerunning a mapper or evaluating a runtime target. Place aliases reserve their destination names until the original statement materializes their actual storage, so an eager declaration cannot accidentally resolve a same-named file constant. `jai-sema/tests/using-prefix-environments.rs` exercises prefix capture, guard selection, nested restoration, and single runtime target evaluation.

Declaration-prefixed `using` retains the original child declaration in the same lexical frame. The child captures its preceding environment before its own members are promoted; later declarations capture the checked promotion. Local enum and record namespace aliases can become ready from the child's actual type metadata before body checking. Runtime aliases stay pending until the original child initializer runs and creates its storage, then promotion reuses that place. No mapper is replayed during prefix refresh.

Record promotion enumerates actual selected namespace declarations and physical fields. The record's self binding and enclosing specialization arguments remain inputs to member evaluation rather than promoted members. This keeps a mapper's name array tied to the authored record and prevents an injected type alias from taking a physical field's mapped name.

Published views of global fields carry a graph-session storage-member identity with the actual global declaration and original field path. Mutable semantic lowering resolves that path through the owning record's checked fields; imported and captured views retain the same source identity. Bare repeated `using` can reuse an identical published view after its place has been materialized. Deduplication compares the canonical publications rather than generated projection IDs or field spellings.

Nested local procedures consume the publication belonging to their actual enclosing source declaration. Qualified place aliases keep their checked physical member paths and normal storage capture rules; they do not fall through to an outer same-named value. The VM prefix fixtures and `jai-codegen/tests/standalone_using.rs` verify these paths using independently written source and this compiler's emitted objects.

The focused checks on 2026-10-02 passed all 15 prefix VM fixtures, 11 standalone VM/native fixtures, 11 scoped-import VM fixtures, and three scoped-import native fixtures. They include original-child initialization once, mapped single-field mutation, file-global and imported field views, repeated canonical promotion, static member guard selection with a missing inactive dependency, and private callback/overload identity. These fixtures do not establish complete application compatibility.

When a condition controls source imports, source `#run`, procedure calls or unresolved lexical types remain a precise graph phase dependency at the original condition span. `GraphDiscovery` retains the original expression, lexical statements, record members and runtime shadow names for later semantic selection. Applying a real selection resumes the existing graph without rebuilding its declaration or module identities. Conditions that control only executable statements remain with the semantic body resolver; discovery does not guess a false value or load both source branches.

```jai
main :: () -> int {
    #if true {
        Handler :: #import,file "handler.jai";
        return Handler.answer();
    } else {
        Missing :: #import "unavailable-on-this-target";
    }
}
```

## How to change it

Change `jai-modules/src/scoped_imports.rs` for lexical dependency discovery and `jai-modules/src/loader.rs` for canonical request loading. Keep request loading separate from file binding publication. Extend `jai-sema/src/modules/scope/imports.rs` and local declaration registration for semantic namespaces, preserving graph identities for overloads and templates.

`jai-sema/src/local_declarations/imports.rs` snapshots and restores import and checked-using environments. When adding a lexical publication, update registration, selected-statement refresh, and deferred source restoration together. Runtime target setup belongs to the original executable `using` statement; prefix refresh must consume its checked publication and readiness state without allocating replacement storage.

Keep declaration wrappers intact when refreshing environments: snapshot the original child's declaration first, then extend the prefix with its promotion. `using_type_members` consumes the selected source-member names retained by record specialization; extending a specialization substitution must not automatically extend the public member list.

New dependency forms should retain source-neutral body syntax, genuine spans and defining-file ownership. Do not register local aliases as module globals or synthesize fake declarations to evaluate lexical constants. Add source-to-VM and native fixtures for new resolution paths, including privacy and inactive-branch failures.

## Configuration

Imports use `GraphOptions::import_dirs` and the selected `SourceProvider`. File and directory modes resolve relative to the defining source. Target-dependent selection uses explicit `BuildTarget` facts. There are no new environment variables or runtime flags.

## Dependencies

This uses `jai-syntax` body syntax, `jai-source` locations and identities, `jai-modules` canonical request and privacy rules, `jai-eval` scalar selection, and the semantic declaration worklists. It adds no external dependency.
