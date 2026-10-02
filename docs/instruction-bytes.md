# Checked instruction bytes and breakpoints

## What it is

`#bytes .[...];` retains literal instruction bytes as `StatementKind::InstructionBytes`. The closed execution profile recognizes the supplied ARM64 BRK1 encoding and checks its target before native emission.

## How it works

The parser accepts comma-separated `u8` integer literals in decimal, hexadecimal, or binary notation, with optional underscores and a trailing comma. Empty payloads and arbitrary byte sequences remain available for source branch selection. Selected statements require a separate semantic decoder and target check; syntax acceptance alone supplies neither execution authority nor architecture compatibility.

The pinned Runtime Support ARM breakpoint example is:

```jai
#bytes .[0x20, 0x00, 0b001_0_0000, 0b1101_0100];
```

It decodes to `[0x20, 0x00, 0x20, 0xd4]`. The parser rejects out-of-range or non-integer elements, missing separators, incomplete brackets, and missing semicolons even inside inactive branches.

Semantic checking recognizes exactly that four-byte payload as `SimdInstruction::Arm64DebugTrap`. Every other selected payload receives a located unsupported-instruction diagnostic. Native lowering checks for an ARM64 target and uses Inkwell's typed inline-assembly API with the compiler-owned instruction `brk #1`, side effects, and a memory clobber. Using a fixed instruction preserves the supplied immediate value, which a generic target breakpoint intrinsic does not promise. LLVM object tests at O0/O2 verify the actual little-endian instruction bytes and the continuing return after the breakpoint. See the [LLVM inline-assembly contract](https://llvm.org/docs/LangRef.html#inline-assembler-expressions).

Exact `#asm { int3; }` instead normalizes to the x86-64 `DebugTrap` operation and LLVM's `llvm.debugtrap` intrinsic. It keeps the continuing control-flow edge and requires x86-64, including when SIMD features are disabled. Both breakpoint forms consume VM fuel and return `RuntimeTrap`; the VM never executes a host breakpoint. A literal `int 0x41` retains its checked interrupt number but selected use requires an unsupported platform interrupt capability. [The source inventory](../artifacts/machine-trap-source-inventory.json) records the exact supplied Runtime Support locations and hashes.

Unsupported assembly statements retain their balanced source span so inactive platform branches can be parsed. Selected unsupported instructions fail during semantic checking. Arbitrary retained text or byte payloads never flow into LLVM inline assembly.

## How to change it

Change `crates/jai-syntax/src/instruction_bytes.rs` for literal grammar and payload bounds. Add source-backed tests in `crates/jai-syntax/tests/instruction-bytes.rs`, retaining the full directive-through-semicolon span. `jai-sema/src/simd.rs` owns exact encoding recognition, `jai-ir/src/simd.rs` owns the canonical operation, and VM/native SIMD dispatch owns execution. Extend all exhaustive instruction visitors together and prove both actual object encoding and wrong-target rejection before accepting another instruction.

`crates/jai-codegen/tests/assembly_traps_source.rs` checks portable VM trap results, O0/O2 instruction encodings in emitted ELF `.text`, wrong-ISA rejection, inactive source selection, and located unsupported payload diagnostics. Its process test links a newly generated object for the actual host architecture with the shared installed-Clang helper, then requires SIGTRAP within five seconds. Cross-target objects are inspected without execution.

`assembly_traps_ir.rs` independently publishes checked IR and passes it through the production native generator. It verifies explicit VM traps, correct target acceptance, wrong-target rejection, continuing return instructions, and real object emission. The x86 case disables SSE2 to prove a breakpoint does not require SIMD vector features.

Whole-file normal-mode parser tests in `crates/jai-syntax/tests/runtime-support-assembly.rs` read original Runtime Support and the pinned Focus override without source filtering. Both files parse completely: 40 original top-level items and 46 pinned Focus items, including PS5 `int 0x41`, x86 `int3`, ARM64 `#bytes`, and retained `SYSCALL_SYSRET` headers. Unknown valid feature identifiers retain a `SimdFeature::Unsupported(Symbol)` and receive located capability diagnostics only when selected. Complete syntax acceptance does not imply semantic or native support for every platform branch.

Original source inventories under ignored `reference/` and `corpus/upstream/` paths are optional local probes. Tests read them at runtime and emit an explicit `SKIP optional original-source probe` message when a file is absent; other read or decoding errors still fail. Self-authored byte-literal, span, range, delimiter, size-limit, and inactive-branch tests run in every checkout. No original source inventory is copied into tracked fixtures.

## Configuration

`MAX_INSTRUCTION_BYTES` caps each parsed payload at 4096 bytes. There are no parser environment variables or flags. The literal array prefix must be `.[`; a plain `[` prefix is rejected. Native target selection supplies architecture; build with installed LLVM 22.1 and `LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm`.

## Dependencies

The implementation uses lexer `Directive::Bytes`, the shared integer literal decoder, `jai-source`, checked `jai-ir`, the VM's explicit trap result, and Inkwell/LLVM. Fixtures inspect pinned Runtime Support source and newly generated object code; they never load or execute original native artifacts.
