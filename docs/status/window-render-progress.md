# Window/render progress

2026-10-14: first resumed batch committed as `a41ae76`. Prior focused runner
recorded 69 invocations; these include CPU component tests and foreign-target
interpreter checks, not combined production GUI integration. No release or
Focus acceptance is claimed.

Current batch: canonical AppKit dependency repaired; real native AppKit window
construction/close/release and public dimension/pointer/fullscreen-query source.
Host interpreter lifecycle test passes. Public create_window remains blocked by
the absent reviewed background default/type; the lifecycle test exercises the
real private constructor, not a fabricated public compatibility overload.

Issue #1: exhaustive signed-word decoding passes interpreter/native O0/O2;
Win32 MyWindowProc and PeekMessage/dispatch pump now handle signed wheel events,
native modifiers/states, keys/text/focus, resize/move, buttons and close requests.
Deterministic real-window PostMessage injection test type-checks x64/arm64;
native Windows execution remains pending coordinator hosts. Horizontal axis
encoding in Event needs reviewed clarification.

Focused runner: 87 invocations passed after replacing CPU substitute-module
tests with actual public Simp host bitmap/font imports. The obsolete substitute
modules have been removed. Owner-aware NEW producer staging removes obsolete
local Basic precedence. Current lint caught two existing owned manual assignment
forms; they were corrected without suppressions. Source-built jaifmt --check and
jailint -D warnings passed on every owned public/private/test Jai scope. Native
AppKit lifecycle passes interpreter/O0/O2; Windows arm64 and macOS arm64 no_dce
checks pass. macOS x64 POSIX dependency failure recorded with minimal reproducer.

Second batch: real AppKit queue/dispatch, native NSWindow notifications for
resize/move/focus/close/minimize, keyboard/repeat/release/modifiers, mouse buttons,
motion/scroll accumulation and external-event projection now pass host
interpreter/native O0/O2. Native Objective-C probe confirms AppKit re-translates
posted physical-key text; the strict test checks the actual translated character.
IME composition, drops/touch and immediate application of custom cursors to newly
created windows remain gaps. Source-built formatter and warnings-denied lint pass.
Next: actual native OpenGL texture driver verification, then remaining renderer/font
contracts; public create_window and Keymap grammar still require reviewed details.

New blocker: actual Apple OpenGL 4.1 context fixture source-builds successfully,
but canonical GL loader fails because general procedure-field reflection omits
PROCEDURE_WITH_VOID_POINTER_TYPE_INFO when exposing procedure fields as *void.
Minimal original reproducer and native-symbol control are in tests/window-render/repros.
Actual driver test fails in interpreter/native O0 before upload. It is added to
the focused runner without skipping/suppressing the failure; 87 successful
invocations above describe the preceding batch, not a passing GPU integration.
Compiler owner must fix the reflection flag; no table patches or peer Rust edits.

Remaining: native window creation/pumps, Keymap operations, glyph atlas/text and
renderer/context integration. See the [deviations report](window-render-deviations.md)
and [coverage ledger](../window-render-coverage.md). No peer checkout edits.
