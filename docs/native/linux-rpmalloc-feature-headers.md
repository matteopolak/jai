# Linux native allocator SDK feature/header repair

Run718/job117139967856 exposed real Linux ARM64 C compilation failures:
POSIX_MADV_DONTNEED, pthread_key_t/key_create/setspecific, madvise and the
MADV_FREE/MADV_DONTNEED declarations were unavailable. The clean producer
compiled strict C11 and loaded system headers through runtime-dimensions.h
before the pinned SDK body. Enabling features later cannot repair that first
system-header selection.

## Narrow implementation

Only four production files change:
- tools/native_bindings/build_rpmalloc.py requests _DEFAULT_SOURCE=1 and
  _POSIX_C_SOURCE=200809L for Linux compiler commands, before source/header
  processing. Other hosts receive no extra feature flags.
- runtime-domain-post.h explicitly includes pthread.h on non-Windows systems.
  Its callback-domain destructors require pthread keys even when the allocator
  SDK thread cache is disabled; that dependency is independent of cache policy.
- runtime-live.h explicitly includes sys/mman.h on non-Windows systems.
- rpmalloc-heaps/bridge.c explicitly includes sys/mman.h for its own advice calls.

The [Linux madvise documentation](https://man7.org/linux/man-pages/man2/madvise.2.html)
requires _DEFAULT_SOURCE with modern glibc. The
[POSIX advice interface](https://man7.org/linux/man-pages/man3/posix_madvise.3.html)
requires a sufficient _POSIX_C_SOURCE level; the selected200809L supplies it.
Both require the actual sys/mman.h declarations. These feature controls expose
the native SDK API; they do not invent advice constants, change unmapping
policy, disable destructor callbacks or relax warnings.

All23 accepted profiles, six thread-cache-disabled profiles, every profile
option, callback domain, source pin, ABI8 flag and public record remain intact.
No third-party implementation body was inspected or edited; the normal
hash-checked native SDK preparer/compiler consumed its existing official inputs.
No Basic, compiler, FreeType, integration wrapper or dependency manifest changed.

## Real Linux-target compilation evidence

The pre-fix producer was compiled against actual official Debian bookworm
ARM64 glibc/Linux headers using Clang's aarch64-linux-gnu target. It reproduced
the reported missing declarations for default and cache-disabled profiles,
including MAP_ANONYMOUS as an additional affected feature. The before receipt
is retained as linux-arm64-before.json.

The four-file repair now compiles:
- one original header/prototype/constant regression probe;
- all23 SDK profile objects;
- all23 callback profile objects.

All47 use strict C11, -Wall, -Wextra and -Werror, and every resulting object is
checked for actual ELF64/AArch64 identity. No warning is accepted as success.
Final receipt: foundations/linux-native-features-6x01s95s/linux-arm64-final23/report.json.
Its producer/config/profile/test/tool source hashes match before and after.
No object is represented as a linked/running Linux program.

Differential controls additionally preserve two independent REDs: the new
feature flags with old headers still reject pthread function calls; new
headers with old flags still reject memory-advice declarations. This verifies
that one change is not merely masking the other.

The Linux sysroot was extracted entirely into own T7 from official Debian
HTTPS packages. The Release SHA256 entry verifies the ARM64 package index,
and package SHA256 values verify libc6-dev and linux-libc-dev downloads.
linux-sdk-provenance.json records exact versions, URLs and hashes. This is a
real Linux-header compilation check on a Mac host, not the CI runner's exact
sysroot, a Linux linking result, or Linux runtime proof. Actual Linux CI remains
authoritative and must rerun the full normal provider build and ABI queries.

The durable regression tool is tools/native_bindings/verify_linux_rpmalloc_features.py.
It requires original hash-pinned SDK inputs and an explicit output directory.
A non-Linux host additionally requires a real Linux target/sysroot. It prepares
the existing SDK normally, compiles the unchanged accepted profile inventory,
verifies every object and retains complete commands/diagnostics. It never runs
target code. The C fixture uses actual pthread/advice declarations and distinct
SDK advice constants, without stub callbacks or fake header values.

## Fresh native assets and integration

The same four repaired sources were copied into a fresh own producer snapshot.
The normal builder completed138 compile/archive/shared-link commands, producing
92 new Mac ARM64 artifacts for all23 SDK/callback profiles. Twenty-three actual
full build_flags calls match the existing ABI8 revision and every profile bit.
fresh-mac-abi8-result.json records every artifact hash and actual/expected flags;
fresh-mac-source-pairing.json matches the explicit producer input inventory to
the shared repair after building. This Mac proof does not establish Linux
runtime behavior.

An initial post-build source-inventory audit encountered an OS-generated
AppleDouble transport file not present in the source inventory. Its failure
and header bytes remain recorded separately. The corrected audit matches the
actual explicit producer input files, rather than treating incidental copy
metadata as C input or accepting malformed source. No source or compiled
result was changed to pass that inventory audit.

Native source hashes changed. Old173-asset source pins must not be silently
reused or declared source-matched to these headers. Integration must rebuild
affected native assets in a fresh output path and issue new source/asset
receipts for Linux CI and the next candidate/package. No global cache or
dependency manifest was mutated here.

The integration-owned build_ci_native_bindings.py receipt currently includes
the Python builder but omits the actual producer C/header inputs. Integration
has a concrete request to include bridge.c, runtime-domain-post.h,
runtime-live.h and their native header closure in its source guard/receipt.
Its wrapper, full23 query logic and other worker changes are left untouched.

Own bounded native SDK job finished; the slot is released and no child remains.
There were no allocator benchmarks, GUI/fault programs, publications, Git/index
operations or remote CI actions. Source/config lint and C fixture formatting
pass. [Exact ready source/patch/evidence hashes](../status/foundations-linux-native-features.json)
identify the narrow cohort and pending authoritative Linux verification.


Integration adopted the exact ready production files and now guards independent native C/header inputs in build_ci_native_bindings.py. The same Linux feature macros also precede the wrapper's three counter translation units, including the adaptive SDK source consumer. Two command-contract controls verify Linux flag ordering and unchanged Mac policy. This additional wrapper omission was found during integration; it is not a Linux runtime result.

Fresh own Mac build-only construction produced92 SDK/callback artifacts across all23 ABI8 profiles plus four counter artifacts. The first attempt lacked the pinned official native C input and compiled nothing; that setup failure is retained. A native-only, hash-checked fetch supplied exactly the declared rpmalloc files into ownT7, then the retry built successfully. Full23 native flag queries are queued behind the generator's bounded runtime slot. No old aggregate source/asset pair is reused after these header changes; actual Linux link/lifecycle remains CI-required. Header fixture formatting uses explicit LLVM SortIncludes:Never to retain include order; default include sorting alone reports a difference, with no compiler diagnostic waiver.
