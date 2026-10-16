# OpenGL debug-output policy

`gl_enable_debug_output(break_on_error: bool = false)` now follows the reviewed
capability boundary on every supported platform: core 4.3 first, otherwise ARB
debug output, otherwise return without registration. KHR alone does not select
a path. In particular a loaded Mac 4.1 context without ARB does not abort startup.
Reported supported capabilities still require valid loaded procedure pointers;
the reviewed contract does not establish a missing-pointer fallback.

Each supported registration passes the same private module-owned callback state.
It captures the current logger, its data, and the requested error-break flag;
later registrations update what previously retained callbacks observe. Native
callbacks establish a Jai context before invoking the captured logger. They
suppress application-source, OTHER, and UNDEFINED_BEHAVIOR messages. Remaining
messages are delivered as the driver's length-delimited payload with default
log metadata; neither that formatting nor metadata is claimed as an additional
reviewed compatibility guarantee. An enabled error-break flag calls canonical
`debug_break()` on error messages, and registration requests synchronous output
only when the flag is true. The helper does not override context message filters
or promise all debug output enabled.

The independent policy fixture substitutes only mutable callback-registration
entries, then invokes the registered callback. It tests unsupported 4.1 and
KHR-only returns, core precedence over ARB, ARB fallback, all three suppressed
classes, selected error/performance delivery, captured logger/data and shared
state identity across registrations. This is procedure-table behavior evidence,
not GPU success. The true/synchronous and debugger-break paths are source checked
but require separately coordinated supported-driver/fault execution. `glEnable`
is a constant SDK procedure on these desktop targets; no production test hook or
fake SDK function was introduced to intercept it.

The pre-fix interpreter control aborted at the unsupported guard. Both declaration
configurations now pass interpreter checks, all six desktop source targets,
complete host strict lint, private-export negatives, retained SDK-fixture source
checks and formatting. Three ARM64 policy programs passed at O0/O2/ASan+UBSan
with exit zero and empty stdout/stderr; snapshot guards matched before/after and
the bounded lease was released in `finally`. That immutable native receipt
retains four Windows source failures caused by a test-only attempt to assign
constant `glEnable`. The corrected fixture removes that false premise and all
source checks pass in a separate current receipt. Production bytes are identical
in both captures; the native run is qualified to its earlier immutable fixture,
not silently attributed to the corrected test file. No fourth native run occurred.

The existing real SDK fixture now injects THIRD_PARTY/PERFORMANCE messages which
the reviewed callback permits, rather than deliberately suppressed application/
OTHER messages. Its test explicitly establishes delivery state. The verifier
requires the actual payload marker, without an unreviewed libc-print prefix.
Unavailable driver callback support remains unavailable and fails that separate
SDK verification requirement; it is never counted as passed registration.
The actual Mac unsupported-context SDK smoke and original Focus startup replay
belong to root. Linux/Windows native, Mac x64 execution, supported-driver callback
delivery/synchronization and debugger-break execution remain separate gates.

No other GL unsupported-API guard, public signature, generated declaration,
context-creation path, Metal implementation or accepted SDK receipt was changed.
