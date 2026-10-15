# Machine_X64 compiler integration gaps

The reviewed module is x64-only and promises architectural CPU/instruction
operations, without a non-x64 fallback. No zero-feature CPU record is supplied as
a completed implementation.

Own compiler source currently lowers Op::Cpuid by writing literal zero into all
four operands in crates/jaic/src/sema/asm.rs. The original standalone
tests/portable-stdlib/pending/cpuid-vendor.jai queries leaf0 and asserts actual
nonempty vendor bytes. It fails in both interpreter and a source-built native
x64 executable, with the same specific assertion. Failed logs are retained at
target/cpuid-vendor-failure.log and target/cpuid-vendor-native-failure.log.

An independently authored C counterpart includes the official native C SDK
cpuid.h and actually executes the instruction. Compiled with clang -arch x86_64
-std=c11 -O2 -Wall -Wextra -Werror, it returns a real nonempty vendor/max leaf
(this run: GenuineIntel,13). No header body is copied or Jai implementation used.
The native Jai command selects x86_64-apple-darwin/x64 and disables crash-handler
installation for this focused assertion probe; its assertion remains active.
Existing full crash-handler tests remain enabled and passing separately.

Required compiler-owner fix: represent the CPU query with real leaf/subleaf input
and four results, lower native target execution to actual architectural CPUID,
and supply truthful interpreter behavior or an explicit unsupported-target
diagnostic. Do not recognize Machine_X64, source paths or individual fixture
symbols. Preserve zero values only when actually returned by the queried leaf.
The architectural query failure is not repaired by inventing public intrinsics or
returning UNKNOWN/empty features from the stdlib.

Further audit flags, not executed claims: own mnemonic parsing maps rdseed and
rdrand to the same Op::Rdrand, and current asm documentation describes synthetic
timestamp processor-ID and CPU-feature results. Their hardware prerequisites and
failure/status behavior need general compiler review before Machine_X64 exports
are counted complete. Native instruction emulation for ordinary arithmetic does
not establish truthful host/target CPU discovery.

The pending Jai reproducer passes source-built formatter/check/strict lint in
the current301-file owned scope, but its x64 execution **fails**. It is not included
as a passing functionality test or used to relax any API assertion.
