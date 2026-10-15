# Portable stdlib worker deviations

REMOVED Default late-parent-option workaround: reviewed during-compile API controls
do_output/debugger, preserving static output type/name/path and dynamic settings.
Normal/interpreter build-driver modes both create actual native child workspaces;
no interpreter-only restriction remains. Target optimization explicitly selected
with reviewed options; new parent-state assertions and all existing native/runtime
assertions pass alongside full owned strict lint. Previous parent-output dependency
below is superseded. No compiler change, name exception or external CLI bypass.

Direct signing keys use installed native crypto CLI on POSIX hosts, not a linked
LibreSSL ABI backend. Production dependency: compatible openssl req/pkcs8/x509 on
PATH; absence/failure yields explicit false/diagnostic, never fabricated key data.
Independent policies: SHA256 self-signing/365-day validity, private unique0700
directory, DER X509/PKCS8 outputs,0600 key permissions, component-only key names.
Native Mac SDK validation passes; Windows backend returns diagnosed unsupported,
Linux/Android native pending. Proper long-term fix: native licensed C crypto ABI
plus platform exclusive file/directory backend, preserving public model/signature.
No user keys/configs/credential stores read. Subject escaping, ownership and full
failure cleanup tested; details portable-direct-signing-key.md. Test oracle fixes
(misspelled member/local redeclaration/unestablished duplicate-failure policy)
are separate from the real minimal crypto config fix.

Default parent-output phase follow-up: current real Default workflow sets its
parent output_type to NO_OUTPUT inside build. Removing that setup in a staged
probe causes the own compiler to write a parent with no main after child build
(target/default-without-root-options.log). Filtered oracle rejects late parent
option mutation in the separate timing probe. Valid parent-output/evaluation
phase needs compiler/reviewer reconciliation; no exact-reference phase claim.
Existing child artifacts/workspace tests remain genuine. General proper fix must
handle build-script parent output through supported phases, not module-name hacks.

WITHDRAWN plugin architecture: initial draft assumed a running procedure could
add the definition of its own unresolved callee. Filtered17:45 reference oracle
disproves that assumption; timing probe also changes root options too late. These
are invalid architecture/test expectations, not required compiler semantics.
Draft never entered active stdlib; no patch to compiler proposed after correction.
Candidate/probes marked rejected/invalid, retained evidence. Real dynamic public
helper remains missing while dirty reviewer supplies valid boundary; parser tests
pass. Earlier compiler-gap wording below is superseded. Details dependency doc.

Metaprogram_Plugins only record/parser are active. Real initializer candidate and
positive dynamic-name test remain outside completed support because general
compile-time add-source/forward-call suspension is missing. Full candidate lint
and positive execution fail, not skipped/converted to pass. Source generation
does not restrict requests to top-level CLI. Public parser's out-of-range index
policy returns false safely; unreviewed prefix edge documented in dependency doc.
Initial fixture redeclaration/.[] dynamic-array-literal errors were corrected
without changing assertions or public contract. No legacy oracle adjustment.

Default_Allocator optimized-target implementation uses owned C blocks/per-heap
intrusive lists and one CAS lock, rather than span caches. This preserves real
heap/resize/ownership/bulk-release behavior and exact standard public layouts;
linear ownership/free lookup and global contention are performance risks. Public
size-class/cache fields stay zero because this backend has no caches; real heap
cache counts are zero, and standard global dummy stats are reviewed behavior.
Proper long-term optimization: indexed ownership/per-heap locking/real caches,
retaining all lifecycle and concurrency regressions. Pointer alignment16 is
validated on actual Mac x64; other native SDK targets pending. Validated numeric
limit uses64KiB margin because reviewed page names a span but omits its byte size;
exact boundary review requested, no source-equivalence claim. Existing fallback
source remains unchanged. Details portable-default-allocator.md.

Active Mac Socket record batch: real SDK/interpreter/native behavior validated,
but full generated-binding strict lint remains FAILED because the compiler cannot
evaluate type_of(fd_set.fds_bits[0]) where fd_set denotes a type. Location and
minimal original reduction pending/field-array-element-type.jai; evidence
target/socket-resolver-active.log. New database fixture strict lint passes, which
is explicitly a narrower check and never a replacement for the failed full gate.
No public type query rewritten, no compiler path/name special case, no lint rule
disabled. Proper fix is compiler field-element type query semantics; rerun full
binding lint after that producer checkpoint. Other-OS native ABI remains pending.

Recovery tool configuration: the launch-assigned T7 target is an authorized own
source build location, accepted through explicit CARGO_TARGET_DIR alongside own
checkout target/. No alternate external-build discovery or reference fallback.
This fixes a test-tool guard failure, not a production stdlib defect. Fresh mail,
channel and crash checks pass; combined original corpus remains coordinator-owned.

Mail scramble: current reviewed alphabet lists characters but no explicit numeric
index table/ciphertext vector. Independent implementation uses ascending listed
order; reversibility/cyclic/temporary/error tests pass on actual interpreter/native
O0/O2, without claiming reference-vector proof. Exact interoperability risk and
proper fix (reviewed mapping/vector, then retain exhaustive behavior tests) are
recorded in portable-mail-questions.md. Unsupported input returns empty safely
after its optional assertion; invalid-input behavior with assertions disabled is
an independent safety policy, not an established reference guarantee. No errors
are converted to successful sends and no transport test assertions changed.

Shared signing model scope: exact data declarations only, explicitly requested
to unblock project worker; no signing/key-generation function counted from model
tests. Genuine union/promoted-field/default/name behavior and full source/lint/
native gates pass. Fixtures use literal test-only strings, never real credentials.
Read-only NEW File/Windows-text staging completes dependency closure; it is not
claimed production integration or an API shim. Details portable-signing-model-handoff.md.

Default Check dependency resolved using real NEW producer factory/parameter and
private engine closure. Full owned strict lint now passes. Fixture correction:
normal CLI added #run invokes callable test bodies, keeping every behavior and
assertion while lint does static body checks. No source-name branch, skipped
assertion, fake checker or target-building bypass. Compiler unsupported backend/
debugger and corrected selected-workspace option readback remain genuine gaps;
old missing-factory/lint-block notes below are historical.

Runtime Android discard: queue uses independent4096-byte capacity/line/forced
flush policy and ordinary raw descriptor sink. Exact finer Android flush/sink
policy is absent from reviewed public page, so no logcat tag mapping or exact
Android conformance invented. Private discard never flushes. Real host byte-I/O
tests and strict lint pass; Android public branch/device and binding adoption
remain pending. Private unit fixture is byte-identical under a target-only library
test module, preserving external private-import rejection; it is not a production
facade/API shim or SDK simulation. pending/android-logger-discard.patch is for
coordinator/owner application, not an edited peer. Details/evidence in
portable-runtime-output-discard.md.

Compiler command-line oracle refined: old get_toplevel scope expectation is
unspecified, so that probe alone was insufficient evidence. New selected-workspace
get_build_options().compile_time_command_line probe fails under the explicit
read/write contract; remaining compiler request uses this genuine evidence.

Default plugin-array ownership correction removes a dangling public descriptor
after shutdown by using Basic.array_reset. Actual repeated workspace/plugin builds
verify cleanup, retaining callbacks and error behavior. No caller patch, lifecycle
registry, public layout change or skipped assertion; full lint dependency unchanged.

Memory protocol comparator review scope: no workaround, reduced semantics,
allocation/dereference, disabled assertion or lint exclusion remains. Both opaque
pointer identifiers are compared exactly. Compile-time/interpreter/native O0/O2
and required source/lint/layout gates executed. External visualizer integration
and native other-OS execution are not claimed from this focused completion.

Project_Generator verification limits: required compile-time real executable path
default is unavailable in jailint SandboxHost (_NSGetExecutablePath); strict lint
remains failed, original generic reproducer supplied, no default/tool exception.
Real CLI builds and XML/artifact/mtime/ownership behavior pass. Native VS/MSBuild
opening/debugging is not executed on Mac. Conventional reviewed jai.natvis path
is emitted but resource is absent from this snapshot; no visualization support
claim. Deterministic SHA256-derived instance/filter IDs and independent standard
VC++ Makefile scaffold are design choices, not original output reproduction.
Process-lifetime generated configuration defaults persist as required; reset
only frees project_files. Output writes are sequential with explicit failure,
not transactional (no stronger reviewed guarantee). Initial array_free/reset
and substring-count mistakes caught by genuine assertions and corrected through
reviewed Basic.array_reset/String.slice semantics; no test weakened.

Socket reexports corrected: native variables now use filtered using, preserving
canonical storage and visibility. No live mutable :: workaround remains in the
owned generated facade. Actual SDK C address/mutation comparisons pass; scoped
lint covers the new fixture/bridge, while whole generated binding lint remains
red on general field-array-element type query. Mac resolver/CMSG runtime now pass
with forward-enum fix; candidate source remains retained rather than claimed
fully integrated. Runner selects only assigned CARGO_TARGET_DIR or own fallback;
no peer/external build reuse. Initial dynamic test library naming corrected to
documented stem resolution; no compiler or ABI semantics altered.

