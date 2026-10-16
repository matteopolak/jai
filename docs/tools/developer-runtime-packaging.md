# Developer native runtime packaging

`tools/developer_native_runtime.py` copies the configured Mac SDK's complete
non-system dynamic dependency closure, rewrites references relative to each
loader and signs the resulting images. It now also retains each component's
installed top-level license/notice files under `notices/` and records their
source, package path and SHA-256 in each image's `runtime-sdk.json` entry.
Missing notices and conflicting staged notice contents fail packaging.

The configured SDK must provide those files beside its `lib` directory.
This is explicit installed SDK input, rather than an invented license fallback.
LLVM, Zstandard and Z3 notices were copied from the actual local SDK installations.
The installed source images and original source-built helpers were not changed.

The regression first failed because libclang had no notice receipt. The final
check stages the actual dependency closure, copies the source-built binding and
Check helpers, relocates them, then renames the entire package. It verifies that
the old directory is gone and all non-system dependencies are loader-relative.
Actual libclang generates a record from an independent C header; the real LLVM
helper parses Itanium and Microsoft mangled signatures. Code signatures, original
helper hashes, copied notice hashes, and missing/conflicting-notice rejection
are checked. A conflicting test notice is restored and hash-verified afterward.

```
python3 -B tools/check_developer_runtime_package.py \
  --sdk /opt/homebrew/opt/llvm \
  --binding-helper <candidate>/stdlib/internal/developer-tools/clang-bindings/developer-tools-clang \
  --demangler <candidate>/stdlib/internal/developer-tools/check-native/libdeveloper_tools_check.dylib \
  --output-root <integration>/package-checks
```

All nine final checks passed on Mac ARM64. Native Windows/Linux execution is
unverified; parsing a Microsoft symbol on Mac is not Windows runtime evidence.
The check uses actual source-built consumers, with no library source repair.
Expected install-name-tool signature-invalidation warnings precede explicit
re-signing; the resulting signatures are verified rather than suppressed.

This closes notice retention for the staged dynamic LLVM closure. Configured
compiler paths, builtin headers/resources, target sysroots and notices for
other static/distribution inputs remain separate packaging work. This is not a
claim that the full compiler/library distribution is self-contained or ready to
publish. Candidate06e8ea96 retains its original packaging source and recorded
limits; these new packaging-tool changes do not silently mutate its receipt.

The real relocated-consumer suite also passes all9 checks under Xcode Python3.9.
Notice/image hashing streams bounded chunks rather than requiring the Python3.11-only
`hashlib.file_digest`; notice conflict/missing-input failures remain mandatory.
The initial Python3.9 SDK-builder failure is retained in integration artifacts.
