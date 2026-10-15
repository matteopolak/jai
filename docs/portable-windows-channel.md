# Windows shared-memory channel backend

The facade loads canonical conditional HANDLE records and a common SPSC ring.
OS lifecycle is independently separated into channel-posix.jai and
channel-windows.jai. Private registry/framing helpers have module visibility and
are not public exports. POSIX behavior remains exercised in interpreter/native
and four process pairings; it was not replaced by a Windows-specific protocol.

| Public API | Windows implementation |
| --- | --- |
| reader_create_channel; reader_create_channel_os_specific | UTF-16 named paging-file mapping, duplicate-name rejection, full view mapping and actual native extent query, initialized header published last |
| writer_connect | Opens/maps the named object, checks native view extent/header/status, atomically claims the single writer |
| writer_disconnect; reader_release_channel | Publishes disconnected status, unmaps and closes native resources; failed cleanup remains registered for retry |
| writer_reserve_message; writer_commit_message | Shared actual contiguous packet/framing/wrap/full/CAS publication algorithm |
| reader_poll_for_message; reader_done_with_message | Shared checked framing/cursor validation and CAS completion |
| get_message_queue_header | Reviewed offset into the mapped header |

CreateFileMappingW/OpenFileMappingW/MapViewOfFile/VirtualQuery/UnmapViewOfFile and
CloseHandle are real NEW Windows bindings. SetLastError is a private official-ABI
completion, clearing the thread error before duplicate detection. UTF-8 names use
the actual Windows_Utf8 converter and captured registry allocation. Native name
namespace/security restrictions apply; no permission elevation or global-namespace
fallback is attempted. A duplicate creator closes only its newly opened handle
and never overwrites the existing object. Windows object lifetime follows native
handle/view references; there is no invented unlink operation.

Native query extent is recorded in the header/registry, with logical packet
capacity determined by the requested bytes. No fixed page size or fake mapping
size is substituted. Unmap/close successes clear their respective public fields.
On partial failure, the remaining resources and updated ownership record persist
for a subsequent teardown call; the operation reports false and logs the error.
Creation/connect failure attempts actual cleanup. Failed native cleanup retains
its captured ownership record in a separate private pending queue; subsequent
create/connect/release operations retry it. No failed handle/view is forgotten or
reported successfully released. If no subsequent call occurs, unreleased native
resources remain until process exit; there is no background retry guarantee.

Reviewed constants/record layouts remain exact. The existing independent framing,
OS-header magic value, status/reconnect, name and logical-capacity policies are
still policy-review questions; no reference cross-library wire compatibility is
claimed. Full reference interoperable behavior is not inferred from native SDKs.

The Windows fixture checks missing/duplicate names, duplicate writers, actual
mapping handles,2048 variable-size packets/wraps, reconnect, reader shutdown,
writer refusal afterward and name reuse after complete teardown. A real protected
handle intentionally makes CloseHandle fail, checking logged failure, retained
public handle and successful retry after clearing the native protection flag.
That assertion is preserved for actual Windows CI, not replaced by a mock.
Both Windows
CPU bodies check, including portable IPC reader/writer fixtures. No Windows call
has executed on this macOS host. tools/check_portable_windows_channel.py --native
requires Windows and executes interpreter/native O0/O2 and all four interprocess
pairings. Missing runtime/active Windows lint gates remain explicit.

The generic IPC driver now uses a queue/thread pipe handshake supported on both
hosts. Unix journal cleanup remains real shm_unlink. Windows cleanup verifies
that the named mapping is absent after child exit using real Kernel32 calls;
remaining named objects fail the check. No test failure is silently ignored.
The updated IPC fixtures call actual sched_yield/Sleep(0) outside assertions.

Official native C ABI/lifetime documentation:
[CreateFileMappingW](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-createfilemappingw),
[MapViewOfFile](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-mapviewoffile),
[VirtualQuery](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualquery).
These establish SDK facts only; reviewed docs/specs establish the Jai interface.
