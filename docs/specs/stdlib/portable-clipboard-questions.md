# Linux Clipboard contract questions

The refreshed Clipboard page specifies the six Linux overloads and excludes
`os_clipboard_empty`. It does not specify these observable policy details:

- Does a Window argument require the selection owner XID itself to equal that
  Window, or may a private child window own and serve its selection?
- Which bitmap MIME targets and channel layouts are required? The existing
  public X11 provider exposes image/bmp; RGB/RGBA and vertical flip match the
  independent Mac and Windows backends, but are not Linux-specific oracle facts.
- Is returned text allocated with the current allocator? What timeout/error
  policy applies to an unresponsive external selection owner?
- Is persistence after application exit required (clipboard-manager SAVE_TARGETS)?

Implementation will use the current allocator for returned strings, explicit
native failures, a private child of a supplied window (root for no-window),
UTF8_STRING selection transfer and BMP bitmap transfer. These are documented
implementation choices pending narrower reviewed requirements, not new exports.
