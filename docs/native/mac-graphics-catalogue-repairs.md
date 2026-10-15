# Mac graphics catalogue repairs

This isolated producer continues the clean graphics work on candidate 90fea8ab.
Inputs were the current reviewed specs, newly authored production sources/tests,
the user's filtered failure descriptions and installed Apple SDK headers. The
named docs/status/mac-integration-baseline.json was absent when checked; no
replacement baseline or aggregate pass count was invented. No /Users/matthew/projects/jai-reference/history,
quarantine, vendor library bodies, transcripts or remote operations were used.

## Failure classification

| Catalogue class | Evidence and classification | Change |
| --- | --- | --- |
| native/clipboard-round-trip | Minimal public UTF-8 test reproduced interpreter abort 134, “Rust cannot catch foreign exceptions.” NSString.h exposes the instance initWithBytes:length:encoding: initializer, not the class stringWithBytes:length:encoding: selector used by our glue. Genuine native defect. | Clipboard and window glue now use canonical Objective_C.NSString.getTempString, which allocates, initializes with explicit UTF-8 byte length and autoreleases. No exceptions are swallowed and no binding class/storage is duplicated. |
| native/clipboard-round-trip, subsequent bitmap failure | After the native fix, valid bitmap writes succeed but invalid zero width hits the explicit safety assertion. The reviewed Clipboard contract does not promise silent refusal for malformed pointers/extents/channel counts. Incorrect test oracle. | Remove that silent-success expectation. Strengthen valid coverage with actual AppKit PNG decode, all RGB/RGBA samples, alpha and flipped rows. Keep native input validation. |
| native/objc-window-levels | init_core_graphics_runtime_constants and mutable kCG globals are absent from the reviewed public inventory. Obsolete helper expectation. | Exercise the real CoreGraphics C query through a private test-only declaration, with int32_t key/result ABI and key values from CGWindowLevel.h. Preserve normal/floating/minimum/desktop/maximum/screensaver/backstop/assistive level relationships. No public binding aliases/globals added. |
| graphics/window-fullscreen-toggle | Contextless and null swap success is unspecified (existing question 28). Native AppKit fullscreen transitions are asynchronous. Incorrect context and timing assumptions. | Establish a real context through public Simp.set_render_target before swapping. Wait for actual NSWindowDidEnterFullScreen/DidExitFullScreen notifications, then measure restored dimensions. Keep invalid-window fullscreen refusal. No arbitrary animation-settling delay or fake attachment. |
| graphics/window-input-native-events, compilation | NSCursor/NSApplication convenience types and routed_events_this_frame are not in this reviewed inventory. Event.window and events_this_frame are public. Invalid helper use. | Route through canonical Event.window and use typed native SDK messages for event injection/cursor observation, without declaring duplicate public types. See binding review questions below. |
| graphics/window-input-native-events, resize/close | After migration, synchronous SDK setContentSize notifications were lost before the next pump: both resize records absent. Genuine frame-boundary defect. | Retain native notifications in a private ordered queue. Drain after frame reset, each native dispatch and window updates; release each notification after consumption. This preserves callbacks delivered between pumps, including close identity and queued notification lifetime. |
| graphics/window-input-native-events, cursor | Old assertion requires a global arrow cursor after injected motion. That behavior is not specified; NSWindow acceptsMouseMovedEvents also controls AppKit dispatch. Incorrect/unreviewed oracle, not evidence to force a new public behavior. | Verify actual areCursorRectsEnabled ownership for both native windows through custom true/false transitions, plus real native motion injection. Record the exact arrow policy as unresolved; no arrow-compatibility claim. |

The independent macos-clipboard-utf8 regression covers empty text, UTF-8 and
embedded NUL lengths. macos-window-context-reopen repeatedly closes the current
native drawable, consumes QUIT with the exact original window identity, releases
the window, reopens and verifies magenta OpenGL readback over three cycles.
The input catalogue also preserves keyboard press/release, committed text, mouse
button, resize and two-window close identity assertions. Cocoa mouse-event pressure
uses float32 and coordinates use NSPoint; foreign procedure casts retain #c_call.

