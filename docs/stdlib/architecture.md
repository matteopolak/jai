# Standard library layout

## What it is

`stdlib/` is the Jai standard library written for this compiler, and `prelude/` holds the runtime type definitions it builds on. Both are ordinary Jai source that `jaic` compiles like user code; the only special case is the default module search root.

## How it works

`jaic` resolves `#import "Name"` against `stdlib/` (a directory `Name/module.jai` or a file `Name.jai`) plus any `-I dir` given on the command line. `stdlib/Preload.jai` is a one-line `#load` of `prelude/Preload.jai`, which loads `prelude/{intrinsics,platform,context,reflection,diagnostics,runtime-storage}.jai`. Those files declare the types the compiler itself knows (`Allocator`, `Type_Info`, `Source_Code_Location`, `Temporary_Storage`, the context). `stdlib/Runtime_Support.jai` supplies the entry point and output hooks.

Modules fall into families, each with a page here:

| Family | Modules | Page |
| --- | --- | --- |
| Basic, containers, time | `Basic`, `Hash_Table`, `Bit_Array`, `Bucket_Array`, `Sort`, `IntroSort`, `RadixSort`, `Soa`, `Tagged_Union`, `Treemap`, `Relative_Pointers`, `Machine_X64` | [basic-and-collections](basic-and-collections.md), [basic-time-and-platform](basic-time-and-platform.md) |
| Strings and text | `String`, `Unicode`, `Base64`, `Text_File_Handler`, `Print_Color`, `Print_Vars`, `Command_Line` | [strings-and-text](strings-and-text.md), [command-line](command-line.md) |
| Math | `Math`, `Random`, `PCG`, `Sloppy_Math`, `Srgb`, `Float16` | [math-and-random](math-and-random.md) |
| Memory | `Memory`, `Pool`, `Flat_Pool`, `Default_Allocator`, `Overwriting_Allocator`, `Unmapping_Allocator`, `Deep_Copy`, `Remap_Context`, `Hash`, `Crc`, `xxHash` | [memory-and-allocators](memory-and-allocators.md) |
| Binary formats | `Adpcm`, `Wav_File`, `Ico_File`, `Zip_File_Directory`, `md5` | [binary-formats](binary-formats.md) |
| OS | `File`, `File_Utilities`, `File_Async`, `File_Watcher`, `Process`, `System`, `Clipboard`, `Mail`, `Shared_Memory_Channel` | [files-and-processes](files-and-processes.md) |
| Concurrency and input | `Thread`, `Atomics`, `Socket`, `Input`, `Keymap`, `Gamepad` | [threads-sockets-input](threads-sockets-input.md) |
| Compiler API | `Compiler`, `Reflection`, `Code_Visit`, `Check`, `Jai_Lexer`, `Program_Print`, metaprogram plugins | [compiler-and-metaprogramming](compiler-and-metaprogramming.md), [program-print](program-print.md) |
| Build tooling | `Debug`, `MacOS_Bundler`, `BuildCpp`, `Autorun`, `Performance_Report`, `Iprof` | [tooling-modules](tooling-modules.md), [iprof](iprof.md) |
| UI | `Simp`, `Window_Creation`, `GetRect`, `GetRect_LeftHanded` | [ui-and-drawing](ui-and-drawing.md), [getrect](getrect.md) |
| Native bindings | `POSIX`, `macos`, `Windows`, `Linux`, `Android`, `Objective_C`, `SDL`, `GL`, `Vulkan`, `ImGui`, `stb_*`, `freetype`, ... | [native-bindings](native-bindings.md), [bindings-generator](bindings-generator.md) |

There is no `legacy/` folder: every module has exactly one implementation under `stdlib/`, shaped like the corresponding module in the reference distribution (field order, procedure names and return order are API). Where a program needs stable addresses (`Treemap`, `Keymap`) it imports `Bucket_Array`.

Module parameters (`#module_parameters`) select behavior at import time, for example `#import "Basic"(MEMORY_DEBUGGER=true)`. Each page lists the parameters that matter.

## How to change it

- Edit the module under `stdlib/` and add or extend a regression program in `tests/stdlib/*.jai`. Each must exit 0 under `jaic run`; assertions are runtime `assert`s or compile-time `#assert #run`. The one intentional failure is `getrect-rh-negative-control.jai`.
- Some modules carry tests next to the source (`stdlib/Math/tests`, `Random/tests`, `PCG/tests`, `Float16/tests`, `Srgb/tests`, `Sloppy_Math/tests`, `GetRect/tests`) and `stdlib/tests/` holds string, UTF-8, command-line and binary-format programs.
- Run the whole set with `python3 tools/jaic-sweep.py stdlib` (documented in `../tools/jaic-sweep.md`).
- A declaration only gets compiler support if `jaic` recognizes it. New intrinsics need a Rust side in `crates/jaic` (see [compiler architecture](../compiler/architecture.md)); declaring an unknown intrinsic in Jai implements nothing.
- Public record fields, parameter defaults and enum values are API: programs print and index them directly. Keep them stable when rewriting internals.
- `reference/` is the reference distribution, for reading semantics only. Never run its binaries and never copy its text into `stdlib/`.

## Configuration

None at the library level. Compiler flags that affect module lookup: `-I dir` adds a search root, and `-os linux|windows|macos` selects the `#if OS == ...` branches, so `jaic check file.jai -os linux` type-checks another OS's bindings from a Mac.

## Dependencies

The `jaic` compiler and interpreter (`crates/jaic`), the `prelude/` types, and system libraries for the native-binding modules (libc, libm, and optionally libcurl, SDL2, libclang; see [native-bindings](native-bindings.md)).

## Parameter names follow the reference modules

Real Jai programs call procedures with named arguments, so exported parameter names, order and return values match the reference modules (`slerp(start, end, t)`, `print(format_string)`, `array_add(array, item)`, `array_insert_at(array, item, index)`, `string_to_float(arg)`, `floor(f)`/`tan(theta)` for `float`, `x` for `float64`, `pow(x, power)` for `float`, `pow(x, y)` for `float64`, `to_float64_seconds(input) -> result, success`, `mail_send(smtp, msg)`, `XXH32_update(state, input: *void, len)`). Extra parameters we add (such as `allocator :=`) go last. Where the body used the old name, the new parameter is aliased in the first line. `tests/stdlib/named-argument-api.jai` guards a sample. Known remaining differences: `File.handle` is `s64`, `Thread.proc` is the native proc type.
