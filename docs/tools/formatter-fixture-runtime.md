# Staged formatter runtime acceptance

The exact seven-file formatter fixture cohort passed both original functional
acceptance tests on Mac ARM64. This is **staged** evidence, using accepted clean
producer HEAD `2166710449bda1652d75da913fd20a024e737b3b` plus only the seven
hash-verified ready files. No peer working changes entered the snapshot.

The compiler and real native test target were rebuilt from that snapshot, with
`JAIC_STDLIB` pointing to its frozen stdlib. Original
`jaifmt_is_idempotent_on_the_repository` compiled and executed real native jaifmt,
formatted a copy containing 5,908 Jai files, and passed the second `--check`.
The native formatter links only the host SDK's libSystem; no unmatched private
helper was loaded. The original source bytes and observed protections remained
unchanged. T7 reported that readonly permission changes were unavailable; normal
CI acceptance on a filesystem retaining readonly bits is still required.

Original `wasm_target::jaifmt_wasm_formats_the_golden_cases` passed, then passed
again with `JAIC_REQUIRE_WASM_TESTS=1`, prohibiting missing-tool skips. It compiled
and executed the real WASM formatter against every discovered golden, retained
all negative and idempotence assertions, and exercised piped WASI input. Existing
timing collection was incidental to this functional test, not a benchmark gate.

Own T7 `formatter-runtime-y6vqf8qs/runtime-receipt.json` pins the accepted source
archive, seven staged file hashes, compiler and native formatter hashes, test
commands/results and copied file count. Adjacent build and per-test receipts
retain the actual command output. The bounded slot was released after all
children returned. Neither full CI nor integrated-tree acceptance is inferred
from these focused results. The earlier source-only seven-file handoff remains
immutable; this separate evidence handoff updates its runtime disposition.