Default plugin-generation pass now suppresses parser reporting/global actions;
duplicate deprecated-option/context diagnostics removed through a general private
parser phase parameter. No public API change or test exclusion. Full lint remains
blocked on the documented Check dependency rather than marked green.

APK safety scope: loader/iterator explicitly check sizes, leading/trailing signing
block lengths, signatures and bounds rather than reproduce unsafe unchecked reads.
Malformed files assert; no recoverable success or valid-signature claim. Fixtures
include a deliberately unsigned marker-only block, and is_signed remains marker
semantics. Native Windows/Linux/Android, real device and cryptographic signing/
verification are separate pending work. No lint/assertion exclusions in positive
APK scope; POINTER fixture is a required negative compilation gate. Public ZIP
enum order now matches reviewed declaration order, preserving reflected order.

ZIP writer deflate tradeoff: internal/archive/android-zip-writer.jai emits real
raw DEFLATE stored blocks rather than LZ/Huffman matches. Independent zlib reads
empty/single/multiple-block output correctly, but payloads grow by5 bytes/block.
No claimed compression ratio guarantee exists in the reviewed spec. Proper future
optimization is a general compressor with equivalent round-trip/boundary coverage.
Writer directly serializes reviewed target records on supported little-endian
targets; no big-endian guarantee invented. ZIP64/oversized/unsupported alignment
diagnose, and failure after a builder allocation may leave partial output (no
transactional guarantee in reviewed API). Temporary storage/names must survive
finalization; no reset/reuse promise. Public #align/#no_padding review resolves
the old field-only probe gap. Strict lint and format/--check executed on owned
writer/records/facade/tests. Test corrections and initial invalid-block evidence
are recorded in portable-zip-wire.md; no failed assertion was blessed as success.

Example_Plugin scope review: no missing reviewed entry or test exclusion remains.
The public some_state stores33 plus messages observed after init; this gives a real
count while preserving exact layout and allocation ownership. Diagnostic prose is
independently worded. Public direct-callback fixtures supply typed messages only
to test reporting; separate actual compiler-workspace runs verify real messages,
output and shutdown. No public callback is a fabricated completion/artifact path.

Default build partial dependency: Default_Check.get_plugin is required by the
generic plugin workflow but absent from the reviewed Check inventory and NEW
producer. No fake plugin/body/check success is supplied; default builds and full
strict lint fail explicitly, while real -no_check/custom-plugin runs pass. Binding
configuration is not claimed implemented; get_plugin shape/config needs producer
review. Default_Metaprogram build remains inventory-incomplete. Compiler wrapper
stores but does not forward target CLI/context/diagnostic fields; original target
CLI assertion fails. X64 backend/debugger flags project correctly but compiler
rejects unavailable implementations. Proper fix is reviewed Check factory/config
and general compiler workspace forwarding, not facade/CLI exceptions. Details and
evidence: default-metaprogram-dependency-request.md and portable-default-metaprogram.md.
The generated unreachable disabled-Check branch diagnoses accidental invocation;
it is not a check implementation. Plugin grouping uses ordinary generated static
imports with real module parameters; dynamic names are not runtime-loaded.

Current compiler1929d5a corrects the constant-alias problem below: assignment now
rejects with cannot-assign-to-constant. Old acceptance evidence retained. Build
uses only assigned per-worker T7 output; authoritative reports/sources remain local.

Historical source-built compiler audit limitation:784415f implements live named ::
storage aliasing rejected by refreshed public constant contract. Original pending
constant-alias-immutability.jai is wrongly accepted (-check exit0). No program
execution or library workaround used to manufacture a result. Resolver/enum
diagnostics are separate unaffected paths; wider compiler semantic compatibility
not claimed. Compiler owner must restore immutable bindings and fix type-query
initialization separation, retaining legitimate declaration reexports. Evidence:
target/constant-alias-contract-conflict.log; no producer Rust changes or peer writes.

ZIP wire supported policy: version minor0..9 and low byte<=255; complete correctly
signed EOCD input, writable setter backing; invalids log/assert with no mutation.
Finer reference recovery policy unestablished, documented portable-zip-wire.md.
CRC32 uses portable bit loops (deliberate slower tableless strategy); no CRC64/API
substitution. Unit macros preserve language arithmetic/argument semantics.
Header sizes32/24 versus wire30/22 await reviewed distinction; no #pack/ABI guess,
public default-version guess or writer stub. Native other-OS runtime pending.
Shared staging explicitly copies real owned source dependencies plus NEW foundation
read-only inputs, replacing repeated incomplete lists without fixture API shims.

X.509 extractor supports DER structural key-info location, versions0..2; does not
claim signature/trust validation. PEM/concatenation/trailing/error-recovery finer
policy is not established by reviewed declaration; supported first-object policy
documented portable-x509.md. Production is pure checked ASN.1, no C crypto ABI.
Native OpenSSL used only as independent test oracle, pinned explicit installation
prefix and no user config; ephemeral newly generated keys never written/read from
credentials. Public DER/native expected SPKI data regenerated for each run.
Native Linux/Windows/Android not executed; separate source-only fixture never
counted as behavior. Proper follow-up: fine contract review and platform CI.

ASN.1 diagnostic conventions: labeled human lines, spaced lowercase hex, yellow
Print_Color ANSI-backend banners, standard native-C UTCTime1950..2049 year mapping,
newline on empty constructed context and invocation-wide skipped indentation.
Finer reference punctuation/century/leap policy not established; recorded in
spec questions and portable-asn1.md, not presented as observed reference output.
Native Windows console rendering remains unavailable; explicit supported ANSI
backend selected. Iterative frames avoid host recursion; per-indent/field printf
calls have deliberate overhead for diagnostics, future batching can improve it.
All supported types/overloads have real bodies; malformed input logs/asserts,
frame allocations are released on normal/early return by defer. No fabricated
parse defaults treated as successful output or hidden assertion/lint suppression.

macOS addrinfo candidate excluded from active source while general forward-enum
compiler defect persists. Location: pending/socket-macos-addrinfo.patch, generated
staging target/portable-socket-resolver; gate tools/check_portable_socket_resolver.py.
Observable effect: API remains missing, existing Socket code retains prior behavior.
Evidence: both native C CPU probes pass; Jai resolver/strict lint fail ADDRCONFIG,
minimal reduction fails LATER; activating shape regresses existing cmsg-layout.
Risk: native Jai resolver remains unverified. Proper fix: compiler dependency graph
retaining enum reflection order, then regenerate normally and run full gates.
No source enum/member-order workaround or disabled assertions. Generated docs
ledger manually marks the retained candidate; later normal generation removes
that temporary documentation note. C-only evidence never counted as Jai support.

ADB SDK/startup earlier gap is now implemented. Durable default-allocator cache
retains one current executable path until rediscovery/process exit; allocator
identity saved for proper Basic free on replacement. This prevents temporary reset
from dangling the executable. Concurrent public cache/config mutation is not
guaranteed; callers serialize it. Current cache retention is deliberate process
lifetime, not a hidden per-call leak. Tests compose actual NEW foundation sources
under target/ only; coordinator production integration is still pending.
Existing-conventional-home precedence source implemented, not native exercised
because host SDK directory absent and tests do not modify user home. Windows
Process/System integration and real SDK/server/device verification remain pending.
23 host protocol executions plus exact default-assert distinction prove startup
ordering/failure, not an installed SDK. See portable-adb.md for test corrections.

ADB reviewed policies first correction: temporary capture backing preserves
device/version views until temp reset; array is temporary. Safe lifetime choice
is explicit where reviewer says original backing lifetime ambiguous. Generic
quote/compression/PID/error contracts corrected. SDK discovery/cache/server startup
still missing and must be integrated before full ADB conformance claims.
Test staging deviation exposed by new assertions: malformed executable copied
without execute mode, so older tests accidentally covered launch failure only.
copy2 fixes mode; stronger diagnostics prove native parser executes. Original
failure retained in target/adb-reviewed-policies-first.log; no suppressed failures.

Refreshed ASN.1 correction supersedes earlier signed/high-tag/active-only/alias
assumptions below: single supported identifier, nonnegative1..8-byte INTEGER,
full-record OID equality, dotted trailing period and known-array implemented.
Value TLV/content borrowing and consumed expected mismatch now exact. Safe
malformed diagnostics/cursor policy is explicitly independent where review grants
no recovery contract. Generic readers still little-endian-target implementation;
all configured targets currently little-endian. Original provisional tests/logs
preserved as historical evidence, corrected oracles documented separately.
ADB review also resolved many earlier fine policies; current startup/discovery,
quote/cache/temp-storage/PID implementation requires correction. Those gaps are
not completed by earlier host protocol totals; portable-adb.md records follow-up.

