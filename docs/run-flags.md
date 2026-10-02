# Run flags

## What it is

`RunFlags` preserves the scheduling policy written on a source `#run` directive. Its `stallable: bool` field distinguishes `#run,stallable` from an ordinary unflagged run.

## How it works

`Parser::run_flags()` consumes comma-separated flag identifiers after a `#run` token and returns typed `RunFlags`. Only the source-evidenced `stallable` flag is supported. Unknown, missing, or repeated flags produce diagnostics located at the offending token. Expression parsing stores `CompileTimeRun { flags, body }`; file parsing retains the same policy in `RunDirective.flags`. Flags remain outside the body AST and survive both source-request paths.

```jai
#run,stallable build();

KEYWORD_MAP :: #run,stallable -> Table(string, Keyword_Token) {
    // Anonymous compile-time procedure body.
}

#run,stallable {
    // Compile-time block body.
}
```

Flag matching uses `Token::spelling(source)`, so canonical identifier spelling determines the flag while the original token span remains available for diagnostics. The helper stops before the call, result arrow, or opening brace; the existing body parser handles the remainder.

An unflagged run receives `RunFlags::default()` with `stallable == false`. The helper rejects `stallable` in legacy execution mode with a diagnostic requiring resumable compile-time execution. `CompileTimeRun` separates these flags from the body AST so the execution request can retain its scheduling policy.

The supplied changelog describes `stallable` as supporting runs that can otherwise stall on one another and records the corresponding exported compiler AST flag. Here it is retained as scheduling policy, rather than treated as permission to ignore a dependency or fabricate a completed run. These parser tests establish syntax and flag propagation inputs. Actual suspension, resumption, wakeups, and result publication require the separate `SourceRun` execution integration and its live scheduler tests; syntax acceptance alone does not prove VM stall support.

## How to change it

Add typed policy fields in `crates/jai-syntax/src/run_flags.rs` and corresponding source-backed parsing in `crates/jai-syntax/src/run_flag_parser.rs`. Propagate flags through both expression and declaration run requests into the execution scheduler. Do not accept a modifier and then drop it at an AST or execution boundary.

The helper tests use authored call, anonymous-procedure, and block forms motivated by the Focus sources, plus canonical identifier spelling and precise malformed-flag spans. `jai-syntax/tests/run-flags.rs` checks public file/expression dispatch, default flags, operator boundaries, and the legacy execution diagnostic. They do not require distributing the original source corpus. Run `RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --locked -j1 --test run-flags` for the source AST regression. Validate scheduler semantics separately when modifying resumable execution.

## Configuration

No environment variables configure flag parsing. The source spelling `#run,stallable` sets the typed policy; omission leaves the default false value. The internal parser's `allow_qualified` mode determines whether unresolved source syntax is retained or legacy executable parsing rejects the resumable policy.

## Dependencies

The helper depends on `jai-lexer` token kinds and canonical spelling, `jai-source` spans and diagnostics, and the internal parser. It adds no external dependencies and executes no original compiler artifacts.

Evidence is in `reference/CHANGELOG.txt` lines 7582–7583, `corpus/upstream/focus-editor--focus/first.jai` line 18, the anonymous runs in `src/langs/hlsl.jai`, and the block run in `src/config.jai`. Corpus revisions and provenance are recorded in `corpus/upstreams.json`. The changelog also mentions `#assert,stallable`; this helper implements only the requested `#run` flag syntax.
