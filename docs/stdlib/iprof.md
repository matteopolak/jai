# Iprof profiler module

## What it is

`stdlib/Iprof/` is a frame-based instrumenting profiler. A metaprogram plugin (`IMPORT_MODE = .METAPROGRAM`, the default) wraps procedures of the target program in *zones*; the runtime (`IMPORT_MODE = .CLIENT`) measures time and calls per zone and frame, and reports them as text, CSV, or through a renderer-agnostic overlay. It can also be used by hand (`MANUAL_MODE = true`).

## How it works

Files (all loaded by `module.jai`):

| File | Mode | Contents |
| --- | --- | --- |
| `plugin.jai` | METAPROGRAM | `get_plugin`, `Iprof_Plugin`, option parsing (`handle_one_option`, `log_help`), body rewriting |
| `timing.jai` | CLIENT | `Zone`, `zones`, the call tree (`Call_Node`), `zone_begin`/`zone_end`, `Automatic_Zone`, `Prepend_To_Main`, `init_runtime`, the clock |
| `frames.jai` | CLIENT | `update`, smoothing levels, per-zone history ring, `set_frame`/`set_smoothing`, `paused` |
| `report.jai` | CLIENT | `Report`, `Report_Row`, `Report_Mode`, `create_report`, cursor/selection, `text_report`/`log_text_report`, `save_csv_report`, the exit report |
| `overlay.jai` | CLIENT + `USE_GRAPHICS` | `Config` callbacks and colors, `draw` (table), `draw_graph` (history lines), mouse picking |

**Instrumentation.** On each `TYPECHECKED` message the plugin looks at procedure bodies and, for those it keeps, prepends `__iprof_runtime.Automatic_Zone(index, "name", "file", line)` with `compiler_modify_procedure`; `main` (always kept) additionally gets `__iprof_runtime.Prepend_To_Main("csv path")` first. The call nodes are copied from two `#code` templates with their literal arguments replaced. `add_source` adds `__iprof_runtime :: #import "Iprof"(IMPORT_MODE = .CLIENT);` to the main program, and to each module that gets an instrumented procedure (`add_build_string(text, w, import_message)`). Each zone describes itself on its first run, so there is no zone table to generate after the fact; this matters for jaic, which re-parses a modified body immediately and would reject a reference to a table that does not exist yet. Skipped: `@NoProfile`, macros, polymorphic, `#c_call`, `#no_context`, `#compile_time`, foreign and nameless procedures, procedures smaller than `-min_size` expressions, and anything outside the main program unless `-modules`.

**Measuring.** Each distinct path of zones from the root gets a `Call_Node` (children are a sibling list; `Zone.last_node` short-circuits the common "same parent as last time" case). Zone 0 is the root and is always open. `zone_begin`/`zone_end` add nanoseconds to the node's `frame_hier` and to the parent's `frame_child`; self time is the difference. Direct recursion and calls deeper than `MAX_CALL_DEPTH` fold into the current node (`nested`), so the tree stays bounded. A node whose ancestors include the same zone is not `outermost` and contributes no hierarchical time to its zone's total, so recursive zones are not counted twice.

**Frames.** `update(true)` charges still-open zones up to now, folds each node's frame counters into three moving averages (level 0 = latest frame, 1 = fast, 2 = slow; picked with `set_smoothing`), writes per-zone sums into `Zone.history` (with `DO_HISTORY`) and clears the counters. `update(false)` and `paused` drop the frame's data.

**Reports.** `create_report()` rebuilds one module-owned `Report`: flat modes list every entered zone sorted by their column (self ms, hier ms, calls per frame); `CALL_GRAPH` shows callers (`<`), the focused zone (`*`) and callees (`>`). `select()` focuses the zone under the cursor; `select_parent()` moves to the most expensive caller, or back to the flat list. `set_frame(n)` shows the frame `n` back from history instead of the averages. `heat` is how far the latest frame differs from the slow average (0..1).

**Batch use.** The `Prepend_To_Main` expansion calls `init_runtime()` and defers the exit report: one `update(true)` (the whole run is one frame), `log_text_report`, and `save_csv_report` when `-csv` was given. Text report shape:

```
Iprof: self time    [1 frame]
     self ms     hier ms       calls  zone
       2.110       2.110           5  square_sum
       0.773       2.883           1  outer
```

CSV columns: `zone,self_ms,hier_ms,calls,indent,file,line`.

**Threads.** Only the thread that called `init_runtime()` is measured; zones on other threads are ignored. `busy` keeps the profiler from measuring instrumented code it calls itself (clock, allocator).

## How to change it

- New report column or mode: `Report_Mode`, `sort_column`/`column_value`, `fill_flat`/`fill_call_graph` in `report.jai`, then `text_report`, `save_csv_report` and `draw`.
- Instrumentation policy: `maybe_instrument` and `SKIPPED_PROCEDURE_FLAGS` in `plugin.jai`. The inserted calls' signatures must match `Automatic_Zone`/`Prepend_To_Main` in `timing.jai`.
- Smoothing rates: `level_weight` in `frames.jai`.
- Gotchas:
  - jaic cannot use a module as an `#add_context` value, which is why the plugin imports the runtime per module instead of through the context.
  - jaic only exports bodies of user modules (not the stdlib directory), so `-modules` reaches your own modules but not `Basic` etc.
  - Automatic zones live in a block of `MAX_AUTOMATIC_ZONES` allocated by `init_runtime`, so `*Zone` pointers stay valid while `zones.count` grows.
  - `#load`ed files need their own `#import`s. Float literals are `float32`; declare `float64` locals explicitly before mixing with `max`/`min`.

## Configuration

- Module parameters: `IMPORT_MODE` (`.METAPROGRAM`/`.CLIENT`), `MANUAL_MODE`, `USE_GRAPHICS`, `DO_HISTORY`.
- Plugin options: `-csv <file>`, `-min_size <n>` (default 30), `-modules`; `Iprof_Plugin.should_instrument` for a custom filter.
- Constants: `NUM_FRAME_SLOTS` (128), `MAX_PROFILING_ZONES_FOR_MANUAL_MODE` (2048), `MAX_AUTOMATIC_ZONES` (8192), `SMOOTHING_LEVELS` (3).
- `Config` fields: drawing callbacks, font metrics, colors, `graph_colors`. The overlay uses y-up coordinates with `(sx, sy)` as the top-left corner.

## Dependencies

`Basic`, `Math`, `File` (CSV) for the runtime; `Basic` and `Compiler` for the plugin.

## Tests

- `tests/stdlib/iprof-instrumented-report.jai`: the plugin instruments a program in a child workspace; a `#run` calls the instrumented `main` and checks the logged exit report (zones, call counts, `@NoProfile`).
- `tests/stdlib/iprof-call-graph.jai`: manual mode; call counts, recursion folding, call-graph navigation, history frames, text and CSV output.
- `tests/stdlib/iprof-runtime-manual.jai`: manual mode with the drawing callbacks.
- `tests/stdlib/iprof-plugin.jai`: plugin hooks and option parsing.