Manifest flag parser: exact reviewed16 names/masks and official SDK | grammar
implemented. Empty input gives no flags; unknown/empty components log+assert and
return zero if assertions continue. Whitespace/invalid recovery fine policy is
not established by inventory; review requested in portable-android-values.md.
Risk: public finer policy may differ and require correction, not silent token
dropping. No newer SDK exports, partial-success fallback or native Android claim.

JAVA_HOME discovery: require successful actual java -version execution before
returning copied bin/executable paths. Environment lookup only reads explicitly
authorized JAVA_HOME; no PATH/default SDK/credential scan. Fine success/storage/
fallback policies need reviewer confirmation (portable-java-discovery.md).
Windows Unicode environment source is implemented using official Kernel32 ABI;
Windows Process integration and real JVM execution are not validated here.
Thirty source-built launcher protocol cases are host process evidence, not Java
or Android compatibility certification. Proper follow-up: real SDK/JVM Windows
CI and reviewed fine policy; no fake JVM/native Android output or hidden bypass.

This is the portable worker's current review record, not full release approval.
The complete per-module completion inventory is in
[the module ledger](../portable-stdlib-ledger.md). Unimplemented entries remain
unfinished work and are never counted as supported functionality.

| Location | Effect and rationale | Evidence / risk | Proper resolution |
| --- | --- | --- | --- |
| `internal/runtime/crash-native` | Newly written C callbacks replace a superseded Jai signal/TLS callback path: native callbacks must outlive interpreter shutdown. The library is pinned for process lifetime. | Both execution modes pass real faults and thread cleanup. A Jai TLS callback previously diagnosed invocation after interpreter completion. One library reference intentionally remains until process exit. Native symbolization remains best effort. | Retain native callbacks or implement an explicit compiler/runtime lifetime mechanism; coordinate crash-handler ownership. |
| `tools/build_portable_runtime.py` | Helper is built beside source, with build-tree macOS install name, to use existing source-relative foreign-library resolution. | Local source/native integration passes; copied deployment alone has not been verified. Missing runtime library causes a real load/link failure. | Coordinator packages and relocates the native runtime and verifies a moved installation. |
| Runtime crash initialization | Replaces existing signal handlers/alternate stack. Public API has no teardown; previous stack is not restored. Windows implementation absent. | Real per-thread stack and fatal-signal tests on macOS; Linux Jai checking only. Concurrent/recursive faults use immediate exit rather than another stack trace. | Review ownership/restoration requirements, implement Windows, execute Linux native tests. |
| Test/formatter integration roots | Copy new independently authored POSIX/Curl/Hash and formatter foundations/compiler dependencies into `target`; owned production tree is not a complete integrated distribution. Meow legacy verification separately stages NEW foundations plus basic-interface/native-path after the baseline's missing Basic.exit and initial missing native-path dependency. | Focused passes prove those staged compositions only; the x64-gated old Meow test actually runs its assertions with explicit target selection. No original implementations or binaries are used. | Coordinator integrates peer-owned sources and runs full corpus/release checks. |
| `Default_Allocator` | Only documented C-runtime fallback works; optimized x64/Switch mode explicitly rejects compilation. x64 target sweep excludes its fallback fixture. | Actual fallback allocation/resize/free passes; no optimized-heap claim. | Implement reviewed optimized heap API; run branch-specific verification. |
| Memory, sort/Xar internals | Portable byte-copy backend and in-place heapsort favor correctness over native-vector/tuned quicksort performance. | Overlap/numeric/sort and stable chunk tests pass; no comparative performance claim. Xar callback header uses equivalent `T.Element_Type` after `array.Element_Type` failed module loading. | Add measured optimized backends; reduce generic-header issue to a general compiler reproducer before compiler changes. |
| Wav_File | Uses explicit widened locals when constructing integers because inline widening in combined bitwise expressions fails. | `pending/widened-bitwise.jai` retains failed assertion; WAV bounded vectors pass. Duplicate-chunk policy unsettled. | General compiler width propagation fix and reviewed duplicate policy. |
| Remap_Context / Thread metadata | Caller-owned cleanup is now supported and the exact lexical macro is implemented. Automatic workspace metadata remains withheld; duplicate field and optional stack-trace policies need review. | Original caller-scope assertions and nested/early-exit macro cases pass interpreter/native; pending workspace-hook retains its compile-time failure. | Resolve compile-time workspace retrieval in compiler ownership and review optional mapping policies. |
| Apollo / System / Print_Color / allocators / Soa / Command_Line / Text_File_Handler / Process / Xar / Mail | Reduced platform coverage or unresolved contract choices are enumerated individually in the linked gaps document. No unresolved choice is claimed as reference conformance. | Local tests show selected supported behavior, not an API oracle. Includes femtosecond assumption, Linux logical CPU fallback, ANSI-only Windows, retained read-only frees, deferred Soa writeback, flat CLI fields, text ownership, subprocess quoting, Xar failure/iterator policy, SMTP STARTTLS/proxy/netrc policy. | Review each unresolved contract; implement remaining native/platform branches and test them. |
| Flat_Pool / Protocol_For_Memory_Visualization / Mail.scramble | Missing oracle details block specific exports; no fabricated constants, comparator or transform added. | Named in ledger/gaps and questions; unrelated implemented functionality has independent tests. | Obtain reviewed contracts then implement and test exact behavior. |
| Zip_File_Directory | `position_in_file` currently records the physical central-record offset, distinct from encoded `chunk_offset`; the spec does not define it. Trailing junk/digital-signature extensions are rejected. | Classic fixtures and malformed cleanup tests establish supported local behavior, not unresolved field/extension conformance. File dependency is currently Unix-only. | Review field and extension contracts; add Windows File integration. |
| Target sweep | OS-dependent cases excluded from unsupported Windows checking; pending reproducers are not included among positive passes. | Runner lists exclusions explicitly. Public/legacy fixture assertions and corpus remain unchanged. | Implement each backend and promote its focused cases after real execution. |
| Atomics | Exact load/store/exchange aliases now execute through updated compiler lowering; no surrogate procedures added. CAS retry loops remain for arithmetic/bitwise updates. Scalar-domain/conversion/ordering contracts need review. | Original intrinsic and direct alias cases pass both modes; prior four-worker contention checks remain. Retry-loop performance is unmeasured. | Review domains/order guarantees and benchmark native fetch/update optimization without changing entity identity. |
| Deep_Copy | Updated reflection enables verified cyclic/shared struct graphs; alignment guards remain. Fixed arrays/Any/unions are rejected; ownership, capacity, scalar-pointer, statistics and overlapping-slice policies need review. | Original graph/reflection assertions pass both modes and are promoted. Private statistics lock adds overhead; Windows timer only target-checked. | Resolve remaining policies, platform timer coverage and richer graph cases without weakening validation. |
| BuildCpp | Unix native-host GCC/Clang-style commands only; Windows/cross-OS discovery, static dependency merging and multi-source OBJ_FILE remain unavailable. Output naming/environment parsing/enumeration policies need review; successful tool streams are forwarded. | Real archive/link/dlopen/object/universal tests; missing tool/invalid C/wrong object tests. Early error reporting bypassed cleanup; replaced with ordinary failure collection and public reporting after cleanup. Original failed-run target dirs answer.build-HTLZeE/answer.build-ujcrhU and failing negative-case dirs were recorded then removed. Current runner requires no leftovers. | Implement reviewed toolchain discovery/unsupported cases; execute Linux/Windows native verification and define naming contracts. |
| BuildCpp test repairs | Local lipo rejects the combined two-architecture verification syntax; two separate invocations test both architectures. Native ar lists its symbol-index member, so stale-member test checks required 0.o and removal of prior 1.o rather than assuming no index. | Actual failing command diagnostics observed; neither architecture nor removed-member assertion is skipped. | Retain equivalent property checks across native tool variants; coordinator reruns on integrated supported hosts. |
| Treemap | Squarified float layout uses zero default borders, east/north coordinates and half-open flush ranges; those details need oracle review. Same-count weight changes require display dirty/force. Traversal remains recursive. | Stable buckets, hierarchy/sort/non-overlap/area/callback/cache/growth checks. Initial float drift was fixed using shared boundaries without changing the assertion. | Review border/range/cache/ordering contracts and depth requirements; add required behavior without changing public layouts. |
| Meow calico / ancillary contracts | Canonical SIMD reg aliases, real calico macros/state and mutable arrays are implemented. Raw Source means trailing region, r1/r3 are residual scratch and Store128 writes 128 pre-fold bytes; unused state bytes are preserved. Dump prints actual decimal lane pairs. These ancillary contracts need review. Portable IR lowering omits tuned prefetch and has no hardware-throughput claim. | 317 pinned own-source-built native C cases match interpreter/native O0/O2, including both state outputs and edited arrays. Scalar probe is correctly rejected; vector probe passes. No original Jai implementation or supplied binary used. | Review ancillary/state/window semantics and benchmark/optimize actual backend without changing aliases or global storage. |
| Shared_Memory_Channel | Unix only; wire alignment/absolute offsets/logical capacity/OS magic/name normalization/empty and paused/reconnect policies need review. Real CAS implements private load/store without changing public aliases. False release can represent partial OS cleanup without retry guarantee. | Local wrap/full/corruption/captured-allocator checks; 2,048 packets per four process pairings; Linux x64/arm64 checks only. Native backing extent is queried, not hardcoded. | Review wire details, implement Windows, verify Linux native and define failed-cleanup recovery requirements. |
| Shared-memory early test artifacts | Two early writer-connection assertion failures left PID-named objects before journaling; names were not captured, and no global sweep/deletion was attempted. | fstat reported 16384 while header said 512. Fixed extent handling; subsequent tests journal/unlink only recorded names. This does not establish cleanup of the historical objects. | Coordinator/owner may resolve historical resources with independently established ownership; retain precise journal cleanup and explicit production release contracts. |
| Autorun argv assembly | Temporary explicit argv workaround removed after the compiler mixed-spread fix. Public API stays exact. | Original mixed-prefix/spread assertions and real workspace child forwarding pass interpreter/native. | Keep the promoted regression; CLI orchestration remains separate unfinished scope. |
| Autorun plugin integration | Real COMPLETE lifecycle verified, but +Autorun is blocked by CLI generation expecting non-oracle Metaprogram_Plugins.build_with_plugin_groups. No convenience export added. Callback parameters/options unresolved; Windows absent. | Pending CLI source fails at missing module; reviewed inventory has only parse_plugin_arguments/init_plugins. Real child errors are logged. | Refactor driver to internal orchestration/canonical lifecycle, finish reviewed loading and Windows/callback contracts. |
| pl_mpeg | Buffer allocator/seek/error policies, even dimensions and alpha preservation need oracle review. Underspecified macros remain unfinished; MPEG-1 demux/Plm and video/audio limitations are recorded below. IDCT uses checked widened intermediates. Qualified Basic imports avoid a retained compiler type-resolution failure without renaming the public Buffer. | Original constructor regression retains the failure; bit/VLC/file, pixel and IDCT cases exercise real operations. Licensed C source is algorithm input only; public tables come from reviewed specifications. Raw pixel pointers cannot prove backing extent. Windows target checking actually failed at the existing File Unix guard; MPEG target cases are excluded from Windows only until platform-io File integration, not counted as Windows support. | Review contracts, fix general import resolution in compiler ownership, complete demux/decoders and execute real fixture decoding before claiming codec completion; integrate new platform File and restore Windows target checks. |
| MPEG video increment | Midstream dimension/rate changes and unsupported picture types/invalid regions fail explicitly. Decoder runs IDCT for DC-only blocks, adding work; zero-initialized reference storage adds creation cost. A temporary byte coverage array and linear pass reject missing/overlapping slice regions per picture. Repeated headers preserve pending frames and update matrices. Fixed/append input stays intact. B-picture prediction has direct coverage, but complete B/nonconstant-AC streams still need fixtures. | Independent constant intra blocks and ten real synthetic red I/P frames decode with rewind; matrix truncation/arrival, allocation failure/retry and lifetime tracking exercise real state. An initial new test expected two pixels for a full-pixel vector of one; unit analysis and diagnostic y=1/cb=1 established the test's error, corrected to x=1 without changing the algorithm. Final short-slice parsing was fixed while retaining completeness assertions. | Add independent B/AC fixtures, support reviewed stream transitions, benchmark coverage/zeroing and introduce verified DC fast path if justified. Complete demux/audio/Plm before claiming full codec support. |
| Vendored C whitespace | Unmodified official pl_mpeg and Meow source retains upstream trailing whitespace, so unrestricted git diff --check reports those lines. | Recorded SHA-256 matches the exact official algorithm inputs; owned Jai sources use real repo format/lint. Standard MIT license template is explicitly identified, not an invented copyright notice. | Preserve provenance; scope whitespace validation to owned authored files or adopt an explicit vendor-only repository policy. |
| MPEG Layer II synthesis | Direct precomputed cosine matrix uses delegated Math and f64 accumulation, trading speed and rounding order for an independently verifiable implementation. Canonical public state/parameters remain exact. CRC-protected audio is now validated; bitrate/sample-rate/mode transitions reject explicitly; richer stereo/joint-stereo content remains unverified. | Real silence plus sixteen mono tone frames decode and rewind. Licensed public C 2,048-basis comparison has max difference 9.44472552e-7. Initial full-tail zero-cross frequency test saw 27 crossings in the padded last frame versus 11/12 in steady frames; the frequency assertion now uses a fixed steady interior while all output sample/count/channel/range checks remain. | Review synthesis precision and transition/error contracts, test richer stereo/joint streams and benchmark a verified factorization. |
| MPEG protected audio metadata | Private CRC state preserves canonical Audio layout, adding one captured-allocator node per parsed decoder and linear CAS-protected registry lookup per header/frame. Frame decode requires parsing a header for the exact object; shallow copies/hand-marked headers reject. Manual/copy lifetime policy needs review. | Protected joint frames/rewind pass in both modes; corrupted CRC fails before samples; tracking reports zero live nodes after destruction. Former unsupported-CRC fault is replaced by real checksum corruption coverage. Per-object use/destruction still requires caller synchronization. | Review manual/copy contract, benchmark metadata lookup and optimize registry ownership without changing ABI or bypassing CRC validation. |

