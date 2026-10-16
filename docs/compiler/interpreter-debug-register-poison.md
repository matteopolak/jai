# Interpreter debug register initialization

The scoped beec catalogue records an unchanged JSON numbers test passing natively but timing out after180.0076seconds in the interpreter. That timeout remains preserved. Root verified equal nonempty Json source trees (341files) and equal interpreter sources (23files) between the approved603 and beec snapshots; timings still describe their actual tested snapshots.

Independent controls verify exact IEEE bits for ordinary decimals, halfway rounding, maximum finite numbers, normal/subnormal boundaries and negative zero. A separate128-value finite full-exponent roundtrip control passes with both the JSON formatter and Basic shortest formatter. Only the existing numbers test was read; no Json implementation body was inspected or changed.

An instrumented diagnostic copy adds only main-level begin/end prints, retaining all original assertions/counts. Parsing/ordinary printing complete quickly,1000random roundtrips complete in about5.7seconds, and shortest_matches_exact dominates the run. A bounded CPU sample shows normal interpreter computation rather than dependency nonprogress. Approximately20percent of active samples are in unoptimized Rust slice-fill register poisoning.

The private poison_registers helper copies constant blocks while preserving the exact dead_beef_dead_beef word in every register. Small frames copy directly. Interp::enter retains the same checked slice, initialization frequency, debug-only configuration and guard behavior. No checks, assertions, input sizes or JSON routines are disabled or special-cased.

The source-built debug repair runs the entire unchanged original numbers test to exit0/ok in137.550seconds, below its unchanged180second limit. This is a603 repair result, not a substituted beec receipt. All169core unit tests,33browser-host tests, formatting and warnings-denied Clippy pass. The browser tests execute on the native host; no new WebAssembly artifact execution is claimed.

[Exact receipts and limits](../status/compiler-json-interpreter-progress.json) include source/compiler SHA256, instrumentation and source-guard provenance. Integration must replay the matching combined candidate. Extensions remains unchanged, and no release build or debug-disable flag is involved.
