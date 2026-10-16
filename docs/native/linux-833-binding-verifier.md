# Binding verifier failures observed in the 833 CI cohort

All four 833 compiler matrix jobs were cancelled with actual failures; none is
green. The admitted matrix inventory contains failure names/categories rather
than the failing ABI test's complete diagnostic. A guarded current-source
compiler build and focused verifier replay independently reproduced the assigned
40 binding failures. This is current evidence, not a fabricated immutable-833
stdout or a new complete CI verdict.

| Failure family | Count | Actual cause | Repair and evidence |
| --- | ---: | --- | --- |
| rpmalloc private source loads | 18 | Relocated fixtures' `../../stdlib` loads resolve outside `private-unit-stdlib` | Keep the private library at `private-units/stdlib`; preserve fixture bytes and relative source forest |
| rpmalloc native pointer type assertions | 12 | Bridge imports all eight SDK parameters, while two oracle imports supplied five; these written import configurations currently have different nominal types | Make the two private oracle imports explicitly match the complete existing eight-parameter profile; preserve every type assertion |
| DXC private source loads | 4 | Same incorrect relocated relative-load root | Correct private library layout; retain actual wide-string/compiler fixtures |
| macOS FSEvents source controls | 2 | Fixture tries to load private SDK bridge from outside the stdlib boundary | Place its unchanged bytes as a private module test unit; required Mac backend remains required |
| AppKit privacy controls | 4 | NSView and NSScreen are reviewed public submodule types, not private names | Add canonical positive controls; test actual private `binding_class` and `binding_send`; retain root namespace privacy |

The macOS two failures were **not** evidence of an unsupported Mac backend.
They are private-fixture placement failures. Linux/Windows rejection of AppKit
is independently required by the reviewed Mac-only submodule contract.
Objective_C's parent also supports iOS, so classification now uses exact child
availability before inheriting a parent's condition.

## Source forest and private boundary

The private library retains the canonical basename `stdlib` inside a distinct
owned scratch tree. Fixtures, public production sources and their `#load`
statements are not rewritten. There is no symlink to a second library root,
bootstrap duplication, producer overlay, public testing backdoor or disabled
private-import guard.

An additional regression exposed deeper no-thread-cache dependencies:
`stdlib/rpmalloc/tests/no-thread-cache.jai` loads the original exercise and three
SDK-layout fixtures from its repository-relative `tests/native-bindings` sibling.
The existing placement inventory instead put those bytes inside the rpmalloc
module. Their four trusted destinations now preserve the repository-relative
forest under the owned private tree. Six desktop source checks verify these
loads, independent layout assertions and current allocator controls unchanged.
The common placement/cleanup API belongs to integration; its rollback must
respect this explicitly inventoried fixture forest as well as library files.

## Canonical type identity and precise module configurations

The bridge's private SDK import forwards STATISTICS, RAW, PUBLIC_HEAPS,
GLOBAL_CACHE, THREAD_CACHE, ASSERTS, VALIDATE_ARGS and ADAPTIVE. The two private
oracle fixtures now supply those same eight existing values, adding only the
previously omitted `ASSERTS=true`, `VALIDATE_ARGS=true`, `ADAPTIVE=false` arguments.
They do not add profiles or public parameters. Every original
`type_of(native) == *Native.rpmalloc_heap_t` assertion, SDK storage probe, public
layout assertion, canary, ownership and cleanup operation is retained. No cast
replaces the nominal type check. All twelve checks pass for the exactly matching
private configurations.

This correction does not establish general equivalence between omitted and
explicit defaults. Independent Leaf/Bridge controls are supplied in
`tests/native-bindings/module-default-identity`: fully explicit forwarding and
repeated identical imports pass; the asserted omitted-default equivalence fails.
The compiler owner independently reproduces that distinction and is reviewing
the existing written-list identity contract. Exact sources and receipt were
transported into the admitted `bindings-module-default-identity` packet. That
question remains visible; no compiler exception or asserted equivalence was
invented to pass the binding checks. Any future canonical import helper should
retain the complete private profile rather than depend on unreviewed default
normalization. No public rpmalloc record, alias, layout, callback or native
ownership adapter changed in this batch.

## Target and privacy policy

Module results use reviewed availability plus actual guard evidence.
An error on a supported target remains a failure even if it contains a familiar
platform-guard message. An unrelated failure on an unavailable target also
remains a failure. A successful import on a reviewed unavailable target is a
failure. Only an actual expected native-platform rejection on an unavailable
target is recorded as unsupported, and it is never runtime success.

The AppKit positive fixture checks NSView/NSScreen public names, reflected
canonical names and repeated-import identity. The root Objective_C privacy
checks remain active. No global negative catalogue, expected SDK misses, public
alias inventory or coordinator ledger was refreshed.

## ABI gate and verification boundaries

The unchanged original `abi_layout::check_host` implementation and ABI manifest
were compiled into a narrow host driver. The real C and Jai layout programs
agree on Mac ARM64, with source/compiler/captured-provider hashes guarded and the
bounded slot released. Captured providers were not rebuilt by this diagnostic;
it does not claim a fresh complete provider closure or identify the original
833 failure on another host.

The final status manifest records the focused verifier, policy regressions,
six cache-forest controls, twelve exact-profile controls and source/format/lint
receipts. Source checks across six desktop configurations are not native Linux
or Windows execution. Actual Linux runtime/SDK ABI and original matrix replay
remain required. Root still needs to admit the precise first diagnostic for
`stdlib_c_abi_matches_host_headers` before assigning its historical failure to
provider preparation, staging or declaration mismatch.

Integration owns the common `regression_source`/placement API migration,
prerequisite providers, workflow/environment setup, global docs index and Git
index. Those separate Python API failures are not silently counted as fixed by
this patch. Please selectively link this document in `docs/README.md`; the exact
owned patch and per-file/evidence hashes are in
`docs/status/bindings-linux-833-verifier-ready.json`.
