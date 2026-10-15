# System raw counter

The reviewed `read_cpu_counter :: inline () -> u64` is implemented for the owned
Unix System backend. CPU selection precedes OS: x64 returns the actual RDTSC
value through the canonical public `M64` Machine_X64 module alias. Other Unix
CPUs call CLOCK_MONOTONIC_RAW and return only tv_nsec. This intentionally wraps
each second and is not elapsed nanoseconds, wall time or the ARM cycle register.
No common unit/frequency/serialization promise is introduced. Windows System
and its non-x64 QueryPerformanceCounter branch remain platform-io ownership.

The SDK clock call executes outside optional assertions. Failure logs, then
asserts; a disabled or explicitly continuing assertion returns zero after the
diagnostic. That is an independent failure policy, not a valid sample success
claim or a reviewed guarantee. The x64 wrapper introduces no runtime dispatch;
the caller must satisfy the architectural timestamp prerequisites.

`tests/portable-stdlib/system-counter.jai` checks64 actual samples bracketed by
SDK raw-clock reads on ARM64, requiring same-second samples to lie between the
native tv_nsec values. On x64 it brackets with fenced actual RDTSC reads and
checks the required public M64 alias. The normal System regression remains
unchanged. New/original fixtures pass interpreter and native ARM64/translated
x64 O0/O2. Strict target-aware lint passes public/private/new fixture roots for
macOS/Linux x64/ARM64. Native Linux and Android execution remain pending; source
checking is not counted as native SDK verification.

The broad runner retains every host assertion and Linux checking. The new test
joins the explicit Unix-only Windows target-check scope because this worker's
System facade intentionally rejects Windows; coordinator integration owns the
peer Windows backend. This is an unavailable backend classification, not an
invalid test or claimed Windows pass. No peer code or Extensions was changed.

Evidence: target/system-counter-red.log, target/system-counter-green.log,
target/system-counter-regression.log and target/system-counter-strict.log.