Audio development currently exposes a constant-table element pointer lifetime
failure: returned quantizer pointers read overwritten values in both modes.
The original `pending/constant-table-pointer.jai` checks value and storage identity;
no private mutable table copy or canonical public export change is substituted.
The current independent compiler was rebuilt; the direct indexed-address gap
remains. Explicitly taking `*QUANT_TAB` before indexing uses the canonical static
aggregate, preserving pointer identity without a copy or new export; real tone
decoding then passes. Separate pending qualified window/quantizer stores compile
when they should reject modification; unqualified constant-array stores reject
correctly, as does the exported typed scalar. No library-level mutable surrogate
was introduced. Compiler ownership must fix indexed constant lifetime and
qualified aggregate lvalue validation generally. Richer stereo/rate
transitions remain unfinished scope.

Program-stream support is MPEG-1 only, with checked finite PES extents; MPEG-2 and
unbounded packets reject. Counts use system-header bounds rather than sparse stream
probing. Linear seek policies, whole-audio-frame alignment, stream switching and
lead handling need oracle review; no indexed/intra/PTS strategy is claimed. Enabled
but unconsumed streams can grow buffers. End bounds now follow compaction and are
cleared on writes; non-file total_size/resume policy remains unresolved. Bytewise
input, 240-frame refills, borrowed ownership and loop/callback cases pass, with
zero tracked allocations. Remaining richer B/AC/stereo/macro/copy/compiler gaps are explicit.

Original intra-coded B and horizontal AC fixtures now supplement the red I/P clip;
broader inter-predicted B and coefficient cases remain unverified. The B EOF case
fixed a genuine dropped reference without weakening frame-count assertions.
No-delay mode rejects B input explicitly, and the real I/P clip passes that mode.

Nonzero stereo/dual/joint fixtures now verify channel-specific scalefactors.
Shared sample codes are decoded once and scaled per channel; the temporary replay
path used to establish the bug is removed. Initial full-gain fixture produced
1.00748 ringing while preserving quarter gain; fixture scalefactors were reduced
equally to provide headroom, retaining every range/gain assertion. Official FFmpeg
C was consulted only for algorithm coverage/scaling facts, with provenance in
third_party/pl_mpeg/README.md. No code bodies/binaries were incorporated.

Further contract details and risks: [portable gaps](../portable-stdlib-gaps.md),
[Socket ABI ledger](../socket-native-ledger.json),
[SMTP choices](../portable-mail.md), [crash backend](../portable-crash-handler.md).
This record covers the known deviations in the implemented portable scope;
the remaining module ledger is unfinished scope, not a claim of no deviations.

SIMD increment: allocation-free scalar fallback uses Basic scalar min/max (Math exports its own vector overloads). All-ones comparison masks, MSB extraction, integer wrap and scalar FP semantics are explicit pending-review policies; no ISA speed claim. Reviewed load has no return/output contract; load/gather/scatter/looping/horizontal-add exports remain unfinished rather than invented signatures or fake bodies. See [SIMD](../portable-simd.md) for exact scope and tests.

