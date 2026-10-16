# LLVM-free WASM CI target contracts

Reviewed producer: `7d51d0a7`; reported product: `f1a7e3a8`.
Job117082611510's graphical-tour failure remains red. This checkpoint repairs
two independently confirmed later smoke fixture errors without weakening that
obligation.

The current smoke calls `checkSourceExamples`, which runs the whole tour, then
later repeats the whole tour directly. The GPU file imports Input and Window_Type
before probing GPU availability. A runtime no-GPU branch cannot make those static
native-only imports valid. Reviewed Window_Type defines no WASM native handle.
Private browser canvas/input protocols do not establish a public native-window
alias. The [capability design review](wasm-tour-capabilities.md) remains open;
neither the guard nor the tour expectation changes here.

Current Rust browser tests already use supported C bridges for stream I/O and
exit. JS smoke still used public POSIX and Basic.exit, both of which independently
reject on WASM. Original argument/input/EOF/live-JSPI and exit7/output assertions
now execute independent Jai fixtures with libc stdin/fgets and exit declarations.
Diagnostics and successful entry are additionally checked. A bounded runner
shares the same checks; it does not replace the full smoke gate.

Private runtime regressions retain cooperative workers, real joins, contention,
filesystem/source isolation, invalid handles and deadlock checks. Their public
Thread rejection control now also requires precise Process and Window_Type
module static-assert diagnostics. Expected rejection is not positive platform
execution evidence.

Actual verification uses source-built wasm32 compiler code from exact approved
current Rust sources and NEW stdlib, with preserved Extensions omitted without
reading/copying it. Only non-GPU I/O/runtime controls use this library subset.
Node24 with JSPI executes asynchronous input (callbacks deliver6 then0 bytes),
fixed input/arguments, exit7 with retained output, and all private runtime checks.
The existing unused inspect_callable build warning is recorded, not suppressed.
No full-product or graphical success is claimed. The separate formatter check
cannot run with this restricted library subset: its driver imports preserved
Extensions/Jai_Format. The missing-module receipt is retained, with no attempt
to inspect that body or claim formatting passed. WASM LSP formatting also reports
method-not-supported; no LSP change was attempted.

Bounded actual-module replays:

```sh
node --experimental-wasm-jspi tools/check_scripting_io_wasm.mjs /path/to/jai_wasm.wasm
node tools/check_playground_runtime_wasm.mjs /path/to/jai_wasm.wasm
```

The full obligation remains `node tools/check_scripting_wasm.mjs /path/to/jai_wasm.wasm`.

Root must supply the failing Process entry/flags/direct import chain. Direct
Process import correctly rejects WASM; no direct Process dependency was found in
the examined smoke/tour core import roots. That does not classify an unspecified
consumer. A portable consumer may need target-aware dependencies once its actual
chain is known; a native-only consumer should retain rejection.

Root/graphics owner must review a private canvas/WebGPU consumer using approved
independent types/callbacks, or approve separately required portable-positive and
unsupported-graphics-negative obligations. No void handle, fake GPU response,
public API invention, assertion suppression or broad exclusion substitutes for
those capabilities. Integration alone applies the shared patch and owns final
matching-product replay.

[Machine-readable evidence](../status/wasm-ci-triage.json) pins source, module,
library subset, actual successes and unresolved red/dependency states. All
build/capture paths use compiler T7. No native program, GUI/SDK test, full corpus
sweep, remote action, /Users/matthew/projects/jai-reference/quarantine/Extensions body or suspended memory
investigation was used.
