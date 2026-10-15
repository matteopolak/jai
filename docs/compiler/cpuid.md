# Real x64 CPUID execution

Follow-up: the separately recorded synthetic timestamp/random/WASM-counter gaps
are repaired in [architectural x64 instruction semantics](x86-machine-instructions.md).
Original failure evidence remains historical; optional RNG hardware execution
still requires a capable CI machine.

The assembler front end previously replaced all four CPUID outputs with zero.
The original NEW portable reproducer exposed this in interpreter and native code.
CPUID now lowers to an explicit two-input/four-result IR intrinsic. EAX selects
leaf and ECX selects subleaf; both are read before any destination write. All four
32-bit results are written in source operand order, zero-extending into 64-bit
register variables. Four 32/64-bit integer register operands are required.
Non-x64 compilation targets diagnose instead of reporting fabricated features.

The interpreter uses the Rust standard x64 CPUID wrapper on an x64 compiler host.
An ARM64 or wasm32 interpreter diagnoses unsupported execution even when compiling
for x64; cross-compilation does not emulate a target processor. The LLVM backend
emits side-effecting inline CPUID with tied EAX/ECX inputs, four fixed-register
outputs and a memory clobber. LLVM handles callee-save RBX for the selected ABI.
Optimization and calling conventions are preserved. No module/symbol exception,
public API change, hardware-feature constants or synthetic fallback is introduced.

## Executed verification

- Original red evidence: target/cpuid-before.log. The zero-result assertion and
  unsupported-target rejection both failed before implementation.
- Own library-free cleanroom_cpuid tests: 3 pass on the ARM64 host, including
  unsupported-host and operand diagnostics; 4 pass when the Rust test binary is
  source-built for x86_64-apple-darwin and actually executed under macOS translation.
  The latter compares every register against independent Rust queries for leaf 0,
  leaf 7/subleaves 0 and 1, and extended maximum leaf 0x80000000.
- LLVM tests: actual native x64 O0/O2 programs match independent C cpuid.h queries
  for the same leaves/subleaves, including clearing upper 32 bits and preserving
  a live RBX value across the call. Eight O0/O2 objects cover Mach-O, ELF, Windows
  MSVC and Windows GNU; disassembly contains CPUID and Windows unwind information
  records saving RBX. Direct ARM64/WASM backend emission rejects the intrinsic.
- NEW portable fixtures were copied into our own target/cpuid/producer before any
  build/run. Its independent C query reports GenuineIntel/max_leaf 13 in the
  translated x64 environment. The original Jai assertion passes in the own x64
  interpreter and actual native x64 O0/O2 executables. These results describe the
  executing x64 environment, not the physical ARM64 processor.
- Broader selected core/backend regression run: 295 cases pass in
  target/cpuid-regressions.log. This includes existing atomics, contexts, layout,
  interfaces, modules, reflection, runtime data, registers, mixed variadics and
  Windows metadata tests. Windows runtime cases remain platform-gated; no Windows
  thread/backtrace execution is claimed from the macOS run.
- Scoped Rust rustfmt/item-spacing and Jai jaifmt --check pass. Source-built x64
  jailint --verbose -D warnings checks the owned Jai fixture successfully using
  the independent runtime candidate, without ignoring inactive CPUID code.
- Warnings-denied clippy passes for core/backend host all-targets, core x64 macOS,
  Windows x64/ARM64 MSVC all-targets and the wasm32 browser library.

Representative commands (run from this checkout):

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic
CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic --target x86_64-apple-darwin --test cleanroom_cpuid
PATH=/opt/homebrew/opt/llvm/bin:$PATH LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic-llvm --test cleanroom_cpuid
CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jailint --target x86_64-apple-darwin
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" target/x86_64-apple-darwin/debug/jailint --verbose -D warnings tests/compiler-semantics/cpuid.jai
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" target/debug/jaic -target x86_64-apple-darwin -O2 -exe "$PWD/target/cpuid/producer/vendor-O2" target/cpuid/producer/cpuid-vendor.jai
target/cpuid/producer/vendor-O2
```

## Limits and retained failure evidence

Native Windows/Linux CPUID execution is still required on those hosts; cross-object
metadata is not runtime evidence. The C execution driver runs on x64 hosts and
macOS with x64 translation; other ARM64 hosts receive object/diagnostic coverage.
Tests require their native tools and fail rather than counting tool absence as a
success. No measured throughput or CPU migration consistency guarantee is claimed.
Queries retain the host OS/hypervisor supplied values, including unavailable-leaf
behavior; tests avoid per-core topology/timing fields.

Initial clippy commands named uninstalled GNU Windows Rust targets; retained logs
report missing std. Repeating with installed MSVC targets passes. An initial CLI
invocation used -cpu x64 on ARM64 without a target triple and correctly rejected
that cross-output selection. Explicit -target x86_64-apple-darwin builds/runs pass.
Neither failure was weakened or hidden. Original test setup used invalid negative
u64 initializers once; those were corrected before the meaningful red assertions.

Separate baseline gaps are NOT repaired by this CPUID batch: RDRAND/RDSEED still
use a cycle-counter-derived synthetic result and force carry success in
sema/asm.rs; RDTSCP still returns a synthetic zero processor identifier; WASM
CycleCounter still returns zero in LLVM lowering. These are observable unsupported
architectural semantics, not completed Machine_X64 support. Proper hardware/status
intrinsics and explicit unsupported-target/host diagnostics are required before
claiming those operations. General AST/debugger/alternate-backend limits and
portable private-runtime adoption remain separate pending work.
