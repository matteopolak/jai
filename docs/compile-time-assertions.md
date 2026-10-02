# Compile-time assertions

## What it is

`#assert` checks an immutable condition while compiling an active file, procedure body, or record. A false condition stops compilation with the original source location and optional diagnostic message; a successful assertion emits no runtime instruction.

```jai
#assert CPU == .X64 "This implementation requires x64.";
check :: ($Enabled: bool) {
    #if Enabled { #assert Enabled; }
}
#assert(2 + 2 == 4, "Arithmetic invariant");
```

## How it works

The parser retains the actual condition, optional message expression, and directive span. Both adjacent quoted messages and parenthesized comma messages are supported. Inactive `#if` branches still parse, but their assertions do not bind or execute.

Body assertions run after source branch selection and before ordinary flow lowering, so they see selected declarations in the enclosing scope and genuine baked parameters. File assertions are collected from original active `FileItem` trees and share the checked procedure readiness worklist. Explicit `#run` can wait for forward procedure bodies. Conditions and messages use the typed purity proof and checked VM. Mutable storage cannot supply assertion operands. Unlike a plain `#if`, `#assert` itself requests static evaluation, so checked source calls with immutable arguments use the actual readiness provider; the reference type-restriction examples use this for source predicates. Messages must produce a compile-time string.

False assertions report their source directive and message. A binding or VM failure retains its actual operand or executed source location. Assertions inside inserted record code preserve their original syntax and follow record assertion scheduling.

## How to change it

`jai-syntax/src/statement_conditionals.rs` parses assertion arguments; `StatementKind::CompileTimeAssert` and `FileItem::Assert` retain the source forms. `jai-sema/src/compile_time_conditionals.rs` owns the shared typed evaluator and body selection. `modules/compile_time/file_conditions.rs` schedules active file assertions; preserve original file identity when extending it. Record selectors call the same assertion evaluator after their shape is ready.

Do not lower assertions as runtime branches or evaluate inactive statements. Keep real `#run` dependencies in the readiness worklist and preserve transactional compiler effects across retries.

## Configuration

The compilation's explicit target supplies platform constants. `ResolveOptions.compile_time_limits` bounds assertion runs. Driver `DiscoveryEffectPolicy::Disabled` uses the VM without host effects for checks; native build sessions use the existing compiler session and effect replay policy.

## Dependencies

`jai-syntax` source AST, `jai-modules` selected source dependencies, `jai-sema` lexical and nominal binding, and `jai-vm` checked compile-time execution. Independent fixtures cover active/inactive assertions, generic values, forward runs, optional messages, source locations, and freshly emitted native code.
