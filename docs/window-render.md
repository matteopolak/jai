# Window/render worker coverage

This worker owns Window_Type, Window_Creation, Input, Keymap, Gamepad and
Gamepad/SDL_Input_Map, Simp, sRGB, Clipboard and their assigned internal directories.
Only the reviewed specs establish compatibility; independent peer code supplies native
bindings and numerical/foundation dependencies in local integration staging.

## First milestone

- Window_Type selects the reviewed native aliases and sentinels, with an explicit
  diagnostic for unreviewed targets. macOS currently requires the missing
  `Objective_C.NSWindow` declaration from the binding owner.
- Input has canonical common nominal records, modifier overlay, enum values, shared
  state, resize/move views, and per-frame transition reset. Native event pumps are
  still outstanding; this is not a claim of platform input support.
- Simp has canonical common nominal font/texture/bitmap/shader/window/immediate records,
  module parameters, texture-format size helpers, and allocator-backed bitmap lifetime.
  Renderer, loaders, fonts and device resource lifetime remain outstanding.
- sRGB implements all reviewed scalar and vector overloads, preserves alpha, and
  uses standard piecewise transfer functions. Independent fast approximations interpolate
  a compile-time table of 65 encoded-domain samples; they are not reference coefficients.
  A 1001-point normalized sweep bounds tested absolute error to 0.002 forward and 0.003
  inverse. Power/square-root variants operate on RGB only.

## Verification

Source-built tools: permitted compiler worker's new Rust sources copied into
`target/window-compiler-source`, built with `cargo build --manifest-path
target/window-compiler-source/Cargo.toml --locked -p jaic-cli -p jailint --target-dir
target/window-compiler`. Our unchanged local compiler builds but still requires the
superseded module.jai entry; the staged worker compiler uses prelude/module.jai.

Integration stdlib combines local stdlib and the permitted new bindings, numerics,
foundations and compiler stdlib sources, excluding peer Extensions. Public local modules
are selected with `-I stdlib`; `JAIC_STDLIB` points at the staging root.

- `tests/window-render/types.jai`: Linux target type-check and interpreter pass.
- `tests/window-render/portable.jai`: Linux target type-check and interpreter pass.
- `tests/window-render/srgb.jai`: host interpreter and native O0/O2 pass.
- Real `jaifmt/main.jai` built from our source using staged dependencies, to
  `target/window-jaifmt`. Format, `--check`, and source-built `jailint -D warnings`
  run on Window_Type/Input/Simp/sRGB, internal/rendering, and tests/window-render.
  No lint exclusions were added. These tools are not supplied reference binaries.

No host GUI, controller or clipboard behavior has been verified at this milestone.
Full integrated corpus/release checks belong to the coordinator.
