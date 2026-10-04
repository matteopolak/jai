# Jai compiler handoff

## Rules

- Never run binaries under `reference/` (the reference Jai distribution). Reading its `.jai` modules,
  `how_to/` and `CHANGELOG.txt` to learn semantics is fine; never copy its text into `stdlib/`.
- Keep `docs/` current (kebab-case files; What it is / How it works / How to change it / Configuration /
  Dependencies; index in `docs/README.md`).
- Commit coherent progress to `main` and push, without attribution lines. Format with
  `rustup run nightly-2026-08-29 cargo fmt --all`.

## What is where

- `crates/jaic`: the compiler — `parser/`, `sema/` (checking and lowering to IR), `interp/` (IR interpreter,
  used for `#run`, metaprograms and `jaic run`), `build.rs` (workspaces and compiler messages for
  metaprograms). `crates/jaic-cli`: the `jaic` binary. `crates/jai-wasm` + `web/scripting-runtime`: the
  browser playground. `crates/jai-language-server`: the LSP, built on the `jaic` lexer and parser.
- `stdlib/`: our independently written standard library; `prelude/`: runtime type definitions.
- `tests/stdlib/*.jai`: regression programs, each must exit 0 (except `getrect-rh-negative-control.jai`,
  a negative control that must fail).
- `corpus/upstream/` (gitignored): the open-source Jai projects we compile.

## Commands

```sh
env RUSTC_WRAPPER= CARGO_TARGET_DIR=/Volumes/CodexBuilds/targets/jai-dev rustup run nightly-2026-08-29 cargo build -q -p jaic-cli
/Volumes/CodexBuilds/targets/jai-dev/debug/jaic run|check|build file.jai [-I dir] [-os linux|windows|macos] [- metaprogram args]
env RUSTC_WRAPPER= CARGO_TARGET_DIR=/Volumes/CodexBuilds/targets/jai-dev rustup run nightly-2026-08-29 cargo test -q --workspace
python3 tools/jaic-sweep.py corpus stdlib upstream --timeout 900   # expect only the negative control to fail
env RUSTC_WRAPPER= /opt/homebrew/bin/python3.14 tools/build_scripting_wasm.py --release   # needs python >= 3.11
node tools/check_playground_worker.mjs artifacts/scripting-runtime   # check_browser_release.mjs needs a packaged dir with release.json
python3 tools/openjai-tests.py   # open-jai expectation harness (open-jai is a separate dialect)
```

Vk-Engine (use a `--release` build; ~45 s per module):
`cd corpus/upstream/ostef--Vk-Engine && jaic check Build.jai -I Modules -I Source -os linux - Core|Renderer|Game|Editor`.

## Status 2026-10-04

- **focus-editor**: `jaic build first.jai` produces a working native editor on macOS (renders, takes input).
  Needs `python3 tools/build_native_libs.py` (stb libraries) and its own
  `modules/Objective_C/LightweightRenderingView/build.jai` run once (`jaic build build.jai` there). Debug builds
  need `~/Library/Application Support/dev.focus-editor` to exist (upstream creates `.../debug` non-recursively).
- **Vk-Engine** (+ Linalg, Jolt-Jai): Core, Renderer, Game and Editor compile and their build metaprograms
  complete. The ImGui / Vulkan binding generators now run and stop only on their C/C++ headers (the corpus now
  fetches C-family sources, but not those submodules); the native `libImGui.so` / `libJoltC.so` are C++ builds.
- **jaison**: tests and example run, also natively (`jaic build tests.jai`). **sgpu**: all examples check (host, linux, windows) and build natively on macOS
  after `python3 tools/build_slang.py` (Slang 2025.24.2, VMA and the Vulkan loader built from source); with MoltenVK
  all run except 04_mesh_shaders (MoltenVK has no `VK_EXT_mesh_shader`). Run commands: `docs/tools/native-libs.md`.
- **Jails**: `jaic build build.jai` produces a native `bin/jails` that answers LSP requests.
  Jails `-os windows` needs a Windows host (compile-time `MultiByteToWideChar`).
- **The_Way_to_Jai**: 21 of 313 examples fail `check`, none a compiler bug: Windows-only APIs (19.8, 33.2C, 33.6,
  50.1), the Windows-only raylib module (35.1, 52.2, 30/jai_raylib), intentional failures (20.2, 30.9), APIs older
  Jai versions had (6.6 `random_seed` result, 26.27 `builder_to_string(allocator=)`, 33.10 `Sound_Player` struct,
  51.2 GetRect `dropdown`), missing command-line arguments or import paths (30.14, 8.2, 12.8, the glfw ones), a
  missing `cpp_library.cpp`, and 31.2, which calls GL at compile time without a context (crashes in libGL).
- **Browser**: wasm build and both checks pass; 93 of 120 stdlib tests run in the playground, the rest
  need threads, native libraries or on-disk modules.

## Open work

- `Bindings_Generator`: C and C++ (methods, ctors/dtors, vtables, inheritance, templates, operators) work and
  were run on the real Vulkan and ImGui headers (`docs/stdlib/bindings-generator.md`). Missing: bitfield accessors,
  tail-padding `__RAW` structs, Objective-C.
