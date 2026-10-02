# Statement source spans

`jai-syntax::Statement` owns a byte `span` and a typed `StatementKind`. Every
parsed statement retains its complete source range so diagnostics and native
debug lowering can identify declaration names, control-flow keywords, and blocks.

## How it works

`Parser::statement` records the first token before parsing a kind and the end of
the last consumed token afterwards. The range includes a required semicolon or
closing brace, but excludes surrounding comments and whitespace. Nested bodies
contain independent located statements. `data_declaration` also records a full
range because file and context declarations call that parser directly.

Offsets are UTF-8 byte positions in the original immutable source. They are never
recomputed from expression positions or inferred from the resulting number of IR
instructions. The scalar `parse` adapter and the module-aware `parse_file` API
use the same statement parser.

Expression spans also retain grouping parentheses. The parser keeps the inner
expression kind and widens its range through the closing parenthesis, so later
binary or postfix operations retain the opening offset. For example, the source
condition `(1/0)>2` keeps that complete range for an execution diagnostic.

The surrounding `ParsedFile` supplies `SourceId` through `location(span)`.
Quoted `CodeBody` trees are cloned structurally, retaining every statement span;
`CapturedScope::location` retains their defining source identity. Current-scope
insertion changes name lookup while the quoted ranges still belong to the quote
source. Debug metadata must therefore use that retained origin independently of
the insertion scope. A synthesized expression statement uses the retained
expression span, and synthesized namespace declarations use their declaration
spans.

Semantic statement lowering temporarily sets the resolver's diagnostic span to
the current statement, then restores it after success or failure. Nested lowering
therefore cannot replace the containing statement's diagnostic location.
Unreachable statement diagnostics use the unreachable statement's own range.

## How to change it

Add semantic forms to `StatementKind`, then extend `statement_kind` and the
semantic match. Keep the outer `statement` parser as the single range boundary.
Helpers that return kinds must consume their own terminators; helpers that return
complete statements must provide a genuine retained span through
`Statement::new(span, kind)`.

Match a node with `match &statement.kind`. Preserve the wrapper when cloning or
moving syntax. For generated code, retain the source identity alongside the AST;
rebinding a lexical scope does not rebase byte offsets into a different file.

`crates/jai-syntax/tests/source-spans.rs` covers all statement parser paths,
nested boundaries, Unicode/CRLF offsets, scalar adapter parity, quotation clones,
and malformed-input diagnostics. Semantic source diagnostics are exercised in
`crates/jai-sema/tests/statement-source-spans.rs`.

## Configuration

There are no flags or environment variables. Ranges are half-open
`[start, end)` byte offsets, using `jai_source::Span`.

## Dependencies

The syntax parser depends on lossless token spans from `jai-lexer` and immutable
source records from `jai-source`. `jai-modules` retains file identity, while
`jai-sema` owns code captures and semantic diagnostic contexts. Native debug
metadata is described in [Native source debug information](native-debug-information.md).
