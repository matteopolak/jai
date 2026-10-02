# Source context bindings

## What it is

An ordinary declaration named `context` shadows the implicit context expression. This supports source modules that declare their own `Context` record and global `context: Context;` storage.

## How it works

```jai
Context :: struct { value: int = 40; }
context: Context;
main :: () -> int #no_context {
    context.value += 2;
    return context.value;
}
```

The parser accepts `context` as a declaration or member name while retaining its context-expression syntax. Resolution checks the ordinary lexical, imported, defining-file and module bindings first. Reads and writes then use the actual source binding and its nominal type. If no binding exists, the expression uses the canonical implicit context schema. Private declarations in another file do not become visible through this fallback.

The named source record and `#Context` keep separate identities. A source global does not supply a procedure's hidden context parameter. Accessing ordinary global storage remains valid inside a `#no_context` procedure.

## How to change it

`jai-syntax` handles the narrowly permitted keyword in names and declaration prefixes. Assignment to a bare context expression still uses normal place resolution; it is not rewritten as a declaration. `jai-sema/src/modules/context_bindings.rs` checks genuine source bindings using the existing scope and declaration rules. `context.rs` selects source storage for expressions, members and places before requiring implicit context availability.

Extend parser and semantic regressions when changing lookup order. Do not make the behavior depend on a filename or equate a source record named `Context` with the implicit schema.

## Configuration

No environment variable controls shadowing. Graph scopes, imports, visibility, and local declarations determine which source binding is visible. `#no_context` continues to govern the hidden procedure context.

## Dependencies

The feature uses the source parser, module graph lookup, lexical declaration completion, canonical nominal types, checked global/local places, and the existing implicit context schema. It requires no original native artifact.
