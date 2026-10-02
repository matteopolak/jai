# Compile-time replay identity

## What it is

Source `#run` receipts identify the directive and its checked specialization and captured environment. Equivalent compilations use the same receipt bytes even when registry allocation order differs; distinct baked captures remain distinct.

## How it works

`Resolver::source_run_origin` gathers `RunLexicalFacts` before starting the VM transaction. The source-origin encoder combines the actual workspace, defining module environment, original source extent, structural type identities, normalized baked values, callable policies, and the ordered quotation and macro capture chain.

Captured static scopes form a bounded pool. Code and local macro references use that pool's deterministic traversal positions, allowing shared captures and cycles without serializing `CodeValueId` or scope handles. Frames retain lexical order and sort names by their source spelling. Runtime storage belongs to the transient execution cache and does not become a portable source receipt.

Transient storage keys describe the checked place and its operand structure. Fresh dereference, index, or sequence projection allocation does not change that identity; different operands or check policies do. A staged budget repair admits wide child batches before work-stack growth and checks the final multi-token leaf, closing the node ceiling even when no further iteration follows. Its two new boundary tests await the coordinated build slot.

Each capture retains both its lexical definition environment and its proven source file instance. Caller-reference snapshots use ordered references into the same capture pool. The encoder checks that the source instance owns the captured extent instead of selecting a file by a shared source identifier.

Types and constants use versioned tags, counts, and scalar bits. Named record, enum, and distinct types retain their defining declaration and source environment. Ordinary aliases do not attach identity to a canonical scalar, pointer, sequence, or callback ABI. Callable result obligations remain outside executable specialization policy. Record placement anchors are validated against their actual owner and then encoded as physical field ordinals, so an arena's `RecordId` cannot leak into the receipt.

Weak floats use the canonical expression encoding from `jai-eval`; their source spans, allocation sharing, and fingerprints do not select identity. Baked IEEE floats retain their width and bits. Mutable VM addresses and unsupported constants must fail encoding rather than become guessed portable values.

Native numeric address constants encode a validated source recipe: canonical pointer type, integer width and bits, and checked, unchecked, or truncate mode. The selected execution target still determines address normalization. Encoding this recipe grants neither VM pointer provenance nor a callable address receipt.

The source regression `quoted_run_captures_have_distinct_stable_replay_identity` checks actual execution, distinct captured values, fresh graph equivalence, and unchanged receipts after appending unused procedures or type aliases. The layout codec unit tests independently change real record allocation order while retaining the same checked placement.

## How to change it

Update `metaprogram/run_facts.rs` and `modules/run_origin/lexical.rs` together when adding a captured binding or expansion source. Keep discovery order deterministic and validate every pool reference. Extend `modules/run_origin.rs` and `stable_values.rs` when adding a type or constant domain; use checked source origins or canonical structure rather than `Debug` output or registry indices.

Keep origin construction before effects begin, and preserve the same encoder for scalar, vector, stallable, and anonymous runs. Verify both differing semantic captures and equal fresh-registry receipts before accepting a new encoding.

## Configuration

The lexical encoder admits at most 8 MiB of receipt bytes. Capture discovery and weak-float encoding enforce their existing node budgets; a limit is a structured compilation failure. There is no environment variable for replay identity. Module environments, the selected compilation context, and checked source metadata determine the input.

Transient storage keys have a 65,536-token ceiling and a 1 MiB byte ceiling. Portable declaration type capture separately preflights each expanded type occurrence before encoding; shared registry nodes cannot bypass that recipe budget. This additional preflight remains staged with the compiler quotation bridge.

## Dependencies

The encoder uses source spans and symbols from `jai-source`, defining environments from `jai-modules`, canonical types from `jai-types`, checked constants from `jai-ir`, weak-float encoding from `jai-eval`, and `SourceOrigin` from `jai-vm`. It depends on the semantic capture registry and the common source execution scheduler.
