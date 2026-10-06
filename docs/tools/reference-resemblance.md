# Reference resemblance check

## What it is

`tools/check_reference_resemblance.py` is a maintainer safeguard for the clean-room `stdlib/`. It flags stdlib code that looks copied or closely paraphrased from an official Jai distribution's modules.

Contributors must not read the source of an official Jai distribution at all, and don't need a copy: the stdlib is written from public documentation, third-party Jai code and this repository's tests ([stdlib architecture](../stdlib/architecture.md)). Maintainers with a local copy under `reference/` run the check over stdlib changes:

```sh
python3 tools/check_reference_resemblance.py                 # whole stdlib
python3 tools/check_reference_resemblance.py stdlib/BuildCpp.jai stdlib/Basic
```

`reference/` is gitignored. Without it the script prints a skip message and exits 0, which is why it is not part of CI. Its unit test (`tools/test_check_reference_resemblance.py`, synthetic fixtures only) runs in CI with the other `tools/test_*.py`.

## How it works

Each `.jai` file is scanned into per-line code and comment text (block comments, string literals and `#string` here-strings are handled, so braces inside them do not confuse the structure). Three checks run:

- **runs**: lines are whitespace-normalized and filtered down to "significant" lines. Excluded: braces and other short lines (under 12 characters or fewer than two words), imports/`#load`/`#scope_*`, procedure, operator, struct/enum/union and `#foreign` declaration lines, platform switches (`#if OS == ...`, `#assert`, bare `else`), numeric data rows, everything inside struct/enum bodies (fields and their defaults are API), and declarations outside procedure bodies (constants, globals, type aliases). A run is 3+ consecutive significant lines that also appear consecutively in *any* reference module; the longest match is reported once.
- **procs**: for each procedure body in a stdlib module with at least 7 non-blank lines, the token sequence (identifiers, literals, punctuation; comments dropped) is compared with every same-named procedure in the same reference module using `difflib.SequenceMatcher`. A ratio of 0.85 or more is flagged; renaming locals does not get below that.
- **comments**: comment lines of 15+ characters and 4+ words are lowercased and stripped of punctuation. Adjacent reference comment lines are merged (sentences wrap), and a stdlib comment is flagged when 80% of its words appear, in order, inside one reference comment of the same module.

"Same module" means the first path component: `stdlib/Basic/Print.jai` is compared with everything under `reference/modules/Basic/`, and `stdlib/Sort.jai` with `reference/modules/Sort.jai`.

Output is one line per finding, sorted by file and line. The stdlib side is given in full (`file:start-end`, procedure name, the stdlib comment text); the reference side only as `reference/modules/...:line`, so reference text never lands in logs or commits. Exit status: 0 clean or skipped, 1 findings.

```
stdlib/Foo.jai:40-52: 9 consecutive lines match reference/modules/Foo.jai:118
stdlib/Foo.jai:61: procedure 'parse' (23 lines) is 0.91 token-similar to reference/modules/Foo.jai:140
stdlib/Foo.jai:12: comment 0.83-similar to reference/modules/Foo.jai:9: //counts the widgets drawn this frame
```

## How to change it

- Fix a finding by rewriting the code from a behavioral spec (different decomposition, names and comments), not by nudging tokens until the score drops.
- Thresholds are constants at the top of the script (`RUN_LENGTH`, `PROC_SIMILARITY`, `PROC_MIN_LINES`, `COMMENT_MIN_CHARS`, `COMMENT_MIN_WORDS`, `COMMENT_SIMILARITY`). Line filters live in `is_trivial` and `analyze`; add a regex there when a whole class of lines is unavoidable boilerplate, and add a fixture to the unit test.
- Allowlist: `tools/reference_resemblance_allow.txt`, one entry per line: `<glob> <checks> <reason>`. The glob is matched against `stdlib/<path>` with `fnmatch` (`*` also crosses `/`). Checks are a comma list of `runs`, `procs`, `comments`, `all`, or `proc:<name>` for one procedure. A reason is mandatory. Binding modules (POSIX, Windows, Vulkan, GL, X11, d3d*, ImGui, ...) get `runs,comments`, because declaration order and header comments follow the C ABI and headers; they stay subject to `procs`, so hand-written helpers inside them are still checked. Use `proc:<name>` for an unavoidable tiny procedure rather than allowing a whole file.
- Known limits: top-level `#scope_file` constants are skipped like public ones; a copy that interleaves new lines every two lines escapes the run check (the procedure check usually still catches it).

## Configuration

- `--reference PATH`: reference distribution root (must contain `modules/`). Without it the script tries `$JAI_REFERENCE`, then `reference/` in this checkout, then `reference/` next to the main checkout's `.git` (so it works from a git worktree).
- `--stdlib PATH`, `--allow FILE`: override the stdlib tree and allowlist.
- `--only runs|procs|comments` (repeatable): run a subset.
- Positional paths limit the stdlib files checked; all reference modules are still indexed for runs.

## Dependencies

Python 3.9+ standard library (`difflib`, `fnmatch`), `git` for locating the main checkout.
