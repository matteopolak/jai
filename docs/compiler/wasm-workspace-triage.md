# Required WASM workspace failures: bounded triage

The coordinator reports the exact60d full-workspace proof as 1054/8/1, with the
tour target rejection and a formatter Node exception retained as failures.
This checkpoint does not repeat that workspace run or claim current60d success.
It uses the owned approved603 compiler plus the accepted pointer fix, with the
exact frozen603 stdlib/native receipt.

## Tour target boundary

The old tour imported public Thread on OS.WASM. The reviewed Thread contract and
its guard exclude this target. An independent import reproduces the guard
rejection. Basic compiles and executes as WASI with OS.WASM and native compiler
BUILD_OS.MACOS; File and File_Utilities imports also compile on this snapshot.
The initial suggestion that File was necessarily unsupported was withdrawn
after these explicit controls.

The tour thread stop now selects a private browser/WASI provider with the normal
language conditional/load mechanism. Other targets load native.jai, byte-identical
to the former independently authored native consumer. No public stdlib API,
target constant, runtime implementation or conditional scheduling function changes.

cooperative.jai consumes existing SandboxHost/Wasi_Runtime foreign hooks. Its
mutex token is storage for those providers, not a native pthread ABI declaration;
its own WASM guard prevents accidental SDK use. Three real prime workers must all
reach a condition-variable barrier. Work is distributed across all three; every
join checks the actual returned worker pointer and completed job count. The bounded
four-slot queue requires actual blocking, consumes all ten squares in order and
joins the producer before destroying synchronization storage. Every foreign status
is checked by unconditional runtime code; failures abort rather than relying on
an optimization-sensitive assertion.

The isolated stop preserves the original expected prime counts and sum 385 in
SandboxHost and emitted WASI at O0/O2. Required tests run with
JAIC_REQUIRE_WASM_TESTS=1; neither existing failing test is ignored or disabled.
The public Thread rejection test and independent scheduler/file/error/deadlock
regressions remain enabled.

## Full tour remains red

After the thread migration, full-tour compilation reaches Window_Type's legitimate
WASM rejection. The GPU stop unconditionally imports Input, Window_Type and
Extensions/WebGPU. The reviewed Window_Type contract provides native handle types
for named native targets and no browser canvas handle.

A graphics/playground owner must design the private canvas/input provider boundary
for this consumer. Inventing a public WASM Window_Type, weakening its guard,
rewriting a target constant or omitting the GPU stop is not this checkpoint's fix.
The full tour remains a required failing test until that dependency is repaired.
The native consumer was preserved as source, not newly executed as native SDK code.

## Formatter result and current-source dependency

The owned source build compiles jaifmt/wasm.jai at O2 and Node v24.12.0 passes all 24
unchanged golden cases, configuration-error/refused-input checks and large-file
formatting/idempotence checks. Own and named NEW shared files were hash-identical
for jaifmt/wasm.jai, jaifmt/main.jai, tools/check_jaifmt_wasm.mjs and
crates/jaic-cli/tests/wasm_target/mod.rs at comparison time.

This does not reproduce or explain the coordinator's exact60d exception. The
readable shared HEAD was 3493a85c, not an immutable60d pin. An exact safe60d
source/stdlib receipt and Node version/exception lines were requested in the
worker inbox. The separate 188-stdlib-difference review remains with its owner.
No production compiler change is justified by the available formatter evidence.

## Artifact integrity observation

A later ordinary file read found zeroed headers in four previously executed own
T7 WASM outputs. Reusing the formatter module then produced:

    CompileError: WebAssembly.compile(): expected magic word 00 61 73 6d,
    found 00 00 00 00 @+0

The earlier successful execution logs and the later failing file receipts are
both retained. This is not established as the root failure's cause. A fresh
Basic module retained its valid magic and SHA across a bounded 12-second check and
a separate subsequent tool call. No alternative access path, memory-boundary
experiment, security tooling or suspended investigation was used. The old affected
outputs were preserved rather than overwritten to claim success.

## Verification and handoff

The new required CLI provider test executes WASI O0/O2. The browser-host test
executes the same private provider through PlayHost. Public Thread rejection and
four existing sandbox regressions pass. Target-aware strict lint, source formatting
and warnings-denied Clippy are recorded with the final checkpoint receipt.

Changes are limited to tour example source, original tests and documentation.
Extensions, core runtime, LSP production, Metal/http/filter sources and owned
conditional/dependency scheduling functions remain untouched. Exact current-source
integration, full-tour canvas repair and current formatter replay are pending;
no broad corpus/workspace or native GUI/fault run was performed.

Captures are under compiler/mac-repairs-audit/wasm-workspace-triage on T7.
