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

Committed File checkpoint: `eb5d83d`.

## System, Thread and runtime checkpoint

Implemented Windows account/profile queries, machine/executable paths, native
error descriptions and topology-based physical/logical/performance counts.
Added Windows critical sections, condition variables, semaphores, suspended CRT
thread creation, completion and allocator/context cleanup. Unix paths remain
selected unchanged. Runtime Windows output now calls WriteFile, avoiding CRT text
conversion; native entry converts the actual Windows command line to UTF-8 and
releases its storage after runtime teardown. Windows debug_break uses DebugBreak.

The original System/Thread fixtures first failed on their Unix-only assertions.
The expanded File allocation-failure test first failed in alloc_string's assertion;
read_entire_file now returns failure when allocation fails, with overflow checked
before reserving the terminator. Other File coverage now includes recursive Unicode
directories, null/negative writes, empty native mappings and borrowed-wrapper cleanup.

Executed `python3 tools/check_platform_io.py --jaic target/debug/jaic --stdlib
target/platform-io-stdlib --cross-check --native`: all four original contract fixtures
pass Windows x64/arm64, macOS arm64 and Linux x64 `-check -no_dce`, host interpreter,
native O0 and O2; Unicode/empty/quoted argument fixture passes host interpreter/O0/O2.
Windows x64 File/System/Thread/runtime fixtures cross-link. PE imports confirm native
runtime uses WriteFile/GetCommandLineW/CommandLineToArgvW instead of CRT `_write`.
The runner now compares bytes, so CRLF translation cannot be hidden by Python decoding.

Source-built jaifmt formatted the owned paths; jailint `-D warnings` passes after
removing an unused test import. Full scoped format idempotence is rerun at handoff.

Next: prepare real private Windows Process mechanisms without inventing missing
public Windows aggregate layouts; record remaining runtime/crash ABI questions.
Native Windows execution, interpreter CRT suspension support and full public corpus
remain coordinator/compiler work. No Windows runtime pass is claimed here.
