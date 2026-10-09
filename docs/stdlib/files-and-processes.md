# Files, processes and OS services

## What it is

File streams and whole-file reads (`File`), directory walking and path helpers (`File_Utilities`), thread-backed asynchronous file requests (`File_Async`), a polling directory watcher (`File_Watcher`), child processes (`Process`), OS queries (`System`), clipboard text and bitmaps (`Clipboard`), SMTP mail (`Mail`) and a shared-memory ring (`Shared_Memory_Channel`).

## How it works

`File` stores the platform's own handle: a libc `FILE*` on macOS and Linux, a Windows `HANDLE` on Windows (an `s64` there until 0.4.4, which kept `File.{ GetStdHandle(...) }` from compiling). `file_open`, `file_read`, `file_write`, `file_seek` and `file_close` loop over partial transfers. `read_entire_file(path, log_errors)` and `write_entire_file(path, data)` are the common entry points. `file_length` returns `-1` on failure; `file_length_checked` returns `(length, success)`. `file_read` requires the full range; `file_read_checked` reports a short read. Unix paths are in `File/unix.jai`, Windows in `File/windows.jai` with UTF-16 conversion in `windows-encoding.jai`. Non-Windows `map_entire_file_start` reads into an owned buffer.

`file_read_line(file)` returns the next line without its newline (nor the carriage return before it) and `ok = false` at the end of input; a last line without a newline still counts. The text is allocated with the context allocator. `read_stdin_line()` is the same for standard input, byte by byte from descriptor 0 (`read`) on Unix and the WASI/playground hosts and from the `GetStdHandle` handle on Windows. It does not go through the C `stdin` stream, which the wasm target has no symbol for. In the playground it waits for the page to supply a line. Tests: `tests/stdlib/file-read-line.jai`, `tests/native/stdin-lines`.

`File_Utilities` provides `visit_files` (recursive, with an optional symlink policy and a callback that can stop descent), `file_list`, `copy_file`, `copy_directory`, `delete_directory` and `path_*` helpers. `file_list` returns only an array, so a failed traversal can yield a partial list; use `visit_files` when failure matters.

`Process.run_command(args..., working_directory, capture_and_return_output, print_captured_output, timeout_ms, arg_quoting)` returns `(Process_Result, output, error, timeout_reached)`; `Process_Result` has `type`, `exit_code` and `signal`. There is no shell, so `|` and `>` are literal arguments. `run_command_line(command, capture)` is a jaic extension that splits one string into arguments and returns `(exit_code, standard_output, standard_error, timed_out)`.

On POSIX:

- Launch uses a close-on-exec pipe to tell an exec failure from an exit code of 127.
- With capture, the child's stdin is one end of a `socketpair`, not a pipe. Programs rely on that to exchange messages and descriptors with their parent (rluba/cluster does `fstat(0)` and `send`/`recv`).
- `read_pipe` returns `(true, 0)` at end of input or when a non-blocking pipe is empty, and never closes the handle. `read_from_process` marks `eof` itself, so callers that watch the handles in their own event loop keep them registered until `deinit`.

```jai
#import "Basic";
#import "Process";

main :: () {
    result, out := run_command("echo", "hi", capture_and_return_output = true);
    print("% %", result.exit_code, out);   // 0 hi
}
```

The rest:

- `File_Async`: one worker thread per `Queue`, a bounded submission queue (default 64) and completion events. Not io_uring or IOCP.
- `File_Watcher`: compares directory snapshots (size and modification time) and merges repeated changes over a quiet interval into added, modified and removed events. Short-lived changes and renames can be missed. `File_Change.time_of_last_change` is a `float64` of `seconds_since_init()`: as a `float32` it rounded up past the current time, so a zero merge window held a change back one run in two and `wait_seconds` could exceed the window.
- `Clipboard`: AppKit on macOS, Win32 on Windows, `wl-copy`/`wl-paste` or `xclip` on Linux. Bitmaps convert to DIB/BMP (`make_dib`, `make_bmp`).
- `Mail`: libcurl SMTP, with base64 bodies and attachments.
- `Shared_Memory_Channel`: a single-reader, single-writer ring over a named mapping (`writer_reserve_message`, `writer_commit_message`, `reader_poll_for_message`, `reader_done_with_message`). The reader zeroes the region, fills the header and publishes the channel magic last, atomically; `writer_connect` refuses a mapping whose size differs from the header's, and macOS reports shared-memory sizes rounded up to the page size, so give `reader_create_channel` a ring size that makes `bytes + OFFSET_TO_MESSAGE_DATA` a multiple of 16 KiB there (`tests/stdlib/shared-memory-channel.jai`).

## How to change it

- Platform splits: `File/{unix,windows}.jai`, `File_Utilities/os/{unix,windows}.jai`, `Process/{posix,windows}.jai`, `Shared_Memory_Channel/{posix,windows}.jai`. Keep portable logic in each `module.jai`.
- `Basic` holds `get_working_directory`/`set_working_directory`; do not redefine them in `File` or `System`.
- `stdlib/tests/os-file-process/file-roundtrip.jai` writes, reads and deletes `file-roundtrip.tmp` next to itself (sweep set `modules`).
- `Process` captures output through pipes, plus the stdin socket (`tests/stdlib/process-stdin-socket.jai`); the Windows variant uses a job object. A new capture feature needs both.

## Configuration

`run_command`: capture defaults to false, `timeout_ms` to `-1` (unlimited), quoting to `QUOTE_IF_NEEDED`. File_Async queue capacity defaults to 64. File_Watcher defaults to recursive traversal, all events and a 0.1 second merge window. Mail server, credentials, SSL flag, recipients and attachments are fields of its structs. Shared channel names must satisfy `shm_open` rules on POSIX.

## Dependencies

`Basic`, `String`, `Thread`, `Atomics`, `Pool`, `Hash_Table`; libc/POSIX or Win32 bindings; libcurl and `Base64` for `Mail`; AppKit through `Objective_C` for the macOS clipboard.
