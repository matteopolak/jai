# Declaration lists

## What it is

Comma-separated declarations bind distinct source names while retaining the written type and initializer group. File bindings share one original syntax owner; local result lists use the existing checked result-destination path.

## How it works

`x, y: int;` declares two default-initialized values. `x, y: int = ---;` declares two actual storage places with no initializer writes. `x, y := 21;` captures the ordinary scalar value once and assigns that checked value to both places. Assignment and compound assignment use the same capture before updating any destination.

A call keeps its real result count: `x, y := pair();` executes once and binds its ordered outputs. A single-result call does not become scalar fanout. An expression such as `tick() + 20` is an ordinary single-valued expression and is captured once, including the nested call. This distinction matches `reference/how_to/010_calling_procedures.jai` rather than duplicating executable expression syntax for each name.

File declaration groups retain one `Arc<DeclarationGroup>` with the original expression, type, attributes, and individual name spans. The module graph still publishes a separate `DeclarationId` for each name. Borrowed metadata admission includes the Arc owner/counter bound and every original name/initializer capacity; separate member visits conservatively admit the same shared owner again. When one initializer supplies all file names, later jobs copy the first published checked value. A written initializer list retains each original expression once and binds its own ordinal. File call-result lists retain a specific joint-global-publication diagnostic; their multi-output worklist producer is a separate requirement. Grouped constants, external symbols, using bindings, and program exports likewise retain their individual-publication requirements.

Record field groups already produce distinct canonical fields. Their source spans now start at each actual written name. Existing record default jobs and layout policy remain authoritative; grouped inferred record fields still require a shared inferred-field producer. Reading a `---` local before a subsequent actual store remains subject to the VM's existing initialization checks.

## How to change it

Extend `jai-syntax/declaration_lists.rs` for grouped file syntax and initializer-list boundaries. Keep `DeclarationGroup` construction private, share its original initializer owner, and retain each name's source span. `jai-sema/results.rs` captures local outputs once; preserve exact direct-call arity and never replace a repeated destination with repeated calls.

File worklist changes belong in `modules/global_initializers.rs`. A future joint call-result producer must reserve every real output and publication ID, drive the original call once, and keep pending/cancel state until all selected values are available. Update borrowed AST metadata and compiler quote visitors when adding retained syntax. Do not normalize source text or manufacture placeholder expressions.

## Configuration

There are no feature flags or environment variables. The existing target layout and semantic/VM quotas apply. `---` requires a typed local declaration; mixed `---, value` initializer lists are rejected. Multiple written initializers must match the number of file names.

## Dependencies

The parser uses `jai-source` symbols and original spans. `jai-modules` publishes actual file bindings. `jai-sema` reuses result capture, callback contracts, canonical record layouts, and the existing global-initializer worklist. Checked storage and runtime execution use `jai-ir`, `jai-types`, and `jai-vm`. `tests/declaration_lists.rs` in syntax and semantics covers retained owners, source identities, no-write storage, arity, side effects, and runtime results; the integration receipt records whether these tests have actually run.
