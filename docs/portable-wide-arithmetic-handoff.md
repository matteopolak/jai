# Reviewed wide arithmetic ownership handoff

The refreshed Basic contract requires S128 addition/subtraction and U128
subtraction. Apollo_Time is an isa S128 and uses those public overloads. Basic
integer operations remain assigned to foundations; this worker has not added
duplicate Apollo-specific exports or edited that producer checkout.

Independent public regression: tests/portable-stdlib/pending/basic-wide-arithmetic.jai
checks low-word carry/borrow, negative signed result, unsigned subtraction and
time differences/addition passed to public conversion/comparison functions. The
actual NEW foundation composition fails 'operator Add is not defined for S128'
(target/basic-wide-arithmetic.log). It does not use inherited stdlib tests or
unreviewed named Add/Sub conveniences. Please implement/export the three reviewed
operators in the foundational owner and run this regression unchanged.

The general compiler dispatch control
tests/portable-stdlib/pending/isa-operator-base-arguments.jai defines its own small
base record/operator and a derived isa record. It verifies that the actual base
operator executes exactly once and returns the correct value. Interpreter/native
Mac O0/O2 and strict lint pass with the current source-built compiler. Therefore
the observed current S128 failure should first be repaired as missing foundational
overloads; this control does not establish every possible overload/isa edge.

Test correction: an initial exploratory assertion expected the operator expression
to have the base record's type. It failed, but the reviewed language contract does
not establish that result-type expectation; the compiler preserves the derived
type. That unsupported oracle was removed before treating anything as a compiler
defect. The useful call-count/value assertions remain. No production change or
disabled valid regression was used to make this control pass.
