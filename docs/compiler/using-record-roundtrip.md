# Filtered parameter using reconstruction

Reviewed Code_Procedure_Header.parameter_usings carries Code_Using nodes whose
public filter_type/filter_expression describe parameter member promotion. The
Compiler graph conversion contract requires retained syntax and public edits to
preserve meaning. Program_Print's browsing contract permits unsupported forms;
it does not require a supported static name filter to fail.

compiler-using-records/main.jai had an obsolete assertion that static only(x)
printing must return false. It now checks successful exact printing instead.
Every original filter/header/body assertion remains. After that oracle migration,
the test exposed a real defect: procedure printing emitted the public using prefix,
then declaration printing repeated a private unfiltered using marker. The parser
accepted both and the second marker erased the original parameter filter.

Procedure printing now emits the parameter_usings graph once and disables the
declaration-level using prefix for parameters. Static name/map arguments are
exported separately from the editable public filter category, as private owned
canonical metadata. Changing ONLY to EXCEPT cannot reuse a stale only prefix.
Computed filter expressions continue to use the public syntax graph. There are
no new public fields/exports and no invented static-filter public graph shape.
Missing private static metadata rejects printing, rather than silently dropping
names when compiler/library snapshots are mismatched. Empty static filters are
distinguished from missing metadata.

The same scoped printer checkpoint adopts the retained __syntax_backtick_label
bit from c957c893. An actual Code->nodes->Code->macro invocation verifies caller
condition visibility and labelled break after reconstruction.

Independent using-parameter-roundtrip.jai checks bare/static/computed parameter
promotion, a reviewed mapper that mutates the original pointed-to member, exactly
one printed using, preserved public records, and changed
computed/static filter categories through actual calls. Three printer fixtures
pass interpreter and native O0/O2. The using-parameter fixture also builds and
executes as a WASI command, printing using parameters ok; that is execution,
distinct from its separately recorded WASM source check. Contextual strict lint
completes the contract root and owned printer fragment with no unvisited inputs.
Scoped Jai formatting uses a newly source-built own jaifmt; Extensions is intact.

Integration must adopt the compiler exporter and private printer together. This
worker edits only its own checkout. Evidence is under the durable local
artifacts/compiler-mac-repairs/using-printer-* and using-parameter-* paths.
Whole original corpus execution remains root-only and opaque.
