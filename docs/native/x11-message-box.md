# Native X11 modal message box

The independently authored `x_message_box` creates a real Xlib window and
returns only after a native mouse, keyboard, WM close or destruction event.
Every reviewed style has its named button set; release must match the pressed
button. Return/Space selects the focused button, Tab/Left/Right changes focus,
and Escape/WM close uses Cancel when available, otherwise OK, No or Abort for
the corresponding style. A destroyed dialog is not destroyed a second time.

The dialog uses the existing drawing helpers, a fixed 480 by 240 core-font
layout and a clipped message panel. The first button starts focused. These are
independent presentation/dismissal policies: the reviewed signatures do not
specify exact geometry, typography, scrolling, focus or close-response choices.
Long messages may be clipped and non-ASCII shaping is not claimed. An exact
presentation or dismissal compatibility requirement needs a reviewed contract.

It uses the existing global connection when present, otherwise opens and closes
its own real default connection. A native parent becomes the transient owner.
No successful response is fabricated for a missing display or failed native
window/protocol setup. Xlib retains its normal asynchronous error handler.
`XIfEvent` removes only this dialog's events, leaving other windows' queues
untouched; no global event draining or fake UI acknowledgement is used.

`tests/native-bindings/x11-message-box.jai` supplies real-server automation for
an isolated Linux X server such as Xvfb, without a reparenting window manager.
A second process opens an independent Xlib connection, locates the actual
viewable dialog and sends native press/release events. All seven styles select
different prescribed button positions. The parent verifies actual responses,
child status and preservation of another window's queued event. A deadline
makes an unresponsive dialog a failed test. This is source-checked for both
Linux CPUs; **native execution has not run on this macOS host**.

The private test's IsViewable value comes from complete official X.Org
xorgproto-2024.1 `include/X11/X.h`, pinned in dependencies.json with the full
release archive hash. Header SHA-256:
`3f3ce079a71d26784ea298a75a29fb8add6f0f409cf36850bea7d428fdb1a9fb`.
An active C assertion checks the value for both Linux C targets; it is not an
additional public Jai export or evidence of native message-box execution.
