# Rule coverage

## What it is

Traceability from the language docs to tests. Every normative claim in `docs/language/*.md` and
`docs/metaprogramming/*.md` carries a stable rule ID, and every rule should be pinned by at least one
test that cites it. `tools/check_rule_coverage.py` reports rules without a test and tests that cite
a rule no doc defines.

## How it works

**Rules.** A claim is marked with `{#prefix.N}` right after it, for example
"Members count up from zero {#enum.1}". `prefix` names the doc (table below), `N` counts up in
document order. IDs are stable: when a claim is removed its number is retired, not reused, and new
claims get the next free number wherever they appear in the doc. Markers inside fenced code blocks
are ignored, so a code example's claim is marked in the prose next to it.

**Citations.** A test names the rules it pins in a comment line anywhere in the file:

```jai
// rules: enum.1 enum.4, enum.7
```

The checker reads `.jai` files under `tests/` (the corpus, `tests/stdlib`, examples) and
`stdlib/**/tests/`, and `.rs` files under `crates/**/tests/` and the parser/sema `tests.rs` modules.
Rules about rejected programs are pinned by negative corpus cases
(`tests/corpus/negative/rule-<prefix>-<N>.jai` plus a manifest entry with the expected diagnostic).
Corpus files are hash-locked by `tests/corpus/manifest.json`, so a corpus case cites rules in its
manifest entry instead (`"rules": ["ctexec.9"]`); the checker reads both.
Most other rules are pinned by one self-checking program per doc, `tests/stdlib/rules-<doc>.jai`,
which asserts each claim and is run by the sweep's `stdlib` set.

**Report.** `python3 tools/check_rule_coverage.py` prints `N rules, C covered, U uncovered`;
`--list-uncovered` lists the uncovered rules with their doc line, `--json` gives the full report.
It exits 1 when a test cites an unknown rule or an ID is defined twice, and 0 otherwise: uncovered
rules are reported, not yet enforced. CI runs it as the `Rule coverage` step of `ci.yml`.

| Prefix | Doc | Prefix | Doc |
| --- | --- | --- | --- |
| `overflow` | arithmetic-overflow-checks | `ptr` | pointers-and-arrays |
| `cast` | casts-and-conversions | `poly` | polymorphism |
| `ctx` | context | `proc` | procedures |
| `flow` | control-flow | `scope` | scoping |
| `decl` | declarations-and-constants | `asm` | simd-asm |
| `note` | directives-and-notes | `str` | strings-and-literals |
| `enum` | enums | `struct` | structs |
| `extdata` | external-data | `typeval` | type-values-and-info |
| `intrin` | intrinsics | `union` | unions |
| `ext` | long-double | `using` | using |
| `lambda` | lambdas | `code` | code-values-and-insertion |
| `macro` | macros-and-custom-iteration | `ctdata` | compile-time-data-and-state |
| `modparam` | module-parameters | `ctexec` | compile-time-execution |
| `import` | modules-and-imports | `compiler` | compiler-module |
| `must` | must-and-discard | `records` | compiler-records |
| `num` | numbers | `plugin` | metaprogram-plugins |
| `opov` | operator-overloading | `prelude` | prelude-and-runtime-support |
| `ops` | operators | `reflect` | reflection-and-type-info |
| `dce` | dead-code-elimination | `ws` | workspaces |

## How to change it

- New claim in a doc: add `{#prefix.N}` with the next unused number for that doc, then a test that
  cites it (extend `tests/stdlib/rules-<doc>.jai`, or add a negative case).
- Changed claim: keep the ID if the claim is the same rule restated; give a new ID if the rule
  changed meaning, and update the citing tests.
- A failing rule test means jaic and the doc disagree. Decide from public Jai sources which one is
  wrong; fix the compiler, or correct the doc with a note saying what changed and why.
- New prefix: add it to the table above (the checker does not need to know prefixes).
- To enforce coverage later, make the script exit non-zero when `uncovered` is not empty.

## Configuration

`DOC_DIRS` and `TEST_GLOBS` at the top of `tools/check_rule_coverage.py`. Tests:
`tools/test_check_rule_coverage.py`.

## Dependencies

Python 3 standard library. The cited tests run under [jaic-sweep](jaic-sweep.md) (`stdlib`,
`negative`, `corpus` sets) and `cargo test`.
