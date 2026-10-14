# Debug report-mode Windows side effect

The final reviewed Debug contract resolves the earlier target question:
`set_report_mode(interactive: bool)` is public and unconditional, including WASM.
Its portable effect updates the reporting-mode flag. The current producer already
represents that effect with canonical `internal/debug-state.interactive_reporting`.
Moving the existing setter into an unconditionally loaded helper repairs the
WASM API gap without a second state record or an invented no-op.

The final contract also mentions an additional Windows native error-mode effect.
The prior producer setter only assigned the shared flag. Please refine the exact
native operation and mapping for `interactive=true` versus `false`: which
`SetErrorMode` bits are set/cleared, whether unrelated existing bits are preserved,
whether a previous mode is restored, and any required failure handling. The
canonical Windows SDK declarations expose `SetErrorMode` and `SEM`, but they do
not determine Debug's compatibility policy. No flags are guessed from SDK names.

The narrow export repair preserves the prior Windows behavior and does not claim
this additional native effect implemented or tested. Actual Windows execution
and the desktop diagnostic-output provider remain separate required checks.
