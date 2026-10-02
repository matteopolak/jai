# Files, processes, and OS services

## What it is

These repository-authored modules implement file streams, directory traversal and lexical paths, child processes, clocks and OS queries, asynchronous file requests, filesystem change coalescing, clipboard transfers, SMTP messages, and a shared-memory channel. Public contracts prefer the maintained OpenJai API; supplied declarations fill gaps where that source has no counterpart.

OpenJai's pinned File/Process bodies are compatibility placeholders. They establish names and return shapes, not successful execution. This implementation does not retain their fixed success/failure answers or load any supplied compiler/native artifact.

## How it works

`File` stores the maintained `s64` handle and converts it to the selected SDK stream or Windows handle at the call boundary. Reads and writes loop through partial transfers. A whole-file read checks length, seeks to the start, allocates exactly the result, and releases it on failure. Recursive deletion uses directory entries and avoids descending through symbolic links. Windows mapping uses real file-mapping handles; other targets implement `map_entire_file_start` through an owned read buffer.

Return-shape conflicts have explicit alternatives. `file_length(file)` returns a length, with `-1` on failure; `file_length_checked` returns length/success. `file_read(file, *u8, count)` requires the entire requested range; `file_read_checked` also reports a short EOF read. `file_close` returns success and invalidates its descriptor. `read_entire_file(path, log_errors)` follows the maintained argument order; `read_entire_file_terminated` exposes the supplied zero-termination option. `File_Visit_Info` retains the maintained three fields. `File_Utilities.File_Visit_Details` and `visit_files_detailed` expose metadata and symlink controls from the supplied surface.

Directory traversal checks file identities when copying a file onto itself and tracks canonical visited directory paths to stop symlink loops. Callback names are transient. A callback can prevent descent. `file_list` retains its array-only result, so a failed traversal can produce a partial list; use `visit_files` when failure must be reported.

`Process.run_command(command, capture)` returns the maintained numeric exit code/stdout/stderr/timeout tuple. It tokenizes quoted arguments and invokes the executable directly; operators such as `|` are literal arguments. The string-array overload returns `Process_Result`; `run_command_arguments` retains the supplied variadic form under an explicit name. POSIX launch uses a close-on-exec error pipe to distinguish an exec failure from a program exiting with 127. Captured descriptors are moved above standard descriptors before duplication. Reads wait for stdout and stderr together, timeout calculations use a monotonic clock, children are reaped, and a pipe write temporarily blocks and consumes its own SIGPIPE. Windows uses SDK processes, pipes, and a job for parent lifetime cleanup.

`Basic/platform-time.jai` deliberately has no module imports: Basic is a dependency of the full POSIX/Windows declarations, so importing those modules from Basic creates a cycle. The clock bridge declares only the system clock, sleep, errno, and exit ABI it needs. Apollo arithmetic remains in Basic. `seconds_since_init` publishes its first monotonic nanosecond sample with compare-and-swap. System executable/directory/user/error queries use SDK calls. Processor topology uses Windows core records, macOS sysctl, and Linux sibling lists; Linux performance queries currently include every online CPU class.

`File_Async` uses one real worker thread per queue, a bounded FIFO submission ledger, and separate submission/completion condition variables. File close waits for its pending requests; destruction drains queued work, joins the worker, closes remaining files, and frees uncollected owned read results. User buffers stay borrowed until completion; an entire-file read transfers ownership to the caller using the allocator captured when creating the queue. This is asynchronous thread-backed execution, not an io_uring or IOCP implementation. Its queue/file internals differ from the supplied platform implementations.

`File_Watcher` compares directory snapshots and merges repeated changes until the configured quiet interval expires. It generates ADDED, MODIFIED, and REMOVED from size/modtime comparisons. This polling backend can miss short-lived changes and does not identify native move or attribute-only events. A failed scan preserves the previous snapshot and sets `scan_failed`. Serialize calls and avoid destroying a watcher from its callback. Prefer the pointer `deinit` overload, which clears state; the supplied value form is a one-shot release.

Clipboard text uses Windows Unicode clipboard memory, macOS AppKit messages with an autorelease pool, or Linux `wl-copy`/`wl-paste` with `xclip` fallback. Bitmap transfers build a checked, padded 24-bit DIB/BMP and convert RGB(A) bytes to BGR; alpha is currently discarded. Linux requires a corresponding running display session and helper executable. The supplied Linux window-parameter overloads are not implemented. Unsupported platforms fail source checking instead of exporting empty bodies.

