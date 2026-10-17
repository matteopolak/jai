# Window/render implementation questions and dependency reproducers

## Fresh Mac catalogue review questions (2026-10-15)

- Reviewed GetRect.pointers references *NSCursor, but current Objective_C/AppKit
  contextual public inventory has no such type. Bindings owner/reviewer: audit
  that public nominal type and contextual namespace. No duplicate type/alias or
  unreviewed convenience method was added by the graphics worker.
- Input.set_custom_cursor_handling(false): is explicitly setting the arrow on
  motion required, or only restoring AppKit cursor-rectangle ownership? The old
  global cursor assertion is not an API oracle. Native ownership is tested;
  the unreviewed arrow policy is not claimed.
- Extend question 28: is null/contextless swap_view_buffers specified to succeed?
  The catalogue now establishes a real public Simp target and does not invent
  silent success or attach a fake context. See the Mac catalogue repair doc for
  exact test migrations and actual native evidence.

Resumed producer integration resolves the Windows File and WGL dependencies in
questions17/30 and the macOS x64 POSIX shape blocker in24. Fresh compiler sources
integrate the general reflection flag fix in26; its runtime reproducer passes
without staging patches. Canonical Windows filename-font source checks now pass.
These are source/host-scoped results, not new native Windows execution evidence.

Current synchronized-contract resolutions: questions 3, 4, 12/15 (font backing
and lifetime), 18 and supplied mip ownership in 19 are resolved by the latest
reviewed module contracts. Public windows, Keymap operations, shader macro stages,
RGBA font atlases and retained shared faces now implement those contracts. NSOpenGL
constructors in 17 are now supplied by NEW bindings. Question 26 has a general
producer patch staged by tools/window_render_compiler.py; it preserves original
procedure identity as reflected member flag 0x8 while reflecting the stored type
as void pointer. Actual GL driver tests now pass; production compiler integration
belongs to the compiler owner. IME composition in 25 is outside the public committed
text contract and is not a compatibility requirement.

27. Latin secondary-font routing is only partially described by the reviewed
    is_latin heuristic. Current routing restricts secondary-font selection to
    is_latin characters, always when use_other_font_for_latin_always is true and
    otherwise when the primary native face lacks that character. Confirm precise
    interactions with reversed, center_character_set, y_offset_for_my_latin_characters
    and y_offset_for_centered_character_set before those layout fields are claimed.
28. swap_view_buffers has a signature but no context-selection/lifetime contract.
    Does it require the window's context already current, or locate a context even
    when another window is current? Native multiwindow swap behavior needs review.
29. General interpreter foreign-call affinity: late Objective-C symbol resolution
    moves foreign calls to the main thread after earlier ordinary C calls ran on
    a worker. Original reproducer native-context-affinity.jai uses a C thread-local
    marker, without GUI/context prerequisites. Preserve consistent native thread
    affinity or establish main-thread execution before the first foreign call;
    do not special-case GL/test library names. Real driver tests now initialize
    AppKit through public init_mac_app before creating native contexts.
30. Windows full-production issue #1 reproducer: windows-render-events.jai calls
    canonical public create_window/set_render_target and injects both wheel native
    messages through the real pump. x64/arm64 source checks fail at the missing
    reviewed GL.wgl_create_context export. Exact canonical metadata is HWND,
    share:HGLRC=null, major/minor:s32=0, compatibility/debug=false,
    wanted_msaa:s32=DEFAULT_MSAA -> HGLRC,HDC,chosen_msaa:s32. No private replacement
    constructor or GL-specific reflection workaround is introduced.
31. Android app ownership: the reviewed Android.android_app global exists only for
    imports enabling DEFINE_ANDROID_MAIN_AND_CALL_THIS. Window_Creation has no
    corresponding module parameter. Which canonical import/handler establishes
    the app pointer used by create_window and the native event pump? Default
    Android imports do not expose that storage. Do not invent a public app-global
    alias or a fake ANativeWindow to bypass the entry-point/glue contract.
32. The reviewed Keymap file grammar provides S-/C-/A-/N- prefixes, while
    programmatic add_mapping accepts Event.Modifier_Flags including cmd_meta_pressed.
    How should a Meta-modified binding serialize without inventing a new prefix?
    Current persistence emits only reviewed prefixes and diagnoses Meta bindings
    explicitly instead of dropping that flag. Also clarify escaping for literal #/newline
    in programmatic command strings; the reviewed reader strips comments/lines.
33. Texture shape flags expose Cube/Array/Volume/Buffer/Multisampled/Display_Target,
    but bitmap-to-shape layout, sample-count source and face/layer target selection
    are not specified. Which native resource operations/data layout are normative?
    Current supported storage/update/render/read paths are real 2D color/depth/
    stencil resources and owned mip chains; other shapes are explicitly rejected.

