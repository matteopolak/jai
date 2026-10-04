# Iprof profiler module

## What it is

`stdlib/Iprof/` is an instrumenting, frame-based profiler (the public API of the original Iprof module). It has two import modes selected by the `IMPORT_MODE` module parameter: `METAPROGRAM` (compile-time plugin that instruments procedures) and `CLIENT` (the runtime linked into the profiled program).

## How it works

- `module.jai` loads `instrument.jai` + `options.jai` in metaprogram mode, `runtime.jai` + `reports.jai` in client mode. `draw.jai` is loaded by `runtime.jai` when `USE_GRAPHICS` is true.
- Runtime: each `(zone, parent-stack)` pair is a `Zone_Profiling_Data` node in an open-addressed hash table; `caches[zone_index]` short-circuits the repeated path. `zone_begin`/`zone_end` charge ticks to the current stack; `update(true)` is called once per frame, rolls ticks into smoothed per-zone `History_Scalar`s, and `create_report()` builds a sorted `Report` (self / hierarchical time, call counts, or call graph).
- `log_text_report` / `save_csv_report` give batch output; `draw` / `draw_graph` render through the callbacks in `Config` (no renderer dependency).
- `MANUAL_MODE=true` skips the metaprogram: fill `Iprof.zones[i].name` (and `.hash`), call `init_runtime()`, then bracket code with `zone_begin(i)` / `zone_end()`.
- Timestamps come from `clock_gettime(MONOTONIC_RAW)` (nanoseconds) or `QueryPerformanceCounter`, on every CPU. `Machine_X64.rdtsc` is not used because our `Machine_X64` does not provide it.

## How to change it

- New report column or mode: `Report_Mode`, `create_report`, `propagate_to_zone` in `runtime.jai`, then the text/CSV writers in `reports.jai` and `draw` in `draw.jai`.
- Instrumentation policy (what gets a zone): `message` in `instrument.jai`.
- Gotchas:
  - `jaic` types literal module-argument values as `s64`, so `IMPORT_MODE=.CLIENT` fails to resolve at an importing site (also affects `Codex(USAGE_MODE=...)`, `Simp(render_api=...)`). `module.jai` therefore compares `cast(s64) IMPORT_MODE == 1`; client code written for jaic passes `IMPORT_MODE=1`. The injected import string in `instrument.jai` keeps the original `.CLIENT` spelling.
  - Files loaded by `#load` need their own `#import`s; file-scope imports of the loading file are not visible (see the imports at the top of `reports.jai`).
  - Float math needs explicit `cast(float)` where the original relied on implicit int-to-float conversion.

## Configuration

Module parameters: `IMPORT_MODE`, `MANUAL_MODE`, `USE_GRAPHICS`, `DO_HISTORY`. Plugin options (`handle_one_option`): `-csv file`, `-min_size n`, `-modules`. Procedures annotated `@NoProfile` are skipped.

## Dependencies

`Basic`, `Math`, `Sort`, `String`, `Thread` (stack-node mutex), `POSIX`/`Windows`, `Compiler` and `Crc` (metaprogram mode and auto-instrumented mode only), `File` (CSV).

## Status

The runtime and drawing code run and are tested (`tests/stdlib/iprof-runtime-manual.jai`). The metaprogram half typechecks and its option handling is tested (`tests/stdlib/iprof-plugin.jai`), but it cannot instrument anything until `jaic` supports metaprogram plugins and `compiler_get_nodes` (see `stdlib/Metaprogram_Plugins.jai`). `get_plugin()` defers `compiler_get_nodes` until the entry point is instrumented so it stays callable.
