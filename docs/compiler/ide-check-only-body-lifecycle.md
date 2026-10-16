# Check-only workspace body lifetime

Frozen 60321c1d checks the curated shader build successfully, but editor diagnostics busy-loop in the child compiler after its build finishes. The captured stack goes through polymorphic sketching, a generic call's #modify, and repeated retained body dependencies before any hover query.

An independently authored child workspace reproduces the problem with ordinary executable output settings. Its unused type predicate is checked, then prepare_compiled_output prunes its IR body. The procedure remains semantically Done. Later sketching evaluates a generic modifier that calls that predicate. Dependency handling treats Done as ready, resumes the same instruction, and requests the absent body indefinitely. A NoOutput comparison avoids emission preparation and finishes; that comparison is evidence, not the solution.

build.rs::write_output now prepares emitted IR only when an actual output backend exists. Checking still settles and checks the full child, runs its metaprograms, retains configured output settings and phase events, and reports existing diagnostics. Actual backends retain preparation and dead-code elimination. No procedure/module/path names participate in the fix.

The independent lifecycle regression fails on frozen 603 and passes with the repair. A backend observation test checks that emission still prunes unreferenced code. The original shader's first input, retaining all eight buffers, now completes 467 hover and 439 definition requests in approximately two seconds. Its strict report stays red for 32 definition gaps; the other seven inputs remain unexecuted in this focused replay. This is no full-project or whole-corpus acceptance claim.

Root owns the supervised remaining audit. Previous five-project receipts and the stalled shader receipt remain preserved. The compiler worker does not own a running full-pass controller. Passive analysis-root observability is assigned to the LSP owner. A general no-progress guard for absent bodies after destructive emission preparation is a separate dependency-controller ownership request.

Exact commands, timings, source/build identity and retained receipt locations are in [the repair status](../status/compiler-ide-stall-repair.json). Native executable and GUI execution are not part of this source/editor checkpoint.
