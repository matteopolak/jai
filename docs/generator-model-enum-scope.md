# Canonical enum lookup at the translation-unit boundary

The required `bindings-custom.jai` visitor could not convert `callback_apply`'s
`value` argument to the already constructed `Mode` enum. Independent official
libclang probes at O0/O2 report unsigned int, size/alignment4, and enumerator
values3/7. The canonical model preserves those exact properties. Its parameter
parent is the actual canonical Function; a global Function correctly has a null
Declaration parent. `Generator.global_scope` is a Block, not a Declaration.

`find_parent_enum` now searches that existing active global Block after its
ordinary lexical parent walk. Lexical matches and cycle rejection retain their
existing precedence. Each scope preserves member order and matches source or
output names. The global step checks the same active owner/ledger/target
relationship used by model access and validates the member view's byte extent.
It returns the existing canonical Enum, without changing parents, enum values,
layouts, records, caches, printers or compiler behavior.

Context-free lexical graphs still work. A missing or mismatched active global
owner does not supply global names; ordinary caller `push_context` restores the
outer lookup. For detached/manual declarations, searching a valid active global
scope is an explicit independent context policy, pending exact reviewed
membership clarification. It is not claimed as universal reference equivalence.

The public regression checks source/output renaming, lexical shadowing, true
parent cycles, impossible global byte extents, owner mismatch, restoration and
independently allocated enum type descriptors. Actual bindings emitted by the
unchanged customization fixture compile and execute with the real C provider:
the record call returns23 and mutates the lane to10; the converted enum argument
passes7 through the native callback and returns16. Interpreter/native O0/O2 and
existing tree controls pass. Complete module/consumer strict lint and formatting
also pass. Exact source/tool identities and separate receipts are in
`status/generator-model-enum-scope.json`.

The required combined C-model gate remains RED at the original fixture's later
line98, printing the incomplete `Opaque` record. The independent SDK and public
model reducer confirm `Forward` has a real4-byte layout and `Opaque` retains
size/alignment-2, no members, and the shared unknown metadata sentinel without
cache insertion or fatal Session state. Fabricating empty-record metadata would
conceal that distinction. The generator-platform printer owner has the exact
reducer and must resolve incomplete opaque emission. All five original C-model
fixtures remain required; the harness retains a nonzero result while that phase
fails. The reviewed C++ adapter work is a separate accepted handoff and was not
reimplemented here.
