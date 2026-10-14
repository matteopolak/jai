# Core foundations handoff

This work owns Basic builder/formatting, String utilities, Hash scalars and
File_Utilities. Inherited spec, argument/runtime and Command_Line edits are
retained in the worktree and excluded from foundations commits.

Implemented progress:

- Removed the invented standalone Basic.Buffer facade. The canonical
  String_Builder.Buffer declaration and optional ensured_count layout remain.
- Added the reviewed builder print overload and temporary-storage tprint.
  Numbered `%N`, sequential `%0`, and escaped-percent directives follow the
  supplied own Rust compiler's format checker and lexer. Missing/extra
  arguments report false through the builder interface.
- Added canonical Formatter and FormatInt records, formatInt and real integer
  formatting for bases 2–36, minimum digits, padding and grouping. Signed
  minimum and unsigned maximum values are covered.
- Added String wildcard matching with bounded iterative star backtracking,
  byte sets/ranges, scan/scan2 with actual parsing and pointer writes. Scan
  values occupy temporary storage; earlier results/writes survive later
  failures as required. Unsupported/null destinations return false.
- Added scalar float get_hash through the reviewed generic signature, retaining
  raw signed-zero representations. Other scalar kinds fail specialization
  explicitly pending the exact seed formula; no substitute hash is fabricated.
- Added Unix Basic working-directory get/set and exit. getcwd grows its buffer
  on ERANGE and asserts other failures rather than fabricating a directory.

Verification uses source-built compiler/jailint from the compiler worker's NEW
independent Rust sources copied into target/foundation-integration, plus NEW
POSIX bindings copied read-only from the bindings worker. No peer checkout is
modified. Source snapshots and build outputs are durable under target/.

Commands:

```
python3 tools/check_foundations.py --jaic target/peer-compiler/debug/jaic --stdlib target/foundation-integration/stdlib --cross
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jailint -D warnings [owned paths]
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jaic -check jaifmt/main.jai
```

The focused runner checks five real cases in interpreter/native O0/O2 and
type-checks unused code on Linux x64/arm64, macOS arm64, Windows x64, and wasm64.
Working-directory APIs are Unix-only and that case is not requested on
Windows/wasm. Other cases run unchanged across those checks.

Unchanged real jaifmt currently fails at `is_directory` because the Unix alias
target's callable signature is absent from the reviewed spec. Its first
builder-overload and Basic exit blockers have been resolved. Formatting and
format-idempotence are NOT claimed while this CLI cannot build. The linter is
built and has been run with warnings denied on all owned changed Jai files.

Full float/aggregate formatting, non-float scalar hashes, File_Utilities
traversal aliases and non-Unix filesystem backends remain incomplete. See the
[focused questions](specs/stdlib/foundations-questions.md) for exact missing
contracts. Full integration/corpus/release verification remains coordinator work.
