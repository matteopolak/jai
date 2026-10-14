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
header. It records each header hash with the generated initializer. The other
incomplete Windows GUID remains unresolved. Public C-library version numbers
identify native ABI inputs only.

Dependencies and archive hashes are in
[dependencies.json](../../tools/native_bindings/dependencies.json). Installed
Apple SDK header identities used for contextual private typedefs and CF string
conversion are in [apple-sdk-inputs.json](apple-sdk-inputs.json).

## Tool verification

Twenty-four Python regressions pass. Regeneration is checked with
`python3 tools/native_bindings/generate.py --check`. The full desktop/native
run after declaration organization is `.work/organized-verification.json`:
44 failed or unimplemented checks are retained alongside passing results.
The subsequent NVTT/member/bitfield batch is
`.work/native-members-verification.json`: NVTT declaration and member-name
checks pass on six desktop configurations; five unrelated remaining failures
are recorded. POSIX ARM64 macOS and its real host-native bitfield setters pass.

The source-built formatter CLI currently fails to build against the integrated
new sources because `Extensions/Args/generate.jai:775` calls a missing
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
them.

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
