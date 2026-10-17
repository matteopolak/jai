# Exact remaining generated-consumer contracts

The resolved VARIADIC-only and mixed17/ULLmax generation controls do not resolve
these unchanged native-consumer assertions. All remain required; this lane has
not changed any native consumer, fabricated CType/layout metadata, or relaxed
the compiler. Actual current-source interpreter/native O0/O2 results are recorded
by tools/check_generator_contract_fixtures.py under the own T7
generator-platform/resolved-contract-fixtures-03 captures.

1. Custom record alias: bindings-custom-roundtrip requires G.Sample to alias
   G.Sample_Record after a visitor renames struct Sample's output name.
   Generated output has Sample_Record but no Sample alias. Reviewed module
   omit_unnecessary_typedefs_and_macros describes omitting typedefs whose source
   name matches the underlying named record's source/current name. Does that
   promise retention after output-only record renaming, or does this consumer
   require an independently represented public alias configuration? Model/run
   owns omission policy; no source-name/output-name special case is invented.

2. Macro scalar types: the unchanged macro-custom consumer requires maximum ULL
   to be u64 and 18.5f to be float32. Current generated text is the untyped
   constants 0xffffffffffffffff and 18.5. The first required failure is the
   unsigned value/type composite assertion. A separate source-only reducer using
   the captured compiler confirms the exact unsigned value with type s64, and
   the exact float value with type float32. The consumer's later float assertion
   was not reached at runtime; its source behavior is established separately. Official nullable CType and
   mixed-enum exact-value verdicts do not establish macro constant type fidelity.
   Is a cast/typed literal part of the reviewed generator conversion contract,
   or are these compiler literal inference / invalid consumer type assumptions?
   Request exact official public emission/type observations for the ULL scalar
   input; no float32 production failure is established. Do not fill native macro CType or change the compiler merely to fit
   an unreviewed type assertion.

3. Native macro enums: the unchanged consumer requires Options size4 and
   WideOptions size8, short/original member aliases and real C int/u64 native
   argument roundtrips. Current macro enum output has no explicit base type;
   the first required #assert Options size4 fails before native calls. The
   separate source-only reducer confirms both generated enum widths are8. A freshly
   grouped enum is explicitly documented not to infer underlying width; public
   visitors may set a suitable represented enum type. What caller setup must
   explicitly pair each replacement with its actual native argument CType and
   short-name aliases? Current wide output exposes ORIGINAL_UNSIGNED, not
   UNSIGNED. Single-member prefix naming and enum base configuration must be
   independently reviewed before adjusting the producer; do not infer a broad
   mixed-sign ABI policy or erase the existing native consumer requirements.

No gate skip, expected-result downgrade, constant truncation or metadata alias
copy is proposed. Existing generated consumer bodies and real C providers remain
byte-preserved. The standalone exact mixed-value consumer passes in the initial
capture, but provides no native enum ABI proof. Root/reviewer should route the
exact alias/model, scalar emission/compiler inference, and caller enum ABI/name
questions to their respective owners.
