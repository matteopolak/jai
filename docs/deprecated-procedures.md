# Deprecated procedures

## What it is

`#deprecated` attaches reference diagnostics to a procedure declaration. An optional message retains decoded source bytes and its original directive/message span.

## How it works

```jai
array_swap :: (a: *[..] $T, b: *[..] T)
    #deprecated "Use Swap() instead." {}
NSAddressOfSymbol :: (symbol: *void) -> *void
    #foreign libc #deprecated "use dlysym()";
```

The supplied source uses both body declarations and foreign prototypes. `Procedure.deprecation` and `ProcedurePrototype.deprecation` retain `Deprecation { message, span }`. Bare `#deprecated` has no message. Debug suppression, source notes, calling convention, and generic parameters remain separate policies.

The semantic diagnostic path follows the selected declaration identity through overloads, local definitions, aliases, and specialization. Calls and procedure addresses report warnings after their actual target is bound. Deprecated-to-deprecated references suppress downstream complaints using the original marked definition's source extent. Marked macro bodies follow the same rule, while caller-supplied expressions retain their own locations.

The source warning payload retains its primary reference site and related declaration site with their exact immutable source allocations. It remains renderable after the module graph is dropped. Equal source IDs, paths, and text from another compilation do not prove source ownership. Warning collection is separate from emitted debug information, so `#no_debug` does not erase diagnostic provenance.

CLI source checks render the successful final library or program's warnings to stderr. Workspace builds render warnings only from the surviving final checked libraries after resolution, before native artifact planning. Scheduler retries and discarded rebuild passes do not print interim warnings.

## How to change it

`jai-syntax/src/deprecation.rs` parses the optional literal message. The shared procedure modifier loop supports annotation ordering; foreign prototype suffixes also preserve attributes after the library name. Duplicate annotations fail at the repeated token. String escapes use the normal literal decoder, rather than converting message bytes to a guessed semantic string.

Deprecation belongs to a declaration and is rejected inside explicit procedure type syntax. Keep warning lookup attached to canonical callable identities rather than names or ABI types. Extend diagnostic tests alongside parser tests when adding another declaration category.

`jai-source/src/warnings.rs` validates spans and retains warning locations; the semantic collector records committed references and deduplicates retries at the original source reference and target sites. Register the authoritative source declaration extent as well as its attribute span: this lets suppression follow the marked definition's source and avoids suppressing a caller's argument expression merely because a marked macro receives it.

## Configuration

The source annotation is independent of debug-information settings. The legacy scalar parser rejects it because that API lacks declaration reference diagnostics. No environment variable changes message decoding. `MAX_SOURCE_WARNINGS` bounds retained diagnostics at 16,384; exceeding the bound reports an explicit error instead of silently dropping warnings.

## Dependencies

The parser uses procedure metadata, source spans, and the existing byte-string decoder. Reference diagnostics depend on semantic declaration lookup and warning collection. No external service or supplied native artifact is involved.
