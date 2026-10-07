# Stdlib extensions (`stdlib/Extensions/`)

## What it is

`stdlib/Extensions/` holds the modules only jaic has. Everything else in `stdlib/` is a clean-room version of a module the official Jai distribution ships; these are not, no other Jai compiler knows them, and they may change between jaic releases.

A program imports them by path, so the import itself says the code is jaic-only:

```jai
#import "Extensions/Long_Double";
#import "Extensions/WebGPU";
```

| Module | Import | What it is for | Docs |
| --- | --- | --- | --- |
| `Long_Double` | `#import "Extensions/Long_Double";` | C's `long double` in the target's format (`Long_Double`, `LONG_DOUBLE_IS_WIDE`), for calling C functions that take or return one. `Bindings_Generator` output imports it when it uses the type. | [Long_Double](../language/long-double.md) |
| `Jai_Format` | `#import "Extensions/Jai_Format";` | The Jai source formatter behind `jaifmt` and the playground's Format button: text in, text out. | [jaifmt](../tools/jaifmt.md) |
| `WebGPU` | `#import "Extensions/WebGPU";` | The standard WebGPU C API (`webgpu.h`), generated from `webgpu.yml`: wgpu-native natively, the page's WebGPU in the playground. | [WebGPU](webgpu.md) |
| `Wasi_Runtime` | `#import "Extensions/Wasi_Runtime";` | The C library entry points and `_start` a wasm64 program needs to run as a WASI command. jaic adds it to `-os wasm` builds itself; a program rarely imports it. | [wasm target](../native/wasm-target.md) |

## How it works

`stdlib/Extensions/` is not a module search directory. `#import "Extensions/Long_Double"` is an ordinary module name containing a `/`: `find_module_in` (`crates/jaic/src/sema/modules.rs`) joins it onto each search directory like any other name, so it resolves to `stdlib/Extensions/Long_Double/module.jai`. Nothing special happens for the folder, and the same path form works for a user's own `modules/Folder/Name`.

Because `Extensions/` is not searched, `#import "Long_Double";` is an unknown module. `Compiler::with_extension_help` turns that error into a fix naming the right import (and for the folder alone, or for the old `Jaic_Extensions`, a pointer to the modules):

```
error: module `Long_Double` not found
help: `Long_Double` is a jaic extension (not official Jai), imported by its path: `#import "Extensions/Long_Double";`
```

An unknown identifier that an extension module declares gets the same import as its help and as jailsp's "Add `#import`" quick fix (`imports_declaring` in `sema/suggestions.rs`, which lists `stdlib/Extensions/*` as `Extensions/Name` after the official modules). In `#import "` completion, jailsp shows `Extensions` as a folder of "jaic extension modules" and the modules inside it as "jaic extension module".

The folder is part of `stdlib/`, so everything that copies or embeds the stdlib carries it: release archives (`cp -R stdlib`), the browser engine's bundled files (`crates/jai-wasm/build.rs`) and `JAIC_STDLIB` overrides.

## How to change it

- New extension module: add `stdlib/Extensions/<Name>/module.jai` (one feature per module, named after it, starting with a comment that says it is a jaic extension), add a row to the table above, and document it. Nothing in the compiler lists the modules: the help, quick fix and completion find it by listing the folder.
- A compiler-backed type (like `Long_Double`): add a name to `jaic_type` in `sema/expr.rs` and export it from the module as `Name :: #jaic_type name;`.
- Never put a module here whose name the official distribution uses: those belong in `stdlib/` itself, under the official name.
- Tests that enumerate modules include the folder: `crates/jaic-cli/tests/stdlib_targets.rs` checks each as `Extensions/<Name>` (keys in `tests/stdlib-targets.txt`), `tools/stdlib_coverage.py` keys them the same way in `tests/stdlib-coverage.txt`, and `tools/stdlib_runtime.py`, `tools/jaic-sweep.py` and `tools/jaic-diff.py` run `stdlib/Extensions/*/tests/*.jai` (test ids `Extensions/<Name>/tests/<file>`).

## Configuration

- `jaic::STDLIB_EXTENSIONS_DIR` (`crates/jaic/src/lib.rs`): the folder name, `Extensions`.
- `jaic::build::WASI_RUNTIME_IMPORT`: the import jaic adds for WASI targets.

## Dependencies

- `crates/jaic/src/sema/modules.rs` (resolution and the missing-module help), `crates/jaic/src/sema/suggestions.rs` (import suggestions), `crates/jai-language-server/src/session.rs` (completion).
