# Module instance identity

Jai treats a module import's written argument list as part of its instance identity. The compiler preserves that order instead of sorting named arguments into a canonical list.

## How it works

`Compiler::load_module` keys the instance cache by the canonical entry path and its ordered `(name, value, type)` arguments. Repeating exactly the same ordered list shares an instance. Reordering named arguments creates a distinct instance, including independent mutable module globals. An omitted ordinary argument remains different from an explicitly supplied default. Aggregate argument identity includes its bytes and every relocation's offset, target kind/identity and addend; pointers to different globals do not collapse merely because their serialized pointer slots are both zero before relocation.

```jai
A :: #import "Counters"(LABEL = "jobs", LIMIT = 4);
B :: #import "Counters"(LIMIT = 4, LABEL = "jobs");
// A and B have independent module storage.
```

Program parameters continue configuring a shared instance through the existing separate program-parameter mechanism; this change concerns ordinary instance arguments. `Runtime_Support` remains a single compiler-loaded instance per program.

## How to change it

The cache key is constructed in `crates/jaic/src/sema/modules.rs`. Preserve argument order there and when collecting arguments. Sorting names or filling omitted defaults before forming the key would change the specified identity rule. The regression fixture is `tests/stdlib/module-parameter-argument-order.jai`.

Source-cache entries distinguish recursive loading, successful completion and
failure. Repeating a failed parse/load returns its original diagnostic; neither
file deduplication nor module/program-parameter deduplication turns failure into
an empty successful module. A new compilation creates a fresh loader cache.

Module arguments carry lexical float precision metadata through the cache and
untyped parameter bindings. Parameters with explicit types now convert the
original constant using the shared conversion machinery instead of synthesizing
a new literal AST. This preserves precision, explicit numeric types and pointer
relocations, and rejects required float64 values supplied to float32 parameters.

## Configuration

There is no compatibility flag. This is the documented compatibility rule recorded in the [language guide](../specs/jai/modules-workspaces-and-examples.md#imports-and-modules).

## Dependencies and verification

The module loader relies on semantic constant evaluation, module argument types and canonical filesystem paths. No external service is involved. Original tests in `crates/jaic/tests/cleanroom_modules.rs` verify ordered/default argument identity and pointer relocation identity without library dependencies. `sema::value` unit tests distinguish global/function/foreign targets, offsets and addends. These tests pass alongside the core unit suite.
