# Installed OpenSSL SDK discovery

CI 833's sanitized Linux failure selected the Mac-only prefix
`/opt/homebrew/opt/openssl@3`, then failed to find `include/openssl/opensslv.h`.
All four matrix jobs were cancelled after actual failures; this repair does not
establish a green matrix.

`tools/openssl_sdk.py` discovers development headers and a linkable libcrypto
installation. Selection is an explicit `--openssl` prefix, then
`OPENSSL_ROOT_DIR`/`OPENSSL_DIR`, then installed `libcrypto` pkg-config metadata,
then an installed Homebrew formula query on macOS or conventional system SDK
prefixes. Explicit selections and selected package metadata are authoritative:
missing headers/libraries fail rather than silently choosing another SDK.
Linux multiarch and lib64 directories and architecture-specific Windows import
library directories are supported. Paths with spaces remain individual process
arguments. Runtime PATH preparation for Windows uses the selected SDK.

The real probe compiles, links, and executes a C consumer with warnings denied.
It requires OpenSSL 3 headers and matching header/runtime major versions.
Missing SDKs, compilers, link dependencies, or runtime DLLs are failures, never
skips or unsupported-host waivers. Synthetic discovery fixtures only exercise
metadata/path selection; the real-installed-SDK test always executes separately.
No signing implementation, SDK parser, or diagnostic golden is changed.

Run with the assigned artifact directory:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 tools/openssl_sdk.py --probe
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tools -p test_openssl_sdk.py -v
PYTHONDONTWRITEBYTECODE=1 python3 tools/check_portable_x509.py
```

`CARGO_TARGET_DIR` is required for probe/verifier artifacts; there is no local
target fallback. In this producer it points to the assigned T7 target. Probe
compiler scratch, logs, receipt, fixture producer, public certificate vectors,
and native Jai binaries stay there. The X509 verifier now consumes this checkout
or an explicit `--stdlib-root`; it no longer executes legacy peer-source staging.
Its fixture receives the public vector filename as an ordinary command argument.
Certificate generation and extraction assertions remain unchanged.

On this Mac, all 11 discovery tests pass, including a real OpenSSL 3.6.3 SDK
compile/link/run. The X509 verifier passes four C-created public certificate
vectors, six malformed-structure cases, ten interpreter/native O0/O2 runs
(arm64 and x64), Linux/Windows x64/arm64 source checks, and strict lint. Linux
multiarch and Windows import-layout discovery are tested using controlled
metadata; actual Linux/Windows package compilation has not run on this host.

## Sole integration-owner handoff

`test_android_crypto_native.py` and its packaging driver are absent from this
independent checkout. They were not read from peer/quarantined/reference trees.
Their integration remains pending; do not claim that failing matrix test passed.

The owner must replace its hardcoded test prefix with `discover_sdk()` (or an
explicit configured SDK) and pass the descriptor's `cflags` and `ldflags` into
its existing compile/link configuration. Preserve `library`/`include_dir` when
packaging SDK artifacts; do not assume a Linux library lives in `<prefix>/lib`.
Use `sdk.runtime_environment()` for actual native test execution and run the
probe before the package test. The crypto implementation stays unchanged.

Provision development dependencies before Python tests: on Debian/Ubuntu CI,
install `libssl-dev`, `pkg-config`, and the C toolchain; on macOS, use installed
OpenSSL 3 (Homebrew discovery queries the formula rather than assuming its
prefix); on Windows, provision matching-architecture OpenSSL 3 headers/import
libraries/runtime DLLs and set `OPENSSL_ROOT_DIR` when metadata is unavailable.
Missing dependencies must fail. The sole integration owner owns workflow edits,
integration Git operations, and rerunning the original package test/matrix.

Package flags follow the official [pkg-config guidance](https://www.freedesktop.org/wiki/Software/pkg-config/).
OpenSSL documents independently configurable install/library directories in its
[installation guide](https://github.com/openssl/openssl/blob/master/INSTALL.md).
