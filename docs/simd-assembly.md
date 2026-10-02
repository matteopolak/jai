# Closed SIMD assembly

## What it is

The SIMD lane models the closed x86 `#asm` register operations demonstrated by the recent OpenJai corpus. It uses private checked register identities and LLVM vector instructions; ordinary records named `Vector4` or `Quaternion` retain their declared fields and source operators.

## How it works

[The source inventory](../artifacts/simd-source-inventory.json) records actual paths, revisions, hashes, and declaration locations. OpenJai's Math module declares ordinary float records. Its `28.6_simd.jai` example instead uses 128-bit `movups`/`addps`, 256-bit AVX float operations, and `movdqu`/`paddb` byte addition. The corresponding corpus test asserts all resulting array values.

Syntax retains feature, opcode, width, register, and memory-operand enums. Checking maps each block's register names to arena-branded identities, rejects reads before initialization and conflicting widths, and resolves memory addresses through normal typed expressions. Two-operand addition reads the old destination; three-operand addition requires declared AVX support. Registers hold 128 or 256 bits and may be reinterpreted between `f32` lanes and `u8` lanes without changing their bits.

The checked register builder limits a block to 256 registers and 4,096 instructions. The immutable program verifier must separately validate address expression references. VM execution emulates numeric lane operations over bounded virtual memory; it never invokes a host SIMD instruction. See [virtual execution](simd-vm.md) for provenance, allocation, and instruction-budget checks.

Native helpers use actual LLVM vector loads, stores, `fadd`, wrapping integer `add`, and bitcasts, with one-byte access alignment. Pointer guards reject null and wrapping nonempty ranges. Native vector emission requires an x86-64 target; ARM targets receive a structured diagnostic. Declared AVX/AVX2 requirements must be enabled in the selected target. Explicit feature overrides apply in order; host CPU selection may use LLVM's actual host feature report. Named cross-target CPUs require explicit feature flags because LLVM's C API does not expose their resolved feature tables. These operations follow the [LLVM vector and arithmetic contracts](https://llvm.org/docs/LangRef.html#vector-type) and the [Intel architecture manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html).

The same canonical block also carries closed architecture-specific breakpoint operations. Exact x86 `int3` and ARM64 BRK1 have separate native target proofs and an explicit VM trap result; see [checked instruction bytes and breakpoints](instruction-bytes.md). Unsupported retained assembly is diagnosed after source branch selection, so inactive platform instructions do not prevent parsing.

The common `Statement::Simd` is active through semantic checking, immutable program verification, VM execution, native lowering, and procedure reachability. Address expressions retain the ordinary type, procedure-owner, call-signature, and expression-depth proofs. Abandoned builders, rejected instructions, and finished blocks dispose address trees iteratively, including deeply nested public staging input. SIMD instructions inherit the enclosing source statement's debug location.

Four independently authored source fixtures verify every lane, byte wrapping, address calls exactly once, and overlapping load/store snapshots in the VM. They emit eight actual x86-64 objects at O0/O2 and check typed vector instructions and explicit unaligned access. Native helper tests also inspect real Linux ELF objects and emitted x86 instructions. ARM emission and missing SSE2/AVX/AVX2 reject correctly. Executable fixtures run only on an actual x86-64 host reporting AVX2; object verification on an ARM host does not establish x86 execution.

The inventory also records additional standard-library byte-search instructions, cross-block registers, and foreign vector-register arguments. Those contracts remain outside the closed block subset and require explicit extensions; their presence is not reported as supported merely because parsing a vector record succeeds.

## How to change it

Update the syntax enum/parser and `jai-sema/src/simd.rs` operand checker together. Extend `jai-ir/src/simd.rs` proof before adding an execution case. `jai-vm/src/execute/simd.rs` and `jai-codegen/src/native_simd.rs` must agree on width, interpretation, destructive destination behavior, and byte-level results. Add source fixtures that execute the operation and verify every lane, plus malformed-IR rejection tests. Preserve the block arena when cloning register operations; never manufacture freely interchangeable ordinal IDs.

For a new instruction, document its actual source declaration or use and its ISA requirement. Preserve exhaustive statement visitors, iterative disposal, procedure reachability through address expressions, and source debug locations. Do not infer a primitive type or intrinsic from a Math record's spelling.

## Configuration

Source declares `#asm AVX` or `#asm AVX, AVX2`. `.x` denotes 128 bits and `.y` 256 bits. The native target triple, CPU, and feature string determine whether emission is legal. Generic x86-64 supports the baseline 128-bit subset; enable `+avx`/`+avx2` explicitly for cross-target wide operations.

Build with installed LLVM 22.1 using `LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target`. VM execution requires a little-endian target with eight-byte pointers. The fixed register/instruction bounds live beside the checked builder and must remain consistent with semantic diagnostics.

## Dependencies

The lane uses `jai-source` symbols and spans, `jai-syntax`, the common checked `jai-ir` register model, `jai-types` floating semantics and pointer identities, VM byte images, and Inkwell/LLVM vector builders. Source provenance comes from the repository's immutable corpus manifests. No original compiler, native object, or native library is loaded or executed.
