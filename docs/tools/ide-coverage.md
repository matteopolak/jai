# IDE coverage

`crates/jai-language-server/examples/ide_coverage.rs` finds the identifiers and directives that get no hover or no go to definition from `jailsp`. It catches whole kinds of names the type checker forgets to record, such as named arguments, struct literal fields or `for` names over a `for_expansion`.

```sh
cargo run --release -p jai-language-server --example ide_coverage -- [--list] [--errors] [--stats] [--stdlib DIR] DIR...
```

## How it works

- Each `DIR` is opened as a workspace folder in a `Session`, with every `.jai` file under it open, as an editor would. The stdlib defaults to the repo's `stdlib/`.
- Each file is lexed with `jaic::lexer::lex`, so comments and strings are skipped. Keywords and builtin type names are skipped too, as are a directive's flags (`#import,file`).
- Every identifier and directive is asked for hover. A hover that is only the syntax layer's fallback ("Source syntax declaration") counts as missing.
- Every identifier that is not a declaration (`name ::`, `name :=`, `name:`) is also asked for go to definition.
- Each gap gets a role from its neighbours: `Declaration`, `Named` (`f(name = 1)`, `.{name = 1}`), `Member` (`a.name`, `.NAME`), `Use` or `Directive`.
- A file with a type-checker error (`DiagnosticCode::Check` at error severity; warnings do not count) is reported as errored. Past an error some facts are expected to be missing.

Output: one line per file with its counts, each gap with `--list`, then totals by file kind and role.

```
tour/generics/polymorphism.jai: 245 identifiers, 0 without hover, 0 without definition
tour/meta/compile_time.jai: 109 identifiers, 1 without hover, 3 without definition
  28:5 Declaration `PLATFORM_NOTE` no-hover  | PLATFORM_NOTE :: "compiled for WebAssembly: ...";
```

## Reading the results

Gaps that are expected:

- Code in an `#if` branch no target takes (`#if false`, a constant the program sets), which is never checked. Branches on `OS` or `CPU` are answered by a compile for another target.
- Builtin members with no declaration (`.count`, `.data`, `Any.type`) and builtins such as `OS`: hover but no definition.
- In a polymorphic procedure or macro nothing calls (see Sketches in [language server](../compiler/language-server.md#semantic-analysis)), members of a `$T` value hover with a stand-in type such as `T.label` but have no definition.
- Code in a polymorphic struct's `#assert` or `#modify`.
- Code a metaprogram rebuilt with `compiler_get_code`: it is reparsed from text and has no source positions.
- Files only a metaprogram's workspace compiles, for a target whose metaprogram needs something the sandbox cannot give at compile time: the Objective-C runtime (`sel_registerName`, Focus's macOS build) or a native library. That target's workspace is never built; other targets still answer `#if OS` branches.

Anything else is usually a kind of name the type checker does not record yet. Add the record where that name is checked (see "How to change it" in [language server](../compiler/language-server.md)), and add a case to `names_outside_plain_expressions_hover_and_go_to_their_declarations` in `crates/jai-language-server/tests/features.rs`.

Good inputs: `examples/tour` (expected to be clean apart from its untaken `#if`) and project folders under `corpus/upstream/`. Run one project at a time: a session over a large project can take a few GiB.

## How to change it

- `KEYWORDS` lists the words that are never asked about.
- `role` decides the role from the previous and next token.
- The fallback check matches the text `session.rs` writes for syntax-only hovers. If that text changes, update the check here.

## Configuration

- `--list`: print every gap with its line.
- `--errors`: print each file's type-checker errors (first line of each).
- `--stats`: print how many compiles each file's requests started and how long they took. A file that needs many compiles points at a cache that is thrashing.
- `--stdlib DIR`: the stdlib to import from (default `stdlib/`).

## Dependencies

- `jai_language_server::Session` (hover, definition, diagnostics).
- `jaic::lexer` for tokens, `jaic::sema::NativeFs` and `Options::host()` for the environment.
