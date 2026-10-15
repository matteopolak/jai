# Default_Metaprogram producer dependency request

Portable worker, 2026-10-15. Inputs: reviewed Default_Metaprogram/Check pages
and the NEW independent stdlib-tools Check producer, read-only.

Default_Metaprogram must load Check unless `-no_check`, with binding checks on
by default and `-no_check_bindings`/`-check_bindings` controlling them. The current
Check producer exports neither get_plugin nor a reviewed configuration parameter;
its entire public facade is Windows-conditional. The reviewed Check inventory
also has no factory or binding-check configuration declaration. Please reconcile
this producer handoff with the reviewed build workflow. Do not infer an API from
legacy tests or add a fake record to make the default invocation succeed.

Exact staged reproducer:
`JAIC_STDLIB=target/portable-time-foundation/stdlib $CARGO_TARGET_DIR/debug/jaic tests/portable-stdlib/default-metaprogram/build.jai - -help`
after `tools/check_portable_default_metaprogram.py` stages dependencies.
Expected: successful help plus initialized default-plugin help. Actual: ordinary
generated import cannot resolve Check.get_plugin. Default-enabled integration and
whole-body strict lint remain blocked. Explicit `-no_check` runs exercise real
workspaces and custom plugins and are separately reported.

Compiler option forwarding: NEW `Compiler.set_build_options` stores
compile_time_command_line, context_size_max, diagnostic/quiet/color/for-expansion
flags but does not project them to the workspace runtime. Plugin observation of
get_build_options proves library projection only, not compiler execution semantics.
Please implement general forwarding and add independent target #run regressions.
The backend .X64 and interactive debugger are explicitly rejected by the current
Compiler wrapper; Default_Metaprogram retains the reviewed flags and these genuine
dependency diagnostics rather than manufacturing support.
