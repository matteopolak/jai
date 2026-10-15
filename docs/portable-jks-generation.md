# Java SDK JKS generation

Current verification2026-10-15: an official Eclipse Temurin25.0.4.1+1 SDK is
staged only under this checkout's artifacts/native-sdk, with SHA256 verified
against the official API metadata. SDK source.zip was excluded; no SDK/Jai source
was used as a compatibility oracle. Receipt: status/portable-java-sdk-receipt.json.
Source: [Eclipse Adoptium releases](https://adoptium.net/temurin/releases).

The ACTUAL public generator now passes interpreter/native Mac ARM64 O0/O2 for
default EC and reviewed zero-size RSA/DSA defaults. Every new runner-owned JKS
store passes actual keytool list; public jks_read/decrypt_private_key recover its
key, preserve borrowed store views, and sign a binary message whose signature
verifies independently through the C SDK against its certificate's SPKI. Twelve
positive workflows run with no fake keytool, success file or user credential input.
Linux/Windows both-CPU source checks and full owned strict lint pass. Evidence:
target/jks-actual-sdk-full.log. The earlier interpreter-only first success is in
jks-actual-sdk-first.log; older absent-SDK evidence below remains historical.

Run `python3 -B tools/check_portable_jks_generation.py --java-bin
/absolute/path/to/official/jdk/Contents/Home/bin`. Without --java-bin only negative
SDK/status tests run and the tool says positive verification was not requested.
Each positive uses a new durable target/ directory; existing stores are never
read/replaced. Java defaults/subject strings, actual format and alias are checked.
The independent signature verifier uses explicit target-only public OpenSSL SDK
composition, not a claim that production crypto packaging is ready.

Remaining limits: larger explicit RSA/DSA size matrix, native Windows/Linux/device,
production bundled crypto package, and generator's existing-destination race /
partial SDK-output cleanup policies. These keep the generator conservatively
partial. Actual positive host generation/read/decrypt/sign is no longer an absent-
Java blocker, but these tests do not establish atomic publication or all SDKs.

android_generate_jks_keystore now has a real SDK command workflow, using the
supplied Java bin directory's keytool executable. The reviewed RSA/DSA size table
is validated before launching; zero selects1024 for either. Default EC uses
secp256r1; explicit nonzero EC size is currently rejected under the reviewed
default-only policy. The canonical returned JKS record owns copies of the path,
alias and password in the active allocation context. Private default constants
remain private; no extra facade exports are added.

Command options use the official [Oracle keytool documentation](https://docs.oracle.com/en/java/javase/25/docs/specs/man/keytool.html):
genkeypair, explicit JKS store type, alias/passwords, distinguished name, algorithm
and size/curve. No fake SDK or test-generated success file is used. A successful
process must also produce nonempty output before the function returns true.
Failure returns false with diagnostics and never fabricates a key record.

Independent policies:365-day validity, quoted/escaped DN values, Java bin argument
interpreted as a directory, refusing an existing destination rather than reading
or updating a credential store. These do not establish exact unspecified reference
behavior. Existing-file refusal is a preflight check, not a concurrency/atomic
publication guarantee; callers must own/exclusively use their destination. Failed
SDK operations may leave their partial newly created output at that caller-known
path. Proper future hardening is exclusive scratch generation/atomic publication
and verified rollback across platforms, without adding override features.

Historical pre-SDK verification: `python3 -B tools/check_portable_jks_generation.py` passed interpreter/native Mac
O0/O2 and strict lint for invalid-size/status and real unavailable-SDK failure.
The missing export was recorded first (target/jks-generation-red.log). Negative
evidence: target/jks-generation-negative.log. The initial host had no Java runtime.
At that checkpoint positive generation was UNVERIFIED and received no success
credit. Those negative tests cannot prove the
SDK would accept every supported positive size/algorithm combination.

The independent positive fixture is ready for an actual SDK:
`python3 -B tools/check_portable_jks_generation.py --java-bin /actual/jdk/bin`.
It refuses an existing runner-owned destination, invokes the real public helper,
checks canonical defaults/owned result paths, actual JKS framing and keytool list.
Its former positive arm was interpreter-only; the current runner above adds real
native/default-algorithm roundtrips. Native other-OS/larger-size gates remain.
No real user keystore or credential/harness data was read.
