# Compiler Code continuations

Compiler Code control runs in a separate checked compiler plan and retained frame. Its return selects an immutable source quotation; it never creates a native procedure signature or puts Code into a VM `Value`.

## How it works

The source binder reserves a plan for an actual named declaration or an anonymous source occurrence. Its registry key includes defining file, lexical occurrence and specialization. Native leaf bindings use the actual scheduler-reserved `Context.owner`; the semantic expression-binding allocator checks that authority. Plan, control, slot, frame and return-site identities remain distinct from native `ProcedureId` and `LocalId` identities.

`CompilerCodePlanBuilder` records `Evaluate`, `Assign`, `Block`, `If` and source `Return` controls in a bounded acyclic arena. Every native expression or call leaf is checked before execution, including untaken branches. Native inputs are exact typed facts from compiler slots. Static definite-initialization checks reject reads before writes, branch-dependent captures, and reads after block-local retirement.

`start_resumable_compiler_code` compiles those checked leaves into ordinary owned VM node plans and opens one Session checkpoint and effect journal. The compiler controller holds actual native slot values, its block cursor, the active leaf machine, input-binding cursor and partially accepted leaf results. A dependency parks that exact state. Resumption continues it; it does not evaluate prior statements or issue a new transaction for each leaf.

For example, a workspace-creation leaf may suspend, followed by a native call that writes a global and a compiler assignment using that result. If an `If` condition then waits for a procedure, the completed workspace request, global write and compiler local survive. Only the waiting leaf resumes.

At `Return`, the controller seals `CompilerCodeSelection`. Its read-only getters expose the reached site, genuine frame identity, ordered selected slots and exact typed native values. It rejects foreign slots and initialized locals outside the selected capture list. A normal block exit retires its local slots; an early return retains the selected lexical values through publication.

`finish_resumable_compiler_code` runs the source publication callback while the same VM and journal are still open. SourceRun materializes native captures through its existing runtime-type-aware constant conversion. Reflection builds the owner-checked quotation from the selected site and defining lookup scope; graph validation checks insertion before the sole journal commit. Rejection or cancellation restores the whole checkpoint and aborts the journal. An incomplete type during final validation retains the same selected frame for another validation attempt.

Compiler control currently rejects process-control transfers explicitly. The runtime process scheduler copies native machines and VM branch snapshots; it cannot yet copy the compiler frame and control cursor. Extend that transport before admitting a fork across compiler controls.

## How to change it

Change control and slot proofs in `compiler_code_plan`, then add the corresponding retained transition in `execute/resumable/compiler`. Leaf expression lowering and computed operands use the existing resumable VM plan and machine modules. Keep type checks before effects and preserve exact input binding-owner equality; a compiler Code function must not acquire a fabricated native ABI.

Capture additions require matching return-site membership checks in the plan, sealed selection getters in the controller, and source quotation checks in Reflection. Source registry changes must preserve real declaration/occurrence identity and defining lookup scope. No returned native address or address-derived integer may bypass the existing source constant converter.

Session root integration must use the general checkpoint admission helper with the complete cached retained-root count. The live root and rollback holder coexist, and signature/origin metadata belongs to the same bound. Each compiler transition measures current ancillary storage; each native leaf invokes the ordinary machine budget observer. Keep rollback storage, compiler ownership and native machine ownership disjoint when changing these reservations. Do not open independent transactions for native leaves or discard the controller when a leaf yields.

## Configuration

`CompilerCodePlanLimits` bounds control nodes, runtime leaves, return sites, graph edges, slots, inputs and definite-initialization proof facts. VM `Limits` additionally bounds cumulative owned plan/frame metadata, native slot payloads, retained machine state, fuel and evaluation depth. Borrowed value inspection charges work before descent or byte/image scans, and depth is capped at 256.

The compiler plan reserves a bounded control stack before execution and counts its complete vector capacity, including unused entries. Retained leaf results include their vector capacity and native payloads. During an active native leaf, the compiler controller temporarily reserves rollback storage, its other retained owners, current ancillary storage and the machine's additional retained backing from both VM and Memory value-cell quotas. Both quotas are restored on success, suspension and failure. There are no environment variables or host runtime Code settings.

## Dependencies

The component uses `jai-ir` typed compiler-input prefix proofs and iterative rejected-AST disposal, `jai-types` canonical native types, the VM owned plan/machine, Session checkpoint admission and `JournalEffects`. SourceRun owns the lexical plan registry and final native constant conversion. Reflection owns immutable quotation templates and capture-to-declaration receipts; the semantic graph owns insertion validation and publication.

The prior isolated component checks cover suspension, detached transfer, one effect journal, selected-capture boundaries, untaken branches, abort and cancellation. The current dynamic storage observer and source binder require the coordinated integration checks; the prior isolated proof does not establish production registration or full compiler/native acceptance.
