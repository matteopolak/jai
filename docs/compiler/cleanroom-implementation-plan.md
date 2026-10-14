# Compiler compatibility implementation plan

The API oracle is the reviewed language and standard-library specifications in
`docs/specs`. Work remains in the existing Rust compiler, public facade folders,
and the compiler-owned directories under `stdlib/internal`. No reference compiler,
old library body, historical checkout, or agent transcript is an input.

## Sequence and validation

- Verify restored canonical bootstrap discovery with original virtual-filesystem
  tests: discovery, a single module instance, reflected type identity and shared
  mutable storage through `Preload`. Build LLVM CLI and publish the command and
  runtime parameters in `docs/compiler-integration-handoff.md`.
- Add failing scope regressions in `crates/jaic/tests/cleanroom_modules.rs`, then
  correct private qualified lookup and sibling file import leaks in `scope.rs`.
  Preserve independent loaded-file scopes and importer isolation.
- Enforce the documented distribution policy at source-loading boundaries:
  canonical destinations inside the selected library's internal directory require
  a library-owned originating source. Test imports, loads, traversal and symlinks.
- Verify filtered reexports, overload aliases, aggregate maps and argument cache
  identity with original tests. Repair their shared resolver/constant mechanisms;
  do not introduce convenience exports to satisfy old tests.
- Build the Compiler ABI records from its declaration inventory, keeping canonical
  reflected names. Implement supported helpers and validate against Rust record
  serialization and workspace operations. Record unsupported compiler/debugger
  behavior in `docs/specs/stdlib/compiler-questions.md`.
- Implement an independent Jai runtime lexer and the Code_Visit and Program_Print
  facades with private algorithms. Test public fixtures and extend coverage for
  malformed input, traversal order and printing failures.
- Run focused core, CLI, LSP, wasm and native regressions. Library-dependent runs
  require the newly implemented foundation; report missing prerequisites honestly.
  Full corpus/release integration remains coordinator-owned.

Each behavioral repair starts with a reproducing test and ends with focused
verification, documentation and a local commit. Work is sequential in this checkout;
no subagents or changes to another worker's checkout are permitted.
