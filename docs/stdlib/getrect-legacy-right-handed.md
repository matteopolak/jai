# Historical right-handed GetRect

## What it is

`stdlib/GetRect` is the standard right-handed (y-up) GetRect module: float32 `Rect`, `ui_per_frame_update(window: Window_Type, ...)`, and the full widget/theme/region/color/text surface. It was formerly a small float64 module; the complete historical right-handed implementation now lives here. `stdlib/legacy/GetRect` is kept only as forwarding stubs (`module.jai`, `geometry.jai`, `orientation.jai`) so `#import "legacy/GetRect"` and older `#load` paths keep working. `stdlib/GetRect_LeftHanded` is the separate y-down variant and is not an alias of this module.

The historical rectangle is 16 bytes: `x, y: float` and `w, h: float`. Its module parameter remains `Type_Indicator: Type = void`; a supplied indicator selects caller-owned window, font, texture, and font-effects types. Geometry and widget state use upward-positive coordinates. They are not aliases of the left-handed module.

## How it works

`geometry.jai` contains independently authored rectangle, color, interpolation, and identity-hash bodies. Cutting the top selects the highest y slice and leaves the low part; cutting the bottom selects the lowest slice and raises the remainder. Margins reduce the remainder without widening the returned slice. Containment includes the low edges and excludes the high edges; disjoint intersections have zero extents. Corners use bottom-left, bottom-right, top-right, top-left order. Optional snapping rounds each coordinate before returning Vector2 values.

Color conversion cycles hue through one turn and uses the piecewise six-sector HSV equation. Generic color modifiers preserve fields other than x/y/z. `move_toward` limits each step to the target; the pointer form applies separate rise/fall rates multiplied by elapsed time. Widget identity hashes deterministically combine filename bytes, line, and identifier. This establishes stable identity within this implementation; exact historical hash-output parity is not claimed.

The paired widget tree is owned by the UI lane. It must preserve historical callbacks, records, and argument defaults while implementing RH pointer, scissor, text, row, popup, resize, and scroll geometry. `end_scrollable_region` receives `max_x` and `min_y`, the lowest content boundary. Despite its name, `draw_proc_adjust_y1` adjusts the lower content boundary while retaining the top. Public Rect state and user drawing callbacks remain RH. Any backend coordinate conversion belongs at an adapter boundary.

## How to change it

Everything lives under `stdlib/GetRect/` (`ui.jai`, `legacy-layouts.jai`, `regions.jai`, `orientation.jai`, ...). Change geometry in `geometry.jai`, preserving the float32 public layout and named arguments. Keep `get_hash`'s public declaration separate from its private wrapping-arithmetic body. Geometry aliases and movement helpers are module-private, following the historical scopes. The source includes 25 exported geometry contracts that match the historical lexical declarations exactly.

Change UI state and behavior in the paired authored UI fragments. Do not forward the public module to GetRect_LeftHanded. An orientation flag or common private helper is valid only when every row, text baseline, popup direction, resize edge, scroll limit, input position, and drawing callback follows the selected orientation. Keep direct consumer checks in addition to contract comparisons: lexical equality does not prove overload admission or interaction behavior.

## Configuration

`#import "GetRect"` selects this version directly; no overlay is needed. The legacy overlay below is only relevant for the frozen reference CLI:

```sh
JAI_RS_MODULE_PATH="/path/to/overlays/getrect-right-handed:/path/to/stdlib" \
JAI_RS_PRELOAD="/path/to/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off path/to/frozen/jai-rs check-library example.jai
```

Search order matters. The focused overlay contains only a GetRect directory symlink to `stdlib/legacy/GetRect`, so Math and other dependencies still resolve from the default library. A broad `stdlib/legacy` search root would select every available historical module, including the historical Math overlays; that is a separate invocation policy. The focused overlay changes GetRect's selected contract without editing the caller or the maintained default. Direct `#import "legacy/GetRect"` is also explicit, but retained consumers use the overlay so their sources remain unchanged.

`tests/stdlib/getrect-legacy-right-handed-geometry.jai` loads the actual authored geometry fragment and executes rectangle/color/hash assertions. Its negative control deliberately changes the expected top coordinate and must fail. This isolated test establishes geometry behavior without pretending the full renderer graph has passed. The retained GetRect example, codex_view, and skeletal-animation inputs are checked only as immutable source material; none of their programs or supplied native outputs are executed.

## Dependencies and limits

Geometry uses the independently authored Math module and prelude source-location descriptor. The full versioned entry also uses Basic and the paired authored input/drawing modules. With the `9508def6…` frozen CLI, geometry assertions pass; full UI checking still encounters the independent GL modifier frontier. The binary and exact input hashes belong to this receipt, with `build_inputs_verified=false` retained.

The historical nine-string `get_rect_get_global_data` protocol forwards local asset-loading logic. The UI lane is independently authoring that logic using real File operations, a configurable asset root, and authored resources. Missing assets must produce an actual load failure; fixed empty strings are not an implementation. Full-module/widget/retained-consumer behavioral acceptance remains pending until the source graph and asset logic are paired. Coverage distinguishes private authored bodies, syntax/contract comparisons, actual geometry execution, and unresolved dependencies.

The nine positional results are radio-full, radio-empty, checkbox-full, checkbox-empty, default font, circle-mode image, HSL-mode image, RGB-mode image, and numbers-mode image. The asset reader retains owned buffers for repeated access. Configure the root before initialization and follow its teardown/reconfiguration policy; callers must not free the returned cached strings. The source receipt does not establish resource availability or successful native font/image decoding.
