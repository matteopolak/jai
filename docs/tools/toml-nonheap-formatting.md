# Nonheap TOML formatter repair

The original `toml-jai` workflow had two independent native runtime failures:
step 3 (`union_and_overlay`) read an inactive string arm while printing a valid
tagged union; step 9 (`formatting_control`) rejected a nested numeric variant
inside FormatFloat. The heap capability qualification for `first.jai` does not
apply to either case.

Independent reducers under `tests/developer-tools/runtime-reducers/toml-nonheap`
separate reflected layout/bindings, boxed metadata/storage, formatter dispatch,
and nominal typechecking. Before repair, metadata/layout/storage controls pass
in interpreter and native O0/O2; union rendering and both numeric formatter
wrappers fail in all three modes. A distinct-number compile negative still
rejects conversion to an ordinary float parameter. No compiler defect has been
established by these reducers.

The [sanitized official oracle](../status/toml-format-official-verdict.json)
confirms numeric variants render through their underlying scalar type, without
changing boxed identity, and valid bound tagged unions render their discriminator
and active value as `{COUNT, 37}` or `{TEXT, chosen}`. Forced long form has the
same union output. Exact independent assertions now encode that evidence.

The narrow producer repair unwraps numeric type metadata locally in scalar
formatters and selects an active union member through canonical reflected
bindings before reading its payload. Ordinary struct rendering, public records,
allocator capabilities, and nominal typing stay unchanged. Integer/enum binding
comparisons mask constants to the stored discriminator width; type tags use
their stored descriptor address. Unmatched/implicit tags and malformed binding
policies remain [explicit questions](../specs/questions/stdlib-tools-nonheap-formatting.md).
Selection scans the binding list once, and scalar wrappers walk the variant
chain once. No metadata cache or new payload ownership is introduced.

`tools/check_toml_nonheap.py` requires explicit source-built tool and stdlib paths
and a `CARGO_TARGET_DIR` scratch root. It hash-checks and copies only ACCESS-admitted
TOML application inputs. Default execution retains all four original nonheap
examples, the existing HashTable control, and independent reducers in interpreter
and native O0/O2. It records every failure, continues independent cases, and
returns nonzero for any required failure. Independent reducer success requires
no diagnostics and exact control markers where specified. Original application
negative cases deliberately log rejected input and retain their existing
`assert(!ok)` checks; application diagnostics alone are not a failing assertion.
Runtime assertion/null-read diagnostic categories and nonzero exits still fail.
Original validation also exercises invalid UTF8 and raw control bytes in its
diagnostics. Exact binary output is retained with SHA256 and explicit UTF8 validity;
JSON escapes invalid bytes only for display. Source, formatter goldens and
independent positive controls keep strict UTF8 handling. `--source-only` performs
format/source/strict-lint and nominal rejection checks without target execution;
it cannot establish runtime acceptance. The heap-required example remains in
the normal upstream capability-aware workflow.

Current evidence and immutable receipt locations are maintained in
[the worker status](../status/stdlib-tools-nonheap-toml.json). A staged snapshot
does not establish integrated or cross-platform native acceptance. Integration
owns the final combined CI replay and documentation index append.

Final staged accepted-source `403424fc` plus the narrow repair passes all 63
focused commands: 14 source/format/strict-lint/nominal-rejection checks, 16 native
builds, and 33 runtime executions. These include all four unchanged nonheap
original examples, HashTable, metadata/storage controls, and exact oracle-backed
union/numeric formatting assertions. Ten separate Python policy tests pass.
Both source and input drift guards are empty. All output byte captures are
retained and hash-verified, including validation's deliberately non-UTF8
diagnostics. The initial causal failures and first replay's capture-policy
failures remain separate immutable receipts, with no whole-project qualification.
