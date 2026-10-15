# Bindings generator naming helpers

All eight names in [implementation-scope.json](implementation-scope.json) are
implemented from the reviewed naming addendum in
[bindings-generator.md](specs/stdlib/modules/bindings-generator.md).
Import `Bindings_Generator` normally; the clean integrator added the facade loads.

Public procedures live in `stdlib/Bindings_Generator/naming-helpers.jai`.
Independent byte helpers and operator tables live in
`stdlib/internal/developer-tools/generator-names-private.jai` with private module
scope. Existing canonical records and reserved-name constants are reused.

- `avoid_cpp_keywords` changes only `this` to `_this`.
- `avoid_reserved_names` prefixes reserved matches with `_`, optionally including
  `Type`, and applies Jai-compatible normalization to operator names.
- `replace_operator_name` removes ASCII spaces and performs the exact reviewed
  substitutions, with the prescribed Jai-preservation mode.
- `make_valid_identifer` overwrites only hyphens and periods with underscores.
  Callers must supply writable bytes; the descriptor is passed by value.
- `convert_objc_selector_name_to_function_identifier` changes only string count
  at the first colon. `print_objc_selector_identifier` replaces every colon with
  an underscore while appending the whole selector.
- `get_enum_value_name` suppresses configured suffix matches before removing the
  first matching configured enum/value-prefix pair and optional enum-name prefix.
  Prefix removal returns borrowed views; reserved-word normalization is separate.
- `compute_enum_names` removes a delimiter-bounded common prefix, skips omitted
  values, normalizes reserved/empty/digit-leading names, and derives an anonymous
  enum name or uses `anon_enum`. `already_stripped` disables only detection.

Integrated access uses the model-owned unparameterized generator-session protocol.
Naming helpers read its borrowed active-options pointer through gm_active_options;
a null pointer uses the canonical Generate_Bindings_Options field defaults. The
separate typed Context value from the producer snapshot was removed during
integration. Fixture setup installs/restores one borrowed pointer to its live
local options record; every original behavioral assertion remains.

Policies for unspecified edges: detection requires at least two non-omitted
values; an empty source enum name is not a removable prefix; a nonempty delimiter
absent from the common prefix means no removal; an empty enum output name triggers
anonymous fallback. Existing nonempty enum output names and collisions remain.
Valid non-null model pointers and valid string descriptors are required.
Changed reserved/repair names use the active allocator. Operator normalization
returns allocated strings except for its two fixed Jai-preservation spellings.
Original model strings are not freed because ownership is unspecified.
Enum and selector slicing leave backing bytes unchanged.

Run `python3 tools/verify_generator_names.py` with the assigned
`CARGO_TARGET_DIR`. It builds compiler/linter from this checkout with two Cargo
jobs and the actual Jai formatter. Logs and machine-readable command results are
under `$CARGO_TARGET_DIR/generator-names-verification/`.

The two original public-import fixtures cover every reviewed operator mapping
in both modes, exact reserved lists, writable-byte mutation, multi-component
selectors, enum suffix/prefix order, borrowed slices, omitted values, delimiter
boundaries, anonymous names, suppression/disabling of automatic detection, and
empty, digit-leading, and colliding results. The new public-name fixture failed
before the implementations were added. Verification comprises 33 commands:
builds, formatting, interpreter and Mac arm64 native O0/O2 execution, plus source
checking and warnings-denied lint on Mac arm64/x64, Linux x64, and Windows
x64/arm64. Cross-target results are source-only, not execution or linking proof.

All previous naming contract gaps are resolved. No stubs, compiler changes,
warning suppressions, path/name exceptions, or publishing were introduced.
Exact committed-versus-draft inventory is in
[generator-names-remaining.json](status/generator-names-remaining.json).
