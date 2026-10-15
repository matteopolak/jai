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
| float-literal-precision | Old total-digit heuristic conflicts with reviewed Jai_Lexer fractional-digit flags. Compiler inference boundary needs review; retain numeric failures pending clarification. |
| macro-code-variable-arg | Exact whitespace obsolete; verify declaration/literal identity plus successful public printing. |
| modern-metaprogramming | Mixed formatting and supported AST print gaps; inspect each assertion, retain scope/type/backtick semantics. |
| poly-struct-type-names | Exact verbose instance spelling unestablished; require declared-name presence and retain parameter/identity metadata. |
| print-null-pointer-union-forms | Mixed Basic formatting oracle; review independently, preserve pointer/union/using field-offset assertions. |
| rules-code-values-and-insertion | Genuine get-code reconstruction parser failure for parenthesized assignment statements. |
| rules-compiler-module | Relative path normalization promise not established by reviewed inventory; test actual configured module lookup and metadata round trip. |
| rules-enums | Review exact Basic out-of-range marker; preserve numeric values/flags/reflection. |
| rules-numbers | Float inference needs same review as float-literal-precision; preserve integer/overflow/conversion checks. |
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
