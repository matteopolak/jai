# Reviewed HTTP current-date adapter

The refreshed [Basic public inventory](../specs/stdlib/modules/basic.md) declares
`current_time_consensus` on Windows/Linux/macOS/Android. The reviewed
[HTTP contract](http-codec.md) places `http_date_now` alongside the existing
native client/server adapters. WASM has no reviewed injected host clock ABI.

The implementation moves only `http_date_now` into `date_native.jai`, loaded
inside Http's existing native adapter block. Its signature, parameter name,
export scope and entire procedure body are preserved. `Date_Cache`, `http_date`,
`format_http_date` and `parse_http_date` remain in the portable source, unchanged.
There is no new OS predicate, fallback timestamp, Basic alias, JSON rewrite or
provider initialization change. The prior held proposal and its failed target
evidence remain preserved; this follow-up is separately versioned from TLS
checkpoint `b459ad41` and its [original receipt](../status/http-tls-target-ready.json).

## Current focused evidence

All new build outputs and captures are under assigned T7
`platform-io/target/http-date-native`. The compiler and linter were freshly built
offline from current independent Rust source, with native LLVM support enabled;
stable tool copies are pinned in the new receipt. The current shared Basic
facade/internal module hashes were verified against their owner's exact two-line
guard receipt (`b2284e8f…`, `82d3a619…`). No frozen309 library or source overlay
was used. The HTTP SDK helper built its complete pinned native mbedTLS profile
into a new own provider directory; its profile identity and artifact hashes are
verified separately. This does not claim any TLS handshake execution.

After notifying the inbox and taking the bounded native slot, exactly three
existing Mac ARM64 HTTP conformance cases ran sequentially: codec, smuggling,
and codec roundtrip. Each passed interpreter execution, native O0 compilation
and actual O0 execution: **9/9 commands, 6 program executions**. Every execution
returned zero, printed exactly `ok\n`, and had empty stderr. All 1,002 current
stdlib Jai input hashes matched before/after. The slot was released immediately;
there was no O2/native WASM/Windows/HTTPS network/echo-server/full-suite execution.

The focused public target/source/lint matrix has **13/15 passing outcomes**:
WASM portable dates compile and pass strict lint, and a new negative test requires
the precise missing-export diagnostic when requesting native-only `http_date_now`
on WASM. Both Windows TLS contexts, Linux/Mac full HTTP contexts, and Windows
clock adapter strict lint pass. Both Windows full HTTP `-no_dce` checks still
fail on the Mac host's unavailable `bcrypt` during compile-time JSON generation.
That failure remains fatal to the runner and is [qualified for phase review](../specs/stdlib/http-tls-target-questions.md).
Use normal actual Windows host CI for native proof; no fake provider was added.

Additional unchanged original WASM conformance source checks (codec, smuggling,
roundtrip) each reach a genuine subsequent failure: their failure-reporting path
calls `Basic.exit`, which the current WASM facade does not expose. All three
failures are retained in `wasm-conformance-source.json`; these are not runtime
passes and are not waived. The portable production module now compiles, but the
original WASM conformance suite still needs a reviewed test termination-provider
migration. Tests and assertions were preserved unchanged. Original309 unknown
exit/fiber diagnostics remain separate earlier failures, not retroactively
cleared by the Mac proof. No full CI success is claimed.

Real source jaifmt check/idempotence, scoped `jailint -D warnings`, Python Ruff
and scoped whitespace validation are included in the separate
[ready manifest](../status/http-native-date-ready.json). That manifest pins exact
production/test/tool/doc hashes, the refreshed oracle files, current guard
dependencies, tools, provider identity and captures. Integration alone stages
and commits; no publishing, remote action or index mutation was performed here.

After native execution and slot release, the final dependency hash check detected
another owner's Basic facade operator-export work (`2b654bb7…` versus the tested
`b2284e8f…`). The native receipt's before/after hashes both match the reviewed
guard version; those positive results are retained for that exact input set and
are not projected onto later peer WIP. The unchanged internal Basic module still
matches `82d3a619…`. The ready manifest records this dependency drift explicitly;
integration must verify the final combined candidate. No peer edit was reverted,
staged or included in this worker's ready file list.

## Remaining limitations and deviations

Only the native current-date procedure and its existing load placement changed
in production. No pure codec function or test assertion was altered. The new
negative fixture is deliberately compile-failing only on WASM and is counted
passing only for the exact reviewed absent-export diagnostic.

The native helper move resolves the approved clock availability issue; it does
not resolve the cross-host `bcrypt` phase question or the original WASM tests'
missing `exit` name. Those are independent retained gates. Native Windows on both
CPUs, full HTTP CI, native O2 and broader networking/corpus acceptance remain
coordinator work. SDK and Basic guard identities were consumed from permitted
current independent inputs; no /Users/matthew/projects/jai-reference/source/vendor implementation body or
foreign worker T7 capture was accessed.
