# Type safety

## What it is

Compiler stages progressively turn source text into stronger representations, following [Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/). Strings describe user text and rendered output; enums and IDs describe compiler decisions.

## How it works

The lexer assigns `Keyword`, `Directive` and `Punct` tags at the text boundary. The parser creates `UnaryOp`, `BinaryOp`, explicit scalar signatures and separate inferred/explicit declarations. An interner maps each identifier to an opaque module-local `Symbol` ID. Parsed modules expose immutable accessors so consumers cannot replace their symbol tables or splice in procedures from another module.

`jai-sema` resolves symbols into private procedure/local IDs, checks scopes, calls, arguments, returns and reachable control flow, and constructs separate `IntExpr` and `BoolExpr` trees. Integer truthiness becomes an explicit `BoolExpr::FromInt`; integer casts of Booleans become `IntExpr::FromBool`. Compound updates are typed before storing back to a local. `Program` has private fields and exposes immutable accessors, so consumers cannot replace checked procedures or fabricate an entry point.

Loop names resolve into opaque `LoopId` values while their scopes are active. Typed break/continue transfers preserve the destination; direction and bound-condition enums describe iteration without reparsing text. See [loop control](loop-control.md).

Exit records carry explicit `CleanupId` lists and a `Transfer` enum. Cleanup bodies resolve into the same typed IR and cannot escape their enclosing cleanup scope. No source text is replayed during cleanup.

The LLVM backend accepts only `Program` and constructs instructions through Inkwell. Private integer/Boolean value and storage wrappers preserve scalar distinctions, while LLVM function and block handles identify control flow. Construction and verification errors are structured backend failures; source semantic errors are rejected earlier. LLVM serializes output only after module verification. The CLI parses raw arguments into command variants before reading or writing files.

## How to change it

For each new type or operator, add syntax and typed semantic variants first, then exhaustive backend matches. Test rejection at the boundary and real generated behavior with independently installed Clang. Preserve Jai's language conversions explicitly rather than changing the source language to match Rust.

Do not add an `Unknown(String)` escape hatch to checked IR. Unknown directives may retain lexical spans for diagnostics, but cannot silently enter a checked program. Private IDs are scoped to their originating module/program; do not mix them across compilations. General composite types, overloads, polymorphism and ownership of compile-time values remain future work.

## Configuration

The workspace forbids unsafe Rust and treats Clippy warnings as failures in CI. No type-safety feature flag or alternative unchecked backend exists.

## Dependencies

`jai-source`, `jai-lexer`, `jai-syntax`, `jai-sema`, `jai-codegen`, `jai-cli` and Rust enums, newtypes and immutable borrowing. The current typed IR covers the documented native subset, not the full language yet.
