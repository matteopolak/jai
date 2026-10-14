# Binding generation and review

Public facades use an independent organization: layouts, callback and opaque
types, aliases and constants, native storage, native entry points, then
convenience operations. Independent declarations sort by public name. Storage
initializers and same-name overloads retain their relative order. Aggregate
fields, anonymous overlays and enum members retain their exact reviewed order.
The ledger stays in specification order for traceability.

`tools/native_bindings/generate.py` reads reviewed specs. The explicitly
delegated NVTT class API additionally uses the pinned official 2.1.0 C++ header;
`vendor_cpp.py` runs Clang for Windows, Linux and macOS to obtain method symbols,
parameter types and defaults. Reviewed Jai signatures take precedence. Native
member declarations and authored convenience bodies have separate ledger
counts, and verification forces qualified class-member lookup.

The native header has const/non-const `CubeSurface.face` overloads that erase
to one Jai receiver type. Both native symbols remain declared, without an
invented public rename. Exact reflected overload equivalence needs
specification clarification. The published additional NVTT
methods and the selected vendor tag also differ in places; source compilation
does not prove those extra native symbols exist.

`vendor_constants.py` recovers three omitted Xlib string operands from official
X.Org libX11 1.8.12 and the HID interface GUID from the pinned Microsoft SDK
header. It records each header hash with the generated initializer. The current
reviewed Windows page subsequently supplied both complete GUID initializers.
Public C-library version numbers
identify native ABI inputs only.

Dependencies and archive hashes are in
[dependencies.json](../../tools/native_bindings/dependencies.json). Installed
Apple SDK header identities used for contextual private typedefs and CF string
conversion are in [apple-sdk-inputs.json](apple-sdk-inputs.json).

## Tool verification

Thirty-one Python regressions pass. Regeneration is checked with
`python3 tools/native_bindings/generate.py --check`. The full desktop/native
run after declaration organization is `.work/organized-verification.json`:
44 failed or unimplemented checks are retained alongside passing results.
The subsequent NVTT/member/bitfield batch is
`.work/native-members-verification.json`: NVTT declaration and member-name
checks pass on six desktop configurations; five unrelated remaining failures
are recorded. POSIX ARM64 macOS and its real host-native bitfield setters pass.

The initial source-built formatter CLI failed to build against the integrated
new sources because `Extensions/Args/generate.jai:775` called a missing
`print(*String_Builder, ...)` overload. Reproduction:

```sh
env TMPDIR="$PWD/.work/tmp" \
  JAIC_STDLIB="$PWD/.work/runs/organized-verification-76685/stdlib" \
  JAIC_NATIVE_LIBS="$PWD/.work/native" \
  .work/target-current/debug/jaic jaifmt/main.jai -O2 -exe .work/jaifmt
```

This is a build blocker, not a formatting pass. No Extensions files or other
worker checkouts were changed. Formatter normalization and format idempotence
remain pending until the new dependencies build the formatter.

The source-built jailint ran with repository config and `-D warnings` on all
owned module folders, `stdlib/internal/bindings`, and `tests/native-bindings`.
Its initial five findings are stored in `.work/bindings-lint.json`; they were
an unnecessary integer cast and unused private imports. Those findings were
corrected in generator inputs. A clean rerun is required for completion;
failed bodies do not gain validation merely because lint could not analyze
them. The latest isolated rerun is `.work/bindings-lint-reviewed.json`: all 34
owned module folders, the private binding folder, and native tests exit zero
with `-D warnings`. No lint rules were disabled. Later source builds using the
current foundation reach a different formatter blocker: `jaifmt/main.jai:53`
cannot resolve `exit`. The full current-foundation declaration check still
fails on `Basic.Buffer`, recorded in `.work/latest-current-foundation.json`.

## Additional supported behavior

X11 screen accessors now forward through the real public Xlib functions rather
than dereferencing the public opaque Display marker. SDL's Linux ABI record
dependencies are file-local imports. SDL passes six desktop declaration and
public-name checks; X11 passes two Linux declaration checks and still fails
its required convenience-name checks.

