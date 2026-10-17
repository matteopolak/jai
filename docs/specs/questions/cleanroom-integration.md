# Integration contract questions

Only reviewed specifications establish compatibility; legacy fixture conveniences
and producer implementation policies do not settle these questions.

1. Runtime_Support has exactly three reviewed bool parameters and one compiler
   bootstrap instance. How should an explicit source import with flags different
   from the configured bootstrap behave? Integration currently rejects conflicts
   rather than silently ignoring them. The original reproducer is retained as
   `stdlib/Runtime_Support/tests/negative/configuration-conflict.jai`; the positive
   temporary-storage fixture now uses the configured instance. Mail only needs
   one_time_init and now imports the configured runtime
   without trying to override executable startup flags.
2. POSIX's inventory declares timeval for macOS x64, but its detailed field shape
   section is labelled ARM64 only. Which shape condition is authoritative? The
   newly specified x64 itimerval is regenerated, exposing unknown timeval in
   kinfo_proc. No ABI shape is inferred from the other architecture.
3. Several legacy fixtures require superseded module paths or implementation source
   locations. New guidance permits reasoned migration/retirement with exact proof
   and preserved behavioral coverage. Basic.log is explicitly reviewed and missing;
   it is a genuine implementation gap, not an invalid historical expectation.
   No convenience export is added solely to satisfy an unreviewed expectation.

Current source gaps with specified contracts are implementation requests, not
contract questions: Basic debugger hooks/default selection, Keymap grammar,
window creation defaults, shader stage encoding and font/mipmap semantics now
have reviewed answers. Input requires committed character events and does not
promise an IME composition API. See the latest module pages and
[integration requests](../../integration-requests.md).
# macOS POSIX.signal declaration versus native ABI

The reviewed macOS public declaration in `modules/posix.md` has three arguments
and a three-argument procedure result; the official native C function has two
arguments `(int, signal-handler)` and returns the previous handler. Generated
`stdlib/POSIX/declarations.jai` retains the reviewed declaration, so directly
calling it is not demonstrated safe. Which public argument represents the native
handler, and what is the meaning of the extra argument/return shape? Do not guess
an adapter or reinterpret an integer as a callable pointer. Integration's isolated
native-protection test uses an explicit private native C declaration and does not
count that oracle as public POSIX.signal support.
# Reviewed replacement fixture audit, 2026-10-15

The independently authored Basic format fixture requires
`sprint("%2 % %1", "A", "B") == "B B A"`. Basic's reviewed prose also says
the sequential cursor advances to the argument after the selected index,
which would request absent argument3 after `%2`. The integrated formatter and
compiler diagnostic follow that cursor rule and reject. Please reconcile the
example/prose through public behavioral review before either code or fixture
changes; no alternative semantics have been invented.

The new scalar Hash fixture passes a u64 seed0x1020304050607080 to get_hash.
The public inventory spells h := HASH_INIT without a reflected parameter type;
the behavioral review defines value5381 and scalar mixing but not h's width.
Current independent implementation uses a u32 seed and rejects this call.
Please review the exact reflected type of h in generic/string/array get_hash
and sdbm routines; do not infer it from output width or private implementation.
FNV's h is explicitly u64 and its direct scalar producer regression remains
separate. No fixture cast or public signature change was made to hide this.

Two other new fixture failures are pending stable producer scope: elapsed time
is not integrated yet, and current pre-refresh audio lacks the reviewed footstep
skip behavior. Recheck after audited portable/audio checkpoints before treating
those as persistent defects. Original four-case output is preserved in
artifacts/integration-clean/reviewed-tests-refresh15-before-inputs.log.

## Wide extension float presentation

Basic's current independent FormatFloat implementation supports IEEE32/64.
Extensions/Long_Double compiler arithmetic and C ABI are separately tested at
x87/binary128 widths. The reviewed Basic formatter prose accepts a float but does
not explicitly establish formatting of compiler-extension wide formats. Record
the intended width set and exact wide-format behavior before claiming it.
Retained wide compiler regressions now narrow only presentation arguments
explicitly; their actual wide precision/type/range assertions remain unchanged.
Do not silently narrow extension values in production formatting as a substitute.
# Legacy Thread negative assumptions, 2026-10-15

Default_Metaprogram's required default Check plugin has no public `get_plugin`
factory in the reviewed Check inventory, whose routines have Windows-conditional
availability. How is that plugin constructed/configured on Mac? Import-time
automatic `build()` invocation and legacy `-os/-cpu/-no_output` likewise are not
established. See the precise coordinator request in `docs/integration-requests.md`.
No default no-op checker or invented option has been implemented.

The old independently owned thread fixtures assumed Boolean `thread_start`,
semaphore/group `init`, group `start` and `add_work`, a `Thread_Group.threads`
array, `Native_Thread_Proc`, `thread_destroy`, `initialized` and
`owns_temporary_storage` fields, explicit allocator parameters on Basic allocation,
and temporary-storage init/deinit helpers. These are absent from the reviewed
contracts. Fixtures now exercise the canonical void calls, `worker_info.thread`,
completion-before-deinit, scoped allocators and caller-owned storage directly.

No reviewed contract establishes null/uninitialized/double-init/start-before-init
group/thread/semaphore behavior, or `shutdown` returning false merely because a
stopped worker left queued work. Those invalid-state/return assumptions were
removed from the positive behavior fixture rather than implemented as new API.
They are unresolved questions, not completed negative coverage. Timed semaphore
waits, blocked-thread polling/timeouts, timed shutdown/retry, STOP callbacks,
exactly-once work, mutex contention, condition wake/recheck and allocator/context
ownership assertions remain active. The public Thread module remains unavailable
on WASM; its compiler scheduler must be tested through the private provider.

Canonical-runtime fixture migration: explicit parameterless imports share the production configured runtime, and #Context is the public syntax used by reviewed new sources. Three old positive fixtures no longer request an unestablished second differently configured reserved runtime. Their original strlen(null) ==0 robustness assertions are retained as own implementation tests; the reviewed Runtime_Support page does not establish null-pointer behavior, so they are not reference compatibility evidence. Differing reserved parameter instances remain the language-page question; no additional aliases or alternate bootstrap are introduced.

Scope precision: after the reviewed deferred-call lexical capture, an inserted Code block whose donor scope equals its insertion scope does not expose ordinary local declarations to subsequent caller statements. The statement reconstruction fixture now asserts all tuple/local values inside that inserted block and verifies the outward assignment separately. No value assertion is removed. Flattening the block collided with a separate same-name enum in the retained enum regression and was discarded before commit. Exact caller exposure/hygiene for reconstructed Code remains the reviewed compiler-code-records scope question; no new general binding promise is inferred from old compiler behavior.
