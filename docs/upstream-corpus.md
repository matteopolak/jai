# Recent upstream compatibility corpus

## What it is

Pinned source snapshots from seven recently maintained Jai projects expand compatibility beyond the February 2025 local distribution. Recent application/library source takes precedence when it demonstrates syntax or APIs that differ from the local snapshot.

## How it works

`corpus/upstreams.json` records exact Git commit IDs, latest Jai-source change dates, file sizes and SHA-256 hashes. Selection requires an actual `.jai` change since 2025-10-01, not just repository metadata activity. All seven suggested projects meet that cutoff at these revisions:

| Project | Latest Jai change | Pinned revision | Jai files |
| --- | --- | --- | ---: |
| [Focus](https://github.com/focus-editor/focus) | 2026-08-19 | `c6b3ead7d4174527d0138e8a31f7c3c5663badec` | 211 |
| [The Way to Jai](https://github.com/Ivo-Balbaert/The_Way_to_Jai) | 2026-01-21 | `19cb4b7acb0de2798c769f9ad73313a4d15f4056` | 375 |
| [Jails](https://github.com/SogoCZE/Jails) | 2026-09-09 | `42fa76c816ad34c9f24a4bde586d145c992dc860` | 14 |
| [jaison](https://github.com/rluba/jaison) | 2026-04-19 | `2009cdb5895d36020b5a3e6be8976db4706518a9` | 6 |
| [OpenJai](https://github.com/withlang-dev/open-jai) | 2026-05-26 | `264ba53218bf0e55bbc328197b312fe704496224` | 633 |
| [Vk-Engine](https://github.com/ostef/Vk-Engine) | 2026-09-08 | `cc91b617d93d13144c947fba925c6c64594ac1d7` | 161 |
| [sgpu](https://github.com/roeyb1/sgpu) | 2026-08-27 | `8ad94f50a50a73ab260403673d09d844830003e3` | 40 |

Submodule dependencies (`DEPENDENCIES` in `tools/fetch_upstreams.py`, currently [jai_parser](https://github.com/SogoCZE/jai_parser) for Jails) are pinned the same way but exempt from the recency cutoff. `MODULE_LINKS` symlinks them (and jaison/unicode_utils) into the consumer's `modules/` directory, where its submodules would live.

The fetcher downloads `.jai` files, README files, license notices and the data files a project reads at compile time (`RESOURCE_PREFIXES`: focus's `config/`, `fonts/`, `images/`, `themes/`), into gitignored `corpus/upstream/`. Git's bare metadata cache lives under ignored artifacts; no repository checkout, upstream compiler, native object, installer or build script executes. Existing manifest revisions remain pinned even if the remote default branch advances.

The corpus is acceptance input. Preserve source and license notices; do not copy another compiler's implementation into this rewrite. OpenJai describes a Jai-style language and incomplete alternate compiler, so use its programs to reveal requirements while resolving contradictory language claims against recent real Jai consumers and supplied language documentation. Its README's compile-through claims are not verification of this compiler.

Focus documents a minimum Jai version of 0.2.029, newer than local 0.2.009. Its formatting-escape here-string syntax `#string,\% TAG` exposed a lexer gap and now has a regression test. jaison demonstrates integer truthiness, polymorphism, reflection, notes, multiple results and import modifiers. Jails requires compiler workspaces, metaprogram diagnostics and `#exists`. sgpu adds `#import,file`, module parameters, Vulkan/VMA/Slang bindings and platform branches.

## How to change it

Run `python3 tools/fetch_upstreams.py`, then `python3 tools/verify_upstreams.py` and `cargo test -p jai-lexer --test upstream --locked -- --ignored`. Python 3.11+ is required. Verification rejects modified/unlisted inputs. Source updates must deliberately change the manifest pin, then fetch and review the diff, dependency requirements and recency; do not silently follow a moving branch during CI.

Track parsing, semantic checking, code generation, linking and execution separately. All 1,440 sources pass lexical tests; no complete upstream project build has passed yet. Negative tests, support modules and platform-specific files are not independent build entrypoints. Do not count their lexical acceptance as compilation.

## Configuration

`--since YYYY-MM-DD` sets the selection cutoff when preparing the manifest. Existing pins remain fixed. Corpus benchmarks are opt-in through `tools/benchmark.py --upstream` or Divan's `--ignored` flag.

## Dependencies

Git, Python's standard library, GitHub's Git service and immutable raw source URLs. Native project builds will additionally require genuine module implementations, inspected/rebuilt external libraries and platform SDKs; these have not been implemented or verified yet.
