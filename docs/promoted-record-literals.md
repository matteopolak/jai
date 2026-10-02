# Promoted record literals

## What it is

Record literals resolve names through anonymous and `using` fields to real physical field paths. Both the constant and dynamic source adapters are registered. Dynamic construction uses immutable expression bindings and passes integrated VM and generated-native checks.

The pinned Jaison source supplies the motivating forms: `.{type=.NUMBER, number=3}` and `JSON_Value.{type=.STRING, str="junk"}`. Its `JSON_Value` stores the named tag beside an unnamed union, so `number` and `str` require real nested field paths.

## How it works

Resolve all literal names to canonical `FieldId` paths before lowering initializer expressions. Validate each parent and leaf type, duplicate or ancestor paths, and competing union alternatives. Union selection is keyed by the entire physical prefix: two fields containing the same union type may choose different alternatives.

Evaluate explicit initializer expressions once in their written order. Immutable expression bindings then let construction group leaves into the existing checked `RecordBuild` and `Union` expressions. Capture omission is safe only for already evaluated typed constants; a general static arithmetic expression can still trap and must keep its evaluation position. For example, `.{x=tick(1), middle=tick(2), y=tick(3)}` must call `tick` in the order `1,2,3`, even when `x` and `y` occupy the same anonymous child. A capture stays inside its source conditional arm, preserving lazy evaluation.

A union expression selects the actual source field. Construction never invents an alternative for unspecified zero union storage. Multiple promoted fields may initialize one struct alternative; selecting fields from competing alternatives is rejected.

Partial construction overlays a checked aggregate initializer or default override when one exists. Otherwise it uses the selected branch's individual field defaults. The public default boundary must finish the owning record's initializer before reading cached defaults. An unrelated default error remains an error; no diagnostic text is interpreted as permission to discard a default.

The constant and expression composition helper has eight construction tests and three canonical-path tests, exercised with the real type registry and IR verifier in a direct test harness. Four semantic tests pass for Jaison-shaped number/string defaults, selected branch defaults, partial defaults and overrides, and conflicting paths: five positive source programs return `42` in the VM, and three malformed programs are rejected. The same five positive programs also return `42` from freshly generated native output at both O0 and O2 in `jai-codegen/tests/anonymous_record_members.rs`. The complete native anonymous-member suite has ten passing tests.

The dynamic suite in `jai-codegen/tests/promoted_literals_native.rs` passes all eleven unchanged positive programs in the VM and freshly generated native output at O0 and O2. It covers interleaved effects, lazy arms, branch defaults, aggregate overlays, ordered overrides, generic fields, pointers, callbacks, strings, and raw NaN bits. Seventeen semantic tests are registered, adding five rejection cases and a literal parameter-default regression at the ownerless constant boundary; their Rust integration run is queued.

The frozen `a19b4808` CLI independently passes all seventeen semantic fixtures: twelve positive source bodies receive only an appended `#run main()` and result assertion, while the five malformed sources retain their expected rejection diagnostics. `artifacts/promoted-literals-cli-a19b4808.json` retains the exact binary, fixture and checked-source hashes, wrapper, and results. This proves compile-time VM behavior, including the parameter default, separately from the Rust test target.

The two CLI tests in `jai-cli/tests/expression_bindings.rs` pass the interleaved-effect and lazy-arm programs through both ordinary execution and `#run` evaluation, followed by native execution at O0 and O2. The ordered calls produce state `123` once; the unselected arm leaves state at zero. Both programs return `42`.

## How to change it

Keep field lookup and physical path validation separate from expression lowering. Extend the aggregate construction helper and the named literal resolver under `crates/jai-sema/src/modules/aggregates/`; retain the actual source metadata exposed by `FieldSource` and the canonical registry.

