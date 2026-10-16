# Runtime instrumentation defaults

Reviewed contract: `specs/stdlib/modules/runtime-support.md`. Both public hooks
have empty default bodies. They are defined in the public module instance so
their identity is shared with that instance's generated system entry point.
The entry calls the first hook and then the second inside the initialized
first-thread context, after optional crash-handler initialization and before
the program entry. No callback registration API was added.

Run `CARGO_TARGET_DIR=<own T7 target> python3
tools/check_portable_runtime_hooks_shared.py` against the source-built tools and
actual shared stdlib. Receipt `runtime-hooks-shared-kh8t5gvo/results.json` under
the portable worker's explicit T7 target records **27 passed, zero failed**:
interpreter, native Mac ARM64 O0/O2, real emitted O0 entry call ordering,
configured O0/O2 object builds without a system entry, desktop source checks,
strict lint with complete manifests, and formatting.

The first missing-export diagnostic was observed before implementation. Test
setup was corrected separately: runtime configuration must be supplied to a
child workspace before its source is compiled, rather than conflicting with
the already configured runtime import in a running main workspace. An unused
Basic import was also removed from the fixture.

Compiler insertion into hook bodies is not specified by the reviewed public
API and remains unverified. Native Windows/Linux execution, crash-enabled
startup ordering at runtime, and arbitrary embedding hosts are separate gates.
Empty defaults are required behavior, not placeholder functionality.
