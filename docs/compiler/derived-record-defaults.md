# Preserving reviewed record defaults through generation

The member inventory used by `generate-compiler-records.py` omitted six reviewed
inherited discriminator initializers. Three emitted declarations had been repaired
directly, but regeneration could remove those repairs. The coordinator's completed
declaration audit additionally confirmed defaults for Binary_Operator, For and
Procedure_Body records.

The reviewed inventory now contains the actual base initializers for all six
confirmed records: Ident, If, Procedure_Call, Binary_Operator, For and Procedure_Body.
The ordinary generator preserves them without a record-name-to-tag inference rule.
Regeneration changes exactly the three missing production base initializers;
the generated registry is unchanged. Existing explicit default overrides in
other inventory declarations continue to be emitted normally.

An independent program verifies all eleven explicit discriminators currently
represented by these base initializers and existing default overrides, using both
local default initialization and initialized `Basic.New`. It checks shared base
storage, then confirms that explicitly replacing the base with an empty initializer
restores UNINITIALIZED. Constructed binary and loop records copy public syntax
fields from ordinary compiler-exported nodes and produce executable Code with the
expected result. No caller discriminator assignment or compiler tag guessing is
used. A newly allocated Procedure_Body is tested only for its declared default;
this does not claim ownership transfer or submission support for fabricated bodies.

The generator now obtains its default formatter and containment validation from
the configured `CARGO_TARGET_DIR`, preserving the existing workspace target default
when unset. The actual source-built formatter and all build/scratch outputs use
the assigned T7 namespace. `--check` verifies regeneration and formatter idempotence.

This repairs the complete set of inherited defaults currently confirmed by review;
it does not assert that every other derived record has an initializer. Any further
missing declaration default still needs the exact reviewed inventory update, not
an inferred kind based on the type name.
