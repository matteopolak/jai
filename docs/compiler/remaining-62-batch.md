# Remaining corpus repair batch

This batch starts on the own integrated-10d9 child, preserving source checkpoint
`586be99b` and the independent operator regressions. It consumes the coordinator's
named `coordinator-reference-classified62.json` ledger. Its 14 prior reference
successes, 42 prior reference build failures and six inconclusive cases are evidence
categories, not validity judgments or exclusions. Every row has a disposition in
[the current work ledger](../status/compiler-batch-62.json).

All new builds, staged approved inputs, scratch and logs use
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/compiler/target` and
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/compiler/mac-repairs-10d9`.
No local build fallback or broad 400-case rerun is part of this batch. Earlier
local build outputs are inactive; the child source worktree is preserved.

## Current focused evidence

**Focus:** 94 exact manifest-listed files were hash-verified and staged. The
unchanged input now reaches its compiler-version guard, not the reported unknown
`set_working_directory` error. Its guard independently compares major, minor and
micro against `0.2.29`; our correctly reported `0.17.0` fails `micro < 29`. This
does not prove the application invalid or the previous scope defect fixed in the
shared tree. Integration must adopt the compiler checkpoint and compare the same
source/context. No version spoof, guard removal or application edit is proposed.
The original `late-import-conditional-procedure.jai` reduction successfully binds
the public conditional Basic procedure from a compile-time procedure preceding
the lexical imports. It queries the callable type without changing directories.

**TOML:** the unchanged custom-handlers input originally reproduced the polymorphic
lambda error. The refined independent reduction uses the actual reviewed callback
parameter signatures. Generic struct binding was retaining the uninstantiated
procedure instead of converting it to the concrete declared signature. The general
binding repair now makes the application pass source checking. Its first runtime
serialization assertion remains red because an underscored key is emitted quoted;
both native O0/O2 builds succeed and both runs fail that assertion. See
[typed generic struct binding](struct-argument-binding.md). The older untyped
parameter reflection question remains separate; no runtime pointer is fabricated.

**Protobuf:** the initial approved snapshot contained no `.proto` data assets.
The coordinator has now admitted and hash-listed the three original example schema
assets, and they are staged locally. The tests and embedded
03 fallback reproduce malformed generated declarations. An independent input
passed through the actual authorized application generator emits a valid
`field: s32` declaration for `int32 field = 1`; changing the field to `field_name`
produces an UNKNOWN underscore token and then an empty-name declaration. The Jai
parser correctly rejects that declaration. The tokenizer relies on Basic's public
`is_alnum`; review now confirms `is_alpha(95) = false`, `is_alnum(95) = true`.
The canonical classifier correction is assigned to the stdlib owner and awaited
for focused replay, rather than editing the application tokenizer or Jai parser.
No malformed syntax acceptance, generator-text patch or app source edit was made.

## Concrete dependencies and limits

- Integration: adopt the independent compiler/regression chain, supply exact
  matching shared source/context if Focus's lookup failure persists, and retain
  the actual version-guard result separately. Matching helper ABI7/relocation
  receipt `a97d0f6f` is acknowledged; no stale helper is substituted.
- Contract review: the separate untyped procedure-valued parameter representation
  and any additional record defaults beyond the six confirmed inherited
  initializers. These are not blockers for the typed callback fix.
- Stdlib adoption: the canonical `is_alnum` correction for protobuf/TOML replay.
- Stdlib and bindings: the ledger records their assigned hash/export, collection,
  allocator, Objective-C and platform prerequisites. A missing name does not
  justify a compiler visibility leak or an invented public convenience export.

The suspended memory investigation remains suspended. No original/reference,
quarantined, excluded vendor body, transcript or credential input is used. A
reference build failure alone never changes a row to invalid or accepted.
