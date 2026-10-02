# Native targets, optimization and linking

## What it is

The LLVM backend selects an explicit target machine, derives type layout from its target data, optimizes verified modules, and emits real native object files. The CLI links host objects with an independently installed Clang. Its artifact commands schedule source compiler recipes and child workspaces as described in [CLI workspace artifacts](workspace-artifacts.md).

## How it works

`target::TargetOptions` separates target triple, CPU, signed feature switches and optimization. Defaults select the host triple, generic CPU and O0. `build_target()` exposes typed source OS/architecture tags and target-derived pointer policy and byte order; unsupported source tags remain explicit. Target initialization is process-wide; target data belongs to the selected machine. The CLI selects the target before loading/resolving the program and supplies `NativeTarget::layout_policy()` to semantic resolution, so `size_of`, alignment and aggregate layout agree with code generation.

`lower_for_target` sets module triple and data layout before lowering. C calls request a separate ABI classifier; Apple ARM64, Linux/Android ARM64 AAPCS64, macOS/Linux x86-64 System V, Windows x64/ARM64 and canonical wasm32/wasm64 C ABIs are implemented. Other C ABIs return an explicit error. Internal code and object emission can use other LLVM targets without claiming foreign ABI or executable support. [Cross-target acceptance](cross-target-acceptance.md) checks actual object formats for Windows, WebAssembly, Android and iOS in addition to the four desktop targets.

`Optimization` maps shared `jai-types` enums into LLVM's `default<O0>` through `default<O3>`, `default<Os>` and `default<Oz>` pass pipelines. Machine optimization can be selected separately; its unset state follows the bitcode level. Modules are verified before and after passes. Object emission rejects an existing module triple or data layout that differs from the selected target, preventing accidental relabeling of previously lowered storage.

`build` emits an object in a private temporary directory and passes it to Clang. LLVM IR serialization is available for diagnostics through `emit-llvm`. Linux linking always adds `-lm`, because LLVM float remainder can become a system `fmod` call. macOS linking selects `-no_fixup_chains` so legal packed global pointers can retain unaligned relocations; [Apple's linker implementation](https://github.com/apple-oss-distributions/ld64/blob/main/src/ld/Options.cpp) supports this policy. Darwin host links use `-Wl,-no_fixup_chains`, because packed records can contain unaligned pointer relocations that chained fixups cannot represent; ordinary relocations retain position-independent executable behavior. Foreign library identifiers resolve through module or lexical declaration scope to checked metadata. The linker uses the actual system basename, normalizes `libc` to `-lc`, and uses exact versioned basenames on Linux. Dependencies referenced by native-reachable foreign procedures and `link_always` declarations are linked once per declaration identity; unused prototypes do not require their native libraries. Installed macOS frameworks use `-framework`. Ordinary source-declared local native paths fail explicitly; the separately configured [reviewed VMA gate](reviewed-native-linking.md) validates the exact declared library identity and links only a fresh source-built snapshot. Persisted receipts and existing archive paths cannot supply native link authority. Independently written fixture tests may also compile and link their own new objects. See [foreign libraries](foreign-libraries.md) for declaration options and provenance boundaries. Host linking rejects a cross-target triple; `emit-object` remains available for those targets.

## How to change it

Extend typed options in `jai-types/src/build.rs` and map them in `jai-codegen/src/optimization.rs`. Add new target policies in `target.rs`; use target data rather than Rust sizes. Extend C classification separately in `abi.rs` and exercise it with independently written C fixtures.

Keep the Clang path canonicalization and reference-directory exclusion in the CLI. Never execute or link the supplied reference compiler, tools, objects or native libraries. Add target-aware linker behavior to `jai-cli/src/backend.rs`; do not send hand-written textual LLVM IR to subprocesses.

## Configuration

```
jai-rs build main.jai program -O2 --cpu native
jai-rs emit-llvm main.jai program.ll -Oz
jai-rs emit-object main.jai program.o --target x86_64-unknown-linux-gnu -O1
```

`JAI_RS_TARGET`, `JAI_RS_CPU`, `JAI_RS_FEATURES` and `JAI_RS_OPT` provide defaults, overridden by CLI flags. `-g` enables [source locations and supported variable descriptions](native-debug-information.md); `-gline-tables-only` emits statement locations, and `-g0` disables debug metadata. Features use comma-separated `+feature,-feature` syntax. CPU and feature wrappers validate syntax before passing data to LLVM; LLVM determines target-specific support. `native` CPU is restricted to the host triple. `JAI_RS_CLANG` chooses the installed linker driver; `PATH` locates it when unset. LLVM setup uses `LLVM_SYS_221_PREFIX` during Rust compilation.

Library output kinds and atomic per-file publication are described in [CLI workspace artifacts](workspace-artifacts.md). `JAI_RS_AR` selects the installed archiver for source `STATIC_LIBRARY` output; its default is `llvm-ar` from `LLVM_SYS_221_PREFIX` or `PATH`. Dynamic library packaging uses the same installed Clang guard as executables.

## Dependencies

LLVM 22.1 through Inkwell, the shared checked IR and type registry, compiler-driver source resolution, and an independently installed Clang plus host system libraries. Cross-object tests establish emission and target layout, while only executed host fixtures establish local native behavior.
