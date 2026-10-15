# Reflection public API audit

All11 reviewed declaration/overload rows have real source. Ten are now individually
classified complete-source after this audit. range_check_and_store remains partial:
the generic narrow-input returned-bound policy needs review, with a genuine
independent failing reduction in specs/stdlib/reflection-questions.md. No truncation
or public type restriction was invented to evade it.

New tests are derived from reviewed specs/stdlib/modules/reflection.md, not legacy
private APIs. `python3 -B tools/check_portable_reflection.py` uses actual NEW
foundation/String parsers and current owned Reflection facade/internal code.
Evidence: target/reflection-contract-audit.log. It passes interpreter/native Mac
O0/O2, Linux/Windows both-CPU source checks and whole owned strict lint.

Coverage includes signed/unsigned1/2/4/8-byte range endpoints and failed writes;
integer limits including unsigned64 maximum/signed64 minimum; mutable string
cursor and value overloads; out-of-range/malformed integer preservation; float32/
float64 values and suffixes; reviewed bool prefix behavior without token boundaries;
quoted strings with literal backslashes and malformed input; enum names, negative/
unsigned numeric metadata and unknown names/numbers; fixed/view/dynamic array
count/data identity; reflected field type/address and absent-field lookup;
unsupported aggregate parsing rejection. No production fix or test correction was
needed for this supported matrix. No exact unknown-enum cursor policy was assumed.

Format/--check passes new tests and unchanged owned production files. New tests
still require coordinator's independent review/integrated run; native other-OS
execution is pending. Ten complete-source rows are not a claim of exhaustive
reflection metadata, arbitrary generic bounds or every malformed parser input.
