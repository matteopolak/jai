# Compiler Code results

Compiler Code results retain source quotations and their lexical captures in the compiler. They have a separate control plan and frame; `Code` does not acquire a runtime layout, native procedure signature, VM `Value`, or pointer representation.

The new plan and binder are staged helpers. Source insertion routing and the retained VM controller must be registered and tested together before executable Code producers are available. Existing direct quotation insertion continues to use its existing source receipt.

## How it works

A named producer is keyed by its actual declaration, defining file, and source location. An anonymous producer is keyed by its real file, source range, and retained occurrence identity. Neither form invents a native procedure declaration for the Code function.

The compiler plan owns bounded controls, native slot schemas, native expression leaves, and Code return sites. Compiler slots use plan-owned identities distinct from runtime locals. Each native leaf declares the exact typed expression bindings it reads from those slots. IR verification checks these bindings against the genuine ambient source execution owner without requiring that a file-level execution owner have a native ABI.

Control verification checks all staged native leaves before effects begin, requires a Code return on every path, and proves initialization before slot reads and selected quotation captures. Branches merge only facts guaranteed on every continuing path. Normal lexical block exit retires its slots; early return preserves the active frame for capture. Rejected native expression trees are disposed iteratively. Before retaining a quotation, a borrowed iterative syntax walk admits every nested statement, expression, type, declaration, and payload. The template constructor borrows the source AST and clones only after admission, so rejecting a deep quotation does not take ownership of its tree.

The retained controller must execute native leaves in one transaction and preserve its current input, running leaf, result application, and compiler frame across pending dependencies. A leaf must never be replayed after completing an effect. At the reached Code return, reflection snapshots selected native captures into portable source values, builds a declaration insertion receipt, and validates the destination graph before the transaction's sole commit. Validation failure aborts the transaction.

Required source examples include:

```jai
#insert -> Code {
    effects();
    return #code Banana :: 5;
}

return_me_a_code :: () -> Code {
    return #code Banana :: 5;
}
#insert #run return_me_a_code();
```

The initial binder stages initialized native locals, assignments, expression effects, `if`, lexical blocks, and explicit quotation returns. Callback-bearing compiler locals require a separate source contract sidecar and are rejected at that local boundary until it exists. Native effect statements retain ordinary `#must` result checks. Other compiler controls, Code-valued local mutation, arbitrary compiler Code factories, and nested Code procedure calls require additional checked compiler-domain forms. They must not be lowered through runtime Code storage or independent scalar `#run` executions.

## How to change it

Change `jai-vm`'s `compiler_code_plan` for new typed controls or storage forms, and its retained execution adapter for their pending and rollback behavior. Change `jai-sema`'s `compiler_code` binder and source insertion/header adapters for source behavior. Reflection owns the compiler quotation receipt and portable capture conversion. Keep a return site's quotation and captures tied to its exact plan and reached frame.

Adding a native slot reader requires both the semantic `CompilerInput` binding and the IR compiler binding prefix proof. Preserve native runtime type checks and the actual source execution owner. Do not substitute zero values to pass verification, allocate runtime locals for compiler slots, or attach a Code result to a native signature.

Tests must cover effects once across suspension, abort before graph publication, initialized captures, foreign plan/site/slot rejection, and deep rejected expression disposal. Ordinary native and scalar compile-time execution should keep their existing behavior.

## Configuration

Plan staging defaults bound controls, runtime leaves, slots, and return sites to 4,096 each; control edges and input/capture entries to 8,192; retained initialization proof facts to 65,536. Source control nesting is limited to 128. Quotation capture admits at most 65,536 syntax facts, depth 128, and 1 MiB of string or byte payloads; these limits cover nested declarations and metadata as well as outer statements. All returned quotations in one source plan share the retained syntax and byte budgets. Named source templates also admit the entire borrowed procedure before cloning it. These compiler-plan limits do not change global VM fuel or allocation defaults.

## Dependencies

The implementation depends on `jai-source` identities, `jai-syntax` retained quotations, `jai-types` canonical native types, `jai-ir` owned expression verification and iterative disposal, `jai-vm` retained effect transactions, semantic reflection capture conversion, and `jai-modules` graph validation/publication.
