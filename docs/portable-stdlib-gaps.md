# Portable implementation gaps

This worker ledger complements docs/specs/stdlib/questions.md. Local tests prove
the implemented behavior; they do not establish missing reference contracts.

Crash-handler native integration, process-lifetime library pinning, existing
signal/alternate-stack replacement and deployment/Linux/Windows limitations are
described in [crash diagnostics](portable-crash-handler.md) and the mandatory
[deviations report](status/stdlib-deviations.md). Native best-effort backtraces
do not establish an exact reference diagnostic format.

Zip_File_Directory.position_in_file currently records the central record's file
offset; its intended meaning is absent from the reviewed contract. Trailing junk
and directory digital-signature records are rejected. These extension policies
need review. See [directory parsing](portable-zip-directory.md).

Atomics preserves the three exact load/store/exchange aliases, but the source
compiler lacks the corresponding bootstrap intrinsic dispatch. The original
`pending/atomic-intrinsics.jai` reproduces the failure. CAS-based arithmetic and
bitwise updates execute; full scalar-domain/conversion contracts require review.
See [Atomics implementation](portable-atomics.md).

Deep_Copy's graph path retains a checked failure because the source compiler
returns zero struct alignment metadata in both modes. Pending minimal reflection
and graph tests retain the actual failed assertions. Scalar/string/scalar-array
copies work; graph conformance is not counted. Ownership, shared-slice extents,
scalar pointers and diagnostic-statistic policies require review; see
[Deep_Copy progress](portable-deep-copy.md).

BuildCpp's Unix host commands work, but Windows/cross-OS toolchains, static-library
dependency merging and multi-source OBJ_FILE are unfinished. Naming/environment
parsing, source extension sets and warning forwarding require review. See
[BuildCpp behavior](portable-buildcpp.md) for actual native tests and cleanup policy.

Treemap's built-in border policy, coordinate orientation, flush_nodes endpoint
convention, equal-weight order and automatic invalidation after same-count weight
changes need review. The current supported squarified layout and unchanged growth
area regression are described in [Treemap design](portable-treemap.md).

Meow Hash's register macros are blocked by the compiler's register-operand macro
binding: the canonical distinct-u16 __reg type is rejected for a caller u64 operand.
`pending/register-macro.jai` retains the original failing call. The compiler's
current rule recognizes Code parameters; replacing the public register type with
Code would violate its reviewed identity. General register-operand semantics must
be fixed at that boundary before counting Meow's macro API as supported. Only the
official public upstream C implementation was consulted for algorithm feasibility;
no original/upstream Jai implementation was accessed or ported.

Shared_Memory_Channel implements real Unix SPSC transport; framing/alignment,
absolute offsets, logical-capacity/name/OS-magic and paused/reconnect policies
need review. Windows is absent, Linux native unverified, failed OS cleanup can be
partial, and early unjournaled resources are honestly recorded in
[shared-memory design](portable-shared-memory.md). Simple_Package lacks package/
TOC magic values and per-entry wire encoding in its current page; do not fabricate
a replacement archive format to claim conformance.

Autorun callback module parameters and full option grammar are absent. Its real
lifecycle/helpers use explicit argv assembly while the compiler loses mixed
scalar/spread prefixes; the failed interpreter/native assertion remains. CLI
generation expects a non-oracle public helper; do not invent that export. See
[Autorun integration](portable-autorun.md).

- Text_File_Handler helpers return independently allocated array strings/table
  keys. Callers free each plus container storage. The spec does not yet settle
  exact helper ownership. With version parsing enabled, startup currently requires
  a nonnegative decimal bracketed first processed line; sign/whitespace/missing
  header edges need review. CR/LF/CRLF are recognized; terminal newline produces
  no extra final empty line. Diagnostics include file, line and caller location;
  exact wording is not claimed. Public error receives its handler by value, so
  owning parse/load paths explicitly set the sticky failed flag.
- Remap_Context's lexical expansion is withheld. The pending macro-push-context
  reproducer retains a failed restoration assertion: caller-scope context push
  ends at the macro block. Both remap procedures are implemented. Duplicate
  base/custom names and optional stack-trace adjustment remain unspecified.
- pending/widened-bitwise.jai retains the byte-cast/bitwise narrowing failure;
  Wav_File assembles bytes using explicitly widened locals. Duplicate WAV fmt/fact
  policy remains under review; current parser takes first fmt/data and last fact.
- pending/workspace-hook.jai records compile-time workspace retrieval failure.
  Thread's automatic workspace metadata remains withheld, not fabricated as zero.
- Apollo duration representation/rounding is assumed signed femtoseconds, which
  is not explicitly established in the current spec prose. Do not extend native
  or calendar conversion from round-trip evidence alone.
- Flat_Pool's default reserve and overwrite option scope/value are absent.
- Process finite STILL_RUNNING boolean, live deinit/stdin inheritance, and the
  quote grammar beyond supported double quotes remain under review.
