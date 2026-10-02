# HTTP WASM conformance termination contract

The reviewed current-date helper move now allows the portable HTTP module to
compile on WASM. Three unchanged original conformance programs subsequently
fail their WASM `-check -no_dce` checks on an unresolved public `Basic.exit`:

- `stdlib/Extensions/Http/tests/codec.jai` and `smuggling.jai` load
  `tests/lib/support.jai`, whose `finish()` calls `exit(1)` after failed checks.
- `tests/extensions/http-codec-roundtrip.jai` calls `exit(1)` on test failure.

The public Basic inventory declares `exit` only on its native POSIX and Windows
branches. It does not export a portable WASM termination procedure. The shared
`Extensions/Args` code has a `#scope_module` helper named
`terminate_process(status: s32)` that calls WASI preview1 `proc_exit` on WASM
and Basic `exit` elsewhere; this is private to Args and is not an API that the
Http tests can import. `Extensions/Wasi_Runtime` privately binds
`wasi_snapshot_preview1.proc_exit` and program-exports the C `exit` symbol for
WASI linking; this is runtime linkage, not a public Jai termination function.

The existing C termination path is available in both relevant test hosts.
`Extensions/Wasi_Runtime` program-exports C `exit`, implemented by WASI
preview1 `proc_exit`; `tools/wasi_run.mjs` returns that status to its caller.
The browser/compile-time sandbox recognizes the C `exit`/`_exit` host call and
converts it to its `Exit(status)` result. These are host/runtime services, not
Basic module exports. For the three Http programs, use a test-local declaration
of the existing C `exit` symbol behind the `.WASM` test condition, while
retaining Basic's ordinary `exit` on native targets. Keep every check, failure
counter, and nonzero failure status intact. This does not add a public stdlib
API or bypass an assertion. A direct WASI `proc_exit` import is not the shared
solution because the browser sandbox is not a WASI host.

This review does not authorize a Basic API expansion. The original WASM
diagnostics remain historical evidence; no test was run as part of this review.
It is separate from HTTP's resolved date-helper scope and the Windows
`bcrypt` compile-time provider phase question.
