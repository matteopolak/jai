# AppKit bindings

`Objective_C/AppKit` owns the reviewed AppKit class records. Root `Objective_C`
retains its Foundation/runtime exports and does not export these AppKit names.
The private NSGL backend aliases AppKit's `NSOpenGLContext`, so GL's returned
pointer has the same nominal type and inherited `NSObject` identity as the
public context methods. There is no second opaque context record.

`tools/native_bindings/generate_appkit.py` reads the reviewed AppKit page. It
emits complete typed Objective-C function-pointer forwarding, prefixed enum
members, pixel-format constants, menu declarations and Core Graphics runtime
globals. Run it, then format `stdlib/Objective_C/AppKit/generated.jai` with the
production formatter. The verification runner regenerates into separate scratch
and compares the formatted output. No upstream Jai implementation is an input.

The dynamic sends use each method's real argument types. x64 aggregate results
larger than 16 bytes use `objc_msgSend_stret`; ARM64 uses `objc_msgSend`.
Native void operations whose reviewed Jai signature returns unspecified `id`
dispatch as void and return the reviewed null slot. This includes application
delegate/menu/launch operations and context update. It does not turn native
failures into successful objects. Public `addSubView` sends Apple's selector
`addSubview:`. `NSApp` binds actual AppKit external storage, and
`NSDefaultRunLoopMode` binds the external Cocoa value.

`init_app_kit` registers its selector table while `characters` is unset and
initializes every reviewed mutable window-level global using the real
`CGWindowLevelForKey`. The Core Graphics initializer returns early when the
mutable `kCGBaseWindowLevel` is nonzero, including a caller-assigned value.
Initialization does not launch an application. Repeated exact imports share
the globals. Explicit startup initialization is not documented as a concurrent
publication protocol; message wrappers register their selectors through the
thread-safe native runtime independently of that startup table.

The class records preserve reviewed source layouts, including NSView's 152-byte
record. This is a compatibility declaration, not a claim that modern SDK
NSView instances contain exactly those bytes. SDK objects are allocated through
Objective-C allocation and follow caller-managed retain/release/autorelease
rules. Context/pixel-format initialization can return null when the requested
configuration is unavailable. NSGL retains its honest supported-profile limit;
an application request for OpenGL 4.6 is not changed into a 4.1 request.

Two source-derived boundaries remain visible: `NSView.convertPoint` sends to
the NSEvent class rather than its declared self, and several NSEvent members
have instance receiver signatures for selectors normally provided on the class.
Forwarding preserves those declarations and receivers. Their presence does not
promise that a system object responds to the selector. In particular, no
fabricated coordinate conversion or static-call substitution is supplied.

`verify_appkit.py` captures actual shared stdlib inputs into bindings-owned T7
scratch. It checks Mac ARM64/x64 source, real SDK aggregate sizes/offsets,
canonical GL identity, complete strict-lint manifests, deterministic generation,
root/helper privacy, and unsupported desktop-target rejection. Its native
interpreter/O0/O2/sanitizer program creates real NSViews and a real NSEvent,
checks geometry/backing conversion and event fields, compares foreign storage
with independently compiled SDK controls, and tests every window-level global
and initialization guard. It neither creates NSApplication nor opens a window.

Source evidence on x64 is separate from ARM64 native execution. Application
launch/event-loop/fullscreen/window/GL hardware smoke requires a serialized UI
lease and restoration of prior state; it is not inferred from these probes.
Windows/Linux are unavailable AppKit targets, rather than missing AppKit
backends. Other owned modules retain their separate native platform gates.

The exact reviewed NSResponder.super and NSWindow.responder members both use `using #as`, preserving the transitive NSObject receiver conversion without an extra overload or cast. The unchanged hash-listed Forbear source now checks successfully. The existing AppKit ABI fixture retains its runtime assertions, with only obsolete short enum spellings migrated to the reviewed prefixed constants. Prepared appkit-ui.jai/appkit_ui_probe.m checks real main-menu and GL current-context/view effects, clears and releases its context, closes only its own hidden window, and restores prior focus/context. It requires a fresh serialized lease; compilation/source lint is separate evidence from execution.
