# Watcher unlock and selected-distribution helper

Two production defects were independently reproduced and fixed.

The private registry unlock compare_and_swap was evaluated inside optional
Basic.assert. A valid public init then process_changes deadlocked when the STAGED
default Basic ENABLE_ASSERT=false. New lifecycle checks use unconditional exits;
eight init/poll/deinit cycles pass enabled before the fix but the disabled
interpreter times out. Original evidence: target/watcher-assertion-red.log.
The CAS now executes outside assert; the invariant assertion still validates its
result. No public API/layout/storage change or disabled coverage.

`python3 -B tools/check_portable_watcher_assertions.py` now passes both actual
default configurations in interpreter/native Mac O0/O2 and whole owned strict lint
(target/watcher-assertion-final.log). This new fixture checks empty-root lifecycle;
it does not replace actual event testing. `check_portable_watcher.py` reruns the
full real FSEvents callback/recursion/overflow/captured-allocation cleanup suite in
interpreter/native ARM64/x64 O0/O2, plus ASan/UBSan C SDK queue/lifetime/retry tests
(target/watcher-current-full.log). Its compiler selector now uses the assigned
own source build and NEW foundations composition; no retracted alias compiler.

The native helper also embedded an absolute producer-tree LC_ID_DYLIB, confirmed
by otool on both universal slices. The build now sets
`@rpath/libportable_watch.dylib`. Native linkage continues resolving the ordinary
source-relative #library from the selected stdlib. Required package location:
`<selected-stdlib>/internal/watching/native/libportable_watch.dylib`.
System CoreServices linkage remains normal OS linkage. No new override feature;
existing JAIC_NATIVE_LIBS preserved. Direct per-helper overrides remain TODO.

`python3 -B tools/check_portable_watcher_package.py` requires both install-name
slices, MOVES a composed distribution before compilation, verifies executable
@rpath linkage and selected relocated library directory, and executes actual
host ARM64/translated x64 native O0/O2 lifecycle. It passes in
target/watcher-package-final.log; initial absolute identity failure is in
watcher-package-red.log and watcher-install-name-red.log. Separate test tooling
correction: cross-CPU native compilation requires the target triple, not only
-os/-cpu; rejected invocation preserved in watcher-package-cli-correction.log.
This changes the test command, not compiler behavior or assertions.

Owned Jai format/--check passes. The composed moved-distribution gate is not a
production release-package result. Final package inclusion/minimum deployment/
signing and native other-OS backends remain coordinator/platform gates; the
public File_Watcher module is still Mac-only/partial. Release0.18.0 remains held.
