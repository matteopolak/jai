# Safe SDL RWops forwarding

The reviewed public record stays 48 bytes, with its original fields and Jai
callback types. Its native SDK counterpart has additional hidden storage and
C callbacks with native counts. A cast cannot make those interfaces compatible.
The original public/native mismatch assertion stays enabled and failing.

`SDL_RWFromFile` keeps the complete native file object behind a public wrapper.
The wrapper's Jai callbacks forward native size/seek/read/write/close operations
with explicit count/origin/result conversion. A synchronized live-address
registry resolves ownership without reading past a supplied public record.
Copying native-file callback fields to another record returns a real SDL error
instead of exposing private adjacent memory; the original stream stays usable.
Closed-handle concurrent use retains the native file API's lifetime restriction.

`SDL_LoadBMP_RW` builds a complete private C record for the synchronous decode.
Its callbacks invoke the public Jai operations under an explicit default
context, since the public C entry point has no hidden caller context. The native
bridge is tagged `SDL_RWOPS_UNKNOWN`, regardless of the preserved public type
field: a FILE/MEMORY tag would authorize unrelated hidden-union interpretation.
Its close callback delegates ownership to the supplied public close operation.
Pinned official SDL source confirms BMP freesrc cleanup goes through that
callback; it does not directly free the bridge's stack record.

Real native tests cover private ABI size/offsets, BMP decoding from an embedded
public record with surrounding canaries, a nonzero public type tag, both freesrc
modes, public file write/size/seek/read/close, copied-record rejection and invalid
callback diagnostics. `sdl-rwops-native-final.json` records native build/run
success; complete matrix reports retain the original layout failures. Private
types/registry/helper aliases have explicit negative-export checks.

The registry adds a small wrapper allocation, a lock and linear live-handle
lookup. A private hash map is a possible performance refinement. Context and
copied-file-handle policy require review if stricter behavior is desired;
general foreign-callback context propagation is preferable to changing the
public ABI. Windows/Linux source checks pass; native host evidence is macOS.
SDK headers/source/runtime provenance is in [sdl-sdk-inputs.json](sdl-sdk-inputs.json).
# Integration disposition

The proxy implementation described below belongs to producer snapshot `fddae00`
and is rejected from the combined production tree. It changes the SDL-owned
native pointer promised by the latest reviewed contract and cannot interoperate
with native C RWops clients. Its default-context callback policy is not established
by that contract. Production retains direct native factory/BMP entry points and
supports SDL-owned native objects; Jai-created/copied 48-byte records are not
native objects. The full private WM-info marshaller remains supported.
See [the precise integration request](../integration-requests.md). Historical
proxy test evidence below is not production verification.

