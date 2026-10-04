# Third-party native libraries

## What it is

The stdlib binds some C libraries that no system ships (`stb_image`, `stb_image_write`,
`stb_image_resize`, `stb_vorbis`). `tools/build_native_libs.py` builds them from pinned, hash-checked
sources into `artifacts/native-libs/<os>-<arch>/`, and `jaic` searches that directory when it resolves a
library name, both for foreign calls at compile time / under `jaic run` and when linking `jaic build`
output. Without it, programs that use those modules check fine but cannot call into them or link.

## How it works

- `tools/native-libs.json` pins each source (repository, revision, sha256 per file) and gives each
  library a one-line C translation unit (`#define STB_IMAGE_IMPLEMENTATION` + `#include`).
- The tool downloads the files into `artifacts/native-libs/sources/` (verifying hashes), compiles each
  unit once with `cc -O2 -fPIC`, and writes `lib<name>.a` and `lib<name>.dylib`/`.so` (macOS dylibs get
  an `@rpath/` install name).
- `jaic-cli` (`native_lib_dirs`) passes the directory to `jaic::interp::set_library_dirs` at startup.
  - Interpreter (`interp/native.rs` `Library::open`): `<dir>/lib<name>.<dylib|so>` is tried before the
    system's search, with a leading `lib` in the Jai name stripped.
  - Linker (`jaic-llvm` `library_args`): `<dir>/lib<name>.a` is linked by path, so executables are
    self-contained.

```bash
python3 tools/build_native_libs.py              # all libraries
python3 tools/build_native_libs.py stb_image    # just one
```

## How to change it

- New library: add its sources under `sources` (compute sha256 with `shasum -a 256`) and an entry under
  `libraries` whose `code` is a C unit that compiles the implementation. The name must match the Jai
  `#system_library` name (without `lib`).
- Libraries a project builds itself (focus-editor's `LightweightRenderingView` via its `build.jai`) are
  not listed here; `tools/fetch_upstreams.py` fetches C-family sources (`NATIVE_SOURCE_SUFFIXES`) for
  that, never prebuilt binaries.

## Configuration

- `JAIC_NATIVE_LIBS`: path list replacing the default directory
  (`<stdlib>/../artifacts/native-libs/<os>-<arch>`, `os` in `macos`/`linux`, `arch` in `arm64`/`x64`).

## Dependencies

`cc` and `ar` on the host; network access to `raw.githubusercontent.com` on first build.
