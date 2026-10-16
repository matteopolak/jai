# Original-source callee resolution and execution guards

The named-completion audit found a genuine defect in the initial b064be58 query
projection: masking an unfinished argument list could make an altered procedure
valid. A following `#run` then compiled successfully and could execute that altered
body. The independent counter reproducer is preserved in T7
`scratch/file-uris-20261016/query-execution-red.log`. This follow-up is required
before final named-completion acceptance; b064be58 alone is insufficient.

## Proper resolver path

Source projections have been removed. An IDE-only parser query captures the actual
callee AST at the requested opening parenthesis **before** argument parsing fails.
It uses normal expression grammar, including nested calls, associated procedures,
generic/pointer/parenthesized receivers and indexing. Only the requested callee is
cloned. Declarations, strings/comments and mere grouping do not become fake calls.

`Compiler::ide_callee_at` resolves that actual AST through existing
`check_expr_no_emit`, in the original recorded semantic scope. It returns actual
procedure identities (including known constant procedure aliases), preserving
normal member lookup and private visibility. Dynamic procedure values without a
selected identity remain explicitly unsupported; the unsafe structural type-name
map is not read. There is no second text-name resolver, dummy value, body/argument
rewrite, whole-program recompile or source-offset translation.

Completed calls still prefer an actual unambiguous selected overload. Existing
reference facts remain usable for simple callee names; complex callees use the
actual AST so an argument near a closing parenthesis cannot be mistaken for the
callee. A following declaration is an unfinished-argument recovery boundary,
recognized by declaration punctuation rather than spelling. Ordinary expression
and member completion remain separate effective alternatives.

Strict CLI parsing does not set the capture hook. Original source, parser errors
and failed-body execution guards remain intact. The original counter test now
asserts compilation fails before/after the metadata query, real `f` identity is
returned, original text is unchanged and recorded parser errors remain present.

## Owned overlap and evidence

Ownership coordination was recorded in `docs/status/lsp-progress.md` before core
edits. Minimal IDE-only compiler overlap:

- `crates/jaic/src/parser/mod.rs`: optional query-only capture state/export.
- `crates/jaic/src/parser/expr.rs`: capture the real postfix callee before arguments.
- `crates/jaic/src/parser/ide.rs`: targeted parser query and original regression.
- `crates/jaic/src/sema/ide_meta.rs`: resolve original AST/scope with normal checker.

LSP changes: `src/named_arguments.rs`, `tests/named_arguments.rs` and
`tools/lsp_named_arguments.py`. No `ide.rs` visibility workaround, bootstrap,
strict grammar, ABI, module export, stdlib or Extensions change. Compiler ownership
still owns declaration/value-bound callback metadata; it is not implemented here.

Executed against the same safe independent production candidate on T7:

- 165 compiler units pass, including actual complex-callee capture and unchanged
  strict parsing. A new test initially assumed grouping parentheses belonged to
  AST spans; the compiler intentionally omits openers. It now uses the existing
  `lexer::balanced` convention. Original failure: `compiler-callee-span-oracle.log`.
- 142 focused LSP checks pass: 30 library units, 11 named API regressions and the
  existing URI/source/protocol/docs/hierarchy/refactoring/resilience/partial-edit/
  qualified-value targets. The nested method reduction was red before the proper
  resolver (`nested-method-red.log`), then passed with declarations after incomplete
  calls and an unrelated-global-name negative case. No assertion was disabled.
- Expanded actual native named requests pass 24 phases, two fresh servers and 38
  feature requests (26 completion, six hover, six definition), with production
  Basic, nested/overloaded/incomplete methods, parenthesized procedures, trailing
  healthy declarations, failed-body metadata, privacy and UTF-16 edits.
- Native URI requests pass four phases/two servers/24 feature requests again.
  Combined final native evidence: 28 phases, four servers, 62 feature requests.
  Programs with exit are not run. The independent integer-only compile-time
  counter regression uses the authorized source-built compiler.
- Scoped Rust formatting and Clippy `-D warnings` pass for compiler/LSP sources
  and selected tests; Python syntax passes. A test-module ordering lint was repaired
  without suppression; original log `safety-clippy-module-order.log` remains.

All receipts are below assigned T7 `scratch/file-uris-20261016/`:
`compiler-callee-final.log`, `safety-focused-final.log`, `safety-clippy-final.log`,
`safety-build-final.log`, `named-parser-final # % é/report.json` and
`uri-parser-final # % é/report.json`. No internal build/capture fallback.

Final effective compiler/LSP/test fingerprint:
`18edef73ae88071bda2607510bbff44bccabff88fde778c865055678f73a0725`.
Source-built jailsp SHA-256:
`a699efcf3fddc9b0e997e1e8f5986665e1f85fc814481cb12ca93e1ce5082e10`.
Safe input remains
`54e154044d20746ac1d12a98c485bbf966d2a09f7208e3efe6e263591f74ca27`;
final shared-source audit shows no drift. Staging preserves the independent
auto-import aliases/stdlib-root work and applies only narrow owned core diffs.

## Remaining requirements

The targeted IDE query may reparse a file when ordinary semantic facts cannot
identify an unfinished callee. No performance benchmark was run; any future cache
must bind the AST/facts to the exact source version. Full operand-aware incomplete
overload compatibility and declaration-bound procedure-value parameter metadata
remain compiler-owner dependencies. No callback completion is claimed.

Coordinator must adopt this follow-up with cf7dd80/5214e9c, b064be58 and the URI/
fixture handoffs, then repeat final merged native/corpus checks. Native Windows
jailsp/VSCode confirmation is still required; portable Windows codec tests and
macOS production requests are not native Windows acceptance.
