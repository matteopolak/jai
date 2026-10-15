# Reviewed macOS addrinfo production integration

Current refresh23 result: compiler6080ff0a and the canonical generated Mac record
are integrated. `python3 tools/check_portable_socket_resolver.py` passes both C
SDK probes, interpreter, native ARM64/x64 O0/O2, both CPU source checks and strict
lint on the actual Root production library. It compares two regenerations with
the production bytes; no staged library overlay is used. The fixture additionally
checks original C storage addresses and live h_errno mutation/restoration. The
producer fixture's unreviewed AF.INET spelling was corrected to reviewed AF_INET;
all address/port/type/value assertions remain. Full C ABI suite still fails the
separate missing Mac hostent shape, requested precisely from contract review.

The following records the original blocked candidate and its retained failures;
those failures are superseded only for the resolver by the production run above.

Current activation2026-10-15: five reviewed macOS records are now in the active
generated binding: addrinfo, hostent, netent, protoent and servent. The earlier
candidate-only status below is historical. No workaround for the fixed forward
enum issue is retained. The original candidate patch remains historical evidence;
do not apply it over the active generated files.

`python3 -B tools/check_portable_socket_databases.py` consumes the ACTIVE owned
Socket closure, not an isolated replacement record. Missing hostent export was
first observed in target/socket-databases-red.log. Exact reviewed types/canonical
names and every field offset for the four database records plus existing rpcent
match independently compiled official Apple netdb.h C probes. Real numeric host,
TCP protocol and HTTP service lookups pass interpreter/native ARM64/x64 O0/O2;
fixture strict lint passes (target/socket-databases-final.log). SDK-returned
records are borrowed; tests do not free or modify their static storage.

Resolver generation is stable across two runs; the new addrinfo shape executes
real getaddrinfo/freeaddrinfo in interpreter/native both Mac CPUs O0/O2 and source
checks. Full generated-binding strict lint was rerun and still FAILS on the
general type_of(Struct.array_field[0]) compiler gap (target/socket-resolver-active.log,
pending/field-array-element-type.jai). That preexisting unrelated public type-query
declaration is preserved, not replaced with a hardcoded type or suppression. No
claim of full binding lint or other-OS native verification is made. The proper
long-term fix belongs to general compiler type-query support.

Current correction2026-10-15: corrected source-built compiler1929d5a resolves
forward enums. Both C SDK probes and the real Jai resolver pass interpreter,
native ARM64/x64 O0/O2 and source checks. Ancillary-message fixture also passes
interpreter; previously interrupted verification has been rerun. Whole-binding
strict lint still FAILS the general field-array-element type query, reproduced
independently by pending/field-array-element-type.jai. Candidate remains staged
until that final gate is resolved; active macOS addrinfo is not claimed complete.

Separate test correction: AF.INET was never a reviewed Socket export. Resolver
fixture now uses reviewed AF_INET for input/output checks; no facade API invented
and both assertions remain. Forward-enum failure had hidden the invalid spelling.
Test-only checkpoint ba07d75 is separate from production storage-reexport fixes.

Production global fix: generated `name :: ABI.name` captured native variable
values in immutable bindings. Original h_errno assignment test rejected as
constant0. Generator/active facade now use general `using,only(name) #import`
for reviewed #foreign/#elsewhere variables, preserving original entities. Ten
conditional declarations/six names are corrected without changing constants,
types, signatures or ABI. Real SDK C h_errno/in6addr addresses equal public Jai
addresses; h_errno mutation is observed by C and restored. Interpreter/native
O0/O2 plus scoped fixture/bridge strict lint pass. No live-:: compiler feature.

Evidence: target/socket-resolver-corrected-compiler.log (initial alias failure),
socket-resolver-storage-corrected.log (only field-type gap remains),
socket-resolver-cmsg-corrected.log, socket-field-array-corrected.log,
socket-storage-red.log and socket-storage-workflow.log. The source-built C bridge
uses official netdb.h/netinet/in.h; generated bridge sources live under target/
and are formatted/--check verified. Initial fixture #library spelling included
.dylib although the compiler appends extensions; corrected to the library stem,
with no compiler/library workaround. Older failure narrative below is historical.

Refreshed Socket spec defines the exact macOS addrinfo record, including public
AI/SOCK/IPPROTO enum types, u32 socklen_t and canonname-before-address order.
Review-derived generation now produces its canonical record and same-entity
facade alias. The former pending/socket-macos-addrinfo.patch candidate has been
removed after normal production generation and the general compiler repair.

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

The original python3 -B tools/check_portable_socket_resolver.py regenerated twice under
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
