# Linux OpenSSL package closure

`build_android_crypto.py` delegates Linux construction to the independent
`android_crypto_linux.py` helper. Darwin's existing build body is unchanged.
Discovery and cryptographic implementations are unchanged. The build accepts
either an explicit prefix or `--openssl-sdk-descriptor FILE`, containing the JSON
serialization of the canonical `OpenSSLSDK` record. The real-package test passes
that full descriptor so pkg-config multiarch paths and compile flags survive.

Linux requires installed OpenSSL 3 development headers, its real `libcrypto.a`
and shared ELF library in the discovered library directory, a native C compiler,
`readelf`, `ldd`, and attributable license notices. Debian/Ubuntu CI should install
`libssl-dev`, `pkg-config`, `build-essential`, and `binutils`; package ownership and
copyright notices are obtained with `dpkg-query`. RPM installations use `rpm` and
their installed license files. A standalone SDK may provide its actual `LICENSE`
or `LICENSE.txt` and optional `AUTHORS.md`. Missing inputs fail the build.

The package contains the archive, the actual ELF SONAME file, a `libcrypto.so`
link, installed license notices with their real names, and `provenance.json`.
No Mach-O filenames, install identities, or invented license files are generated
on Linux. All license-owning packages must supply notices. Public-header closure
comes from the compiler's dependency output, including configured multiarch
headers. Provenance records source paths and SHA256 for those headers, archive,
shared library, notices, and resolved system runtime dependencies. System runtime
libraries remain host requirements; they are recorded rather than redistributed.
Unexpected direct or transitive dependencies fail construction. This closure
currently covers native glibc Linux installations; Windows packaging is unverified.

Before publication both admitted C consumers are compiled with warnings denied
and executed against both packaged library forms. Their version result must match
the public SDK header. A separate `dladdr` probe verifies that executable-relative
RUNPATH loads the staged SONAME file. Publication occurs only after these checks;
the `linux_native_verified` receipt is emitted only by a successful native build.

The original three package test methods remain present. Darwin expectations stay
the same; Linux expectations require its genuine SONAME, library link, license
closure, complete package hashes, and runtime versions. Both negative methods and
both C consumers are unchanged. Parser tests exercise missing SONAME, unresolved
runtime paths, foreign dependencies, multiarch headers, and missing attribution;
they do not emulate successful native packaging.

Run from the integrated producer with its assigned `CARGO_TARGET_DIR` and
`CARGO_BUILD_JOBS=2`:

```sh
python3 -B -W error -m unittest discover -s tools -p test_android_crypto_linux.py -v
python3 -B -W error -m unittest discover -s tools -p test_android_crypto_native.py -v
```

Producer verification includes source guards, nine parser/source tests, eleven
SDK-discovery tests including a real SDK probe, and eight actual Mac C ABI/version
compile/run controls at O0/O2 with OpenSSL 3.6.3. These are not Linux execution.
The current admission lacks `tools/android-crypto-native.json` and
`tools/portable_toolchain.py`, so the full package test must run in integration.
Linux `test_real_sdk_package` and the compiler matrix remain required; no CI-green
claim or host waiver follows from the source-only Linux checks.
