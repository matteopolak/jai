# LSP partial-edit recovery

This work is for coordinator integration after 0.17.0, into 0.17.1. It changes no
version, release metadata, bootstrap definitions, public library exports or
Extensions sources.

The IDE parser first tries strict parsing. On failure it retains good statements
and enum members, discards malformed ones, and resumes at grammar boundaries:
semicolons, enclosing braces and subsequent lines. A missing closing brace can
end at a sibling declaration using indentation as a recovery hint. This is an
editor policy; the strict parser and CLI still reject the original malformed text.
Recovered syntax drives symbols, selection ranges and call hierarchy as well as
semantic checking. IDE declaration and statement checks continue after errors but
return failure for damaged bodies. They never supply fabricated local values or
make failed IR available to compile-time execution.

Incremental lexical recovery maps previously verified literal/comment boundaries
through the changed bytes. A damaged opaque region is omitted from the IDE view,
preserving byte offsets and newlines. The rest is checked from its current text.
No previous AST, definition, value or type is reused. Apparent code inside comments
and here-strings stays opaque. Open-document indexes provide UTF-16 positions for
definitions from such views. A local lexical diagnostic describes the omission.
Restoring valid text removes the recovery view. Fresh malformed documents have no
prior lexical boundaries; unterminated opaque regions remain conservative.

Custom iteration records a reference on the three-byte `for` keyword using the
actual overload selected by `call_procs`. A body failure does not erase a completed
selection. Named, aliased, imported and polymorphic expansions use their actual
source procedure. The association is recorded directly at overload selection,
independent of capped/deduplicated call summaries. A loop instantiated with several
collection types returns all actual selected source definitions, deduplicating
instances of one generic declaration. Stand-in sketches do not invent selections.
Ambiguous overloads do not claim a unique target. Collection
operands keep their own entity references, and array/range loops gain no expansion
reference.

## Regression checks

```sh
cargo test -p jai-language-server --test partial_edits --test edit_corpus
cargo test -p jaic --lib
python3 tools/lsp_partial_edits.py --max-lines 0 \
  --report artifacts/lsp-edits/fixtures.json tests/lsp/partial
python3 tools/lsp_partial_edits.py --stdlib ../stdlib/stdlib \
  --report artifacts/lsp-edits/stdlib.json ../stdlib/stdlib
```

The Python runner builds its Rust worker from this source tree, copies that binary
to a per-run artifact, and uses one timeout-isolated process per file. It persists
JSON results after every file. Panics, invalid reports, assertion failures and
timeouts cause a nonzero result; baseline failures are recorded, never counted as
successful coverage. No supplied/reference executable is used.

Each file gets independent, real `#no_context` procedures before and after its
source. The worker checks typed hover, exact definition locations, typed
completion, document symbols, syntax selection ancestors, semantic tokens,
folding, inlay requests and absence of invented expansion targets on an ordinary
loop. It also asserts that unaffected original top-level declarations survive.
An open configuration explicitly chooses the file as its entry, avoiding a
different inferred application entry that excludes the file on the host target.
Auto-import suggestion scanning is outside this harness's scope. Imports and loads
inside the source remain real.

Some suffix deletions produce strictly valid different scopes: deleting the call
after `#run` can move the next declaration into that run statement. Such declarations
are reported in `scope_changes`, rather than misclassified as unaffected globals.
Independent before/after probes are still mandatory, and every original top-level
declaration is asserted again after restoration. The worker uses the same large
compiler-thread stack as native `jailsp`; excessive parser nesting still produces
an error and discards the damaged enclosing statement.

Suffix cuts include byte fractions, scalar boundaries and a valid boundary near
the UTF-16 midpoint. Edits use LSP UTF-16 ranges and range lengths; the source is
restored and checked after each edit. `--max-lines 0` checks all nonempty lines;
the default samples eight evenly spaced lines per file. Existing source tests
also reject split surrogates and invalid edit batches atomically.

For pinned public applications/tutorials:

```sh
python3 tools/fetch_lsp_application_corpus.py
python3 tools/lsp_partial_edits.py --stdlib ../stdlib/stdlib --max-lines 3 \
  --report artifacts/lsp-edits/applications.json corpus/lsp-applications
```

This fetcher uses only `corpus/upstreams.json`'s application/tutorial allowlist and
hash-verified raw `.jai` files. It does not access a Git cache, other checkout,
credentials, compiler/parser projects, reference distribution or native binaries.
The existing broad upstream fetcher is deliberately not used because it shares a
Git common directory and includes other language implementations. Application
imports unavailable from the NEW library are reported as baseline errors. Passing
independent edit probes does not assert full application typechecking or API
compatibility. Coordinator owns complete project integration and release checks.

See [open questions](../specs/lsp-questions.md) for remaining ambiguity and core
overlap. Correctness reports are durable under `artifacts/lsp-edits/`; these runs
are regression checks, not the deferred benchmark phase.