CoreFoundation string conversion uses real native UTF-8 byte APIs, preserves
embedded NULs, returns CF Create-rule ownership for CF strings, and allocates
converted Jai bytes through the current context allocator. Allocation or
conversion failure aborts; failed native creation returns its null result.
Its native roundtrip test passes.

Metal no longer depends on the macOS-only facade for a native double typedef.
The native descriptor creation/property calls and region helpers pass on the
host. A separately compiled public Apple SDK probe confirms six record sizes
and six offsets, including Metal structs and NSOperatingSystemVersion.

GL now has real version parsing/querying, extension discovery, reflection-based
function loading, shader string forwarding, name wrappers, object labeling,
and the specified diagnostic/no-op configurations. Windows and Linux source
checks pass for these bodies. Host native GL tests remain blocked by the missing
new portable `Window_Creation` dependency; no GL runtime success is claimed.
The compiler CLI rejects `-os ios` and `-os android`; mobile execution and source
target checks remain a compiler integration gap, not passing desktop tests.

ImGui formatting wrappers now forward through libffi with explicit native
procedure types and separate bool/void returns. A real ImGui 1.89.6 C++ program
checks formatted and colored text, clipboard logging, true/false tree-node
results, and nonempty rendered draw data. This proves the bridge/SDK route; the
Jai ImGui facade itself remains blocked by the Math/Basic dependency and its
published flattened bitfield layout still requires review. All 518 active
ImGui symbols resolve. The omitted nested TextRange linker name is generated by
Clang from its pinned public header and symbol-only declarations; no SDK
function body or substitute SDK is supplied.

Direct3D component/filter arithmetic is tested exhaustively against complete
selected native SDK enum/macro definitions compiled as a C oracle. This test
loads our private arithmetic source directly as a unit test; it adds no facade
exports and does not simulate a Windows SDK runtime. Public COM helpers whose
names use type aliases now forward through their canonical receiver vtables.

Authored coverage compares complete overload signatures, including parameter
names and defaults. A same-name body no longer counts as implementation of
other overloads. Shape selection checks condition intersections and records
any uncovered condition, retaining valid branches instead of choosing a
contradictory single shape.

SDL has an additional real host-native suite for subsystem initialization,
version constants versus runtime version reporting, hints, caller-owned pixel
surfaces, BMP file loading/error propagation, and event queue transfer. The C
fixture populates complete native event bytes in the existing 56-byte public
union; it adds no Jai exports. All 299 SDL foreign symbols resolve against the
installed SDL2-compatible runtime, identified in
[sdl-sdk-inputs.json](sdl-sdk-inputs.json).

The separate SDL layout suite uses pinned official SDL 2.0.1 headers. Five
record sizes and five offsets pass; SDL_RWops is 48 instead of 72 bytes and
SDL_UserEvent is 8 instead of 32. Both failures are reported before the final
assertion. Direct RWops callback invocation is not validated. The record
contracts require review; the passing runtime subset does not establish full
SDL ABI conformance.

Current-foundations tool verification uses the designated NEW foundations
worker's Basic, String, Hash and File_Utilities over the portable source tree.
The source-built compiler now builds the actual `jaifmt/main.jai` successfully;
the previous exit/print blockers no longer apply to this staging route.
`.work/formatter-current-foundations.json` records the build result.
All 34 owned module folders, private binding internals and native Jai tests
were formatted with that executable. `jaifmt --check` and 36 separate
`jailint -D warnings` invocations passed, without disabling rules; commands,
scopes and outputs are in `.work/current-owned-quality.json`.

Regenerate checked-in source with
`python3 tools/native_bindings/generate.py --formatter .work/jaifmt`, then
repeat with `--check`. Use the same options for `vendor_context.py`.
Both formatted regeneration checks passed; the 31 generator regressions passed.
Raw output remains available for bootstrapping tools, but must be normalized
before committing. See the [deviations report](../status/bindings-deviations.md)
for staging limits and remaining ABI/runtime failures.
