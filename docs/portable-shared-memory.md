# Native shared-memory channels

The public module loads canonical records and reviewed constants; no private
registry/helper is exported. The Unix backend creates exclusive named POSIX
objects, maps them read/write and records mapping extent, descriptor, creator
allocator and name in a private synchronized ownership registry. Reader release
unlinks its own name; writer disconnect never unlinks the reader's object.
Duplicate reader creation and duplicate writer connection fail without destroying
the existing channel. Windows now has a real named mapping backend; native Windows
execution remains unverified, as detailed below.

Creation publishes initialized header magic last. Queue cursors and statuses
use the compiler's real sequentially consistent compare-and-swap, including in
the interpreter; its implementation accesses native atomic storage rather than a
VM-local lock. This avoids missing load/store intrinsic lowering without replacing
any public alias. Each channel requires one reader, one writer and at most one
pending reservation/read packet per side.

Reservation exposes contiguous payload storage; commit publishes it after filling.
Poll validates framing before returning a borrowed view, and completion releases
the occupied span. A tail marker handles wrapping; a short tail is skipped without
reading a nonexistent frame. If a maximum-size packet cannot coexist with its wrap
gap, reservation publishes only the wrap notification and returns false. The
reader consumes that metadata without reporting a user packet, allowing a later
reservation. Full queues return false, corrupt header/cursor/frame state produces
a fatal poll result, and signed cursor overflow is rejected.

Native ownership uses the backing extent reported by fstat. macOS rounds a
512-byte request to a 16 KiB shared object on the test host; assuming fstat would
return 512 incorrectly rejected writers. Queue capacity remains based on requested
logical size; mappings and destruction use native extent. Destruction uses
captured extent/descriptors rather than mutable wire fields. Metadata is freed
through its creator allocator even when the active allocator changes. OS cleanup
results are checked; false destruction can represent partial cleanup and does
not promise retryable channel state.

Wire choices absent from the reviewed prose require review before reference
interoperability can be claimed: bytes denotes full logical region size; payload
capacity is rounded down to eight bytes after offset 256; cursors/packet offsets
are absolute byte positions; frame header is the supplied eight-byte message
magic followed by u64 payload length; total_bytes includes the 16-byte overhead
and eight-byte alignment padding; OS-specific magic repeats channel magic. Empty
messages work. A name without leading slash is normalized to POSIX form. Pause/
reconnect policies beyond tested single-owner lifecycle remain unresolved. Our
round trips do not establish interchange compatibility with an unprovided original.

Local tests verify unpublished reservations, varied bytes, full-buffer draining,
wrapping/max-size packets, corruption, duplicate instances and captured allocator
cleanup. Separate source-built processes transfer 2,048 ordered byte-checked
messages in all four native/interpreter pairings. Linux x64/arm64 is compile-checked;
Linux native execution remains unverified.

The target journal records only test-owned names. The process runner unlinks
exactly those recorded names after completion/failure; it never scans the global
namespace. Two early assertion-failing runs before journaling created PID-named
objects and did not reach release; their names were not captured. No broad deletion
was attempted. This historical cleanup limitation is recorded rather than claiming
a clean global namespace. Production callers must release channels; abrupt process
death can leave POSIX names behind.
