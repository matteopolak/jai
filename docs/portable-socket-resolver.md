# Reviewed macOS addrinfo integration candidate

Refreshed Socket spec defines the exact macOS addrinfo record, including public
AI/SOCK/IPPROTO enum types, u32 socklen_t and canonname-before-address order.
Review-derived generation now produces its canonical record and same-entity
facade alias. The durable own-source candidate is
[pending/socket-macos-addrinfo.patch](../pending/socket-macos-addrinfo.patch).
It is excluded from active stdlib until the general compiler dependency is fixed.
macOS addrinfo is still missing from the active public surface, not completed.

Native C compiled from the official Apple SDK netdb.h verifies both ARM64 and
translated x64: size48, alignment8, field offsets0/4/8/12/16/24/32/40. It also
executes real getaddrinfo/freeaddrinfo with NUMERICHOST/NUMERICSERV, verifying
127.0.0.1:32123 and TCP/STREAM metadata. This uses numeric addresses and performs
no DNS lookup. It is C SDK evidence, not Jai execution or a skipped assertion.

The actual Jai fixture tests canonical name, exact field types/layout, real
resolver output and release. It fails on AI.MASK's dependency on later ADDRCONFIG:
unknown identifier ADDRCONFIG. Original minimal general reduction:
[socket-ai-forward-enum.jai](../tests/portable-stdlib/pending/socket-ai-forward-enum.jai).
Its BOTH = FIRST | LATER also fails ordinary -check. Compiler NEW handoff confirms
sequential enum_items as the cause and a fix remains pending. Keep declaration
and reflected member order; no reordering/value substitution is used to evade it.

Activating the generated shape also makes existing socket-cmsg-layout fail at
that same enum dependency; original broad failure preserved in
target/android-sdk-asn1-socket-full.log. Candidate therefore remains staged only.
No existing Socket assertion or fixture was weakened/disabled. The next compiler
checkpoint must make both the new resolver gate and existing Socket suite pass.

Run python3 -B tools/check_portable_socket_resolver.py. It regenerates twice under
its own target/ output root, requires byte identity/format, executes both native C
probes, then strictly fails at the current Jai compiler dependency. Dedicated
staging leaves the active library untouched. Generic generator --output-root
supports owned isolated generation without changing native declaration semantics.
Evidence: target/socket-resolver-isolated.log and socket-ai-forward-enum.log.
Strict lint was actually run and fails on the same compiler cause:
target/socket-resolver-isolated-lint.log. Formatting passes on generated candidate
and fixture. No Jai interpreter/native O0/O2 or strict-lint success is claimed.

Temporary documentation artifact: docs/socket-native-ledger.json marks this one
shape as a retained candidate; normal generation after compiler integration will
replace that status with the ordinary declaration record. Regeneration with the
refreshed spec writes the new shape, so default generation into active stdlib must
wait for the compiler fix. Other unresolved shapes/platform runtime gaps remain
listed in portable-windows-socket.md; Android/Windows variants are preserved.
