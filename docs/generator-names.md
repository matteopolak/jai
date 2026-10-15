# Bindings generator naming helpers

This clean-room batch owns precisely the eight public names in
[`implementation-scope.json`](implementation-scope.json). Its independent public
file is `stdlib/Bindings_Generator/naming-helpers.jai`; its private byte helper is
`stdlib/internal/developer-tools/generator-names-private.jai`. The latter uses
`#scope_module` so the public implementation can call it across files without
exporting it to importers. No canonical model, context, or lifecycle declaration
is added or changed.

The implemented selector subset shortens the caller's string view at its first
colon. For `setValue:` the result is `setValue`; `description` stays unchanged.
It keeps the original data pointer, allocates nothing, and leaves source bytes
untouched. The caller must supply a valid string pointer. The implementation
currently also keeps the portion before the first colon for multi-component
selectors, but that boundary choice has not been established by reviewed prose.
The function is therefore **partial**, not compatibility-complete.

The reviewed constructor paragraph establishes removal of the colon suffix.
The module inventory alone does not establish escaping, operator replacement,
selector print spelling, or enum naming policies. Seven other owned functions
remain missing; no placeholder procedures are exported for them. The existing
review questions also identify reserved/operator mapping as unresolved.
[`worker-inbox.md`](worker-inbox.md) requests precise public rules, including the
mutation contract of the void-returning `make_valid_identifer(string)` signature.

Facade integration remains with the coordinator: add
`#load "naming-helpers.jai";` to `stdlib/Bindings_Generator/module.jai` once the
selector boundary is reviewed. The original fixture imports the helper file as a
module directly, exercising actual export/private-module scope without editing
the coordinator's facade. Until integration, importing `Bindings_Generator`
alone does not expose the new function.

Run `python3 tools/verify_generator_names.py` with the assigned `CARGO_TARGET_DIR`
environment. It builds compiler/linter from this checkout with two Cargo jobs,
builds the actual Jai formatter, and verifies the three owned Jai files. Logs and
machine-readable command results are written under
`$CARGO_TARGET_DIR/generator-names-verification/`. The original fixture first
failed with the assigned selector function absent, then passed after its addition.

On 2026-10-15, all 18 verification commands exited zero: tool and formatter
builds; formatting; interpreter execution; Mac arm64 native O0/O2 builds and
execution; and source checking plus warnings-denied lint for Mac arm64/x64,
Linux x64, and Windows x64/arm64. Cross-target results establish source checking,
not native execution or SDK/linking. Tests cover empty, colon-free, and unary
selectors and source-byte/view ownership only. They establish no behavior for
the seven missing helpers or multi-component selectors.

No hacks, stubs, compiler changes, warning suppressions, duplicate records,
path-specific exceptions, publishing, or network messages were introduced.
The deviation from the requested full implementation is the explicit partial
selector and seven missing names awaiting reviewed public contracts. See
[`status/implementation-remaining.json`](status/implementation-remaining.json).
