# Autorun execution and plugin lifecycle

Reviewed helpers resolve workspace output path/name, log and skip non-executable
outputs, and launch executable results with caller arguments. Launch/signal/exit
failures produce error logs using actual Process_Result fields. Child stdout/stderr
follow Process. Windows suffix/backend support remains unimplemented and is
explicitly rejected by the current Unix-only module.

The private opaque Plugin retains its canonical reflected name and a leading
Metaprogram_Plugin base. A stable singleton owns copied arguments and captured
allocator state. Typed private bridges adapt exact public lifecycle signatures
to Compiler callbacks without casting function-pointer types. Init replaces prior
owned arguments, matching successful COMPLETE messages run the workspace, and
shutdown frees strings/header storage. Current init options are program arguments;
full option grammar is unspecified. The callback module-parameter declaration is
absent and withheld rather than invented.

An actual source-built workspace test waits for COMPLETE, verifies output exists,
invokes the registered callback and checks the child's forwarded marker bytes.
It tests the direct helper again and a real NO_OUTPUT workspace's informational
log. Runtime tests capture missing-executable/nonzero-exit errors. This verifies
real lifecycle events, not completed CLI plugin integration.

The updated independent compiler fixes mixed scalar/spread variadic calls. The
original regression passes in both modes and is promoted, retaining result/output
assertions. Autorun now passes executable plus spread directly, removing the
temporary argv allocation. Its real workspace argument/lifecycle regression stays.

CLI integration remains unfinished:
- `pending/autorun-cli.jai` with +Autorun fails at unimplemented Metaprogram_Plugins.
  CLI generation also calls build_with_plugin_groups, absent from the reviewed
  public inventory. Do not add that convenience export to satisfy old behavior.
  The driver should use separately designed internal orchestration or canonical
  lifecycle operations. Dynamic plugin loading/argument contracts also require
  implementation; +Autorun is not counted as integrated support.
