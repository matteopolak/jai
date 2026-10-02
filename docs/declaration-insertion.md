# Declaration insertion

Top-level `#insert` publishes declarations from captured syntax into a retained source graph. The graph transaction preserves the quote's original source record and separates its captured lexical environment from the file where names are published.

The graph transaction is registered in `jai-modules/src/declaration_insertions.rs` and its loader helper. Typed semantic Code production and scheduler integration are being connected; ordinary semantic preparation still reports the existing top-level insertion diagnostic until that route is integrated.

The ten focused graph tests pass for exact receipt cancellation, original source validation, repeated selected imports and private bindings, captured namespaces, allocator and nested-scope rollback, and imported-module resumption. These establish graph transaction behavior; end-to-end Code query execution remains a separate gate.

The post-placeholder component checkpoint at `artifacts/component-checkpoints/insertions-20261002T134130Z/validation.json` verifies 188 captured inputs and its actual test executable; insertion tests pass 10/10. Production-library strict Clippy reports three unfinished placeholder producer fields or methods in that snapshot. The earlier nine-test checkpoint and later live ten-test run are separate measurements; see [Parallel component checks](parallel-component-checks.md).

Source fixtures in `tests/fixtures/declaration-insertions/` cover a generated entry point, a selected import with an absent inactive branch, and one current-scope quote inserted into two private files. Their expected results are 42, 42, and 43. All five authored input files pass parsing with the immutable a19 Rust-built CLI. Semantic and native validation awaits the insertion query; parsing alone is not execution evidence.

## How it works

Each active insertion retains its original `InsertDirective`, destination file, visibility, and `SourceSpan`. A request identity belongs to one discovery session. Repeated source traversal returns the same request, while distinct expansion file instances keep repeated insertions of the same quote independent.

A typed response carries original `FileItem` subtrees, the quote's defining file and source span, canonical graph bindings, and registry-independent captured values. `SourceCaptureValue` preserves weak integer and decimal expressions, concrete scalars, source types and enum identities, and arbitrary string bytes. Source declarations and module instances survive semantic arena retirement. Runtime `TypeId`, `ProcedureId`, native addresses, and replay summaries are not declaration capture transports. Local aggregate, callable, or nested Code captures require their own portable typed representation; producers must reject unsupported captures precisely before effects commit.

The nominal constant classifier recognizes a captured enum by its source enum declaration and integer payload, even when there is no ordinary graph binding for the captured name. It selects typed enum evaluation and propagates that dependency through aliases. Captured values do not acquire dependencies from a same-spelled declaration in the quote's fallback namespace. The semantic decoder must hydrate the original enum into the current registry; forwarding its payload to the scalar evaluator would erase its nominal identity. This adapter does not establish end-to-end insertion execution before the query/scheduler gate above.

Staging returns a transaction receipt. Cancelling the receipt drops the response and leaves the original request pending. A new response receives a new generation, so a cancelled receipt cannot publish a later response. Cross-session receipts are rejected. Publication records its actual expansion file, destination, source provenance, and genuine appended declaration identities.

Before publication, `ModuleGraph::validate_insertion_code` checks original source ranges, canonical capture identities, unique captured names, ancestry cycles, nesting limits, and forbidden inserted module parameter headers. The source evaluator must validate the typed response before committing compiler effects. `GraphDiscovery::prepare_insertion` stages it; `commit_insertion` mutates the graph only after live semantic continuations release their immutable graph borrow. `cancel_insertion` retires the exact receipt.

Each publication appends an actual file instance and scope identity while sharing the original quote's `SourceId`. Original parsed files remain unchanged. File-private declarations are published into the insertion destination; nested publications follow the destination chain to the original file. Their bodies resolve their own declarations first, then captured bindings and values, then the retained capture file's namespace. Current-scope insertion instead uses its destination namespace. Private operators follow the same source and destination relationship without changing their defining declaration identities. Pending work in an imported destination module resumes explicitly, even when its importing module already reached source readiness.

The response's `file` identifies lexical capture; `source_file` is the retained original quote instance. They can differ after current-scope insertion. Validation checks the genuine original source receipt without selecting an arbitrary instance that shares its `SourceId`. Captured safety checks and debug suppression remain metadata and combine with each original procedure's policy during semantic binding. Expansion origin spans are provenance; they must not replace the generated procedure's actual runtime invocation when resolving caller-location semantics.

Source execution cache keys include the insertion occurrence, destination ancestry, captured graph bindings and values, and policy metadata. These canonical bytes preserve raw strings and source type identities without serializing arena or graph allocation IDs. Reusing the same quote span in another destination cannot reuse the first insertion's execution result.

The metaprogram factory structurally converts original quoted statements or blocks into `FileItem` values. It preserves declaration spans independently of wrapper locations, `using` selections, imports, and both branches of compile-time conditionals and cases. Captured-mode insertion exports effective lexical bindings in deterministic symbol order, including scoped imports and ready constants. A ready file-level Code capture becomes its genuine graph constant binding only when that declaration holds the exact same registry-owned Code handle; source-name matching is insufficient. Unresolved shadows, unpaired source frames, scoped operator groups, runtime storage, and semantic-only local Code or callable captures report explicit transport diagnostics. Current-scope insertion deliberately supplies no captured binding overlay and retains the original source receipt and policies. The factory is registered; the source query and scheduler still need to connect its receipt to the graph transaction.

## How to change it

Extend the transaction and provenance rules in `declaration_insertions.rs`. Graph registration and dependency scheduling belong in a loader helper; semantic capture export belongs to the metaprogram subsystem. Extend those typed transports together rather than generating replacement source text or modifying original parsed files.

Enum capture classification is shared by `modules/enum_constants.rs` and its pure-expression evaluator. Keep both routes aligned when adding captured nominal value forms, and preserve capture precedence when collecting declaration dependencies.

Declaration publication must be atomic when a later declaration conflicts with an existing binding. A failed or cancelled transaction must preserve previously published declarations, bindings, overload memberships, and identity allocation. Nested publication checkpoints all affected destination scopes and ancestor expansion names. The driver must couple graph publication to the original source effect transaction; a completed scalar `#run` followed by unchecked graph insertion is not equivalent.

`#insert,scope()` uses the insertion destination's lexical context. Default insertion uses the captured context. Both retain the quote's original diagnostic source; changing lexical lookup must not change where an error is rendered.

## Configuration

The helper accepts at most 128 nested declaration expansion levels and 100,000 original file items per response. Target facts, import directories, compiler effect policy, and VM limits continue to come from the existing discovery and semantic options.

The structural semantic factory uses a stricter 65,536-item and 128-level syntax ceiling. Capture export permits 65,536 effective names, 1,048,576 lexical nodes, and 1 MiB of encoded constant data. These checks precede graph publication and compiler effect commit.

## Dependencies

The transaction uses `jai-source` identities and immutable source records, `jai-syntax` source subtrees, and `jai-modules` canonical bindings and source argument values. Activation also requires the metaprogram capture producer, semantic source worklist, and driver's retained graph job and compiler effect journals.
