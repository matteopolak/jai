# Program_Print

## What it is

`stdlib/Program_Print/module.jai` prints `Code_Node` syntax trees back to Jai source text. `Compiler.code_to_string(code)` and `Compiler.print_expression` are thin wrappers over it (they `#import "Program_Print"` inside the procedure body to avoid a module cycle).

## How it works

Public API: `print_expression(builder, node, skip_parens := false) -> bool`, `print_declaration(builder, decl, ...) -> bool`, `print_string_literal(builder, s)`, `print_procedure_bodies`. The bool result is false when something printed as `<unsupported node>`.

The printer dispatches on `Code_Node.kind` (`pp_expression`) and walks the node structs that jaic's exporter fills in (`crates/jaic/src/sema/code_export.rs`):

- binary operators print with spaces (`x + y`), `.` and `[]` without; parentheses are re-derived from a precedence table (`pp_precedence`) because the exporter does not keep `IS_PARENTHESIZED`. The table is Jai's, not C's (bitwise and shift operators on one level above `*`, `%` between `*` and `+`; see [operators](../language/operators.md)), so `(a + b) & c` keeps its parentheses and `a * (b & c)` prints as `a * b & c`. A cast that is the operand of a bitwise operator or of a postfix one prints in parentheses (`(cast(u32) b) << 4`), because a prefix cast takes a following bitwise chain into its value. If the parser's table changes, change `pp_precedence` and `PP_CAST_LEVEL` with it.
- declarations print as `a := v`, `a : T = v`, `a :: v`, `a : T : v`; compound ones as `a, b := f()` (`a=, b := f()` when one target is assigned), from the names list and the nameless `declaration_properties`.
- blocks are multi-line, four-space indented; `;` follows every statement except those ending in `}`.
- `compiler_get_nodes(#code a := 1;)` returns the bare declaration as the root (brace-less single statement); `#code { ... }` returns a `Code_Block` and prints with braces.

- Backticked identifiers and declarations (`HAS_SCOPE_MODIFIER`) print with their backtick: `` `x + y ``, `` `z := 1; ``.
- `Code_Directive_Run` prints `#assert(cond, "msg")` when its flags say assert, else `#run expr`; `Code_Directive_Exists` prints `#exists(q)`. Compound declarations print as `a, b := f();`.

Unsupported or lossy: enum bodies (`enum {}`), array/proc type expressions without a resolved type (`<type>`), `#run` bodies (only the expression form), number base (hex/binary print in decimal), comments and original layout, assembly.

## How to change it

Add a `case` to `pp_expression` for a new kind, reading only fields the exporter populates. If a field is missing, add it in `code_export.rs` first. `pp_ends_with_brace` decides whether a statement gets `;`. Tests: `tests/stdlib/program-print-expressions.jai` (exact strings).

## Configuration

`print_procedure_bodies` (default true): when false, procedure literals print `{ ... }`.

## Dependencies

`Basic` (`String_Builder`, `print_type_to_builder`) and `Compiler` (node structs, `operator_to_string`).
