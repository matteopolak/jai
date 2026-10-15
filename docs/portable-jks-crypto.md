# Owned JKS protection and canonical EVP provider

Scope: jks_read, jdk_decrypt_private_key, decrypt_private_key, native complete-DER
key readers, CheckSSL/error callback, and sign_data. Direct-key generation,
Java keystore generation, APK parsing/digests/framing, and facade integration
retain their assigned owners. See [provider handoff](portable-crypto-provider-handoff.md).

JKS parsing consumes checked, network-order lengths. It supports exactly one
private-key entry, returns the last X.509 chain certificate, and verifies the
integrity digest before publishing borrowed views. Version 1 is supported only
without certificates. ASCII passwords become UTF-16BE bytes, including embedded
ASCII NUL. Wrong passwords, malformed input, unsupported entries/version/chain
encoding, and extra bytes log/assert. If an assertion handler returns, owned
code exits safely without publishing partial results; this adds no recoverable
error promise to the reviewed public contract.

The protection design uses a 20-byte salt, SHA-1(password || previous block)
keystream XOR, and SHA-1(password || recovered bytes) integrity check. The wrapper
reuses the existing ASN.1 parser and compares the Sun OID's active arcs. It accepts
absent/NULL algorithm parameters and rejects other parameter encodings. Failed
plaintext and temporary password/hash concatenations are overwritten and freed;
this is cleanup behavior, not a guarantee against optimizer removal or paging.
Successful plaintext is caller-owned and should be freed after use.

The provider uses installed OpenSSL 3 public headers, not native library bodies.
It binds real complete-key parsers and EVP SHA-256 signing/verification, preserving
the public libressl names. It never embeds a private EVP structure layout. Every
key requires EVP_PKEY_free; digest contexts require EVP_MD_CTX_free. Signatures
are ordinary caller-freed allocations. Error callbacks use the supplied context
and synchronously drain the provider error queue. The installed production
library path is relative to the binding: android-crypto/libcrypto.a and (for
interpreter calls) libcrypto.dylib or target equivalents. Windows uses 32-bit C long;
POSIX uses 64-bit C long on supported 64-bit targets. No new override feature exists.

Verification runner: `python3 -B tools/check_portable_jks_crypto.py`. It uses only
this clone, named supplied clean dependencies, own source-built compiler and
assigned T7 storage. It does not invoke older producer overlay scripts. Generated
fixtures/binaries are rebuilt from current sources and are never committed.
`--sdk-only` repeats the independent SDK fixture and C ABI checks without
invoking Jai. `--fixtures-only` writes the deterministic hashlib vectors.

The full base is the explicitly authorized production snapshot 934a6918 in
artifacts/verification-base-934a6918/stdlib. The runner overlays only the three
owned source files and stages exact facade loads plus test-only native aliases.
The original partial portable stdlib never overwrites the complete base.

Verified: interpreter and native Mac ARM64 O0/O2 for all four programs, strict
context-aware lint, formatting, and Linux/Windows x64/ARM64 source checks. The
48 independent hashlib cases cover empty/NUL passwords, SHA/keystream boundaries,
absent/NULL parameters, borrowed certificate/key pointers and counted allocation
release. Negatives cover every store/wrapper prefix, nine authenticated malformed
store cases, eight malformed wrappers, unsupported OID/parameters, bad passwords,
non-ASCII passwords and wrong/trailing native key input. Callback tests verify
supplied context, synchronous queue draining, every non-1 CheckSSL status tested,
and exact explicit caller location. Native EVP exports are checked to stay private.

Fresh OpenJDK 26 keytool JKS integrity/decryption and certificate public key agree
with the independent fixture design and the Jai implementation. Fresh SDK EC/RSA
PKCS8/SEC1/PKCS1 keys exercise exact-message and empty-message signatures, signature
mismatches, key-kind checks and repeated key/context release. OpenSSL independently
verifies EC, RSA and JKS-derived signatures from each execution mode. The installed
public-header C ABI/context checks pass O0/O2. Evidence:
`$CARGO_TARGET_DIR/jks-crypto-verification.log`; deterministic vectors SHA-256:
36110ac1fbcc27adac3c38a08c9d742d3ff14599efdd46448b490462971a6edc.

The [configured Mac native package workflow](portable-crypto-native-package.md)
now builds the shared dependency from the SDK archive and verifies moved
distribution interpreter/native consumers with original configured prefixes gone.
Shared distribution assembly invocation, facade adoption, native Windows/Linux/device
execution and coordinator-only reference oracle remain integration and platform
gates. Foreign-target source checks do not establish native execution.
No global inventory totals have been changed. The earlier missing runtime-config
dependency was resolved by the exact named complete production stdlib handoff.

Public documentation used: [OpenSSL digest signing](https://docs.openssl.org/3.0/man3/EVP_DigestSignInit/),
[OpenSSL private-key decoding](https://docs.openssl.org/3.0/man3/d2i_PrivateKey/),
and [Java KeyStore public API](https://docs.oracle.com/en/java/javase/24/docs/api/java.base/java/security/KeyStore.html).
The proprietary JKS protection design was independently checked against fresh
installed SDK output; no upstream implementation bodies were used.
