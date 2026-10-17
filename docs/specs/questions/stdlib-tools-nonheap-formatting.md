# Nonheap TOML: numeric variants and tagged-union formatting

The exact original case `toml-jai` runtime step 3 (`union_and_overlay.jai`)
exits 1 with a null-read diagnostic in Basic's string rendering. Runtime step 9
(`formatting_control.jai`) exits -6 with the FormatFloat IEEE-kind assertion.
These are independent of `first.jai`'s unsupported heap capability. All admitted
original sources and data were unchanged. Neither failure is classified as a
capability or a stale expectation without evidence.

Independent producer inputs are under
`tests/compiler/runtime-reducers/toml-nonheap/`:

* `numeric-variants.jai` has separate `base`, `metadata`, `float`, and `int` modes.
  It uses canonical Basic factories and nominal float64/s64 distinct/isa variants.
  Does the public formatter accept an Any containing a numeric variant with the
  same scalar storage as its base? Please supply bounded acceptance/output from
  an independent official native probe and refine Basic's float/integer contract
  if necessary. There is no request for reference implementation bodies or for
  new FormatFloat exports. The direct base cases use exact binary 8.5 and integer
  41, avoiding rounding ambiguity. Variant metadata/storage checks precede the
  formatter calls, so a metadata defect can be separated from kind dispatch.
* `union-metadata.jai` checks direct fields, reflected names/offsets and explicit
  discriminator-to-member bindings independently of printing the aggregate.
* `union-format.jai` prints valid count/text choices, short and forced long form.
  Does Basic print only the active tagged-union arm, a union placeholder, or
  another documented representation? Please provide exact independent public
  outputs and the safety rule for inactive overlapping members. The reviewed
  general FormatStruct description does not specify tagged-union selection.

Root resolved these two valid-input questions with independently compiled
producer reducers, official Jai 0.2.030 native Mac ARM64, in
[the sanitized verdict](../../status/toml-format-official-verdict.json). Numeric
variants print `8.50` and `29`; boxed identity/storage assertions pass without
assertion diagnostics. Valid tagged choices print `{COUNT, 37}` and
`{TEXT, chosen}`, with identical output when forced long form is requested.
The new formatter regression asserts these exact outputs. This is neither an
expected-output refresh for the application nor a new public export.

The independent producer baseline passes metadata/layout/storage controls in
interpreter and native O0/O2. Its scalar wrappers reject the variant kind, and
its aggregate renderer consumes an inactive string arm. The narrow repair is
therefore in formatter dispatch, with no compiler metadata or nominal typing
change. Original failures and baseline receipts remain retained.

Still requiring reviewed clarification: unmatched discriminator values,
unbound implicit ordinal arms, custom union delimiters, and malformed binding
metadata. The admitted oracle only establishes valid explicitly bound enum
choices. No historical behavior for those other cases is inferred. Current
explicit-binding selection also handles stored integer/type tag bits using the
canonical producer metadata; further native acceptance must be stated separately.
