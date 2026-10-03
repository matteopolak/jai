# Statement termination

## What it is

The source parser retains explicit empty statements and distinguishes ordinary semicolon-terminated values from direct forms with their own closing delimiter. This admits authentic closed here strings, anonymous procedures and aggregates, quoted code blocks, and compile-time block producers without relaxing ordinary expression boundaries.

## How it works

An empty statement produces `StatementKind::Empty` with the exact semicolon span. It remains a real single-statement control body: `if ready ;` evaluates its condition and `while ready ;` still iterates and consumes VM fuel. Semantic resolution lowers the empty syntax to the existing empty checked block; no new VM operation or host effect is introduced. Empty statements after `defer { ... };` do not change when the deferred body executes.

The parser classifies the completed outer expression and its actual final token. A direct here string must finish at its `HereString` token; a direct anonymous procedure, inline aggregate, `#code { ... }` or compile-time block/procedure must finish at its closing brace. These forms may consume one optional semicolon. A call, arithmetic expression, parenthesized value, quoted scalar expression, or ordinary assignment still requires its own semicolon.

```jai
main :: () -> int {
    ;
    callback := () -> int { return 40; }
    quoted :: #code { unused_until_insertion(); }
    return callback() + 2;
}
```

Here-string bytes and delimiter spans are unchanged. Direct assignments and field assignments apply the same boundary rule as declarations; multiple result values keep their existing explicit terminator. Additional semicolons inside an enum body are separators and do not create members or advance implicit enum values.

Bare anonymous local union syntax retains its complete type and members. Its storage/member-promotion producer remains unsupported and receives the existing located semantic diagnostic; termination support does not discard those members or invent their storage. Likewise, accepting a `#code` block does not execute its quoted effects: only a genuine insertion consumes the retained body.

## How to change it

Extend `crates/jai-syntax/src/statement_termination.rs` with a specific retained outer syntax form and genuine closing-token rule. Keep the hooks in declaration, assignment, expression-statement and using parsing consistent. Never classify an expression solely by whether some nested operand contains braces or a here string, and do not make every semicolon optional.

`StatementKind::Empty` has no children. Retained syntax accounting still counts its node and source span; semantic resolution must keep it harmless without bypassing the surrounding condition, loop or cleanup. If an aggregate begins producing storage or promoted members in statement position, implement that producer and its checked ownership before removing the current refusal.

The source-to-AST tests cover boundaries and retained bodies. The closed source-to-VM tests cover actual effects, deferred cleanup, quoted insertion, callable values, here-string content, enum numbering and bounded fuel for an empty infinite loop. Preserve rejection tests for wrapped and ordinary values missing semicolons.

## Configuration

There is no syntax flag or new dependency. Existing source spans, parser mode, semantic layout and VM limits apply. Fuel limits still bound an empty loop. This feature changes no global compiler/interpreter default and grants no host filesystem, foreign-library or process capability.

## Dependencies

The lexer supplies punctuation and complete here-string tokens. `jai-source` owns source spans and retained text; `jai-syntax` owns the complete statement/value trees and their accounting. `jai-sema` lowers explicit empties to existing checked blocks and resolves the retained producers. Existing `jai-ir`/`jai-vm` control flow and cleanup execute authored programs; no supplied native artifact is needed.
