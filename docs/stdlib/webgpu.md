# WebGPU (prototype)

## What it is

`#import "WebGPU"` gives Jai programs the standard WebGPU C API (`webgpu.h`): every type, enum, struct, callback and `wgpu*` procedure. Natively the procedures call [wgpu-native](https://github.com/gfx-rs/wgpu-native); in the browser playground the sandbox forwards them to the page's WebGPU. The bindings are generated from webgpu-headers' machine-readable spec (`webgpu.yml`), on both sides, so the same program runs in both places (`examples/webgpu/triangle.jai`).

Status: a prototype on the `feat/webgpu` branch. macOS (Metal) natively and Chromium-based browsers in the playground are tested; Linux (Xlib) and Windows surfaces are written but untested.

## How it works

```
webgpu.yml (pinned) --tools/webgpu_gen.py--> stdlib/WebGPU/generated.jai        types + #foreign procs
                                          --> stdlib/WebGPU/generated_wasm.jai   callback dispatch (browser)
                                          --> crates/jai-wasm/js/webgpu_bindings.generated.mjs
                                                 struct layouts, enum strings, call descriptors
```

**Native.** `generated.jai` declares each procedure `#foreign libwgpu` (`#library "libwgpu_native"`). `tools/fetch_wgpu_native.py` puts the release's `libwgpu_native.{a,dylib}` in `artifacts/native-libs/<os>-<arch>/`, where `jaic run` (dylib) and `jaic build` (static archive, plus the frameworks `stdlib/WebGPU/macos.jai` links with `link_always`) find it. `module.jai` adds what `webgpu.h` leaves to the platform:

- `webgpu_create_surface(instance, window)`: a `Window_Creation` window's surface. macOS gives the content view a `CAMetalLayer` (`macos.jai`); Windows and Linux chain `WGPUSurfaceSourceWindowsHWND` / `WGPUSurfaceSourceXlibWindow`.
- `webgpu_request_adapter`, `webgpu_request_device`: request and loop on `wgpuInstanceProcessEvents` until the callback ran. The device prints uncaptured errors unless the descriptor has its own callback.
- `webgpu_present(surface)`: `wgpuSurfacePresent` natively; in the browser, wait for the next animation frame.
- `webgpu_window_size`, `to_string_view`, `to_string`.

**Browser.** A program runs in the interpreter inside `jai_wasm.wasm`, in a worker that owns an `OffscreenCanvas`.

1. A `#foreign` procedure the sandbox does not implement goes to `crates/jai-wasm/src/host_bridge.rs`, which offers it to the page by name (`jai_host.call` import) with its arguments as 64-bit slots. By-value structs and aggregate results are pointers (the interpreter's C ABI lowering). Interpreter pointers are addresses in the module's own memory, so the JS side reads structs in place, and `wgpuQueueWriteBuffer` hands WebGPU a view of that memory without a copy.
2. `crates/jai-wasm/js/webgpu_host.mjs` interprets the generated tables: it reads the C structs into the dictionaries the JS API takes (snake_case members become camelCase keys, enums become their WebIDL strings, chained structs merge into the parent, sentinels such as `WGPU_WHOLE_SIZE` become `undefined`) and calls the method of the same name (`wgpuDeviceCreateBuffer` -> `device.createBuffer`). Objects cross as small integer handles with reference counts. `OVERRIDES` covers where the APIs differ (about 30 functions): surfaces (the canvas context), mapping (copies between the mapped `ArrayBuffer` and module memory, written back on unmap), `writeBuffer`/`writeTexture` argument order, getters that return structs (`GetInfo`, `GetLimits`, `GetFeatures`), device callbacks (`lost`, `uncapturederror`), `popErrorScope`.
3. A host function may return a promise. Then the bridge calls the `jai_host.wait` import, which is a `WebAssembly.Suspending` function: JSPI suspends the whole module, Rust and interpreter stacks included, until the promise settles. `engine.mjs` runs such programs with `playAsync` (`WebAssembly.promising(jai_play_run)`). The interpreter itself is not involved, so it can suspend anywhere, inside any foreign call.
4. JS cannot call a Jai procedure, so callbacks are queued: a callback-taking function returns a `WGPUFuture` and records the settled promise; `wgpuInstanceProcessEvents` and `wgpuInstanceWaitAny` are Jai procedures on WASM (`stdlib/WebGPU/wasm.jai`) that wait (`jai_webgpu_wait`, one page turn or until a future settles), then pull finished records (`jai_webgpu_poll`) and call them (`webgpu_dispatch_record`, generated per callback type).
5. Frame pacing: `webgpu_present` calls `jai_webgpu_next_frame`, a promise of `requestAnimationFrame`. The browser shows the canvas when the worker yields. After every wait the bridge refills the run's block budget (`Host::refill_budget`, so the budget bounds the work per frame), advances the sandbox's virtual clock by the real time that passed (`seconds_since_init` animates), and streams new output to the page.
6. Input: the page posts canvas events to the worker; `stdlib/Input/wasm.jai` (installed as Input's adapter on `OS == .WASM`) reads them with `jai_canvas_poll_event` and queues keyboard (pages map keys to `Key_Code`), text, mouse buttons, wheel, focus and resize events.

## How to change it

- New webgpu-headers revision: update `tools/webgpu.json` (revision and `webgpu.yml` sha256, and the wgpu-native tag and asset hashes built from it; `fetch_wgpu_native.py` refuses a release whose bundled `webgpu.yml` differs), rerun `python3 tools/webgpu_gen.py`, and check the rules with `--check-header webgpu.h` (of the same revision): it renders every struct, function, enum value and callback back to C and compares. Then review `OVERRIDES` and `STRUCT_FIXUPS` in `webgpu_host.mjs` against the JS API.
- C and JS API differ somewhere new: add an `OVERRIDES` entry (whole call) or a `STRUCT_FIXUPS` entry (one dictionary), not generator special cases.
- WebIDL enum strings come from `js_enum_string` (`_` -> `-`, texture formats join digits: `rgba8unorm-srgb`); `tools/test_webgpu_gen.py` covers the tricky ones.
- Gotchas: `WGPUBool` is 4 bytes, not Jai's `bool`. Native callbacks are `#c_call`; use `push_context` to print from one. On WASM a callback runs only inside `wgpuInstanceProcessEvents`/`wgpuInstanceWaitAny`, whatever its mode, and a loop that never calls either (or `webgpu_present`) never yields to the page, so nothing settles and nothing is drawn.

## Configuration

```sh
python3 tools/webgpu_gen.py [--yml webgpu.yml] [--check-header webgpu.h]
python3 tools/fetch_wgpu_native.py [--force]
JAIC_NATIVE_LIBS=<main checkout>/artifacts/native-libs/macos-arm64 jaic run examples/webgpu/triangle.jai  # from a worktree
```

Browser: the bundle ships `webgpu_host.mjs` and `webgpu_bindings.generated.mjs` next to `engine.mjs`. An embedder passes `createEngine(bytes, { host: createWebGPUHost({ canvas, output }) })`, runs with `playAsync`, and forwards events with `host.input(event)` / `host.resize(w, h)`. JSPI is required (Chrome 137+, current Edge; not yet Safari); without it `play` still works for programs that never wait.

## Dependencies

- webgpu-headers `webgpu.yml` (BSD-3-Clause), pinned in `tools/webgpu.json`, downloaded to `artifacts/webgpu/` by the generator; not vendored.
- wgpu-native release zips (MIT/Apache-2.0), pinned by sha256.
- Browser: WebGPU in workers (`OffscreenCanvas`, `navigator.gpu`), JSPI, `requestAnimationFrame` in workers.
- Internal: `interp::Host` (`refill_budget`), `jai-wasm` `host_bridge`, `stdlib/Input`, `Window_Creation`.
