# Architectural x64 instruction semantics

Implements compiler mechanisms for the reviewed
[Machine_X64 contract](../specs/stdlib/modules/machine-x64.md). Public macros remain
portable-worker owned. No module-name recognition, new public intrinsic names,
peer edits, or external assembler fallback is introduced.

## Compiler/runtime interface

Existing `#asm` syntax accepts `rdtsc high, low` and
`rdtscp high, low[, auxiliary]`. Outputs require integer registers with 32/64-bit
storage. Each architectural 32-bit result zero-extends into 64-bit storage.
Omitting auxiliary discards the actual result, never substitutes zero. Flags
are preserved.

`rdrand` and `rdseed` require one 16/32/64-bit integer register. Explicit `.w`,
`.d`, `.q` widths must fit its storage. A 16-bit write preserves upper bits;
a 32-bit write zeroes upper bits. Each operation makes exactly one hardware
attempt, supplying actual CF to subsequent `setc`/branches and clearing
ZF/SF/OF/PF. No retry, manufactured sample or forced success is added.

`mfence`, `lfence`, `sfence`, `pause` take no operands. Each emits its actual
instruction; fences retain compiler memory clobbers, all preserve flags. PAUSE
does not promise a delay or memory barrier. `prefetcht0/1/2` and `prefetchnta`
require a memory operand and emit actual hints using its computed address;
they do not read data or promise a cache-line fetch. All require x64 targets
during checking and again during backend lowering.

Private IR distinguishes timestamp/AUX, random kind/width, fence kind, PAUSE
and prefetch kind. LLVM uses fixed instructions and typed outputs: EAX/EDX/ECX
timestamp constraints, separate random result/CF outputs with flags clobber,
side effects, and timestamp/fence memory clobbers. LLVM owns ABI preservation
and allocation under optimization. Existing named `rdtsc` and
`get_cpu_cycle_count` intrinsics require no arguments and one 64-bit integer
result. No new public facade is supplied here.

The x64 interpreter executes fixed Rust instructions on its executing CPU.
Real CPUID guards TSC/RDTSCP/RDRAND/RDSEED; missing features diagnose specifically.
Fences/PAUSE/four prefetch hints are baseline x64. ARM interpreter hosts reject
x86 execution. An own x64 compiler under actual OS translation uses the translated
environment's CPUID and instructions. Architectural operations increment effects
to prevent pure compile-time result reuse; PAUSE also cooperatively polls.
Generic cycle counts now use real RDTSC or ARM64 CNTVCT_EL0, matching native
lowering. WASM diagnoses unavailable counters instead of substituting wall-clock
nanoseconds or incrementing call counts.

## Independent verification

Original fixtures: `tests/compiler-semantics/x86-machine.jai` and
`x86-machine-driver.c`. Core/LLVM harnesses: `cleanroom_x86_machine.rs`.
Oracles are actual independently written C/Rust ISA queries with real CPUID
before optional execution. Core covers invalid registers/widths/signatures/targets,
ARM-host rejection and unsupported-cache diagnostics. The x64 interpreter test
brackets timestamps with real SDK intrinsics, checks AUX with bounded migration
retries, and tests flags/partial writes/failure zeroes when hardware is available.
Missing features must diagnose. C tests repeated attempts without inventing a
success-rate, entropy or nonzero-value guarantee.

LLVM tests inspect actual instruction lines for eight O0/O2 objects across
macOS/Linux/MSVC/GNU Windows x64, including all six RNG width/kind combinations.
Timestamp/fence IR must retain side effects and memory clobbers. ARM64/Windows
ARM64/WASM reject x86 lowering. Native C O0/O2 execution runs on native x64 or
macOS x64 translation. Missing tools fail tests rather than silently skip.

```
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --all-targets --no-fail-fast
CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic --target x86_64-apple-darwin --test cleanroom_x86_machine
```

Original red logs: `target/x86-machine-red.log`,
`target/x86-counter-signature-red.log`, `target/x86-prefetch-red.log`.
Final validation results are in progress/handoff documents.

Final evidence: full available core/backend suite `target/x86-machine-full-suite-final.log`
has 317 passing tests, zero failures, one inherited corpus sweep ignored. Six x64
interpreter cases pass in `target/x86-machine-interpreter-x64-final.log`; eight
ABI objects and actual translated native O0/O2 C execution pass in
`target/x86-machine-native-final.log`. Scoped rustfmt/item-spacing, host core/LLVM
all-target clippy and core x64 Mac/Windows x64/Windows ARM64/wasm32 clippy pass.
Browser wasm32 clippy also passes. Own rebuilt jaic/jailint build, fixture
`jaifmt --check`, and target-aware `jailint -target x86_64-apple-darwin -v -D warnings`
pass; no lint exclusions were added.

`JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib` selects the owned
independent bootstrap for browser builds. Actual
`node tools/check_machine_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm`
passes target capability errors, x64 child-workspace host rejection and subsequent
successful compilation. The initial build omitted this environment and lacked
the prelude; `target/x86-machine-wasm-runtime.log` retains that setup failure,
and `target/x86-machine-wasm-runtime-configured.log` records the corrected pass.
This is independent staged-bootstrap evidence, not full production integration.

## Limits and remaining dependencies

This ARM64 Mac's actual translated x64 CPUID advertises TSC/RDTSCP, neither
RDRAND nor RDSEED. Native O0/O2 timestamps/AUX/fences/PAUSE/prefetch and real
interpreter execution are verified; RNG execution remains a capable-machine CI
gate. All RNG opcodes and unavailable-feature diagnostics are tested. Native
Windows/Linux execution is pending, distinct from their ABI object checks.

Raw compiled instructions require caller hardware/OS checks and can fault on
unsupported hardware. CPUID cannot prove OS/hypervisor timestamp permission.
Counters are not wall time, synchronized CPU time or extra serialization beyond
the ISA instruction. Interpreter CPUID probing adds overhead/serialization;
exact native timing/throughput is not promised. No artificial feature enabling.

`prefetchw`, `prefetchwt1`, `clflush`, `clflushopt`, `clwb`, `cldemote` now diagnose
unimplemented support instead of succeeding as no-ops. They are outside the four
reviewed prefetch hints. Existing unrelated synthetic `rdpid`, `xgetbv`, MXCSR
behavior remains a concrete ISA gap requiring real architectural operations and
feature/privilege checks; it is not counted complete.

Portable can now implement its eight missing reviewed public macros (`prefetch`,
`rdtsc`, `rdtscp`, `rdseed`, `rdrand`, `mfence`, `lfence`, `sfence`). Public bodies
and integrated contract execution remain that owner's work. Existing CPU-query,
options and PAUSE APIs are that owner's implementations. Private runtime protocol
adoption remains separately pending.

The continuing-handlers generic-pointer issue has no exact original reproducer
in the authorized Machine gap document/current mailbox. Compiler questions request
that reduction; no guessed binding change or broader peer search is performed.
