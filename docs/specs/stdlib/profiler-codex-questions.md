# Profiler/Codex contract synchronization requests

Current status after9b3d4932: all reviewed required public operations and actual
Mac modules-enabled workflows pass. Earlier compiler-failure sections below
are historical. No producer defect remains identified in this assigned scope.
Only independent policy questions remain: concurrent plugin instances (current
policy one active configured instance), and the collection boundary below.

Scope: the independent profiler-codex worktree, Iprof and Codex only.
The module pages read on 2026-10-15 contain declaration inventories and brief
behavior paragraphs. The shared developer-tools questions document marks some
details resolved without spelling out the actual resolved contract.

## Required synchronized facts

1. Codex: provide the actual v2 magic value, byte order for each fixed field,
   record traversal/order, exact version rejection rules, string placement and
   count/displacement encoding. Is Relative_String exactly the canonical
   Relative_Pointers.Relative_String(s16)? Does zero_terminated count include NUL?
   What scalar kinds do generic get/put accept, and what happens on truncation
   (consumption, output preservation, diagnostics) for the overload without error?
   The public model can be implemented independently of these wire decisions.
2. Codex: provide exact Basic allocation/free names and conditional metric
   weights/depth rules (ordinary if, ifx, static if, switch/case, else-if).
   Existing explicit rejection of these paths is not completed functionality.
3. Iprof: spell out the reviewed option grammar, instrumentation eligibility
   (entry point, polymorphs, inline bodies, modules, already modified bodies),
   hook ordering and shutdown ownership. Existing compiler phase/liveness
   mechanisms are available; the missing information is policy, not a compiler
   mechanism request.
4. Iprof: provide History_Scalar factor orientation, variance recurrence,
   eternity_set history/variance behavior, initial sample boundaries, calibration
   samples and SPEEDSTEP_DETECTION_RATIO's actual initializer.
5. Iprof: provide recursive self/hierarchical aggregation rules and exact
   propagate_stack/sum_times/update_history/propagate_to_zone/propagate_expanded
   effects. Define create_report ownership/lifetime, title/headers,
   row sorting/numbering/indent/prefix, heat and tie-breaking.
6. Iprof: define public node/hash helper allocation, duplicate handling and
   init_zone_hash clear-versus-rehash semantics; traversal order/mutation rules;
   whether clear_stack also clears tracker histories or only current counters.
   Existing private identity hash is not evidence of a public bit-value contract.
7. Iprof: provide cursor/frame clamp/wrap conventions, selection and parent
   boundaries, graph scale initializers/easing/sample mapping, USE_GRAPHICS=false
   export availability and Automatic_Zone versus guarded macro selection.
   Callback defaults' names are known; their exact text-width result and
   diagnostics are not specified.

These are requests for observable contracts only, not source bodies or private
implementation details. No alternate source or reference binary is requested.

## Implementable without wire assumptions

The public Codex record layouts use canonical Compiler, Basic and
Relative_Pointers types. Codex_Help memory is borrowed according to the shared
reviewed ownership note; deinit releases its pointer arrays, never the supplied
memory. Original tests will verify these identities and release effects.

## Reviewed answers received

The synchronized module pages now resolve questions 1–7 above. Those broad
requests are closed; implementation uses the reviewed refinements.

Remaining precise questions: what canonical returned-plugin type exposes the
mentioned should_instrument callback? Compiler.Metaprogram_Plugin has no such
field, and the reviewed Iprof get_plugin return type names that canonical
record. Supply the public shape/type identity before adding any field.
For add_hook, specify the generated wrapper name/signature and how the four
name/argument strings map to calls or context bindings, plus the exact runtime
frame/editor hook names to wrap. No wrapper ABI or guessed context field is
invented. Confirm writer minimum thresholds use Report_Row milliseconds, as
the newly explicit propagation contract specifies for those stored fields.

## Final reviewed clarifications received

The later Iprof refinement resolves the private-derived-plugin exposure gap,
wrapper names/signatures/forwarding, Basic exclusions and report threshold
units. No public configuration bridge is added. All formerly pending public
function names now have bodies. Unspecified concurrent plugin-instance policy
is independently one-active-instance per configured module; serial sessions
are supported. Please clarify concurrency if a stronger guarantee is needed.
Ordinary standard-library interception and module-root lint are resolved by
approved producer114dda87. Newly exposed canonical body-ownership and
expression-printing failures are reduced in the compiler handoff; they are
producer dependencies, not missing Jai behavioral contracts.


## Approved reconstruction replay59a69c03

ARRAY_SUBSCRIPT/index printing is resolved and its original modification
reduction passes. Publicly specified unnamed member ownership and inferred
member-dot reconstruction still fail in canonical producer mechanisms; see
new enum-only and interpreted-module reductions in the compiler handoff.
No further behavioral contract is requested for those reviewed shapes.
The independent implementation retains Iprof.message as partial until those
producer editing mechanisms support the required modules workflow.


## Approved ownership/contextual-enum replay69e971b1

Member ownership and inferred enum reconstruction now pass the unchanged
original reductions. Actual modules-enabled workflows expose a general array
inst_flags exporter mismatch: Resizable emits0x10 (TYPE_DIRECTIVE_DISTINCT), but
reviewed RESIZABLE is0x2. Original baseline and edited-body sources and exact
commands are in the compiler handoff. No new behavior question or alternative
public flag is invented; canonical compiler correction is required.


## Precise collection-window policy question

The reviewed entry-point prefix initializes zone names/storage and final report
work before the program main body, but does not define collection of normal
library callbacks invoked by native runtime startup before that prefix, or
teardown after final reporting. The native crash-handler init demonstrates such
a pre-entry call. Current generated automatic instrumentation preserves the
runtime guard and collects only after entry-point setup and before final
reporting; all eligible procedure bodies remain instrumented. Direct public
manual/guarded zone operations are unchanged. Please confirm this window, or
specify required pre-entry/post-report rows and the initialization/lifetime rule
for them. This is an explicit independent lifecycle policy, not a requested
public field, parameter or compiler exception.
