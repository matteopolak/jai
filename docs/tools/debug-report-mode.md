# Unconditional Debug report-mode setter

The final reviewed public declaration is
`set_report_mode(interactive: bool)`, including WASM. The previous producer loaded
its implementation through the desktop-only lifecycle file. An independent
public API/state reducer therefore passed Mac source checking but failed WASM
with `module Debug has no exported member set_report_mode`.

The repair moves the existing real flag update into
`internal/developer-tools/debug-report-mode.jai`, loaded unconditionally by the
Debug facade. The desktop lifecycle file no longer declares the setter. All
module parameterizations still write the same canonical reporting flag. No
public alias, extra state record, native fallback, dialog, or debugger feature
is added. The update retains constant time and introduces no allocation.

`Debug/tests/report-mode-state` checks the public procedure signature, named
arguments, invocation through a typed procedure value, true/false transitions
observed in canonical state, restoration of prior state, and the documented false
WASM debugger query. It is a library-owned private-state test exercising the
public facade, not a new public state export. The existing portable target and
native ownership fixtures remain unchanged and required in their reviewed modes.

Frozen source-matched checks pass all 40 source/strict-lint commands: three
fixtures on Mac/Linux/Windows x64 and ARM64, plus the setter and portable fixtures
on WASM. The new state fixture passes Mac ARM64 interpreter/native O0/O2 and WASM
interpreter/emitted O0/O2, with exact `ok` output and no diagnostics. Four generated
artifacts have valid magic and unchanged pre/post execution hashes. Source/tool
drift guards are empty. Windows/Linux source checks are not native acceptance.

The earlier Debug fixture packet remains sealed. Its native ownership/output
test still requires integration's real developer-debug provider; this repair does
not waive that failure or call the native provider. The TOML formatter production
files also remain sealed. The old target-availability question is resolved by
the final reviewed spec; the separate Windows native error-mode mapping is still
[precisely requested](../specs/questions/debug-report-mode-windows.md).

Exact snapshots, retained baseline failure, runtime artifact guards and integration
handoff paths are recorded in [worker status](../status/stdlib-tools-debug-report-mode.json).
