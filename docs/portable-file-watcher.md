# File watcher implementation work

The reviewed public layout and lifecycle will be retained. Work begins with a
macOS backend using SDK-native FSEvents state and a bounded native event queue.
Framework callbacks stay in C; Jai drains actual events and performs coalescing
and user callbacks on the polling thread. This prevents native callbacks from
holding interpreter procedures after their lifetime. Public event-stream entries
will remain actual canonical macOS FSEventStreamRef handles.

Integration found a genuine ABI defect in the NEW bindings input:
`macOS.FSEventStreamContext` currently orders copyDescription first and version
last, whereas the installed official FSEvents.h places version at offset 0 and
copyDescription at offset 32 (64-bit layout). The middle info/retain/release
fields have offsets 8/16/24. The original focused regression is retained in
`tests/portable-stdlib/pending/macos-fsevent-context-abi.jai`; it fails its first
field assertion in the interpreter. Initial staging also needed the NEW
Objective_C dependency. No peer source was modified and no assertion was relaxed.

The proper binding fix is to preserve official aggregate field order. Watcher
native lifecycle/queue internals will construct SDK aggregates in C rather than
depending on the incorrect declaration or accidentally equivalent zero values.
The native bridge is an implementation dependency, not a replacement public
binding or a claim that the binding defect is resolved. Windows/Linux backends,
generic process_changes semantics and detailed coalescing/path lifetime policy
remain work; no watcher functionality has passed execution yet.

Native API facts follow Apple's official
[FSEvents guide](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html)
and the installed public SDK headers. No other Jai implementation is used.
