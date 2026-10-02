# Module source origins

`ModuleGraph::module_environment_origin(file)` returns versioned bytes identifying the defining module's source environment. Compile-time effect replay and captured definitions can append these bytes to their existing source origin, so equal source spans in differently parameterized instances cannot share a receipt accidentally.

## How it works

The envelope includes explicit target OS, architecture, byte order, and primitive layout; the module entry path; the ordered supplied import arguments; and bound parameters in formal order, including their declaration source slices. Ordered request identity preserves absent versus explicit empty argument lists, as well as named argument order. Program-wide parameter facts are encoded separately, sorted and deduplicated by their relevant source bytes. Appending an unrelated declaration does not change the environment; consumers separately encode the actual recipe body and owner locator.

Nominal type and enum values retain actual declaration path, span, name, declaration source slice, and the declaration's own defining module environment. Generic applications include their template origin and normalized formal-order arguments. Structural types preserve element types, lengths, and full procedure signatures. Recursion uses deterministic traversal reference ordinals, never allocation IDs. Exact weak decimal keys are retained as framed canonical key writes rather than rounded floats or hash digests.

Version 3 also describes each genuine inserted file: its destination occurrence, lexical capture file, original quote file and source slice, insertion ancestry, safety checks, debug policy, and captured bindings and values. Captured names are ordered by their source spelling. Source bindings retain their real declaration or member origins; byte strings retain arbitrary bytes, including NUL and non-UTF-8 bytes. The declaration encoder includes this file environment too, so two expansions of the same original declaration cannot collide when a later quote captures either expansion. File and module recursion share bounded deterministic traversal references.

An incomplete header, unavailable declaration, unresolved contextual value, or excessive structural depth returns `SourceOriginError`. Consumers must preserve that dependency failure; an empty fallback envelope would reintroduce replay collisions. The bytes describe identity, not a committed effect or permission to execute a modifier.

The semantic run consumer encodes canonical types and checked constants under explicit `v2` domain tags. Integer and floating-point values retain raw bits; source policy defaults use the same checked-value encoder. Structural canonical types do not acquire an ordinary alias origin; only actual nominal definitions contribute nominal source provenance. Record storage constraints retain packing, minimum alignment, per-field alignment and earlier-field placement ordinals. Placement anchors are checked against their actual owning record before their arena identity is removed from the encoding. Thus allocating an unrelated record first cannot change an otherwise identical storage layout key.

## How to change it

Extend `crates/jai-modules/src/source_origins.rs` when adding parameter values or source types. Add explicit tags and length framing, and bump the envelope version whenever encoding changes. Keep graph `source_requests` metadata synchronized with bootstrap and imported module allocation; it preserves instance identity even when bound defaults happen to match. Never serialize `ModuleId`, `DeclarationId`, `Symbol`, or semantic registry IDs directly.

`crates/jai-modules/tests/source-origins.rs` checks equal identities across fresh graphs, different values and named argument order, absent versus empty requests, recursive nominal origins, explicit targets, program settings, exact weak decimals after equal float rounding, contextual enum requests after nominal binding, incomplete headers, stability when unused declarations are appended, repeated quote occurrences across fresh graphs, changed capture values and debug policies, exact raw byte strings, structural captured types, exact weak decimals after identical rounding, and a later quote capturing a prior inserted declaration whose own environment changes. Consumers need their own replay tests in addition to these graph contracts. The semantic quoted-capture regression compares fresh origins after adding unused integer and required callback aliases; three focused run-origin tests cover typed storage keys and runtime layout policy.

The consumer's typed value encoder lives in `crates/jai-sema/src/modules/run_origin.rs`; storage layout encoding and its allocation-order regression live in `run_origin/stable_values.rs`. Keep physical field ordinals paired with checked owner provenance, and avoid debug formatting of semantic IDs when adding layout metadata.

## Configuration

The graph's supplied `BuildTarget` affects the envelope; an absent target has its own tag. Import search and source-provider configuration determine canonical source paths. This API introduces no environment variables or command-line switches.

## Dependencies

The encoder uses `jai-source` source records, structured module parameter keys, checked `jai-types` values and target facts, and `jai-eval`'s span-free exact weak float keys. Effect scheduling and replay remain owned by the driver and semantic effect adapters.
