# Architectural XGETBV lowering

The former `XOp::Xgetbv` branch discarded its index and assigned zero to both
destinations. It now emits the effectful `X86Xgetbv` IR operation and consumes
the low 32 bits of its index. The operand form is `xgetbv high, low, index`
with 32- or 64-bit integer register operands and an x64 target. Result writes
use the existing 32-bit register-write rule, clearing upper destination bits.
The frontend leaves its modeled flags unchanged.

## Public ISA contract

The [official Intel SDM revision 089](https://cdrdv2-public.intel.com/868137/325462-089-sdm-vol-1-2abcd-3abcd-4.pdf),
Vol. 2D XGETBV (6-35/36), specifies index 0 as XCR0 and index 1 as
XCR0 AND XINUSE when CPUID.D.1:EAX[2] is set. EDX/EAX receive high/low
32-bit halves; upper RCX bits are ignored and upper RDX/RAX bits are cleared.
Flags are unaffected. XSAVE and CR4.OSXSAVE are required; CPUID.1:ECX[27]
reports the latter. Other indices and LOCK are invalid. Unimplemented
result bits are undefined. Vol. 1 13.3 and Vol. 3A 15.5 explain OS enabling.

The complete instruction entry and enabling sections were read from that
downloaded primary manual, including the instruction table. No search snippet,
reference implementation or vendor implementation body was used. The input
PDF SHA256 is `1eb81360c636a723fb34610a1deef276e98e1fc331ac08b380114079664add20`.

## Execution boundaries

The interpreter uses the existing architectural host dispatcher. It checks
real XSAVE/OSXSAVE, the selected index and optional index 1 support before
executing XGETBV. Unsupported hosts/features/indices return a managed
diagnostic. Architectural reads increment interpreter effects, including
discarded results, so compile-time pure-result caching cannot retain them.

LLVM emits a side-effecting real instruction with fixed ECX input and
EDX/EAX outputs, preserving flags. This follows the existing native timestamp
and random-instruction boundary: native callers guard optional instructions
using actual runtime CPUID. The compiler does not invent a successful value
for an unavailable instruction or insert an unrelated module capability.

## Controls and qualifications

Four new source regressions first failed on accepted a2ba7738, then passed:
index/effectful IR, target diagnostics, invalid operands, and non-x64
interpreter execution. The pure prerequisite matrix checks both indices
without executing optional hardware. Exact LOCK rejection is retained.

The independent `tests/compiler-semantics/xgetbv.jai` fixture exposes five
small queries covering 32/64-bit destinations, overlapping input/output,
discarded results and CF/ZF/SF/OF/PF preservation.
`xgetbv-driver.c` checks actual CPUID before any XGETBV, compares XCR0 only
in enumerated defined bits, requires its x87 bit, and checks the complete
pair ABI and upper-bit clearing. XINUSE is dynamic, so index 1 comparisons
check its defined enabled-state subset rather than equality across calls.

Backend metadata controls pass for Mach-O, ELF, Windows MSVC and MinGW at
O0/O2: all five instructions remain, including unused output. ARM and WASM
backend targets reject. These are object-code/diagnostic proofs, not execution
on each operating system.

This worker's Mac ARM host can run translated x64 programs, but actual CPUID
reports XSAVE/OSXSAVE unavailable. Both guarded native controls return 77
UNAVAILABLE before XGETBV. The translated interpreter verifies the managed
diagnostic. Neither is claimed as successful hardware XGETBV execution.

Actual Intel x64 CI remains REQUIRED: run the core and LLVM
`cleanroom_xgetbv` tests at O0/O2. The native test requires an available
index 0 instruction and preserves index 1's optional capability distinction.
Main owns legacy GPR/CPUID fixtures and LLVM output durability; this patch
does not modify those files or clear their independent gates.
