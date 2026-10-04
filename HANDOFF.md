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
  browser playground. `crates/jai-language-server`: the LSP, built on the `jaic` lexer and parser. The older
  `jai-*` architecture has been removed; many pages in `docs/` still describe it (see `docs/README.md`).
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

- **focus-editor**: `first.jai` checks.
- **Vk-Engine** (+ Linalg, Jolt-Jai): Core, Renderer, Game and Editor compile and their build metaprograms
  complete. The ImGui / Vulkan binding generators now run and stop only on their C headers, which the
  corpus does not fetch (it pins `.jai` files only); the native `libImGui.so` / `libJoltC.so` are C++ builds.
- **jaison**: tests and example run. **sgpu**: all examples check (host, linux, windows).
  **Jails**: server and build check; `-os windows` needs a Windows host (compile-time `MultiByteToWideChar`).
- **The_Way_to_Jai**: 26 of 315 examples fail `check`; mostly Windows-only APIs, SIMD, missing native
  libraries, intentional `#assert` failures, and an older GetRect `dropdown` API (51.2).
- **Browser**: wasm build and both checks pass; 93 of 120 stdlib tests run in the playground, the rest
  need threads, native libraries or on-disk modules.

## Open work

- `Bindings_Generator`: C and minimal C++ work (see `docs/stdlib/bindings-generator.md`); C++ methods,
  templates and inheritance, and Objective-C are missing. Untested on the real Vulkan/ImGui headers (absent here).
- GetRect: `text_display` does not compile in either module (passes a `*Text_Display_State` where
  `get_status_flags` takes a `*Active_Widget`). `stdlib/api-coverage.json` and `stdlib/.coverage/*.json`
  still name pre-`GetRect_Common` paths.
- `tools/check_corpus.py` and its inventory helpers are legacy (they drove the removed `jai-rs` binary).
- Float printing details (TTWJ 5.2 / 6.5) are unverified.
