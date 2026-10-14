# iOS toolchain helpers and host verification

The reviewed iOS-specific availability applies to all three public helpers.
The facade now enforces it: no desktop root export is added for convenient
host testing. The old host invocation in `ios.jai` was an invalid target
expectation, not evidence of a missing desktop public API. The same public
fixture remains checked under both iOS CPU targets; the compiler currently
rejects that OS option, and those required failures stay recorded.

The native implementation lives in `internal/bindings/apple-toolchain`. Its
private host unit is compiled inside the staged stdlib boundary, with test
bytes copied unchanged. This respects private-import checks without a testing
backdoor or compiler exception. Scope is explicitly `private_toolchain_host`,
not an iOS public-facade runtime pass. Desktop negative-export checks cover all
three names on all six configurations.

The implementation invokes real `xcrun` commands, reads output with a growing
buffer, checks stream errors and process exit status, trims whitespace, logs
empty/failing output and caches successful process-lifetime strings. It
preserves the reviewed non-ARM64 fallback triple. Logging handles partial
writes and aborts on a failed write rather than ignoring it. A native pipe unit
exercises a 5,000-byte payload, whitespace-only output and a nonzero command
exit; those are stream tests, not substituted SDK results. Real SDK path
lookups and repeated-call storage identity are tested separately.

Cache first-use synchronization is not yet provided; concurrent initialization
could duplicate lookup/allocation before one cached value wins. The contract
does not establish concurrent cache semantics. Proper follow-up is a reviewed
thread-safety requirement and a general synchronized lazy-init mechanism.
Cached buffers intentionally persist for the process lifetime. Allocation
failure and logging failure abort; failed SDK invocation returns an empty
string and remains retryable, as reviewed.

Evidence: `.work/ios-target-contract-verified.json` and subsequent reruns,
including explicit native SDK paths. Earlier rejected private-unit placements
remain in the preceding reports; they did not establish a successful check.
