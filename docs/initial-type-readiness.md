# Initial type readiness

## What it is

The initial preparation stage retains original alias, annotation, and scalar requests when they need a checked source prerequisite. It runs before field defaults and global initializers, preserving the actual semantic arenas and the original constant evaluator across retries.

## How it works

The existing source-procedure inventory reserves genuine concrete declaration identities before aliases are resolved. A type wait must retain that inventory, the original constant evaluator, nominal registry, specialization cache, and source request. Reserving an identity does not publish a signature, type descriptor, body, or global allocation.

The alias cursor visits actual original declaration IDs and advances only after `Nominals::prepare_alias` returns a ready canonical type or identifies a declaration that is not an alias. A pending alias publishes no representation. Retrying a ready distinct alias validates its original representation instead of defining a second nominal identity.

The pending cause is a typed sum: a real record-modifier intent, an actual `PlaceholderId`, or a checked constant declaration. Each retains its original demand span. Source preparation waits remain separate from `jai-vm::Dependency`; an unfilled source declaration is not an unavailable VM procedure. Only a one-shot diagnostic boundary turns that cause into a message.

Initial preparation has several earlier demand boundaries: aliases, explicit constant annotations, scalar constant evaluation, procedure type headers, and global annotations. The owning phase retains original declaration IDs, parser-owned annotations, checked source signatures, and the evaluator state for those requests. Scalar dependencies must come from the actual lazy lookup; scanning an expression beforehand could demand a name in an inactive branch. Parsing diagnostic text cannot recover a source dependency.

The existing scalar evaluator binds both conditional arms to establish their common domain, then evaluates only the chosen arm. The paired evaluation API preserves that distinction: genuine ready type/domain facts bind names without reading their scalar values, and value lookup runs only on the selected or short-circuit path. An inactive `u8` or `F64` arm still influences the common result. A genuinely unavailable domain remains a separate type-readiness wait; choosing a literal domain would change semantics. On a value wait, roll back only unfinished `Visiting` constant states belonging to that attempt and retain already checked ready constants.

While a type request waits, only independently ready jobs may run. Such a job needs its actual source signature, checked body, implicit context when required, runtime/compiler adapters, and provider metadata. Count-only modifiers may use their genuine no-context policy. A reserved nominal type does not supply a runtime descriptor, and a missing global cannot be replaced with a zero initializer or an empty globals map.

While initial types wait, readiness-aware adapter binders validate the original graph unit, selected target, immutable source receipts, and canonical role policy. They withhold capabilities for missing checked headers or incomplete nominal facts. Later phases use the strict binders; a missing source contract remains an error.

Newly completed source headers must refresh the retained worklist under their original procedure IDs. The refresh merges actual signatures and queues each genuine source body once; it never resets the auxiliary allocator. Record-modifier completion is measured through accepted-cache progress, because completing a modifier can precede reserving its final record shape. A body annotation may request a new recipe after the initial cursor completes. Full binding services the same retained intent before retrying that original body, and a change in the actual recipe queue counts as progress. The wait keeps its original source application, auxiliary procedure, and accepted bindings; it does not become a fabricated VM dependency. When acceptance changes a preceding Type slot, later formals resolve against that actual accepted TypeId. Their retained values pass the common argument compatibility and baking checks before entering the final specialization key. Checked widening preserves the value; narrowing and distinct nominal substitutions remain errors. This recheck consumes the already accepted value and never reevaluates its source initializer or modifier.

The checkpoint source suite proves the original seven modifier cases and a dependent narrowing rejection. The coordinated source candidate additionally passes four canonical typed-constant gates, including the preserving-Type control and changed distinct-Type rejection corresponding to the [earlier pending witnesses](../crates/jai-sema/tests/pending/record-modifier-distinct/README.md). Their original typed annotation is prepared before modifier execution, so the denial exercises actual accepted dependent bindings rather than an earlier annotation failure.

An explicitly requested source-run prefix can service original source producers before an unrelated type marker is filled. Its early context producer currently admits only a genuinely empty original schema with no bootstrap additions; unfinished source context fields retain their original wait. A completed run yields an actual checkpoint for the graph owner to inspect, rather than fabricating a source dependency from an unknown-name diagnostic.

Selected typed nominal constants can be prerequisites of an alias argument before ordinary constant publication. Their original annotations are prepared in the same canonical arena; the demanded initializer uses the retained source constant queue, and only its actual checked typed value enters nominal constant metadata. A nominal value never becomes a guessed scalar seed. Scalar/domain consumers of a ready non-scalar value receive a real type error.

If a retained source queue reaches a fixed point before recording a VM read, preparation reports its actual body, constant, run, or alignment source front and queue identities. It does not panic or create a synthetic VM wait. This diagnostic repair does not establish support for the unresolved authored Memory Debugger Core source.

Generated source changes the graph snapshot. The driver must cancel the old semantic continuation and its exact effects tokens before appending source or rebuilding the graph. Types and lexical identities from the retired arena cannot cross into the replacement phase. Replayed effects retain their original source identity and execute once.

## How to change it

Coordinate `modules/source_preparation.rs`, `modules/prepared_session.rs`, the parameterized type-preparation helpers, and `modules/compile_time/worklist.rs`. Preserve recursive pending causes through named types, aliases, type queries, inferred annotations, and lazy scalar/count lookup through the public `SourcePreparationPending` channel. Do not convert source waits into VM dependencies. Keep the Full method sweep connected to queued modifier service so late body applications can finish through the same cache. `materialize.rs` normalizes accepted bindings in declaration order; its dependent values share the argument checks in `overloads/baked_rechecking.rs`. Retain exact canonical target types and source spans when extending those checks. An inferred pattern with an omitted modified default still needs its own checked recipe; its rejection belongs to the original owning header occurrence.

Share the checked eligibility predicate between the concrete source inventory and selected type-only header preparation. Dormant generic templates and expansion macros cannot create dependency cycles in the concrete inventory; their selected instantiations still require their real preparation jobs.

Source tests cover count-only modifiers, checked scalar prerequisites, annotation requests, stable marker identity, and cancellation. Further generated-source acceptance must include generated global/header types, a pointer alias through an unfilled marker, genuine modifier omission versus explicit arguments, and a stable unfilled fixed point. Verify source spans, canonical identities, cancellation before graph mutation, and effect counts. A successful private helper test does not establish source or native execution support.

## Configuration

The stage retains the phase's `ResolveOptions`, selected target, bootstrap policy, and compile-time limits. Record modifiers use the actual compiler policy `ContextMode::None` with inherited default safety checks; source body directives continue to apply. A new graph or target requires a new semantic arena. Type-valued modifier slots use canonical runtime descriptors and therefore require an explicitly selected layout or target. Count-only recipes remain target independent.

## Dependencies

`jai-modules` supplies original declaration and placeholder identities. Parameterized type preparation supplies modifier intents and canonical accepted bindings. `Constants` supplies lazy source evaluation, the source worklist supplies checked bodies, and the driver owns generated-source publication and cancellation. The existing VM and compiler effects journals provide retained execution; no supplied native compiler or artifact is required.

The [initializer lookup producer](initializer-source-lookup.md) uses an actual escaping `LookupError` and existing consumer declaration to admit an independent original source producer. It does not convert unknown names into initial type or placeholder requests. Its four semantic, two diagnostic-receipt, and seven workspace gates pass in the coordinated source candidate.
