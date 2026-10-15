# Wide conversions, division diagnostics and scalar FNV

The current reviewed Basic/Hash contracts resolve the earlier pending questions.
Public facade aliases preserve the complete overload sets and conditional scope.
Private code remains grouped by numeric responsibility rather than spec order.

`to_s128` specializes only for reflected INTEGER sources. Its low half uses the
no-check u64 conversion; its high half sign-extends the ordinary s64 conversion.
Thus `u64` values with their high bit set produce a negative high half. `to_u128`
accepts exactly u8/u16/u32/u64 and zero-extends. Both reject records, booleans,
floats, enums and distinct integer types through #modify. Signed wide division
now explicitly converts its internal bit representations, rather than relying
on public conversions that intentionally reject S128/U128 records.

`test_unsigned_division` is exported on CPU.X64 for every OS. Its independent
deterministic samples include zero, maximal halves and a quotient at the u64
limit. Every sample prints decimal `high:low / divisor = quotient remainder r`
and verifies reconstruction using the separate 64-bit multiplication helper,
carry arithmetic and the remainder bound. The exact presentation/sample choices
are ours; the spec requires tested results and consistency, not those bytes.
Positive iteration counts call the supplied callback three times: divisor,
high sample reduced modulo the divisor, then low sample. A nonzero divisor and
nonnull callback are required. Zero/negative counts run the deterministic checks
without calling the callback; no count clamp or internal random substitute exists.

Scalar `fnv1a_hash(u64, h)` XORs the whole value once and multiplies once with
wrapping arithmetic. Byte hashing calls that step per byte, in address order.
It is deliberately different from hashing an eight-byte representation.

Original regression scope:

- basic-wide-conversions: all unsigned accepted widths, signed boundaries,
  unsigned-to-signed extension and signed division after the private refactor.
- Thirteen wide-to-* rejection sources: booleans, floats, enums, distinct types,
  both wide records and signed-to-unsigned conversion must reject specialization.
- hash-scalar-fnv: independently computed vectors, seeds, named arguments,
  wrapping and scalar-versus-byte distinction.
- basic-division-exercise: callback count/order, zero and negative iterations.
  The Python driver checks every printed result with independent arbitrary-
  precision divmod. It executes interpreter x64 and real native x64 O0/O2
  artifacts; macOS arm64 executes those artifacts through the OS x64 support.
  An executable --x64-target can be supplied on other supported hosts. Failure
  to execute the target is a failure, not an omitted test or fake native pass.

Run the durable source-built suite with the selected NEW library composition:

```sh
python3 tools/check_foundations.py --jaic target/peer-compiler/debug/jaic --stdlib target/foundation-integration/stdlib --jaifmt target/jaifmt --wasm --cross
```

Full lint still needs general target-context/negative-source workflow support;
no bootstrap parameters, private import rules or lint exclusions are changed.
WASI unused File ABI remains a producer dependency, unrelated to these numeric
APIs. WASI executes the portable wide/FNV tests; the diagnostic is correctly x64
conditional and is checked/executed in its supported target context.
