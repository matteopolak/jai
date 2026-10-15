# Portable native helper distribution lookup

Integrator pickup: relocation fix is commit0504879. b0703cb is the separate pending
plugin initializer, not the relocation fix. Build command:
python3 -B tools/build_portable_runtime.py. Install the resulting host-architecture
binary at <selected-stdlib>/internal/runtime/crash-native/libportable_crash.dylib
(Mac) or libportable_crash.so (Linux), beside runtime.c. The current builder uses
the host architecture; universal/multiarch and deployment minimum are packaging
gates, not automatically provided by this fixture.

Exact verification command: python3 -B tools/check_portable_native_package.py.
Evidence target/native-package-red.log and target/native-package-final.log;
actual selected relocated directory/rpath and native OFF/ON signal tests checked.

Assigned-path audit: Runtime's private crash helper is a source-relative #library
reference, crash-native/portable_crash, resolved below the selected stdlib package.
Other audited Runtime/Android helper references are normal system libraries
(libc/kernel32). No portable-owned direct libclang loader was found; the reviewed
ensure_local_libclang_exists overloads belong to the excluded stdlib-tools worker.
Its default bundled source and any direct loader still require that owner's audit.

Genuine packaging defect: the Mac helper build embedded its absolute producer
checkout filename as LC_ID_DYLIB. A copied distribution could link back to that
build tree. tools/build_portable_runtime.py now sets @rpath/libportable_crash.dylib;
the Linux build sets the normal basename SONAME. The existing compiler adds the
selected source library directory as an rpath. No loader override or source-path
special case is introduced, and normal OS linkage stays unchanged.

`python3 -B tools/check_portable_native_package.py` first verifies the helper's
install name, assembles a source-built test distribution, MOVES it before compiling,
and runs actual native crash-handler OFF/ON regressions. otool verifies the compiled
program uses @rpath and the relocated selected package directory, with no producer
helper path. The test clears JAIC_NATIVE_LIBS only in its child environment to
exercise default lookup; parent/user overrides remain unchanged. It passes on the
actual Mac SDK (target/native-package-final.log). The old absolute identity failure
is retained in target/native-package-red.log. Linux SONAME/native execution remains
pending CI, not implied by source flags.

TODO: this direct relative #library does not currently offer a per-helper override.
Native compiler library_args resolves explicit relative paths before generic
library search directories; JAIC_NATIVE_LIBS must not be assumed to cover this
helper or the delegated libclang loader. Existing override behavior is preserved;
no new override feature is implemented.

Packaging handoff: build and include the helper under the installed
stdlib/internal/runtime/crash-native directory for each intended native architecture
and deployment minimum. The fixture explicitly composes that tree; it is not a
claim that coordinator's final release package already includes it. Release builds,
publication and full installed compiler/libclang/native dependency verification
remain held/coordinator-owned.
