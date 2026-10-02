# Type safety

## What it is

Compiler stages progressively turn source text into stronger representations, following [Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/). Strings describe user text and rendered output; enums and IDs describe compiler decisions.

## How it works

The lexer assigns `Keyword`, `Directive` and `Punct` tags at the text boundary. The parser creates `UnaryOp`, `BinaryOp`, explicit scalar signatures and separate inferred/explicit declarations. An interner maps each identifier to an opaque module-local `Symbol` ID. Parsed modules expose immutable accessors so consumers cannot replace their symbol tables or splice in procedures from another module.

`jai-sema` resolves declarations, types, scopes, calls, and storage before publishing the representation owned by `jai-ir`. Common `TypeId` values preserve nominal identities across scalar, record, enum, distinct, pointer, sequence, and procedure domains. `IntExpr`, `BoolExpr`, and `FloatExpr` express arithmetic distinctions; their storage still uses the shared typed `Place`. Integer truthiness and Boolean/integer conversions are explicit checked nodes.

Public staging constructors do not establish validity. `ProgramBuilder` checks ownership, types, all expression branches, call/result bindings, control flow, cleanup dependencies, and bounded graph depth before returning a `Library` or `Program`. Those objects have private fields and immutable accessors. Ready VM execution similarly requires borrowed procedure, expression, or call proofs tied to the checked environment. See [shared checked IR](semantic-ir.md).

Loop names resolve into opaque `LoopId` values while their scopes are active. Typed break/continue transfers preserve the destination; direction and bound-condition enums describe iteration without reparsing text. See [loop control](loop-control.md).

Exit records carry explicit `CleanupId` lists and a `Transfer` enum. Cleanup bodies resolve into the same typed IR and cannot escape their enclosing cleanup scope. Their metadata captures the procedure context or an owned lexical push; invocation checks that pushed captures dominate the exit. No source text is replayed during cleanup.

Bindings distinguish immutable constant values from typed storage. Common places distinguish local/global/context roots and typed field, index, dereference, or descriptor projections. Scalar views require matching registry types. `jai-eval` handles pure constant expressions, while `jai-vm` executes checked procedure bodies and owns virtual allocation provenance.

The LLVM backend consumes checked IR and constructs instructions through Inkwell. Private scalar value and storage wrappers preserve arithmetic distinctions, while LLVM function and block handles identify control flow. Backend capability and verification errors are structured failures; source semantic errors are rejected earlier. LLVM serializes output only after module verification. The CLI parses raw arguments into command variants before reading or writing files. Driver source/unit IDs are opaque, source units are immutable, and errors preserve typed provenance. Required and defaulted parameter AST variants exclude parameters without either a type or a default. Named arguments resolve once to opaque parameter IDs while preserving source evaluation order.

## How to change it

For each new type or operator, add syntax and checked IR variants, extend the publication verifier, then add semantic and consumer matches. Test rejection at the public builder boundary and real generated behavior with independently installed Clang. Preserve Jai's language conversions explicitly rather than changing the source language to match Rust.

Do not add an `Unknown(String)` escape hatch to checked IR. Unknown directives may retain lexical spans for diagnostics, but cannot silently enter a checked program. Respect each identity's owner and arena; never use a failed proof to construct a fallback executable body. Extend unsupported source features only with semantic and execution evidence beyond an accepted AST or hand-built IR fixture.

## Configuration

The workspace forbids unsafe Rust and treats Clippy warnings as failures in CI. No type-safety feature flag or alternative unchecked backend exists.

## Dependencies

`jai-source`, `jai-types`, `jai-ir`, `jai-vm`, `jai-driver`, `jai-lexer`, `jai-syntax`, `jai-eval`, `jai-sema`, `jai-codegen`, `jai-cli` and Rust enums, newtypes and immutable borrowing. Typed IR and consumer support cover the documented implemented behavior, not the full language yet.
