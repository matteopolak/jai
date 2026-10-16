# Code insertion and receiving lexical scopes

The human-authored reduction imports Basic, captures the unbraced statement
`a :: #code b := 2;`, inserts it, and prints `b`. Before this repair, the
compiler rejected the following use of `b`. It declared the local inside a
synthetic captured-lookup scope and only copied bindings to the receiving scope
when the two capture/site scopes differed.

Sanitized official 0.2.030 observations supplied by the coordinator establish:

| Payload / use | Result |
| --- | --- |
| Unbraced `#code b := 2`, use after insertion | Accept |
| Explicit `#code {b := 2;}`, use outside the block | Reject |
| Explicit `#code {{b := 2;}}`, use outside the blocks | Reject |
| Unbraced `#code N :: 2`, use before insertion | Reject |

No reference binary, raw reference logs, or reference implementation was accessed.

## Implementation

The parser retains an unbraced statement as `CodeBody::Stmt`, separately from
an explicit `CodeBody::Block`. Both Code exporter entry points use this AST
distinction; source spelling and single-statement span heuristics no longer
decide whether a public Code root is a statement or a block.

An unbraced insertion still uses the captured lookup scope (or the existing
explicit scope override). Its synthetic wrapper is linked to the receiving
declaration namespace. After successful checking, publication transfers canonical
entity bindings and root using entries, preserving storage, immutable constants,
selected callable headers/defaults and types. Captured parent bindings and
explicit child-block bindings are not reexported.

Publication validates collisions before changing the receiving namespace.
Ordinary overload eligibility and identical-signature checks are reused.
The overload checker compares logical declaration namespaces for these synthetic
wrappers, without changing call ranking or real nested-block declaration scopes.
This also diagnoses duplicate signatures in otherwise unreferenced procedures.

An explicit Code block is checked through the ordinary scoped-statement path,
including scoped defers and block checking flags. An unbraced deferred statement
retains the receiving block's lifetime. Existing scoped string-source insertion,
module-targeted insertion, for-expansion and capture mechanisms remain distinct;
the change does not establish new donor precedence or public alias rules.

Span, Code conversion, FIRST_ADD_CONTEXT and jailint walkers consume the
structural statement variant. The jailint adapter visits the actual statement;
it does not exclude generated Code from checking.

## Verification and deviations

The initial uncommitted tests wrongly assumed explicit root braces were
transparent. Their 15-pass receipt and earlier CLI control failures remain on T7,
marked superseded in the checkpoint metadata. No version of that insertion batch
was committed or exported. Corrected tests retain the exact human snippet and
all three newly supplied rejection observations.

Independent controls cover origin/site capture, receiving nested scopes, private
module captures, duplicate locals/constants/signatures, ordinary overloads,
forward Code values, forward declarations inside explicit blocks, using members,
canonical type aliases, callable defaults/names, macro private/backtick bindings,
scoped cleanup, and public compiler_get_nodes/compiler_get_code roundtrips.
AST export additionally preserves lexical shape when no source spelling exists.

Evidence lives under the worker's T7 `mac-repairs-audit/insert-declaration-scope`
directory. The [checkpoint](../status/insert-declaration-scope.json) separates
core/source checks, actual Mac ARM64 O0/O2 execution, actual Node WASI O0/O2
execution, strict lint and retained failed/superseded receipts.

Windows/Linux native execution and other architectures are not claimed. Full
corpus verification belongs to integration; no new broad corpus pass was run.
Unspecified arbitrary copied-body ownership, scope-donor precedence and unrelated
backend limits are unchanged. The suspended memory investigation remains suspended.
