# Repeated failed-import discovery in editor analysis

The original approved718 plus second repair remains red: profiling finished
normally at122.559073583 seconds against60 seconds. Root restored all six
diagnostic files byte-exact. Only the858 numeric rows and result/restoration
receipts were consumed; no corpus/reference bodies or path/name mappings.

## Actual causal evidence

Audit elapsed113.163 seconds. Body-drain stage elapsed94.418 seconds.
The body category's96.619-second inclusive total overlaps nested work and is not
added to other categories. Its self time is only2.162 seconds.

One failed import, opaque scope23/index17, has58,733 calls/errors in body drain,
86.764 seconds inclusive AND self, and zero source/module/entity/procedure/run/
placeholder/in-progress deltas beneath it. Import self time across body drain is
89.511 seconds. Other failed imports contain this nested work and their inclusive
times overlap it. This identifies repeated failed import resolution as the
dominant work, rather than failed-body memo reuse, pending settling or interpreter
execution. Epoch-query scans take2.527 seconds in body drain; pending-scope self
time is0.104 seconds. Only25 interpreter executions occur beneath body draining.

The opaque import's precise diagnostic category was requested from root without
requesting bodies or names. The independent reducer isolates the filesystem
discovery path: one unchanged missing import performs33 directory/suggestion
discovery scans for33 requests. The causal assertion requires one real initial
scan and no repeat scans while preserving the complete error (span, message,
notes, fixes and help). It is red on the approved six-file718 baseline; all four
initial correctness controls pass there.

## General repair

Only two production files change: sema/ide.rs and sema/modules.rs.
A private per-Compiler IDE memo retains missing filesystem-discovery diagnostics,
keyed by actual importing scope and source span, with the resolved requested name,
actual directory, configured import paths/preload and source/file/module/run/
execution generation guards. This uses constant-size counters and existing path
values, with no symbol/path exception, global state or case folding.

Import operands and remaps are resolved normally before memo lookup. Provided
imports are checked through their normal path before returning a cached miss.
Parameter, placeholder, failed-body and failed-module semantics are not memoized
by this change. Failed-import event recording and real errors remain intact.

Active interpreter executions bypass the memo entirely: a metaprogram can write
files and ask again within one run. Outside execution, real compile-time runs,
source/file/module progress or import-option changes invalidate discovery misses.
A compiler retained for editor queries uses its analysis snapshot; document/
workspace changes select new analysis normally. Strict CLI resolution (no IDE
facts) does not reuse this memo. No AST/header/scope/recording/timeout/type fallback
or production library change is introduced.

## Independent controls and verification

Six original regressions cover complete diagnostic reuse, real import-directory
changes, actual scalar compile-time execution followed by successful filesystem
discovery, a newly supplied argument binding, strict uncached resolution, and
Session diagnostics/hover/completion/definition before and after a UTF-16 edit
and a fresh Session. File creation is reported through the normal watched-file
notification. Healthy imported declarations and independent errors stay visible.

Fixture setup corrections are preserved separately: initial code tried to name a
private Rust operand type (replaced by its existing const_value accessor); the
first hover position was before the token; post-recovery warning text legitimately
mentioned an unused imported module, so the absence assertion targets error
severity. No production workaround or meaningful error assertion was removed.

Current-source checks use the exact approved transported six files (including
c0c selection and both prior repairs), staged in the existing own authorized
controlled dependency capture. This is not a claim that the entire current shared
workspace was rebuilt here. Scoped Rust format, focused tests and Clippy commands/
results are in own T7 `scale-current-20261016/fourth-repair`; final counts and
source-patch hashes are recorded in the handoff manifest. Native Windows and final
merged verification remain required.

## Integration and remaining acceptance

Apply the narrow tested current-source patch on the accepted718+second-repair
baseline; preserve all other compiler changes. Never bulk replace a compiler file
from this isolated older checkout. Scope.rs accepted c0c source is unchanged.
Integration remains sole shared index owner and owns the separate scale.rs opt-in
budget change. This worker does not change any test bound or functional assertion.

Root reruns the original single case without temporary instrumentation and with
`JAILSP_ENFORCE_SCALE_BUDGET=1` if that approved integration change is present.
The threshold remains60 seconds. Functional diagnostics are always required.
Normal functional CI does not wait for this performance acceptance per current
steering; the opt-in original gate is still mandatory before claiming the latency
fixed. A passing standalone reducer does not prove that the opaque hot import is
this discovery branch or establish the application's final elapsed time.


Integration preserves the always-required !diagnostics.is_empty() assertion in
the original project case. Only its elapsed-time assertion is opt-in, exactly
JAILSP_ENFORCE_SCALE_BUDGET=1, as explicitly requested by the user. The
60-second threshold is unchanged; other functional scale tests are unchanged.
Normal CI is not evidence that the latency target passed. Strict CLI resolution,
module parameters, provided imports and all functional controls remain required.
Current production files preserve accepted integrated changes; whole producer
file hashes differ, so only exact supplied new hunks are claimed integrated.
