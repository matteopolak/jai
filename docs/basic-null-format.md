# Basic Any formatting correction

Root supplied sanitized official Jai 0.2.030 native verdicts from independently
authored public inputs. No reference implementation body or binary was accessed
by this worker.

The previous reviewed paragraph promising a diagnostic for a typed Any with null
payload was wrong. Its earlier passing tests used the wrong oracle; those
receipts remain historical evidence, not compatibility proof.

| Public input | Official result |
| --- | --- |
| Both Any fields null | Prints `Any.{}`, successful continuation |
| Named null type, non-null payload | Native fault before output |
| Named s64 type, null payload | Native fault, no continuation |
| Null-lvalue print after address-only use | Prints 7 and true, then faults |
| Unused or ignored scalar-null boxing | Continues |
| Ignored zero-sized null boxing | Continues |
| Borrowed valid Any after payload mutation | Reads updated value 11 |

`render_item` now recognizes only the all-zero empty record. It validates missing
metadata and missing storage for nonzero-sized values through the existing
context assertion-failure handler before entering a value-specific formatter.
These checks remain active when optional Basic assertions are disabled. They
do not print a successful diagnostic or copy/read a payload during boxing.
Zero-sized storage is exempt from the new payload validation. No broader
zero-sized formatting output is claimed by the official boxing controls.

The minimal intermediate removal of the payload fallback was insufficient:
integer dispatch reached the separate `FormatInt` null-value diagnostic. Its
RED receipt is preserved. Central read validation fixes plain Any consumption
without changing the independently specified formatter-wrapper contracts.

Only `render_item` early guards changed in production. Compiler `box_any`,
descriptor assertions, Mac/Windows platform code and Extensions are unchanged.
The previously requested eager compiler boxing repair is withdrawn. Official
unused/ignored controls disprove it. Compiler worker confirmed its prototype
was withdrawn before integration.

The positive regression uses named fields and checks builder/sprint empty Any,
borrowed alias mutation, address-only null lvalue, unused/ignored boxing and
zero-sized ignored boxing. Separate negative inputs test each corrupt field
and the null-lvalue consumption shape. An additional input imports the actual
Basic instance with `ENABLE_ASSERT=false`, proving mandatory validation survives
that configuration.

Focused interpreter/native O0/O2 current-byte evidence: four controls pass all
12 modes; the assertions-disabled input passes three modes. Here a negative
case passes only when execution fails with exact preceding stdout and no
continuation. Baseline all nine required fault modes incorrectly continued.
All build/runtime commands, source hashes and stderr are retained under own T7
`stdlib/null-format/corrected-any`. The native/fault slot is released.

Default Type initialization is a separate resolved compiler repair, already
integrated by its owner. Official default scalar/record formatting is
`void\n{void, 0}\n`, and scalar/record/array identity controls all match void.
Historical default-Type RED evidence remains; this batch does not change its
legacy golden or claim a new Windows replay. Explicit null descriptor inputs
remain invalid; their assertions are untouched.

See [the ready manifest](status/basic-any-read-ready.json) for exact files,
source/build/strict-lint receipts and hashes. Integration alone stages/commits
the narrow patch and updates the global README link. Actual Windows follow-up
remains required; Mac native execution is not Windows runtime proof.

Integration additionally tightens the runtime checker: partial-null controls must fail with the specific metadata/payload validation cause and exact preceding stdout. Unrelated missing-library failures cannot count as an accepted negative. Two policy unit tests pass; actual replay of this stronger checker is deferred under root’s timing lease. The legacy null-deref-print-any fixture retains its source/hash, stdout7 newline true newline and mandatory failure; only its obsolete NULL READ error literal changes to the new specific validation cause. Original wrong-oracle/failed receipts remain preserved. See [integration review](status/basic-any-integration-review.json).
