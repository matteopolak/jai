# Deep_Copy timer operations

The public graph/callback contract is reviewed in specs/stdlib/modules/deep-copy.md.
Independent safety regression: optional Basic assertions must not suppress SDK
clock operations used to measure a real string-mapping callback.

The existing implementation called clock_gettime inside assert on Unix, and
QueryPerformanceCounter/QueryPerformanceFrequency inside assert on Windows.
With the staged DEFAULT Basic instance's ENABLE_ASSERT=false, a real 20 ms
nanosleep callback ran but time_total remained zero. The new regression exits5
independently of Basic.assert. Original evidence: target/deep-copy-timing-red.log.
The enabled configuration passed before the fix; the disabled interpreter failed.
This is a production defect, not an obsolete test/API expectation.

Clock calls now run unconditionally. Their results are checked explicitly;
failure invokes the configured assertion handler and aborts if it returns, since
no valid duration exists. No fabricated time or silent failure is accumulated.
Public shapes/signatures/storage and allocator ownership are unchanged.

Run with the source-built compiler selected by CARGO_TARGET_DIR:
`python3 -B tools/check_portable_deep_copy.py`.
Target/deep-copy-timing-final.log records both actual default configurations in
interpreter/native Mac O0/O2, the existing graph/scalar/debug fixtures, and whole
owned Deep_Copy strict lint. The new timer fixture uses unconditional exit checks;
existing assertion-based graph checks are effective in the enabled configuration
and their production paths execute in both configurations. Owned format/--check
passes. Windows clock source was corrected by the same cause; native Windows and
injected real SDK clock failure are not verified here. No test oracle changed.
