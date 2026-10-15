# Canonical crypto packaging plan

Use a configured installed OpenSSL3 SDK, public headers and upstream license.
Preserve its actual libcrypto.a for static Jai native linking. Build a shared
libcrypto.dylib from that same SDK archive using the native linker, with relative
Mach-O identity and no undeclared non-system dependency. The default provider is
built into libcrypto; external legacy/FIPS modules are outside this package.

1. Write failing crypto-specific workflow tests for output license/provenance,
   rejected unsupported versions, missing artifacts, ABI and dependency policy.
2. Implement new tools/android-crypto-native.json and build_android_crypto.py.
   Build shared code from the real archive; link/run header ABI checks against
   both artifacts and copy license/author notices into the installed directory.
3. Compose only named clean dependencies and owned crypto files in assigned T7.
   Stage fixtures/test consumers/compiler inside the distribution, then move it.
4. Deny loader reads to original source/build/SDK prefixes with a child sandbox.
   Prove denials with reads, execute actual JKS/signature consumers in interpreter
   and native Mac O0/O2, verify signatures independently outside the sandbox,
   and inspect dyld loaded images: only moved crypto shared library for interpreter,
   no crypto shared library for statically linked native executables.
5. Document exact configured packaging invocation for integrator-owned native
   manifests without editing shared files. Commit workflow/tests/docs and scoped
   evidence, retaining Linux/Windows/device and actual release-workflow gaps.

No release workflow, release build, tag, push, publication, peer checkout access,
reference execution or new runtime override is part of this work.
