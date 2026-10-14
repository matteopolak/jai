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

## Native clipboard and SDL2 milestone

Clipboard's macOS backend uses actual AppKit NSPasteboard operations, owns returned
UTF-8 strings through the caller allocator, and creates real PNG clipboard data through
NSBitmapImageRep from borrowed RGB/RGBA pixels. Native mutation failures assert because
the reviewed procedures have no status return. Other targets issue an explicit backend
diagnostic; they are not counted as implemented.

Gamepad has canonical records and an SDL2 controller backend: native discovery/open,
attachment changes and close, normalized axes/triggers, thresholded digital controls,
button transitions, and opt-in Input events. The private controller handle has process
lifetime and closes on disconnection. Stick Y is positive upward; negative/positive signed
axis endpoints each map exactly to -1/+1. Native SDL errors assert. Physical device
coverage is unverified; an actual SDL2 virtual controller exercises the native device
pipeline deterministically. This is separate from a physical hardware claim.

Gamepad/SDL_Input_Map owns parsed strings and array storage, frees all partial results on
error, parses complete button/axis/hat index tokens with overflow checks, and rejects
signed/inverted-axis encodings instead of silently losing their meaning. GUID formatting
uses temporary storage and explicit little-endian byte placement. The database export
contains 541 platform-qualified mappings extracted from the public **native SDL 2.0.9 C
source**, with its license retained and artifact/payload hashes recorded in
[dependency metadata](window-render-sdl-database.json). This is the independently selected
replacement data allowed by the reviewed spec, not the historical Jai payload. Some native
records use extended axis encodings that this public mapping shape cannot represent.

Keymap now supplies canonical callback, map/set, and mapping records. Dispatch and file
grammar remain unresolved and are not represented as complete support.

Validation added: host clipboard interpreter/native O0/O2; SDL mapping interpreter/native
O0/O2; Linux-target callback-record interpreter; Linux-target interpreter invoking the
host's real SDL2 virtual-controller APIs for attach, press, hold, release, axis extremes,
and detach. No physical controller was required or emulated by a success stub.
