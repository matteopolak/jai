# Numerics contract questions and independent decisions

Reviewed inventories, not legacy convenience tests, establish compatibility.
Default Simp font/texture/effects and Window_Creation window identities are now
integrated; their previous missing-shape questions are resolved.

1. Non-void Type_Indicator prescribes Font, Font_Effects, Texture and Window_Type
   aliases but no metric fields/hooks. What supplies em width, line height,
   ascender/descender and centering for opaque alternate fonts? Current metric
   calls require corresponding fields. Direct my_draw_text needs only callbacks;
   label's runtime alignment branches can instantiate em even with a finite
   baseline. Also specify the relation to Input.Event.window for alternate handles.
2. Does Type_Indicator apply identically to GetRect_LeftHanded? User requested
   both variants; that page lacks GetRect's contextual parameter paragraph.
   Both currently support the same parameter; a real custom-type regression tests
   identity, callbacks, full texture storage and independent instance globals.
3. What exact baseline/get_y_range formulas and descender sign convention are
   required? Current policy centers absolute ascent/descent, adds centering offset,
   uses handedness for baseline direction, em_width for em and character_height
   for text_size. The requested default font size16 is an independent theme choice.
4. What is Texture cache disposal/invalidation lifetime, and who cleans partial
   alternate-loader resources? Current cache is process-lifetime; canonical failed
   loads call Simp.texture_destroy, alternate failures require loader cleanup.
   No reviewed destruction callback is available. Widget states likewise retain
   stable module-owned cache allocations; clarify eviction and custom allocator
   lifetime before adding resource release that could invalidate active pointers.
5. Should using base: Color_Keyframe satisfy /Color_Keyframe without #as?
   The minimal independent generic reproducer still fails. Do not change the
   reviewed Augmented_Keyframe shape. Editor sampling copies canonical keyframes
   until the general compiler/spec decision is made.
6. Is GetRect.Windows an unconditional alias off Windows? The native binding
   rejects other targets; current export is conditional. Clarify the condition
   or the required platform-neutral binding namespace.
7. What native-window/Input contract is intended for WASM? Current reviewed
   Window_Type has no WASM branch. Default UI target checks diagnose unsupported
   handles; no invented window alias or fixture is substituted.
8. Exact styling/easing/text-format strings, rank-deficient polar completions,
   transform composition conventions and degenerate HSV hue are partly unspecified.
   Independent coherent choices are documented; no bitwise equivalence is claimed.
9. Capacity behavior is not prescribed beyond the fixed buffer shape. Current
   insert_text returns false without mutation, append_text diagnoses overflow,
   interactive text/newline rejection logs and preserves state, invalid Unicode
   scalar events are diagnosed. Clarify a different externally required policy.
10. What defines the NSCursor class identity reachable through pointers off
    Windows? Current AppKit supplies NSWindow but no NSCursor declaration. The
    UI uses an opaque borrowed pointer identity without fields/allocation;
    external nominal/reflection identity remains unverified.
11. Wheel handling now normalizes signed wheel_delta by abs(typical_wheel_delta),
    with scale1 when metadata is zero, and consumes it once per eligible region
    per frame. What exact scroll-speed units are intended for mouse_wheel_increment?
    How should horizontal UNKNOWN-key records be distinguished, given Event has
    no axis field? Combined region flags currently choose vertical for one scalar
    scroll value. No native event-pump implementation was changed here.

Current foundation fixes resolved scalar Hash integration and WASM libc formatting
imports. Actual WASM numeric/oracle tests pass without fake imports. Canonical
Input/Window_Type are integrated on supported native targets. Remaining producer
and compiler failures have original reproducers in
[dependency handoff](../../status/numerics-dependency-handoff.md).

## Current target availability / canonical Clipboard dependency

GetRect default Window_Creation.Window_Type and canonical Input.Event.window have no reviewed WASM handle. A non-void Type_Indicator supplies only Font/Font_Effects/Texture/Window_Type, not Event; does it promise availability on targets where canonical Input is unavailable? Current reducer preserves the Window_Type rejection rather than inventing an Event member or handle. Linux callback coverage is retained independently of unavailable native cursor resources.

Canonical Clipboard has a reviewed real Linux/X11 backend; GetRect now routes its existing text clipboard operations through that public API on Linux as well as Windows/macOS. Source/IR calls and ownership checks do not establish actual Linux display behavior; CI-private Xvfb native proof remains required. The private named-pasteboard module remains Mac-only and is not the public Linux Clipboard contract.

Root official NO_OUTPUT remap probes reject Basic program parameters supplied from a non-MAIN module and accept child-root-only configuration. Earlier remap reducers are retired as positive compatibility expectations; old failure evidence is retained. No import-discovery or late-overwrite change is authorized by those invalid fixtures.
