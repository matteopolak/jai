# Debug ownership fixture target contract

Live Mac ARM64 833 case `Debug/tests/ignore-ownership` fails in interpreter/native
modes because the real `developer_debug_output` provider is unavailable. Its
WASM modes fail resolving `Debug.set_report_mode` at line 47. These are separate
categories; native provider setup remains required and integration-owned.

The fixture verifies retained filename/table ownership by calling the real
`interactive_assert` on an ignored location, which still prints the assertion
before returning false. It never requests attachment or an unhandled dialog.
Interactive debugger deferral therefore does not apply. Its original source and
assertions remain unchanged.

Clarification requested: the reviewed Debug page lists `set_report_mode` without
an OS annotation, whereas this producer's lifecycle/assertion implementation is
loaded only on Mac/Linux/Windows. Is the Android/WASM absence reviewed target
behavior or a missing public body? No alias/export or absence assertion will be
invented from a compiler error. Please refine the page's target clauses.

Independently unambiguous portable checks are now in
`stdlib/Debug/tests/target.jai`: canonical enums/shared storage
across graphics parameterizations, absent separate crash-handler thread under
the declared false constant, absent graphics-only functions with
`USE_GRAPHICS=false`, Android/WASM false debugger query, and reviewed non-Windows
empty minidump results. This preserves portable positive and conditional-negative
coverage without invoking native output, debugger attachment, or faults.

Proposed exact fixture metadata restricts only `Debug/tests/ignore-ownership` to
desktop native execution, keeps its native provider mandatory, and reports WASM
unavailable separately from pass. Other Debug fixtures are not blanket-filtered.