## Native verification and reproduction

The explicitly assigned CARGO_TARGET_DIR is
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/window-render/target`.
Compiler/linter were built here from this checkout's Rust sources using:

```
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= cargo build --locked --offline -j 2 -p jaic-cli --bin jaic -p jailint --bin jailint
python3 tools/check_mac_graphics_repairs.py
```

The runner pins JAIC_STDLIB to this production stdlib, uses fresh executables and
runs six regressions in interpreter/native O0/native O2 (18 runs). Results, host
identity, source hashes and per-case output are durable under
`$CARGO_TARGET_DIR/mac-graphics/`. The source-built formatter is built from
jaifmt/main.jai in this checkout. Format all three changed private Jai files and
the six scoped regression files, then require --check on the same paths.
Final evidence reports macOS 27.0 arm64, all 18 runs passing and source_inputs_stable
true. The runner rejects source changes during execution. Formatter --check,
warnings-denied lint, Python compilation and scoped whitespace checks pass.

Strict lint invocation (module files avoid traversing Windows-only module tests):

```
JAIC_STDLIB=$PWD/stdlib "$CARGO_TARGET_DIR/debug/jailint" -D warnings -I stdlib stdlib/Clipboard/module.jai stdlib/internal/window/cocoa.jai stdlib/Input/module.jai tests/native-regressions/clipboard-round-trip.jai tests/native-regressions/objc-window-levels.jai tests/native-regressions/macos-clipboard-utf8.jai tests/graphics-regressions/window-fullscreen-toggle.jai tests/graphics-regressions/window-input-native-events.jai tests/graphics-regressions/macos-window-context-reopen.jai
```

An initial directory-wide Input lint invocation encountered its Windows-only
test's platform assertion on macOS. It was corrected to the production module
entry; no lint diagnostic/rule or supported platform assertion was suppressed.
No Rust or Extensions source was modified.

## Clipboard and platform limits

The runner builds clipboard-guard.m with installed clang/AppKit, ARC and
Wall/Wextra/Werror. For each clipboard execution it materializes every existing
pasteboard item/type into separate native items before starting the child, restores
them even after child abort, and compares restored bytes without printing content.
If a promised type cannot be materialized, it refuses to launch the test. This
preserves data representations, not the original provider's identity, changeCount,
lazy-provider behavior or external files referenced by URL representations.
Concurrent user clipboard changes can be overwritten by restoration; run in an
isolated test session. The fixture itself also restores prior text, but direct
unwrapped fixture execution cannot restore all rich formats; use the guard runner.
Assertion diagnostics no longer print any returned clipboard text.

These are actual local macOS tests; no desktop accessibility/screen-recording
permission was needed for application-local NSEvent injection. This is not global
hardware-event injection or proof for every macOS/CPU/GUI session. Missing GUI
services remain real failures, not skips-as-pass. Windows WGL verification and
full catalogue/integration are outside this batch and publication remains held.

## Binding and behavioral review requests

Bindings owner: GetRect's reviewed public macOS pointers field references
*NSCursor, but current Objective_C/AppKit and its reviewed contextual inventory
provide no NSCursor declaration. Please audit the contextual public surface and
supply its canonical nominal type only if reviewed. Native NSCursor has
currentCursor/pointingHandCursor class getters and a void instance set method;
we added neither an alias nor duplicate storage. The old NSApplication convenience
use is likewise not grounds to invent an export. SDK tests use canonical runtime
entry points and private correctly typed procedure casts instead.

Reviewer: does set_custom_cursor_handling(false) require explicitly installing an
arrow cursor on native motion, or only returning cursor-rectangle handling to
AppKit? Does swap_view_buffers accept a null/window without a context, and what
selection policy applies across windows (question 28)? Current tests use supported
real contexts and native ownership, and do not claim these unspecified policies.
