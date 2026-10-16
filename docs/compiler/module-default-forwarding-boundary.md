# Written defaults across forwarded module imports

This investigation found no established compiler defect. The accepted compiler
identifies an ordinary module instance by its canonical entry and ordered
argument list. The existing reviewed language contract explicitly distinguishes
omitted parameters from explicit matching defaults, and distinguishes named
argument orders. See [the language contract](../specs/jai/modules-workspaces-and-examples.md#imports-and-modules)
and the [resolved native-bindings question](../specs/stdlib/native-bindings-questions.md).
PROGRAM parameters retain their separate configuration mechanism.

The independent Leaf/Bridge reduction makes the relevant boundary explicit:

| Import | Relationship to Bridge's forwarded Leaf |
| --- | --- |
| `Leaf(FLAG=true, SECOND=true)` | Same nominal instance |
| Repeated identical full list | Same type and module storage |
| `Leaf(FLAG=true)` | Distinct instance despite matching defaults |
| Plain `Leaf` | Distinct instance despite matching defaults |
| `Leaf(SECOND=true, FLAG=true)` | Distinct ordered-list instance |
| Full list with a different value | Distinct instance |

Bridge always supplies the complete ordered list when importing Leaf. Both a
plain Bridge import and a configured Bridge import forward to the same full
Leaf instance when their values match. This is ordinary evaluated-argument
identity; it does not depend on the names Leaf or Bridge or on a private SDK.

The reported native-handle comparison used an abbreviated direct SDK import
against a facade that forwards the complete SDK profile. That mismatch is
consistent with the reviewed language rule. The bindings owner retains all
12 assertions and owns selecting the same complete reviewed profile on both
sides. No assertion, handle cast, public parameter, type identity or cache
normalization is changed by this packet.

## Independent checks

`tests/producer-requests/module-written-default-identity/main.jai` checks
nominal identities, default values, both forwarding paths, and independent
versus shared mutable module storage. Its Leaf and Bridge modules are original
small fixtures. Run with `jaic -check -no_dce -I
tests/producer-requests/module-written-default-identity/modules
tests/producer-requests/module-written-default-identity/main.jai`.

`cleanroom_module_written_defaults.rs` runs the positive fixture with VirtualFs
and retains two negative source programs inline: the false omitted-equivalence
assertion must fail with `#assert failed`, and passing an omitted-instance pointer
to the explicit-instance procedure must fail with an argument-type mismatch.
Negative programs are not added as positive lint roots.

The exact admitted bindings reducer and its source hashes were verified before
copying only its five authored inputs into this worker's T7 capture. All 18
source checks across host, Linux x64 and WASM match the expected result:
omitted-equivalence assertion rejects; full explicit/repeated imports accept;
the written-contract and cross-nominal controls preserve their verdicts.
No SDK or native application was executed.

The fresh source-built checker uses accepted fa81afd0 sources, with 1,390
existing compiler/stdlib/formatter input hashes matching the sealed numeric
handoff. There is no production change, including no module-key, program-slot,
LSP, alias-refresh, atomic/x86 or LLVM-output edit.

## Current-version qualification

The reviewed lesson notes that its written-list rule might change in a future
language version. Root has the exact admitted omitted/explicit/repeated probes
for an optional official Jai 0.2.030 build-only confirmation. This worker has
no new official verdict and never runs the reference compiler. A superseding
positive omitted-equivalence verdict would require a new reviewed general
design; this packet does not silently reinterpret the current contract.
