# Remaining x86 catalogue premises

The admitted CI833 runtime records preserve four required failures: interpreter
and native `compiler/lang-asm` reject the GPR call to `add_regs`; interpreter and
native `compiler/rules-simd-asm` fail `asm.25`. No case is deferred or passing.

## GPR parameters

`lang-asm` passes two declared GPRs to expanded `__reg` parameters. The reviewed
Meow_Hash contract establishes SIMD operand identity, and the compiler questions
explicitly leave wider register-marker contracts unestablished. The existing
independent negative GPR-to-`__reg` assertion must remain until that contract is
reviewed. This is not evidence for a SIMD register forwarding defect.

A new original core control demonstrates the supported alternative mechanism:
two expanded `Code` parameters forward through another expansion, perform an
ordinary GPR addition, and update the caller's register storage. It returns 17
from inputs 10 and 7. All three `cleanroom_registers` tests pass, including SIMD
identity/forwarding and the unchanged misuse diagnostics. This control does not
silently migrate the catalogue fixture or decide the public `__reg` question.

## CPUID and XGETBV

Both catalogue fixtures assert that CPUID reports zero. CPUID already queries
real hardware in interpreter and LLVM lowering; that zero-result expectation
is obsolete. The rules fixture also unconditionally executes XGETBV and expects
zero. Inspection found a separate unimplemented instruction: scalar lowering
currently writes literal zero to both XGETBV outputs. The earlier real timestamp,
random and fence cohort did not implement XGETBV.

Before claiming a corrected rules fixture, establish the reviewed XGETBV
operand/feature contract and implement or honestly diagnose the instruction.
Required questions are index support (XCR0 versus CPUID-enabled index 1),
prerequisite diagnostics and unchanged flags. The existing fake-zero result is
not counted as completed functionality. Execution controls must guard optional
instructions with actual CPUID/OSXSAVE, and valid values must be compared with
an independent host intrinsic or native ISA oracle.

The `a2ba7738` investigation checkpoint changed no production source, fixture
assertion or target eligibility. The follow-up now migrates only the false
zero-CPUID assertions in the two existing catalogue cases. Both sample all
leaf-zero fields twice, require a real vendor and baseline feature leaf, and
preserve the register values without masking topology data. The rules fixture
also checks the x64 baseline SSE2 bit and guards XGETBV with both XSAVE and
OSXSAVE before checking XCR0's required x87 bit. Its other arithmetic/vector
assertions are retained. No eligibility or required gate changed.

Original `cpuid-leaf-zero.jai` exports each of the four CPUID outputs for direct
comparison. New core tests compare the actual x64 interpreter with the Rust
host intrinsic and preserve ARM/WASM target rejection. New LLVM tests retain
the side-effecting CPUID opcode and memory clobber, then execute O0/O2 x64 C
drivers comparing all four fields with the public C intrinsic. These controls
pass on the Mac host through actual OS x64 translation. This is not native
Windows/Linux execution evidence.

The existing `cleanroom_cpuid.rs` files remain byte-exact to the accepted parent;
new controls live in separate `cleanroom_cpuid_leaf_zero.rs` files. A filename
collision in an intermediate unexported commit was corrected before handoff.
Preservation verification passes all four ARM-host core tests, all six translated
x64 core tests and all three LLVM tests (four native O0/O2 driver executions),
including the original ABI/opcode/unwind/target-rejection controls. Both original
test hashes are recorded in the status JSON; the consolidated patch deletes none
of their assertions.

The edited rules fixture and independent CPUID fixture pass warnings-denied
lint with complete x64 contexts, no incomplete/unvisited files. The rules fixture
passes source checking; `lang-asm` still rejects the GPR marker call. Actual
full-catalogue runtime acceptance remains pending the GPR oracle and the separate
XGETBV owner cohort. The newly guarded XGETBV assertion is not claimed passing
against the old zero implementation.

Four independently authored public oracle inputs have been exported with
SHA256s under owned T7 `gpr-cpuid-controls/oracle-request.json`: direct GPR
`__reg`, nested GPR `Code`, scalar `Code` mutation and SIMD `__reg` mutation.
Root owns official 0.2.030 execution and filtered verdict delivery. These inputs
use only ordinary integer/register operations and public assertions. No
reference binary or implementation body was accessed by this worker.

The exact historical CI failures remain open until combined replay. The
unrelated canonical WASM output-channel investigation is
[recorded separately](wasm-output-channel.md).
