# Typed heap constructor receipts

## What it is

The IR receipt retains the checked source binding for a typed `New` allocation and
its initializer event. It is a dependency carrier for typed heap windows and
captured storage graphs; it does not allocate memory or certify completed native
initialization by itself.

## How it works

`TypedConstructorOwner` keeps the actual original declaration and either its
checked procedure/signature or its module macro role. A macro never acquires a
replacement procedure ID. `TypedConstructorSource` retains the actual immutable
`SourceProcedureIdentity`; identity comparison uses its genuine source allocation,
exact span, retained text allocation and path. A reload with equal text is rejected.

A checked specialization retains `T`, the result pointer type, layout policy, byte
order, extent, alignment, default source scope and an optional initializer step.
The semantic source issuer separately validates the selected original module
instance and its accepted constructor/initializer/default substitutions. This IR
carrier does not recover those bindings from a type descriptor or record shape.

Native completion must match `same_issuance()` on the exact step payload. Graph
rebinding preserves `same_source_issuance()` while creating a new checked payload;
that relation cannot stand in for native execution. Rebinding retains the original
source definitions, initialization policy/event and target window, and validates
mapped types/signatures. It creates no completion witness or descriptor authority.

`retained_byte_upper()` accounts for receipt/step payloads, Arc headers, full source
text and source paths in constant time. Shared sources are conservatively counted
more than once. Layout failures retain `LayoutError`, including actual incomplete
reserved types, instead of turning readiness into a string-only error.

## How to change it

Keep the source issuer, native call/inline-success observer, Memory window ledger,
captured graph rebind and canonical source recipe consumer paired. Changes to the
IR result/statement marker require exhaustive IR, VM and codegen consumers in a
separate activation package. This finite packet registers only the receipt DTO.

The implementation is reconstructed from surviving authoring commands, with an
explicit current source-identity adaptation and repaired default-step consistency
validation. It is not claimed to reproduce a vanished historical tree byte for
byte. Four low-level receipt tests are authored but uncompiled and unrun; actual
source `New`, initializer cleanup, heap enrollment and compiler AST factories still
require their genuine producer/consumer packages and integration-owned gates.

## Configuration

The semantic caller supplies the actual target `LayoutPolicy` and `ByteOrder`.
There is no implicit target or configured-path authority in this DTO. One retained
Rust byte is one ValueCell for consumers that retain these receipts.

## Dependencies

The carrier uses `jai-source` original declaration/allocation identities,
`SourceProcedureIdentity::matches_identity`, checked IR procedure/parameter IDs,
`jai-types` pointer/signature lookup and target layout. Source catalog/module
instance selection, accepted specialization/default policy and actual execution
completion are separate prerequisites rather than authority invented here.
