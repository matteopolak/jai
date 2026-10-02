# Anonymous field types

Anonymous `struct`, `union`, `enum`, and `enum_flags` annotations create real nominal types at their source sites. Nested fields use the same checked field IDs, layouts, defaults, and member namespaces as named record declarations.

```jai
Options :: struct {
    output: enum u8 { OMIT; EXECUTABLE; } = .EXECUTABLE;
    using common: struct { amount: int = 40; }
}
```

`output` receives its own enum identity and exact `u8` representation. Its leading-dot default resolves against that enum. `common` receives its own record identity, and its `using` field exposes `amount` through the enclosing value.

Contextual casts in defaults also receive the actual enum type: `enum_flags u8 { READ; WRITE; } = xx 3` retains that nominal flags identity. Checked `xx` validates the representation's range, while `xx,no_check` uses its wrapping width.

## How it works

The parser retains an anonymous body and its source span without inventing a declaration name. The semantic resolver reserves a registry type before visiting its fields. A key containing the defining file instance, source span, and enclosing record instance makes repeated resolution reuse the same identity while different source sites and template instances remain distinct. Outside a record, the typed enclosing substitution supplies the specialization identity. Member bindings can grow during forward resolution without changing a field site's identity.

`RecordBody` borrows either named or anonymous record syntax. Shared materialization builds member bindings, resolves real field types, validates layout attributes, and publishes owned field metadata after definition. Anonymous records retain their source file and substitutions for default evaluation and preserve field notes and record reflection metadata. Anonymous enums retain ordered members, aliases, representation width, `#specified`, and flags progression; reflection leaves their names absent.

Pointer recursion may refer to reserved containing records. Recursive by-value storage is rejected by the type registry. Failed resolution keeps its reserved identity for a later retry rather than allocating another nominal. Incomplete schemas cannot become frozen executable types.

## How to change it

Extend grammar in `jai-syntax/src/types.rs`; named and anonymous enums share their header/body parser. Extend identity and retry handling in `parameterized/state.rs`, and anonymous materialization in `parameterized/inline_types.rs`. Record changes should use `RecordBody` and the shared member/layout paths so named and anonymous behavior stay consistent. Local anonymous annotations use the lexical declaration resolver and its scope-owned identities.

Do not derive nominal identity from display names, create placeholder fields, or merge equal-looking bodies. Update the independently authored parser, semantic, and native fixtures when extending behavior. Anonymous record templates require a named template declaration, and modifiers/insertion obey the same checked execution requirements as named records.

## Configuration

There are no feature flags or environment variables. Target layout policy affects storage exactly as it does for named types. The existing constant-depth budget limits deeply nested anonymous schema resolution.

## Dependencies and validation

This flow depends on `jai-syntax` bodies, `jai-modules` file identities, typed polymorphic substitutions, `jai-types` nominal reservations and layouts, and the shared defaults/reflection resolvers. Tests are `jai-syntax/tests/inline-types.rs`, `jai-sema/tests/inline-types.rs`, and `jai-codegen/tests/inline_types.rs`. Native fixtures link only objects newly emitted from those independently authored sources.
