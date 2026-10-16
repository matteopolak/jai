# Conditional callable header inference

This narrow repair follows the independently authored official compilation controls
supplied by root. With f(x:=3) and g(x:=4), a runtime conditional selecting f/g
retains the lexical else header: both flags pass 4 to the selected procedure.
Reversing the arms passes 3; mutating the flag after assignment changes neither
the selected pointer nor its lexical header. Exact official observation:
`ORACLE choose 4 4 reverse 3 3 mutate 4 4`.

## Implementation

Only sema/expr.rs::check_ifx changes. Capture existing callable Operand metadata
from the converted else arm before reducing it to a runtime pointer, then attach
that metadata to the joined result. Existing declaration inference receives the
same names/defaults/evaluation scope/returned-callable headers it already handles.
Runtime branch dispatch, structural procedure TypeId, pointer ABI, conversions,
lookup and visibility do not change. Explicitly typed callback declarations keep
their own lexical header. Compile-time constant-conditional branch checking is
unchanged; this repair addresses the runtime conditional join.

Independent regressions cover both flags, reversed arms, flag mutation, named
arguments, nested else joins, ordinary aliases sharing structural types, explicit
callback headers, private loaded-file defaults and required/incompatible-header
rejections. Root additionally confirmed the different-name discriminator: a call using the
else parameter name succeeds for both runtime flags; the then-only name is rejected.
A required else parameter cannot inherit the then default. Those exact positive
and negative controls are included in the causal tests.
The original overloaded proc-type-defaults-ifx fixture remains officially rejected
at its earlier branch mismatch; it is unchanged and never counted as repaired.

## Io workspace configuration frontier

The original Choice two-list reducer had invalid import arguments according to
the supplied official control. With corrected single-list ordinary parameters,
a direct configured import passes and an unused named configurator does not
override an anonymous plain instance. Neither justifies broad eager discovery.
All such prototypes remain removed, and the official cycle rejection is retained.

The separate four-source numerics-io-workspace-config reducer uses actual reviewed
Basic/Compiler APIs: NO_OUTPUT child workspace, import remapping, child root Basic
import, an independently authored Worker and No_Assert provider, and correct second
argument-list Basic configuration. Both Windows CPUs reproduce ENABLE_ASSERT
already-used. A child with an explicit second-list Basic setting passes locally;
a child omitting its plain root Basic import still fails when only the remapped
provider supplies configuration. This removes Io/Thread implementation dependencies while preserving
the metaprogram/child/configuration structure. Root official compilation is requested
before classifying its public contract; no configuration guard bypass is proposed.
The obsolete earlier Choice reducer is preserved as invalid diagnostic evidence,
not a compatibility-positive fixture. Initial source failures and exact commands
remain in own T7 captures, never reclassified green by a source-only heuristic.

All source builds/captures use the existing own T7 cross-source-8e81 namespace;
new patches are relative to isolated c0c2419, disjoint from its frozen context/Json
handoff. Integration alone stages shared adoption. No compiler peer functions,
Extensions production, reference bodies, GUI/fault/performance or remote operations
are part of this repair.

## Current verification

Twelve new causal tests and 42 focused existing tests pass (54 total). The exact
independent official control prints the matching choose/reverse/mutate observation.
The owned runtime fixture passes interpreter/native ARM64 O0/O2 with assertions
covering callee selection, reversal, mutation, named arguments, explicit callback
headers and an ordinary alias. Both new public contexts pass warnings-denied lint
on Mac ARM64 and Windows x64/ARM64 (six contexts). Actual JaiFmt rewrite/check
passes on all nine new Jai inputs, with original workspace oracle bytes retained
in capture/io-workspace-oracle-original. Rustfmt and Clippy warnings-denied checks
are recorded separately. Native slot explicitly released; no Windows binaries,
GUI, fault programs, benchmarks or broad corpus run were executed.

The original overloaded fixture may now compile through existing permissive
overload handling plus the repaired join, but its official rejection category
remains unchanged and its raw exit code is never counted as compatibility PASS.
Initial RED receipts remain intact. The four prior context/Json source positives
remain positive; actual Io workspace configurations remain unresolved REDs.
