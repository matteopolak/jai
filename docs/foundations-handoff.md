# Core foundations handoff

This work owns Basic builder/formatting, String utilities, Hash scalars and
File_Utilities. Inherited spec, argument/runtime and Command_Line edits are
retained in the worktree and excluded from foundations commits.

Implemented progress:

- Removed the invented standalone Basic.Buffer facade. The canonical
  String_Builder.Buffer declaration and optional ensured_count layout remain.
- Added the reviewed builder print overload and temporary-storage tprint.
  Numbered `%N`, sequential `%0`, and escaped-percent directives follow the
  reviewed grammar. Invalid selections are omitted, logged according to the
  style, and reset the sequential cursor; extra arguments are ignored.
  Only builder failure makes the builder interface return false.
  Builder print and print_to_builder are true aliases with tested callable
  identity. Added expand and append_and_steal_buffers; inline bytes are copied,
  heap buffers transfer only between matching allocators, and differing
  allocators take a copy-and-release path.
- Added canonical Formatter and FormatInt records, formatInt and real integer
  formatting for bases 2–64, minimum digits capped at 64, padding and grouping. Signed
  minimum and unsigned maximum values are covered.
  Added the reviewed FormatFloat, FormatStruct, FormatArray and Print_Style
  records and real formatFloat/formatStruct constructors, with tests for
  canonical names, promoted value storage, nested enums and defaults.
  Float rendering supports decimal/scientific/shortest modes, rounding,
  explicit precision padding, zero removal, prefixes, grouping, separators,
  signed zero, NaN and infinity. Original portable integer arithmetic supplies
  exact decimal conversion and ties-to-even binary rounding; no numeric libc
  imports remain. Shortest mode searches significant precisions until the source width
  round-trips. Aggregate rendering supports reflected member filtering,
  long/short forms, doubled name separators, indentation, array truncation,
  nested string quoting, enum flags, variants, pointers and custom printers.
  Formatter wrappers expand only at top level. Type names cover ordinary
  scalars, records, pointers, arrays and procedure types. Default-filtered
  generic names explicitly diagnose missing compiler default metadata.
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
  Added is_integer_type from reflection metadata and sleep_milliseconds using
  nanosleep with EINTR retry (Sleep on Windows). The Unix sleep regression
  measures elapsed monotonic time; it does not accept an empty sleep stub.
- File_Visit_Info is now declared once in a portable private module and exported
  on all targets. The Unix filesystem code aliases that same declaration.
  Its former Unix-only facade visibility was a reviewed shape omission.
- Added Unix visit_files, is_directory and add_modtime_and_size_if_missing
  using their synchronized reviewed signatures. Traversal uses real lstat/stat,
  detects ancestor cycles, respects callback pruning, and returns errors from
  directory opening, reading and closing.
- Windows Basic get/set working directory and exit, plus File_Utilities
  metadata, copy/rename, visitation, file lists, directory copy and path-prefix
  existence helpers now have real wide-Win32 implementations. UTF conversions
  reject invalid input; file identities prevent ancestor cycles and copying a
  source inside itself. These have been cross-checked, not executed on Windows.
  [Native ABI details and sources](foundations-native-abi.md) document the narrow
  private supplements and platform limits.

Verification uses source-built compiler/jailint from the compiler worker's NEW
independent Rust sources copied into target/foundation-integration, plus NEW
POSIX/Windows bindings copied read-only from the bindings worker. No peer checkout is
modified. Source snapshots and build outputs are durable under target/.

Commands:

```
python3 tools/check_foundations.py --jaic target/peer-compiler/debug/jaic --stdlib target/foundation-integration/stdlib --jaifmt target/jaifmt --jailint target/peer-compiler/debug/jailint --cross
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jailint -D warnings [owned paths]
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jaic jaifmt/main.jai -O2 -exe target/jaifmt
target/jaifmt [owned paths]
target/jaifmt --check [owned paths]
```

The focused runner now contains twenty-six real cases in interpreter/native O0/O2.
`--wasm` also builds/executes each supported case at O0/O2 under Node WASI,
rejecting all non-WASI imports instead of supplying fake env functions.
Unused-code checks pass on Linux x64/arm64, macOS arm64, Windows x64/arm64 and
wasm64. The Windows-specific fixture is also cross-checked on both Windows
CPUs, including callback instantiations; it requires an actual Windows host
to execute and is not counted as a host runtime pass. Unix File-dependent
fixtures are not requested on Windows/wasm; process exit is not requested on
wasm because that target has no reviewed Basic.exit export.
Filesystem coverage uses real files/directories and tests binary content,
hard-link self-copy protection, truncation, empty-directory preservation,
destination-inside-source rejection and rename. A root-level
`-add 'ENABLE_ASSERT :: true;'` does not configure imports. The reviewed Basic
module parameter now defaults true and propagates through the facade to its
canonical private instance. Default/on imports share builder type identity;
off imports omit ensured_count and select the discard assertion declaration.
Both layouts/capacities and ensured counters are tested. Discarded argument,
message and variadic expressions have zero side effects. All five reviewed
parameters now propagate, including the exact constrained replacement type.
The canonical shared interface has the reviewed four inline no-op hooks;
the default sentinel selects real tracking, and replacements preserve their
canonical type identity. Allocation helpers, arrays, builder heap buffers and
temporary backing pages route real notifications. Failed resize retains old
ownership. Heap lifecycle helpers call the allocator's actual modes.
Default tracking validates live/retired allocator identity with synchronized
updates. Visualization controls real per-frame counters and logger summaries;
precise transport remains a question, not a claim of native GUI integration.
Temporary overwrite mode stamps rolled-back/reset/freed storage, including
overflow payloads inspected by a test allocator before release.
Additional cases cover actual stdout/stderr bytes and returned counts,
temporary/normal string lifetime, process exit status 17, allocator identity
during builder transfer, symlink following/filtering and traversal cycles.
file_list now shares the real visitor rather than maintaining a duplicate
walker that incorrectly reported an ancestor link as a filesystem error.
copy_file rejects a directory source before opening the destination, preserving
an existing destination when that source is invalid. A real regression first
exposed destination truncation and now verifies preservation as well as the
successful file-copy truncation behavior.

