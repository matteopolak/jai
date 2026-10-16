# POSIX crash provider: executable lifetime and test setup

Candidate833's admitted Linux upstream evidence reports native crash-handler
initialization status 5 in reflector and jai-tracy. This remains a genuine
required failure, separate from the matrix's missing provider archives. All four
compiler matrix jobs were cancelled with earlier failures, not green. No exact
original Linux argv/provider/source pin has yet established a complete replay
of those upstream failures here.

## Source defect and narrow correction

The matching native builder now produces both a static archive and a shared
provider from one object. When the archive is linked into an executable, the
old initialization path obtains that executable's pathname from `dladdr` and
tries to reopen it with `dlopen`. glibc rejects executable self-loading, including
PIE. See its official [self-loading regression and rationale](https://sourceware.org/pipermail/glibc-cvs/2019q4/067753.html)
and [PIE rejection](https://sourceware.org/pipermail/glibc-cvs/2019q2/067035.html).
The old provider maps that failure to EIO (5), matching the reported symptom.
This establishes a source defect consistent with that symptom; actual Linux
replay is still required before attributing every original failure to it.

`runtime.c::initialize_global` now delegates lifetime selection to a private
helper. On desktop Linux, `dl_iterate_phdr` checks whether the private initializer
address lies in a PT_LOAD segment of the main executable. The loader documents
an empty name for that object and the address calculation includes its relocation
base: [Linux loader interface](https://man7.org/linux/man-pages/man3/dl_iterate_phdr.3.html).
This works for both PIE and non-PIE. Code in that permanent executable already
has process lifetime and needs no pathname reopen.

Shared providers retain the real `dladdr`/`dlopen` RTLD_NODELETE pin and EIO error
handling. A private initializer address identifies the actual provider even if
ELF interposes its exported `portable_crash_init` symbol. No public API, fake
handle, capability, signal selection, assertion, alternate-stack logic or error
suppression is added. macOS/Android retain their existing loader-pin path; the
new ELF executable predicate is desktop-Linux-only.

## Regression and harness setup

The independent C fixture `tests/platform-io/portable-crash-init.c` requires
successful initialization, installed signal-handler flags, a real sufficiently
large alternate stack, repeat-init storage identity and real worker-thread
initialization/join. Shared mode closes the caller's library handle and then
calls the retained provider again, including from the worker, exercising handler
and TLS-destructor lifetime. Linux interposition mode links a separate static
provider into the host executable while loading the shared provider, preventing
public-symbol preemption from falsely classifying that DSO as permanent main code.
No deliberate fault is used by this startup control.

Run the new required native control on each supported CI host:

```sh
python3 tools/check_portable_crash_init.py --out OWN_TARGET/crash-init
```

The runner uses the production `build_plan` and object architecture verifier,
builds into explicit owned storage, and runs O0/O2 consumers. Linux requires PIE,
non-PIE, shared and interposed-shared modes; macOS requires static and shared
modes. Every compile/link/run error remains fatal. Exact command/output bytes,
source hashes and artifact drift checks are retained even on failure. Provider
code uses the production O2 build plan; O0/O2 refers to the control executables.
This does not replace the existing ON/OFF crash, trace-quality or cleanup gates.

Two Python test setup repairs preserve all assertions:

- The library-nonmutation test now explicitly assigns its own temporary compiler
  build root. Without inherited CARGO_TARGET_DIR, the original test fails the
  production compiler-origin check before reaching its mocked dispatch.
- The build-plan test imports the actual adjacent `build_portable_runtime.py`,
  removing dependence on an unprovided PORTABLE_CRASH_TEST_SOURCE environment
  key. It still checks both OSes/CPUs, one matching object, archive/shared output
  identity, target flags and Windows rejection.

These tests use mocks only for harness policy and do not count as native proof.
No production compiler-origin validation or host-provider path is relaxed.

## Evidence and limitations

Both original Mac static/shared baseline controls pass; no Mac native failure is
invented. After the change, four actual Mac ARM64 controls pass (static/shared at
O0/O2), with empty source/artifact drift. Seventeen pure Python tests pass in a
neutral environment with both inherited setup keys removed. Owned Python lint
and format pass; the new C fixture and changed helper region are clang-formatted
and idempotent without reformatting unrelated runtime code.

Official Debian glibc2.41 ARM64 and Linux header packages were fetched anew using
the exact URLs and SHA256 values already admitted in thread SDK provenance.
Both original/changed providers and the control compile at O0/O2 against those
real ARM64 headers with warnings denied, producing six inspected AArch64 ELF
objects. These are object/source checks, not Linux link or execution evidence.
The first extraction omitted package header symlinks and failed on asm headers;
that setup RED is retained. The corrected SDK staging materializes each official
header alias from its exact in-package target bytes. No declaration, macro,
target or compiler warning is substituted. This additional header-copy I/O is
local SDK staging, not a production workaround.

Actual Linux x64/ARM64 native controls and original init-5 upstream replay remain
required. No hardware-fault/trace acceptance is inferred from init-only tests.
ARM64 Windows archive feedback remains pending; earlier source/COFF controls do
not establish native success. The independent native-output durability issue
also remains with the compiler/foundations owners; this batch adds no byte-copy
publication workaround or fallback to the production builder.

Integration must rebuild and install **both matching portable_crash artifacts**
from this new C source before Cargo/native/upstream tests. External native search
directories do not replace the source-relative provider. Common native_verifier
fixture/placement API drift and other provider closure remain separate owners;
do not remove source-restoration safety assertions merely to accommodate an
arity change. No workflow/index mutation is performed by this worker.

Exact inputs, retained REDs, receipts and required native gates are pinned in
[the ready manifest](../status/portable-crash-init-ready.json). Integration owns
the scoped commit and selective docs/README.md link.
