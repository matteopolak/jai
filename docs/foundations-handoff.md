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
  Builder print and print_to_builder are true aliases with tested callable
  identity. Added expand and append_and_steal_buffers; inline bytes are copied,
  heap buffers transfer only between matching allocators, and differing
  allocators take a copy-and-release path.
- Added canonical Formatter and FormatInt records, formatInt and real integer
  formatting for bases 2–36, minimum digits, padding and grouping. Signed
  minimum and unsigned maximum values are covered.
- Added String wildcard matching with bounded iterative star backtracking,
  byte sets/ranges, scan/scan2 with actual parsing and pointer writes. Scan
  values occupy temporary storage; earlier results/writes survive later
  failures as required. Unsupported/null destinations return false.
  Scan2 parses float64 destinations directly at full precision and checks
  integer destination range before writing. The reviewed string_tests export
  now runs real assertions over comparison/search/split/path/token operations.
- Implemented scalar get_hash for integers/bools/enums/pointers using the
  reviewed cast,no_check/u64 XOR-seed, Knuth-product, upper-32 formula. Float
  scalars retain raw signed-zero representations. Original vectors cover
  signed widths, bools, negative enums, pointer bits and explicit seeds;
  default scalar-key Hash_Table growth, find and removal now work.
- Added Unix Basic working-directory get/set and exit. getcwd grows its buffer
  on ERANGE and asserts other failures rather than fabricating a directory.
- File_Visit_Info is now declared once in a portable private module and exported
  on all targets. The Unix filesystem code aliases that same declaration.
  Its former Unix-only facade visibility was a reviewed shape omission.
- Added Unix visit_files, is_directory and add_modtime_and_size_if_missing
  using their synchronized reviewed signatures. Traversal uses real lstat/stat,
  detects ancestor cycles, respects callback pruning, and returns errors from
  directory opening, reading and closing.

Verification uses source-built compiler/jailint from the compiler worker's NEW
independent Rust sources copied into target/foundation-integration, plus NEW
POSIX bindings copied read-only from the bindings worker. No peer checkout is
modified. Source snapshots and build outputs are durable under target/.

Commands:

```
python3 tools/check_foundations.py --jaic target/peer-compiler/debug/jaic --stdlib target/foundation-integration/stdlib --jaifmt target/jaifmt --cross
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jailint -D warnings [owned paths]
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jaic jaifmt/main.jai -O2 -exe target/jaifmt
target/jaifmt [owned paths]
target/jaifmt --check [owned paths]
```

The focused runner checks nine real cases in interpreter/native O0/O2 and
type-checks unused code on Linux x64/arm64, macOS arm64, Windows x64, and wasm64.
Working-directory and native filesystem APIs are Unix-only and those cases are
not requested on Windows/wasm. Other cases run unchanged across those checks.
Filesystem coverage uses real files/directories and tests binary content,
hard-link self-copy protection, truncation, empty-directory preservation,
destination-inside-source rejection and rename. Builder checks also pass with
`-add 'ENABLE_ASSERT :: true;'` in the interpreter.

Unchanged real jaifmt/main.jai builds at O2 against production core APIs. Its
CLI regression covers dirty-file --check exit status, recursive rewrite,
hidden-directory pruning, stdin and idempotence. Owned Basic builder/formatting,
String, Hash and File_Utilities facades/internals and focused tests were
formatted with this executable; --check passes. Source-built jailint passes
with warnings denied over the same scope.

Full float/aggregate formatting, the scalar FNV operation's unresolved byte/
word behavior, and non-Unix filesystem backends remain incomplete. See the
[focused questions](specs/stdlib/foundations-questions.md) for exact missing
contracts. Full integration/corpus/release verification remains coordinator work.
