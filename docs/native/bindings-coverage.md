# Native binding implementation coverage

The [generated ledger](bindings-coverage.json) accounts for every inventoried
declaration in all 34 assigned public module aliases. It records the reviewed
spec page SHA-256, condition, exact signature and disposition. `declared` means
emitted ABI syntax, `forwarded` means a generated wrapper with a real call, and
`unresolved` means absent implementation. None of these statuses proves target
compilation, native layout, library symbol availability or runtime behavior.

The generator reads only reviewed spec pages. It retains conditional shapes,
implicit enum members, overloads and complete anonymous overlays. Native C
implementations, where built, come from pinned official vendor repositories.

## Validation so far

- Thirteen Python parser/generator regressions pass.
- lz4, xxHash, meshoptimizer, freetype, stb_image, stb_image_resize,
  stb_image_write and stb_vorbis pass declaration and importer-visible name
  checks on Linux/macOS/Windows, each on x64 and ARM64 (96 checks).
- Host native programs pass LZ4 compression and HC streaming roundtrips;
  xxHash one-shot/streaming/block-boundary/empty-input checks; PNG memory and
  callback write/decode roundtrips; image resize; invalid image/Vorbis rejection;
  mesh vertex remapping/index codec/statistics/bounds; and FreeType font loading
  and glyph rendering. These are five source-built native programs, ten
  build/execution checks.
- C sizes and selected field offsets agree for LZ4 1.9.4 streams and internal
  state, xxHash 0.7.0 streaming state, meshoptimizer 0.11 records, and host
  FreeType face/glyph/bitmap/vector records. Nominal aliases and external mutable
  stb settings are exercised. Three qualified private-export rejection tests
  pass for lz4, xxHash and stb_image.
- Other modules remain provisional. Current broad checks fail on incomplete
  public aggregate initializers, omitted contextual declarations, platform
  shape gaps and member prototypes needing bodies; these are not passing
  modules merely because their declarations were generated.
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
  -I /opt/homebrew/opt/freetype/include/freetype2 \
  tests/native-bindings/abi_probe.c -o .work/native/libabi_probe.dylib
```

`verify.py --compiler <explicit-source-built-jaic> --runtime` stages only the
independent foundation worker's new sources with these bindings, then records
compiler hash, every target result, diagnostics, privacy checks and native
execution results in `.work/verification.json`. Use `--module` to select a
batch. Full coordinator corpus/release verification is outside this worker's
scope.
