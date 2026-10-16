# CRC, Base64 and PCG public audit

All 23 reviewed declaration/overload rows have real supported bodies: Crc one,
Base64 eleven and PCG eleven. Canonical facades retain the declared overloads and
defaults; decoder tables remain immutable constants, with mutable caller-owned
copies accepted by the table parameter. No production edit was needed in this
audit.

`tools/check_portable_codecs_shared.py` exercises actual shared-library imports.
The explicit-check fixture verifies all 256 entries of both decoder tables,
LF-only whitespace, first-padding termination, invalid-byte partial output,
one/two/three-symbol tails, custom alphabet/table behavior, URL encoding without
padding, and binary round trips. CRC checks include empty input, the established
123456789 vector and bytes 0 through 255. The latter expected value
`0x59c3325b2927a19a` was calculated independently with Python arbitrary-width
arithmetic from the reviewed polynomial, initial register and final XOR.

PCG tests verify the exact reviewed five output/state pairs, global and state-pointer
sequence equivalence, both bounded variants for small/full-width bounds, and all
float/range convenience overloads. No statistical quality or thread safety claim
is made. A separate compiler negative rejects mutation of the exported decoder
table because it is constant. The existing built-in public Base64 test functions
also execute with assertions enabled; their assertion-based checks are not counted
in disabled-assert execution.

Final receipt `stdlib/shared-target/codecs-shared-ln556uns` records nine passing
interpreter/native Mac O0/O2 executions, six native builds, six source target gates,
six complete strict owned-body lint contexts, fixture lint and formatting. The
explicit-check fixture also runs against the fresh disabled-default source-only
configuration; every functional check is independent of optional assertions.
Linux/Windows source gates do not establish native platform execution.

Test correction: an initial Jai bitwise CRC oracle omitted parentheses around a
cast before shifting, causing test exit7. Parenthesizing the cast made that draft
pass without production changes. The final fixture removes the mirrored algorithm
and uses the independently calculated Python vector. It does not replace the
expected value with a result obtained from the library.
