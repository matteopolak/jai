# Insertion loop control

## What it is

Statement `#insert` can replace the inserted caller's `break`, `continue`, and `remove` with source retained at the insertion directive. This supports sparse containers and loops whose public iterator spans several physical loops.

## How it works

The parser keeps each modifier's typed jump kind, original body, and source range. Replacement source is captured in the macro's lexical environment before the caller quotation is installed. It is checked only when an applicable caller jump appears; an unused `remove=#assert(false)` does not reject an otherwise valid loop.

```jai
#insert(remove={entry.hash=REMOVED_HASH; map.count-=1;},
        break=break row) body;
```

This syntax appears in the unchanged supplied `Hash_Table`, `Bit_Array`, and `Bucket_Array` modules, Focus's `src/utils/array.jai` and `ring_buffer.jai`, and Vk-Engine's `Modules/Hash_Map.jai`. The replacement can be a source block, a direct jump such as `break row`, a statement expression, or a compile-time assertion.

A bare jump belongs to the insertion's caller loop only when caller code has not introduced another loop. A named jump must address the actual exported iterator alias; an intervening same-named loop shadows that alias. Nested caller loops retain their own builtin removal and exits. Replacement source resolves against the directive's physical loop prefix, so a caller loop named `row` cannot capture a replacement's `break row`.

Replacement blocks read macro storage and types while the inserted caller body reads caller storage and exported bindings. Transfers run the crossed caller and macro cleanup scopes through the existing checked exit representation. Deferred bodies cannot replace an enclosing loop-control statement. Replacement assertions and invalid source bodies retain the definition's source location; an invalid caller target retains the caller's jump range.

An expansion can also export a bound while condition, as in `while \`table_while_loop := remaining { #insert body; }`. The condition keeps its checked integer or boolean storage and its original physical loop identity. Inserted caller code can read that binding and use `break table_while_loop` or `continue table_while_loop`; crossed cleanup still follows the normal exit path. The marked name is rejected outside an active expansion invocation. The syntax stores the backtick and name range separately from the initializer, so this error points to the export itself.

## How to change it

`jai-syntax/src/insert_replacements.rs` owns modifier parsing and retained source bodies. `jai-sema/src/metaprogram/loop_replacements.rs` captures those bodies, matches the active typed export alias and loop depth, and restores source, checks, lexical frames, and insertion guards after checking. `insert_statement` brackets the replacement frame; `loops.rs` asks this layer before resolving ordinary builtin exits or removal.

Keep replacement bodies lazy and preserve the procedure and loop identity checks. Rewriting all jumps recursively would incorrectly capture exits in nested caller loops or independently checked procedures. Preserve cleanup stacks while switching lexical bindings, and disable replacement matching while checking replacement source to avoid recursively replacing its own jump.

`WhileCondition::Binding.export_span` retains the optional caller export marker. `resolve_while` exports the actual checked binding before checking its body; it does not construct another loop or copy its condition value into a synthetic binding. Keep this distinction when adding binding forms or adapting source preview consumers.

Expression, lvalue, and record insertion reject loop-control modifiers explicitly. File insertion follows its existing declaration-scheduler boundary. The syntax tests parse unchanged collection files without editing their bytes; runtime tests exercise independently authored sparse-map, forward-removal, outer-break, cleanup, and shadowing cases with both the Rust VM and generated native programs. Full library checking and generic specialization acceptance are separate from those tests.

The replacement suite currently passes 13 tests, including ten valid VM/native fixtures. [Collection iteration source acceptance](collection-iteration-source-acceptance.md) records the exact complete source files and dependency failures separately.

## Configuration

No new compiler flags. Source import directories, the shared Code insertion cycle/depth limit, procedure safety checks, and typed compile-time assertion policy continue to apply.

## Dependencies

`jai-syntax` retains source modifiers. The `jai-sema` Code registry provides capture identity and export remapping; lexical declarations and source debugging retain the original definition environment. Existing `jai-ir` blocks, stores, cleanup IDs, and exits execute through the Rust VM and LLVM backend. No collection function is implemented by its spelling.
