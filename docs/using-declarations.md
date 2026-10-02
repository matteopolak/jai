# Using declarations

## What it is

A declaration prefixed with `using` binds its original name and exposes selected members in the surrounding scope. Runtime members alias the declaration's actual storage; enum and type members retain canonical declaration identities.

## How it works

The parser keeps the ordinary declaration as a child of a `UsingDeclaration` wrapper. The child retains its original name, initializer, annotations, source span, and visibility. The wrapper retains the selection and exact original name-token span. Existing named-import syntax remains an import node.

```jai
Pair :: struct { value: int = 41; }
main :: () -> int {
    using item: Pair;
    value += 1;
    return item.value;
}
```

The local declaration registry inspects the original child at the wrapper's source ordinal. The child's defining environment is captured before promotion; later declarations see the checked promoted names. File discovery reserves the actual child declaration and retains it in the using request. Typed discovery can prepare that child's storage type without executing its runtime initializer.

A discarded file nominal owner such as `using _ :: struct { ANSWER :: 42; }` keeps its own real child declaration ID and original source span. It introduces no `_` namespace binding. Typed promotion resolves that exact child directly, so repeated discarded owners retain independent nominal types and source members.

File-level value storage promotion publishes a graph-owned storage-member identity containing the actual global declaration and original field-name path. Typed discovery validates the real canonical field chain before publishing it. Body and import lowering project the global's physical place through that checked path; renamed, imported, and re-exported aliases therefore retain the defining storage. File enum and type namespaces use the static-member route; lexical mutable declaration promotion uses checked place aliases.

File-level promotion through mutable pointer globals remains a located diagnostic: it requires a genuine initialized pointer capture. Re-reading the global pointer each time would change the declaration's once-captured target semantics. Lexical pointer declarations already retain their initialized target and null checks.

Executable lowering initializes a runtime child once, then applies the existing checked promotion to its actual place or pointer. Mutating an exposed field therefore changes the named declaration or pointed-to record. Static children resolve through the ordinary declaration registry. The resolver never feeds them to the executable declaration-only arm or invents a second source declaration.

`Only`, `Except`, and `Map` remain attached to the wrapper and use the same checked publication as [standalone using directives](using-directives.md). Computed selectors and mappers run during typed preparation; body lowering consumes their canonical results. Pointer promotion retains null and place checks. Conflicting names, immutable storage writes, and escaped lexical aliases remain errors.

Quoted code retains the wrapper. Inserting it as record members currently reports a located diagnostic because record-member metadata cannot represent declaration selection. It does not discard the selection or flatten the child into an ordinary field.

## How to change it

`jai-syntax/src/using_declarations.rs` owns the original-child name adapters and common declaration recognition. Statement and file dispatch share the existing selector parser. Extend the wrapper's source contract before adding a declaration category; preserve the child and name-token spans.

Graph reservation, dependencies, lexical scanning, and retained requests live in `jai-modules`. Its `storage_members.rs` owns session-specific source-path identities. `jai-sema/src/modules/using_discovery.rs` prepares the retained original child; `modules/scope/storage_members.rs` recovers the real global owner. `using_declarations.rs` creates canonical place projections in the current place registry, without caching places across registries. Local registration and prefix snapshots live in `local_declarations`. Keep these stages together so discovery cannot execute an initializer or resolve an unrelated outer name.

Source/VM tests are in `jai-sema/tests/using-declarations.rs`; native fixtures are in `jai-codegen/tests/using_declarations.rs`. `jai-modules/tests/discarded-using-owners.rs` checks independent original declaration IDs and the absence of a discard-name binding. Parser tests check exact original source ranges and import precedence. Full application compatibility is measured separately in [Focus and Jaison acceptance](focus-and-jaison-acceptance.md).

The ignored `actual_string_builder_and_focus_core_graphics_parse_unchanged` parser test requires the local original reference and pinned checkout. Run it explicitly to inspect the complete unchanged files and retained declaration nodes. It is a parser probe, separate from their full semantic dependencies or project output.

## Configuration

No flag enables this syntax. Existing visibility, lexical scope, typed compile-time limits, target layout, and active safety-check policies apply. Published global source paths have a maximum of 128 components; canonical promoted-field traversal has its own bounded cycle checks. Native test compilation uses the shared `JAI_RS_CLANG` / LLVM installation selection described in [native test tools](native-test-tools.md).

## Dependencies

The feature uses retained syntax, the module declaration registry, checked using publication, canonical types and places, the typed VM, and LLVM lowering of ordinary stores and projections. It adds no external runtime dependency.
