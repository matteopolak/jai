# Generator platform contract review status

Inputs are reviewed public declarations/behavior and the independently produced
model. No original/private/reference implementation or original history was read.

Resolved by the 2026-10-15 reviewed behavior batch and now implemented:

1. find_lib_for_foreign_name uses context.generator, scans canonical libraries in
   order and returns the first match, without excluding LINK_ALWAYS. Callers own
   record/context lifetime; deinit does not restore or clear the active pointer.
2. The symbol cache uses exact OS/CPU/full_path keys, stores copied path/name data
   only on success, returns borrowed hit storage and provides no invalidation.
   Apple targets remove one leading underscore. The model owner's canonical
   Library_Symbols is integrated on all desktop branches.
3. Explicit libclang setup compares source versus current-directory basename mtime
   and size, copying when absent/older/different size and asserting a missing source.
   No-argument selection is Windows/macOS/Linux bundled file and assertion otherwise.
   The initial independent validation/symlink policy has been removed.
4. libc paths are include roots: generic/platform Linux or Android roots and the
   Apple SDK usr/include path in both outputs. Unsupported targets return empty/false.
5. Apple foreign-name normalization applies to macOS and iOS, removing one prefix.

No assigned public name remains blocked by these resolved questions.

Remaining precision/coordination, not a missing implementation claim:

- The reviewed text names context.generator but does not specify its reflected
  field type across multiple TARGET_OS module instances. One parameterless internal
  module owns an opaque pointer, and consumers cast to their canonical Generator.
  Confirm whether a stronger cross-instance reflected type identity is promised.
  The current implementation retains one slot, not competing context registries.
- Exact installed/bundled SDK path conventions and include-root allocator choice
  are not specified. Documented independent paths/configuration and owned output
  strings are described in ../../generator-platform.md.
- function_is_missing_foreign_library's virtual/inline/bridge exceptions were not
  specified. It currently tests null input/null canonical library pointer; no extra
  exception or implicit resolution behavior is presented as reviewed equivalence.

The independent combined-test macro failure is reported to stdlib-tools in
../../generator-platform-macro-cause.md. The separate generic module-root lint
ordering failure was reduced and repaired by compiler owner e9affab7, integrated
without the overlapping model-worker fix.
