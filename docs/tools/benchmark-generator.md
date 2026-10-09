# Corpus-shaped benchmark generator

## What it is

`tools/jaistats.py` measures the shape of real Jai code (the [upstream corpus](upstream-corpus.md)) and
`tools/benchgen.py` samples from that shape to write compilable programs of a chosen size. They exist so that
compile-speed work (see [compile speed](../compiler/compile-speed.md)) can be measured on code that looks like
code people write, at 10k, 60k or 240k lines, without a big project in the tree. This is not
[`jaigen.py`](differential-testing.md), which generates small semantics-stressing programs for differential
testing.

## How it works

`jaistats.py` blanks comments and string contents, then finds `name :: (...) {`, `struct`, `union` and
`enum` bodies with regular expressions and brace matching (no parser). It writes `tools/corpus-shape.json`:

- procedure body lines (quantiles and a bucketed histogram), parameter counts, nesting depth;
- struct field counts, enum member counts;
- shares of polymorphic procedures, `#expand` macros and polymorphic structs;
- control-flow, `cast`, `print` and literal density per statement;
- binary operators per statement, string literals per kloc, `#run`/`#insert`/`#if` densities, imports,
  parameter, return and field type mixes.

The committed file comes from `python3 tools/jaistats.py --out tools/corpus-shape.json` over the whole
corpus (1,963 files, 373k code lines, files above 20k lines skipped as generated bindings). Declaration
density is high in the corpus because many projects ship FFI bindings (28 `#foreign` per kloc), so the
counts of structs and enums are skewed toward bindings; the generator uses them anyway.

`benchgen.py` keeps adding items (enum, struct, polymorphic struct, procedure, polymorphic procedure,
`#expand` macro, `#run` table, `#insert`, `Table` user) with probabilities from the measured densities until
the line budget is used, then adds driver procedures that call every procedure once, and a `main` that
prints a checksum. Procedure bodies are built from typed statements (declarations, assignments, `if`/`else`,
`for` over ranges and arrays, `while`, `if x == { case ... }` on enums and integers, calls to earlier
procedures, `tprint`, casts, array literals, polymorphic calls) in the measured proportions.

Properties the output keeps, because the programs must be valid and deterministic whatever compiler builds them:

- Only `Basic`, `Math`, `String` and `Hash_Table` are imported.
- Loops have constant trip counts and calls carry a cost estimate, so a program runs in milliseconds.
- No operator-precedence reliance: binary operations are parenthesised, so chains like `a % b / c` never
  appear.
- Narrowing uses `cast,trunc`; parameters are never assigned; `acc += f()` is written
  `r := f(); acc += r` because the order is undefined when `f` changes `acc`.
- Struct field names never collide with primitive type names.

The checksum is the same for every correct compiler and backend. Use `--trace` to print it after every driver
call when two builds disagree.

Known deviations from the corpus shape: procedure bodies are a little longer at the median (blocks
overshoot small targets), `cast` density is far above the corpus (the typed-field mix needs casts), string
literal density is lower, and there are no pointer-heavy data structures or `defer`-heavy cleanup.

```sh
python3 tools/benchgen.py --lines 60000 --seed 2 --out /tmp/gen60k      # main.jai
python3 tools/benchgen.py --lines 60000 --files 8 --out /tmp/gen60k-8    # main.jai + part_N.jai via #load
jaic build /tmp/gen60k/main.jai -o /tmp/gen60k/out && /tmp/gen60k/out    # checksum NNN
python3 tools/jaistats.py /tmp/gen60k --max-file-lines 10000000          # shape of any directory
```

`tools/compile_bench.py` has `gen-10k`, `gen-60k` and `gen-240k` workloads (`check` and `build-O0`, seed 1)
that generate into a temporary directory; see [compile-time benchmark](compile-time-benchmark.md).

## Reference numbers

jaic 0.5.1 on an Apple M5 (10 cores, 16 GiB), release build, seed 1, `tools/compile_bench.py --only gen- --repeat 6`
(warm median). "Code lines" counts non-blank, non-comment lines of the generated file only (comments and strings
blanked by `jaistats.py`); standard-library lines are not counted.

| workload | code lines | check s | build -O0 s | build lines/s | front end s | codegen s | link s | peak RSS MiB |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| gen-10k | 9.5k | 0.04 | 0.13 | 73k | 0.03 | 0.05 | 0.03 | 165 |
| gen-60k | 57k | 0.13 | 0.42 | 136k | 0.13 | 0.22 | 0.04 | 517 |
| gen-240k | 228k | 0.47 | 1.50 | 152k | 0.48 | 0.88 | 0.06 | 1579 |

On these, `codegen` (LLVM) is about 60% of an `-O0` build, the front end about 30% and `link` 3 to 5%. With one
codegen unit the 240k build's codegen takes 3.3 s, against 0.88 s on ten units, so the units use about twice
the CPU time of one (7.1 s user for the whole build against 3.6 s with one unit). Leaving out debug info
(`--no-debug-info`) saves 0.25 s (17%) at 240k lines.

## How to change it

- New statement or declaration kind: add a branch in `Gen.stmt` (statements) or a `Gen.emit_*` method plus a
  case in `Gen.generate`'s item loop. Check a sweep of seeds with `jaic check` and `jaic build` (run the result and compare
  `--trace` output between `-O0` and `-O2`).
- Changing any probability changes every program for a seed, so numbers from before and after are not
  comparable. Say so in the commit that does it.
- Refresh the shape with `jaistats.py` after the corpus changes; the generator reads only the keys it uses.
- Tests: `python3 -m unittest tools/test_benchgen.py`.

## Configuration

- `benchgen.py --lines N --seed S --files F --shape FILE --trace --out DIR`. Deterministic for a given
  seed, line count and shape file.
- `jaistats.py [DIR ...] [--out FILE] [--max-file-lines N]`.

## Dependencies

Python 3.11+. No third-party packages. The corpus (`tools/fetch_upstreams.py`) is needed only to
re-measure the shape.
