# Mac compiler catalogue repairs

Scope: the 22 unresolved compiler entries in the stable Mac JSON baseline,
using this approved integrated d30311a5 snapshot and reviewed specs only. Baseline
JSON is preserved as measured evidence; this ledger records focused follow-ups.
No live mutable `::` aliases, catalogue routing changes, native prerequisite setup,
Default_Metaprogram changes, profiles or benchmarks are included.

## Initial classification

| Fixture | Reviewed classification / next action |
| --- | --- |
| build-options-main-defaults | Automatic main output name/path/`.build` not promised; retain reviewed struct defaults and explicit metadata round trip. |
| compiler-build-file-and-literals | Unavailable debugger is a capability error; move it to a required negative regression. Program_Print has no canonical whitespace contract; retain AST values/types and literal escaping. |
| compiler-get-code-rerun | Removed unreviewed `code_to_string`; use public Program_Print with structural name/value assertions, retaining nested get-code rerun. |
| compiler-reflection-pure | Missing **public** compare_alloc_and_free_traces (Protocol spec). Preserve assertion; portable dependency owner request. |
| compiler-resolved-nodes | Exact whitespace obsolete; structural/typed/modify checks remain. Public compound printing currently returns false: supported printing extension needed. |
| compiler-typechecked-notes | Genuine candidate: previously published header body pointer does not update. Preserve notes, identity and body assertions. |
| custom-link-library-lists | Reviewed completion takes only Workspace; extra status argument obsolete. Corrected API exposes separate missing portable_crash native prerequisite. |
| float-literal-precision | Reviewed compiler metadata counts fractional digits, excluding trailing zeroes. Correct default types; explicit rounding replaces invalid implicit narrowing, with separate rejection tests. Replace obsolete 18-significant-digit formatting assumptions with actual rounded-value checks. |
| macro-code-variable-arg | Exact whitespace obsolete; verify declaration/literal identity plus successful public printing. |
| modern-metaprogramming | Mixed formatting and supported AST print gaps; inspect each assertion, retain scope/type/backtick semantics. |
| poly-struct-type-names | Exact verbose instance spelling unestablished; require declared-name presence and retain parameter/identity metadata. |
| print-null-pointer-union-forms | Mixed Basic formatting oracle; review independently, preserve pointer/union/using field-offset assertions. |
| rules-code-values-and-insertion | Genuine get-code reconstruction parser failure for parenthesized assignment statements. |
| rules-compiler-module | Relative path normalization promise not established by reviewed inventory; test actual configured module lookup and metadata round trip. |
| rules-enums | Review exact Basic out-of-range marker; preserve numeric values/flags/reflection. |
| rules-numbers | Correct `9876543210.125` default to float32 under the reviewed fractional-digit rule; all integer/overflow/conversion checks retained. |
| rules-scoping | Module-private name is incorrectly expected exported; retain internal cross-file reads and require absence through namespace. |
| rules-structs | Exact verbose generic type spelling unestablished; retain canonical reflected name, identity/layout/default checks. |
| struct-using-member-path | Genuine candidate: aliases through a pointer member fail scope/type checking. |
| type-of-polymorphic-template | Mixed exact pretty-name expectations and signature metadata; preserve template/instance distinction and concrete argument/return types. |
| using-only-import | Excluded names are incorrectly expected fallback-visible; require absence and use named namespace for explicit other exports. |
| void-values-print | Plain void contract is established; dereference of null void pointer requires separate semantic review. |

## First cohesive migration group

Six fixtures pass interpreter and actual native ARM64 O0/O2 after oracle repair:
build-options-main-defaults, compiler-build-file-and-literals,
compiler-get-code-rerun, macro-code-variable-arg, rules-scoping, using-only-import.
Commands use the existing catalogue runner with one exact filter each; local
reports live in artifacts/compiler-mac-repairs/verified-migrations. No passing
test relies on ignored print failures or removed correctness assertions.

custom-link-library-lists passes interpreter with -no_workspace_output after the
arity correction, but the normal runner still fails loading the absent
crash-native/portable_crash library for its child executable. This remains a
prerequisite failure, not a pass or compiler fix; integrator owns setup.

The initial compiler-resolved-nodes repair exposed compound-print failure instead
of inspecting a partial string as success. The implementation below resolves it.
The compiler-reflection-pure missing public helper is not removed.

## Statement printing and reconstruction

Program_Print now prints compound declarations, comma-separated values, plain
#exists queries, and backtick identifiers/declarations through reviewed fields.
Mixed existing/new declarations retain assignment markers. Compound export
preserves per-name HAS_SCOPE_MODIFIER flags, which an original round-trip test
first reproduced as an unknown caller variable. Compiler.compiler_get_code prints
a root without expression-only parentheses, permitting assignment statements
to parse as statements. No source text or symbol-name matching is involved.

Original code-roundtrip-statements.jai executes assignments, typed/mixed compound
declarations, existence queries and caller-visible backtick bindings. Interpreter
and actual native ARM64 O0/O2 pass. compiler-resolved-nodes, including procedure
modification assertions, now passes; its native runner result is honestly
compile-time-only (the test disables root output), not executable execution.

New(Code_Ident) was incorrectly expected to override inherited kind defaults.
The reviewed Code_Node default is UNINITIALIZED and Basic.New applies declared
defaults. The fixture now verifies that default, explicitly sets IDENT/name, and
checks successful printing of the constructed node.

