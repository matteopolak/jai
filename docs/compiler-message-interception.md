# Compiler message interception

The source Compiler bindings subscribe to owned workspace events and receive them as checked `Message` pointers in VM memory. Event production belongs to the scheduler and native job service; the VM adapter does not infer compilation completion from a successful semantic check.

## How it works

`compiler_begin_intercept(w, flags)` and `compiler_end_intercept(w)` bind only marked declarations with a selected Compiler API origin, the exact signed workspace ABI, and the checked `Intercept_Flags` source enum. The default flags value requests AST events. The current host supports `SKIP_ALL` for phase and terminal events; requests for AST or performance data fail explicitly until those exports exist.

The original header's weak integer-zero default is bound to the exact source flags enum. Omitting flags forwards NONE to host policy; it does not silently substitute SKIP_ALL or enable unsupported AST exports.

`compiler_wait_for_message() -> *Message` requires the real source `Message`, `Message_Phase`, and `Message_Complete` records from one selected module. The binder validates every field, the embedded `#as using` base, and exact inline enum names, values, and representations. It stores actual `TypeId` and `FieldId` metadata. Ordinary procedures with these spellings remain ordinary procedures.

The host returns an owned `CompilerEvent`, never a cached VM pointer. The receiving VM constructs a fresh concrete phase or completion record, embeds the actual `Message` base, initializes remaining fields with valid zero values and string descriptors, and returns an immutable pointer to that leading base. Checked casts can recover the concrete record. Existing snapshots retain their contents after later messages arrive. Workspace IDs and pending counts must fit the source `s64` and `s32` fields.

Reconstruction prepares the concrete record's target layout within the remaining fuel before allocating it. Cold layout traversal, including incomplete-type readiness attempts, is charged rather than performed outside the VM budget.

Supported phase payloads are source parsed, typechecked with an actual pending count, and target code built. Completion carries NONE, COMPILATION_FAILED, or COMPILER_SHUTDOWN. A successful COMPLETE event requires completion of the configured job. A workspace configured with NO_OUTPUT completes after its actual source and compile-time recipes reach a clean fixed point; this emits neither target-code-built nor write phases. Native-output workspaces need a completed native job receipt, and parsing or typechecking alone cannot finish them. Executable names, object lists, linker results, and later link/write phases require additional real job metadata and are not reported by this subset.

An empty queue returns an effect dependency with an exact polling identity. It does not return null or a successful empty response. Resumption must poll that issued request while retaining the recipe’s checked execution and transaction state. Source-origin replay accounts for owned event values and reconstructs storage in each receiving type arena. Driver subscription, queue, cancellation, and continuation handling remain the host’s responsibility; VM/schema tests alone do not establish complete scheduler progress.

## How to change it

Extend the source schema validator in `jai-sema/src/modules/compiler_intrinsics/schema/messages.rs` and the catalog in `compiler_intrinsics.rs` together. Source enum syntax and flags metadata live in semantic nominal/inline metadata; the canonical type registry carries enum storage representation and values.

Owned models live in `jai-vm/src/effects/compiler_messages.rs`. Memory reconstruction lives in `execute/compiler_messages.rs`, and ordinary begin/end argument adapters live in `effects/source.rs`. Add a typed event payload and a genuine scheduler/backend producer before exposing more source fields or phases. Update request accounting and replay/polling adapters for each new payload; never retain arena pointers across graph rebuilds. Test source schema rejection, actual record reads, immutable snapshots, Pending identity, and genuine host lifecycle separately.

## Configuration

Configured module roots establish trusted source identities. The current workspace resolves source `-1` arguments, and the receiving VM's target layout and byte order govern record storage. Normal VM fuel, memory, structural-depth, and value bounds apply to reconstruction. Host queue and suspended-job limits govern event production and waiting. No configuration loads or executes supplied native compiler artifacts.

## Dependencies

The feature uses source metadata from `jai-modules` and `jai-sema`, canonical records/enums from `jai-types`, checked VM calls and memory, CompilerSession transactions, source-origin replay, workspace scheduling, and actual native job receipts. It adds no external dependency.
