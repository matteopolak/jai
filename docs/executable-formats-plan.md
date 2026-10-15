# Executable formats implementation plan

Goal: implement remaining reviewed executable_formats declarations and bounded workflows from independent ad575d16.

Architecture: retain the archive parser. Canonical public records/constants live in focused private loaded files. Validate ranges before borrowing bytes. Reject unsupported layouts rather than invent public models. Failed parses return empty aggregates and release derived storage.

- [x] Add explicit ABI constants/enums/records from reviewed members; resolve incomplete shapes through worker-inbox.md.
- [x] Add bounded Mach-O64 commands, sections, symbols and strings; test real host objects, truncation, malformed fields, borrowing and allocation cleanup.
- [x] Add reviewed ELF64 and COFF/PE workflows after resolving wire-layout gaps, with independent fixtures and official format oracles.
- [x] Add universal workflows when Arch_File arrives; preserve archive behavior.
- [x] Run interpreter/native Mac O0/O2, formatter and warnings-denied lint. Record cross-target checks separately.
- [x] Update feature docs, index and exact scope JSON; commit verified object/container phase with Conventional Commits.

Remaining reviewed rows: zero. The approved independent Debug_Info dependency
is adopted exactly from 8b134bdb in commit 1432c9f4. Both CodeView records import
its canonical Guid identity. Nlist and all 37 lexer/TBD procedures are implemented.
Public layout/identity tests, real PE CodeView oracle comparisons and preserved
parser suites run in interpreter/native Mac O0/O2; cross checks remain separate.

Source tools: `cargo build -j2 -p jaic-cli -p jailint`; use assigned `$CARGO_TARGET_DIR/debug` binaries. Fixture generator: tools/build_executable_fixtures.py. Runner: tools/check_executable_formats.py. Tests: tests/portable-stdlib/executable-objects.jai.
