# Standard library layout

## What it is

`stdlib/` is the Jai standard library written for this compiler, and `prelude/` holds the runtime type definitions it builds on. Both are ordinary Jai that `jaic` compiles like user code; the only special thing about them is that `stdlib/` is the default module search root.

It is a clean-room implementation. Contributors must not read the source of an official Jai distribution at all: not its modules, its example programs, or its compiler. Work from public documentation, third-party Jai code and this repository's tests. Maintainers also run a [reference resemblance check](../tools/reference-resemblance.md) as a safeguard.

## How it works

`#import "Name"` resolves to `Name/module.jai` or `Name.jai` under `stdlib/` or an `-I` directory. `stdlib/Preload.jai` just `#load`s `prelude/Preload.jai`, which declares the types the compiler itself knows (`Allocator`, `Type_Info`, `Source_Code_Location`, `Temporary_Storage`, the context); see [Preload and Runtime_Support](../metaprogramming/prelude-and-runtime-support.md). `stdlib/Runtime_Support.jai` supplies the entry point and output hooks.

| Family | Modules | Page |
| --- | --- | --- |
| Basic, containers, time | `Basic`, `Hash_Table`, `Bit_Array`, `Bucket_Array`, `Sort`, `IntroSort`, `RadixSort`, `Soa`, `Tagged_Union`, `Treemap`, `Relative_Pointers`, `Machine_X64` | [basic and collections](basic-and-collections.md), [time and platform](basic-time-and-platform.md) |
| Strings and text | `String`, `Unicode`, `Base64`, `Text_File_Handler`, `Print_Color`, `Print_Vars`, `Command_Line` | [strings and text](strings-and-text.md), [Command_Line](command-line.md) |
| Math | `Math`, `Random`, `PCG`, `Sloppy_Math`, `Srgb`, `Float16` | [math and random](math-and-random.md) |
| Memory | `Memory`, `Pool`, `Flat_Pool`, `Default_Allocator`, `Overwriting_Allocator`, `Unmapping_Allocator`, `Deep_Copy`, `Remap_Context`, `Hash`, `Crc`, `xxHash` | [memory and allocators](memory-and-allocators.md) |
| Binary formats | `Adpcm`, `Wav_File`, `Ico_File`, `Zip_File_Directory`, `md5` | [binary formats](binary-formats.md) |
| OS | `File`, `File_Utilities`, `File_Async`, `File_Watcher`, `Process`, `System`, `Clipboard`, `Mail`, `Shared_Memory_Channel` | [files and processes](files-and-processes.md) |
| Concurrency and input | `Thread`, `Atomics`, `Socket`, `Input`, `Keymap`, `Gamepad` | [threads, sockets, input](threads-sockets-input.md) |
| Compiler API | `Compiler`, `Reflection`, `Code_Visit`, `Check`, `Jai_Lexer`, `Program_Print`, metaprogram plugins | [compiler and metaprogramming](compiler-and-metaprogramming.md), [Program_Print](program-print.md) |
| Build tooling | `Debug`, `MacOS_Bundler`, `BuildCpp`, `Autorun`, `Performance_Report`, `Iprof` | [tooling modules](tooling-modules.md), [Iprof](iprof.md) |
| UI and audio | `Simp`, `Window_Creation`, `GetRect`, `GetRect_LeftHanded`, `Sound_Player` | [UI and drawing](ui-and-drawing.md), [GetRect](getrect.md), [Simp](simp.md), [Sound_Player](sound-player.md) |
| Native bindings | `POSIX`, `macos`, `Windows`, `Linux`, `Android`, `Objective_C`, `SDL`, `GL`, `Vulkan`, `ImGui`, `stb_*`, `freetype`, ... | [native bindings](native-bindings.md), [Bindings_Generator](bindings-generator.md) |
| jaic extensions (not official Jai) | `Extensions/Long_Double`, `Extensions/Jai_Format`, `Extensions/WebGPU`, `Extensions/Wasi_Runtime`, imported by that path | [stdlib extensions](extensions.md), [WebGPU](webgpu.md) |

Every module has exactly one implementation. Its public API (exported names, parameter names and order, return order, struct fields and defaults, enum values) matches the official module, because real programs call with named arguments, read fields and print enum values. Extra parameters we add (such as `allocator :=`) go last. `tests/stdlib/named-argument-api.jai` guards a sample. Known differences: `File.handle` is a `*FILE` on macOS and Linux (so `File.{ stdin }` works) and a `HANDLE` on Windows (so `File.{ GetStdHandle(STD_INPUT_HANDLE) }` works), and `Thread.proc` is the native procedure type.

Module parameters select behaviour at import time, for example `#import "Basic"(MEMORY_DEBUGGER=true)`. Each page lists the ones that matter.

## How to change it

- Edit the module and add or extend a regression program in `tests/stdlib/*.jai`. Each must exit 0 under `jaic run`; use runtime `assert`s or compile-time `#assert`. Programs that must fail go in `tests/corpus/negative/` with an entry in `tests/corpus/manifest.json`.
- Some modules keep tests beside the source (`stdlib/Math/tests`, `Random/tests`, `PCG/tests`, `Float16/tests`, `Srgb/tests`, `Sloppy_Math/tests`, `GetRect/tests`), and `stdlib/tests/` holds string, UTF-8, command-line and binary-format programs.
- Run everything with `tools/jaic-sweep.py stdlib modules` ([sweep](../tools/jaic-sweep.md)).
- Declaring an `#intrinsic` the compiler doesn't know implements nothing; new intrinsics need Rust support ([intrinsics](../language/intrinsics.md)).
- To check that a rewrite keeps behaviour, run a probe against both versions: `git archive HEAD stdlib prelude | tar -x -C /some/dir`, then diff `JAIC_STDLIB=/some/dir/stdlib jaic run probe.jai` against plain `jaic run probe.jai`. The prelude must sit beside the stdlib as `../prelude`.

## Configuration

- `-I dir` adds a search root.
- `-os linux|windows|macos` selects the `#if OS == ...` branches, so `jaic check file.jai -os linux` type-checks another OS's bindings from a Mac.
- `JAIC_STDLIB` overrides the stdlib directory.

## Dependencies

The compiler and interpreter (`crates/jaic`), `prelude/`, and system libraries for the native-binding modules (libc, libm, optionally libcurl, SDL2, libclang; see [native bindings](native-bindings.md)).