- Command_Line nested/overlay fields, help result/priority/layout and full numeric
  consumption edges remain under review. Flat fields and fixed arrays work.
- System's Linux topology queries currently use the permitted online logical
  fallback. CPU counter semantics are unresolved and that export is withheld.
  Android is not accepted by the current CLI; macOS x64 passwd shape is missing
  from the new native binding inventory.
- The source-built full jaifmt CLI now builds with the new foundations modules
  in an integration directory and passes the complete owned --check scope.
  The temporary file-only frontend has been removed.

Scalar hash seed mixing was clarified in the latest reviewed Hash page. It is
assigned to the foundations worker; no duplicate implementation is added here.

Overwriting_Allocator uses the new independent scalar-hash implementation only
in the integration root. Lifecycle/thread modes currently forward to the base;
the prose permits forwarding/no-op but does not list the exact per-mode mapping.
Destroying the wrapper releases tracking metadata/mutex, not remaining client
allocations. Clients must release allocations while the wrapper is alive; exact
behavior for destruction with outstanding allocations remains under review.

Unmapping_Allocator's contract says free changes writable pages to read-only,
but also says stale reads/writes fault. Read-only native protection faults writes
while allowing reads. This implementation follows the explicit read-only mode;
tests verify stale writes fault and retained reads remain possible. Clarify that
contradiction before claiming stale-read faults. Reservations intentionally
remain mapped after free/deinit. OS lifecycle/thread modes require no per-thread
state and currently do nothing; their exact compatibility policy needs review.
Windows/console backends remain unimplemented.

Soa omits explicit overlays/imported aliases/constants and keeps the first stored
field when raw extents overlap. The contract does not settle which union arm is
selected for general overlapping unions. Pointer iteration gathers a temporary
and scatters on scope exit, including continue/break/return. In-loop accesses
through other aliases observe writeback only when that iteration ends; whether
the experimental pointer contract requires finer-grained observation is unclear.

Print_Color currently emits ANSI style/color as ESC[style;color m (without the
space) and reset as ESC[0m. Exact escape byte serialization and combinations of
the numeric enum_flags color values are not specified. Native Windows console
attributes/save-restore are unimplemented and explicitly rejected. Windows with
USE_ANSI_CODES_ON_WINDOWS=true uses the supported ANSI branch.

Default_Allocator implements only its documented C-runtime fallback. Its
optimized X64 (except iOS) and Switch heap implementation remains unimplemented
and is rejected explicitly; supported fallback tests are not counted as X64
heap coverage. The fallback's unsafe_reset is the explicitly specified no-op;
it exports neither the optimized allocator value nor heap/statistics names.

Protocol_For_Memory_Visualization's compare_alloc_and_free_traces signature does
not establish equality versus ordering semantics. It is withheld, rather than
inferred from its name. The packet layouts, tags and version/channel constants
are implemented and tested independently of any transport/receiver.

Xar returns null on backing allocation failure without changing count, and
captures the allocator before the first attempt. The exact allocation-failure
policy is not specified. End/zero iterator operations return null and keep their
iterator unchanged; that side effect is likewise not settled. Comparator callbacks
currently use a negative/zero/positive result convention. Equivalent T.Element_Type
references preserve the public callback types while resolving exported generic
headers; spelling those as array.Element_Type currently fails in this module's
compiler loading path. A simple same-file procedure does not reproduce it, so no
general compiler root cause is claimed. The public types/parameter names are
unchanged. Max_chunks/overflowing-shift invalid configurations are rejected.

Mail.scramble has no described transform or output lifetime and is withheld.
Current enable_ssl requests mandatory SMTP STARTTLS, not implicit SMTPS; the
reference policy is unspecified. Required-TLS rejection is tested, but positive
encrypted delivery/custom CA verification remains unverified. Header encoded-word
handling, exact message serialization, default port and proxy/environment policy
are likewise not established by the prose. Current transport uses protocol default
port when zero, disables inherited proxy/netrc settings, and uses only explicit
caller authentication. Native C string fields reject NUL, and header values reject
CR/LF to avoid silent truncation or injected headers. Attachment strings are
interpreted as filenames. All current transport tests use this checkout's own
127.0.0.1 receiver and synthetic fixture credentials, never existing credentials
or external recipients.

## MPEG increment

Buffers, immutable tables, pixels/IDCT and elementary video decoding have real
focused coverage, as do unprotected Layer II audio, MPEG-1 program streams and Plm
lifecycle/linear seeks. B-stream/nonconstant AC/stereo fixtures, CRC and format
changes remain limitations. Seek/macro/stream-bound contracts remain unresolved. Exact unknown
contracts and general import-resolution reproducer are documented in
[portable MPEG](portable-mpeg.md). Windows checking fails at the separately owned
File guard and is not counted as MPEG support. No empty decoder bodies or guessed
macro exports were added.
