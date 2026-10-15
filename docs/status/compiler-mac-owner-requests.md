# Remaining Mac compiler catalogue requests

## Portable owner: missing reviewed public protocol comparison

compiler/compiler-reflection-pure still fails on compare_alloc_and_free_traces.
The name/signature is explicitly public in specs/stdlib/modules/protocol-for-memory-visualization.md.
The approved facade and independent internal module have no implementation/export.
The original independent test checks equality and inequality of alloc/free trace
pointers. This is not classified as an obsolete/private helper and is not removed.
Please implement the reviewed behavior or obtain its missing behavioral review;
this compiler worker does not guess a library implementation outside its scope.

## Integrator: native custom-link prerequisite

compiler/custom-link-library-lists now calls the reviewed one-argument completion
API. Normal interpreter/native runner attempts to build its child executable and
fails on missing crash-native/portable_crash. Its -no_workspace_output run passes,
but that does not exercise the native link phase and is not an integration pass.
Please supply the normal native prerequisite through the owned setup/routing;
no backtrace option, guard or library is disabled or fabricated here.

## Spec reviewer: compiler decimal literal inference

Two untouched failing fixtures are float-literal-precision and rules-numbers.
The former assumes digits before the decimal count towards a total-digit cutoff;
the reviewed Jai_Lexer contract instead explicitly counts only fractional digits
(trailing zeroes ignored). The high-level language page says float32 when
representable at that precision, otherwise float64. It does not reconcile these
statements for compiler inference versus the runtime lexer flags.

Please establish compiler default types for 12342345234.0, 16777216.0 (exactly
representable at float32), 9876543210.125 and 0.123456789, and the admissibility of
implicit PI_LONG-to-float32 where PI_LONG has more than eight fractional digits.
No change to numeric inference, narrowing diagnostics or these failing oracles is
made pending that refinement. Local failure reports are retained.

## Optional tour follow-up (outside the 22 compiler fixtures)

The integrated CLI provider scenarios already cover scheduler wake/deadlock
without a public WASM Thread API. The tour still loads native-only Thread and
describes browser Thread_Group/semaphore behavior that the reviewed public module
does not supply on WASM. Do not remove the target guard. A supported tour should
present native-only concurrency separately and adjust its target-specific output
oracle, while retaining the independent real scheduler tests. Integrator owns
overall example routing/prerequisites and portable owns Thread/API migration.
