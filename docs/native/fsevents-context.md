# FSEvents context adapter

The reviewed public `macOS.FSEventStreamContext` is 40 bytes, with
`copyDescription/info/retain/release/version` at offsets 0/8/16/24/32. Apple's
native record is also 40 bytes, but orders `version/info/retain/release/
copyDescription` at those offsets. Equal size never established interoperability.

`macOS/wrappers.jai` now implements the exact `FSEventStreamCreate` signature
using `internal/bindings/fsevents-context`. It copies all five fields into
complete private native storage and forwards null contexts as null. All supplied
callbacks already have the reviewed C calling convention. Private callback
types replace opaque object pointer types with `*void`; widths, indirection,
parameters and calling convention remain identical. No callback trampoline,
hidden Jai context, allocation or lifetime registry is needed. The SDK expressly
copies context fields synchronously and owns subsequent retain/release calls.
Returned streams and callback info retain their native ownership rules.

This necessary wrapper changes the public function's address from the SDK
symbol. It preserves its callable ABI, parameter names and nominal public types.
The sole inventoried context-taking FSEvents entry point is adapted. No new
root exports or speculative unlisted stream helpers are introduced. Portable
FileWatcher's independently implemented native bridge is untouched.

`tests/native-bindings/fsevents-context.jai` asserts every public and private
field offset separately. Its C probe includes the complete pinned Apple SDK
header and asserts every native field offset. It invokes the actual public
wrapper from C, checks surrounding canaries and unchanged source bytes, then
overwrites source storage before native description/refcount/release calls.
Native callbacks verify info identity, retain/release counts and filesystem
event delivery through a real scheduled stream. The event test creates and
removes a private directory/file and has a ten-second failing deadline. A direct
SDK control runs the same lifetime assertions; it never substitutes for the
wrapper test. Null contexts are also exercised. No SDK symbol is replaced.

An initial test incorrectly assumed that returning a different pointer from
the retain callback replaced stored info; direct native SDK control failed the
same assertion. The final test uses normal retain semantics, returning its
input, and checks identity/counts. `copyDescription` is forwarded; the test
requests the SDK's stream description but does not assume that the SDK invokes
that optional callback. The current SDK deprecates run-loop scheduling; the C
probe narrowly permits that deprecation while retaining other strict warnings.
This exercises the existing public scheduling contract. A future public API
review may permit a dispatch-queue alternative; no extra public API is invented.

Header identity is pinned in `apple-sdk-inputs.json`. Build probes with
`tools/native_bindings/build_dependencies.py`; run the public matrix/native
program with `verify.py --module macOS --runtime --compiler <own compiler>`.
Production formatting, strict lint, regeneration and two-CPU execution commands
are recorded in `.work/fsevents-both-cpus-tools.json`; the source/privacy/native
matrix is `.work/fsevents-native-current.json`. Full integration/corpus remains
coordinator-owned.
