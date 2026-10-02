# File conditional bodies

File-level `#if` accepts either a braced item list or one declaration or
directive. This permits unchanged standard-library forms such as
`#if VISUALIZE_MEMORY_DEBUGGER #load "Visualize_Memory_Debugger.jai";`.

## How it works

Both forms use the existing file-item parser and retain `FileItem::Conditional`.
An unbraced body stops after exactly one complete item, including that item's
terminator. It preserves source spans, visibility and import/load metadata.
An `else` belongs to the nearest conditional; an `else #if` remains an ordinary
nested conditional. This parser change does not select branches or load source.
The module graph and semantic conditional scheduler retain those responsibilities.

## How to change it

`jai-syntax/src/file_conditional_bodies.rs` owns body selection and the nesting
budget. `modules.rs::file_item_list_with_limit` uses the existing declaration and
directive dispatch with a typed single-item limit. Add new file item kinds to
that common dispatch so braced and unbraced forms stay consistent. Preserve
terminators and original spans; consuming the next declaration changes scopes
and dependencies.

The focused parser tests cover load spans, import and declaration branches,
visibility, dangling `else`, malformed bodies and nesting on a two MiB stack.
Graph fixtures also verify that only the selected load/import becomes a source
dependency and that a following declaration remains outside the branch.
This supports Basic's original line-48 unbraced load. Full Basic also depends
on procedure policies, discarded macro arguments, native instruction syntax,
and the ordinary runtime/allocator/formatting bodies; these isolated tests do
not establish full module acceptance.

## Configuration

File conditionals have a fixed maximum nesting depth of 64, shared by braced
and unbraced forms. The counter is restored after success or failure and resets
between sibling conditionals. There are no environment variables.

## Dependencies

The existing lexer, file-item AST, source map and symbol interner. Conditional
evaluation and dependency selection rely on `jai-modules` and `jai-sema`.
Supplied source is read as data; no original compiler or native library is run.
