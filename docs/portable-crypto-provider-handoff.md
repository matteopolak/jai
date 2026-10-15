# Canonical native crypto handoff (host-verified source)

Exact verified owned source commit: **47bf26e**. Adopt crypto-provider.jai,
jks-reader.jai and jks-decryption.jai from that commit; it supersedes 852aa24.

Owner: portable-jks-crypto. No dependency adoption is required to consume this
document. Interpreter/native Mac ARM64 O0/O2, SDK signature cross-checks,
strict context-aware lint and formatting pass using named clean compiler/base
934a6918. The configured Mac dependency build/package workflow and relocated
consumers are now verified; shared assembly invocation and facade adoption remain
integration-owner work. See [native package workflow](portable-crypto-native-package.md).

Portable facade owner must load these files into Android/Toolchain exactly once:

```
#load "../../internal/android-toolchain/crypto-provider.jai";
#load "../../internal/android-toolchain/jks-reader.jai";
#load "../../internal/android-toolchain/jks-decryption.jai";
```

Existing ASN.1 and SHA aliases must remain available. No new signing model or
parser records are introduced. Provider defines the sole `evp_pkey_st`, opaque
`EVP_MD_CTX`, `EVP_PKEY_CTX`, `EVP_MD` and `ENGINE` types. They are native-only
handles; never allocate, dereference, or copy their storage in Jai.

APK consumers use `libressl_get_public_key` / `libressl_get_private_key` for
complete DER inputs and release with `EVP_PKEY_free`. Within the shared
Android/Toolchain module, the implementation-scoped binding provides
`EVP_MD_CTX_new`, `EVP_MD_CTX_free`, `EVP_sha256`,
`EVP_DigestVerifyInit`, `EVP_DigestVerifyUpdate`, `EVP_DigestVerifyFinal`,
and the corresponding DigestSign functions. All status calls return s32.
`EVP_PKEY_is_a(key, nul_terminated_name)` is available for canonical key-kind
checks: use provider type name `EC` to enforce the APK ECDSA algorithm. It returns
1 for a matching type, 0 otherwise. The name pointer must be NUL-terminated;
the caller retains ownership. This binding requires OpenSSL 3, as do its SDK tests.
Provider success is 1. Digest verification final returns 0 for mismatch and a
negative result for error; consumers decide their reviewed failure policy.
`CheckSSL` is fatal for every result other than 1. Callback userdata is a valid
`*#Context`, not a newly allocated substitute context.

Only the eight assigned compatibility procedures are exported. Native ABI and
opaque provider declarations use #scope_module; the DLL library/parser details
are #scope_file. APK implementation files must load into this same module scope.
Do not add a second #import provider instance or export native EVP as an Android
API. Verification uses test-only aliases in its staged facade to access the
same canonical handles; those aliases are never production sources.

Native dependency: `#library "android-crypto/crypto"`. This is installed
distribution-relative, beside crypto-provider.jai in android-crypto/. Native
linking prefers libcrypto.a; interpreter needs libcrypto.dylib (Mac), libcrypto.so
(POSIX), or crypto.dll (Windows), with matching transitive dependencies. No new
environment or module-parameter override.
OpenSSL 3 installed public evp.h, x509.h, types.h and err.h provide the API/ABI
declarations; C long is s32 on Windows and s64 on supported POSIX targets,
size_t is u64 on supported 64-bit targets. tools/build_android_crypto.py constructs
the Mac archive/shared/library-license closure from a configured OpenSSL 3 SDK.
Linux/Windows native packaging remains unverified. Existing runtime overrides
are unchanged; the builder's SDK prefix is only package-construction configuration.

`sign_data` owns/frees temporary key and digest context. It returns an allocated
signature whose caller must `free`. SHA-256 is used over the exact message;
EC signatures use the provider's DER encoding, RSA its default padding policy.
No deterministic EC signature bytes are promised. Parse/trailing input failures
and provider failures log/assert. Do not assume general certificate validation.