Executable container increment: supported 32-bit archive indexes borrow content/name/data and allocate result arrays; caller must free matching allocator storage. Special members are metadata, second COFF index determines ordering, BSD tries little endian before big; these detailed API policies need review. Thin/64-bit indexes reject, object/debug/text parsers unfinished, missing Arch_File prevents universal records. Basic allocation failure asserts. Current File import prevents Windows checks, so executable-archive is explicitly excluded there without a Windows claim. SDK headers/official native docs only supplied format facts; no implementation copied. Original test harness initially missed empty metadata-array frees; retaining the zero-live assertion identified and fixed both omissions.

Sound_Player increment: only portable records/arithmetic/storage are implemented. Zero inactive channels in returned add, preserved inactive in-place channels, all-eight-lane multiply, checked bounds and little-endian magic reads are explicit policies pending review. Counting public retired_decoders has no new synchronization guarantee. Reviewed arc arrays and accumulator are real shared mutable entities; no device/playback success is claimed. Cached Ogg/platform shapes and remaining lifecycle/mixer/decoder exports remain unfinished, and the Matrix2 helper is delegated numerics coordination rather than duplicate math. See portable-sound-player.md.

MacOS_Bundler increment: XML scalar writer conditionally delegates new Basic formatters; baseline explicitly returns false for float rather than invoking missing formatting support. NEW-foundation stage passes true finite real formatting; basic-context was newly required and added to plist/Meow staging after a genuine missing-module failure. Native macOS tools provide real icon/bundle operations; other host calls diagnose, no backend success is fabricated. Relative option-like bundle names unverified; copy overwrite/symlinks, selected plist fields and Any policies need review. Partial output directories remain on failure; icon staging cleanup is checked, and failed cleanup returns failure even when output exists. All details and actual verification in portable-macos-bundler.md.

File_Watcher integration: NEW macOS bindings have incorrect FSEventStreamContext field order versus the official SDK (version/copyDescription reversed). Retained assertion regression actually fails; peer untouched. Native lifecycle/queue design will use official C SDK aggregates, keeping callbacks in native code and draining on Jai's poll thread. This is a new native implementation dependency and does not fix the public binding defect. Initial macOS staging required Objective_C. See portable-file-watcher.md; no completed watcher execution claim yet.

File_Watcher execution increment: native SDK-owned context/dispatch queue prevents escaped Jai callbacks and avoids the recorded NEW binding aggregate defect without claiming its repair. Actual events pass both modes; ASan/UBSan and owned C/Jai allocation counts pass. Native dylib host architecture/build-tree install name remains packaging work. Canonical paths, trailing-edge merge, per-root byte cap/rescan, combined flag filtering, borrowed callback paths, by-value teardown/reinit policy and rejected callback teardown/reentry need review. Windows/Linux import rejects. Initial original fixture used .. paths and retained an existing file after failure; real canonical MODIFIED/ATTRIBUTES event diagnostics established the test error, fixed setup/expectations without weakening event assertions. Initial library stem syntax corrected; no loader patch. Source default-generic probe passed, so no compiler gap is alleged.

SIMD revised oracle increment: removed earlier unreviewed all-ones/MSB mask policy. Comparisons now convert true/false to lane values and get_mask tests truth, matching the updated reviewed page. Added all previously withheld operations after the oracle supplied load result/byte offsets/index values/pair order. Scalar reductions now use ordinary scalar additions, removing private forced wrapping. Scatter/full-width horizontal add implement reviewed intended semantics while preserving source defects in documentation; no uninitialized results are emulated. Reversed scalar-left noncommutative semantics remain unspecified, with exact symmetric flags retained.

Runtime/CAPS adoption: exact public size workaround removed in favor of the NEW compiler private getter and actual extent tests. Diagnostic allocator-name spelling (Pool and Runtime default allocator) is independent policy pending review; names are static, no copy/lifetime risk. Current NEW dependency staging proves producer behavior, not production distribution. Child fixture initially reused a root setter and suppressed its output; parent-only configuration fixes the harness, retaining all extent assertions and prior failure logs. No peer/compiler special case. Three provisional Performance_Report files are excluded/uncommitted and not completed support; exact paths and interpreter-only evidence in portable-runtime-configuration.md. Audio/tool code and their tests are excluded from formatting mutation by ownership; previously verified tests still run in the full behavioral suite.

Time/calendar increment: uses reviewed FEMTOSECONDS/Unix epoch constants and NEW POSIX ABI, independently truncates binary float fractions, returns invalid for nonfinite/range failures, floors timespec negatives and rejects non-normalized input. Native calendar rejects leap seconds/invalid normalized dates, chooses libc DST ambiguity with tm_isdst=-1 and derives weekday; these fine policies require review. String formats/ConvertToApollo/seconds_since_init and Windows FILETIME remain absent rather than fake. Android implementation branches have no executed target check: CLI rejects -os android. Host timezone state is libc-global. Canonical Basic facade/load overlaps require coordinator merge with foundations. Four additional allocator CAPS names are static independent diagnostic text; required null instance data no longer asserts or locks instance state. Focused family tests pass actual allocation behavior in interpreter/native O0/O2; full 93-case suite verifies preceding time batch before these final CAPS extensions. See portable-time.md and target/allocator-caps-family.log.

Flat_Pool partial core: no guessed reserve default or replacement public initializer. Tests populate canonical fields from real native reservations; this is mechanism verification, not production init support. Global overwrite option unresolved and absent; reset currently honors explicit argument only. Ownership is allocated-prefix (padding included); initialized STARTUP/actual SHUTDOWN and repeat empty teardown are independent policies. Native page-size query per commitment trades overhead for no additional public/private state. Windows/console absent, Android CLI unsupported. Readonly shared source-file mapping produces actual commit failure and is released; initial #filepath directory mapping assertion fixed to #file with assertions retained. Capacity fault initial runner KeyError fixed by explicit exact expectation, no skipped fault. Canonical record ABI/name and actual native O0/O2 verified. Detailed gaps/risks/long-term requirement: reviewed defaults/flag contract, complete initialization and supported backends, in portable-flat-pool.md. Hash_Table duplicate code existed; new coverage corrects stale inventory, no claim of new algorithm completion or Walk_Table support.

Flat_Pool reviewed update: previous missing-default/global-overwrite statements above are historical and superseded. Exact inferred256MiB/module flag, public page-rounded init, lazy get and global OR local reset now implemented. No guessed default/replacement API or missing-init workaround remains. Public behavior fixtures replace manual reservation setup except the supplementary genuine readonly-mapping commit-failure fixture. Independent safety/lifecycle/ownership policies and platform gaps are enumerated in portable-flat-pool.md; full rerun/strict lint pending at this update.

Flat_Pool initialization rerun complete:95 cases/23 faults both modes plus eight rejections and prior integration/target checks pass; dedicated Flat_Pool native O2 passes;293 owned files pass formatting/check/strict lint. Refreshed reserve/default/overwrite gaps are resolved, not remaining blockers. POSIX-host implementation now exercises all reviewed procedures; Windows/console backend and Android target-validation gaps remain.

Windows_Utf8: native code not executed on this macOS worker; x64/ARM64 target checks verify bodies/ABI only, no fake native success. Host fixture explicitly fails if executed outside Windows; --native runner refuses that host. Zero conversion flags delegate malformed replacement to Kernel32, explicit wide length0 fails, oversized input/result lengths reject before narrowing, active allocator owns results; fine policies need review. Actual production dependency is Windows Kernel32 and NEW bindings, not a mocked backend. Proper next gate is actual Windows interpreter/native O0/O2 using the supplied fixture/runner. Initial fixture used invalid block-form push_allocator; corrected to exact expansion-call syntax, no API shortcut. See portable-windows-utf8.md.

Flat_Pool Windows backend increment: private generic virtual-memory operations preserve POSIX calls and add genuine Windows GetSystemInfo/VirtualAlloc/VirtualFree using NEW ABI bindings and official native C documentation. Windows x64/ARM64 full fixture bodies type-check but do not execute on this host. No fake backend or platform pass; actual Windows allocation/failure verification remains coordinator gate. POSIX readonly-mapping failure branch is platform-specific; all ordinary public init/default/overwrite/lifecycle tests now compile for Windows too. Console and Android validation gaps remain, and superseded default questions are edited to resolved status.

FILETIME increment: production private arithmetic is host-executed through exact source loading, while canonical Windows ABI wrappers only type-check both CPUs. This is genuine arithmetic coverage, not a substitute Windows integration pass. Sub100ns fractions truncate, pre1601/invalid/overflow fail; detailed range/rounding policy needs review. Unsigned native DWORD fields are read separately with explicit widened locals (existing compiler narrowing regression remains); no unaligned u64 pointer alias. General Basic unsigned128 division costs128 bit steps per reverse conversion; performance optimization may follow measured correctness. Public Basic facade/load overlap requires coordinator merge with foundations. Proper remaining gate: actual Windows interpreter/native and policy review; no private helper export. See portable-time.md.

