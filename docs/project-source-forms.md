# Source forms from recent projects

## What it is

Two source forms used by pinned Focus and Jaison reuse the compiler's existing checked execution and pointer operations: block-form `#run` declaration initializers and the parenthesized dereference operator `(.*)`.

## How it works

A declaration initialized directly by `#run { ... }` or `#run -> Type { ... }` ends at its closing brace. A semicolon remains optional there, as it already is for a here string. Ordinary expressions and expressions combining a run with another operation still require their semicolon. The parser retains the original initializer and statement spans; this rule does not skip body typing or compile-time execution.

```jai
ANSWER :: #run -> int { return 41; }
main :: () -> int {
    offset := #run -> int { return 1; }
    return ANSWER + offset;
}
```

`(.*) pointer` and `(.*)(pointer)` parse as the same `Dereference` node as `pointer.*`. The operator binds its pointer operand at unary precedence, so `(.*) pointer + 1` adds one to the loaded value. It is not a fabricated procedure call or a first-class procedure value. The existing resolver checks pointee types and addressability; VM provenance/lifetime checks and native null guards apply to both spellings. A dereferenced assignment target captures its actual typed place.

```jai
value := 17;
address := *value;
((.*) address) = 41;
result := (.*) address + 1;
```

Focus's pinned `first.jai:3-12` uses semicolon-free string-producing run bodies. Jaison's `typed.jai:42`, `73`, `83`, and `217` uses parenthesized dereference for typed view loads and stores. Pins and source fingerprints come from `corpus/upstreams.json`. Independent fixtures verify checked constant results, unary precedence, single evaluation of a pointer-producing call, Boolean/string conditions, stores, type errors, and null failures; these fixtures do not establish complete project builds.

## How to change it

`jai-syntax/src/statements.rs` classifies self-terminated initializer forms. Keep classification tied to the entire initializer node, rather than accepting any expression that happens to contain a block. `pointer_prefixes.rs` recognizes only the exact parenthesized dereference token sequence and constructs the existing pointer AST. Preserve short-lambda recognition and the other expression prefixes when adding forms.

Parser fixtures are in `jai-syntax/tests/project_source_forms.rs`; source/VM/native fixtures are in `jai-codegen/tests/project_source_forms.rs`. Native fixtures emit fresh objects with the LLVM library and execute only independently authored generated programs.

## Configuration

There are no source-form feature flags. Normal source scope and execution limits apply to runs; normal target layout and pointer validity checks apply to dereferences. Native tests use the shared reviewed Clang selector in `jai-codegen/tests/support/native_tools.rs`.

## Dependencies

The forms depend on `jai-syntax`, the typed semantic resolver, checked IR, the Rust VM, and LLVM lowering. See [compile-time execution](compile-time-execution.md), [pointers and places](pointers-and-places.md), and [Focus and Jaison acceptance](focus-and-jaison-acceptance.md).
