# Current shared reconciliation

The shared candidate already has canonical bootstrap and report-once setup. Integration retains existing production refactor coverage and the passing production doc test, adds the independent imported-doc regression, and checks the actual readable production hierarchy destination and exact symbol range. The producer replacement details below are historical, not changes blindly reapplied here.

# Clean dependency maintenance for editor regressions

These are LSP/compiler behavior tests, not compatibility requirements for a
replaced library's private source layout or prose. Reviewed public signatures and
the independently produced canonical prelude take precedence over legacy setup.
No library export, implementation body, assertion gate or diagnostic was relaxed.

## Exact corrections

| Owned test file | Failure classification | Replacement and retained assertion |
| --- | --- | --- |
| `doc_comments.rs`, `hierarchy.rs`, `refactor.rs`, `resilience.rs` environment helpers | Invalid dependency setup: `stdlib/prelude/module.jai` is absent; the single canonical `stdlib/prelude/module.jai` exists. | Select `jaic::PRELOAD_ENTRY` from the current compiler. No duplicate bootstrap or library fallback. This requires the current safe compiler dependency, not the isolated older compiler. |
| `doc_comments.rs::stdlib_declarations_show_their_docs` | Obsolete implementation-prose oracle: a particular print description, example and parameter wording are not reviewed public API contracts. | `imported_declarations_show_their_authored_docs` uses an original imported procedure. It asserts the exact authored description, fenced example and parameter documentation. Production Basic hover/definition remains separately tested by actual native requests. |
| `hierarchy.rs::outgoing_calls_reach_into_modules` | Obsolete private path oracle: the target was required to contain `Basic` or end in `Basic/print.jai`. | Require the real selected function name, a readable destination inside the actual independent production stdlib, and a selection range containing the exact `print` identifier. No fixed internal path. |
| `refactor.rs::offered_refactorings_always_parse` | Unavailable replaced-library sample files: `Autorun.jai`, `Example_Plugin.jai`, `MacOS_Bundler.jai` at the old flat root. They were not inspected or restored. | Three original fixtures cover expressions/defaults, records/enums/cases, nested procedures/loops/arrays. Preserve all four range selections per line, apply every offered refactoring, require strict parsing afterward and retain `offered > 10`. Also assert each original fixture parses. This is representative compiler/LSP safety coverage, not a claim of full corpus coverage. |
| `resilience.rs` project notification timing | Incorrect operation-timing oracle under valid dependencies: initial diagnostics already report the malformed `jai.toml`; completion correctly does not repeat it. | Trace proves the initial-open report includes `unknown setting colour`. Assert exactly one report across initial analysis and completion, with path/message checks retained, then require a second completion produces no duplicate. Production reporting is unchanged. |

## Evidence

All outputs are under the assigned T7 LSP root
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/scratch/file-uris-20261016/`.
Original failures remain in `focused-before-fixture-repair.log`,
`focused-before-layout-oracle-repair.log`,
`focused-before-flat-file-fixture-repair.log`,
`focused-project-notification-timing.log` and `project-notification-trace.log`.
The initial 17 documentation failures were not counted as a pass. No test was
ignored or a failure threshold lowered.

Against the current safe candidate with owned URI fixes, 140 focused checks pass:
29 library units and the integration targets `doc_comments` (22), `file_uris` (4),
`hierarchy` (11), `named_arguments` (10), `partial_edits` (20), `protocol` (7),
`qualified_values` (4), `refactor` (21), `resilience` (4), `source` (8).
The platform-conditional native Windows production test is **not executed on
macOS** and is excluded from this count. See [URI verification](lsp-file-uris.md).

The coordinator must complete the wider inherited-test migration, full merged LSP
suite and opaque public corpus checks. Other old fixture helpers were not broadly
rewritten or falsely called verified by this scoped maintenance batch. No repository
Jai/stdlib/Extensions file changed; embedded IDE documents are Rust test payloads.
