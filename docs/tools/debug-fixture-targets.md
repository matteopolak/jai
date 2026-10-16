# Debug fixture target accounting

`Debug/tests/ignore-ownership` is a desktop native diagnostic/ownership test.
Its real `interactive_assert` call prints the assertion before finding the
ignored location and returning false. Missing `developer_debug_output` or its
native image is therefore a required failure on Mac/Linux/Windows, in both
interpreter and emitted native execution. Interactive debugger deferral does
not cover this output path. The original fixture and all its assertions stay
unchanged.

The exact-case metadata helper `tools/debug_case_capabilities.py` marks only
this fixture unavailable in WASM modes; it does not mark it passed, remove it
from the catalogue, defer native output, or filter other Debug tests. Integration
owns the real source-built `debug-native/developer_tools_debug` provider and
its package/loader closure. The producer C implementations are
`stdlib/internal/developer-tools/debug-native/runtime.c` and
`runtime-windows.c`; no fake symbol or wrapper is substituted by this patch.

The new `Debug/tests/portable-target-contract` stays selected in all four runtime
modes. It tests canonical public enums and shared state across module graphics
parameters, negative conditional exports with `USE_GRAPHICS=false`, the false
separate-thread constant, Android/WASM false debugger queries, and the reviewed
non-Windows empty minidump results. It does not call debugger attachment,
install signal handlers, open a dialog, or deliberately fault.

Reviewed target wording for `set_report_mode` remains an
[explicit question](../specs/questions/debug-fixture-targets.md); no missing
function or absence assertion is invented from its current WASM diagnostic.
This does not block identifying the ownership fixture's actual native diagnostic
requirement. Source checks preserve the original target failure as evidence,
separate from the new portable positive.

Source/lint evidence covers both fixtures on six desktop OS/CPU profiles and
the portable fixture on WASM. The first WASM setup incorrectly passed an
unsupported `-cpu wasm64` flag; those three failed commands are retained, and
the corrected target selection uses `-os wasm` without a CPU override. They
are not counted as successful source checks. Evidence and exact remaining
native-provider/catalogue integration obligations are maintained in
[worker status](../status/stdlib-tools-debug-mode.json). No production Debug,
formatter, allocator, compiler, or native helper implementation is changed.

The frozen accepted-source portable fixture passes Mac ARM64 interpreter/native
O0/O2 and WASM interpreter/emitted O0/O2: six program executions and four builds,
all with exact `ok` output and no diagnostics. Source/tool drift guards are empty.
Six focused Python mode/catalogue/merge/provider-failure policies pass after the
foundations-reserved two-line catalogue hook. These results establish portable
coverage and correct selection only. The unchanged ownership fixture's native
provider/output acceptance remains required from integration; it is not claimed
passed by this handoff. Windows/Linux source checks are not native execution.
