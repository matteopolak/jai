# Measured compiler reports

The updated reviewed Run_Directive_Report.Record shape is implemented with its
callee, stall count and elapsed seconds. Message_Performance_Report and nested
records are materialized through the ordinary record builder. The facade forwards
performance intercept flags and accepts the existing Rust performance event.
Reports arrive before completion; unrequested run sections remain blank.

Values come from the compiler's existing measured runs, lowering durations,
polymorph instantiation tracking and actual IR instruction/call counts. This
compiler has no bytecode inlining or bytecode-based polymorph deduplication pass;
their counts are zero because no such transformations occur. Native backend
optimization is a separate stage. Anonymous compile-time thunks can have a null
callee because they have no source procedure header; this boundary remains a
public-contract question.

An actual wasm32 compiler host lacks a monotonic timing provider. It now diagnoses
requests for performance reports instead of presenting zero durations as measured
timings. A native compiler targeting WASM can report its real host compilation
measurements. A host clock provider is the proper future implementation for
browser-side timing, rather than target/module checks or manufactured durations.

The original compiler-performance fixture checks both report flags, nonempty
real run/polymorph records, positive measured run time, nested header pointers,
instruction counts, workspace identity, report ordering and an unrequested blank
run section. It passes through interpreter and native CLI execution. Generated
declarations and registration use repository jaifmt normalization and reproducible
regeneration.
