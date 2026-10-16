# Required full-tour WASM providers

The original full tour runs in the wasm32 playground engine and as an emitted
wasm64 WASI command. Its stops, output manifest, budgets and required Rust test
assertions remain enabled. This supersedes the earlier proposed tour-core split
in [the capability investigation](wasm-tour-capabilities.md); that proposal was
not adopted.

The verified source baseline is producer
7187647b3c3769abbc9daa3118a4febe9ee7f4dd plus the accepted ac174e805660ce4d8f4744d2be9f6842b60edc24
cohort, with only the owned consumer/provider/test changes listed in the handoff.
Builds use isolated compiler T7 targets and the full matching bundled library.

## Graphics and native windows

`Extensions/WebGPU` loads the public `Window_Type` dependency and declares its
two native-window helpers only on native targets. Its C API, asynchronous
requests, callbacks and headless compute remain available without native window
types. The native helper signatures and behavior are retained. The coordinator's
preservation clarification authorizes this narrow new dependency migration;
there is no module replacement, deletion or history backport.

The tour's private `gpu/browser_canvas.jai` consumes the existing embedding event
and size protocol. Canvas availability requires an actual supplied WebGPU canvas
context and is separate from GPU availability: headless compute needs no canvas.
The host caches that context and uses the same object for surface creation.
Input uses the existing 32-byte event ABI, including resize events, key presses,
Space parity, all palette clicks and Escape. The private microsecond clock uses
the embedding's real `performance.now()`; native rendering keeps Basic timing.
No public WASM Window_Type or Input compatibility is invented.

Normal Node/WASI has no canvas/GPU service. The original tour's availability
check reports this and returns from its optional graphics stop. No GPU work is
represented as having rendered. A real browser with GPU, canvas and JSPI retains
the rendering path, shader and existing frame logic.

## Files and temporary storage

File_Utilities has no reviewed WASM `visit_files` export. A private tour adapter
uses the existing sandbox/WASI C bridge's `opendir`, `readdir`, `closedir` and
`access` procedures, with their shared directory-entry layout. Native tour code
uses aliases of the canonical File_Utilities procedures/type. The recursive
census, file reads, headings and write/read/delete stop remain intact. The private
walker reports open/read/close failures; it does not follow symlinks or guess
unknown entry kinds. Such traversal is a reported failure, not an empty success.

The Node WASI runner maps virtual `/tmp` to the real configured host temporary
directory, canonicalized using Node's `tmpdir` and `realpathSync`. The existing
root preopen remains. This follows the [Node WASI preopens contract](https://nodejs.org/api/wasi.html#new-wasioptions)
and keeps host temporary storage available when the host `/tmp` is a symlink.
Verification uses an owned T7 TMPDIR. The regression checks actual host-file
bytes, not just the program's report. It does not resolve arbitrary host symlink
behavior or change public File semantics.

## Verification and limits

Captured in the owned T7 `required-tour-ac174` directory:

- Unchanged `check_scripting_wasm.mjs`: nine repeated compiler fixtures, original
  full tour/output assertions, asynchronous JSPI stdin, arguments, exit7 and LSP.
- Unchanged required Rust `wasm_tour_runs_as_a_wasi_command`: actual emitted WASI.
  Separate full-tour O0/O2 executions satisfy every existing output assertion.
- Private runtime regression: workers/barriers/contention/joins, in-memory files,
  source isolation, invalid handles and public Thread/Process/Window_Type rejection.
- Seven actual WASM canvas-protocol cases, plus exact recursive/shallow directory
  counts, byte reads, errors and write/read/delete controls.
- Five selected JS host protocol tests and the actual wasm32/JSPI bridge test:
  real cooperative workers continue during asynchronous mapping and frame waits.
  The bridge uses private scheduler hooks, not the unsupported public Thread API.
- Native target source checking only; no native GUI/SDK execution in this batch.

JS protocol tests and the JSPI bridge use controlled WebGPU objects. They prove
marshalling, context identity, event semantics and scheduling, **not hardware GPU
rendering**. Actual browser rendering remains a hardware acceptance obligation.
The unrelated suspended memory investigation was not resumed. No original
corpus sweep, performance benchmark or required-gate waiver was performed.

Earlier failed full-tour, private-clock and WASI temporary-directory captures
are retained alongside the passing results. The early no-context callback
assertion was corrected by recording worker failure and asserting after join.

Run the new private controls with a source-built full `jai_wasm.wasm`:

```sh
node --experimental-wasm-jspi tools/check_tour_canvas_wasm.mjs PATH/jai_wasm.wasm
node tools/check_tour_files_wasm.mjs PATH/jai_wasm.wasm
```

Keep `JAIC_REQUIRE_WASM_TESTS=1` for the required Rust WASI tests.

Formatting and strict native-test clippy pass. The wasm32 source build retains
the baseline unused `inspect_callable` warning; this batch does not suppress it
or edit the separately owned semantic implementation.