The staged `promoted_literals/indexed_source.rs` helper preserves relative member and index order, validates actual fixed-array owners and counts, and asks the defining-environment adapter only for already-ready integer constants. It rejects runtime indices, pointer/view targets, and dereference or insertion targets before any RHS producer runs. Its five tests pass in the private harness but remain unregistered until the coordinated indexed path engine and source syntax adapters activate; this helper alone does not enable indexed literal construction.

The private standalone harness passes all 24 tests using the existing trusted rewrite `jai-types`, `jai-ir`, `jai-syntax`, `jai-source` and lexer libraries, without rebuilding dependencies or registering live modules. `artifacts/indexed-literal-plan-private-proof.json` retains the exact Rust command and source, metadata and library hashes. Its 13 composition, five path, five source-path and one descriptor-target tests establish helper behavior; they do not establish semantic or native source acceptance.

The staged `target_expressions.rs` dependency helper visits original index expressions in source order and excludes relative field names from lexical dependency lookup. It bounds path depth and rejects runtime roots before collecting index facts. Three standalone tests pass; their source and dependency hashes are recorded in `artifacts/literal-target-dependency-private-proof.json`. Original generic target and index facts still require a paired checked producer with the defining environment before immutable default construction can consume them.

The private indexed plan (`indexed_paths.rs` and `indexed_tree.rs`) retains both actual `FieldId` projections and `(array TypeId, index)` steps. This distinguishes separate elements of the same union type, checks whole-array/projected overlaps, and validates budgets before copying paths or allocating element vectors. Partial arrays use the checked source initializer or override when present; untouched cells otherwise require a genuine element type default in the declaring field's environment. A failed or unavailable default remains an error. Root arrays have no declaring-field context and require a separate checked default producer before this plan can construct them.

`typed_source.rs` and `defaults/indexed_literals.rs` are unregistered adapters for the forthcoming `TypeSyntax` literal target and relative `PlaceSyntax` field target. They resolve all paths and validate defaults before lowering any initializer, then reuse the ordered capture and composition flow. Index checking uses the ordinary pure evaluator over actual ready lexical or declaration constants, never the source execution provider. Their pending semantic/native fixtures cover overlays, qualified unions, generic applications, structural sequence descriptors and named required callbacks; these are authored tests, not acceptance results. Parser-only readiness for the selected Focus, Jails and Vk Engine files does not establish semantic or native acceptance.

The shared `Bind` contains an ordered vector of immutable producers and a body; `Bound` refers to an opaque ID owned by the real procedure. Activate it only with the verifier, disposal, debug traversal, callback contracts, purity and lifetime visitors, native lowering, and both VM execution modes in one coherent change. Each producer may read earlier captures. A bound value cannot escape its binder, and exact types, float bits, pointer provenance, and aggregate storage must survive capture. Standalone compile-time expression verification also needs the actual owned root identity from the compile-time context; it cannot infer ownership from the first arbitrary binding or a placeholder procedure ID. The source allocator keeps an ordinal ledger per real owner in `MetaContext`; `Resolver.expression_owner` records explicit authority from source procedure construction or `compile_time.Context.owner`. Header and enum scratch resolvers retain `None`, even when their temporary procedure index happens to match a real procedure. New resolver construction paths must choose this authority deliberately.

Add source and generated-native witnesses for interleaved effects, skipped conditional arms, partial aggregate defaults, same-typed physical unions, callbacks, pointers, strings, and raw floating-point bits. Keep original project checks separate from independently authored feature tests.

## Configuration

The path and construction budgets are 128 levels and 65,536 cells. There are no new environment variables or user-facing flags. Source tests use the normal resolver options; generated-native tests should exercise both O0 and O2 with trusted system linking.

## Dependencies

The design depends on source-owned record metadata, canonical `jai-types` field identities, declaration-site defaults and overrides, checked `jai-ir` aggregate constructors, callback contracts, the ordinary and resumable `jai-vm` evaluators, and `jai-codegen` aggregate lowering. See [anonymous record members](anonymous-record-members.md) and [newer project entrypoints](newer-project-entrypoints.md) for the implemented storage behavior and original-source acceptance boundary.
