# Native global cache selection

Extend the existing typed ownership domains with a private GLOBAL_CACHE boolean.
Each of the six public-layout/statistics combinations receives a distinct real
SDK and callback library with ENABLE_GLOBAL_CACHE=0, in addition to its existing
default library. Preserve default symbol/library identities. Forward the option
consistently through SDK, callbacks, checked allocation and heap adapters.

This deliberately uses separate builds rather than retaining a hidden native
global cache or emulating cache statistics. Public record layout is unchanged;
the SDK itself implements cache removal and mapping lifetime. Unsupported thread
cache, adaptive, numeric and other profiles remain explicit diagnostics.

Verification: fail the profile inventory test before implementation; regenerate
from pinned official C plus reviewed public specs; build all domains; run public
allocation, heap ownership, collection and statistics with canaries and callback
failure rollback; inspect actual private SDK storage through independent C
probes; retain existing sanitizer/lifetime tests. Run six desktop source checks,
host native behavior, strict lint, format and regeneration. Windows/Linux native
execution remains separate from source evidence. Additional domains increase
build/package size; metadata allocation and snapshot costs are unchanged.

Implemented after `7eafe15`. All twelve native domains built as universal Mac
archives. `.work/rpmalloc-global-cache-first.json` records 238 passing checks:
60 desktop source checks, 20 positive Mac executions, 36 actual C sanitizer
executions across all twelve profiles, existing native field/size probes,
strict lint, formatting, regeneration and 67 Python tests. Ten intentional
compile/assertion rejections retain their actual observed nonzero exits.
The cache-disabled public regression overflows cache batches, preserves an
independent initialized default domain and its data, verifies caller-context
map-failure rollback, and checks global-statistics output canaries/cache zero.
Independent SDK storage checks assert the disabled global cache is empty after
real release/collection operations. No official C patch was added.

## Thread cache extension after 154ff0d

Extend the same real domain inventory to all four independent thread/global
cache selections (24 domains). Preserve conditional public heap field removal
and use the complete independently generated SDK-correct storage. Add native
public field size/offset probes for heap layouts without thread cache; use real
SDK allocation/ownership and counter checks for both statistics variants.
Re-use public operation regressions through a shared independently authored
helper; keep existing failures and sanitizer gates. This retains build-size
cost explicitly. Other option families remain unsupported.

The thread-cache extension now passes `.work/rpmalloc-cache-matrix-final.json`
(357 checks), including independent generated public layout probes without
cache fields and72 actual C sanitizer executions for24 domains. Shared public
cache tests include four real native-thread free handoffs per domain, preserving
canonical allocator and heap lifetimes. Both private heap selections pass192
configuration checks apiece in the expanded16-combination public name matrix.
Other options remain incomplete; the declaration ledger stays80 partial.
