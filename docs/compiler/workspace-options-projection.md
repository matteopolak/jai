# Selected workspace option snapshots

The selected workspace now owns its complete public `Build_Options` snapshot in
the Rust workspace registry. Previously the Jai facade kept options in a global
array belonging to each compiler instance: setting a child's options in its
parent did not make those options visible while the child compiled.

The private snapshot bridge captures scalar/fixed-array bytes and owns copies of
strings and string-array contents. Reflection supplies all offsets; neither the
compiler nor the facade hardcodes `Build_Options` field offsets. Readback creates
compiler-managed backing storage in the receiving interpreter. Public opaque
`user_data_pointer` values retain borrowed pointer identity; this mechanism does
not clone arbitrary pointees or extend their lifetime. Unsupported future view
schemas fail explicitly. A mismatched aggregate size also fails explicitly.
Each readback materializes fresh backing storage lasting for that compiler's
lifetime; it does not promise storage identity between successive string/view
readbacks. This trades additional compile-time storage for safe independent
compiler lifetimes. No content is allocated in a process-global fallback registry.

Separate newly created workspaces start with the public aggregate's defaults.
No parent options are inherited implicitly and no global settings fallback is
used. Explicit `set_build_options` and dynamic updates save into the selected
workspace. Resetting an optimization enum to `UNSET` now also resets the backend
setting. Dynamic linker argument appends become visible through public readback.
The isolated `#run,host` registry remains independent of target workspace options.

`add_build_file` retains its original caller-source anchoring. The coordinator's
official Jai 0.2.030 observations confirm that direct relative addition finds the
main-adjacent child while a helper's default relative addition looks in the
helper directory. Explicit `loc` selects a different source directory; absolute
filenames bypass relative anchoring. The earlier cwd-based change and its
incorrect positive premise are withdrawn, not counted as a compiler fix. Their
original receipts are preserved. Minimal's no-cwd mode retains relative strings
and therefore uses its own API call-site base. The producer's final production
diff contains no path-resolution change, no wrapper rewrite, and no special
Minimal behavior. [Contract questions](../specs/stdlib/workspace-api-questions.md)
record the resolution. This worker read only sanitized coordinator observations
and reviewed specs, not original code or reference binaries.

Reproduce the original option defect with
`tests/compiler-semantics/workspace-options/projection.jai -interp`. The native
regression suite is `cargo test --locked --offline -p jaic-cli --test
cleanroom_workspace_options`. It creates fresh outputs below Cargo's assigned
T7 target, removes any previous child executable before each build, and executes
the actual child outputs. It checks parent/child/grandchild/sibling isolation,
owned snapshot strings and arrays, fixed-array fields, all three parent execution
modes and invalid workspace rejection. Corrected path controls require default
helper rejection, positive explicit-location/absolute-path behavior and positive
helper-local selection. They execute real child binaries without changing the
production path API. The exact independent portable projection and relative
controls supplied by root also run unchanged. No fixture library substitutes for
the canonical stdlib.
An additional real cross-target source check verifies that an isolated host run
starts with its own option defaults and cannot overwrite the target snapshot.

The executed commands and precise limits are recorded in the
[verification handoff](../status/compiler-workspace-options.md).

Root supplied the authorized shared path and copied all four independent pending
fixtures into this checkout. Its actual Minimal sources and runner are available
read-only in `stdlib-shared`; the portable/integration owners are rerunning that
workflow against the final options-only patch. Combined Minimal replay remains
their gate, not an absent-source blocker. The private native crash dependency was
built from the supplied independent runtime C source with
`tools/build_portable_runtime.py`; no prebuilt reference binary was used.
