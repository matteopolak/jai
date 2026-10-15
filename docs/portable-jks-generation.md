# Java SDK JKS generation

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

`python3 -B tools/check_portable_jks_generation.py` passes interpreter/native Mac
O0/O2 and strict lint for invalid-size/status and real unavailable-SDK failure.
The missing export was recorded first (target/jks-generation-red.log). Negative
evidence: target/jks-generation-negative.log. This host has no Java runtime.
POSITIVE JKS GENERATION IS UNVERIFIED and receives no completed functionality
credit; source is implemented but partial. Those negative tests cannot prove the
SDK would accept every supported positive size/algorithm combination.

The independent positive fixture is ready for an actual SDK:
`python3 -B tools/check_portable_jks_generation.py --java-bin /actual/jdk/bin`.
It refuses an existing runner-owned destination, invokes the real public helper,
checks canonical defaults/owned result paths, actual JKS framing and keytool list.
Its current positive arm is interpreter-only; native positive/algorithm matrix,
Windows source/native and EC explicit-size edge remain future gates, not skipped
checks counted green. No real user keystore or credential/harness data was read.
