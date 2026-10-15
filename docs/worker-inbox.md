# Extensions dependency migration inbox

2026-10-15: This fresh worktree had no worker inbox. Current authorization owns
only Extensions/Io and Extensions/Args, their focused regression tests and docs.
The refresh21 classified report is the failure input; raw integration logs,
quarantined integration, reference sources and peer checkouts are not inputs.

Private allocator adaptation stays inside Io; private process termination stays
inside Args. No new standard-library facade or compiler changes are authorized.
Additional dependency failures will be recorded here with original reproducers.

The first real fiber-context compile additionally exposed obsolete temporary
storage init/deinit, atomic compare-exchange and Thread-start result contracts.
Their dependency migrations stay entirely inside Io, covered by the current
authorization. Native context O0/O2 and interpreted context pass; the original
fiber-overflow test passes. No peer/module/compiler sources were changed.

Linux target checking now reaches `Extensions/Io_Uring/ring.jai:241`, which calls
the canonical one-argument `atomic_load` with a second `.SEQ_CST` argument.
Reproduce with `target/debug/jaic -check -os linux -cpu x64
tests/extensions/io-uring-dependency-repro.jai`. Io_Uring is outside this worker's
exclusive Io/Args ownership; the integrator owns that dependency migration.
Io's own io_uring backend now uses canonical sequentially consistent operations,
which preserve its previous acquire/release guarantees. No dependency source,
backend availability guard or genuine target assertion has been weakened.

The existing owned sleep/cancel regression used unsupported Apollo arithmetic;
it now checks the same ordering and elapsed bounds using checked nanosecond
conversion. Existing Io engine suites also have unreviewed qualified
Atomics.atomic_store calls. Those broader suite migrations remain integrator
work; a new focused real-file/thread test covers this worker's lifecycle changes.

Final owned verification:118/122 focused checks pass, with only the four Linux
Io_Uring dependency failures above. Original compiler fiber3/3 and WASI
formatter2/2 pass with required WASM execution. Actual WASI/native formatter
goldens agree24/24; changed Jai formatting and contextual strict lint pass.
Cross-context ownership now includes real file-pool and localhost-resolution
cleanup, plus zero-scratch/immediate-stack-release variants. No failure is
reclassified as success. See docs/status/extensions-dependencies.md for replay
commands and the exact limits. Ready for integration of the owned migration;
full integration remains pending the integrator-owned dependency/test work.


## Io_Uring migration authorized
Please continue through the four Linux failures: Io_Uring dependency migration is now included in your exclusive scope and AGENTS updated. Preserve real kernel ABI and at least previous memory-order guarantees using supported canonical atomic APIs. Sequentially consistent operations are valid stronger ordering; document that cost/boundary rather than fake unsupported order parameters or weaken synchronization. Add source checks on bothLinuxCPUs and deterministic ownership/protocol regressions; actual kernel/runtime unavailable evidence must remain explicit. Finish all117checks where supported beforefinalhandoff; unsupportednativehost isnot pass. Integrator will receive the complete Extensions dependencycheckpoint.
