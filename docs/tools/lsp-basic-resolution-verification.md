# Basic symbol resolution verification

## What it is

A user report says the LSP sometimes fails to recognize `Basic.temp` and resolve `exit(1)`. These are required targeted checks after the compiler, standard library, and LSP are combined; the report is not yet reproduced.

## How it works

Use the source-built merged language server and its selected production standard library. Open independent minimal documents with qualified `Basic.temp`, normal Basic imports, and `exit(1)`. Inspect diagnostics, completion, hover/type information and definition resolution. Repeat after edits to detect stale or partial-document resolution, preserving the existing incomplete-edit contract. LSP inspection must not execute `exit(1)`.

If these work, leave production behavior unchanged. Record exact document text, selected stdlib, server revision and outcomes. If reproducible, compare the public declarations and general resolver behavior before fixing; do not add symbol-specific exceptions.

## How to change it

Add cases to existing LSP resolution/incremental-document regressions only when useful. Recheck against the final combined snapshot even if an isolated producer passes. Obtain the reporter's actual document/configuration later if minimal cases do not reproduce the intermittent failure; that does not block current integration.

## Configuration

Use the merged `jailsp` and production `JAIC_STDLIB`/editor stdlib setting, with a fresh server and then incremental edits. Record import spelling and qualification.

## Dependencies

Canonical Basic declarations, compiler semantic/name resolution, language-server document updates, and the selected installed distribution.

## Combined verification and repair

An original JSON protocol regression reproduced Basic.temp hover as Allocator but returned an empty definition list before the fix. Module value lookup discarded its selected declaration entity and recorded a generic struct-member reference. The compiler now retains the successful qualified module entity only until its matching member token is recorded. This also fixes qualified globals and primitive aliases without symbol-name exceptions; procedure/type handling and private export checks remain separate.

The exact independent document is:

```jai
#import "Basic";
Basic :: #import "Basic";
main :: () {
    allocator := Basic.temp;
    assert(allocator.proc != null);
    exit(1);
    Basic.exit(1);
}
```

Source-built JSON requests verify hover/definition for Basic.temp and exit, qualified exit hover, completion after replacing temp with te, and repaired diagnostics/hover/definition after a range edit restores temp. The document has no #run and is never executed. A separate original Values module verifies constant/global/primitive-alias definition locations. All37 features and5 modules tests pass against this production stdlib; Rustfmt and workspace Clippy warnings-denied pass. The minimal exit issue did not reproduce; no exit-specific production behavior changed. Final combined workspace replay remains required after later merges.

Command: cargo test --locked -p jai-language-server --test modules --test features. Selected stdlib: this worktree/stdlib, preload/module.jai. Parent revision41e78573 plus the committed module-entity repair; exact later measurement identity is retained in status/mac-current-baseline.json.
