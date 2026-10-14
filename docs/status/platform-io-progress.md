# Platform I/O worker progress

## File checkpoint (2026-10-14)

Implemented Win32 File handles, binary reads/writes, 64-bit size/seek, flush,
Unicode paths, links/moves/deletion, directories, absolute/canonical paths,
known folders, real read-only mapping and ownership cleanup. Shared convenience
operations use the selected backend. Unix operations retain their implementation.

Evidence executed locally:

- Original `tests/platform-io/file-contract.jai` first failed Windows checking on
  the existing OS_IS_UNIX assertion.
- Windows x64/arm64 `-check -no_dce` now pass with the source-built compiler.
- Host macOS interpreter and native O0/O2 each print `ok`.
- Windows x64 O0 executable cross-links with the installed MinGW-w64 toolchain.
- Source-built `target/platform-io-tests/jaifmt` formatted the six owned Jai paths;
  source-built `target/debug/jailint -D warnings` passed on the same scope.

Compiler/tool staging: copied permitted independent `../compiler/crates` plus
Cargo manifests into `target/platform-io-toolchain`, then built with
`cargo build --locked --manifest-path target/platform-io-toolchain/Cargo.toml -p
jaic-cli -p jailint`. Cargo's target directory is this checkout's `target`.
The first source build caught an in-flight Option<Sym> compiler error; retrying
with the producer's corrected interfaces.rs passed. A copied permitted producer
binary was used only for early checks while that source build was repaired.

Dependency staging: copied local stdlib plus independent bindings POSIX/Windows/
internal bindings, foundations Basic/String/Hash/File_Utilities and their private
dependencies, and compiler Compiler/Jai_Lexer/private dependencies, into
`target/platform-io-stdlib`. No staged source is claimed as a production merge.
The formatter was built from `jaifmt/main.jai -O2` against that tree.

Next: finish File edge-case validation and durable checkpoint; implement dedicated
Windows System, Thread and runtime I/O, then Process where reviewed layouts allow.
Native Windows execution and full public corpus remain coordinator work.
