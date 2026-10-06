# Developer documentation

Start with [compiler architecture](compiler/architecture.md). Real projects that compile are listed in [upstream corpus](tools/upstream-corpus.md#project-status).

- [License](license.md): AGPL-3.0-or-later with a runtime library exception for compiled programs

## Language

Jai language behavior as implemented by `jaic`.

- [Casts and conversions](language/casts-and-conversions.md)
- [The implicit context](language/context.md)
- [Control flow: loops, cases and defer](language/control-flow.md)
- [Declarations, constants and globals](language/declarations-and-constants.md)
- [Statement directives, flags and notes](language/directives-and-notes.md)
- [Enums](language/enums.md)
- [External data](language/external-data.md)
- [Compiler intrinsics](language/intrinsics.md)
- [Lambdas and anonymous procedures](language/lambdas.md)
- [Macros and custom iteration](language/macros-and-custom-iteration.md)
- [`#must` results and `#discard` parameters](language/must-and-discard.md)
- [Module parameters](language/module-parameters.md)
- [Modules and imports](language/modules-and-imports.md)
- [Arithmetic overflow checks and `#no_aoc`](language/arithmetic-overflow-checks.md)
- [Integers, floats and numeric literals](language/numbers.md)
- [Operator overloading](language/operator-overloading.md)
- [Pointers, arrays and bounds checks](language/pointers-and-arrays.md)
- [Polymorphism and baking](language/polymorphism.md)
- [Procedures and calls](language/procedures.md)
- [Scoping: visibility, using and conditional declarations](language/scoping.md)
- [SIMD and `#asm`](language/simd-asm.md)
- [Strings and literals](language/strings-and-literals.md)
- [Structs and aggregate literals](language/structs.md)
- [Type values, identity and type info](language/type-values-and-info.md)
- [Unions and tagged unions](language/unions.md)
- [using](language/using.md)

## Metaprogramming

Compile-time execution, the `Compiler` module, reflection and code values.

- [Code values and #insert](metaprogramming/code-values-and-insertion.md)
- [Compile-time values, globals and runtime info](metaprogramming/compile-time-data-and-state.md)
- [Compile-time execution (`#run`)](metaprogramming/compile-time-execution.md)
- [Compiler module (Jai side)](metaprogramming/compiler-module.md)
- [Compiler records (messages, syntax trees, type descriptors)](metaprogramming/compiler-records.md)
- [Metaprogram plugins (`-plug`)](metaprogramming/metaprogram-plugins.md)
- [Preload and Runtime_Support bootstrap](metaprogramming/prelude-and-runtime-support.md)
- [Reflection and Type_Info](metaprogramming/reflection-and-type-info.md)
- [Workspaces and metaprograms](metaprogramming/workspaces.md)

## Compiler internals

How `crates/jaic`, the interpreter and the language server work.

- [Compiler architecture](compiler/architecture.md)
- [jaic `#asm` blocks](compiler/asm.md)
- [Threads under `jaic run`](compiler/interpreter-threads.md)
- [jaic interpreter](compiler/interpreter.md)
- [Low-level IR](compiler/ir.md)
- [Shared Jai language server](compiler/language-server.md)
- [Parser](compiler/parser.md)
- [Sema: module loading and top-level expansion](compiler/sema-modules.md)
- [Sema: polymorphism and declarations](compiler/sema-polymorphism-and-declarations.md)
- [Stack traces (`context.stack_trace`)](compiler/stack-traces.md)

## Native builds

The LLVM backend, C ABI and linking.

- [C ABI, callbacks and C++ methods](native/c-abi.md)
- [jaic LLVM backend](native/llvm-backend.md)
- [Native debug information](native/debug-info.md)
- [Native build and linking](native/native-linking.md)
- [Vk-Engine corpus project](native/vk-engine.md)
- [Native Windows executables](native/windows.md)

## Standard library

The independently written `stdlib/`. Before committing any change under `stdlib/`, run `python3 tools/check_reference_resemblance.py` (it needs a local `reference/`; see [reference resemblance check](tools/reference-resemblance.md)) and fix what it flags by rewriting, not by allowlisting.

- [Standard library layout](stdlib/architecture.md)
- [Basic and collection modules](stdlib/basic-and-collections.md)
- [Basic calendar time, working directory and platform exports](stdlib/basic-time-and-platform.md)
- [Binary formats and checksums](stdlib/binary-formats.md)
- [Bindings_Generator](stdlib/bindings-generator.md)
- [Command_Line](stdlib/command-line.md)
- [Compiler API, reflection and metaprogram support](stdlib/compiler-and-metaprogramming.md)
- [Files, processes and OS services](stdlib/files-and-processes.md)
- [GetRect](stdlib/getrect.md)
- [Iprof profiler module](stdlib/iprof.md)
- [Math, random numbers and color/float helpers](stdlib/math-and-random.md)
- [Memory, allocators and hashing](stdlib/memory-and-allocators.md)
- [Native and platform bindings](stdlib/native-bindings.md)
- [Program_Print](stdlib/program-print.md)
- [Strings, Unicode and text files](stdlib/strings-and-text.md)
- [Threads, atomics, sockets and input](stdlib/threads-sockets-input.md)
- [Toolchains: macOS SDK and Android NDK helpers](stdlib/toolchains.md)
- [Tooling modules: Debug, MacOS_Bundler, BuildCpp, Autorun, Performance_Report](stdlib/tooling-modules.md)
- [Drawing, windows and audio](stdlib/ui-and-drawing.md)
- [Simp (2D renderer)](stdlib/simp.md)
- [Sound_Player (audio mixing and output)](stdlib/sound-player.md)

## Browser

The WebAssembly compiler bundle and its releases. The hosted playground UI lives in the portfolio site (https://matteopolak.com/playground/jai).

- [Browser compiler (WebAssembly bundle)](browser/playground.md)
- [Browser compiler releases](browser/compiler-releases.md)

## Tools and workflow

Scripts, CI and project policies.

- [Benchmarks and profiling](tools/benchmarks.md)
- [Build storage and target directories](tools/build-storage.md)
- [Code formatting](tools/code-formatting.md): rustfmt and jaifmt checks, format-only commits and `.git-blame-ignore-revs`
- [Continuous integration](tools/continuous-integration.md)
- [Dependency policy](tools/dependency-policy.md)
- [jaic regression sweep](tools/jaic-sweep.md)
- [jaifmt (Jai formatter)](tools/jaifmt.md)
- [LLVM setup](tools/llvm-setup.md)
- [Third-party native libraries](tools/native-libs.md)
- [open-jai expectation harness](tools/openjai-expectations.md)
- [Reference resemblance check](tools/reference-resemblance.md)
- [Releases](tools/releases.md)
- [Upstream corpus](tools/upstream-corpus.md)
