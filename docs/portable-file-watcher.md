# File watcher implementation

The reviewed public macOS layout and lifecycle are implemented with a
backend using SDK-native FSEvents state and a bounded native event queue.
Framework callbacks stay in C; Jai drains actual events and performs coalescing
and user callbacks on the polling thread. This prevents native callbacks from
holding interpreter procedures after their lifetime. Public event-stream entries
remain actual canonical macOS FSEventStreamRef handles. Generic user data and
the exact unparameterized `process_changes` header work without API adaptation.

Integration found a genuine ABI defect in the NEW bindings input:
`macOS.FSEventStreamContext` currently orders copyDescription first and version
last, whereas the installed official FSEvents.h places version at offset 0 and
copyDescription at offset 32 (64-bit layout). The middle info/retain/release
fields have offsets 8/16/24. The original focused regression is retained in
`tests/portable-stdlib/pending/macos-fsevent-context-abi.jai`; it fails its first
field assertion in the interpreter. Initial staging also needed the NEW
Objective_C dependency. No peer source was modified and no assertion was relaxed.

The proper binding fix is to preserve official aggregate field order. Watcher
native lifecycle/queue internals construct SDK aggregates in C rather than
depending on the incorrect declaration or accidentally equivalent zero values.
The native bridge is an implementation dependency, not a replacement public
binding or a claim that the binding defect is resolved. Windows/Linux backends
remain unfinished and diagnose on import; they are not counted as supported.

Initialization captures the backing allocator. Real Pool storage owns root
bookkeeping; state, pending paths and arrays use the captured allocator even if
polling/deinitialization occurs under a different context allocator. Native
directories are canonicalized and checked before registration. Registration
failure returns false and retains earlier successful registrations. Keep the
watcher at a stable address and serialize operations on each instance. Native
framework callbacks never invoke Jai; only polling invokes the current public
callback and current user-data pointer.

Pending events with the same canonical path merge their flags and reset a private
f64 deadline. Public timestamps do not drive timing, so their scalar precision
cannot prematurely expire a deadline. The callback borrows a path until it returns;
delivered path allocations are then freed. The event array is compacted in place.
Changes/events arrays remain bookkeeping; external queue edits diagnose if they
break metadata counts. Recursive polling and deinitialization from callbacks
are rejected. The reviewed deinitializer takes the watcher by value, so it cannot
clear the caller's copy: reset that copy before reinitializing, and never reuse
its destroyed storage. These detailed lifetime/reentrancy policies need review.

The native buffer limit counts queue nodes plus pathname storage for each
registered root. Overflow reports a real root rescan notification; it never
pretends lost individual events were recovered. Native failures propagate as
checked diagnostics. SDK-native event classification includes extended attributes,
root/volume changes and dropped events. macOS rename notifications map to MOVED;
separate MOVED_FROM/MOVED_TO pairing is not promised by this backend. Event filters
admit matching events while retaining their combined flags. A nonrecursive watcher
filters nested paths, with root rescan notifications retained. Exact filters,
buffer interpretation, timestamp epoch, trailing-edge debounce, wait hints and
path/partial-registration policies remain compatibility questions.

`tools/build_portable_watcher.py` builds the original native C implementation with
warnings treated as errors. The dynamic library currently has a build-tree install
name and host architecture; production relocation/cross-architecture packaging
requires coordinator integration. `tools/check_portable_watcher.py` stages only
our sources and NEW bindings in our target directory, then checks real events in
interpreter/native execution: create/modify/remove/rename, typed/coalesced callbacks,
recursive filtering, bounded-queue rescan and zero outstanding Jai allocations.
It also executes the exact native backend under ASan/UBSan with tracked owned C
allocations, including overflow and failed registration. This does not claim
instrumentation of allocations internal to Apple's frameworks.

Initial runtime testing failed on a test path containing `..` and an existing
file left by that failure. Actual diagnostics showed canonical MODIFIED/ATTRIBUTES
events. Tests now clean only their known original fixture directory and normalize
expected paths, retaining create/modify/remove assertions. An initial library
specifier included an extension despite the compiler's source-relative stem
syntax; that was corrected without changing the loader. No general default-generic
pointer compiler gap was found; typed dispatch is executed by genuine event tests.

