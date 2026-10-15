# Direct signing-key generation

The reviewed android_generate_signing_key_direct workflow now generates real
EC/P-256 or fixed RSA-2048 material and a self-signed certificate. key_size is
intentionally ignored, as reviewed; DSA returns false. The returned canonical
Android_Signing_Key uses ASN1_CERTIFICATE_AND_PRIVATE_KEY, with owned path strings
allocated in the active context. The function does not read any existing key,
user keystore or harness credential. Tests use only freshly generated fixture keys.

This supported POSIX backend invokes the installed native OpenSSL/LibreSSL tool
through real Process.run_command calls. Its req/pkcs8/x509 commands must be
available on PATH. Exit/launch/timeout failures return false and report diagnostics;
there is no fabricated output, shell script, compiler CLI shortcut or C library
implementation vendored here. Native Windows backend remains explicitly
unsupported with an error result/diagnostic, pending later platform work.

Every generation creates a new private0700 directory under out_path using real
mkdtemp. Its prefix comes from key_name; output filenames also contain key_name.
Repeated names produce distinct directories and leave existing keys untouched.
Certificate output is DER X.509 and private-key output is unencrypted DER PKCS#8,
with0600 permissions. A private minimal request configuration supplies the req
section; no user crypto configuration is loaded. Intermediate PEM/config files
are deleted before success. SDK failure removes generated files and the private
directory; any cleanup failure is explicitly diagnosed. Public paths survive the
function; callers free their strings and manage the returned files/directories.

Independent policies where the reviewed page does not specify exact choices:
self-signed SHA-256 certificate with365-day validity, private unique directory and
DER filename conventions, rejecting empty/path-separated/NUL key names, POSIX
crypto-tool dependency and fixed result encodings. These are real supported
choices, not claims about original private behavior. Proper longer-term work may
add a licensed native C ABI backend and Windows exclusive directory/file handling
without changing canonical public key models or accepting fake crypto success.

`python3 -B tools/check_portable_direct_key.py` passes interpreter/native Mac O0/O2
and full owned strict lint. Native crypto tooling independently parses DER,
matches certificate/private public keys, checks256/2048-bit sizes, verifies the
self-signature, inspects escaped CN/organization, and checks0700/0600 modes and
intermediate cleanup. Real SDK rejection of an invalid country code returns false
and leaves no private output behind in all three modes. Repeated generation uses
distinct paths; DSA is rejected. Native Linux/Android/Windows execution is not
claimed. The machine has no Java runtime, so JKS generation has not been faked or
counted complete.

Test corrections, separate from production: initial test misspelled the reviewed
key-kind member and reused a local binding; both corrected. A first draft expected
duplicate names to fail despite no such reviewed policy; it now checks distinct
outputs and preserves original material instead. SDK investigation established
that an empty req configuration lacks distinguished_name; the production fix
writes a minimal private config. Initial missing-export evidence is
target/direct-key-red.log; SDK failure evidence is direct-key-sdk-failure.log;
successful verification is direct-key-final.log.