Windows clocks: real typed Kernel32 code is type-checked both CPUs, with host-executed exact production counter arithmetic; native Windows calls/frequency-cache concurrency remain unexecuted. No native pass claimed. Cache uses general committed64-bit CAS and boot-fixed frequency; independent arbitrary counter origin and femtosecond truncation need review. GetSystemTimeAsFileTime provides ordinary system resolution; no precision claim. Reverse scaling uses general128-bit division at128 bit steps, a deliberate correctness-first performance cost. Proper long-term gate: actual Windows interpreter/native threaded clock tests and measured optimization; no source/compiler shortcut. seconds_since_init still withheld pending real initialization-origin integration, not replaced with first-query zero. Details/native-doc provenance in portable-time.md.

Machine_X64 remains withheld: source compiler Op::Cpuid hardcodes all outputs0. Both actual interpreter/native reproducer fail; real SDK C query succeeds. This compiler behavior is not counted as CPU detection or wrapped in fake get_cpu_info. Proper generic IR/interpreter/native lowering required across ownership, described in portable-machine-gaps.md. Native focused probe disables crash-handler installation only to isolate CPU assertion; all assertions remain active and existing crash coverage intact. Rdrand/Rdseed opcode conflation and synthetic timestamp-ID docs are additional unverified audit risks, not supported exports.

Elapsed API resolved: the inbox/refreshed Basic page explicitly requires lazy FIRST CALL, so older statements calling that origin a workaround or withholding it are superseded. Exact public seconds_since_init now captures/publishes a real monotonic origin with existing general CAS, subtracts timestamps before float conversion and shares the same private storage across aliases. First return0 is the capture instant; private synchronization strengthens the source's first-use concurrency guarantee. Eight-thread and compile-time/reset fixtures execute genuine behavior, no fake clock/reset hook; the latter uses actual macOS ABI and diagnoses execution on another host rather than claiming portability. Windows clocks/elapsed code type-check but native execution remains a platform gate.


Parameterized Basic fixes: no type-coercion workaround; private Windows arithmetic returns primitive words and wrappers construct their actual module instance's canonical Apollo_Time. NEW foundation composition is staging only, with explicit current facade/load-list merge and normalized regeneration, not production integration. Initial tool substring/stale-kernel failures fixed and retained. Native actions no longer occur only inside discardable assertions. Operational failure callback is unconditional, guarded by context.handling_assertion_failure; if caller continues, invalid timestamps/negative calendar fields/NaN are explicit failure markers. Failed first origin remains unavailable; this error-continuation policy and context guard require review. No native failure-success result invented. Actual Windows calls still unexecuted.

Rebuilt jailint provenance repair: exact owned library bytes must match staged paths under JAIC_STDLIB; tests keep their real app paths. This preserves private-import rejection rather than bypassing it. Old all-input-original-path invocation failed and is retained. Scalar Hash/shared facade belongs to foundations and is excluded from this worker's lint mutation; portable MD5/Meow remain owned and explicitly restored after peer Hash staging (peer MD5 copy differed only by old formatting). No peer write or blanket diagnostic suppression. Final mapped verification pending at this update.

Current mapped verification: full strict lint still fails, not a completed gate.
Exact categories/evidence and proper remedies are in portable-verification.md:
eager Random Context/Socket type checks, enum forward resolution, compile-time
tools, required fixture flags, intentional negative fixtures and workspace hook.
No categories are silently excluded; no allow-incomplete/suppression was added.
Configured time roots pass strict lint separately. Risk: unlinted failed bodies
may hide further findings; proper long-term fix is general compiler/linter and
configured-fixture support plus a reviewed negative-fixture policy. Real Unicode
literal/facade errors were fixed, not reclassified as tool failures. Meow runner
now executes NEW public-contract/vector fixtures rather than the obsolete inherited
test. Full99 host positives/23 faults pass; that does not establish full portable
API completeness or native Windows correctness.

Machine_X64 CPUID blocker is now resolved by the NEW compiler producer. Portable
CPU/feature/options records and three mask operations plus get_cpu_info execute
real CPUID, with independently built C/native O0/O2 comparisons. Missing
instruction macros/get_machine_options_x86 remain explicit per-API gaps; no
synthetic random/timestamp/fence exports are supplied. Raw feature bits and invalid
index assertion are independent policies awaiting fine oracle review. Actual
execution here uses macOS x64 translation, not physical ARM64 CPU information;
Windows/Linux runtime remains unverified. x64 source-built jailint runs pure
CPUID/mask compile-time assertions and strict lint; its initial full file-reading
fixture aborted in SandboxHost. Native C comparisons retain all assertions and
run separately, not counted as linter file-I/O support. Initial Windows body check
failed at existing File's Unix guard; the native-oracle fixture now imports File
only on its supported Unix hosts and explicitly fails runtime elsewhere. Common
CPU/mask bodies still check Windows, without claiming Windows native coverage.
Generator emits explicit independently grouped values, normalizes/checks source
and regenerates identically. Whole strict lint remains failed; architecture-specific
machine checks use an actual source-built x64 linter, never a fabricated target.

Pool checked-extents batch: positive sizes whose private total cannot fit s64
return null before invoking the signed-size allocator; invalid extents no longer
wrap negative. This is independent allocation-safety policy rather than an
asserted reference boundary result. Interpreter/native O0/O2 and focused strict
lint verify genuine failure preservation and cleanup. No mock production allocator
or fabricated success; the test's supplied allocator deliberately returns null
above its budget to exercise failure. USE_UNMAPPING_ALLOCATOR specialization
remains rejected and unfinished pending exact reviewed retention/ownership
contract. Details/risk/evidence and long-term review need: portable-pool.md.

Windows calendar batch: real Kernel32 UTC/local conversions are implemented and
both CPU bodies/configured Basic instances check, but native Windows execution is
unverified. Dynamic-zone Ex APIs require Windows7/Server2012; older support is
unfinished. Private ABI completions take an opaque dynamic-zone pointer that is
always null, never allocated/dereferenced, plus actual NEW SYSTEMTIME pointers
and s32 BOOL result. No peer edit or guessed struct layout. Local ambiguity follows
native selection; gap detection/invalid-date rejection are independent policies
needing review. Pure Gregorian production validation executes a400-year cycle
on host. Focused host strict lint passes but Windows branches are inactive; the
current linter lacks target selection, so active Windows lint is a genuine gap.
Proper long-term gates are target-aware lint support, actual Windows interpreter/
native error/DST testing and reviewed minimum-version/ambiguity policy. No fake
platform constants, native mocks or assertion weakening. Details/native ABI
sources and supported range: portable-time.md.

Machine options projection: resolved using reviewed Compiler.Build_Options
machine_options:[128]u8 and canonical44-byte Machine_Options_X86 shape. Real
#modify struct constraint, byte-array/extent checks and actual reflected alignment
guard precede the in-place pointer cast. No separate storage, snapshot or guessed
field offset. Pointer lifetime is caller-owned; native/interpreter tests verify
two-way edits and trailing bytes. Actual instruction macros remain absent while
compiler fences/random/processor-ID behavior is unsupported. No new workaround
or blanket diagnostic suppression in this batch.

Windows shared-channel backend: actual named mapping/view/extent/status calls
and retryable teardown are implemented; both CPU lifecycle/packet/IPC fixtures
check but native Windows execution and active Windows lint remain pending.
Private failed-construction cleanup retains ownership in a pending retry queue;
future lifecycle calls retry it, while final unrecoverable resources can remain
until process exit. No background retry guarantee. Existing independent framing,
OS-header magic/name/logical-capacity/reconnect policies still need reference
review; no cross-reference wire interoperability claim. Native VirtualQuery
extent replaces guessed page sizes. Registry validation retains existing lock/
linear lookup cost per packet. Windows tests include a genuine protected-handle
close failure with logged status and retry; not executed or mocked on this host.
IPC driver uses cross-platform pipe handshake and real named-object absence
checks on Windows, preserving real POSIX unlink. Full101 host cases/23 faults/14
negatives and four2048-packet process pairings pass, not Windows runtime success.
Proper remaining gate: actual Windows interpreter/native error/lifetime/concurrency
tests and target-aware strict lint. See portable-windows-channel.md.

