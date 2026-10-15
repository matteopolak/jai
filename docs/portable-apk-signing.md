# APK signing framing and digest

This worker implements new APK signing internals from the reviewed contract and
the [official Android wire format](https://source.android.com/docs/security/features/apksigning/v2).
Existing archive/android-apk remains the APK partitioner; ZIP loading is reused.
No peer checkout, reference compiler, original implementation or oracle is used.

The new model keeps canonical enum names, record fields and `Certificiate`
spelling. Checked internal readers distinguish the whole outer signing container
from its v2 payload, require one ECDSA/SHA256 signer and one digest/signature/cert,
reject attributes and malformed lengths, and borrow all encoded string storage.
Only result arrays are allocated; `apk_v2_free_arrays` releases those arrays and
zeroes the record without freeing input bytes. Unknown outer IDs can be skipped.
The verification-policy mode uses the same reader: it rejects v3 and nonzero
verity padding, accepts all-zero padding, and logs/skips v3.1 and unknown IDs.

The SHA256 digest routine hashes content, central directory and end record as
separate sections. It temporarily normalizes the end record's central-directory
offset and restores it through defer. Serialization builds a single v2 block
from digest/certificate/signature/SPKI bytes; assembly inserts it before the
central directory and updates the copied end record. The public reader consumes one
length-prefixed signer sequence from the v2 pair value and leaves later bytes
untouched. Unsupported or malformed values log and assert.

`apk_sign2` uses canonical provider sign_data to produce a single ECDSA/SHA256
signer and one certificate. It enforces EC keys, checks private/certificate key
agreement, refuses already-signed APKs and returns a caller-owned complete APK.
`apk_sign` reads the supported JKS entry, delegates decryption and signing, and
wipes/frees its decrypted key. Caller-supplied direct key/certificate buffers are
never freed or wiped by the signer.

Both `apk_verify` overloads preserve the reviewed compatibility behavior:
unsigned APKs return false; signature, content-digest and certificate-key
mismatches log but do not change the eventual true result. Unsupported structure
or crypto preconditions assert. Consequently this API is not a security validity
predicate, even though it executes genuine native cryptographic checks.

`tools/build_portable_apk_signing_fixtures.py` generates independent Python
hashlib/struct/zipfile vectors, including chunk boundaries and ZIP comments.
`tools/check_portable_apk_signing.py` stages the named clean production dependency
closure 934a6918 and overlays only current owned APK files into the assigned T7
target. It adds owned loads and private test checks to that staged module. The
production facade is never changed.
It loads the exact canonical provider sources from named implementation 47bf26e,
handoff d16943e, once into the same Android module. Verification stages installed
OpenSSL 3 libraries beside that provider; production packaging is separate.
Framing fixture credentials deliberately are not DER certificates or signatures.

`tools/build_portable_apk_signing_native_vectors.py` additionally generates an
independent EC P256 certificate, PKCS8 key, DER signature and signed ZIP using
the installed native CLI. It verifies SHA256 chunk digests against hashlib,
verifies the signature and rejects a modified signed message. CLI operations
follow [public digest/signature documentation](https://docs.openssl.org/3.0/man1/openssl-dgst/).
This tool creates test vectors; it is not a production signing fallback.
An installed OpenJDK keytool creates a fresh EC JKS store using
[public SDK commands](https://docs.oracle.com/en/java/javase/26/docs/specs/man/keytool.html).
Actual Jai direct-key and JKS output signatures and content digests are checked
independently with the native CLI after each execution mode.

## Verification state

- Authorized compiler archive 934a6918, supplied by coordinator and containing
  89560db9, builds jaic-cli and jailint from source into the assigned T7 target.
- Python fixture generation and independent list/incremental digest formulation
  comparisons execute successfully. zipfile reads the independently framed ZIP.
- Native vector generation passes with installed LibreSSL 3.3.6: EC P256/SHA256
  signing, verification, tamper rejection and chunk-boundary digest comparisons.
  Jai provider calls use the named OpenSSL 3 dependency, and their generated APK
  signatures independently verify with the separate LibreSSL CLI.
- Jai interpreter, native Mac O0/O2, context-aware strict lint and formatting
  pass for constants/models, public cursor consumption, borrowed bytes, allocator
  ownership, malformed-input assertions, SHA512 rejection, digest restoration,
  native-standard DER framing and byte-exact ZIP assembly. The lint manifest
  reports a complete context and no unvisited requested files.
- Direct-key and actual SDK-generated JKS signing, verification, already-signed
  and unknown-keystore refusal, mismatch logging with true, RSA rejection and
  v3/padding/algorithm-list structural assertions pass in all three host modes.
- Linux/Windows x64/arm64 source checks pass. These are not native execution.
- The initial missing runtime-config/POSIX closure is resolved by the exact
  coordinator-supplied production snapshot artifacts/verification-base-934a6918.
- Android APK SDK verification, device installation and Windows/Linux native
  execution have not been validated. apksigner is not
  on PATH and Android SDK environment paths are unset.

Public reader/orchestration compatibility questions are recorded in
[the scoped spec questions](specs/stdlib/modules/android-apk-signing-questions.md).
The global inventory is unchanged. The scoped inventory records verified
supported APIs separately from shared facade integration, native distribution
packaging and platform/SDK/device gaps. Named dependencies remain owner-owned.
