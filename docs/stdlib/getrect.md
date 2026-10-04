# GetRect

## What it is

`GetRect` is the immediate-mode UI library: float32 `Rect` layout (`cut_top`, `cut_left`, ...), widgets (buttons, sliders, dropdowns, text inputs, scrollable and slidable regions, subwindows, color pickers, flowed text), themes and a per-frame `ui_per_frame_update`. Two modules expose the same API and differ only in coordinate orientation: `GetRect` (right-handed, y up) and `GetRect_LeftHanded` (y down). Both are thin entry points over one implementation in `stdlib/GetRect_Common`.

```text
stdlib/GetRect/module.jai             GETRECT_Y_UP :: true;   + #load of the common files
stdlib/GetRect_LeftHanded/module.jai  GETRECT_Y_UP :: false;  + #load of the common files
stdlib/GetRect_Common/*.jai           the implementation (never imported directly)
```

## How it works

Each public `module.jai` declares the module parameter `Type_Indicator: Type = void` (a supplied type selects caller-owned `Window_Type`, `Font`, `Texture` and `Font_Effects` types), defines the module-private constant `GETRECT_Y_UP`, and `#load`s `GetRect_Common/geometry.jai`, `geometry-helpers.jai` and `ui.jai`; `ui.jai` loads the rest. Common files branch on the constant:

- Value selection: `ifx GETRECT_Y_UP then a else b` or a plain `if`. Both branches still type-check, so symbols used in a branch must exist in both modules.
- Declarations present in only one orientation use `#if GETRECT_Y_UP { ... }` (`#if` does not open a scope). Examples: the subwindow draw-callback type, the asset provider (`assets.jai`, `set_asset_root`, `release_asset_data`) and `Dropdown_State.original_value`, which exist in the y-up module only.
- `end_scrollable_region` is declared once per orientation (`min_y` in y-up, `max_y` in y-down) and forwards to a shared body. Row stepping goes through `advance_row`, and pointer flipping through `left_flip_y`.
- `orientation.jai` holds the pure y-up layout math (`right_divider_rects`, `right_scroll_nib`, ...) and does not depend on `GETRECT_Y_UP`, so `stdlib/GetRect/tests/orientation-tests.jai` can load it alone.

Geometry in the y-up module: cutting the top takes the highest-y slice and leaves the low part; cutting the bottom takes the lowest slice. Containment includes the low edges and excludes the high edges. `Rect` is 16 bytes (`x, y, w, h` as float32). Widget identity hashes combine file name, line and an identifier. Drawing goes through a `Draw_Procs` table; `Simp` provides the default implementation (see [ui-and-drawing](ui-and-drawing.md)), and input is read from `Input`.

Scope gotcha: a scope directive in a loading file does not carry into a `#load`ed file and cannot be made conditional with `#if`. `geometry-helpers.jai` starts with `#scope_module` because the right-handed module keeps `move_toward` and the `v2`/`v3`/`v4` helpers private; `GetRect_LeftHanded/module.jai` exports its own copy of those few lines.

Assets: `get_rect_get_global_data()` returns nine strings (radio full/empty, checkbox full/empty, default font, and the circle/HSL/RGB/numbers color-mode icons) read with `File.read_entire_file` from `getrect_asset_root`, defaulting to `GetRect/data` next to the module. That directory is not in the repository, so call `set_asset_root(path)` (while the UI is uninitialized) or pass a font to `ui_init(default_font, procs)`. A missing required asset asserts.

## How to change it

- Same behavior in both orientations: edit the file in `GetRect_Common` once.
- Orientation-specific behavior: put both variants next to each other behind `GETRECT_Y_UP`, and keep the other module's variant unchanged.
- A public symbol that must exist in one module only needs `#if GETRECT_Y_UP` (or `#if !GETRECT_Y_UP`) around the declaration, not just around its uses; do not reference y-up-only symbols without it, because the y-down build type-checks them.
- A new common file is `#load`ed from `ui.jai` and sets `#scope_module`/`#scope_export` explicitly at its top.
- Tests: `tests/stdlib/getrect-right-handed-api.jai` (API surface), `getrect-right-handed-geometry.jai` (rectangle, color and hash assertions that `#load` `GetRect_Common/geometry.jai` with `GETRECT_Y_UP :: true`), `getrect-right-handed-surface.jai`, `getrect-text-display-compiles.jai`, and `stdlib/GetRect/tests/orientation-tests.jai`. `getrect-rh-negative-control.jai` is the same geometry check with a deliberately wrong expectation and must fail with `#assert failed`. They are mostly compile- and geometry-level; widget behavior needs a stubbed `Draw_Procs` harness when you change layout code.

## Configuration

The `Type_Indicator` module parameter on both public modules, `GETRECT_Y_UP` (private, set only in the two `module.jai` files and in the geometry tests that load `GetRect_Common` directly), and the asset root and file names (`getrect_asset_root`, `getrect_asset_filenames`; y-up module only).

## Dependencies

`Math`, `Basic`, `Input`, `Window_Type`, `Simp`, `String`, `Hash_Table` (both modules); `Window_Creation` and `File` (y-up module only, for pointer position and assets).
