# Default Type values use the void descriptor

An implicitly initialized `Type` value is `void`. Before this fix, the default
initializer returned no image for Type, so locals and globals received zero
bytes. That created an invalid descriptor address rather than the canonical
value. Printing such a value exposed the defect in the descriptor renderer.

The Type arm now writes `Value::Type(void)` into a default image using the
existing constant writer. That writer supplies the canonical type-metadata
relocation, also used by explicit `= void`. Existing struct, fixed-array and
distinct default-image recursion preserves the relocation at every nested field
or element. The same image serves local/global initialization and generated
reflection initializer procedures; no additional lowering change is needed.
Explicit field initializers still replace overlapping default relocations.

No formatter, Any boxing, public signature or nominal type identity rule changes.
An ordinary pointer still defaults to null. An explicitly null Type_Info pointer
remains invalid for the type-name renderer; its assertion is unchanged. The
separate null-lvalue Any consumption defect and valid typed-Any null fallback are
outside this patch. Required cross-compilation failures are also retained.

The coordinator's actual official Jai0.2.030 native observations establish
`void` and `{void, 0}` for scalar/record defaults, and all six scalar, record,
fixed-array and explicit identity controls are true. The independent official
identity probe uses a void entry point; an earlier integer-entry probe was
rejected and remains separate. Only sanitized observations are supplied here,
without reference bodies, logs or executables.

Eight independent core tests cover the canonical relocation, local/global
scalars and records, nested fixed arrays, generic and distinct records, explicit
nonvoid overrides, pointer defaults and generated reflection initializers.
The first six tests failed before the Type arm was added. Existing reflection,
module and interface regressions also pass.

`tests/compiler-semantics/default-type-image.jai` exercises those initialization
paths against the actual independent library. The unchanged producer identity
fixture and `tests/corpus/positive/print-null-type.jai` provide focused runtime
controls. The latter keeps its program body and updates only the obsolete
expected output, description and explanatory comment. Every other catalogue
entry, including the separate Any fault expectation, remains unchanged.

The ready receipt under the worker's T7 `default-type-8e81` namespace records
source hashes, exact commands, interpreter and macOS ARM64 O0/O2 outcomes,
format/lint results and initial failures. Tools are built from approved
8e81e901 plus this exact arm; the frozen f1/7d51 compiler source is unchanged
in that approved base. No Windows/Linux/WASM runtime result is inferred from
host runs. Integration owns shared staging and combined replay.
