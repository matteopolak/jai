# Linux ARM64 Thread SDK storage repair

Actual ac174e80 Linux ARM64 CI job 117150697309 reports native SIGSEGV for
thread synchronization/lifecycle/group cases. Its supplied native logs identify
exit -11 without a fault site. Interpreter Thread/audio failures separately
identify pthread_setname_np with an invalid address near 0xd2. Do not equate
those two observations or claim a common native fault site.

The current interpreter's pthread_create/self return scheduler IDs rather than
libc pthread_t values. Both interpreter naming dispatchers lack setname/getname
routing. Compiler ownership covers that identity boundary; this stdlib batch
does not edit Rust, suppress names, change parameter counts or add a library
workaround.

Independent SDK verification found a separate production ABI defect. The
[glibc ARM64 public header](https://raw.githubusercontent.com/bminor/glibc/release/2.41/master/sysdeps/aarch64/nptl/bits/pthreadtypes-arch.h)
specifies larger mutex and mutex-attribute storage than x64. Own Debian glibc
2.41/Linux headers were acquired over official HTTPS, with Release-to-package
index hashes and package SHA256 verification. The C control compiles against
that real ARM64 sysroot. No Jai implementation or peer SDK tree was copied.

| Binding | Old ARM64 | Required ARM64 | Preserved x64 |
| --- | --- | --- | --- |
| pthread_mutex_t storage | 40 | 48 | 40 |
| pthread_mutexattr_t storage | 4 | 8 | 4 |
| pthread_mutex_t alignment | 8 | 8 | 8 |
| pthread_mutexattr_t alignment | 4 | 4 | 4 |

Only these two Linux declaration records change. Canonical names, existing
fields, overlay organization and x64/Mac declarations remain. The wider mutex
storage contains native writes instead of placing adjacent fields inside the
SDK object. Thread lifecycle/state, naming calls, allocator use and public Thread
record layout are unchanged. This repairs a demonstrated SDK size mismatch;
the original native SIGSEGV remains CI-pending rather than assumed solved.

Test corrections are distinct from production: the first independent C test
incorrectly expected mutex-attribute alignment 8. Real SDK compilation reported
alignment 4; the test was corrected before production edits. The first full
verification also incorrectly requested POSIX lint in a Windows-only context
and found three fixture formatting issues. Those failed receipts are retained;
the final run requests the actual loaded target files and formats all fixtures.

The independent Jai layout regression failed before the production change on
Linux ARM64's mutex-size assertion. It now passes. The C public-header control
checks ARM64 sizes/alignment, creates a gated real pthread, compares its returned
identity with pthread_self, names it with the platform-specific SDK signature,
joins its actual result and destroys synchronization objects. Separate Jai
controls compare C SDK sizes/alignment, place canary bytes after a mutex across
real SDK init/destroy, and perform 16 named suspended Thread lifecycle cycles
while checking native identity, context index, completion and teardown.

Final receipt: 56 passing commands, including 32 Windows/Linux/Mac x64/ARM64
source checks, six complete strict-lint contexts, formatting, fresh locked
compiler/tool builds, real ARM64-header compilation and five actual Mac native
programs. The Mac programs comprise one C creation control and the Jai storage
and lifecycle controls at O0/O2. Full shared Rust/stdlib source drift is empty.
The host slot is released, all children reaped. Cross compilation and Mac
execution are not Linux native execution.

[Ready manifest](../status/thread-linux-runtime-ready.json) contains exact
production/test/tool/doc hashes, SDK package/header provenance, compiler hash,
failures and final receipts. Integration alone stages/commits and maintains the
global README link. Linux native replay must include the original thread,
synchronization, group and audio cases after both separately owned fixes.
No tests are waived and no Linux runtime success is projected.

Further binding inventory, outside the direct Thread repair, should verify
ARM64 pthread_attr_t and pthread_condattr_t storage and internal mutex field
types against the public SDK. Thread currently passes null for those attribute
records; this batch does not claim the whole POSIX binding is audited.