Native API facts follow Apple's official
[FSEvents guide](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html)
and the installed public SDK headers. No other Jai implementation is used.

## Native close ownership and continuing-handler safety

The private native close protocol now returns an actual POSIX error code and a
separate released flag. The symbol is portable_watch_close_v2; the old symbol is
removed. A stale helper must fail symbol resolution rather than accidentally
calling an incompatible C prototype. Rebuild the source helper with
tools/build_portable_watcher.py; it now contains real arm64/x86_64 slices.

pthread_mutex_destroy failure retains the closed native Watch and sets released=0;
a later retry can finish. Prior queue error can be reported after successful
destruction/free with released=1. Jai clears only released handles and retains
the registry, pool and pending paths when any native object remains. Poll/add
diagnose a stopping watcher; deinit permits a later retry and guards recursive
teardown. After all native objects are released, metadata is unregistered before
user allocator cleanup. Every native error is logged without allocating a
diagnostic string; optional assertion handling cannot remove the close syscall.

Root metadata is reserved before acquiring a native stream, so allocation failure
cannot create an unrecorded native object. Failed registrations recycle that
metadata through a private spare list.4097 actual attempts to register a regular
file as a directory report failure without growing retained allocator counts
after the first reserved slot; teardown reaches zero captured live allocations.
No public Pool layout or watcher signature changes.

Queue/clock errors now report and return no change/no wait, rather than letting a
continuing assertion handler fall into repeated failed polling or fake events.
Null/uninitialized/stale lifecycle calls also stop after diagnosis. New public
diagnostic regression checks six genuine invalid operations and successful fresh
reuse after resetting the caller's consumed by-value watcher record. Verification
uses the original fatal assertion handler; captured diagnostics cannot swallow
the test's own failed checks. Existing event assertions remain unchanged.

Native tests induce actual SDK EBUSY with a locked mutex after draining real
FSEvents callbacks, prove released=0 and retry to zero tracked C allocations.
They also feed the native error channel a real EDEADLK obtained from an SDK
error-checking mutex, proving error-after-free/released=1. This second case is
explicit private-protocol fault injection, not a claim that public FSEvents
naturally produced EDEADLK. The tests include our own backend source to exercise
its private ABI; they are mechanism/safety tests, not a reference public API oracle.
ASan/UBSan and owned-allocation tracking pass. Apple-framework allocations are
not included in that counter.

Actual public event and diagnostic fixtures pass interpreter plus host ARM64 and
translated x64 native O0/O2. The universal library and translated binaries were
checked as actual Mach-O architectures. Passing evidence:
target/watcher-close-reuse-matrix.log; focused strict lint and final formatter
status are recorded in the progress/verification docs. Native Linux/Windows and
public failed-teardown forcing remain pending; C ownership failure branches are
executed, while Jai retry-state handling has source review and normal/continuing-
handler execution, without a fabricated foreign close result.

Failure triage and test repairs are separate:
- An initial source edit called nonexistent Basic.to_string(*u8). Reviewed Basic
requires a length; corrected the owned logging code to use a direct native
NUL-terminated string view. No convenience export was added. Failure:
target/watcher-close-verified.log.
- A default generic pointee type fails the general compiler constraint. Minimal
original reproducer pending/default-generic-pointer-constraint.jai fails with
Box is not an instance of Box; explicit Box(void) specialization is supported.
Diagnostic fixture uses the explicit public specialization; existing default
value declarations in the event fixture remain. Public headers are unchanged.
- Initial test assumed Basic sets handling_assertion_failure before a replaced
assertion callback, which the reviewed contract does not guarantee. Corrected
that test oracle to check actual invocation/nonempty diagnostic and final context
state; all six lifetime safety checks remain decisive. Failure:
target/watcher-close-diagnostics-focused.log. No Basic/Foundation behavior changed.
- Verification callbacks now temporarily restore the original fatal handler for
each check. The initial draft was corrected before any passing result was counted.
A routine post-edit format check also failed and was normalized with source-built
jaifmt; failure and final logs remain under target/watcher-close-*.
