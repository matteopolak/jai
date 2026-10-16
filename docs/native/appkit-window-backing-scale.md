# NSWindow backing-scale alias

The reviewed public declaration is a true alias:
`NSWindow.backingScaleFactor :: NSView.backingScaleFactor`. The existing target
already has the exact `(self: id) -> CGFloat` signature and instance dispatch.
Adding one alias line preserves its procedure identity, parameter name/count,
calling convention and return type. No forwarding body, class property,
cast-based substitute, additional field or root Objective_C export is added.

The AppKit generator now renders explicitly reviewed aliases into existing
authored aggregates. It preserves existing members, accepts an identical alias
idempotently, and rejects conflicting targets or missing owners. Default
generation emits both facades; external `--output` leaves inputs unchanged,
and `--module-output` emits the authored facade separately. Five unit cases
cover body preservation, comments/strings, idempotence, conflicts, missing
owners and separate owners. Public inventory rows identify aliases and their
canonical targets rather than attributing a new method body to them.

The focused Jai fixture checks public lookup, exact procedure type and `self`
named argument, typed NSWindow receiver conversion, and runtime alias/target
procedure-pointer equality. The SDK probe checks the actual NSWindow and
NSScreen instance getter arity and CGFloat return encoding. A real retained
NSScreen supplies the read-only runtime getter comparison. `NSView` here is
the Jai target namespace, not a promise that native NSView instances implement
the selector: the SDK declares this getter on NSWindow and NSScreen. The first
planned NSView probe was corrected after reading those headers, before any
native execution.

Twenty focused commands pass, including ARM64 O0/O2 and ASan/UBSan programs,
both Mac CPU source checks and complete AppKit strict lint, root privacy,
both SDK object compilations, general alias-unit tests, exact regeneration and
formatting. Native tests compare actual SDK getter values and confirm NSApp
remains nil. They create no NSWindow, NSView or NSApplication, change no focus
or clipboard, and release the retained screen. An unavailable display or SDK
receiver is a failing test, not substituted success.

This is native procedure-identity/CGFloat ABI evidence on NSScreen plus
NSWindow selector metadata, not an allocated-window behavioral test. Mac x64
has source and SDK compilation only. Actual window creation requires a
separate explicit GUI lease. The three bounded native programs finished and
their slot was explicitly released. Exact hashes and receipts are recorded in
`ready_appkit_backing_scale_checkpoint` in the bindings audit. Root replays
the original UI-builder application after adoption with its permitted
dependencies; this batch does not access excluded bodies.

The four previously reviewed NSEvent/convertPoint receiver mismatches remain
unchanged and separately pending a coherent forwarding contract. This repair
does not refresh their expected-miss audit, invent selectors, or change any
public parameter count.