Windows Socket: real Winsock source paths implemented and both CPU bodies check;
actual Windows/active Windows strict lint remain pending. Pure production ioctl/
descriptor kernels execute host tests, not a simulated Winsock backend. Explicit
u32 locals accommodate the still-failing general widening-cast/shift compiler
semantics; original FIONBIO failure0x8004007e versus SDK0x8004667e and existing
widened-bitwise reproducer remain. Proper long-term fix is general compiler width
propagation, followed by regression rerun; no Native status/instruction is faked.
The generator's wildcard Windows import caused GUI MSG to capture Socket foreign
flags. Explicit qualified reviewed dependencies fix that source namespace defect,
without changing signatures to raw integers. Native keepalive units/ignored
attempt count are reviewed compatibility, not a workaround. Startup refs remain
caller-balanced with WSACleanup. Negative timing inputs diagnose checked casts;
close failure logs then resets the handle, with retry/resource risk awaiting
review. Missing CMSG/bitfield/shape APIs are explicitly inventoried and not counted
complete. See portable-windows-socket.md for locations, evidence and SDK provenance.

Native TCP fields: no new production workaround. Explicit ABI offsets come only from official Apple C declarations and are measured by independent C record output on host/x64. Values truncate to native bitfield width; whole-record comparisons verify neighboring data preservation. Unsupported big-endian/other-platform behavior is not claimed. Source-generated C includes SDK headers, with no header/library body copied. Initial nested fixture used process-relative file path; #file anchoring repairs test staging only, with original failure retained. Active scoped strict lint passes; whole strict lint remains failed. Public CMSG/other field/shape inventory is still incomplete and separately named. Details/evidence/risks: portable-socket-fields.md.

Windows scope-ID: unsigned bitfield truncation is explicit in internal/net/scope-word.jai, not a compiler workaround. Public pure-record #run tests execute on the host interpreter, without native Windows C layout validation. Native Windows and target-aware strict lint remain required; no fake native functions or platform substitution.

Pool lifecycle correction: the previous address-keyed registry was an unnecessary
and incorrect workaround for an overstated first-use policy. The refreshed
review establishes only the allocator-field guard. The registry, C allocation,
CAS lock and address bookkeeping are removed. Reset/release retain the allocator
and options. Genuine returned leak reports now pass without caller changes.
Original failure evidence is retained in target/lifecycle-leak-red.log.

Linux TCP accessors: little-endian current x64/ARM64 only. Cross-target public
#run execution is real interpreter behavior; Linux native and SDK C ABI tests
remain pending, Android APIs are not completed. Initial test-only narrowing/import
errors are retained, corrected without lowering coverage. No target substitution,
native-call emulation, blanket lint exclusion or ABI-layout relaxation.

Pool test platform classification: pool-unmapping depends on currently Unix-only Unmapping_Allocator. Added that fixture to the existing explicit Unix target-check list after the real Windows availability diagnostic (target/pool-policy-full2.log). Host interpreter/native assertions and Linux checking remain required; no Windows pass or completed Windows unmapping backend is claimed.

Calendar policy adoption: removed this producer's stricter POSIX round-trip
validation and Windows local DST round-trip rejection; refreshed specs delegate
to native normalization/rules. Changed POSIX -1 result to zero, output error to
ERROR log plus zero record, Windows input failures to assertion handling. These
are production compatibility fixes, with old policy-test corrections separately
recorded in portable-time.md. Continuing Windows assertion handlers get explicit
invalid sentinel, not a valid fabricated timestamp. Native Windows pending.

Calendar text uses a128-byte private bounded scratch buffer and real temporary
copy. All public fields fit this bound; decimal padding/English month names are
private calendar responsibilities, not duplicate public formatter APIs. An
initial minimum-length test oracle was wrong for May; replaced with exact twelve
reviewed English outputs, failure logs preserved. ConvertToApollo is NOT exported:
the exact reviewed no-result header cannot currently yield a value in the compiler.
Minimal original language reproducer is pending/expand-return-inference.jai;
do not classify its failed check as completed functionality or silently add an
unreviewed return annotation. Remaining native/target-lint gates are unchanged.

Windows Registry:23 real reviewed bindings implemented, ten pseudo-handles omitted
because reviewed positive casts conflict with official signed-LONG64-bit SDK
extension. No guessed ABI constants or extra public convenience exports.
All seven native call bodies/source constants check both Windows CPUs; actual
interpreter/native Windows execution and active target-aware strict lint pending.
Fixture uses private SDK setup only, a PID-specific volatile HKCU Software test
key, checked native statuses and explicit cleanup; abort can leave this test-only
key until cleanup/reboot. It never reads unrelated registry/credential data.
Initial UTF conversion return-shape error belongs to the fixture and is fixed
using reviewed pointer/success/byte-count, without changing production APIs.
Generated declarations are normalized/idempotent; no copied Jai bodies.

Android TCP accessors share actual tested Linux bodies only after official bionic
public C header verification.22 reviewed Android exports, four Linux-only scales
remain conditional, no invented Android APIs. Actual header C layout probes pass
host ARM64/translated x64; these are NOT Android runtime/SDK execution. Compiler
rejects -os android, so Android body/native validation remains blocked. No target
constant overrides or fake backend. Old Linux-only implementation/facade files
are removed. Public-header SHA/provenance and initial manual include-path staging
error are documented in portable-socket-fields.md; no assertions skipped.

Ancillary helpers: four real functions match native SDK vectors, CMSG_SIZE omitted
pending exact relationship to native SPACE/LEN. CMSG_ALIGN uses native macOS4/
Linux-Android64-bit8 boundary, not a universal guessed pointer-size rule. Negative
sizes and unrepresentable alignment/u32 result diagnose; this is an independent
safety policy for unspecified invalid inputs, not claimed reference wrapping.
Live-record/control-storage preconditions remain with caller. Native Linux/
Android still pending despite Linux pure #run execution. Initial signed/unsigned
test mismatch fixed by explicit boundary conversions; no signature/assertion
change. No copied Jai bodies, fake kernel calls or test/lint suppressions.

Android JNI ABI helper: static immutable native directory strings for the only
reviewed real CPU targets X64/ARM64. Other tags diagnose explicitly; fine
invalid-tag behavior remains independent. This is host tooling functionality,
not evidence of an Android backend/device integration. No ADB/auth/credential
action executed. Parent Android bindings untouched; formatting ownership exception
is scoped only to Android/Toolchain, not a lint suppression. All other toolchain
APIs remain missing, now explicitly listed with other untouched portable modules
in portable-missing-surface.md (253 rows, no functionality credited).

Watcher native ownership fix: close_v2 distinguishes actual error code from
released/retained object, prevents ABI mismatch with stale helpers, and retains
Jai state for retry only when real resources remain. Native operations execute
outside optional assertions. Stopping instances reject polling/additions; callers
must retry deinit after a reported retained failure. No background cleanup
guarantee; never retrying can retain resources until process exit. Registration
metadata is reserved first and recycled on failure, avoiding untracked native
objects and unbounded failed-registration arena growth. Existing event behavior
is retained.

Verification limits: actual SDK EBUSY retention/retry and real SDK EDEADLK seeded
into the private native error channel are C mechanism tests under ASan/UBSan,
not fabricated public FSEvents outcomes. Public event/diagnostic programs execute
host ARM64/translated x64 O0/O2; failed native Jai teardown is not directly forced
through the public surface. Source review covers its retained/released state
branches. Native source helper remains a required build/deployment dependency;
universal slices are real and no binary is committed. Binding Context ABI defect,
Linux/Windows backends and full integrated CI remain separate gaps.

Staging corrections: nonexistent one-argument Basic pointer conversion was an
owned source defect, fixed with native string view without API additions.
Default generic pointer inference is a real compiler gap; original Box reproducer
preserved, explicit specialization used only in new fixture. Test's assumed
pre-callback handling flag was an incorrect oracle; removed that unsupported
assumption while preserving six decisive lifetime/error checks and context
restoration. Verification checks restore the fatal handler so captured assertions
cannot yield false passes; draft never counted green. Normal formatter repair
and failure logs retained. Details: portable-file-watcher.md.

Machine pause: real compiler native instruction wrapped with exact #expand header;
native opcode/C intrinsic/baseline checks pass O0/O2. Interpreter is cooperative
hint emulation and may be a no-op in single-thread execution. This models a hint,
not physical CPU delay or memory ordering; no timing/ordering success is fabricated.
No random/timestamp/fence fallbacks exposed. Native prefetch/fence original probes
compile/run but emit0 requested instructions versus C1 each; dedicated dependency
tool FAILS and those public APIs stay absent. Fine compiler semantics remain owner
work, never hidden by module-specific hacks.

Pause baseline lint initially flagged unused import. Both controlled fixtures now
assert the same reviewed canonical record size, preserving import/control parity
without blanket exclusions. Runner diagnostics now retain captured output on
failure. Original logs retained. Target-aware/all-owned lint remains failed.

Android OID identity: canonical inline twelve-arc record, counted-prefix equality,
exact Sun initializer and immutable typed JKS constants implemented. Invalid
counts diagnose rather than indexing outside storage; fine invalid-input policy
is independent. Qualified constant writes reject and local copies are independent.
No ASN.1/JKS decoding/signing success is claimed. Both JKS constants preserve the
reviewed numeric0xfeedfeed, while the review's byte-swap rationale is flagged as
mathematically wrong (actual byte reversal0xedfeedfe). No guessed alternate
constant, key/device/auth access or fake crypto behavior. Remaining API inventory
drops only these five implemented declarations, from253 to248 rows.

