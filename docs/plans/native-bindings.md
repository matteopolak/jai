# Native binding implementation plan

The reviewed pages in `docs/specs/stdlib/modules` are the sole Jai API oracle.
All work runs inline in this workspace; no delegation or external Jai sources.

## Design

Generate canonical public records and ABI declarations directly into module
facades. Preserve complete aggregate blocks verbatim, including anonymous
overlays, using prefixes, defaults, function pointers and type-info directives.
For inventory/member-list pages, join declarations to shapes by name **and
configuration**, never by dependency guessing. Keep native library handles and
contextual helper types file-local. Independently authored wrapper bodies live
beside generated declarations; reusable algorithms belong to internal/bindings.

Official native headers and implementations may supply native dependencies,
with immutable pins and hashes. They cannot add Jai exports. Do not replace
missing native libraries with stubs. Report every unresolved declaration in a
machine-readable ledger and the questions document.

## Work sequence

- [x] Add generator parser regression tests for conditional shapes, implicit
  enum references, anonymous unions, overloads and private contextual types.
- [x] Implement deterministic spec parsing and generation; verify every
  inventoried declaration is emitted, implemented manually, or explicitly
  unresolved in the complete ledger.
- [x] Implement the compression, image, mesh and hashing facades and wrappers;
  pin native dependencies and check host C layouts and runtime operations.
- [ ] Implement OS, graphics, COM and SDK facades and wrappers using the same
  condition-aware generator; document ambiguous contracts rather than guessing.
- [x] Stage newly authored foundation sources from ../stdlib and compiler
  sources from ../compiler into a durable test tree, preserving one bootstrap.
- [x] Check six desktop configurations (Linux/macOS/Windows × x64/arm64),
  module parameter configurations, public nominal names and export privacy.
- [x] Run host native Jai programs that compare C sizes/offsets and exercise
  real runtime calls. Record unavailable SDK checks separately.
- [ ] Self-review changes against the specs, update docs/README.md and the
  coverage ledger, commit each verified batch, and continue remaining scope.

## Verification commands

Generator tests: `python3 -m unittest discover -s tests/native-bindings -p 'test_*.py'`.
Generation: `python3 tools/native_bindings/generate.py` (then `--check`).
Native dependencies and integration tests will be driven by checked-in scripts
under `tools/native_bindings`; their output and exact limitations are recorded
in `docs/native/bindings-coverage.md`.
