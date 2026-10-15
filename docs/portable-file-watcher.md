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
