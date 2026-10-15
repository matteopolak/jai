# APK signing owned checkpoint handoff

Owned framing/digest/signing/verification pass Jai interpreter and native Mac
ARM64 O0/O2, independent native crypto checks, strict lint and formatting. See scoped
[inventory](status/portable-apk-signing.json) and
[verification/dependencies](portable-apk-signing.md).

Production facade integration belongs to the original portable owner. When the
checkpoint is reviewed, load these into the existing Android/Toolchain namespace
after the canonical signing model, SHA aliases and archive/android-apk closure:

```jai
#load "../../internal/android-toolchain/apk-signing-model.jai";
#load "../../internal/android-toolchain/apk-signing-framing.jai";
#load "../../internal/android-toolchain/apk-signing-digest.jai";
#load "../../internal/android-toolchain/apk-signing-assembly.jai";
#load "../../internal/android-toolchain/apk-signing-orchestration.jai";
```

Public declarations authored: all four SIGNING_BLOCK_ID_* constants, Algorithm_Id,
Digest_Hash_Algorithm, Digest, Signature, Certificiate, Apk_Signing_Block_V2,
apk_read_signing_block_v2, apk_compute_digest_libressl, apk_sign, apk_sign2 and both
apk_verify overloads. Do not alias these types
through another namespace; load canonical declarations exactly once.
ANDROID_APK_SIGNING_BLOCK_MAGIC remains the existing canonical
definition in archive/android-apk.jai; no second definition is introduced.

The digest uses canonical sha256, ZIP EOCD helpers and Android_Apk. Its exact
reviewed result signature refers to the single module-private SHA256_DIGEST_LENGTH
constant in apk-signing-digest.jai. The provider declares no duplicate constant;
there is no test-only constant or context/provider substitute.

Private helpers: apk_v2_read_container and apk_v2_read_payload are distinct,
checked entry points; they allocate only result arrays and borrow string views.
apk_v2_free_arrays releases arrays and clears the model; callers must retain
source bytes. apk_v2_encode_signed_data, apk_v2_serialize_block and apk_v2_assemble
return caller-owned strings. Assembly copies bytes and changes only the new
output end-record offset. These helpers neither verify credentials nor sign.
The outer reader's verify_structure mode implements reviewed v3/padding/unknown
ID policy without a second parser; its false result must be asserted by the
public verifier for rejected structural preconditions; orchestration does so.

Public apk_read_signing_block_v2 consumes the v2 pair value's signer sequence,
preserving later bytes. apk_sign/apk_sign2/apk_verify use exact clean provider
implementation 47bf26e, handoff d16943e, source files crypto-provider.jai,
jks-reader.jai and jks-decryption.jai. The facade owner must adopt/load those
three files once in the SAME Android namespace before owned orchestration.
No guessed EVP handles, duplicate contexts, CLI-signing fallback, parser fork or
test-only production behavior was added. No native EVP bindings or opaque handles
are re-exported by the APK worker. Source staging adopts exact named dependency
bytes without changing them; that dependency's commits remain provider-owned.

Tests: run python3 -B tools/check_portable_apk_signing.py with assigned
CARGO_TARGET_DIR. It source-builds the formatter and stages named clean base
934a6918 plus only owned current APK files/load changes into T7. Interpreter,
native Mac O0/O2, strict context-aware lint and formatting pass, as do source-only
Linux/Windows x64/arm64 checks. SDK/device/Windows/Linux native execution is not claimed.

Direct-key and JKS output are independently checked with native LibreSSL against
the actual emitted signed data, DER signature, SPKI and normalized content digest.
JKS comes from the installed OpenJDK SDK keytool. This is not Android apksigner
or device validation. Verification stages installed OpenSSL3 static/dynamic libs
at the provider's distribution-relative android-crypto/crypto location. Provider
distribution packaging and shared facade integration remain separate owner work.

Reviewed apk_verify mismatch behavior is intentionally permissive: all three
cryptographic mismatch classes log and still return true. Do not advertise it as
a general security signature-validity predicate. RSA and structural unsupported
forms assert; already-signed sign2 and unknown-keystore sign return false/empty.
