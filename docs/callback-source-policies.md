# Callback source policies

Callback source metadata describes parameter evaluation, names, defaults and result obligations alongside the canonical runtime procedure type. Equal runtime types can expose different source contracts, so callback bindings and generic specialization decisions retain checked source facts separately.

## How it works

The annotation producer checks every source parameter type, including `#discard` parameters that have no runtime slot. `CheckedSourceProcedureType` validates the evaluated projection against the canonical ABI and stores the full checked source parameter vector. Its private ledger key includes the original file or lexical procedure owner, source annotation node, captured lexical scope identities, actual substitution and target layout policy.

`ContractSyntax` retains a tree of original callback nodes during alias expansion. Each node captures its producer environment and an immutable `Arc` proof before nested aliases are cloned. Imported private aliases, local aliases, callback results, container elements and record type arguments consequently retain their defining contracts. Consumers validate the proof's canonical type instead of looking up erased formal types in the caller scope. A proof that is not ready remains a genuine semantic dependency.

The pure callback preview reads established storage contracts, checked constants and actual procedure signatures. Field, index, pointer and concrete factory-result projections use existing metadata; previewing does not lower arguments or execute source expressions. Record receiver types remain available even when the receiver itself has no callback contract, so physical and promoted fields can recover their actual `FieldId` contracts. Lexical storage takes precedence over graph procedure lookup. Unknown source policies remain unknown. An already checked expected type supplies the canonical target for explicit casts and checked short lambda previews.

Valid sequence views retain an existing element contract when the checked source and target element types agree. A record or pointer `#as` conversion follows the existing conversion checker's physical field path and projects each field's source contract. These conversions preserve source metadata across a changed outer type without inferring a callback policy from equal runtime representation.

`CallablePolicyKey` records executable source parameter types, evaluation rules, names, normalized defaults and variadic positions, plus nested callback policies. Record bindings use exact symbol-keyed semantic map equality, with order-independent hashing. Recursive field traversal includes each actual record type and its per-use source bindings in the visited identity.

The opaque key exposes a private encoding visitor for compile-time replay origins. The visitor delegates actual type, field, symbol and checked constant identities to the replay encoder, including raw float/string data and certified runtime type constants. Record bindings are emitted in stable source-symbol order. Canonical type and checked value encoding uses explicit versioned tags and binary fields. Storage placement validates the actual field owner before encoding its physical ordinal; semantic arena numbers and debug formatting never become callback policy identities.

The policy key excludes `ResultUsage` and the bound callback target identity. Checked default values still retain their semantic value identity, including procedure-valued defaults. A `#must` change therefore uses the existing same-procedure recheck mechanism. Executable source policies distinguish generic specializations without adding annotations to canonical `TypeId` or record specialization keys. The current obligation suite passes 24 source tests, and the procedure-value suite passes 63 VM/native tests, including erased source-slot and private-annotation fixtures. Dedicated specialization key distinctions remain covered by the polymorphic fixtures; these bounded suites do not establish full original-corpus parity.

An inferred conditional joining equal runtime types with incompatible source evaluation rules, full source parameter types or variadic positions retains an ambiguous argument policy. Calling that value requires an authoritative destination annotation or cast. Result obligations still merge independently; choosing one branch's executable policy would silently change which source arguments run.

Runtime-read defaults key their checked storage root, canonical projection path and final type. Diagnostic source spans do not split an executable callback policy or replay identity; the codec retains the defining global declaration and its environment. A focused unit fixture checks that two reference spans share a policy while different actual field projections do not.

## How to change it

Annotation proof construction and storage live in `procedure_values/source_annotations.rs`. Graph and lexical annotation producers must publish full source types once, in the original environment. Preserve captured scope identities when changing expansion or retained declaration environments; repeated quotations can resolve the same source annotation in different lexical scopes.

Captured producer metadata lives in `procedure_values/contracts/expression_bindings.rs`. Keep its IDs separate from replay origins: source producer identity and checked semantic contracts establish provenance, while IR verification proves actual owner, type and lexical scope. Restore lexical overlays on every result path and preserve real physical field paths when regrouping aggregates.

Alias normalization lives in `procedure_values/contracts/syntax.rs` and `modules/callback_bindings.rs`. Preserve child provenance when adding a type syntax form. The pure preview and policy keys live in `procedure_values/contracts/policies.rs`; add a new preview path only when actual checked source metadata is available. Update the encoding visitor in `contracts/policies/encoding.rs` when adding a key variant. Keep result obligations outside executable policy identity, and preserve pending body proofs when strengthening a required-result contract.

## Configuration

There are no feature flags. Target layout policy is part of annotation proof identity. Existing constant-depth limits bound source normalization and metadata traversal.

## Dependencies

The implementation uses syntax source annotations, lexical scope IDs, actual procedure/field/type IDs, checked constant values, the callback registry and the polymorphic worklist. It has no external dependency and introduces no runtime ABI field.
