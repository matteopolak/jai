# SDL public prefixes and native ABI

The reviewed SDL facade preserves its exact public records and procedure signatures.
SDL_RWops is48 bytes and SDL_UserEvent is8 bytes on supported64-bit targets.
These records describe prefixes; they are not complete C values. In particular,
ordinary Jai procedure fields on the public RWops are not C callback pointers.
Never pass a caller-created public prefix to an SDK operation that writes or
owns a complete native record.

The internal/bindings/sdl-native module supplies separate complete SDK records.
Its native RWops has C callbacks and target-specific hidden union storage.
Its User_Event includes windowID, code and both data pointers after the common
type/timestamp prefix. These private shapes do not change canonical public
names, field layout or export visibility. Native extent is checked against the
pinned target SDK, not assumed to be the same across operating systems.

SDL_RWFromFile and SDL_LoadBMP_RW remain the real foreign symbols. The factory
returns the actual SDL-owned object; passing it back to its SDK preserves native
identity and ownership. No Jai proxy, registry, copied callback table or fabricated
context is interposed. Real file operations, BMP decoding, both freesrc policies,
native close counts and errors are covered by the RWops regression. Safe WM-info
marshalling uses a complete private buffer and canaries before copying public
fields; it must not call C with an undersized public record.

The SDK probe tests both independent contracts. Public sizes/alignments and prefix
offsets match reviewed Jai specifications. Complete private sizes/alignments and
every RWops/User_Event field offset match the pinned official C headers. Native C
fills the private User_Event between before/after canaries; the test checks every
written field and reads only type/timestamp through the public prefix. Existing
version/rectangle/pixel-format/surface/event-union SDK checks remain active.
Historical48/72 and8/32 full-size failures are preserved in integration evidence.
Their equality requirement was invalid for specified prefixes, as clarified by
coordinator review; neither public layout nor native safety was relaxed.

To extend an adapter, derive its complete private layout from the pinned official
native headers, preserve observable field ordering, add C size/alignment/offset
oracles and bounded-output/lifetime checks, then test actual interpreter/native
calls. Keep SDK source versions and hashes in tools/native_bindings/dependencies.json
and native input documents. A host native pass and six source targets do not prove
execution on Windows/Linux or every supported SDK version.

Executed production evidence: build_dependencies.py --library sdl_abi_probe and
--library sdl_runtime_abi_probe builds actual C probes; verify.py --compiler
target/debug/jaic --stdlib stdlib --module SDL --runtime --native-libs
artifacts/integration-clean/native-sdk reports zero failures. The prefix regression
also passes interpreter/nativeO0/O2 and strict repository formatting/lint.
Native Window/UserEvent transport, WM-info and factory lifetime tests are retained.
