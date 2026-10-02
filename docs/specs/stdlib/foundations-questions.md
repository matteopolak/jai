# Foundations contract questions

These questions concern reviewed declarations, not legacy API conveniences.

- Wide conversion, scalar FNV and x64 division-exercise contracts are resolved
  in the current Basic/Hash specs and implemented. Integer-kind to_s128 uses
  signed-64 sign extension; to_u128 accepts only u8/u16/u32/u64. Records and
  distinct types reject at specialization. Scalar FNV XORs/multiplies once;
  bytes apply that step independently. The diagnostic is public on every x64
  OS, always runs deterministic checks, and calls the random callback exactly
  three times per positive iteration. Their original probes now pass.

- CAPS name-out ABI and Preamble scoped effects are now resolved and implemented
  natively and in production WASI. NEW compiler host constants resolve the
  previous cross predicate failure; see foundations-preamble-request.md.
  Confirm exact allocator-family matching:
  current code recognizes Pool/own-temp procedures directly, per-frame temporary
  capability and the documented Flat_Pool CAPS version string. The provisional
  modules/Pool name check was removed; canonical Pool uses procedure identity.
  Real NEW Pool and Flat_Pool producers are now integrated
  read-only for tests; the former simulated Flat_Pool CAPS callback is removed.
  Specify whether allocator wrappers claiming family names should be excluded
  too, or whether only canonical procedures and Flat_Pool's version are intended.
- The refined leak contract is resolved and implemented: exact procedure names,
  case-sensitive source-path substrings, matching/null root suffix removal,
  inclusive first matching leaf, and report-owned lifetime. No module identity
  lookup is needed. A stable child pool owned by the exposed report pool meets
  the unconstrained private allocation/lifetime contract.

- Basic debugger: clarify resize-zero notification ordering and whether a null
  return for a zero-sized resize means a free or a failed resize for custom
  allocators. Nonzero failed resize preserves the old live allocation. Module
  parameter/interface and visualization channel/lifecycle contracts are now
  supplied; the real native channel backend is implemented and tested.
- File visitation: specify root visitation, traversal order, callback metadata
  validity, symlink filtering versus descent, cycle behavior, and whether
  callback pruning prevents a directory's descendants from being visited.
  The independent implementation enumerates children in native directory
  order, supplies eagerly queried metadata and callback-scoped name views,
  and permits pruning before descent. Ancestor identities prevent cycles.
  Also specify the missing-metadata sentinel for add_modtime_and_size_if_missing:
  currently APOLLO_TIME_INVALID triggers querying and had_error tracks failure.
- Basic selection: the current prose advances the sequential cursor after
  the selected argument, but its example `%2 % %1` with A,B says B B A.
  Following the prose yields B [omitted] A and one logged invalid index.
  Which is authoritative? Current code follows the prose. Also specify
  whether only exactly `%00` is empty, or any all-zero index of length >=2.
- Basic remaining reflected output: give exact unknown-enum marker bytes,
  nonnull procedure spelling, corrupt-value fallback strings, recursion
  policy and the meaning of `may_be_uninitialized`. Current unknown enums
  use an independently chosen `(Name out of range: number)` marker;
  nonnull procedures use pointer formatting. Corrupt representations assert.
- Basic type names: generic names/values/default elision and temporary
  type_to_string lifetime are now resolved and implemented with NEW compiler
  metadata. Clarify only exact generic punctuation (including all-elided empty
  parameter lists) and procedure annotations. Current output is `Box(T = s64)`
  and `Box()` when all parameters match defaults.
- Basic Print_Style: where is the active style stored and how is it selected?
  The reviewed page declares the type but no storage or selection API. The
  current prelude does not expose a print-style context field. Do not invent
  a global/style setter to satisfy legacy uses. The independent implementation
  uses context.print_style when a caller declares that extension, otherwise a
  call-local default; this optional hook is not a reviewed storage contract.
- String scan: specify whether trailing unmatched text is failure, whitespace
  handling by each conversion, numeric storage types in returned Any values,
  overflow behavior and permitted scan2 pointee conversions. Current
  independently designed behavior requires full consumption, uses s64/float/
  bool/string values, and rejects out-of-range integer destination writes.
  Scan2 parses float64 destinations without a float32 intermediate. Its
  integer parser currently uses signed s64; full-range u64 scanning awaits
  the conversion contract rather than silently wrapping.
- String wildcard sets: specify malformed/unclosed set handling, whether sets
  can be negated, and literal `]`/`-` rules. Implemented positive sets/ranges,
  `*` and `?` have byte semantics; unclosed sets fail to match.

No reference implementation or binaries were accessed to answer these questions.

Resolved by synchronized review: scalar get_hash now has the explicit
cast,no_check/u64 XOR-seed, Knuth-product, upper-32 formula; Unix File_Utilities
alias signatures and Basic output/lifetime contracts are present. Those are
implemented and no longer treated as blockers. Unchanged real jaifmt builds,
formats the owned files, and passes its CLI integration/idempotence check.
The synchronized formatter review also resolves ordinary grammar/arity/errors,
integer bases and padding, float options, nested quoting, enum flags, array
limits and struct long-form quirks; those are implemented and covered by
original regressions rather than retained as stale questions.

The next Basic review batch resolves logging empty-message suppression,
reflection views/temporary enum values, empty enum ranges, field misses,
scalar membership and #modify constraints, sequence quoting, hexadecimal byte
output/newline, copying consumption, allocator ownership, shrinking slice
reallocation, temporary stack strings and exact frame text, debugger report
baseline/scan flags/visualizer mode, and visualization protocol/timing. Those
are implemented or actively being implemented; the old questions above are
removed rather than used as stale reasons to stop.
