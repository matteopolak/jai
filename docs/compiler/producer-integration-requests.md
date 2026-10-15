# Independent producer integration requests

Only NEW producer sources and tests were used. No quarantined integration,
history, vendor bodies, transcripts or coordinator data were accessed.

## Autorun executable path

The compiler CLI now orchestrates reviewed Compiler hooks directly; no public
`Metaprogram_Plugins.build_with_plugin_groups` export is required. An original
plugin fixture checks initialization/options, interception, messages, completion,
finish/shutdown, failure handling and actual native child execution. Existing
plugin order/repeated-parameter tests also pass.

The portable pending `autorun-cli.jai` now builds an executable and invokes the
plugin. Its helper reports `Autorun process failed: type 2, exit -1, signal 0`.
NEW `internal/build/autorun.jai` constructs the path with
`sprint("%%", options.output_path, options.output_executable_name)`. For output
`/absolute/directory/program`, the directory/name fields concatenate to
`/absolute/directoryprogram`. With an empty directory it passes `program` to
Process, whose normal executable search need not include the current directory.
The executable exists and runs directly. This remains a producer path defect;
it is not successful Autorun execution evidence.

Required general producer repair: join directory/name using path semantics and
resolve an explicit executable path when the name is not a PATH search request.
Retain exact reviewed public signatures and arguments. Do not require a new
Compiler export, introduce module-name checks, or change directory option
semantics to compensate for concatenation. Autorun producer source was not modified; the separate MPEG runtime-artifact
incident is recorded in the compiler deviations report.
Coordinator should rerun real +Autorun execution after that repair.

## Independent integration-clean source review

Ported general struct alignment and hidden-procedure reflection marker fixes
after an original reflection regression failed. Ported fault-safe probe transfers
after a new child-process regression reproduced SIGBUS with a stale mapping cache
following a native-thread protection change. No GL/name-specific exception was
ported. Private FnCtx context initialization already covers the reviewed scratch,
lambda and thunk sites; original context regressions remain passing.

Mach copy ABI was checked against the installed official macOS SDK mach_vm.h.
Actual guarded-copy runtime verification is macOS; Linux/Windows runtime gates
remain coordinator work. wasm32 bounds-copy code passes target checking.

## Runtime storage configuration

Implicit Runtime_Support loading now supplies exactly the three reviewed boolean
parameters. The legacy system-module exemption for unknown arguments is removed.
The old extra TEMPORARY_STORAGE_SIZE argument must not become a public export.
Default target allocation works. NO_OUTPUT workspaces retain the requested size
as metadata and the unchanged 65536 option fixture passes in both runner modes.
The private startup/config mechanism is now implemented in the compiler and owned
internal/compiler-api/runtime-config helper. A checked staging adapter uses it in
NEW runtime initialization and executes real 65536-byte late-root and 0/131072-byte
native child allocations. The producer must adopt those exact private consumer
changes and remove the public size parameter/forwarding. See runtime-configuration.md.
Until adoption, nondefault requests on an older runtime still diagnose; no option
round-trip or staging-only pass is called production integration.

## Register reproducer classification

The NEW pending register-macro.jai asks a __reg parameter to accept a u64 scalar
and execute scalar add. That expectation contradicts the reviewed Meow_Hash
128-bit SIMD operand contract. It remains an invalid-operand diagnostic; no Code
or scalar alias is introduced. Original SIMD lane extraction/mutation and generic
forwarding tests execute on interpreter/native/WASM64, preserving canonical type
identity. Producer source and assertions were not edited.

## Host/target dependency resolved

BUILD_OS/BUILD_CPU now retain compiler-binary host tags under cross selection;
OS/CPU retain output tags. The unchanged NEW foundations predicate and Preamble
fixtures are staged only in this compiler checkout and pass cross checking and
interpreter/native/WASI execution. No producer facade change is needed. Actual
wasm32 compiler host and Linux/X64 child checks pass too. See
[host-target evidence](host-target-constants.md). The portable private runtime
protocol adoption remains pending independently; existing runtime-configuration.md
consumer edits and allocation regressions are unchanged and pass.
