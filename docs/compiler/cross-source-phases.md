# Cross-source configuration and library phases

This independent compiler lane starts from accepted clean producer commit
8e81e901866e60122901596117892be77abb631b. All scratch, source builds and
captures live under the numerics/cross-source-8e81 T7 namespace. Compiler
production changes are isolated; the shared integrator alone stages adoption.

## Supported repairs

A plain static conditional was evaluated during its readiness probe and then
again during commitment. The latter evaluation enabled ordinary pending lookup,
which could initialize an unrelated defaulted global using and freeze Context
before the selected file registered its context field. Expansion now retains
the first successful selection, restores ordinary lookup, and declares that
branch. An unresolved probe still waits for normal expansion and diagnostics.
Runtime pending retries, visibility and declaration ownership are unchanged.

The interpreter used every target link_always requirement during any foreign
lookup, including a compiler-host allocator call while generating Windows Json
code. Program metadata now records whether selected OS/CPU differ from the
compiler host. Cross-target compile-time lookup does not initialize the target
requirement list. Explicit foreign lookups remain normal; same-target compile-time
requirements and runtime requirements remain mandatory. No library-name or
platform-name exception and no target dependency is removed from emitted metadata.
An embedding foreign-data provider verifies an actual lookup and readable storage;
it is not reported as execution of a native provider or Windows binary.

## Actual initial evidence

The fresh source-built compiler reproduced all eight reported Windows source
failures: four fixtures on each of x64/ARM64. After the two repairs, static-switch
context and Json generator checks pass on both CPUs. The other four executions
remain failed and recorded. Focused independent/core tests initially pass 70/70,
including existing typed program settings, callable provenance, nominal generic
argument conversions, isolated host runs, context behavior and all eight readiness
controls. These include error retention, exactly-once effects and the previously
officially rejected conditional cycle. This is scoped evidence, not a full corpus
or native Windows result. Exact commands/output are in the T7 capture receipts.

## Remaining decisions and preserved experiments

Root official Jai 0.2.030 rejects the original proc-type-defaults-ifx fixture at
an earlier overloaded/concrete branch mismatch. Its two CPU failures must stay
reference-rejected, not be made green with an unreviewed overload conversion.
Two supplied independent non-overloaded common/differing-default controls are
reference-positive and currently reproduce a real missing-header inference gap.
The exact true-flag/reversed-arm/mutation default-selection rule was requested
before implementing a general join rule. No global structural-TypeId default table
or ordinary alias refresh is proposed.

The real Io configuration fixture and an independent Choice/Configure reducer
still report a program parameter used before its setting. Broad early import
registration prototypes fix that symptom but incorrectly accept the existing
reference-rejected conditional cycle. Those prototypes are retained only as
local rejected experiment receipts and removed from production. Root has been
asked to classify the precise late named-configurator contract. Existing bf436
typed program-parameter behavior remains intact; no conflicting-setting guard is
removed and no default is silently rewritten after consumption.

After the root LSP-scale slot release, bounded serialized checks completed:
both production contexts passed interpreter/native ARM64 O0/O2 (six outcomes,
ten commands), and both existing real C constructor/required-library protocol
tests passed. Actual JaiFmt rewrite/check passed on the six owned Jai fixtures.
The initial formatter invocation used paths relative to its driver directory and
failed; absolute input paths corrected that test setup only, and both receipts
are retained. The slot was explicitly released after children were reaped.

Strict lint passes for the original context-loading fixture on both Windows CPUs
and the owned Json/Tls context on both Windows CPUs plus native Mac target.
The original Json diagnostic intentionally imports but never names Tls and
retains its unused-import lint failure; no suppression or source alteration is
used to call that fixture lint-clean. The new context actually consumes the public
Tls_Config and Json.free_json declarations.

No native lease is currently held by this lane. TLS source-positive cases
and the separate ARM64 SDK link issue remain platform-io ownership.