The expanded macOS x64 unused-code check FAILS in the peer POSIX declarations:
`__shmid_ds_new.shm_perm` references an undeclared ipc_perm for that target.
The current new binding source declares ipc_perm only for Linux and macOS
arm64. Reproducer: tests/portable-stdlib/pending/macos-x64-posix.jai, with
`-check -no_dce -os macos -cpu x64`. No peer file was changed and no placeholder
native layout was introduced. The --cross runner continues independent
targets but returns failure for the overall run until this is resolved.

Unchanged real jaifmt/main.jai builds at O2 against production core APIs. Its
CLI regression covers dirty-file --check exit status, recursive rewrite,
hidden-directory pruning, stdin and idempotence. Owned Basic builder/formatting,
String, Hash and File_Utilities facades/internals and focused tests were
formatted with this executable; --check passes. Source-built jailint passes
with warnings denied over the same scope.

Assertion messages now format their arguments before dispatching to the
context callback. A focused regression checks message bytes, caller location,
callback return and the successful-assert path; the old implementation fails
the original regression with exit 2 because it drops the arguments. The
portable test now validates all captured results with the default callback
restored, avoiding an unavailable Wasm exit export.

Four additional runtime rejection programs verify that integer/float formatter
kind mismatches, base 65 and negative minimum digits assert in the interpreter
and native O0/O2. Truncated arrays append a separator after the last printed
element only when requested, including before the early-stop marker; an
original regression exposed and corrected the extra separator. Shortest float
round-trip vectors include subnormals, normal boundaries, adjacent values and
the largest finite positive/negative representations.
Aggregate checks also cover empty fixed/view arrays, the default 100-element
limit, null formatter values and incompatible struct formatting with logging
enabled and disabled.

Remaining formatter/debugger visualization compatibility details and
the scalar FNV operation's unresolved
byte/word behavior remain incomplete. Windows runtime testing remains required;
Windows jaifmt also depends on the portable worker's File/runtime backends.
See the
[focused questions](specs/stdlib/foundations-questions.md) for exact missing
contracts. Full integration/corpus/release verification remains coordinator work.

Prior formatter checkpoint retained the peer POSIX macOS/x64 failure above.
All seventeen cases and four formatter assertion cases passed
interpreter/native O0/O2. Six independent cross-target checks passed after
the assertion test was made portable; macOS x64 failed as recorded.
Real jaifmt format/check and warnings-denied
jailint passed over Basic's facade, changed formatter/scalar sources, builder,
integer128/parsing, the Windows filesystem source and all changed positive
tests. Inherited allocation/time/array/temporary/File code was retained. See
the deviations report for remaining limits and
precise exclusions.

The focused runner now exposes `--jailint` and checks the exact owned source
scope with jaifmt --check and jailint -D warnings, in addition to real CLI
behavior and execution tests. Current configuration/notification work includes
the modified allocation/array/temporary helpers in owned formatting/lint scope;
their previous functionality is preserved. Time/runtime/File/MD5 remain outside
that scope. The previous pending
default-metadata reproduction is now promoted to a passing regression using
NEW compiler default metadata. Generic formatting includes names and values,
elides matching defaults, retains required parameters and evaluates dependent
defaults with actual preceding bindings. type_to_string has reviewed temporary
lifetime. No earlier generic-default blocker remains.

The producer compiler's context-slot regression temporarily blocked real
jaifmt and jailint. The original pending/context-overload-probe reproduced it
without Basic. NEW producer sources now initialize all scratch contexts through
the context-state API; copied read-only and rebuilt in own durable staging.
Latest real build/lint/runtime outcomes are maintained in foundations-progress
and foundations-deviations. No compiler or peer source was edited here.

Latest checkpoint: 26 cases pass interpreter/native O0/O2 and 21 supported
production WASI cases pass O0/O2, with all non-WASI imports rejected. Five
runtime assertion cases pass their rejection checks. Real unchanged jaifmt
rebuild/CLI/check and scoped warnings-denied jailint pass. Direct binary32
parsing now avoids double rounding at exact halfway/subnormal/overflow edges.
Default debugger metadata is live-only and reclaimed, preventing false failure
when addresses are reused by another Basic configuration. Default/custom tests
cover real heap allocations/destruction, failed resize, ownership diagnostics,
visualization flags and canonical replacement/interface aliases.

The runner additionally requires binding-time rejection of an invalid unused
module interface. Current compiler accepts the original minimal reproducer,
so the overall run fails despite the execution passes. This is a general
compiler request, not a Basic-only guard. Six targets pass unused-code checks
of all newly affected cases; macOS x64 now fails in refreshed POSIX on missing
itimerval rather than the earlier ipc_perm. Both failures are preserved.
