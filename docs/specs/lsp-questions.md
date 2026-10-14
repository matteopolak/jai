# LSP implementation questions and integration notes

- Named-completion compiler prerequisite: procedure-value parameter names/defaults
  must be associated with the resolved declaration/value, not merely interned
  `TypeId`. Two same-shaped independent callbacks reproduce name leakage; see
  [named completion evidence](../tools/lsp-named-arguments.md). Named procedure and
  associated-procedure headers are supported without this compiler change. Indirect
  callback completion stays explicitly unavailable; no private signature is guessed.
  Full merged native requests remain required with cf7dd80 and 5214e9c adopted.

- Recovery is an IDE service policy, not a Jai syntax/API compatibility extension.
  Recovery must never make CLI compilation accept malformed source.
- Indentation can help resynchronize malformed source, but it does not define Jai
  scopes. Prefer explicit delimiters; record cases where scope cannot be recovered
  confidently instead of returning a stale or guessed definition.
- Core overlap for coordinator: minimal IDE-only parser and sema changes are owned
  here; bootstrap/global compiler compatibility remains the compiler worker's work.
  Review `lexer.rs`, `parser/{mod,ide,stmt,aggregate,directive_stmt,expr}.rs` and
  `sema/{modules,ide,ide_meta,lower,stmt,procs,calls,consteval}.rs` during
  integration. In particular, block checking now retains real hoisting/context
  errors while checking independent later statements. Strict compilation returns
  the same errors immediately; recovered failed bodies cannot execute.
- Audit-phase overlap: a compile that stops before `finish_program` can leave
  speculative pending inserts. Resolving a nested helper's signature can retry the
  failed generator and recreate that helper indefinitely. The original
  `tests/lsp/partial/pending.jai` reproducer needs no library. The IDE audit now
  finalizes placeholders using the existing compiler flag before auditing other
  declarations; no CLI retry/bootstrap behavior was changed.
- Fresh unterminated opaque literals/comments without a prior verified boundary
  can hide the rest of their lexical region. Incremental edits retain verified
  boundaries, not old semantic facts. Missing braces with several plausible scope
  repairs remain a language-service policy question; explicit matching braces take
  precedence over indentation hints. Resource admission limits remain explicit.
- Initially only Extensions and the public corpus manifest were present. The worker
  fetched 1,044 pinned application/tutorial sources from the allowlist and captured
  independent library snapshots as production progressed: 244 then 284 Jai files
  from `../stdlib/stdlib`, plus 225 from `../compiler/stdlib` (including unchanged
  Extensions in each snapshot). These are separate inputs with baseline errors,
  not a claim that coordinator library integration is complete. The final integrated
  library and complete projects still require coordinator verification.
- The existing diagnostics suite requires `stdlib/prelude/module.jai` and Basic. With
  those absent in this clean-room snapshot, three tests return no semantic facts.
  This is a dependency/baseline limitation; do not recreate a legacy bootstrap to
  satisfy it. Standalone new tests explicitly disable runtime support and stack
  traces and assert actual typed facts, rather than treating empty diagnostics as
  evidence of successful compilation.
- Jai fixture formatting/lint integration remains blocked at tool startup. A fresh
  source build of `jaic-cli` succeeded, but compiling `jaifmt/main.jai` and running
  source-built `jailint -D warnings tests/lsp/partial` both rejected the local library.
  Retrying with `JAIC_STDLIB` set to the independent canonical library snapshot
  produced the same error. `crates/jaic/src/lib.rs` still validates `module.jai`,
  while CLI/lint drivers also select that legacy path. This belongs to the compiler
  worker's bootstrap integration; no duplicate file or alias was created here.
  Rust formatting and scoped Clippy pass. Intentionally malformed edit cases must
  retain their damaged syntax when coordinator reruns fixture tooling.
