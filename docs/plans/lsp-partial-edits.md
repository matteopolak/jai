# LSP partial edits and custom iteration navigation

Owner: LSP worker; integration after 0.17.0, for 0.17.1. No bootstrap,
release, version, Extensions, or other-worker changes belong here.

## Design

Use a separate IDE parser entry point with statement-boundary recovery. Keep the
strict parser and CLI behavior unchanged. Retain original byte spans and original
source text; omit malformed statements rather than synthesizing values or names.
Synchronize at statement separators, enclosing braces, and subsequent source lines
when a partial expression/header has lost a delimiter. Guarantee forward progress.
Syntax navigation and sema must consume the same recovery rules. Lexical errors
need IDE-only recovery too, particularly partial strings.

Alternatives considered: extending the existing six-pass line blanker risks deleting
unaffected declarations and scopes; reusing previous ASTs risks stale definitions
and requires offset remapping. Recovering current text at grammar boundaries uses
the compiler's existing independent-body checking. Semantic statement errors must
preserve subsequent independent statements in IDE mode, while recording real errors
and without declaring fabricated stand-in values.

The overload resolver already records the actual selected custom-iteration call.
Associate that selection with the keyword span in the custom expansion path.
Do not match spelling alone, change operand references, or attach expansion targets
to ordinary array/range loops. Aliases and polymorphic instances must navigate to
the underlying actual source procedure. Ambiguous selection must not claim a unique
target.

## Implementation and verification sequence

- [x] Add standalone LSP fixtures/tests for malformed statements and selected custom
  iteration; run them and inspect failures before implementation.
- [x] Implement selected-procedure keyword association; verify named, pointer,
  generic, overloaded, aliased, imported and ordinary loops. Commit reviewed progress.
- [x] Implement IDE parser recovery with strict-parser negative checks. Verify
  symbols, type hover, definition, completion, document features and incremental
  edits including Unicode; retain local syntax diagnostics. Commit reviewed progress.
- [x] Check IDE semantic continuation with no invented locals or swallowed errors.
- [ ] Add a deterministic suffix-edit corpus harness using baseline IDE coverage,
  varied byte/UTF-16 boundaries, explicit assertions, process timeouts and reports.
  Exercise original fixtures first, then all available public application and NEW
  stdlib sources. Record corpus availability and baseline gaps honestly.
- [ ] Run appropriate compiler and LSP tests, review the diff, update docs/README.md
  and questions, commit clean logical changes. Coordinator owns full integration,
  corpus and release checks. Do not benchmark.

User requests autonomous inline execution without questions or subagents;
that takes precedence over workflow skill review/handoff prompts.
