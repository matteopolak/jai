# Source expression parsing

## What it is

The expression parser distinguishes callable headers from parenthesized expressions and retains the original type syntax of typed array literals. These choices affect source parsing before semantic name and type resolution.

## How it works

A nonempty parenthesized sequence must contain an actual top-level formal separator before it can start an anonymous procedure. This lets `if mode == .ALLOCATE || (mode == .RESIZE && !old_memory) { ... }` keep its boolean condition and block. Empty callable headers and typed/inferred formals still produce the existing anonymous-procedure node. Nested parentheses alone do not provide formal evidence.

Typed array targets are converted into the existing `TypeSyntax` representation. For example, `(*u8).[value]` retains a pointer to `u8`; `type_of(original).[value]` retains the original query expression; and `Box(element_type).[value]` retains the application arguments. Runtime array binding, source constants and quotation traversal consume the same type syntax. Parsing a target does not establish that it names a valid type or that its elements can convert to that type.

## How to change it

Change callable lookahead in `jai-syntax`'s `anonymous_procedures` module without consuming tokens or constructing alternate callable identities. Keep complete condition/range spans and genuine empty, typed and inferred callable cases covered.

Extend `array_literal_targets` when admitting another genuine type-expression form. Retain its actual children and spans, then check array binding in `jai-sema` and source-quotation traversal. Reject arbitrary value expressions as type targets. Broad callable ABI/default changes, record literal schemas and conditional-expression forms have separate consumers; this correction does not activate them implicitly.

## Configuration

There is no feature flag or platform setting. Both decisions apply to ordinary and compile-time source on every target. Source files keep their original bytes and syntax; parsing does not rewrite upstream programs.

## Dependencies

`jai-lexer` tokens, `jai-source` spans/symbols and the existing `jai-syntax` expression/type nodes. Later consumers include `jai-sema` runtime arrays, module sequence constants, parameter applications and metaprogram quotation accounting.
