# Enum source namespaces

## What it is

Inferred source parameter types can follow transparent enum aliases before enum values finish preparation. Header inference uses the existing canonical enum type while the retained default job waits for its actual member value.

## How it works

Independent headers run while aliases and enum representations are still being prepared. A source expression such as `flags := ProtocolAlias.ERROR` must first establish its domain without asking the scalar evaluator to treat the alias as a module namespace.

`Nominals::source_enum_member_type` follows the actual declaration chain in each alias's defining file. It accepts an original enum declaration and an original named member, then returns that declaration's already reserved canonical `TypeId`. It follows transparent named type aliases and unannotated type constants. Distinct representations, arbitrary expressions, missing members, and cyclic or excessively deep chains receive their ordinary source outcomes.

The retained ordinary default job still evaluates the original member after its enum values are genuinely ready. No integer value, namespace declaration, or compatibility role is inferred from a spelling. The authored positive uses two aliases to an imported enum and checks a value with that original enum type. The negative requires an unknown-member error from the real source enum.

## How to change it

Change `modules/aggregates/types/enum_namespace.rs` when adding legitimate source namespace forms. `infer_name_constant` consumes the type fact before ready-value inference. Keep source declaration identity, defining-file lookup, and canonical enum identity together; a same-layout distinct type is not a transparent alias.

For selected early execution that also needs enum values, add a real dependency-selected enum preparation job. Inferring its type does not claim those values are ready.

## Configuration

The alias depth bound is 256. The session's normal target and type preparation policies govern the canonical enum; this helper has no platform-name or library-name configuration.

## Dependencies

`ModuleGraph` supplies original declarations and namespace resolution. `Nominals` owns the canonical reservations, while the existing enum producer and source default worklist supply checked values later.
