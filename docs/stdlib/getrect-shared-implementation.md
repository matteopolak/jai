# GetRect shared implementation

## What it is

`stdlib/GetRect` (right-handed, y-up) and `stdlib/GetRect_LeftHanded` (y-down) expose the same public API and differ only in coordinate orientation. Both are thin entry points over one implementation in `stdlib/GetRect_Common`, so fixes land once. `stdlib/legacy/GetRect` is a set of forwarding stubs onto the right-handed module.

```text
stdlib/GetRect/module.jai             GETRECT_Y_UP :: true;   + #load of the common files
stdlib/GetRect_LeftHanded/module.jai  GETRECT_Y_UP :: false;  + #load of the common files
stdlib/GetRect_Common/*.jai           the implementation (never imported directly)
stdlib/legacy/GetRect/*.jai           forwarders (module, geometry, orientation)
```

## How it works

Each public `module.jai` declares the module parameter `Type_Indicator: Type = void`, imports Math and Basic, defines the module-private constant `GETRECT_Y_UP`, and `#load`s `GetRect_Common/geometry.jai` and `GetRect_Common/ui.jai`. `ui.jai` loads the rest. Common files branch on the constant:

- Value selection: `ifx GETRECT_Y_UP then a else b`, or a plain `if GETRECT_Y_UP`. Both branches still typecheck, so symbols used in a branch must exist in both modules.
- Declarations that exist in only one orientation use `#if GETRECT_Y_UP { ... }` (`#if` does not create a scope, so variables declared inside stay visible). Examples: the subwindow `draw` callback type, `Subwindow_State.draw_proc_*`, `draw_proc_adjust_y1`, the asset provider (`assets.jai`, `set_asset_root`, `release_asset_data`, `get_rect_get_global_data`), and `Dropdown_State.original_value`.
- Divergent public signatures keep each module's historical form. `end_scrollable_region` is declared once per orientation (`min_y` in y-up, `max_y` in y-down) and forwards to `end_scrollable_region_shared`; the subwindow draw callbacks of the color editor forward to `color_picker_callback_body` and `time_view_callback_body`.
- Orientation-sensitive row stepping goes through `advance_row`; Simp/pointer flipping goes through `left_flip_y` (identity in y-up, `render_target_height - y` in y-down).
- `orientation.jai` holds the pure y-up layout math (`right_divider_rects`, `right_scroll_nib`, ...). It has no dependency on `GETRECT_Y_UP` so `GetRect/tests/orientation-tests.jai` can load it alone; it is compiled into both modules but only used by the y-up branches.

Scope gotchas. A scope directive in a loading file does not carry into a `#load`ed file, and a directive cannot be made conditional with `#if`. So `geometry-helpers.jai` (`move_toward`, `v2`/`v3`/`v4`, `fract`) starts with `#scope_module` because the right-handed module keeps them private like the reference module. `GetRect_LeftHanded/module.jai` has always exported them, so it carries its own exported copy of those few lines.

The default asset directory is `stdlib/GetRect/data` (assets.jai resolves it relative to `#filepath` through `../GetRect/data`), so moving the file did not change where assets are expected.

## How to change it

- Behavior that is the same in both orientations: edit the file in `GetRect_Common` once.
- Orientation-specific behavior: put both variants next to each other behind `GETRECT_Y_UP`; keep the other module's variant byte-for-byte equivalent to what it was.
- A public symbol that must exist in only one module needs an `#if GETRECT_Y_UP` (or `#if !GETRECT_Y_UP`) around the declaration, not just around its uses.
- Do not add helpers that mention y-up-only symbols without `#if`; the y-down build typechecks them.
- Adding a new common file: `#load` it from `ui.jai`, and use `#scope_module` / `#scope_export` explicitly at its top as the other files do.

Equivalence checking used during the refactor: a headless harness that stubs the `Draw_Procs` table, moves the pointer over a subwindow's edges and corners, and logs every triangle, quad, scissor, pointer image and layout rect for labels, buttons, sliders, dropdowns, scrollable regions (both directions), slidable regions (both orientations), the color picker (all modes), the animation editor, text input and flowed text. Output was identical before and after for both modules. Keep a similar run in mind when changing layout code; the in-repo tests are mostly compile-level and geometry-level.

## Configuration

- `Type_Indicator: Type = void` module parameter on both public modules (selects caller-owned `Window_Type`, `Font`, `Texture`, `Font_Effects`).
- `GETRECT_Y_UP` (module-private constant, set only in the two `module.jai` files and in `legacy/GetRect/geometry.jai`).
- Asset root and filenames: see [right-handed UI](getrect-legacy-right-handed-ui.md) (y-up module only).

## Dependencies

Math, Basic, Input, Window_Type, Simp, String, Hash_Table (all modules); `Window_Creation` and `File` (y-up module only, for pointer and asset reads). Related docs: [right-handed GetRect](getrect-legacy-right-handed.md), [right-handed UI](getrect-legacy-right-handed-ui.md), [UI and drawing](ui-drawing.md).
