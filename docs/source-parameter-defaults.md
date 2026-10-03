# Retained source parameter defaults

## What it is

Ordinary concrete procedure headers retain source default occurrences before their values are ready. An early source prefix can demand the selected omitted default while an unrelated source placeholder still blocks full type preparation.

## How it works

A types-only header publishes the genuine optional formal and canonical expected type, with a source-owned default proof. The proof retains the original declaration, defining file, formal ordinal, reserved procedure identity, original expression span, and immutable source text. It does not supply a placeholder value.

Overload matching uses the checked formal type to recognize an optional argument. Only materialization of a selected omitted argument requests the source value. The request counter is typed state on that proof; the controller observes that state rather than interpreting the binder's diagnostic message.

The retained worklist admits each requested proof once and reserves an owner from the existing auxiliary procedure allocator. Its job calls the normal `Resolver::parameter_default` under the defining `FileScope`, genuine `Context`, canonical type and place registries, current storage facts, and retained VM cache. Procedure, constant, field-default, and effect waits use the existing prerequisite channels. `LibraryPending.source` can additionally identify the actual default declaration and parameter; it never substitutes for a VM dependency.

Publication stores an actual `Constant`, runtime storage-read recipe, or other existing checked default policy on the original proof. Existing signature clones share it, and later complete-header registration reuses the published value rather than rerunning an effectful initializer. Callback policy keys use the real published policy once ready. An unselected early default is not evaluated simply because its header exists.

Each completed selected default is also a source-prefix checkpoint. The driver checks the real input and configuration journals before binding its selected caller, because a default's `#run` may generate a declaration used by that caller. Cancellation uses the same retained cache and effect rollback as other source jobs.

Graph-owned default runs retain their actual VM frames and effect checkpoint when execution reaches an unavailable checked procedure or type. A write before that read is issued once; completing the real source prerequisite resumes the same run key and defining origin. The original `stallable` flag remains unchanged. An external effect or host wait without that flag cancels the checkpoint before servicing that external dependency and reports the existing policy error.

The coordinated candidate passes all six selected-default gates. The failed-producer witness observes one actual `WriteOutput` request and one journal begin, two genuine procedure prerequisites with paired suspension/resumption, and one failed finish with no published output. The non-stallable external-wait gate observes no effect or host service call. These assertions preserve reached internal procedure waits rather than assuming a fixed number of binding attempts.

## How to change it

Change `source_parameter_defaults.rs` for source proof and publication rules, `modules/procedure_default_jobs.rs` for retained job admission and defining-environment evaluation, and `modules/compile_time.rs` for queue and checkpoint ordering. Keep header reservation, candidate optionality, argument materialization, runtime default-read tracking, and callable policy encoding synchronized when extending the carrier.

Do not manufacture default values, infer a source wait from an unknown-name diagnostic, or resolve original expressions in the caller's file. Tests should keep omitted arguments and prove a generated-source round, a genuine checked `#run` prerequisite, repeated pending requests, exact producer spans, cancellation, and failed-producer rollback. This producer covers ordinary concrete graph headers; generic and callback-annotation source jobs have their own defining-environment proofs.

## Configuration

The job uses the session's selected target, `ResolveOptions`, compiler source authority, compile-time limits, and effect owner. The early prefix still requires an independently ready original Context; unfinished context additions retain their real source wait.

## Dependencies

`jai-modules` owns source declarations and immutable source allocations. Header identities, signature metadata, overload selection, runtime defaults, callback policies, the semantic worklist, and `jai-vm` provide checked execution and publication. The driver workspace frame owns graph rebuilds and source/effect journals.
