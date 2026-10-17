# XGETBV remaining native proof

The primary Intel SDM fixes the index 0/index 1, prerequisite, output-pair and
flag contract. General lowering and interpreter checks are implemented; no
language or module-name exception is used.

Actual Intel x64 native/interpreter execution remains required because the
worker's Mac ARM translation reports no XSAVE/OSXSAVE. Local guarded C
programs return 77 UNAVAILABLE before the optional instruction, not pass.
Windows and Linux object emission is metadata proof only.

Index1 requires CPUID.D.1:EAX[2] and observes dynamic XINUSE. Its value is
not required to equal a preceding/following sample; unimplemented output
bits are undefined. Native controls check the defined enabled subset,
output ABI, flags, and feature-gated execution.

The instruction form currently follows the existing implicit GPR forms:
32/64-bit integer register operands. No new immediate/memory-index grammar
contract is inferred or claimed. Legacy GPR __reg and catalogue fixture
updates remain the main compiler owner's separate lane.
