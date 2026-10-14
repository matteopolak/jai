# Compiler deviations and implementation gaps

## Unintended producer-runtime artifact write (2026-10-14)

Running NEW `../stdlib/tests/portable-stdlib/mpeg-buffer.jai` in interpreter mode
executed its file-writing assertions. The fixture derives its path from #file,
so it wrote and then deleted `../stdlib/target/portable-tests/mpeg-buffer.bin` outside this worker
checkout. This violated the no-peer-writes constraint even though no producer
source was edited. The test printed ok; its source contains that successful
write and delete assertions. The test file was removed by the fixture itself;
preexisting contents, if any, cannot be inferred. No peer artifact/status/history was inspected or changed to
clean up. No forbidden source exposure occurred. Further producer executions
must stage test source under this checkout and audit source-relative outputs;
the independent loaded-constructor tests already use only this worker's target.
Coordinator/producer can audit any effect on a preexisting artifact. This incident is not hidden
under a blanket no-peer-writes claim.

Current continuation: mixed variadic packs use caller stack storage; yielding
continuations retain dynamic storage on the thread frame stack. Baked packs
snapshot interpreter memory and reuse content-keyed storage. Native/WASM64 O0/O2
execution passes, including unwind/rewind. The focused WASM harness provides real
memcpy; it is not production runtime integration. Interface matching compares
full procedure types and macro category; argument names/defaults and generic
required-interface declarations remain unspecified/unverified. Register, CLI
plugin and independent probe/reflection repairs now have focused regressions. No module,
path or fixture bypass is used. See compiler/mixed-variadics-and-interfaces.md.

Discovered legacy deviation: module parameter checking exempted system/library
modules, allowing unknown arguments to be silently ignored. Original library-root
regressions reproduced this. The exemption is removed; binding now rejects unknown,
excess and duplicate arguments, including modules without a parameter header.
Bootstrap loading passes only reviewed Runtime_Support flags. Nondefault temporary
target storage allocation needs a private compiler/runtime mechanism instead of
the old unreviewed TEMPORARY_STORAGE_SIZE import argument; it diagnoses explicitly.
NO_OUTPUT workspaces retain option metadata without allocating a target runtime.
Both initial and late executable-workspace requests are checked; producer handoff
is pending.

Scope: current producer source and handoff documents, plus this task's atomic,
context, reflection, measured-report and formatting work. This is an active ledger, not a claim of
full compatibility or production integration. Existing detailed limits remain in
`docs/specs/stdlib/compiler-questions.md` and the compiler integration handoff.

| Location | Observable effect and rationale | Evidence/risk | Proper fix |
| --- | --- | --- | --- |
| sema/calls.rs intrinsic dispatch | Bootstrap atomic dispatch gap repaired through shared IR, with scalar/signature/alignment validation. | Four original regressions pass. Public accepted scalar set is an independent supported policy where reviewed pages are incomplete. | Review exact type-set/reference ordering; retain general validation. |
| interp/atomics.rs | Real host atomics replace non-atomic sequences. Mapped-access checks cannot retain an allocation another native thread frees. | Original simultaneous-host CAS regression now passes; caller owns allocation lifetime, as for native atomic pointers. | Continue enforcing lifetime/compatible access at calling API boundaries; no fake memory-safety claim. |
| interp/mod.rs cooperative polling | Polls after indivisible atomic operations on cooperative multi-thread hosts. | Preserves progress; can cost additional scheduling overhead versus polling only stalled operations. | Profile scheduler budgets before tuning; never weaken atomicity. |
| jaic-llvm/src/lib.rs | Atomic wasm programs automatically require +atomics; explicit -atomics errors. | Shared-memory linking previously failed and now passes contention. | Keep IR-derived feature requirements; thread-enabled linkage remains embedder configuration. |
| jaic-llvm/tests/cleanroom_atomics.rs | Native contention driver uses pthreads on Unix; WASM tests require node/wasm-ld and fail when tools are missing. Error-reporting imports throw if executed. | Actual native and shared-memory tests pass; no tool skips or successful error stubs. | Coordinator must run Windows native contention with its threading backend; full platform CI remains outstanding. |
| sema/lower.rs and stmt.rs | Context selection and caller-owned cleanup registration use runtime slots; movable boundaries preserve nested macro ownership. | Eight original core cases and native/WASM O0/O2 pass. Adds interpreter loads/stores and linear updates over live lexical boundaries. | Retain correct semantics; profile before optimizing storage/mark traversal. No module/path bypass. |
| sema/typeinfo.rs | Generic source and instance defaults now have real metadata/storage. Instance defaults resolve dependent arguments; shared sources retain symbolic null type/-1 offset where unbound. Per-instance default metadata adds read-only storage to preserve those evaluations. | Six original core and native/WASM O0/O2 tests pass. Dependent metadata encoding is an independent contract, not specified by the public record declarations. | Review the encoding; foundations should consume instance defaults for dependent default elision. |
| cleanroom_reflection tests | Scoped bootstrap includes only reviewed fields needed by the test. WASM supplies real byte-comparing memcmp for the backend's existing external C call. | Focused native/WASM relocation execution passes; this is not production bootstrap/runtime integration. Rust raw strings contain original Jai/C/JS inputs; rustfmt/clippy cover their Rust harnesses, not embedded Jai formatting. | Coordinator runs full bootstrap and production runtime gates; standalone owned Jai sources require real jaifmt/jailint. |
| tools/assemble-cleanroom-test-library.py | Test-only overlay reads new independent producers; no production integration. | Focused prior tests only; missing dependencies can block broader runs. | Coordinator integrates independent producers and runs full gates. |
| jaifmt source build | Prior missing-builder blocker resolved using new independent dependencies. All owned facades/internals and new standalone Jai fixtures are now formatted and linted. Generator normalizes its outputs. | Real source build, jaifmt --check, jailint -D warnings and regeneration idempotence pass. | Coordinator repeats on full integrated tree. |
| interp/fibers.rs and mod.rs | Native-only fiber structures, stack constants and state are gated to supported Unix/Windows x86_64/aarch64 hosts. Unsupported hosts retain the existing explicit diagnostic. | Removed eleven wasm32 dead-code warnings at their cause; native tests and actual wasm32 clippy -D warnings pass. No lint suppression or supported feature disabling. | Retain matching implementation/state capability gates when adding a native host. |
| sema/perf.rs and build.rs | Native reports use measured timings/counts. Actual wasm32 compiler hosts explicitly reject performance requests because their stopwatch lacks a monotonic clock. Anonymous run thunks may have null callee headers. | New interpreter/native performance fixture passes. No fake zero browser timings presented as measured support. | Provide a real browser host clock; review anonymous-callee representation. |
| code_export.rs / Program_Print | Reviewed backtick/defer-pop flags and block presence serialize correctly. Bare implicit-copy versus explicit-context public AST encoding is unspecified; push-context printing remains explicitly unsupported. Runtime lowering preserves the distinction. | Original real-prelude flags/lifetime case passes; no invented public field or semantically different printed source. | Review the bare-context representation, then implement faithful public AST printing/reconstruction. |
| compiler facades | Visitor macro bindings, static filter expression shape and selected diagnostic semantics remain unspecified; some printing forms return false. Debugger/alternate backend operations diagnose unavailable support. | Questions and facade docs; reduced functionality is explicit. | Reviewed contracts plus real implementations and regressions. |
| browser/LSP/legacy CLI integration | Fresh overlay browser run passes 19/28; seven LSP auto-import failures use incomplete local stdlib. Legacy executable-path CLI test requests unavailable System module. | Failure assertions retained; compiler-owned CLI arguments, LSP unit and focused native/WASM cases pass. | Coordinator/owners integrate new dependencies and review legacy API assumptions; no invented System facade or weakened assertions. |

