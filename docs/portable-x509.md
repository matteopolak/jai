# DER certificate public-key-info extraction

Reviewed API: Android/Toolchain x509_get_subject_public_key_info(certificate_data)
returns the canonical ASN1_Value. Its content and complete encoded value_data
remain borrowed views into the caller's certificate storage. Private independent
schema traversal lives in internal/android-toolchain/x509-structure.jai.

Supported input is DER X.509 Certificate containing a TBSCertificate sequence,
optional explicit version0..2, serial, signature algorithm, issuer, validity,
subject and SubjectPublicKeyInfo. The extractor checks structural tags, skips
fields without narrowing their contents, and returns the key-info SEQUENCE.
Twenty-byte serial numbers are preserved; they are never decoded through the
s64 INTEGER helper. Optional v3 extensions after the key do not change selection.
Malformed/truncated/wrong required fields diagnose and return an empty record if
assertions deliberately continue; private boolean parsers prevent fake success.
This locates the public-key structure; signature/trust validation remains separate
unfinished public crypto functionality. No production native crypto dependency.

The declaration does not establish PEM input, concatenated/trailing certificate
handling or whole-certificate validation/error recovery. The implementation reads
the first encoded certificate and locates key info; those finer input policies
remain independently documented supported choices pending review. No additional
PEM export, success result or deinit API is invented.

Run python3 -B tools/check_portable_x509.py [--openssl official-install-prefix].
Its independently written C fixture uses official native OpenSSL3 headers/API:
[X509 public-key access](https://docs.openssl.org/3.0/man3/X509_get_pubkey/),
[version API](https://docs.openssl.org/3.0/man3/X509_get_version/).
It creates four real v1/v2/v3 certificates using newly generated ephemeral
Ed25519/RSA keys, signs and verifies each, serializes public certificate DER and
native SubjectPublicKeyInfo, then frees keys without writing private material.
User OpenSSL configuration loading is disabled; no existing key/credential/auth
or external service is read. C errors and all writes are checked; no fixture
success is fabricated. This is test-only native-library integration.

All four extracted value_data blobs match actual native i2d_X509_PUBKEY output;
pointer ranges and mutation prove shared caller backing. Six malformed structural
cases verify error/assertion counts after restoring fatal result checks. Ten
interpreter/ARM64+x64 native O0/O2 executions pass. Separate source-only gate
instantiates the public body for Linux/Windows x64/ARM64; its invalid input is not
executed or counted as behavior. Strict scoped lint and formatting pass.
Evidence: target/x509-extraction-red.log and x509-extraction-first.log. The first
actual behavior run passed; no inherited test correction or production workaround.
Native Linux/Windows/Android execution remains pending. SDK/device/signing/APK
verification is not inferred from this portable structural extractor.
