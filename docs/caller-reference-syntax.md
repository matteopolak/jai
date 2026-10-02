# Caller reference syntax

## What it is

A backtick before a root name requests lookup in a macro invocation's retained caller scope. The isolated syntax helper is currently test-only while checked caller-frame capture and place binding are being integrated; the production expression variants remain gated.

## How it works

`caller_references.rs` consumes only the backtick and source identifier. It returns the interned name and the original backtick-through-name span, leaving member, index, and call syntax to the ordinary expression parser.

```jai
mask := cast,trunc(u32)(`table.allocated - 1);
value := `items[index];
`destination.data = value;
```

Only the root lookup changes scope. `index`, call arguments, and unrelated right-hand expressions retain definition scope. The planned `ExpressionKind::CallerReference(Symbol)` and `PlaceKind::CallerReference(Symbol)` therefore remain leaves beneath ordinary postfix operations, rather than wrappers that rebind an entire expression tree. The invocation snapshot must retain the actual caller's lexical identities before switching to macro definition scope.

Backtick declarations and deferred cleanup use the separate [caller export](caller-defer-exports.md) statement contract. Production statement dispatch must distinguish those forms from a caller-reference expression or assignment; an assignment is not a declaration export. The original `Hash_Table.jai` macro body provides source evidence for caller-reference roots in projections and arguments. Its whole-file syntax regression remains visible until the checked expression and place consumers are ready.

## How to change it

Update `crates/jai-syntax/src/caller_references.rs` and its root/postfix boundary tests. Coordinate production leaf variants, place conversion, and statement dispatch with the retained invocation-frame binder. Add tests that shadow the same name in caller and definition scopes and verify that index and call operands keep their original scope.

Run focused helper tests with `RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --lib --locked --offline -j1 caller_references::tests`.

## Configuration

There are no source parser flags. The scalar compatibility parser rejects caller references because it does not retain checked invocation scope.

## Dependencies

Lexer backtick and identifier tokens, shared symbol interning and padded-identifier normalization, source spans, ordinary expression/place parsers, and checked macro invocation capture. No supplied compiler executable or native asset is used by these syntax tests.
