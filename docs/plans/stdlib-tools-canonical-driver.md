# Canonical driver active checkpoint

Approved contract: bindings-generator.md, Option normalization and public
generation workflows. The coordinator delivered this refinement during the
active shared implementation. Integration alone owns commits/index/branch.

Implemented source:

- binding-options-normalization.jai: selected mutable-array copies, canonical
  then legacy library/path order, four deprecation warnings/reset arrays,
  default search/include/suffix/target policy, lowercase lookup fragments,
  unchanged explicit callback and supported nondefault options. Private owner
  descriptor frees only its arrays/text in high-level calls; standalone
  normalize returns caller-allocator storage.
- bindings-driver.jai now routes BOTH generate_bindings overloads and bridge
  through binding-canonical-driver.jai. No private Native_Model/native C helper
  branch remains in either public workflow.
- canonical output initializes/runs/deinitializes the same model, calls the
  will-print callback only for Jai, emits public declarations/delayed globals,
  file support/library directives/checks/bitfield accessors, honors header/footer
  and returns an output artifact independent of model lifetime.
- bridge collection uses actual mapped metadata, excludes reviewed visibility/
  deprecated/operator categories, preserves represented arguments, and emits
  actual C-linkage adapters. Placement output/constructor code requires <new>.
- enum printing accepts null underlying CType without assigning an inferred
  type; macro rendering uses current enum scope for same-enum names.

Actual evidence:

- Options fixture genuinely red on old source/library/null callback validation,
  now interpreter/native Mac O0/O2 green; Android explicit-root target case had
  a separate real red before correction.
- Header-only canonical driver genuinely red at zero-library index, now builder,
  filename/lifetime/header/footer/checks and empty bridge stages green. Its unchanged
  BAD/GOOD consumer now passes after ASN finalized enum names after generic
  preparation and macro grouping. Both assertions remain unchanged.
- canonical-bridge-driver-w4n5vipj: actual generate_bridge interpreter/native
  O0/O2 and linked original C++ provider/consumer effects, guarded source green.
- Resolved-library-path-p6t829bt remains preserved RED, but the delivered
  logical-name/directive contract invalidates it as a generator compatibility
  oracle. It is not a proven compiler bug. No output-path/compiler exception
  follows. Driver now omits shared modifiers and adds no_dll only for static.

Immediate remaining work:

1. Current header-only/80-namespace/96-type/expression workflows pass interpreter,
   generated Jai/native Mac O0/O2 and strict checks. Consume any later current
   provider change using a fresh guarded receipt.
2. Complete actual ordinary/static/system library gate after the platform owner
   repairs canonical full_path to logical extensionless spelling. The current
   dedicated system-name assertion remains RED; no caller-side stripping.
3. Done: exact callback/lifetime/filename default-report/write-failure/preserved
   file assertions now pass. No universal diagnostic accumulator installed.
4. Reconcile unsupported vtable/ObjC/generic/raw/128 output with exact questions.
   Do not claim completion by emitting invalid private placeholders or dropping
   supported declarations. Initial reviewed C++-linkage selection excludes unmangled ordinary C;
   mixed C/C++ consumers now verify this with canonical native name normalization.
5. Audit retained obsolete provider code with integration/root before removal.
   module.jai still loads binding-native-model.jai and legacy CPP adapters;
   current pure quote/type utilities have dependencies that must be extracted.
   No silent deletion of shared/legacy evidence.

No-workaround audit: old uncommitted qualifier-ignore branch is preserved under
own shared-target/qualification-review-before for review. Current code has no
qualifier-check opt-out. Correct canonical function parameter types expose array
adjustment; strict matching propagates array qualifiers into elements and private
full declarators retain represented row types. Namespace-scoped C-linkage
adapters avoid global C++ redeclaration with different linkage while retaining
required exported C symbol names. Temporary debug symbol conditions are removed.

Source/tooling snapshots change during implementation; older passing receipts
remain historical exact inputs. New source is durable in the shared worktree,
builds/outputs remain worker-private T7. No peer source, git index or remote edits.

Current correctness followup: public deep input replaced own declaration, name,
type/expression/template/array-normalization and native CPP matcher count limits
with cycle-aware paths. One shared private emission-state module preserves its
identity across parameterized generators, owns transient pointer/phase tracking,
and releases root traversal storage. Temporary CPP array qualification views
retain original model identity for actual cycle detection. Native long96-pointer
regression exposed/fixed long-long fallback, with exact SDK alias assertions.
Other model-property guards and unused legacy parser paths remain separately
owned/audited; no all-depth/all-format/all-platform guarantee is claimed.

Actual high-level ownership repair: a counting allocator reproduced live
Library_Info allocations after generate_bridge because the platform allocator
was outside the session ledger. Canonical Pool now owns temporary initialization,
run and print allocations; the result builder allocator is explicitly captured
from the caller before switching. Native/session cleanup precedes Pool release.
Final guarded mixed C/C++/default-options/zero-live-allocation gate:
canonical-bridge-driver-qh6thvhb/verification.json,33 checks. Pool source/facade
are hashed read-only dependencies. Native loaded-library handles/cache unloading
remain separate, and intermediate memory is retained until bulk release.