Unix Thread critical correction: all owned essential SDK operations are evaluated
outside optional assertions. Failures log independently; failed Mach destruction
retains the handle, failed join retains worker storage, private teardown flags
permit join/semaphore cleanup retry. Public layouts remain exact. Thread object
address stability is already required by its reviewed lifecycle, unlike Pool.
No relocation tracking was added. Native invalid-task Mach failure retention
executes; invalid pthread handles are never used for artificial failure tests.

Explicit conservative error policies: group worker-creation failure and group
clock failure terminate after diagnostics, including when assertions are disabled.
The void APIs cannot provide a usable partial group or an invented clock. Live
worker storage remains until OS teardown. This is a deliberate fatal policy for
unspecified fault paths, not tested transactional recovery; proper long-term
improvement is recoverable staged group initialization/cleanup with retained
progress. Work-list partial-destruction retry remains an existing gap. Join failure
now prevents freeing the whole worker backing array. Native Linux/Android/Windows
execution, forced join failure and full integrated CI are not counted complete.

Verification staging: only target/ default Basic parameter lists are changed to
test Thread default instances; caller-only false configuration does not disable
Thread. Peer implementations and original audio/foundations fixtures are read-only.
New test checks use enabled assertions and restore fatal handler after captured
errors. Draft locked-mutex EBUSY oracle was invalid POSIX misuse and returned
success; removed in favor of genuine Mach failure, with original evidence retained.
Draft assertion callback type and Darwin cross-target CLI spelling were corrected
without production API changes or weakening valid checks. See portable-thread-lifecycles.md.

Group fatal path initially referenced Basic.exit, absent from this producer's
baseline facade despite existing in NEW foundations. Broad regression caught it;
the private native boundary now binds official libc abort directly. No public
foundation export is added and no failure result is invented. The original broad
failure is target/lifecycle-full.log; corrected broad run passes112 cases,
including the preserved uncommitted digest fixture.

Machine ISA handoff supersedes the earlier missing/fake compiler-instruction
entries for the eight reviewed APIs. Real timestamp/AUX, RNG carry/value, fences
and prefetch bodies now use the general compiler assembler; no C production shim,
wall-clock/random substitution or forced success. Actual CPUID on this translated
x64 environment lacks RDRAND/RDSEED. Opcodes and actual interpreter capability
errors pass; native hardware RNG sample/CF execution is pending capable CI.
Timestamp/AUX exact cross-SDK tests are compiler-owner evidence, not independently
repeated public-wrapper evidence. Native Windows/Linux remains unexecuted.
Public prefetch invalid compile-time hints diagnose explicitly. The forty-four-byte
options projection and all prior canonical feature types remain unchanged.

Digest batch: scalar SHA-1/SHA-256 uses no native acceleration and bounded local
word schedules; this is a deliberate portable performance choice, not a reduced
algorithm. Only compression arithmetic uses #no_aoc for required modulo2^32
additions. Standard mathematical constants are private immutable arrays. Valid
readable strings hash completely; invalid length always logs independently of
optional assertions, then asserts. Disabled/explicitly continuing assertions yield
a zero array after the error; no invalid-input digest success is claimed or
reviewed. No streaming API, signing, key management or native crypto exports
are fabricated. Actual native hashlib vectors are independent test oracles only.
Tests execute unaligned/NUL/padding boundaries and million-a, both native CPUs
O0/O2 and interpreter. Native Linux/Windows/Android execution remains pending.

ConvertToApollo: previous compiler-gap report was based on an ordinary macro
value-expression probe, which does not represent the refreshed caller-return
contract. That mistaken oracle is now explicitly superseded; original source
and failure evidence retained. Exact no-result macro header is preserved.
Private signed product corrections use existing full-width multiply and #no_aoc
only for modular high-word corrections; no fake arithmetic, inferred arrow,
compiler hack or public helper export. Both producer compositions execute
interpreter/ARM64+x64 native O0/O2. Further floating rounding/calendar policy and
native platform gates remain separate; no new workaround introduced.

Registry candidate is NOT completed: six owned files are deliberately left
uncommitted/excluded pending general opaque pointer-constant freezing. Exact
paths and failing evidence are in portable-opaque-pointer-constants.md. Public
reviewed zero-extension is preserved; no sign-extension, mutable global, wrapper
function, fake handle, whitelist or ignored test is substituted. Source checks
and target-aware lint are blocked before native execution. Compiler source cause
is the existing small-or-negative integer-handle heuristic; proper solution tracks
opaque address bits versus memory requiring freezing/relocation. The unchanged
committed23-export implementation remains the last verified checkpoint; the
working candidate33-export source is explicitly unverified. No native Windows
handle acceptance is claimed. Formatting/byte-stable generation alone is not
functional completion.

System raw counter adds no synthetic fallback: x64 RDTSC and Unix
CLOCK_MONOTONIC_RAW.tv_nsec follow reviewed CPU-first selection. The Unix member
wraps each second by contract; not represented as monotonic whole time or physical
CPU cycles. Clock failure logs independently, then optional assertion; a disabled
or explicitly continuing handler receives zero after diagnostics, not a counted
valid sample. Native Linux/Android and peer Windows remain verification/ownership
gaps. The new test is explicitly Unix-only for Windows target scope; every host
assertion and Linux source check remains. Existing System test is unchanged.
No blanket suppression or target constant substitution.

Ownership metadata update only: latest resource/data split moves five modules
and55 missing rows to the data worker.191 current retained missing rows do not
mean those55 APIs were implemented. No code overlap/pending source existed in
those modules; mutation/format scopes exclude their public/private/test names.
Coordinator will merge new producer sources and exact private-root ownership
when supplied; no other checkout was read or written for this update.

ADB first batch: native C CLI fixture models official SDK protocol strictly for
unit/process/argv/error/parser/ownership regression, not an Android SDK binary
or device verification substitute. No actual SDK found on PATH; no device/daemon/
auth accessed. Independent finer policies: context-owned return strings/array;
explicit nonempty serial wins; optional generic escaping only spaces; high-level
remote literal quoting; disable compression wins; malformed parse rejects and
pidof returns the first positive signed32 PID. These remain precise questions
where review is silent. No public convenience exports added. Windows Process
remains unintegrated for ADB; the dependency is local to adb so digests/types
retain Windows use. Original dependency/indexing/lint failures are retained.
No test assertions were weakened, invalid SDK/device results manufactured or
errors mapped to success. Registry candidates remain excluded until compiler
rebuild and original-probe validation.

Registry pointer workaround remains NONE: general compiler fix is rebuilt and
original probes pass; public immutable positive values now validate on both
Windows CPU targets. No whitelist, mutable surrogate, function replacement or
sign extension. Native acceptance is still pending actual Windows. The new
linter correctly rejected producer paths outside JAIC_STDLIB; byte-identical
staged paths fix tool setup without changing capabilities or public imports.
Intentional constant-write negative is compiler-rejection coverage, not a
lint-positive claim. Earlier uncommitted/blocker notes are historical; six
candidates now pass source/strict-lint gates and are checkpoint-ready.

ASN.1 primitive supported-domain limits: definite lengths with at most eight
length octets, u8 tag numbers, s64 INTEGER results and twelve u64 OID arcs.
Indefinite/overflow/excess/truncated values log and assert; explicitly continuing
or disabled assertions return non-success defaults and retain input cursor.
Those invalid defaults are never counted as parsed functionality. Signed INTEGER
redundant sign bytes are trimmed; invalid-recovery/noncanonical policy needs
review. Binary integer reading supports reflected integer widths1/2/4/8 on the
current little-endian compiler targets; broader generic kinds remain unsupported.
OID dotted strings are context-owned. Field meaning/printing/prefix/endian finer
questions remain recorded, so their API bodies are not invented. Standard wire/
Python mathematical vectors are independent test inputs, not reference Jai code.
No C/native crypto dependency, caller relocation tracking, mutable alias surrogate,
blanket lint exclusion or fake parsing success. All negative checks restore fatal
handlers before verification.

ADB app lifecycle: no installed SDK/device is available. Source-built process
protocol fixtures validate argv/status/parser/ownership on host native O0/O2 and
interpreter; they are not device integration. Narrow pidof status1+empty capture
means absent, other failures remain errors; package path responses require
package:/ prefixes. These supported choices need public fine-policy review.
Risk: future SDK output/status changes may require parser adjustment; proper
follow-up is SDK/device CI plus reviewed failure-policy clarification, not treating
arbitrary command errors as successful absence. No fake SDK success or test
exclusions added. See docs/portable-adb.md and target/adb-apps-final.log.
