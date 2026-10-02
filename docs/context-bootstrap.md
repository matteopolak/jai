# Context bootstrap registration

## What it is

The selected source Preload can supply its initial context extension as quoted syntax. Registration happens before the single Context schema is defined, so the compiler never resizes a context record after procedure checking.

## How it works

When the module graph designates both Preload and Runtime_Support, semantic resolution reads `FIRST_ADD_CONTEXT` from that exact Preload module's exports. An application declaration with the same spelling has no bootstrap authority. The initializer must be structural `#code` containing `#add_context` declarations or blocks of those declarations.

```jai
FIRST_ADD_CONTEXT :: #code #add_context #as using base: Context_Base;
```

The collector preserves each declaration's source span and defining file. The schema builder prepends these extensions to ordinary graph context declarations and resolves their types and defaults in the quotation's defining scope. This allows `Context_Base` to come from the graph's designated Runtime_Support exports. Duplicate members retain the ordinary source diagnostic.

Quoted `#if` guards use immutable constants after source enums are registered. Only the selected branch contributes fields; inactive branch types and declarations are not resolved. Guards requiring typed procedure execution remain unavailable in this earlier bootstrap phase.

This bootstrap quotation is consumed as compiler registration syntax. It is not interpreted as arbitrary executable Code. Module quotation constants bind into the Code registry during the typed readiness phase; top-level insertion remains a separate unsupported phase. Runtime `#add_context` statements cannot change the completed schema.

## How to change it

Extend `crates/jai-sema/src/modules/context_registration.rs` for additional structural bootstrap forms. Keep the designated module and declaration identities authoritative. `modules/context.rs` consumes the ordered registration list with ordinary context declarations; preserve the defining file rather than rebinding names in the application.

If executable or generated registration is added, schedule it before schema definition with explicit readiness dependencies. Do not drop unsupported quoted statements or publish a partially resized Context type.

Bootstrap tests prepend `tests/fixtures/minimal-preload-schema.jai` to their small Preload quotations. This independently authored fixture supplies every required runtime descriptor declaration, including exact field order, embedding and flag values. It contains no executable bodies or runtime imports. Keep it aligned with the source-schema contract in `reflection/schema/preload.rs`; a designated Preload must pass the ordinary reflection validation even when the test only exercises context registration.

## Configuration

`BootstrapOptions.prelude` and `runtime_support` select actual source modules. Registration is disabled unless both modules are present. Selecting Runtime_Support requires its designated Preload to export the quotation; a missing marker is a source diagnostic. An application's similarly named declaration cannot supply it.

## Dependencies

`jai-modules` supplies canonical module exports and source identities. `jai-syntax` preserves quoted context declarations and statement spans. `jai-sema` collects registrations and builds the typed schema; `jai-types`, `jai-ir`, and `jai-vm` use the resulting immutable context definition.