1. Resolved: contextual NSWindow and mask types now belong to Objective_C/AppKit.
   Window_Type and Window_Creation use that canonical import; the root module
   supplies NSRect. Public Simp bitmap/font host tests now use production imports.
2. Input's reviewed `overlay unpacked: { ... }` spelling is not parsed by our
   compiler. The existing general `#overlay(packed) using unpacked: struct { ... }`
   mechanism represents the same four bytes and promoted bool members. A general
   syntax alias, if required, belongs to the compiler owner. No symbol special case
   is required for the implementation.
3. Window_Creation references DEFAULT_WINDOW_CREATION_COLOR without providing its
   value or the inferred parameter type. What default/type is normative? It is absent from the public declaration
   inventory. Do not fabricate a background color to resolve this.
4. Keymap's specification does not define text grammar, accepted key spellings,
   duplicate precedence, or the precise meaning of ignore_modifier_keys. Additional
   reviewed behavior is needed for compatibility decisions beyond the signatures.
5. Resolved texture shape: the updated review supplies `gl_handle: GLuint` for OPENGL
   and the empty shape only for NONE. These are now implemented separately; no texture
   layout is invented for other render APIs. Window_Info_Platform_Specific remains empty.
   Please confirm the labeled shader/pixel-read variants correspond to OPENGL versus NONE.
6. Clipboard returns text without an explicit allocator contract in the reviewed
   inventory, and mutation functions have no status result. Which lifetime and failure
   reporting behavior is normative? Native errors must remain visible.
7. SDL mapping records have no public fields for signed-axis ranges/inversion. These
   extended SDL encodings need a reviewed policy; do not silently ignore their meaning.
8. Gamepad's axis orientation, threshold inclusivity, device-selection priority, and
   `generate_left_stick_events` interaction with `generate_events` are unspecified.
   Current independent SDL2 behavior uses upward-positive Y, inclusive thresholds,
   first enumerated supported controller, and both flags for left-stick key events.
   These choices require coordinator compatibility review; native polling/state values
   and transitions are real, with deterministic native SDL device coverage.
9. Resolved by the reviewed OPENGL gl_handle field: texture resource identity now follows
   the actual GL name through by-value returns/copies. No dimension/flag token or address
   registry is used. Native-driver execution still requires a working context backend.
10. Windows clipboard needs GlobalFree, GlobalSize, SetLastError and
    IsClipboardFormatAvailable beyond the current binding inventory. This adapter
    declares them privately from official SDK documentation; the native binding owner
    can absorb these declarations at integration. The implemented real owner window
    avoids OpenClipboard(NULL)'s SetClipboardData ownership failure.
11. Historical `-no_dce` failure in inherited Basic/module.jai:
    `Buffer :: Impl.Buffer` refers to a missing internal/basic export in the staged new
    foundations implementation. Resolved by owner-aware NEW producer staging without
    older local facade precedence: Linux x64, Windows arm64 and macOS arm64 focused
    no_dce checks now pass. Full corpus remains coordinator work.
12. Windows OEM punctuation/layout translation needs reviewed policy and native
    VkKeyScanW/MapVirtualKeyW declarations. Current pure translation returns UNKNOWN/0
    for unsupported inputs; it does not fabricate a US-layout mapping.
13. Font effects/shaping, mipmap layout/filter/gamma policy, is_latin membership, and
    glyph width versus advance semantics lack behavioral detail in the reviewed Simp
    inventory. Further reviewed contracts are needed before claiming exact support.
14. SDL mapping `deinit(map: SDL_Gamepad_Mapping)` takes its descriptor by value.
    It frees owned payloads; resetting the caller's descriptor cannot follow from this
    signature under the implemented value semantics. Clarify the reviewed wording
    "resets the array" without changing the public signature or using hidden mutation.
15. The loaded-face implementation copies memory inputs, caches filename requests by
    name, and destroys registry-owned faces through their creating allocator. Confirm
    any required shared-face reference counting or alternative borrowed-buffer lifetime
    before Dynamic_Font ownership is integrated; no fabricated metrics are supplied.
16. Window query coordinate details need review: Win32 global right-handed coordinates
    currently use the virtual desktop bottom; client pixel pointers flip with height-1-y.
    X11 uses the native window's screen height for global dimension orientation.
17. NEW GL now supplies the Linux glx_create_context constructor. Generic
    gl_create_context and NSOpenGL constructors remain missing. Compile-only reproducer:
    stdlib/GL/tests/context-invalid-window.jai on Linux. Simp window/context ownership
    should integrate these real constructors; do not return fake contexts or bypass the
    native binding owner with a second public GL module.
    Existing internal/window connection storage must converge with canonical
    X11.x_global_display for GLX integration; successful native X11 tests need a server.
