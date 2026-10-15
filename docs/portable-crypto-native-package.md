# Configured native OpenSSL 3 package for Android/Toolchain

Exact native workflow source commit: **cd8a6c3**. Canonical provider sources remain
the accepted **47bf26e** checkpoint.

The crypto-specific workflow is tools/build_android_crypto.py, configured by
tools/android-crypto-native.json. It consumes an installed, trusted OpenSSL 3 SDK
and uses its actual libcrypto.a. It preserves that archive for Jai native links
and links a shared libcrypto.dylib from the same archive for interpreter calls.
There is no compatibility shim, reconstructed OpenSSL implementation, upstream
body inspection or implied source-build of OpenSSL itself. The shared dependency
is a real native linker build from the configured SDK's binary archive.

Configure the package build explicitly:

```sh
python3 -B tools/build_android_crypto.py \
  --openssl-prefix /path/to/configured/openssl-3-sdk \
  --stdlib /path/to/distribution-staging/stdlib
```

The SDK must contain public headers under include/openssl/, lib/libcrypto.a,
LICENSE.txt and AUTHORS.md. Headers must declare major 3. Actual static/shared
runtime version probes must agree with the header version. The real canonical
EVP ABI harness links and executes against each artifact before installation.
Only actual Mac construction is implemented; a non-Mac invocation rejects the
request rather than create an unverified target package.

The output directory is
stdlib/internal/android-toolchain/android-crypto/, beside crypto-provider.jai:

- libcrypto.a: exact configured archive, used by native link preference.
- libcrypto.dylib: built from the archive with @rpath/libcrypto.dylib identity.
- licenses/openssl/LICENSE.txt and AUTHORS.md: unchanged upstream notices.
- provenance.json: SDK/archive/manifest/output hashes, version probes,
  architecture, loader identity and dependency closure.

The shared library may depend only on Mac system libraries/frameworks. Unknown
third-party dependencies fail construction, so they cannot be silently omitted.
Both the observed shared dependency closure and real static-link probes are
checked. The verified SDK is OpenSSL 3.6.3, arm64; shared closure is solely
/usr/lib/libSystem.B.dylib. Ad-hoc signing of the local built dylib satisfies the
Mac loader; this is not distribution signing, notarization or release work.

The [OpenSSL default provider](https://docs.openssl.org/3.0/man7/OSSL_PROVIDER-default/)
supplies the algorithms used by these consumers. This package uses the built-in
default provider; it does not require external legacy/FIPS modules for the tested
JKS/EC/RSA paths. It does not package or promise arbitrary externally configured
providers. OpenSSL 3 is [Apache-2.0 licensed](https://openssl-library.org/source/license/index.html);
the actual configured SDK license and author notices travel with the artifacts.

For the integration worker: retain ownership of tools/native-libs.json,
tools/build_native_libs.py and distribution assembly. Invoke this configured
crypto builder against the selected staging stdlib after staging the canonical
provider. The relative #library android-crypto/crypto name needs these artifacts
beside its source, rather than a global search-directory manifest row. Do not
represent this linker build as a fake generic C compilation unit. No shared file,
release workflow, release build, dispatch, tag, push or publication was performed.
The CLI prefix is a construction input, not a new runtime override. Existing
runtime overrides retain their behavior; new runtime override features remain TODO.
The builder requires tests/native/android-crypto/abi.c from accepted checkpoint
47bf26e and the new package-version.c in addition to its two crypto-specific tool
files. This is an exact own-source dependency; no peer producer source is needed.

Verification:

```sh
python3 -B tools/test_android_crypto_native.py
python3 -B tools/check_android_crypto_package.py
```

The three packaging tests cover actual artifact/ABI/version/license/provenance
construction, missing SDK rejection and unsupported major rejection. The Mac
relocation gate uses only named clean compiler/stdlib 934a6918 and the accepted
three provider files. It builds the crypto package from a disposable configured
SDK copy, stages the actual consumers and compiler, moves the distribution into
a path containing spaces, and deletes the original configured SDK/build/source
prefixes. It then compiles native consumers from the moved distribution and
executes all four programs in interpreter/native O0/O2: 12 real executions.
EC/RSA/JKS signatures from each mode are independently checked using the SDK tool.

DYLD_PRINT_LIBRARIES records actual loaded images for every execution. The two
interpreter EVP consumers load only the moved libcrypto.dylib; pure JKS consumers
need no EVP image. Native executables load no shared crypto and have only system
dynamic dependencies. Hiding the moved dylib makes interpreter EVP calls fail,
even though the original installed Homebrew SDK remains available. That original
SDK is never moved or modified and cannot appear in consumer loaded-image records.
The compiler's existing LLVM dependency remains its owner's packaging scope.

The host rejected nested sandbox-exec with sandbox_apply: Operation not permitted.
Therefore the test proves actual removal of disposable configured prefixes,
loaded-image origins and absence of SDK fallback; it does not claim an OS denial
of the still-installed Homebrew SDK. No successful nested sandbox was inferred.

Evidence in assigned T7: android-crypto-package-verification.log and
android-crypto-relocation/loaded-images.json, plus the moved package's provenance.
Native Linux/Windows/device, native x64, minimum deployment compatibility, and
actual release assembly remain unverified. Previous Linux/Windows x64/ARM64 Jai
source checks are separate evidence and do not close these native gaps.
