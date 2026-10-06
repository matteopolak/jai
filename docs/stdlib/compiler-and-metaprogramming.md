# Compiler API, reflection and metaprogram support

## What it is

The library side of metaprogramming: `Compiler` (workspaces, build options, compiler messages, code nodes), `Reflection` (runtime operations on `Type_Info`), `Code_Visit` (syntax-tree traversal), `Check` (a message-driven lint plugin), `Jai_Lexer`, the metaprogram helpers (`Default_Metaprogram`, `Minimal_Metaprogram`, `Metaprogram_Plugins`, `Example_Plugin`), `Print_Vars`/`Program_Print` (see [program-print](program-print.md)), and `Runtime_Support` (entry point and output hooks).

## How it works

`Compiler` is thin Jai over `__jaic_*` primitives implemented in `crates/jaic/src/build.rs`. It is documented in [Compiler module](../metaprogramming/compiler-module.md), [workspaces](../metaprogramming/workspaces.md) and [compiler records](../metaprogramming/compiler-records.md).

`Reflection.jai` works on the `Type_Info` layout: `get_array_count_and_data`, `get_struct_field_info`, `enum_value_to_name`/`enum_name_to_value`, `get_enum_value`/`set_enum_value`, `set_value_from_string`, `get_values`. `is_subclass_of` follows `#as` first members by value or through one pointer; a type is not its own subclass.

`Code_Visit` offers `visit_pre_and_postorder` and breadth- or depth-first node collection. `visit_pre_and_postorder` builds its whole enter/leave schedule first (iteratively, with an explicit stack) and then runs the inserted code with `it` and `preorder` declared in the caller's scope, so call it at most once per block. `get_subexpressions` switches on `kind` and adds each node's direct syntactic children (operands, arguments, statements, declaration names and values). It never follows resolved links (`resolved_declaration`, parent blocks), so walks terminate; a kind it doesn't list has no children.

`Jai_Lexer` lexes Jai (`set_input_from_string`/`set_input_from_file`, `peek_next_token`, `eat_token`). Tokens live in a small lookahead ring: `get_unused_token` claims the slot after the pending lookahead and stamps the current line and column. `:=` lexes as two tokens.

`Check` is a metaprogram plugin: it inspects `TYPECHECKED` messages and reports print-like format string mismatches (`check_print_calls`) and, with `CHECK_BINDINGS`, C-porting problems. `jaic check|build file.jai -plug Name` runs plugins through `build_with_plugins` in `Metaprogram_Plugins.jai` (see [metaprogram plugins](../metaprogramming/metaprogram-plugins.md)); `init_plugins`, which picks plugins from inside a running metaprogram, still reports an error. `Default_Metaprogram` and `Minimal_Metaprogram` build workspaces against the Compiler options API.

```jai
#import "Basic";
#import "Compiler";

build :: () {
    w := compiler_create_workspace("child");
    options := get_build_options();
    options.output_type = .EXECUTABLE;
    options.output_executable_name = "probe";
    set_build_options(options, w);
    add_build_string("main :: () { }", w);
}

#run build();
```

## How to change it

- A new compiler-facing capability needs a `__jaic_*` primitive in `crates/jaic` plus a wrapper here; declaring the primitive in Jai alone does nothing.
- Keep `Code_Node` field layouts in sync with the exporter in `crates/jaic/src/sema/code_export.rs`; `Program_Print` and `Code_Visit` read those fields.
- Tests: `tests/stdlib/compiler-api-shapes.jai`, `compiler-helper-behavior.jai`, `core-small-helpers.jai`, `compiler-get-code.jai`, `code-visit.jai`, `compiler-typechecked-messages.jai`, `compiler-workspace-ids.jai`, `compiler-reflection-pure.jai`, `compiler-enum-external-type.jai`, `autorun-plugin.jai`, `performance-report-plugin.jai`, `runtime-support-source.jai`, `runtime-support-output.jai`.

## Configuration

`Check(CHECK_BINDINGS=true)`. `Runtime_Support` takes `DEFINE_SYSTEM_ENTRY_POINT`, `DEFINE_INITIALIZATION`, `ENABLE_BACKTRACE_ON_CRASH` and `TEMPORARY_STORAGE_SIZE` (default 32768). The `jaic` command line passes metaprogram arguments after a lone `-`.

## Dependencies

`Basic`, `String`, `Hash_Table`, `Sort`; the `__jaic_*` primitives from `crates/jaic`; `prelude/reflection.jai` for the `Type_Info` types.
