# Compiler API, reflection and metaprogram support

## What it is

The library side of metaprogramming: `Compiler` (workspaces, build options, compiler messages, code nodes), `Reflection` (runtime operations on `Type_Info`), `Code_Visit` (syntax-tree traversal), `Check` (a message-driven lint plugin), `Jai_Lexer`, the metaprogram helpers (`Default_Metaprogram`, `Minimal_Metaprogram`, `Metaprogram_Plugins`, `Example_Plugin`), `Print_Vars`/`Program_Print` (see [program-print](program-print.md)), and `Runtime_Support` (entry point and output hooks).

## How it works

`stdlib/Compiler/module.jai` is thin Jai over `__jaic_*` primitives that the Rust side implements (`crates/jaic/src/build.rs`): `compiler_create_workspace`, `get_build_options`/`set_build_options`, `add_build_file`/`add_build_string`, `compiler_begin_intercept`/`compiler_wait_for_message`/`compiler_end_intercept`, `compiler_get_nodes`, `compiler_get_code`, `compiler_report`, `get_type_table`, `compiler_get_version_info`. `nodes.jai` holds the `Code_Node` family, `options.jai` `Build_Options`, `records.jai` the message records, `workspace.jai` the workspace operations. The semantics are described in `../metaprogramming/compiler-module.md`, `../metaprogramming/workspaces.md` and `../metaprogramming/compiler-records.md`.

`Reflection.jai` works on the compiler-owned `Type_Info` layout: `get_array_count_and_data`, `get_struct_field_info`, `enum_value_to_name`/`enum_name_to_value`, `get_enum_value`/`set_enum_value`, `set_value_from_string`, `get_values`. `Code_Visit` offers `visit_pre_and_postorder` and breadth/depth-first node collection over `Code_Node`s. `Jai_Lexer` is a scalar Jai lexer (`set_input_from_string`/`set_input_from_file`, `peek_next_token`, `eat_token`).

`Check` is a metaprogram plugin: it inspects `TYPECHECKED` messages and reports print-like format string mismatches (`check_print_calls`) and, with `CHECK_BINDINGS`, C-porting problems. `Metaprogram_Plugins.jai` parses `-plug Name` arguments (`parse_plugin_arguments`), but `jaic` cannot instantiate plugins yet, so metaprograms that ask for none work unchanged and the plugin modules (`Check`, `Autorun`, `Performance_Report`, `Example_Plugin`) can only be driven by hand. `Default_Metaprogram` and `Minimal_Metaprogram` build workspaces against the Compiler options API.

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
- Tests: `tests/stdlib/compiler-api-shapes.jai`, `compiler-get-code.jai`, `compiler-typechecked-messages.jai`, `compiler-workspace-ids.jai`, `compiler-reflection-pure.jai`, `compiler-enum-external-type.jai`, `autorun-plugin.jai`, `performance-report-plugin.jai`, `runtime-support-source.jai`, `runtime-support-output.jai`.
- `stdlib/legacy/{Compiler,Check,Code_Visit}` are the older shapes; new code uses the unprefixed modules.

## Configuration

`Check(CHECK_BINDINGS=true)`. `Runtime_Support` takes `DEFINE_SYSTEM_ENTRY_POINT`, `DEFINE_INITIALIZATION`, `ENABLE_BACKTRACE_ON_CRASH` and `TEMPORARY_STORAGE_SIZE` (default 32768). The `jaic` command line passes metaprogram arguments after a lone `-`.

## Dependencies

`Basic`, `String`, `Hash_Table`, `Sort`; the `__jaic_*` primitives from `crates/jaic`; `prelude/reflection.jai` for the `Type_Info` types.
