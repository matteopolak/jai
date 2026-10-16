# Checked declaration source associations

This repair consumes independently authored reductions/oracles transported in
`producer-handoffs/current-repair-batch/ide-navigation-reductions`, source checkpoint
`36ea131e`. The three families are procedure-type parameter declarations, named
generic-struct callback arguments, and inherited-member default assignment paths.
All supplied exact declaration targets remain strict. Builtin no-source reviews
are not used to waive any of these targets. No corpus report or scanner eligibility
rule is changed.

## Cause and repair

- Procedure-type parameters already had typed hover facts, but no declaration
  association. `ide_note_param_name` now records the authored name span as its own
  declaration, using the existing source-association map. Procedure-type named
  results now receive the same facts in `expr.rs::proc_type_from_header`.
- A successful polymorphic-struct call checked argument values and selected an
  instance without recording its named argument labels. The `check_call` branch
  now records labels after successful instantiation. The IDE helper uses that
  instance's actual struct AST and directly bound constant entities for declaration
  spans and resolved types. Dependent/baked parameters and aliases follow the
  selected instance. There is no additional lookup, evaluation, speculative
  signature, or callable metadata inferred from structural procedure type identity.
- Default assignments use a dedicated existing field resolver. Its internal
  `find_used_member`/`struct_member` result now carries the selected field's authored
  declaration span alongside its unchanged offset/type. `override_target` and
  `override_path` record each successfully selected segment with that exact span.
  The same resolution order and diagnostics remain in force, including promoted
  members, nested paths, and zero-valued overrides.

Core ownership was announced before edits: the above functions plus IDE helpers.
No overlap with runtime-owned `scope.rs::module_declarations`, parser/scanner,
`decls.rs`, IR lifetime, visibility, bootstrap, or module selection changes.

## Regressions and execution

`crates/jai-language-server/tests/navigation_associations.rs` embeds the three
transported source reductions with exact target coordinates. Three further original
cases cover distinct authored names sharing structural parameter types, named
results, dependent/baked/aliased struct arguments, and nested/promoted zero overrides.
Every case checks hover and exactly one correct definition in complete, unrelated
incomplete-suffix, and restored states. Edits use actual UTF-16 ranges through a
non-BMP comment. Complete states require no error diagnostics; the incomplete state
must produce an error confined to the appended suffix.

`tools/lsp_navigation_reductions.py` exercises the transported JSON oracles through
actual stdio LSP requests, one fresh server per document, sequentially. It writes
full requests/responses and diagnostic phases in the assigned T7 namespace. It
never executes a document as a program. Example, with explicit approved inputs:

```sh
python3 tools/lsp_navigation_reductions.py \
  --binary "$OWN_T7_TARGET/debug/jailsp" \
  --stdlib "$APPROVED_603_STDLIB" \
  --fixtures ../producer-handoffs/current-repair-batch/ide-navigation-reductions \
  --output "$OWN_T7_CAPTURE/native"
```

The controlled source is frozen `60321c1de653dfb416f64ed000d38b657e7bbc9a` plus
the already accepted stable LSP patches and separate passive metadata cohort,
then only these four Core files and the new test. Source/native dependencies use
the exact 603 receipt; no old producer Core overlay is copied. The source-only
copy reuses prior proofs and does not rerun the root corpus audit.

Durable capture:
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/scratch/navigation-603-20261016`.
Final inventory fingerprint:
`3ce9259f62f77c10fed2622ed7e2f526c60475e77f5c46d05d581906b64d3e4e`.
Fresh source-built jailsp SHA-256:
`77bdefe7c27f9fe61d3cac2ed2b5ad49db50294c8d2b093c14c77708de873987`.
`final-source-guards.json` records all source/input hashes, with exactly four
changed Core files and one added Rust test against the captured base.

Evidence:

- Native red: 15 strict mismatches over nine phases; all complete documents error-free.
- Unit red: all three transported regression families fail for their missing facts.
  A separate named-result control exposes its missing hover before the result hook.
- Green: all 179 LSP library/integration tests; all 168 compiler library tests
  (nested subprocess test summaries are not added to the outer count).
- Final focused check: six navigation cases pass, including strict suffix errors.
- Fresh final native: 42 requests, nine phases, three sequential servers; zero
  oracle mismatches and complete documents error-free. Earlier 118-request proof
  remains a separate cohort and is not projected onto this binary.
- Scoped pinned nightly Rustfmt and compiler/LSP Clippy `-D warnings` pass.
  No new Jai/stdlib file requires formatting. No stdlib/Extensions changes.

Setup failures are retained: initial test String/DocumentUri comparison error;
formatter invoked from the capture selecting stable instead of the repository's
pinned nightly; source guard rejecting an AppleDouble sidecar created by copy2.
The test type was corrected, formatter toolchain explicitly pinned, and the
non-source sidecar removed before the successful final guard. None was counted
as a functional result, and no production source or assertion was weakened.

## Integration and limits

Apply the new narrow repair patch to the current clean shared compiler, preserving
`cf7dd80`, `5214e9c`, callee-query safety, URI fixes, and callback metadata. The
separate metadata `74e4f3e7` and proof `8fea8b6f` cohorts remain independently
reviewable. Do not replace current Core files with older producer copies.

Native Windows and final merged checks remain required. Root owns the full corpus
and next scanner pass; these bounded original reductions do not establish corpus
acceptance. Facts here require an actually checked signature/instance/default
path. Uninstantiated generic-body coverage and synthetic builtin source contracts
are not resolved or fabricated by this repair. No workaround or waiver is added.
