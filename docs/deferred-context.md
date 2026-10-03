# Deferred context pushes

## What it is

`push_context,defer_pop;` establishes a context for the remainder of its enclosing lexical block. An explicit value may precede the semicolon; the old context resumes when that block exits, after cleanups registered under the pushed context.

The parser dispatches the comma modifier into its checked helper, and semantic block lowering activates the prepared lexical suffix. CI on `a4232c6` failed all five native witnesses during source parsing because these helpers were not registered; it never reached the VM or LLVM. The recovery preserves those witnesses unchanged. Post-repair VM/native acceptance remains pending the integration gate.

## How it works

The source AST keeps the semicolon push as a separate statement, preserving the actual containing block and following declarations. Semantic lowering prepares that original declaration list once, then lowers its suffix into the existing context-push IR. The suffix shares its source lexical scope; it receives a nested cleanup scope whose active context is the real pushed context. Repeating the modifier nests those lifetimes.

Existing context IR captures the value before changing the active context and keeps a private record copy. Bare pushes use schema defaults. Cleanups retain the context in which each was registered, so an earlier defer reads the restored outer record and a later defer reads the pushed record. Return values are captured before cleanup; break and continue execute the applicable cleanups before restoring context. An already captured pointer into the outer record retains that original allocation.

## How to change it

Change `jai-syntax::deferred_context` and the statement parser dispatch for the source modifier, and `jai-sema::deferred_context` plus `Resolver::block_with_preparation` for its lifetime. Keep the compiler quotation budget visitor charging the optional source value; following statements remain in the enclosing source list. A deferred push outside an enclosing statement sequence is rejected explicitly. Do not rewrite this form as assignments to individual context fields or rediscover the suffix in a new lexical declaration scope; either changes aliasing or forward declaration behavior.

`crates/jai-codegen/tests/deferred_context.rs` checks authored sources through the VM and freshly generated native executables at O0/O2. It covers cleanup ordering, same-block forward aliases, captured outer pointers, loop transfers and nested record copies. Complete Vk-Engine source checking remains a separate gate. Pointer-valued context inputs and caller-exported deferred pushes require their own checked contracts.

## Configuration

The context schema comes from `#add_context` and `#Context`. The modifier accepts only the literal `defer_pop`. Native source tests use the installed trusted Clang selected through the existing test helper, with five-second execution deadlines and temporary owned files.

## Dependencies

The source parser, lexical declaration preparation, [implicit context](implicit-context.md), [deferred cleanup](deferred-cleanup.md), checked VM, LLVM context lowering, and installed Clang. No original executable or supplied native library is used.
