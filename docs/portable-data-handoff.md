# Data/resource handoff

Scope is exactly the five assigned modules and owned tests/docs. Shared producers,
Extensions and old foundations worktree/staging are untouched. Stable checkpoints:

- a8f982b: package wire API and ICO primitives.
- 4dc5881: subtitles and broader ownership/malformed-file coverage.
- 75e1e55: checked resource conversion/transactions and SDK fixtures.
- 7b72f9d8: all refreshed public contracts, five-frame ICO, public Windows APIs,
  real Setup/registry discovery, Icon callbacks, corrected CSV/TOC semantics.

[Per-API ledger](portable-data-api.md), [testing/dependencies](portable-data-testing.md),
[Windows native gate](portable-windows-resources.md), and [narrow review questions](specs/questions/portable-data.md)
give current detail. Earlier single-frame assumptions were superseded by reviewed
five-frame wire expectations; they are not used as compatibility evidence.

The supported-scope runner passes with source-built unchanged real jaifmt,
warnings-denied target-aware lint, interpreter/native O0/O2, portable WASI,
unused-code target checks and independent package/CSV/XML/LLVM RC consumers.
Native evidence is macOS ARM64. Subtitles/Simple_Package compiled WASI use real
filesystem operations. Windows native resource/public discovery/positive Icon
tests remain coordinator CI gates. Do not call source checks native execution.

Image WASI is outside established contract support. The explicit optional probe
runs and fails on missing real native dependencies; it exits nonzero rather than
pretending success. Official WASI SDK headers currently do not supply this
compiler's wasm64 target. No ABI substitution is made.

Integration needs existing native stb packaging and Windows SDK system libraries
(kernel32, advapi32, ole32, oleaut32). No shared dependency manifests are changed.
Retained compiler argument buffers live for the compiler process. SupportedOS
subset/filter/empty-speaker adjacency/path-literal questions remain precise and
do not excuse missing exports. Full corpus, final integration and release remain
coordinator owned; no publication performed.

The final testing checkpoint adds native Windows discovery/registry oracles,
real +Icon SDK readback, scoped Windows C SDK build recipe, exact facade-name
audit, and six desktop OS/CPU source contexts. It also diagnoses registry-close
errors and accepts the full 16-bit numeric resource-ID range, including zero.