18. `get_shader_program(shader_text: string)` has no reviewed source-combination grammar:
    how are vertex and fragment stages selected from its single string? Shader macros,
    delimiters, or source preambles must not be invented as compatibility answers.
19. The new GL texture source currently supports ordinary 2D textures on desktop GL 3+,
    checks driver/extension format support, and explicitly rejects unsupported shape flags
    or unspecified supplied mip-chain layouts. Confirm minimum context/profile requirements
    and desired filtering/wrap policies; native-driver validation remains pending.
20. SDL integration policy: native button states project into common Input state even
    when normalized event emission is disabled. A newly owned SDK event subsystem is
    configured for manual polling to prevent an unused raw queue; existing SDK queues
    are preserved. Confirm any required raw-SDL interoperability beyond this policy.
21. Event has one wheel_delta and no explicit horizontal axis. The native Windows
    pump preserves signed WM_MOUSEHWHEEL deltas with key_code UNKNOWN, while vertical
    deltas use MOUSE_WHEEL_UP/DOWN and accumulate mouse_delta_z. What reviewed
    convention distinguishes horizontal wheel events and wheel-button impulses?
    No public field or synthetic arrow-key export has been invented.
22. macOS queries currently report native AppKit content points; right-handed is
    the native bottom-left origin, left-handed uses the main screen's upper edge
    for global coordinates and content height for local continuous coordinates.
    Confirm backing-pixel versus point requirements and multi-screen origin policy.
    Fullscreen returns actual current dimensions during asynchronous native transition.
23. AppKit's contextual setTitle signature returns id although the native SDK setter
    returns void. Window lifecycle glue uses the native void ABI and does not depend
    on an undefined return value. Binding owner should review the contextual result.
24. NEW bindings POSIX on macOS x64 currently reports unknown itimerval at
    declarations.jai:3422 (kinfo_proc dependency). Compile-only original reproducer:
    stdlib/POSIX/tests/macos-x64-kinfo.jai with -check -os macos -cpu x64.
    macOS arm64 no_dce window test passes; do not patch tool-only imports or peer code.
25. macOS native scroll uses scrollingDeltaX/Y with fractional accumulation and a
    typical_wheel_delta of 1 in native point/line units. Confirm expected trackpad
    scale and horizontal convention. Raw characters are native key text, not IME
    composition completion; full NSTextInputClient integration remains outstanding.
26. Release-blocking general reflection issue: `struct
    #type_info_procedures_are_void_pointers` reflects a stored procedure field as
    POINTER but omits PROCEDURE_WITH_VOID_POINTER_TYPE_INFO (0x8). Original minimal
    reproducer stdlib/Reflection/tests/procedure-type-info.jai fails at runtime
    with kind POINTER, flags 0; an ordinary struct reflects PROCEDURE and passes.
    GL.gl_load correctly recognizes procedure kind or this flag, so it cannot load
    glGetStringi or other stored procedure fields. Both interpreter and native O0
    actual-context texture-driver fail at indexed extension discovery. The NEW
    native GL symbol resolves normally (repros/gl-loader.jai), proving the driver
    symbol is present. Compiler owner must preserve the member flag when replacing
    reflected procedure type with *void. Do not special-case GL or patch test tables.
34. Windows device notification dispatch now registers the canonical HID and
    XBOX_GUID interface classes. The native class determines is_xbox; the borrowed
    UTF-16 path and connect flag follow the real arrival/removal payload. Must HID
    interfaces associated with XInput also report is_xbox=true? No reviewed path/VID
    classification policy is supplied, so no guessed heuristic is used. Native
    registration/dispatch and original x64/arm64 parser tests are independent of
    this classification question; physical-device and Win32 runtime remain pending.
35. Broader all-code Windows arm64 check now fails in the NEW Unicode producer's
    utf8_inital_byte_mask initializer: expected [6]u8, found s64. Original minimal
    production-import reproducer: stdlib/Unicode/tests/no-dce.jai,
    -check -no_dce -os windows -cpu arm64; ordinary -check passes. Foundation/compiler
    owners should review that typed array declaration/general semantics. No local
    staged import/source rewrite or individual-symbol compiler bypass is applied.
36. Actual filtered WindowsCI candidate0100a1f passes signed-wheel issue#1 on both
    CPUs but fails public WGL creation in interpreter/nativeO0/nativeO2 on both.
    Actual driver identity and failing native stage are absent from that feedback.
    Original windows-wgl-driver.jai now reports native PFD/GL/WGL/DLL identity and
    requires real3.3 core rendering/readback and failure-path context preservation.
    Bindings owner: capture native errors before cleanup, and review unconditional
    target ReleaseDC on CS_OWNDC failure paths. See native/window-render-wgl-investigation.md.
    Explicit real-Mesa CI deployment is prepared; no Windows driver/runtime result
    is claimed until authorized filtered native feedback supplies that evidence.
