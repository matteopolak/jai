# Procedure source notes

Procedure bodies and external prototypes can carry ordered user notes, such as
`print :: (format:string, args:..Any) {} @PrintLike`. Notes preserve their defining
source identity and exact bytes independently of executable behavior and debug
suppression.

## How it works

`Procedure` and `ProcedurePrototype` retain `NoteSyntax`: the decoded note name,
argument syntax, and original source span. The parser uses the same note parser
as record and field metadata. Notes after a body or prototype terminator belong
to that declaration; an optional following semicolon does not attach them to the
next declaration.

Semantic lowering captures note ranges from the actual `SourceRecord` before a
generic body, nested declaration, or inserted source changes lexical lookup.
Checked source metadata associates notes with the real `ProcedureId`. Callable
aliases preserve their target's notes, and generic specializations retain the
template's source notes under their own procedure identities. Source snapshots
remain owned after the original source map is dropped.

`DebugSources::procedure_notes(id)` exposes immutable `ProcedureNote` values.
Each retains a checked source location and exact source bytes following `@`,
including argument spelling and spacing. Capture checks source identity, UTF-8
boundaries, source order, and nonoverlapping ranges; publication checks procedure
ownership and the retained source snapshot. `#no_debug` controls debug emission
and does not erase user notes.

User notes do not execute their argument syntax. `@PrintLike` and `@ScanLike`
have no special print or scan binding in this compiler. The unchanged
`reference/modules/Check/module.jai` implements its own checks by reading
`Code_Procedure_Header.notes`. Its compiler AST introspection and diagnostic
protocol are separate prerequisites; retaining notes does not establish execution
of that module or the complete Basic formatter.

## How to change it

Extend `jai-syntax/src/procedure_notes.rs` for placement rules and reuse the common
note parser for note syntax. Add source capture paths through
`jai-sema/src/procedure_notes.rs`, preserving the defining source when procedures
are cloned or specialized. Extend the immutable metadata in
`jai-ir/src/debug_sources/procedure_notes.rs`; do not replace note bytes with a
reconstructed expression or expose mutable source ownership.

Compiler AST adapters must consume the retained source facts when implementing
`Code_Note`; invented flags or synthesized source ranges are not a substitute.
Entry-point aliases retain their own notes in source AST and must not overwrite
the target procedure's published metadata.

## Configuration

There are no feature flags or environment variables. Graph-based resolution
provides the canonical source snapshot. A legacy resolver without a defining
source snapshot diagnoses note capture explicitly.

Run `cargo test -p jai-syntax procedure_notes::tests`,
`cargo test -p jai-ir procedure_notes::tests`, and
`cargo test -p jai-sema --test procedure_notes` for the parser, ownership checks,
and source behavior fixtures.

## Dependencies

The shared source map and span model, the note lexer/parser, semantic procedure
identities and specialization, immutable IR publication, and checked source
provenance. Native debug suppression is a separate policy.
