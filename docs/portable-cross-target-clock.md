# Compile-time clock host/target dependency

The fresh 06e8ea96 report identifies four Vulkan build failures at the monotonic
clock query. The newly authorized curated configured-cases metadata shows all four
select `-os linux` on this Mac host. A later hash-matched read of the approved
Build.jai confirms ordinary `#run,stallable Build()` and target Basic timing calls.
No application metaprogram was executed.

`pending/cross-target-compile-time-clock.jai` calls the actual public Basic clock
twice in a compile-time directive. Mac x64/ARM64 source checks succeed. Linux
x64/ARM64 checks abort with the same monotonic query assertion. This is a genuine
blocked configuration, not a passing target gate.

The SDK-only control `pending/cross-target-posix-clock.jai` produces:

| Target on this Mac host | Clock ID | Actual SDK status |
| --- | ---: | ---: |
| macOS ARM64 | 6 | 0 |
| Linux ARM64 | 1 | -1 |

Both target constants match their native ABI. The installed Apple SDK `_time.h`
declares monotonic ID 6; the official [Linux UAPI time header](https://raw.githubusercontent.com/torvalds/linux/master/include/uapi/linux/time.h)
declares ID 1. The refreshed reviewed
[execution contract](specs/jai/polymorphism-and-metaprogramming.md) explicitly does
not promise automatic host-ABI remapping for ordinary target `#run`. These four
client timing premises therefore require host-metaprogram work or the isolated
host form. They do not justify a library fallback or compiler clock-ID translation.

The first SDK control additionally tried target POSIX errno after the failing
call. Linux-target execution could not call `__errno_location` on the Mac host.
That original result remains in `sdk-control.json`; the final independent clock
status control omits errno specifically to expose the original call result.
No fabricated errno or timestamp replaces either failure.

The documented host form's earlier implementation gap is now resolved in the
current shared compiler. Fresh worker-local receipt
`artifacts/local-verification-stdlib/cargo-target/host-clock-current-glmg06d7/results.json`
passes both the block form and explicit primitive-result form, with a real Linux
x64 object output. No Basic/POSIX production change or host clock substitution
was needed. The receipt records the exact source-built compiler hash.

Historical failure retained:
`pending/host-clock-workspace.jai` creates a Linux x64 OBJECT_FILE child using
the reviewed Compiler APIs. Its target imports Basic inside `#run,host`, with no
outer target captures. Both the block form and the explicit no-argument bool result
in `pending/isolated-host-clock-result.jai` fail the actual monotonic query with the
freshly built shared compiler. Receipt:
`stdlib/shared-target/shared-compiler-revalidation-azndbra2/host-workspace-primitive-result.json`.
This valid host-isolation reduction was compiler-owned, distinct from ordinary
cross-target calls outside the portable execution domain.

Earlier raw target/CLI controls in `cross-clock-i24tnarw` used the older allowed
sibling compiler; their identities and failures remain historical. Current shared
source was rebuilt after finding 106 Rust-file differences. The actual shared
Compiler-API host-form failure above is superseded by the fresh passing receipt. The Basic
runtime clock implementation and POSIX declarations remain unchanged; no fabricated
errno or time value, skipped assertion, or automatic remapping is introduced.
