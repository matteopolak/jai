# Native binding implementation coverage

The [generated ledger](bindings-coverage.json) accounts for every inventoried
declaration in all 34 assigned public module aliases. It records the reviewed
spec page SHA-256, condition, exact signature and disposition. `declared` means
emitted ABI syntax, `forwarded` means a generated wrapper with a real call, and
`unresolved` means absent implementation. None of these statuses proves target
compilation, native layout, library symbol availability or runtime behavior.

The generator reads reviewed spec pages and explicitly delegated pinned native
header inputs described in [generation and tool verification](bindings-generation.md).
It retains conditional shapes,
implicit enum members, overloads and complete anonymous overlays. Native C
implementations, where built, come from pinned official vendor repositories.

## Validation so far

- Twenty-four Python parser/generator regressions pass, including configuration
  labels between aggregate names and kinds, multi-type fences, GL parent/field
  relationships across metadata sections, and implicit native enum dependencies.
- lz4, xxHash, meshoptimizer, freetype, stb_image, stb_image_resize,
  stb_image_write, stb_vorbis, Curl and MojoShader pass declaration and all active
  importer-visible name checks on Linux/macOS/Windows, each on x64 and ARM64
  (120 checks) against the explicitly staged independent foundation snapshot.
- Vulkan passes the same checks on its four documented Windows/Linux desktop
  configurations. Its array helpers perform real count/allocate/fill forwarding
  and preserve native error statuses; native Vulkan execution is not claimed.
- Host native programs pass LZ4 compression and HC streaming roundtrips;
  xxHash one-shot/streaming/block-boundary/empty-input checks; PNG memory and
  callback write/decode roundtrips; image resize; invalid image/Vorbis rejection;
  mesh vertex remapping/index codec/statistics/bounds; FreeType font loading
  and glyph rendering; POSIX errno/clocks/mutex/wait helpers; Curl local-file
  transfers, escaping and formatted output; typed Objective-C NSString/process
  messages, struct and float results and selector initialization; and MojoShader
  preprocessing, bytecode assembly and GLSL translation. These are nine
  source-built native programs, eighteen build/execution checks. The separate
  iOS helper fixture currently fails on the host due to unresolved availability.
- C sizes and selected field offsets agree for LZ4 1.9.4 streams and internal
  state, xxHash 0.7.0 streaming state, meshoptimizer 0.11 records, and host
  FreeType face/glyph/bitmap/vector records and four MojoShader records. Canonical
  reflected names, nominal aliases and external mutable stb settings are
  exercised. Private-export rejection checks include native library handles,
  helper namespaces, opaque FILE context and MojoShader contextual enums.
- All 383 active foreign function/data symbols in the nine probed C-library
  facades resolve against real native libraries. This excludes xxHash's private
  implementation entry points, which are exercised by its native program.
- Other modules remain provisional. Current broad checks fail on incomplete
  public aggregate initializers, omitted contextual declarations, platform
  shape gaps and member prototypes needing bodies; these are not passing
  modules merely because their declarations were generated. Nested NVTT methods
  summarized through its upstream-header contract are not counted as complete
  by an import-only check.

## Integration boundary

The latest foundation tree currently fails with `Basic` exporting an unresolved
`Buffer` name. A preceding snapshot also exposed an inherited-overlay compiler
gap; rebuilding the latest independent compiler changed that first diagnostic.
These failures remain recorded in `.work/full-verification.json` and
`.work/current-foundation-check.json`. They are not binding conformance results.

Isolated tests use a previously staged copy of the **new independent** foundation
authored during this session, never the removed library or a reference snapshot.
`--foundation <path>` makes that selection explicit. Every new verification run
records hashes of its compiler, specification pages and staged Jai sources.
Full current-foundation/corpus/release integration remains with the coordinator.

The complete default target run against the independent snapshot is durable at
`.work/full-independent-verification.json`: 204 declaration checks, additional
active public-name checks, privacy checks, symbol probes and all native builds
and executions. It reports 44 failed/unimplemented checks; these failures are
not omitted or relabeled as passes. [Earlier verified snapshot evidence](bindings-verified-snapshot.json)
retains the preceding batch and its limitations. Newer native evidence is in
`.work/vendor-native-verification.json` and `.work/mojo-native-verification.json`.

The initial MojoShader fixture incorrectly assumed a positive runtime version.
The official archive build sets its public `MOJOSHADER_VERSION` macro to `-1`
when changelist metadata is unavailable. The corrected assertion compares the
real function with the C header macro; no library result or vendor code was
changed to satisfy it.
- Public declarations containing omitted method bodies, contextual types,
  generated configuration differences and unsupported target branches still
  need implementation review. The ledger lists these explicitly.

## Reproduction

Run `python3 -m unittest discover -s tests/native-bindings -p 'test_*.py'`, then
`python3 tools/native_bindings/generate.py --check`. No reference compiler or
reference binaries are used. All build/test output belongs under `.work/` in
this durable workspace.

The native source pins, file hashes and repositories are in
[dependencies.json](../../tools/native_bindings/dependencies.json). Run
`python3 tools/native_bindings/build_dependencies.py` to fetch and build them.
The host FreeType test currently uses the installed official FreeType headers
and library, and `/System/Library/Fonts/Helvetica.ttc`; the font test requires
macOS. Probe build:

```sh
cc -dynamiclib -I .work/vendor/lz4/lib -I .work/vendor/xxhash \
  -I .work/vendor/meshoptimizer/src \
  -I .work/vendor/mojoshader-<pinned-revision> \
  -I /opt/homebrew/opt/freetype/include/freetype2 \
  tests/native-bindings/abi_probe.c -o .work/native/libabi_probe.dylib
```

`verify.py --compiler <explicit-source-built-jaic> --runtime` stages only the
independent foundation worker's new sources with these bindings, then records
compiler hash, every target result, diagnostics, privacy checks and native
execution results in `.work/verification.json`. Use `--module` to select a
batch. Full coordinator corpus/release verification is outside this worker's
scope.

Curl's variadic wrappers marshal runtime `Any` values with the official libffi
ABI. Directly spreading an `Any` slice into a native C variadic call produced
incorrect values in the failing native fixture. The bridge supports C scalar
promotions, pointers, enum values and UTF-8 string arguments, and uses the exact
native function address. Invalid C argument kinds or libffi preparation errors
abort; they are not ignored. The six-desktop source checks do not require an
installed libffi runtime, but native linking does (`libbinding_ffi` and libffi).
