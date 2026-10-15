# Code source reconstruction

The compiler reconstructs supported syntax from its own AST and the mutable
public Compiler graph. `compiler_get_code` and `compiler_modify_procedure` request
complete bodies independently of Program_Print's inspection options. No original
source-text fallback is used. Parentheses protect expression meaning, including
indexing, postfix dereference and cast operands with shift expressions.

The exporter and serializer now cover control-flow blocks, switches and cases,
multi-assignment, types and aggregate definitions, enum branches, generic headers,
constraints and modify blocks, imports and using filters, insertion directives,
run/assert expressions, quoted byte strings and the compiler's assembly AST.
Public syntax fields supply representable operands; private structural attributes
carry syntax absent from the reviewed public records, such as assembly operands
and assertion arguments. They are compiler-owned record associations, not source
text or additional public members. Type directives and modify blocks use the
reviewed public fields. Procedure alias declarations retain their original
reference expression while exported canonical headers retain procedure identity.

Floating literals retain value bits and applicable default/required precision
flags. Decimal spellings are regenerated; exact input spelling is not promised.
Native tests exercise reconstructed arithmetic, control flow, types, constraints,
using members and imports at O0 and O2. Independent compile-time tests verify
literal bits, structural assembly round trips, edited bodies and procedure-alias
identity. Negative tests retain implicit narrowing and unsupported module-map
diagnostics. Assembly serialization tests do not execute optional instructions.

## Boundaries and deviations

Reflection-only records without sufficient syntax, inconsistent edited literal
payloads, incompatible record kinds and unsupported directive combinations fail
explicitly. There is no fabricated type name, guessed syntax or success for
missing operands. The current parser accepts one modify block per definition;
multiple imported modify directives are rejected rather than silently combined.
Arbitrary copied-body ownership and conflicting scope-donor bindings remain
unsettled contracts. Existing scope selection is preserved; this batch does not
claim new cross-workspace binding semantics.

Comma-separated case values preserve the own compiler's accepted source meaning
through its existing comma-argument node. This is an internal reconstruction
choice, not a claim that the reference exports that grouping. Public case fields
are unchanged. Statement notes absent from public records are structural private
metadata; declaration/type/procedure notes use public fields.

The sanitized corpus grouping identifies seven printing failures on an older
snapshot. No original corpus bodies or raw logs were read, and these independent
regressions do not establish that those seven cases pass. Coordinator replay is
still required. Evidence is retained under `artifacts/compiler-mac-repairs/`:
`printer-regressions.log`, `printer-cli.log`, `printer-native.json`,
`printer-clippy.log` and `printer-lint.log`.
