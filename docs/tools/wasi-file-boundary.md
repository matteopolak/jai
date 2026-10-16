# WASI module and caller-file boundary investigation

The sealed catalogue128 handoff is unchanged. Its six damaged modules and old
execution receipts remain intact. This investigation tests a specific proposed
cause: a duplicated module argument causing a file-effect program to overwrite
the file from which it was instantiated. It does not presume a compiler,
filesystem or disk-space cause.

## Mechanism and controls

The production tools/wasi_run.mjs passes `[module, ...callerArgs]` to Node WASI.
Wasi_Runtime widens the real WASI32 argument pointer table and forwards its count
to Runtime_Support; Basic converts those pointers to strings. Both sources behind
the six old damaged modules contain no argv consumption or file operations.

The opt-in tools/wasi_file_boundary_observer.mjs is loaded with Node `--import`
before the actual production wrapper. Set FOUNDATIONS_WASI_TRACE to a new receipt
path. It forwards real imports once, retaining results and thrown exceptions,
and records actual argument strings, path opens, descriptors and module hashes
before/after WASI start and process exit. It provides no missing imports or fake
filesystem calls. Receipts use exclusive creation and must differ from module
and caller-data paths. No environment values are dumped.

The original file-effect control takes exactly a module path, separate caller
data path and boundary-token. It writes and reads a nonzero payload through
canonical File, preserving all assertions. The pure wire control is the unchanged
production-owned resource-wire regression. Each module, data file, trace and host
receipt has a separate name under the assigned T7 namespace.

An observing JAIC_WASM_LD wrapper forwards the exact actual installed LLD command
and records its actual output bytes before the compiler returns. A separately
written/fsynced copy contains those exact bytes. This diagnostic copy is not a
repair for the original output. The default-link pure control also runs without
the linker observer. Compiler, linker, sources and command vectors are hashed in
an immutable safe-source snapshot; no reference or peer program is used.

## Observed boundary

Nine actual Node executions succeeded. Pure controls received one argument and
called only fd_write on stdout. File controls received exactly three arguments;
path_open targeted only the separate data file, and file writes used its actual
descriptor. Payload readback matched. All module hashes remained identical
through Node process exit.

A delayed audit nevertheless found all five original linked outputs zero-filled
while their four independently written byte copies retained the exact valid
hashes. Original file timestamps remained at creation. Thus the proposed WASI
argv/file overwrite mechanism does not explain this reproduced corruption. No
failed module is relabelled as a required negative or unavailable target.

A direct public SDK control uses clang and wasm-ld without Jai, Node or WASI.
Its 326-byte linked module remains valid at 60 seconds but is zero-filled at the
90-second audit. The 329-byte clang object and ordinary byte copies, both with
and without fsync, retain their hashes. This independently reproduces the native
linker output failure and rejects the initial output-size hypothesis.

A second independent native SDK consumer calls the installed public LLVM
FileOutputBuffer create/commit API with four documented flag combinations. All
four commits return success and initially contain the same 4096 bytes. The
flags=0 and F_executable files later become entirely zero; F_mmap and
F_mmap|F_executable retain their bytes. The earlier two-mode control retained
both files through 90 seconds, so the observed latency is not a guaranteed bound.
This isolates failure at the native default/executable output-buffer commit
boundary in this environment; the underlying SDK/OS writeback cause still needs
producer investigation. It does not establish a general File or WASI bug.

The [public LLVM writer source](https://github.com/llvm/llvm-project/blob/main/lld/wasm/Writer.cpp)
informed the flag comparison; current upstream source is not claimed identical
to the installed binary. The installed SDK header supplies the actual constants
used by the consumer. Both create and commit errors are fatal; delayed contents
are audited separately from exit status. These are file-producer reductions,
not performance benchmarks. Precise outcomes are in
[the investigation receipt](../status/foundations-wasi-file-boundary.json).

## Evidence and limits

The immutable runtime snapshot and final formatted fixture have distinct source
hashes where formatting changed whitespace. Neither is silently substituted for
the other. Node helper regressions check transparent forwarding, real pointer-table
decoding and BigInt rights. Source checks and strict public-context lint use the
frozen source-built tools. The observed actual-byte copies provide scoped durable
WASI execution evidence only after delayed hash verification; they do not clear
the original six corrupt artifacts or establish a production output fix.

Any general file-provider or compiler defect belongs to its producer. Foundations
has made no production wrapper, compiler, File, JSON or Extensions change. The
root833 sanitized inventory is reported admitted by the coordinator, but its
relative transport path is absent in this sandbox; an exact readable coordinator
path has been requested. Own commands are actual captured vectors. No CI argv is
claimed recorded where the job did not print it.

The first SDK consumer build exposed an unused parameter in an installed SDK
header. Its failure is retained. The corrected command classifies that official
include directory as a system header and retains -Wall/-Wextra/-Werror for the
owned source. The final four-flag command pair overlapped a newly posted numerics
lease; both commands completed and the overlap is recorded. No serialization or
timing-isolation claim is made for that pair. Delayed audits hold no native lease.
