# Shared portable verification

The integration owner adopts only the owned ASN.1/Socket files from `67c9dc52`,
the canonical crypto/JKS implementation from `47bf26ec`, native package tooling
from `cd8a6c33`, and APK signing from `3e89682b`. Existing shared null safety and
the private canonical POSIX TIMEVAL alias are preserved. Android/Toolchain loads
each implementation once, in its original module namespace. Producer specs and
inboxes do not replace the coordinator's current files.

Build the workspace tools with `cargo build --locked --workspace --bins`, using
the integration owner's separate CARGO_TARGET_DIR. Construct the native dependency
with `python3 -B tools/build_android_crypto.py --openssl-prefix
/opt/homebrew/opt/openssl@3 --stdlib stdlib`. Generated native outputs are ignored;
the builder records their hashes, actual SDK version, licenses and loader closure.

Run `python3 -B tools/check_shared_portable.py` with that same CARGO_TARGET_DIR.
The runner uses the actual combined `stdlib`, without replacing any source,
facade, context, provider or compiler. It retains every assertion in nine public
fixtures and checks the private-provider rejection. Native executions use ARM64
O0. Inputs are hashed after every command; timeouts/failures remain failures.
The JSON report and command output go under ignored artifacts/shared-integration.

Producer staging runners remain diagnostic tools and are not production proof.
In particular, the private APK framing fixture and EVP test aliases still need
owner reconciliation into independent unit coverage; the new public runner does
not certify those fixtures. It does execute the public APK orchestration fixture,
including real direct-key/JKS signing, structural/mismatch assertions and native
SDK verification of emitted signatures and content digests. Android device/SDK,
Windows/Linux native, x64 and O2 execution are not covered by this baseline.

APK verification intentionally logs cryptographic mismatches while returning
true, as specified; callers must not treat it as a general signature-validity
predicate. The OpenSSL3 provider uses opaque native-owned objects and the reviewed
compatibility names. No EVP declarations are added to the public facade.

The reported all-zero PDB/CIE corruption is still an open integration failure.
Seventeen retained inputs in the integration owner's former target were inspected
and were nonzero; this does not identify or explain the reported corrupt inputs.
Shared native input generation must be serialized, with immutable hashes checked
through all consumers. The coordinator must identify the failing input/command
or supply an independent reproducer before that failure can be closed.
