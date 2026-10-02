# Aggregate type syntax

## What it is

`jai-syntax` preserves unresolved type annotations, top-level record and enum declarations, named struct literals, and member reads in its per-file AST. This is a parser foundation: it does not provide aggregate storage, semantic type checking, or native lowering.

## How it works

`parse_file` recognizes `Name :: struct { ... }`, `union`, `enum`, and `enum_flags` as nominal declarations instead of treating them as scalar constants. `FileDeclarationKind::Record` and `Enum` retain names, source spans, and ordered members. An optional semicolon after the closing declaration brace is accepted.

`TypeSyntax` represents builtin types, named or qualified types, pointers, fixed arrays, slices, dynamic arrays, and procedure signatures. Fixed-array counts remain expressions; resolving names and evaluating counts belongs to semantic analysis. Builtin spelling classification happens once in the parser and produces enum variants. `as_scalar()` explicitly bridges supported integer and boolean annotations to the existing scalar AST.

```jai
Point :: struct {
    x, y: int;
    enabled: bool = true;
}

Container :: struct {
    using point: Point;
    values: [Count + 1] u8;
    view: [] u8;
    growing: [..] *Point;
    callback: #type (item: *Point) -> bool #no_context;
}

State :: enum u8 {
    READY :: 1;
    RUNNING;
}

p: Point = Point.{x=3, y=4};
```

Explicit field types and optional initializer expressions use `FieldBinding::Explicit`; inferred defaults use `FieldBinding::Inferred`. Plain grouped fields expand into individual entries in source order, each retaining the declaration span. `using` remains an annotation for future member lookup. The parser does not choose field offsets, copy semantics, or default initialization rules.

Enums preserve optional representation types, `#specified`, implicit members, and explicit `::` initializer expressions. Assigning enum values, validating the representation, and enforcing `#specified` require semantic analysis.

`Point.{x=3}` and context-dependent `.{x=3}` produce `StructLiteral` expressions. Only named fields are implemented; `.{}` is an empty literal, and named literals accept a trailing comma. Qualified literal type names remain unresolved `NamePath` values.

Bare dotted paths such as `p.x` remain `QualifiedName` syntax because parsing cannot distinguish a record member from a module or type namespace. Projections from other expression bases, such as `make().x` or `Point.{x=3}.x`, use `ExpressionKind::Member`. Both bind more tightly than arithmetic; a resolver must inspect the resolved base rather than assume every dotted path denotes a module.

The standalone `parse(&str)` API remains executable scalar syntax and rejects aggregate definitions, non-scalar annotations, literals, and member references. The per-file parser accepts unresolved syntax without claiming that `check`, `build`, or native execution supports it. Downstream stages must reject unsupported domains until complete checked types and lowering exist.

## How to change it

Extend `crates/jai-syntax/src/types.rs` for type forms, field bindings, nominal declarations, and literal parsing. `lib.rs` connects expressions and data annotations; `modules.rs` connects top-level declarations and file visibility. Update module declaration binding and every downstream AST match when adding variants.

Non-scalar procedure declaration parameters/results, local nominal declarations, record constants or nested declarations, member assignment, positional literals, string/float initializer expressions, array indexing/literals, uninitialized `---` fields, layout directives, and generic type applications remain outside this parser slice. Do not silently convert them to supported scalar forms. Procedure *type* signatures are available in annotations, including typed named/unnamed parameters, multiple results, `#c_call`, and `#no_context`; executable procedure declaration signatures retain their scalar API.

Regression tests cover field order/defaults, unresolved shapes, enum members, cross-file spelling identity, literal/projection precedence, source spans, malformed input, and the executable parser boundary. Run:

```sh
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --locked -j1
```

The source evidence is the supplied `reference/how_to/004_arrays.jai`, `006_structs.jai`, `007_struct_literals.jai`, `013_enums.jai`, and `042_using.jai`. Recent pinned jaison `typed.jai` (`Member_Offset`) and `module.jai` (`Special_Float_Handling`, `Ignore_Proc`) confirm the same record, flags, and procedure-type shapes. Tests reproduce small syntax examples without depending on ignored corpus downloads. No original reference binary, library, or object executes.

## Configuration

No environment variables or parser feature flags enable aggregate execution. `parse_file` takes a shared `Symbols` interner and preserves source identity; `parse` uses its own interner and the scalar executable boundary. Visibility directives follow the existing file/module scope parser.

## Dependencies

`jai-lexer` provides keyword and punctuation tags, `jai-source` provides symbols and source spans, and `jai-types` provides builtin scalar/float tags, record kind, calling convention, and context mode. Semantic resolution, canonical `TypeId` allocation, layout, and runtime lowering belong to later compiler stages.
