# Regex benchmark

## What it is

`tools/regex_bench.py` compares jaic's `Extensions/Regex` with other regex engines on one generated 16 MB corpus: throughput for counting all matches, typed-captures throughput, pattern compile time, and a check that every engine finds the same matches. The latest results are in [`benchmarks/results/regex.md`](../../benchmarks/results/regex.md), with the machine's CPU in the header.

| Engine | Variant | Notes |
| --- | --- | --- |
| Jai `Regex.Static` | precompiled | patterns are compiled by `jaic` while the program compiles |
| Jai `Regex.compile` | runtime | |
| Rust `regex` 1.13 | runtime | the reference for correctness |
| Rust `regex-automata` dense DFA | precompiled | built by `build.rs`, deserialized zero-copy (`DFA::from_bytes`) |
| RE2 | runtime | |
| PCRE2 with JIT | runtime | `PCRE2_UTF \| PCRE2_UCP` |
| CTRE 3.9.0 | compile time, header-only | closest analogue of `Regex.Static` |
| Hyperscan (vectorscan) | runtime | optional |

Not included: Zig (no regex in its standard library; not installed) and `std::regex` (libc++'s backtracking matcher recurses per character, so a 16 MB subject overflows the stack, it has no `\p{Greek}`, and it is orders of magnitude slower).

## How it works

```
python3 tools/regex_bench.py                       # everything, writes benchmarks/results/regex.md
python3 tools/regex_bench.py --engines jai,rust --cases date,wordb --runs 3 --no-write
python3 tools/regex_bench.py --list
```

The runner:

1. Generates the corpus with `python3 -I benchmarks/regex/corpus.py` into `benchmarks/regex/target/` (gitignored). A seeded generator writes the same bytes everywhere: 7/8 English-like ASCII prose with planted dates, e-mails and names, 1/8 Greek, Cyrillic, CJK and accented Latin. It never contains `zzz` or `hello` and uses no combining marks.
2. Builds one harness per engine group and runs them one after another, one process at a time. A harness reads the corpus into memory, then for each case prints a tab-separated line: `RESULT engine case status count check mbps compile_us note`. `mbps` is the best of N timed runs. `check` is a checksum of the captured date groups (0 for count-only cases). Compile time is the best of 20 compiles.
3. Compares each engine's `count` and `check` with Rust `regex`. A difference prints a `CORRECTNESS MISMATCHES` list on stderr and marks the cell with a warning sign and a footnote. An engine that cannot express a pattern reports `n/a` with the reason, which becomes a footnote.
4. Prints the Markdown report and writes it to `benchmarks/results/regex.md`.

Layout:

| Path | What |
| --- | --- |
| `benchmarks/regex/cases.tsv` | case id, pattern, description |
| `benchmarks/regex/corpus.py` | the corpus generator |
| `benchmarks/regex/jai/bench.jai` | Jai harness (both `Regex.Static` and `Regex.compile`) |
| `benchmarks/regex/rust/` | separate crate (own `Cargo.lock`, own `[workspace]`): `regex` and the dense DFAs from `build.rs` |
| `benchmarks/regex/cpp/` | `common.h` plus one harness each for RE2, PCRE2, CTRE and Hyperscan |
| `benchmarks/regex/target/` | build products, the corpus and the CTRE checkout; gitignored |

Why some cells differ or are `n/a`:

- RE2, CTRE and (as a fallback) Hyperscan have ASCII-only `\w` and `\b`, so `\b\w+\b` finds a different number of words in the Unicode part of the corpus. That is reported as a mismatch rather than hidden. PCRE2 runs in UCP mode, so it agrees.
- Hyperscan reports every match end. The harness asks for start-of-match offsets and counts a match only when it starts after the previous counted one. It tries Unicode classes first and falls back to ASCII classes with a note (`\w+@\w+\.com` is too large, `\b` is unsupported with UCP).
- A DFA reports match bounds only, so the dense DFA has no captures case, and it cannot build Unicode `\b`.
- The dense DFA search is forward only: it finds where each leftmost-first match ends and resumes there, which is all a count needs.

## How to change it

- **A new case**: add a line to `benchmarks/regex/cases.tsv`. The Rust, RE2, PCRE2 and Hyperscan harnesses read it at run time, and `build.rs` builds a DFA for it. Then add the id by hand to the harnesses that spell patterns in code: a `bench_static(..)` and `bench_runtime(..)` line in `jai/bench.jai` (with a `Regex.Static` constant), a `PLAIN_CASE(..)` line in `cpp/ctre.cpp`, and the id in the `dfa_bytes!` list in `rust/src/main.rs`. A case with captures needs a checksum in every harness (see `caps`).
- **A new engine**: write a harness that takes `CORPUS RUNS [CASES_TSV] [CASE...]` and prints `RESULT` lines as above, then add it to `ENGINES`, `ENGINE_NOTES`, `GROUPS`, the precondition block in `main()` and `build_and_run()` in `tools/regex_bench.py`. A missing library should set `report.skipped[group]` instead of failing.
- **Pin a newer Rust crate**: edit `benchmarks/regex/rust/Cargo.toml` and run `cargo update` in that directory; commit `Cargo.lock` (the build uses `--locked`).
- **Gotchas**: run only one engine at a time (the machine this was written on has 16 GiB, and timings of two parallel runs disturb each other). Clang 23 needs `-Wno-missing-template-arg-list-after-template-kw` for CTRE 3.9.0; the runner passes it. Throughput of prefilter-driven engines (Rust, PCRE2) depends heavily on match density, so a new case with different density changes the ranking.

## Configuration

- `--engines` takes harness groups (`jai`, `rust`, `re2`, `pcre2`, `ctre`, `hyperscan`) or engine ids; `--cases` takes case ids; `--runs` (default 7), `--size-mb` (16), `--seed` (1), `--timeout` (seconds per harness), `--skip-build`, `--no-write`, `--out`.
- `JAIC` or `--jaic` selects the compiler; otherwise `$CARGO_TARGET_DIR/release/jaic`, `target/release/jaic`, then `PATH`, then the runner builds it with `cargo build --release -p jaic-cli`.
- `CXX` selects the C++ compiler (default `clang++`).
- The CTRE tag and commit are `CTRE_TAG` and `CTRE_COMMIT` in the runner. The release is cloned into `benchmarks/regex/target/ctre` and the commit is verified; nothing from CTRE is committed.

## Dependencies

- `jaic` with `Extensions/Regex`, built with `-O2`.
- Rust toolchain (`rust-toolchain.toml` applies); crates `regex` 1.13 and `regex-automata` 0.4, pinned in `benchmarks/regex/rust/Cargo.lock`.
- A C++20 compiler and the Homebrew libraries `re2`, `pcre2` and `vectorscan` (`brew install re2 pcre2 vectorscan`). A missing one skips that engine with a note.
- `git` and network access for the one-time CTRE fetch.
- Python 3.11 or newer, standard library only.
