# Historical right-handed UI

## What it is

`stdlib/GetRect` (also reachable as `legacy/GetRect`) supplies the GetRect widgets with float32 rectangles, upward-positive coordinates, historical state/theme layouts, and the `Type_Indicator` drawing protocol. This is now the default `#import "GetRect"`; see [right-handed GetRect](getrect-legacy-right-handed.md).

The complete historical closure has 268 matching lexical declaration contracts. This count covers names, fields, defaults, modifiers, argument and result spelling; it does not establish semantic API admission or widget behavior. Source bodies are independently authored. Read-only original declarations and resource roles were inspected, while supplied implementation bodies, compilers, native outputs, images, and fonts were not reused.

## How it works

The module keeps stable widget states, balanced draw/scissor stacks, active-widget capture, frame-buffered occlusion, popup ordering, text editing, region layouts, subwindows, and color controls. The y-up and y-down modules now share one source tree; right-handed layout differences are `GETRECT_Y_UP` branches. Public rectangles and the three-argument subwindow draw callbacks retain upward-positive coordinates throughout.

`orientation.jai` contains the pure layout math actually called by the widgets. A vertical divider's first rectangle is the high-y slice. The horizontal scrollbar occupies the low edge. `end_scrollable_region(state,max_x,min_y,scroll_value)` receives the lowest drawn content y; positive scroll translates content upward. A vertical nib starts at the track's upper end and travels downward as scroll increases. The caller applies the returned/current scroll displacement to its content before reporting the drawn bounds.

Subwindow titles occupy the upper slice. South-edge resizing moves the lower boundary while retaining the top, and north-edge resizing extends the upper boundary. `draw_proc_adjust_y1` reports a new lower content boundary, despite its name; the outer top remains anchored and vertical margin is retained. The title/content rectangles and occlusion extent update after the callback. Flowed text starts at the top and subsequent lines descend; positive display offset moves lines upward. Text baselines account for descenders below and ascenders above the baseline.

The Simp adapters pass triangle, quad, scissor, and text coordinates directly to its bottom-first draw space. The default pointer callback invokes `Window_Creation.get_mouse_pointer_position(window,right_handed)` with the genuine target window, so a different window's render height is never used to convert pointer coordinates. Custom draw providers implement the same right-handed protocol. HSV plane coordinates explicitly convert the stored downward-positive disc parameter into the displayed right-handed rectangle or warped disc; marker placement, dragging, and mesh colors use corresponding transforms.

Input uses actual provider-associated `Input.Routed_Input_Event` wrappers and separate per-window button state. The historical `Input.Event` ABI has no window field. Unassociated events retain current-window compatibility; they cannot establish multiwindow origin. Input views borrow payloads owned by Input and are consumed before the next Input update. The cursor helper uses verified stock Windows/AppKit calls or a caller provider; diagonal cursors use the documented older AppKit fallback. Native input, cursor changes, renderer submission, and font decoding have no acceptance receipt here.

### Retained resource data

`get_rect_get_global_data()` has nine positional string results: radio full, radio empty, checkbox full, checkbox empty, default font, circle-mode icon, HSL-mode icon, RGB-mode icon, and number-mode icon. These are actual byte strings loaded with `File.read_entire_file`; the wrapper explicitly returns the nine values from the same module-local provider. No compiler reflection or invented intrinsic is involved.

The provider caches each successfully read nonempty buffer and its resolved path. Repeated getters return the same borrowed data until asset release, UI teardown, or root reconfiguration. Failure to read a required role asserts; an empty string is not a successful resource. `ui_init(default_font,procs)` borrows an explicitly supplied font string, or obtains the font role from the owned cache when the string is empty. Simp copies font bytes for its memory-backed face lifetime. The provider does not own caller-supplied font strings, textures, callback data, or input pieces.

`set_asset_root(path)` copies the path, requires the UI to be uninitialized, and invalidates previous resource borrows. `release_asset_data()` also requires the UI to be uninitialized. `ui_deinit()` clears `default_font_data` before releasing cached resources and its owned root path. Directly modifying `getrect_asset_root` or `getrect_asset_filenames` while cached data is retained fails a path-consistency assertion; release first. Asset configuration and caching are not thread-safe.

The paired packet records the allocator that produced each cached role and its resolved path, and the allocator that produced the owned root string. Release uses those recorded values even if the caller changes `context.allocator` later. Caller-owned allocator state must remain alive until its retained allocations are released. This ownership change has source parsing evidence; its File-backed allocation/release paths have not been executed.

The asset-path ownership follow-up releases the temporary default-directory join after building the final path. Every transient resolved path captures the active allocator before allocation and is released on cache hits and failures. A successful first read transfers that path directly into the cache, avoiding a second copy; cache release frees it with the recorded owner. The uncached `global_data` reader also releases its path after reading while returning ownership of the file buffer to its caller. A caller-supplied root remains borrowed by path construction. `#filepath` denotes the containing source directory, while `#file` denotes the full filename; no basename removal belongs in this directory join.

