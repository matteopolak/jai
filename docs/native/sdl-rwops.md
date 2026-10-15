# SDL native RWops pointer forwarding

The refreshed reviewed contract specifies that `SDL_RWFromFile` returns the
actual SDK-owned pointer and `SDL_LoadBMP_RW` accepts that native object. The
file factory binds directly to its real C symbol. The BMP entry point uses a
scalar ABI adapter for its 64-bit public close flag; no replacement owner,
callback table, registry or context policy is interposed. File-factory symbol
identity is checked against an independent declaration.

The public record remains 48 bytes with ordinary Jai callback signatures. It
is an incomplete description of the native 72-byte object. Never construct,
copy, dereference its callbacks as Jai procedures, or pass this public record by
value to C. The supported pointer can be passed to the SDK that owns it. Public
RWops/UserEvent ABI mismatch assertions remain unchanged, active, and failing.

The regression checks private C record size/hidden offset against official SDK
headers, native file write/size/seek/read, a real decoded BMP, and both freesrc
modes on successful and failed decoding. A C observer wraps the real native
close callback, restores it before SDK deallocation, and counts exact closes;
it neither replaces the BMP loader nor fabricates success. Tests use the full
private native callback ABI when examining SDK files. No Jai callback table is
passed to C. Missing-file errors are also checked.

Earlier `sdl-rwops-native-final.json` validated an independently authored custom
stream adapter that the refreshed contract does not support. That result is
historical, not current compatibility evidence. Its custom callback/context and
copied-record tests have been replaced with meaningful native pointer/lifetime
coverage. The earlier adapter and registry are removed rather than retained as
unreviewed convenience exports. SDK provenance remains in
[sdl-sdk-inputs.json](sdl-sdk-inputs.json).

The public `freesrc: int` is 64-bit while native C int is 32-bit. A real native
regression proved that direct forwarding of `0x1_0000_0000` left the stream open
because SDL received zero. `SDL_LoadBMP_RW` now forwards the identical native
pointer with C flag 0 or 1 according to the full public value, preserving the
reviewed nonzero-closes contract. Its public function address consequently
belongs to this scalar adapter; the private declaration retains the actual SDK
symbol. No public parameter name, type, C calling convention, record layout or
stream identity changes. Before/after evidence is in
`.work/sdl-wide-freesrc-before.json` and `.work/sdl-wide-freesrc-after.json`;
the original layout failures remain active.
