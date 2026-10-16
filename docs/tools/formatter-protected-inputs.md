# Protected formatter inputs

The repository idempotence test formats its own complete source copy. Frozen
candidate sources are read-only, and std::fs::copy preserves that protection.
The original10d9 full workspace correctly failed when the formatter could not
write its scratch tree.

The test now grants only owner-write permission to copied Unix files. Original
source files and protections remain untouched. A new explicitly read-only source
fixture is copied through the same helper; the real source-built formatter must
format every copied file, preserve tokens, and pass its second idempotence check.
The test also verifies the protected original bytes and read-only mode remain.
No formatter or production library source changes, excluded input expansion or
assertion removal are involved.

The exact case passes1/0/0 in4.28seconds with actual frozen10d9 production stdlib;
Rustfmt and warnings-denied clippy pass. See the
[machine receipt](../status/formatter-protected-input-verification.json).
The original full944/7/1 aggregate remains failed. Windows's inherited test early
return remains an unexecuted platform branch, not a passing Windows claim.
