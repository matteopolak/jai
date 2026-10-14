# Register operands through expanded calls

Canonical bootstrap `__reg` keeps its reviewed distinct source type and reflected
name. It is classified separately as a compiler-managed SIMD operand; it is no
longer represented by Code. Core-only compilations without a selected bootstrap
use an intrinsic nominal marker; ordinary library builds select the prelude type.

Assembly vector locals carry that marker. An explicit or inferred expanded
parameter binds to the caller's register storage and class, preserving mutation
and forwarding through nested generic macros. Scalar lane results keep their
declared integer types. Ordinary aliases preserve the canonical type identity.
No module or source-name exception is involved.

Scalar/memory/GPR arguments to a SIMD operand parameter, scalar loads of registers,
standalone storage and runtime procedure ABI uses produce diagnostics. The reviewed
Meow_Hash contract needs 128-bit operands and indexed 32/64-bit extraction. The
existing portable assembly lowering implements these operations in ordinary IR;
original tests execute on native and WASM64 at O0/O2 as well as the interpreter.
This is not physical register pinning or a claim of every ISA instruction.

Shared original source is in `tests/compiler-semantics/register-operands.jai`.
Rust core tests additionally check canonical bootstrap identity and invalid uses.
