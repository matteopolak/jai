# HTTP/TLS host-provider review request

The Basic reviewed public inventory supplies only `alloc(size: s64) -> *void`
and supplies `talloc(size)` for temporary allocation. The Windows TLS call's
second argument was the `temp` allocator; the repair uses that scratch API,
retains ownership and adds explicit overflow/null failure handling. No public
Basic API expansion is requested.

## WASM clock availability: resolved by reviewed scope

The refreshed [Basic inventory](modules/basic.md) declares consensus time only
on Windows/Linux/macOS/Android. The reviewed [HTTP contract](../../extensions/http-codec.md)
places `http_date_now` in the existing native client/server adapter surface;
explicit-seconds formatting and parsing remain portable, including WASM.
Root authorized the held procedure move under that existing load block. No new
clock ABI, fallback, target gate or Basic export is needed. The original request
below is retained as historical evidence; it no longer blocks this narrow move.

### Original unresolved request (historical)

The current Basic facade exposes the clock only on Mac/Linux/Android/Windows,
but the reviewed inventory lists it without an explicit WASM condition. The
permitted transported `stdlib-target-dispositions.{md,json}` classify the Http
WASM missing name as a confirmed public mismatch. Http already imports Basic;
qualifying the name cannot add an absent facade export. No speculative alias or
WASM clock has been introduced, and Basic is owned elsewhere.

Please explicitly confirm whether `Basic.current_time_consensus` is required on
WASM and, if so, the reviewed host clock capability/ABI and failure behavior.
Alternatively confirm whether Http's `http_date_now` belongs only with its
existing native client/server adapters while explicit-seconds date codecs stay
portable. A proposal implementing that latter boundary passed WASM source/lint
checks but is held as own T7 `http-date-native-proposal.patch`; production HTTP
was restored unchanged after reading the transported disposition. This is not
permission to add a new target guard or reduce a reviewed API. No target manifest
was changed, and the production WASM failure remains counted as a failure.

## Required-library phase question (compiler/provider owners)

`stdlib/Extensions/Json/tests/windows-host-provider.jai` is an independent small
reproducer: import current `Extensions/Tls` and `Extensions/Json`, declare a
one-string record, call public `Json.free_json` on that record. On a Mac host:

```
JAIC_STDLIB=<shared>/stdlib <own-source-built-jaic> -check -no_dce \
  -os windows -cpu x64 stdlib/Extensions/Json/tests/windows-host-provider.jai
```

It fails during `generate_freer` compile-time execution, at the ordinary
runtime allocator's `c_malloc`, with "required native library `bcrypt` could
not be loaded". ARM64 full Http checks report the same diagnostic. The simple
Json-only import and a string rather than a record did not reproduce it; those
negative observations are recorded here and are not presented as successful
production behavior.

TLS currently declares Windows `bcrypt` as `#library,system,link_always`, needed
by its real native mbedTLS dependency. Does the reviewed compiler/provider
contract require loading a target link-always library during unrelated host
compile-time allocator calls, or only when execution reaches that native
dependency/initialization? Please establish the phase boundary and provide the
proper general mechanism. Do not remove the real SDK dependency, bypass required
initialization, intercept by module name, or create a fake bcrypt provider to
turn this cross-target check green. This worker has not changed compiler,
Basic, runtime, TLS bindings, or provider initialization semantics.
