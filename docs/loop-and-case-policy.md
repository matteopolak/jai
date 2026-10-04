# Loop and case policy

## What it is

This compatibility layer accepts ordered default case labels, default fallthrough, the transition `for #v2` marker, and unnamed removal of the current array iterator. It preserves typed control flow rather than rewriting source text.

## How it works

Case label dispatch and physical body order are distinct. `CaseOrder` validates the bare default ordinal and gives body successors. The hidden case subject evaluates once. A match bypasses any earlier default; unmatched input selects the default; `#through` follows bodies in source order. Each body has an independent scope and runs its own deferred cleanup before entering the next. The same order is retained across procedure-readiness suspension and native branch analysis.

`#v2` is an explicit syntax policy for the existing captured endpoints and reverse visit order described by local pinned source witnesses. Both endpoints and array descriptor addresses evaluate once. Bare `remove;` resolves the actual innermost lexical loop and uses the existing checked descriptor stores and removal-aware cleanup latch. It rejects range/while targets and deferred removal rather than silently mutating an outer array. The existing restrictions on explicit outer removal and multiple removal sites remain.

## How to change it

Update the syntax scalar policy fields, source insertion conversions, semantic validation, IR verification, ordinary/resumable VM dispatch, LLVM branches, and native path analysis together. Keep dispatch priority independent of physical fallthrough. Extending removal should change the typed per-loop state and cleanup latch, not add a text-based iterator lookup. The fixtures in `jai-syntax`, `jai-ir`, `jai-vm`, and `jai-codegen/tests/iteration_removal.rs` check original targets, side effects, nested cleanup, first/middle defaults, direct return chains, and genuine Pending continuations.

## Configuration

No new flags or environment variables. Existing evaluation/fuel and bounds-check limits apply. Retained case lowering reserves the two added policy fields before allocating the plan; its source-copy reservation includes them as well. The authored fixture packet is source-only: formatting and saved-base patch checks are distinct from compilation and execution, and all newly authored tests remain unrun until the shared SSD build slot is granted. Supplied reference executables are never used.

## Dependencies

`jai-lexer`, `jai-syntax`, `jai-types::CaseOrder`, `jai-sema`, `jai-ir`, `jai-vm`, and the existing LLVM backend. The transition-marker evidence comes from local `reference/how_to/019_looping.jai` and `reference/modules/Basic/tests.jai` source text. See [case control flow](case-control-flow.md), [loop control](loop-control.md), [array removal](array-iteration-and-removal.md), and [compile-time cases](compile-time-cases.md).
