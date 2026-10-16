# Relative_Pointers public contract audit

All ten reviewed declarations have supported bodies and focused shared-library evidence. The only production change drops three unused displacement locals in pointer-only helper calls; it changes neither returned values nor public signatures.

`relative-pointer-contracts.jai` exercises all four signed storage widths, canonical record names and sizes, positive/negative/zero offsets with an explicit base, null encoding, same-address static helpers, typed encode/decode, compatible record relocation, and non-owning relative strings whose data displacement is based at the data field. Mutating the relocated string's storage changes its view without changing the original record. Private helpers remain unavailable through the facade.

Run `tools/check_portable_relative_pointers_shared.py` with worker source-built tools and `CARGO_TARGET_DIR`. Final receipt `artifacts/local-verification-stdlib/cargo-target/relative-pointers-shared-fnx773fc/results.json` has 20 passing checks: three actual interpreter/native Mac ARM64 O0/O2 executions, two builds, six source checks, six complete strict production/fixture lint contexts and three format gates.

The earlier `relative-pointers-shared-jz0wtrb4` receipt retains passing runtime controls and six strict-lint failures for unused `offset` locals. Selecting only the first returned pointer is ordinary language behavior; no error status is discarded and no assertion or validation is suppressed. This is lint cleanup, not a newly fixed decoding defect.

The null representation has a mathematical limit: because encoded zero is reserved for null, a non-null displacement equal to the signed minimum would also encode as zero under the reviewed XOR rule. No alternate format or extra tag was invented. Tests use non-reserved signed offsets -127 through 127 and valid compatible storage. Wider extreme displacements, invalid addresses/layout/lifetimes and native other platforms remain unverified; the reviewed API provides no such validation.
