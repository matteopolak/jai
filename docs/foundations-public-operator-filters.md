# Public operator-filter facade migration

Six facades now use reviewed public operator spellings in their existing
using,only lists. The complete production change is twelve string-literal
substitutions; imports, module parameters, visibility, types, overloads and
storage identities are otherwise byte-for-byte preserved.

| Facade | Public filter strings |
| --- | --- |
| Basic | +, - |
| Math | +, -, *, / |
| RadixSort | [] |
| Bit_Array | [], []= |
| Soa | [], []= |
| Xar | *[] |

No new overload or compatibility fallback is introduced. Basic's allocation,
configuration and Apollo femtosecond behavior are unchanged, as are the
integrated fourteen Math operators. Each facade still imports exactly the same
internal module/instance and only its original operator set. Its nonoperator
aliases and file-private implementation import retain their original bytes.

The filtered official0.2.030 observations prove that symbolic "-" selects
subtraction and internal "operator-" does not. The reviewed public inventory
supports the other source spellings used here; they are not described as
separately official-executed filter results. Additional unary/bitwise/cast
filter grammar remains with the reviewer/compiler owner and is outside this
six-consumer migration.

## Compiler pairing and verification

The coordinated compiler dependency is numerics' isolated b21c8c05 general
using.rs/scope.rs public filter repair. It rejects internal-name filter aliases.
With that compiler, retaining the old facade strings would hide their operators.
Conversely, the old shared compiler cannot expose the correctly migrated
facades. Both halves must be adopted together. No conditional old strings or
name-specific compiler bypass is permitted.

Own T7 public-filter-facades-rgq9w5ef preserves the six pre-edit sanitized
facades, before/after SHA ledger and an exact byte-comparison proof that each
new file is solely its requested string replacements. The unchanged real
repository source-built jaifmt verifies all six production files and formats/
checks only the eight original new test fixtures.

tests/portable-stdlib/public-filter-facades covers all six facade workflows:
Apollo/S128/U128 arithmetic and overload identity; Math vector/matrix/scalar
arithmetic and overload identity; real RadixSort ranks; Bit_Array read/write
across a word boundary and procedure identity; Soa indexed value/component
storage; Xar pointer indexing, pointer/storage stability and mutation.
Repeated imports check canonical type identity where applicable. A symbolic
minus positive and internal-name negative preserve the reviewed distinction.

The first Xar fixture tried referring to operator *[] as a procedure value.
That hit an existing parser limitation on the old compiler, so it was replaced
with actual indexed addressing and pointer identity, leaving that first receipt
unchanged. This batch does not claim to fix or validate explicit pointer-index
operator-value syntax.

The current old-compiler receipt is
foundations/public-filter-proof-d02i7ps6/results.json. Required facade positives
remain RED and scoped lint is also RED because the old compiler cannot resolve
their newly public-filtered operators. Overall complete=false/exit1 is retained;
no test assertion is skipped or counted as functionality. These are dependency
receipts, not completion evidence. Production source hashes match throughout.

For paired verification, the new original runner accepts --compiler, --lint,
and --stdlib paths and records tool/source/fixture hashes and exact commands.
It performs compile/interpreter checks and warnings-denied six-facade/positive
fixture lint. --native enables actual O0/O2 only after the integrator releases
the serialized native gate. Unexecuted native cases are not counted as passing.
The compiler owner was sent exact stable six-file hashes and fixture paths for
its own isolated paired compiler/stdsnapshot; paired evidence is pending.

[Exact stable source/test/doc manifest](status/foundations-public-operator-filters.json)
separates source readiness from pending paired behavior validation. Only the
integrator performs Git/index actions. This follow-up does not start a broad400
replay or hold unrelated ready checkpoints. No compiler, other production,
Extensions, application, reference or peer checkout was modified.