## How to change it

The files below live in `stdlib/GetRect_Common/` and are shared with the y-down module through `GETRECT_Y_UP` ([shared implementation](getrect-shared-implementation.md)); the assets provider is compiled only for y-up. Preserve exact public declarations in `legacy-layouts.jai` and `advanced-layouts.jai`. Change region/subwindow flow in `regions.jai`, pointer and drawing adapters in `ui.jai`, editing in `text-interaction.jai`, flowed display in `text-flow.jai`, color interaction in `colors.jai`, and geometry conversion in `orientation.jai` or `color-surfaces.jai`. Keep callback geometry right-handed, retain borrowed/owned distinctions, and unwind matching state, scissor, and occluder operations in order.

`stdlib/GetRect/tests/orientation-tests.jai` loads the real geometry and production orientation helpers without replacing a renderer or constructing a native window. Its assertions cover asymmetric top/bottom layouts, nib positions and drag mapping, edge clamping, anchored content fitting, descending lines, and HSV coordinate mapping. Extend this fixture for new coordinate behavior, and test the real rendered result separately when the full source graph and native dependencies are available.

The RH UI source receipt and exact hashes are recorded separately in `stdlib/.coverage/getrect-legacy-right-handed-ui.json`. The geometry lane retains its own passing geometric assertions. Do not turn a copied passing geometry receipt into an RH widget, resource, or native acceptance claim.

## Configuration

Without configuration, assets resolve from `stdlib/GetRect/data/` (`GetRect_Common/assets.jai` reaches it through `#filepath` plus `../GetRect/data`). Required default filenames are:

```text
ui_radiobox_full.png
ui_radiobox_empty.png
ui_checkbox_full.png
ui_checkbox_empty.png
Karla-Regular.ttf
mode_circle.png
mode_hsl.png
mode_rgb.png
mode_numbers.png
```

Install genuine caller-owned resources there for unchanged consumers, or call `set_asset_root("/absolute/path/to/resources")` before initialization/getter use. Individual role filenames may be configured before loading. `Karla-Regular.ttf` is the historical filename role; the implementation does not bundle a supplied font or claim that an absent file exists. A caller can map that role to a genuine compatible font it provides.

The same provider body is available to runtime and compile-time callers. Compile-time reading depends on the source VM's real File/Platform IO capability and has not been executed here. Cached data belongs to the execution lifetime that loaded it; no implicit cross-process or compile-time-to-runtime cache persistence is claimed. The explicit nine-string wrapper permits a compiler-supported retained-data caller without substituting empty assets.

Use the focused module-search overlay ahead of the independent default stdlib and select the independent preload. The frozen source check used `9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d`, with `JAI_RS_RUNTIME_SUPPORT=off` and `build_inputs_verified=false`. All 19 staged files lexed; 17 parsed. The two retained layout defaults stopped at callback-parameter default and `widget.widget_type=#this` grammar frontiers. The complete module stopped at the GL procedure-table modifier. The isolated production orientation assertion stopped waiting for checked dependencies before its assertion. No new RH widget, asset, decoder, or native behavior passed that gate.

That preceding paragraph describes the immutable upstream UI receipt. The final paired packet fixes private nested scalar overload admission with concrete float32/int helpers and casts the integer text-row index to float32. Its actual production orientation assertions now pass on the same frozen CLI. They cover dividers, vertical nib/drag mapping, title/content rectangles, resize limits, lower-boundary fitting, descending text rows, and HSV coordinate inverse mapping. They establish those pure layout calculations, not complete widget interactions or native drawing. The paired receipt preserves the original failed gate separately and records the amended source hashes.

The narrow asset-path ownership follow-up preserves the preceding receipts. Its changed asset source passes frozen-CLI lexing and parsing, and a real compile-time assertion confirms the directory/filename distinction of `#filepath` and `#file`. The five exported asset declarations are unchanged. These checks do not execute File reads, cache hits, or allocator teardown; dynamic allocation and release verification remains outstanding. The coverage manifest records the exact base and amended hashes separately.

## Dependencies and limits

Geometry uses authored Math and the retained source-location descriptor. UI uses Basic, String, Hash_Table, Input, Clipboard, Window_Type, Simp, and Window_Creation; the asset provider uses File and its real platform IO dependencies. Simp text/texture paths additionally require genuine FreeType, codec, and graphics providers. External resource availability is a separate requirement from the implemented file-reading/cache bodies.

The current source supplies interaction algorithms but has no complete RH semantic/native acceptance. Remaining differences include unimplemented cosmetic timing fields and relative-drag initial-outside-range clamping, integer precision limits in float64 slider arithmetic, unverified cross-frame occlusion/input ordering, approximate authored palettes and warped-disc/interpolation appearance, and incomplete shaping/topic/console behavior. The native stock cursor fallback, actual resource decoding, renderer state, and teardown behavior still require live verification.