## Continuation review scope

| Location | Observable effect and rationale | Evidence/risk | Proper fix |
| --- | --- | --- | --- |
| sema/asm.rs, calls.rs and scope.rs | Canonical __reg is a distinct SIMD operand marker; expanded parameters alias caller storage. Core-only no-prelude compilations use an intrinsic nominal marker. Scalar, memory, GPR, standalone-storage and runtime-ABI misuse diagnoses. | Original canonical-bootstrap and interpreter/native/WASM64 O0/O2 tests pass. Wider operand contracts and physical pinning are not claimed. | Review wider contracts; retain explicit unsupported diagnostics and source identity. |
| interp/probe.rs | Fault-safe own-process kernel transfers replace stale-cache userspace dereferences. Comparison snapshots allocate buffers and kernel copies cost syscalls. | Original native-thread protection-change test reproduced SIGBUS and now passes. Mach ABI checked against official installed headers. Linux/Windows runtime execution remains unverified here. | Run platform CI; optimize only with equivalent lifetime/fault guarantees. |
| sema/typeinfo.rs | Direct procedure fields hidden as pointers retain marker 8 and actual struct alignment. Plain aliases retain identity. Distinct procedure variant behavior is an open contract question. | Seven core reflection cases plus native/WASM64 O0/O2 relocation/marker execution pass. | Review variant reduction semantics before introducing a nominal-type rewrite. |
| sema/driver.rs and build.rs | Only reviewed runtime module arguments are supplied. Default target storage works; actual nondefault target allocation diagnoses the missing compiler/runtime contract. NO_OUTPUT metadata round-trips without target allocation. | Unchanged public workspace fixture passes both runner modes; original early/late request diagnostics pass. Earlier overbroad guard failure logs are retained in target. | Joint compiler/runtime implementation through private configuration/startup, without adding public module parameters. |
| jaic-cli plugin source generation | Private orchestration uses reviewed Compiler hooks, grouped options, failure cleanup and COMPLETE handling; no unreviewed public helper export. | Original check/native-child execution and existing order/repeated-plugin tests pass. Autorun itself still has a producer executable-path defect. | Producer must join/resolve paths; coordinator reruns real Autorun, WASI and full plugin integration. |
| tests/compiler-semantics and LLVM harnesses | Shared positive Jai fixtures are formatted/linted with complete verbose checks. Node provides real memcpy/memset; unexpected imports throw. Deliberately invalid VFS source strings remain Rust test inputs, not positive Jai lint roots. | Core, native and WASM64 execute checks; namespace fixture preserves type/alias/storage identity across loads. This is focused backend evidence. | Full runtime/corpus and platform validation remain coordinator gates. |
| tools/assemble-cleanroom-test-library.py | Optional NEW portable overlay protects foundation-owned modules/helpers; selected producers are copied only into this worker target. It is local staging, not a production merge. | Host facade tests pass. Cross-producer snapshots/Windows/WASI completeness are not inferred. | Coordinator integrates authoritative ownership snapshots and runs full platform gates. |

Atomic default ordering is not established by the reviewed public pages. This
implementation will use sequential consistency, consistent with its existing
CAS backend, and document that stronger implementation guarantee without
claiming it is the unspecified reference guarantee. No public ordering API is
invented. Existing explicit-order compiler intrinsics must reject invalid orders.
