# Windows ABI unwind tables under optimization

The LLVM backend now requests asynchronous unwind tables for every Windows
function definition before optimization and again for definitions introduced by
optimization/instrumentation. A module synthesis default carries the same
requirement. This applies to Microsoft x64 and Windows ARM64, including MinGW
triples, independently of debug information, runtime modules, frame-pointer
settings and optimization level.

Root cause: without `uwtable`, LLVM can omit tables after inferring `nounwind`.
Our original pure non-inlined call chain reproduced an empty O2 unwind table,
while O0 had entries. O2 disassembly retained calls, RSI saves and stack allocation.
Language exception propagation and ABI stack descriptions are distinct: inferred
`nounwind` is preserved, as are calling conventions, inline/tail-call choices and
frame-pointer controls. No instruction, artificial frame or runtime exception
handler was added. A true leaf may still legitimately have no unwind entry.

Official contracts:

- [Microsoft x64 exception handling](https://learn.microsoft.com/en-us/cpp/build/exception-handling-x64?view=msvc-170): functions that allocate stack space or call other functions require table entries.
- [Microsoft ARM64 exception handling](https://learn.microsoft.com/en-us/cpp/build/arm64-exception-handling?view=msvc-170): stack-manipulating functions need unwind descriptions; true leaves can omit them.
- [LLVM function attributes](https://llvm.org/docs/LangRef.html#function-attributes): `uwtable(async)` requires instruction-precise tables even when exceptions cannot propagate.
- [LLVM synthesized-function flags](https://llvm.org/docs/LangRef.html#synthesized-functions-module-flags-metadata): the `uwtable` module flag uses Max merging and value 2 for async.

Implementation: `crates/jaic-llvm/src/lib.rs::apply_abi_unwind_attributes`.
LLVMs public C API and the installed Inkwell binding do not expose Max flag
behavior, so the code constructs the documented `llvm.module.flags` metadata
record using safe metadata APIs (behavior 7, value 2), with errors propagated.
This is the real LLVM representation, not a substitute table or unsafe enum cast.
The two linear definition sweeps also cover backend helpers and synthesized code;
no measured performance claim is made. Non-Windows codegen is unchanged.

## Original regression and executed evidence

`tests/compiler-semantics/windows-unwind.jai` contains pure no-inline exported
calls with observable arithmetic after each call. It also contains callback frames
for actual native stack walking. `crates/jaic-llvm/tests/cleanroom_windows_unwind.rs`
checks O0/O2 x64 MSVC, x64 MinGW and ARM64 MSVC objects with llvm-readobj and saves
disassembly/optimized IR. It links all six COFF objects into PEs and matches each
required function entry to its exported RVA plus image base; a merely nonempty
runtime table does not pass. Frame pointers are explicitly disabled in this test.
Optimized IR must retain `nounwind`, the async table attribute and module default.

The original red result is `target/windows-unwind-before.log`: x64 MSVC O2 missing
unwind_leaf, with `UnwindInformation []`. Fixed runs pass both new test cases:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic-llvm --test cleanroom_windows_unwind
```

Artifacts and exact llvm-readobj output are under
`target/windows-unwind/<triple>-O0` and `-O2` (`object-unwind.txt`, `pe-unwind.txt`,
`optimized.ll`, `disassembly.txt`, frames.obj/exe). The SDK driver cross-links at
O0/O2 with MinGW and `-Wall -Wextra -Werror`. It checks arithmetic/ABI forwarding,
real RtlLookupFunctionEntry lookup and captured stack PCs identifying both actual
Jai callback frames in order. On native Windows the same Rust test executes it;
on this macOS host only construction/linking was executed. Native Windows x64
and ARM64 runtime backtrace quality are still coordinator gates, not proven by
cross-linking. The direct invocation is backtrace.exe under the sdk artifact
folders; required output is `real Windows frames and unwind tables: ok`.

Core/backend library and original focused language/atomic/context/reflection/
module/variadic/interface/namespace/runtime/Windows-thread suites pass (log
`windows-unwind-regressions.log`). Separate CLI plugin/older-runtime and adopted
runtime-allocation tests pass. Owned Rust passes rustfmt/item spacing and backend/
CLI all-target clippy with warnings denied. The owned Jai fixture passes source-built
jaifmt check and strict verbose jailint. No new public library code was changed.

## Safe producer coordination

Read only NEW platform-io handoff/follow-up/status docs, its independently authored
windows-symbol-fault.jai and windows-x64-stackwalk-sdk.c. Both fixtures were copied
into this checkout before tool execution. The original producer snapshot does
not yet contain a separate minimal O2 metadata report; our independent pure-call
regression supplies exact object evidence. No peer source/artifact was written.

The unchanged producer named-fault fixture cross-links at O0/O2 through the
source-built CLI with the documented runtime candidate and backtrace startup off.
Both O0 named functions have entries; O2 middle has an entry at 0x1400014a0. O2
fault_leaf at 0x140001490 is a true leaf (store, constant result, return; no stack
allocation/save/call) and legitimately has no entry. Its unconditional assertion
that both RtlLookupFunctionEntry results are nonnull therefore needs producer
review. Do not manufacture a frame or treat every named/exported function as a
nonleaf. The producer source and its assertion were left unchanged; its native
fault/trace test is not claimed passing. Preserve real named fault/trace coverage
while making any future metadata expectation conditional on actual ABI obligations.

Exact outputs are in our `target/producer-fixtures/windows-unwind/named-O*-unwind.txt`
and named-O*-disassembly.txt; summary `target/windows-unwind-producer-evidence-final.log`.
The first evidence parser incorrectly matched only unnamed StartAddress records;
that harness parse was corrected without changing compiler output or assertions.
The next strict check exposed the legitimate O2 true-leaf case; that failure is
retained and classified, not hidden. The independent SDK StackWalk64 probe also
cross-builds with warnings denied; it has not been run on Windows here.

No /Users/matthew/projects/jai-reference/quarantined/vendor source, transcripts, credentials or supplied
reference binaries were accessed. Existing browser/AST/debugger/backend limits
remain documented. Portable adoption of private runtime configuration remains
pending; see [runtime configuration](runtime-configuration.md).
