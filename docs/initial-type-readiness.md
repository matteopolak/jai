# Initial type readiness (staged)

## What it is

The planned initial preparation stage retains a source type request when it needs a record modifier or an unfilled source placeholder. It precedes the existing retained field-default/header stage. The controller and paired `PendingType` migration remain private and unregistered; ordinary initial preparation still reports these waits as diagnostics.

## How it works

The existing source-procedure inventory reserves genuine concrete declaration identities before aliases are resolved. A type wait must retain that inventory, the original constant evaluator, nominal registry, specialization cache, and source request. Reserving an identity does not publish a signature, type descriptor, body, or global allocation.

The staged alias cursor visits actual original declaration IDs and advances only after `Nominals::prepare_alias` returns a ready canonical type or identifies a declaration that is not an alias. A pending alias publishes no representation. Retrying a ready distinct alias validates its original representation instead of defining a second nominal identity.

The proposed pending cause is a typed sum: a real record-modifier intent and its demand span, or a real `PlaceholderId` and its original demand span. Source preparation waits remain separate from `jai-vm::Dependency`; an unfilled source declaration is not an unavailable VM procedure. Only a one-shot diagnostic boundary turns that cause into a message.

Initial preparation has several earlier demand boundaries: aliases, explicit constant annotations, scalar constant evaluation, procedure type headers, and global annotations. Each needs its own retained original request and cursor. Scalar dependencies must come from the actual lazy lookup; scanning an expression beforehand could demand a name in an inactive branch. Parsing diagnostic text cannot recover a source dependency.

The existing scalar evaluator binds both conditional arms to establish their common domain, then evaluates only the chosen arm. The paired evaluation API must preserve that distinction: genuine ready type/domain facts bind names without reading their scalar values, and value lookup runs only on the selected or short-circuit path. An inactive `u8` or `F64` arm still influences the common result. A genuinely unavailable domain remains a separate type-readiness wait; choosing a literal domain would change semantics. On a value wait, roll back only unfinished `Visiting` constant states belonging to that attempt and retain already checked ready constants.

While a type request waits, only independently ready jobs may run. Such a job needs its actual source signature, checked body, implicit context when required, runtime/compiler adapters, and provider metadata. Count-only modifiers may use their genuine no-context policy. A reserved nominal type does not supply a runtime descriptor, and a missing global cannot be replaced with a zero initializer or an empty globals map.

Newly completed source headers must refresh the retained worklist under their original procedure IDs. The refresh merges actual signatures and queues each genuine source body once; it never resets the auxiliary allocator. Record-modifier completion is measured through accepted-cache progress, because completing a modifier can precede reserving its final record shape.

Generated source changes the graph snapshot. The driver must cancel the old semantic continuation and its exact effects tokens before appending source or rebuilding the graph. Types and lexical identities from the retired arena cannot cross into the replacement phase. Replayed effects retain their original source identity and execute once.

## How to change it

Coordinate `modules/prepared_session.rs`, the parameterized type-preparation helpers, and `modules/compile_time/worklist.rs` as one registration batch. The private alias cursor is a foundation, not a complete scheduler. Preserve recursive pending causes through named types, aliases, type queries, inferred annotations, and lazy scalar/count lookup before exposing a public source-preparation wait.

Share the checked eligibility predicate between the concrete source inventory and selected type-only header preparation. Dormant generic templates and expansion macros cannot create dependency cycles in the concrete inventory; their selected instantiations still require their real preparation jobs.

Acceptance must include generated global/header types, a pointer alias through an unfilled marker, genuine modifier omission versus explicit arguments, and a stable unfilled fixed point. Verify source spans, canonical identities, cancellation before graph mutation, and effect counts. A successful private helper test does not establish source or native execution support.

## Configuration

The stage retains the phase's `ResolveOptions`, selected target, bootstrap policy, and compile-time limits. Record modifiers use the actual compiler policy `ContextMode::None` with inherited default safety checks; source body directives continue to apply. A new graph or target requires a new semantic arena.

## Dependencies

`jai-modules` supplies original declaration and placeholder identities. Parameterized type preparation supplies modifier intents and canonical accepted bindings. `Constants` supplies lazy source evaluation, the source worklist supplies checked bodies, and the driver owns generated-source publication and cancellation. The existing VM and compiler effects journals provide retained execution; no supplied native compiler or artifact is required.
