# Isolated host runs

Reviewed polymorphism-and-metaprogramming.md and root's independent public
behavior receipt establish that cross-target #run,host evaluates in an isolated
host workspace. Ordinary #run continues to use target declarations and constants;
arbitrary target foreign calls are not automatically translated to host ABIs.

Previously expression checking ignored run flags, and multiple-result extraction
discarded the wrapper. Host runs consequently used target imports and could capture
target names. The compiler now evaluates the original AST in a separate compiler
with host OS/CPU, fresh configured bootstrap, module cache, context and type table.
The filesystem/import configuration and runtime settings are retained. Source maps
share locations, not lexical bindings; diagnostics from new host files keep their
real paths. Non-cross host runs retain ordinary lexical behavior as reviewed.

The existing embedder host factory supplies the new interpreter. A direct compiler
can use its Host.isolated_host capability; unsupported custom providers diagnose
the operation instead of silently switching to native execution. Both execution
and nested workspace service consume the caller's budget. The isolated registry
reports compilation errors, finishes pending workspace work and never adopts
target build settings. It has no output backend; nested code-output requests need
additional backend integration and are not claimed supported by this checkpoint.

Built-in integer/float/bool and string results transfer as owned values. Primitive
fixed/view/growable arrays transfer their type and frozen data relocations to
target-owned globals; host compiler data cannot dangle after its destruction.
Multiple primitive results retain ordering at constant and local bindings.
Pointers, type descriptors, procedures and user aggregates cannot cross the reviewed
result boundary. The host entry takes no parameters, including defaulted ones.

Eleven original core tests cover host constants/imports, independent target module
instances, forbidden capture, primitive/string/array results, multiple results,
parameter/result diagnostics, execution budget and unsupported provider behavior.
An original observer-provider test caught host effects being replayed when a later
target body stayed unresolved: the parent dependency controller did not see the
child's actual execution/trap counts. Those real counts now propagate, so executed
host work cannot be classified as an unstarted target attempt. The unresolved
binding retains its real diagnostic and the effect occurs once, with no skipped
assertion or synthesized completion. Existing retained-continuation tests remain.
Actual interpreter/native ARM64 O0/O2/WASI executions verify transferred data.
The supplied isolated-host-clock-result checks successfully for Linux/x64 on Mac
ARM64, and its exact Compiler-API wrapper completes the real clock evaluation.

The producer's output verification originally remained red: its Linux/x64 child
emitted Mach-O64. Integration's general workspace target routing now passes the
unchanged exact ELF64 ET_REL machine62 assertion. All four host-run CLI tests pass,
including real native ARM64 and WASI transferred-value execution. Cross-object
generation establishes no Linux native runtime result. The original producer
failure remains historical evidence; no target assertion was removed.

Host-body IDE facts are not yet projected into target IDE facts. Whole-corpus
semantic coverage remains strict-red; this limitation is not an acceptance waiver.
The scanner signal investigation remains unconfirmed and suspended.
