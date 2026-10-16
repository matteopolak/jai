# Void conditional expressions

The independently authored discarded-void ifx reduction was confirmed valid by
root's public behavior oracle (coordinator-language-oracles.json). Runtime branches
ending in void calls previously failed because result lowering unconditionally
loaded/stored their operands. Constant-condition arms already accepted void.

Void branches now join their existing control-flow blocks and return the compiler's
void operand, with no fabricated result or storage. Ordinary conversions still
reject a nonvoid opposite arm; consuming void as an integer/arithmetic operand
retains diagnostics. Block-value lowering preserves void while emitting registered
defers after the arm's effects. Nested conditionals retain their selected effects.

An adjacent independent regression exposed constant-false omitted-else lowering
executing the then arm while discovering its type. That arm is now checked in its
untaken control-flow block; the result follows ordinary default/void lowering.
No application rewriting or public array_add return change is involved.

Four core regressions cover selected effects, nested/deferred effects, omitted
else for void and numeric arms, and four invalid value/arm combinations. Original
runtime counters also execute in the interpreter, native ARM64 O0/O2 and real WASI.
The existing ten deferred-call tests and three printer/backend groups pass,
including exact-once continuation and terminal-error checks. The scoped library
suite passes222tests; all-target warnings-denied clippy passes. Those native
results do not imply Windows/x64 execution or whole-corpus acceptance.

The six hash-staged curated yield examples are separately replayed compile-only:
constant passes; defer/first/if/if_case/while advance to a source-printer unsupported
syntax diagnostic and remain failures. Their statuses are retained in own artifacts;
source checking may execute
ordinary metaprograms, but it does not count as executing their generated programs.
The scanner signal investigation remains open and suspended; this fix does not
claim its cause or resolution.