rules-code-values-and-insertion also confused backtick caller-scoped defer with
per-iteration cleanup. The immediate per-iteration example now uses ordinary
defer; a separate caller-scoped defer check proves it stays pending until the
caller block exits. Neither lifetime check is dropped. That fixture passes actual
interpreter/native O0/O2. Parameterized-name fixtures retain declaration names,
instance identity, parameter values and concrete signature metadata; exact verbose
spelling/spacing is not established by polymorphism-and-metaprogramming.md.

Known print bounds remain explicit: unsupported Run/assert procedure encoding,
non-null Code_Directive_Exists.sync_expression, and mixed typed assignment
records return false. No unknown public fields or placeholder procedures are
added. These forms require reviewed representation contracts before extension.
The modern-metaprogramming migration requires that unsupported Run printing
report false and independently tests supported #exists printing, rather than
present partial output as successful assertion serialization.

Initial and focused reports are stored locally under artifacts/compiler-mac-repairs.
The assigned T7 compiler target holds reproducible build output only. Native
execution is distinguished from source checking and compile-time-only workspaces.

## Typed member paths and late record links

Typed fields are now collected as deferred Declaration items for forward layout.
The struct using-path classifier previously recognized only already-expanded
Field items, mistakenly treating a field name as a global type expression. It now
recognizes both declaration forms without changing layout/reflection order. The
original pointer-path fixture passes; a new core test verifies actual read/write
identity and exclusion of filtered members. All 11 layout tests pass.

Records preserve identity while their materialized pointer fields can initially
be null. A published procedure header's body becomes available later, but its
cached object was never linked. Records now journal mutated identities across
temporary lends; each builder revisits only changed records with pending null
references. Newly ready targets are queued/materialized and linked into the same
object. Other fields and metaprogram-supplied non-null pointers are preserved.
Failed fills roll back new links and cached allocations before retrying. The
original notes/header-identity/body assertion passes unchanged. A separate core
regression checks cyclic links, edits, failed target fill/repair and pointer
identity; 165 library, 11 layout and 8 reflection tests pass.

This deliberately handles null-to-ready references, not arbitrary changes to
already populated scalar/list/non-null fields. No record/type/field-name exception
exists. The journal and pending-link index live for the compilation's lifetime;
work is proportional to mutations and affected pending fields, without scanning
every previously built record for each message. No benchmark claim is made.

## Final focused result and oracle reasons

Machine-readable scope/result ledger: [compiler-mac-repairs.json](../status/compiler-mac-repairs.json).
Stable source checkpoints: b377ed7c (public-contract migrations), 427fbfdc
(statement/compound Code printing and reconstruction), 6d5e2172 (typed using
member paths), 9e527a22 (late metadata links and rollback).

Fresh normal interpreter replay: **18 of the original 22 now pass**. Existing
runner verification at O0/O2 records **16 cases executing natively** at each
optimization level; resolved-nodes and typechecked-notes are **compile-time-only**
at each level. The original round-trip fixture additionally executes native
O0/O2. Scoped Rust/Jai formatting, strict positive lint, core clippy and the
negative debugger capability regression pass. This is not a full baseline rerun.

Additional oracle migrations retain the useful public behavior:

- modern-metaprogramming requires successful printing for supported nodes and
  explicit false for unsupported Run/assert printing, with real ASSERTION flags;
  it retains macro scope, Code values, typechecked expression and code_of checks.
- rules-compiler-module tests the configured directory through an actual child
  workspace module import and error-checked completion; it no longer assumes
  relative/absolute readback spelling based on #file formatting.
- rules-enums preserves numeric/flag/reflection assertions and requires both
  the out-of-range marker and numeric value, without unreviewed punctuation.
- print-null-pointer-union-forms preserves pointer formatting and using offsets,
  checks callable/null-procedure behavior and union storage, without unreviewed
  non-null procedure prefixes, union fallback spelling or type-name spacing.
- void-values-print formats two real void values plus a null pointer. It does not
  manufacture a second void value by dereferencing a null pointer.

Two retained red cases require outside input: compiler-reflection-pure (missing
reviewed public portable export), custom-link-library-lists (native prerequisite).
The decimal review follow-up below resolves the other two. Full details
are in ../status/compiler-mac-owner-requests.md and the questions document. No
numeric assertion or missing public comparison is removed, and no prerequisite
is disabled. Program_Print's explicit Run/assert limitation is still a limitation,
not implemented functionality or a reference round-trip guarantee.

## Reviewed decimal inference follow-up

The updated language specification confirms fractional-digit metadata, not exact
float32 representability or total digit count. No compiler behavior was changed.
The two fixtures now require float32 for the reviewed large integer-side
literals, float64 for eight uncontextualized fractional digits and nine required
digits, and allow float32 context for the eight-digit default. Explicit PI_LONG
rounding is tested; direct initialization and arithmetic implicit narrowing each
remain required compiler errors in original negative fixtures.

Old large-number printing strings assumed an unreviewed 18-significant-digit
policy. Those checks now validate actual rounded values instead; the existing
PI/infinity formatting checks remain. Both fixtures pass normal interpreter and
actual ARM64 O0/O2 execution. WASI verification here is source checking only.
The scope ledger now records 20/22 interpreter passes, 18 native executable passes
and two compile-time-only cases per optimization level. The two external owner
dependencies are retained, not disabled.
