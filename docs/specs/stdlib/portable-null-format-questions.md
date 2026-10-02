# Null formatting: corrected official controls

Root supplied sanitized official Jai 0.2.030 public-input verdicts, with no
implementation body access. The worker never executed reference binaries.

Resolved Any contracts:

- Only both-null Any prints `Any.{}`.
- Named `Any.{type=null, value_pointer=*k}` faults before output.
- Named `Any.{type=type_info(s64), value_pointer=null}` faults when printed.
  Positional identity controls independently establish field order; production
  and regressions use named field access rather than guessing that order.
- The null-lvalue print case prints 7 and true, then faults without unreachable.
- Unused or ignored scalar-null boxing and ignored zero-sized null boxing
  continue. Valid Any storage remains borrowed, observing a mutation to 11.

The previous reviewed Basic typed-null diagnostic paragraph is superseded by
these actual public oracle controls. The old passing fallback receipts are
wrong-oracle evidence, not compatibility. Withdraw the proposed eager
`convert.rs::box_any` validation: it violates unused/ignored conversion behavior.
No compiler boxing repair is required for the confirmed formatter failures.

Resolved separate Type contracts: default scalar and record output is
`void\n{void, 0}\n`; independent official void-main scalar/record/array and
explicit identity controls all produce true. Default-Type compiler repair was
integrated separately. Old `(null)` expected output is stale, not a null renderer
contract. Explicit null descriptor formatting remains invalid. The descriptor
probe faults at its first call; the second API was not independently reached.
Preserve existing descriptor validation.

Current validation uses the existing context failure handler for corrupt
metadata or nonzero payload storage even when Basic optional assertions are
disabled. It leaves zero-sized boxing, aliasing and address taking untouched.
Direct malformed FormatInt/FormatArray/FormatStruct wrapper fallback contracts
are separate and unchanged.

Remaining verification: actual Windows CI replay of both original cases after
the compiler default fix, integration-owned default-Type golden correction and
this Basic guard repair. Official ignored zero-sized boxing does not establish
the output of directly formatting every zero-sized malformed storage shape;
no broader claim or new fallback is invented.
