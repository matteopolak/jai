# Reviewed underscore classification

`Basic.is_alnum` now accepts ASCII underscore, alongside letters and digits. `is_alpha` remains false for underscore; `is_digit` remains decimal ASCII only. This is the exact reviewed byte contract, with no Unicode/locale decoding or application-specific condition.

The coordinator explicitly assigned this narrow canonical-helper repair to the portable owner. Production changes are confined to the `is_alnum` return expression in `internal/basic/scalar.jai`; the public signature, facade, parser and application producers remain unchanged.

`ascii-predicate-contracts.jai` checks all 256 input byte values against the reviewed classification table, including the explicit 95/65/48 controls. Genuine pre-fix evidence is `ascii-predicate-red-6uxedte8/results.json`, exit 4 at the alphanumeric check. Final receipt `/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/stdlib/target/ascii-predicates-shared-ffbbedho/results.json` has 19 passing checks: three actual interpreter/native Mac ARM64 O0/O2 executions, two builds, six source checks, six complete strict production/fixture lint contexts and two format gates.

Run `tools/check_portable_ascii_shared.py` with the explicit worker T7 target and source-built tools. The tools/compiler owners have the stable source hash for unchanged protobuf-consumer revalidation. Original protobuf cases and full-corpus acceptance are their separate evidence; this focused receipt does not fabricate those results. Foundational Basic outside the explicitly assigned predicate/time repairs remains with its owner.
