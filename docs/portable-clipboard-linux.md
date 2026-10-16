# Linux Clipboard backend

The Linux facade now has the reviewed six text/bitmap overloads, including the
canonical X11 `Window` parameters and both `flip := false` defaults. Linux does
not export `os_clipboard_empty`. The Mac and Windows implementation bodies are
unchanged. All native helpers and imports stay in module-private scope.

The new independent C service opens an X11 connection and creates an unmapped
selection-owner window. With a supplied Window, that owner is its private child;
otherwise its parent is the root. A dedicated thread services native selection
events after setters return. It does not consume the application's input queue.
Destroying the parent destroys the child and releases its selection naturally.
This parent relationship is a documented implementation choice, pending the
narrow Window policy question in [portable-clipboard-questions.md](specs/stdlib/portable-clipboard-questions.md).

Setters validate and copy their input before returning. Text is checked as UTF-8
and served through `UTF8_STRING` and `text/plain;charset=utf-8`; embedded NUL bytes
retain their explicit length. The reader requests UTF-8, falls back to native
`STRING` with Latin-1 conversion, and validates the resulting UTF-8. Missing
selection ownership produces an empty string. Native failures are logged and
asserted; disabling assertions does not remove native calls or error cleanup.
Returned strings are copied into the caller's current Jai allocator, and native
temporary buffers are freed separately.

RGB/RGBA input is copied into an `image/bmp` BITMAPV5HEADER payload, with explicit
BGRA masks, alpha, top-down rows, and optional vertical reversal. A large payload
uses native incremental property transfer. Incoming incremental transfers are
also assembled from actual property events. Outgoing transfers own independent
snapshots, so replacing or losing the selection does not invalidate an active
request. Unresponsive transfers expire after five seconds without progress.

The private Window connection now checks `XInitThreads` before its first display
is opened. This ordering follows the [official Xlib threading requirement](https://xorg.freedesktop.org/archive/X11R6.8.2/doc/XInitThreads.3.html).
Applications opening raw Xlib connections themselves retain that same native
prerequisite. The service installs an Xlib error handler which forwards errors
from other Displays to the previous handler. Errors on its own Display are
logged and checked, including asynchronous writes to vanished requestors.
Changing the process's error handler later can interfere with this handling;
provider ownership coordination is recorded in the shared inbox.

The selection/property protocol is independently implemented against the
[official X11 ICCCM](https://www.x.org/releases/X11R7.7/doc/xorg-docs/icccm/icccm.pdf)
and installed public Xlib headers. BMP layout follows Microsoft's
[BITMAPV5HEADER documentation](https://learn.microsoft.com/windows/win32/api/wingdi/ns-wingdi-bitmapv5header).
No external implementation body is included or downloaded. Native dependencies
are system X11 and pthread only. `tools/build_portable_clipboard.py --output DIR`
builds `libportable_clipboard.a` and `libportable_clipboard.so` on Linux, recording
exact source and binary hashes in `portable-clipboard-build.json`. Supply DIR
through the compiler's existing `JAIC_NATIVE_LIBS` search path. No binary asset
is committed by this source batch; integration must include this native build
in Linux packaging and CI.

`tools/check_portable_clipboard.py` builds fresh source-matched tools, checks both
Linux CPUs, Mac/Windows compatibility, overloads/defaults/privacy, strict lint and
format, and native C syntax against official installed headers. Its display-free
data tests execute with address/undefined sanitizers at O0/O2. The full compiler
and shared stdlib source set is guarded against concurrent changes. The first
29-command receipt passed every command but **failed its overall guard** when
the File_Watcher owner updated three source paths; that receipt is preserved.
The fresh replay at `clipboard-proof-qo8w981z/summary.json` passes all 35 commands
with zero compiler/shared-source drift, including complete strict-lint visits
to the Window connection helper on both Linux CPUs. The new API fixture's
missing `Basic` import was a test correction after clearing the gate, separate
from the production backend and connection changes.

That 35-command receipt remains historical evidence, **not acceptance of its
clock policy**: integration subsequently rejected the native clock-error
fallback. The corrected clock operation returns success only with an actual
timestamp; failure records the SDK errno, logs it, and leaves the output unused.
Selection timeouts stop on that error. The service frees retained payloads and
transfers, closes its Display, marks the pending command failed, and broadcasts
to both queued and active waiters. Later native callers receive the latched
negative errno without restarting the service or retrying the failed clock.

`tools/check_portable_clipboard_clock.py` exercises this correction without any
Display: translation-unit-only clock injection covers EIO in expiry, event
waiting and outgoing chunk dispatch; real heap/pipe/pthread operations verify
cleanup, two already-waiting callers, error reporting and native API error
propagation. O0/O2 tests use address/undefined sanitizers. Normal successful
clock reading/expiry remains tested independently of injected failure. The
ordinary verifier now also invokes this failure suite. No injection symbol or
configuration option exists in the public library.

The correction's eight-command receipt is `clipboard-clock-bkn9baio/summary.json`;
all commands and exact owned-input guards pass. The accepted 309 snapshot's
directory access was denied by the OS sandbox, so no alternate access or mutable
peer-source rebuild was attempted. Integration must perform the refreshed frozen
309 plus owned-files source replay; the historical 35 checks are not relabeled
as a current replay. Actual Linux execution remains pending normal Linux CI.

Actual Linux validation requires a Linux host and an explicitly authorized test
display: `tools/check_portable_clipboard.py --linux-runtime`. That mode builds
the native assets and runs interpreter/native O0/O2 Jai allocation/ownership
tests plus a separate Xlib-client test for text, embedded NUL, replacement,
incoming/outgoing incremental transfers, Latin-1 fallback, bitmap alpha/flip,
unsupported-target failures, Window parenting and destruction. Source checks on
Mac do not establish that these Linux runtime tests pass. No GUI, display or
global clipboard operation was executed in the Mac source verification.

Remaining limitations are explicit: Linux native linking/execution and normal
CI are pending; this is X11, not a Wayland-native backend; only the advertised
text/BMP/TARGETS conversions are served (TIMESTAMP/MULTIPLE and clipboard-manager
SAVE_TARGETS persistence are not implemented); selection lifetime ends when the
application or native owner ends; the native display's fatal I/O-disconnection
policy remains Xlib's. Returned allocator, Window parenting, bitmap MIME and
timeout policies await any narrower reviewed requirements. There are no new
public convenience exports or success stubs.
