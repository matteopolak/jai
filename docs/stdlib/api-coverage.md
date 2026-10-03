# Standard-library API coverage

## What it is

`tools/stdlib_api_inventory.py` inventories the public declaration contracts of the pinned historical and maintained library inputs and the independently authored `stdlib/` tree. Its local report separates declaration matching, source checks, family implementation reports, and behavior acceptance.

## How it works

The tool verifies original-source hashes against `corpus/reference-inputs.json` and `corpus/upstreams.json`. It finds named `.jai` modules and directory `module.jai` entrypoints, follows literal `#load` references, and scans declaration headers outside procedure bodies. Records retain ordered field and nested declaration identities; procedure signatures retain arguments, result shapes, defaults, and relevant modifiers. The report stores names, source lines, and hashes rather than original source bodies.

Each module has separate `historical-reference`, `maintained-openjai`, `authored-default`, or `authored-legacy` surface records. Comparisons never merge incompatible versions by spelling. A procedure with the same name and a changed default, result shape, or record layout is reported as a different contract. Foreign library locators and compiler implementation markers are excluded from the signature hash so an independently authored body can implement the same public interface.

Every reference surface is compared with the default module. A separately authored legacy module also gets its own comparison when present. `stdlib/api-coverage.json` is the compact reviewable manifest: per-module counts, compiler failures, family report hashes, and explicit evidence limits. The full compressed local report retains individual declaration identities and source receipts. Third-party libraries such as Jaison are acceptance inputs rather than replacement modules.

Both a top-level `Name.jai` and a `Name/module.jai` candidate are retained when present. Comparisons mark and use `Name.jai` for an ordered module search root, matching the compiler's search-root preference. Relative imports can resolve differently, so these lexical candidate records still do not establish full source-graph behavior. The summary separates candidate surfaces from distinct named modules.

The scanner inventories possible lexical declarations in every literal load and conditional branch. It is not the compiler's selected-platform export resolver: macro-generated APIs, dynamic loads, conditional scope selection, inferred type equivalence, and semantic reexports require the actual source graph. Hash matches are useful compatibility evidence; they do not establish semantic API completeness or working behavior. Empty bodies are counted explicitly, and no source body, compiler declaration, or foreign prototype is promoted to behavior acceptance.

Procedure headers may begin with `inline` or `no_inline` before the parameter list. The scanner retains that hint in the contract hash and skips the implementation body, so local declarations and following procedures cannot be mistaken for one aggregate constant. Reports created before this correction need regeneration; their lexical counts are historical.

Optional source checks invoke only an already frozen repository-built CLI. They parse authored source files and optionally check authored module entrypoints with the authored Preload. The compiler hash must remain unchanged during the run. Reports retain the exact source check command, configuration, exit status, and first diagnostic. Changed input bytes, added or removed sources, and changed family receipts invalidate the inventory snapshot rather than silently presenting mixed evidence.

Whitespace-only source cleanup still changes input hashes. Its receipts preserve the previous authored bytes and family reports, verify identical token streams and unchanged quoted/heredoc payloads, and record fresh lex/parse observations before refreshing the aggregate. Existing behavior evidence remains historical unless the behavior fixture is rerun; trivia normalization does not establish new native or runtime acceptance.

Family files in `stdlib/.coverage/` are retained as separate implementation attestations, with file hashes. Their wording and test scope remain visible. The inventory does not reinterpret a family claim as complete module acceptance.

`authored_implementation_forms` counts declaration occurrences across module load closures, where one file can appear in several surfaces. `authored_unique_production_implementation_forms` counts each production source file once and descends into nested declarations. Legacy files and test fixtures are excluded from that production count. Both are lexical counts rather than runtime implementation claims.

## How to change it

Update `FAMILIES` when adding a module or changing ownership. Extend the lexical declaration scanner only with focused examples that show a real inventory failure. Tests in `tools/test_stdlib_api_inventory.py` protect overload multiplicity, default and field changes, private helper exclusion, nested enums, implementation-independent signature matching, and snapshot source-set stability.

Add semantic export verification through the compiler graph when exact selected API coverage is needed; do not make the lexical report claim that stronger result. Keep maintained source revisions and historical compatibility reports separate when their field layouts or algorithms differ. A newly supported runtime operation needs actual VM or native tests in the owning family in addition to a declaration match.

## Configuration

```sh
python3 tools/stdlib_api_inventory.py
python3 tools/stdlib_api_inventory.py \
  --compiler target/standard-library-snapshots/COMPILER_SHA256/jai-rs \
  --check
```

`--output` defaults to `artifacts/stdlib-rewrite/api-inventory.json.gz`; a `.gz` suffix writes a gzip-compressed JSON report, while a `.json` suffix selects plain JSON. `--summary-output` defaults to `stdlib/api-coverage.json`, outside the family receipt directory to avoid recursively embedding previous inventories. Compression and streaming keep this large contract inventory from consuming the integration disk budget. `--compiler` must select a frozen `target/standard-library-snapshots/*/jai-rs` file. `--check` adds `check-library` for authored default entrypoints; source parsing is always included when a compiler is selected. `--timeout` bounds each subprocess and defaults to ten seconds. Four source-only subprocesses can run concurrently.

Source checks clear ambient `JAI_RS_*` settings, select `stdlib/` and its `Preload.jai`, and disable runtime support. This makes the report's source configuration explicit. The report records a frozen binary hash and independent input hashes with `compiler_build_inputs_verified=false`; those observations do not establish which Rust sources built that executable. Source parsing and checks do not emit or execute native programs.

## Dependencies

The tool uses Python's standard library, `check_corpus.inventory`, `library_source_inventory` source metadata/tokenization, and the shared source decoder. Optional checks use this repository's frozen Rust CLI. It never executes an original compiler, library binary, project build script, or external application, and it does not upload source files.
