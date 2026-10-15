# Flat_Pool and container verification

The refreshed reviewed contract resolves the earlier initialization/default gaps.
Flat_Pool has both exact inferred module parameters:
DEFAULT_VIRTUAL_MEMORY_RESERVE := 256 * 1024 * 1024 and
OVERWRITE_ALL_POOLS_ON_RESET := false. Its canonical record/layout and immutable
CAPS_VERSION_STRING remain unchanged.

| Public API | Current implementation |
| --- | --- |
| init | Exact inferred reserve default; checked positive/page-rounded native reservation, cursor and commit boundary initialized without eagerly committing pages |
| get | Lazily initializes null base with the selected module default; aligned stable-address bump, page-wise commitment, checked extent/overflow, null on native commit failure without metadata advance |
| reset | Stamps allocated prefix when local argument OR module flag is true; false cannot disable global true; rewinds while retaining reservation and committed pages |
| fini | Checked native unmap, clears pointer fields, retains alignment; empty repeat teardown accepted |
| flat_pool_allocator_proc | Allocate/copy-resize, no-op FREE, allocated-prefix ownership, static CAPS name/flags, lazy STARTUP and real SHUTDOWN; thread/heap modes diagnose |
| example | Real default initialization, allocation, reset/stamp verification and deferred release |

Implemented native operations are macOS/Linux/Android branches. Windows/console
operations remain absent; Windows target checking of the test verifies canonical
record shape only. Android CLI is unsupported, so no Android target/native claim.

Normal behavior tests now use public init and lazy get, rather than manually
populating reservation fields. They verify explicit page rounding, default 256MiB
reserve, custom module default, zero-byte lazy reservation without commitment,
reinitialization after fini, all four global/local stamp combinations, retained
committed pages, changed alignment, stable bytes, resize copying, no-op individual
FREE, static CAPS and allocator STARTUP/SHUTDOWN. Capacity failure also uses real
public initialization. The supplementary read-only shared mapping of the original
test source still forces a real mprotect failure and verifies no metadata advance,
then releases the reservation. That fixture verifies the failure path only.

Remaining independent policies needing review: ownership recognizes the allocated
prefix including alignment padding; empty reset/fini are harmless; repeated init
requires prior fini; nonpositive/overflowing reservations diagnose. Page size is
queried at each commitment, trading overhead for no ABI/state changes.
These are distinct from the now-resolved reserve/default/overwrite contracts.

Historical evidence: first core-only tests used caller-provided native
reservations because the earlier page lacked defaults. That checkpoint is
superseded by public-init behavior tests. An initial #filepath (directory) instead
of #file caused mapping failure; corrected without weakening checks. Initial
capacity-fault runner omitted its diagnostic map entry and stopped with KeyError;
the explicit diagnostic is registered and retained. Old suite log:
target/flat-pool-suite.log; prior successful core suite:
target/flat-pool-suite-final.log. Current init suite:
target/flat-pool-init-suite.log.

## Hash_Table audit

Existing table_find_multiple/table_remove_multiple implement temporary copies and
all-duplicate removal; the earlier ledger understated that implementation. New
tests verify 128 duplicate copies without assuming storage order, no value alias,
stability across rehash, first-match set, removal preserving collision neighbors,
caller-initialized find_or_add, captured allocator cleanup, non-refilling
tombstones, collision counters and NEW foundation scalar-default hashing.
Walk_Table remains withheld pending its caller-local expansion contract.

Refreshed initialization verification: full95 positive cases and23 expected faults pass in both interpreter/native modes, eight compile rejections and prior SMTP/IPC/parent/startup/Linux+Windows checks pass. Flat_Pool also executes native O2. All293 currently owned Jai files pass source-built jaifmt --check and jailint -D warnings. Windows checking currently covers canonical record only, not a native Windows allocator backend.
