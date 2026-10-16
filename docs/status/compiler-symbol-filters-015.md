# Compiler symbol-filter checkpoint

Owned isolated accepted015 compiler checkout; previous workspace options work is
already integrated and was not changed. Production changes are limited to
`crates/jaic/src/sema/using.rs` and `crates/jaic/src/sema/scope.rs`.

Fresh source-built baseline (`operator-filter-red.json`):

- symbolic Apollo subtraction: exit1, operator Sub missing;
- symbolic S128 subtraction: exit1, operator Sub missing;
- internal `operator-` string: exit0, contradicting official rejection.

After compiler fix, independent core suites pass: six new filter tests, two
operator visibility tests and twelve existing module-filter tests. They cover
all thirteen reviewed forms, private overloads of public types, only/except,
filtered reexports, aliases, storage identity and preserved aggregate filters.
Rust format and warnings-denied clippy are scoped to the owned files.

Canonical status is NOT green: Basic itself reexports arithmetic with the wrong
internal string filters. After the core fix its operator exports disappear until
the facade consumer is migrated. Both symbolic Basic fixtures still fail, and
the internal-string control correctly fails. The failed attempt is retained as
`artifacts/T7numerics/operator-filter-green.json`; its historical filename is not
a passing claim. Strict canonical lint is likewise retained as a failing receipt.
Shared owners were notified of all six affected facade consumers. No fallback,
private import, overlay or test-only library is counted as production proof.

No native executable build/run was attempted: integration's serialized native
suite owns that resource until it completes or grants a focused lease. No broad
corpus replay, SDK/platform claim, shared source/index edit, parser/LSP/callable
metadata edit, Extensions change, reference execution or remote action occurred.

Remaining: owner-approved canonical consumer migration, actual Basic interpreter
and strict-lint replay, serialized native O0/O2 proof, and reviewer confirmation
of additional filter forms. This checkpoint is a genuine compiler repair with
explicit integration prerequisites, not a completed canonical handoff.
