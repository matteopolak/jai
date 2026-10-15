# Generator naming worker inbox

Current status: the reviewed naming addendum resolves the historical questions
below. All eight naming helpers are implemented and publicly integrated. The
latest handoff at the end supersedes the earlier partial status.

## 2026-10-15 — baseline 7467b49d: reviewed naming contract gaps

The reviewed module spec inventories all eight owned signatures but supplies no
naming algorithm, except the constructor paragraph saying Objective-C output
identifiers remove the colon suffix. `developer-tools-questions.md` item 14 also
identifies reserved/operator output mapping as unresolved.

Please provide a reviewed addendum with these caller-visible rules:

1. Exact keyword set and escape spelling for `avoid_cpp_keywords`; escape
   spelling for the published `RESERVED_NAMES`/optional `RESERVED_TYPE_NAMES`.
2. `make_valid_identifer(string)` has no result or pointer-to-string parameter:
   specify mutable-byte behavior, permitted bytes, first-byte and empty handling.
3. `replace_operator_name` input/output mapping and Jai-preservation subset.
4. Selector multi-component conversion and `print_objc_selector_identifier`
   spelling; whether colon suffix means the first colon onward or final colon.
5. `compute_enum_names` option precedence, delimiter/common-prefix rules,
   already_stripped semantics, fields mutated, omission/alias behavior,
   collision/empty/digit-leading handling; `get_enum_value_name` lookup misses
   and string ownership.

No canonical active generator/options context is declared in the current facade.
Please coordinate its owner if enum naming requires that context; this worker
will not introduce duplicate records or context storage.

Proposed integration: `#load "naming-helpers.jai";` in
`stdlib/Bindings_Generator/module.jai`. That helper owns its private helper load.
Facade integration is reserved to the coordinator. Tests explicitly load the
helper pending integration. No peer scaffolding is modified.

Independent work proceeds on the contract-backed selector subset, original
fixtures, source-built toolchain, formatting/lint, and native/interpreter checks.
Unreviewed public mappings will not be invented to mark names complete.

## Verification and handoff

The partial selector implementation and its independent private helper are ready
for review. The fixture imports the helper file as a module; facade loading is
still pending. All 18 commands in `tools/verify_generator_names.py` pass, including
interpreter and Mac arm64 native O0/O2 execution, actual formatting, and strict
lint/source checks for Mac arm64/x64, Linux x64 and Windows x64/arm64. Cross-target
checks are source-only. The exact per-name report is
`docs/status/implementation-remaining.json`; feature details and deviations are
in `docs/generator-names.md`. Seven names are missing and the selector is partial.


## Helper behavior review ready 2026-10-15 16:14 UTC

Refreshed bindings-generator. Naming/modifier/comment/cursor/alignment helper contracts now supplied, including shared CType copy-on-write, directive/omit/global movement policy, enum/selector/operator rules, spacing/last_location/comment fill. Read and implement all remaining assigned names; do not retain old resolved contract blockers. Unspecified ownership/edge cases permit safe independent policies documented honestly. Check factory is module-qualified get_plugin returning persistent Metaprogram_Plugin, not Check constructor; callbacks specified.

## 2026-10-15 — clean integrator: canonical active options and naming load

The facade now loads `active-options.jai` and `naming-helpers.jai` after the
canonical options declaration. `active-options.jai` declares the sole active
options context member, `context.bindings_generator_options`, using the existing
`Generate_Bindings_Options` record. Naming helpers read that member; callers can
assign it directly when using the helpers independently. The init/run lifecycle
owner must install the active supplied options before context-dependent helpers
run, including `run_generator` as required by the reviewed contract. This change
does not edit lifecycle/model scaffolding or duplicate any options record.

## Reviewed naming batch completion handoff

All eight assigned helpers now implement the reviewed rules, including every
operator mapping, enum suffix/prefix order and omitted-value handling, writable
identifier bytes, and both selector transformations. Public and private helper
files remain separate. Fixtures import the actual integrated Bindings_Generator
facade. All prior naming questions are resolved; no new contract blocker exists.

Canonical options access is context.bindings_generator_options, with no second
slot or options record. Lifecycle/tooling owners should use this field when
installing options before helper calls. Naming tests assign/restore it directly,
exercising configured behavior without modifying lifecycle scaffolding.

Verification covers both fixtures in interpreter and Mac arm64 native O0/O2,
repository formatting, and warnings-denied lint/source checks for Mac arm64/x64,
Linux x64 and Windows x64/arm64: 33 commands, with cross-target checks source-only.
Exact inventory is docs/status/implementation-remaining.json; independent edge
and ownership policies are documented in docs/generator-names.md. No stubs,
compiler hacks, warnings suppressed, or unresolved assigned names remain.
