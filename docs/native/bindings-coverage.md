# Native binding implementation coverage

The [generated ledger](bindings-coverage.json) accounts for every inventoried
declaration in all 34 assigned public module aliases. It records the reviewed
spec page SHA-256, condition, exact signature and disposition. `declared` means
emitted ABI syntax, `forwarded` means a generated wrapper with a real call, and
`unresolved` means absent implementation. None of these statuses proves target
compilation, native layout, library symbol availability or runtime behavior.

The generator reads only reviewed spec pages. It retains conditional shapes,
implicit enum members, overloads and complete anonymous overlays. Native C
implementations, where built, come from pinned official vendor repositories.

## Validation so far

- Twelve Python parser/generator regressions pass.
- Desktop target and host-native checks have not yet completed.
- Public declarations containing omitted method bodies, contextual types,
  generated configuration differences and unsupported target branches still
  need implementation review. The ledger lists these explicitly.

## Reproduction

Run `python3 -m unittest discover -s tests/native-bindings -p 'test_*.py'`, then
`python3 tools/native_bindings/generate.py --check`. No reference compiler or
reference binaries are used. All build/test output belongs under `.work/` in
this durable workspace.