Mail uses system libcurl SMTP, checks every setup call, uses envelope recipients separately from visible headers, excludes Bcc headers, and encodes body and attachment parts with base64. The maintained server port is a string. The maintained message fields remain, with reply-to, cc, bcc, and attachments added. TLS requests require libcurl's SSL mode while retaining its certificate verification defaults. Attachment filenames currently use `attachment-1`, `attachment-2`, etc.; the supplied undocumented `scramble` helper is not implemented. No email was sent during validation.

Shared memory uses exclusive native mapping creation and a bounded single-reader/single-writer ring. Reservation validates capacity, commitment publishes stamped bytes before the write cursor, and the reader advances only after releasing the exact active message. Contiguous messages wrap with the supplied sentinel. A connected writer prevents reader release. Only one read and one write reservation may be active per side; protocol constants retain the supplied names and values. Cross-process compatibility with the supplied implementation has not been demonstrated.

## How to change it

Modify the Jai algorithms in the corresponding `stdlib/` module; platform boundaries are in `File/{unix,windows}.jai`, `File_Utilities/os/`, `Process/{posix,windows}.jai`, and `Shared_Memory_Channel/{posix,windows}.jai`. `File/windows-encoding.jai` adapts the maintained Windows_Utf8 tuple returns and moves temporary conversion buffers into temporary storage.

Treat SDK declarations as boundaries, not behavior implementations. Compiler-time execution additionally requires the driver's exact source receipts and the VM's supported ABI catalog. FILE pointer/integer/pointer conversion must preserve capability provenance; reconstructing a token from arbitrary integer bits is invalid. `stdlib/tests/os-file-process/file-roundtrip.jai` is an authored witness for the public integer-handle path, binary bytes, lengths, seeks, and close. It requires an explicitly supplied disposable, absent path and was parsed but not executed.

Update `stdlib/.coverage/os-file-process.json` whenever source checks, native execution, VM support, or API coverage changes. A future native watcher backend needs move/attribute/overflow acceptance tests before claiming full event parity. Changes to the shared ring need wrap, near-full, corrupted header, reconnect, and concurrent publication tests.

## Configuration

- File append behavior is selected by `for_writing` and `keep_existing_content`; `log_errors` controls open logging.
- Process capture defaults to false, timeout to unlimited (`-1`), and quoting to `QUOTE_IF_NEEDED`. Parent lifetime cleanup uses a Windows job and Linux parent-death signal; macOS does not implement that option.
- Async queue capacity defaults to 64 outstanding requests. Change the declared default before creating queues; live mutation needs synchronization.
- Watcher defaults: recursive traversal, all events, 0.1-second merge window, and buffer-size compatibility value 8000. Polling frequency belongs to the caller.
- Mail server host/port, credentials, SSL flag, recipients, content type, and attachments come from its structs.
- Shared channel names select native named objects; data capacity is in bytes, excluding the 256-byte header region. POSIX names must satisfy `shm_open` naming rules.
- Source checks select modules with `JAI_RS_MODULE_PATH`, the independent preload with `JAI_RS_PRELOAD`, and runtime support with `JAI_RS_RUNTIME_SUPPORT`. They do not grant host execution.

## Dependencies and evidence boundary

The modules depend on independently authored Basic, String, Thread, Atomics, File, File_Utilities, Windows_Utf8, and normalized system SDK modules. Mail additionally needs system libcurl and Base64; macOS Clipboard needs AppKit/Objective-C, and Linux Clipboard needs display helpers.

All 24 owned files pass the frozen compiler's syntax stage. The refreshed nine semantic roots still stop at target-value resolution or Basic's checked `size_of` constant evaluation before these algorithms can be accepted. The refresh used compiler SHA-256 `9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d`; its bytes and all 404 observed stdlib/prelude Jai inputs stayed unchanged during checking. This observes source stability, not verified build inputs for that binary.

Compiler integration, trusted linking, native runtime behavior, and cross-process behavior are unverified. Existing VM support for stdio and selected POSIX process primitives does not establish successful execution of these whole modules; exec, polling, cancellation, signal operations, clipboard, SMTP, mappings, and clocks need separately authorized adapters and tests. No original compiler, library binary, or source upload was executed.
