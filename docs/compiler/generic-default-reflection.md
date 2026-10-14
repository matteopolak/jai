# Generic parameter defaults

Generic source descriptors retain shared identity across instances. Their
parameters array follows the source's declared parameter order and contains
names, types and defaults. A stored default has a nonnegative offset into that
descriptor's constant_storage, including zero and null defaults. Parameters
without a default have offset -1. Type-valued defaults use relocations to the
canonical reflected descriptor; strings retain their data relocations.

An instance's specified_parameters continues to contain actual argument values.
Its parameters contains declared defaults evaluated against preceding actual
arguments. A consumer implementing Basic's reviewed default-elision behavior
should compare these instance defaults with actual arguments by name/type/value,
using the respective constant_storage offsets. This handles, for example,
struct(T: Type = u8, amount: int = size_of(T)) instantiated with u32: the instance
default for amount is 4, while the shared source default is 1. Arguments without
defaults must remain visible, and the explicit print-all option bypasses elision.

A shared source cannot assign a concrete value to defaults depending on required
arguments. Such entries retain offset -1, and a type depending on an unbound
argument has a null type pointer. The instance record resolves both. Unbound
generic parameters have a distinct internal diagnostic category; only that
category permits symbolic source metadata. Invalid defaults and serialization
failures propagate as errors. Actual specified arguments are no longer silently
discarded after serialization errors.

The reviewed Basic behavior is explicit, but the reviewed prelude declarations
do not specify dependent-default metadata encoding. The representation above is
our independent implementation contract using existing public fields; the open
ABI question is retained in compiler-questions.md. No extra public fields or
exports were invented. Formatter integration belongs to the foundations worker.

Six original core regressions cover identity, required parameters, type/default
storage, dependent defaults, inferred pattern bindings and invalid declarations.
Native and WASM64 O0/O2 tests execute storage/relocation reads. Their deliberately
scoped test bootstrap uses reviewed fields and does not replace full integrated
prelude verification. WASM string comparison uses a real host memcmp over the
exported memory, consistent with the backend's existing external C dependency;
other unexpected runtime imports throw.
