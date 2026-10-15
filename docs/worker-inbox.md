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
