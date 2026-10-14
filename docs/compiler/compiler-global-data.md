# Compiler-managed global data

`Compiler.add_global_data` copies byte slices into compiler-owned allocations.
After a compile-time run the compiler adopts those allocations as IR globals,
retaining their addresses in the interpreter and preserving native relocations.
Aliases therefore share the registered storage, rather than separately frozen
heap copies. Writable registrations participate in ordinary global reset before
interpreted target execution. Read-only registrations become read-only IR data.

`add_data_segment` copies the section name and owns an opaque descriptor for the
duration of compilation. User registrations validate the exact descriptor and its
workspace, and honor its power-of-two alignment and read/write classification.
Descriptor storage is also adopted into the interpreter's global map, allowing
handles and aliases returned from one `#run` to retain identity in a later `#run`.
The backend groups compatible globals and does not create arbitrary discrete
named sections, so `actual_segment_will_be_created` returns `false`.

`get_runtime_info` reports real data addresses and type descriptors. Compile-time
queries receive retained snapshots of the current program, including registrations
made earlier in the same run. Target queries use the final relocated runtime
record. A previously materialized interpreter runtime record is refreshed when
finalization fills it. Segment records identify user registrations with USER,
ordinary writable/read-only registrations with DATA/RDATA, and BSS with BSS.

Registration and compile-time global-data snapshots currently require the running
workspace. Executable segment characteristics, unknown flags/indices, invalid
handles, non-power-of-two alignments, WRITABLE_NO_RESET, and nonzero BSS/ZEROED
inputs produce diagnostics. The reviewed contract does not establish the latter
two reset/initialization behaviors. Version stamps currently remain zero; their
change protocol is unspecified. This implementation does not promise stable
segment ordering or named object-file sections.

The `compiler-managed-global-data` fixture checks copied input, same-run snapshots,
native aliasing and mutation, alignment, BSS/read-only data, reset before target
execution, final runtime records and the target type-table accessor. Separate
negative fixtures check invalid handles and alignment. Run these through
`tests/stdlib-contract/run.py` in interpreter and native modes with the independent
test-library overlay described in the integration handoff.
