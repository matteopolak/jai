# Context lifetime and macro cleanup

Caller-scoped backtick push_context,defer_pop retains its pushed context until
the caller's lexical block exits. Macro-local pushes end with the expansion.
Restoration shares the deferred-action stack, so later defers observe the pushed
context and earlier defers observe the restored context. Return, break and
continue use that same cleanup path. Explicit push_context blocks also restore
before outer exit cleanup.

Cleanup boundaries are stable handles. Inserting a caller-owned action moves
the live nested boundaries while retaining the caller's boundary. Raw vector
indices cannot represent this when an expansion registers cleanup inside a
nested block.

Context selection uses procedure-local runtime storage. A conditional macro
push selects the pointer only when executed, and its caller-owned cleanup has
a runtime registration guard. Saved pointer storage dominates the join, avoiding
branch-local SSA references in exit cleanup. Caller-owned ordinary defers use
the same registration mechanism. These local slots add interpreter instructions;
native optimization can promote/eliminate them where control flow permits.

The core cleanroom_context suite contains eight original regressions. The LLVM
suite executes conditional and nested macro cleanup, loop exits and explicit
context-block returns natively and on WASM64 at O0 and O2. This is focused
compiler verification, not integrated production library/corpus verification.
