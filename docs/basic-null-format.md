# Basic null-format Windows CI triage

Windows native job `117082710709` built 63 programs and reported 61 matching
results. This batch uses the reviewed Basic contract and root-supplied sanitized
official Jai 0.2.030 observations. No excluded fixture or reference body was read.

| Case | Established facts | Disposition |
| --- | --- | --- |
| `print-null-type` | Official default Type/record probe compiles and runs with exit zero, output `void\n{void, 0}\n`. Our identity reducer fails without calling a type formatter. | Compiler default-initialization defect; the old `(null)` output expectation is also stale. Do not format null descriptors as void. |
| `null-deref-print-any` | Sanitized input passes a null pointer's lvalue to print after taking its address. This involves compiler boxing rather than manually constructing Any. | Official native execution faults after output 7 and true; unreachable is not printed. Preserve that fault oracle and the separate reviewed manual typed-Any fallback. |

The separate official descriptor probe compiles and then fails native execution
with a null SEGV at its first public formatting call. Both null descriptor APIs
must remain invalid as directed by root; the second call was not independently
reached in that probe. Keep the existing renderer assertion. The manually
constructed typed-Any diagnostic's unusual wording remains exact as reviewed.

Five independently authored public inputs are durable:

- `format-null-any-contract.jai` checks manual typed-Any fallback through builder
  and formatted arguments, continuation, and owned-string cleanup.
- `format-null-type-probe.jai` prints a default Type variable and a Type/int
  record. Its official output is now established as void formatting.
- `format-null-descriptor-probe.jai` separates invalid descriptor APIs from Type
  defaults. It is not a locally executed fault test.
- `format-default-type-identity.jai` compares implicit scalar/record defaults
  against void and explicit controls, printing only booleans. Root now confirms
  official scalar, record and array identity controls all print true.
- `format-null-lvalue-any-probe.jai` reproduces the root-sanitized pointer/lvalue
  shape. Root confirms compile zero and native fault after 7 and true; it
  was not executed locally.

The resolved facts and remaining question are recorded in
[portable-null-format-questions.md](specs/stdlib/portable-null-format-questions.md).
Root supplied outputs/verdicts only. This worker never ran a supplied reference
compiler or reference binary.

The fresh source/build/lint/format receipt
`null-format-source-th83sgwt/summary.json` passes 41 commands with zero full Rust
and shared stdlib source drift across Windows/Linux/Mac x64/ARM64. All six strict
lint contexts are complete. The earlier 29-command source receipt is preserved.
Source checks do not establish Windows runtime output.

Under a bounded claimed slot, actual Mac interpreter/native O0/O2 identity runs
all exit 1 with `false false false false true true\n`: implicit defaults differ
from void; explicit controls match. No null descriptor is formatted or
dereferenced. `identity-formatted/summary.json` pins the current reducer and
source-built compiler `e2c1a756…`; the pre-format RED receipt is retained.
Manual typed-Any tests pass interpreter/native O0/O2 with `ok\n`, and current
fixture bytes match `focused-native/summary.json`. No GUI or deliberate null
fault probe ran. All processes finished and the slot was explicitly released.

Read-only compiler diagnosis: `sema/structs.rs::default_initializer` has no
`TypeKind::Type` branch, so `init_default` emits zeros. The existing
`write_value(Value::Type(...))` supports canonical type-info relocations. Export
the general default-value reducer to the compiler owner for a void-valued Type
default image, rather than adding a Basic null-to-void fallback. Separately,
`convert.rs::box_any` takes a Place's address without loading it. Its required
null-lvalue consumption now has an official fault verdict. Hand off this
function and reducer to the compiler owner for a general value-consumption
repair; do not invent a printer fault or change manually constructed Any.

Root additionally supplied an independently authored, void-main official
identity control: scalar, record and fixed-array implicit defaults plus explicit
controls all print true. This resolves the prior formatting-versus-identity
qualification. Our implicit-default mismatch is a compiler initialization
defect. The original int-main official rejection is retained as a fixture
adaptation receipt, not mistaken for a failed identity control.

No Basic production function, assertion, existing oracle, catalogue or Rust
source changed. The old 61/63 native receipt remains unresolved. After the
compiler default is fixed, the stale null Type expectation needs correction to
the official void output and actual Windows verification. The confirmed boxing/value-consumption defect
remains a separate compiler dependency. Integration alone stages this new-only regression/doc batch
and maintains the global README link. Clipboard and final source markers remain
untouched.
