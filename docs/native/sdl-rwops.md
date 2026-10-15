# SDL native RWops pointer forwarding

The refreshed reviewed contract specifies that `SDL_RWFromFile` returns the
actual SDK-owned pointer and `SDL_LoadBMP_RW` accepts that native object. Both
public entry points now bind directly to their real C symbols; no replacement
owner, callback table, registry, or context policy is interposed. Native function
address identity is checked against independent private declarations.

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
