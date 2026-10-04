# Files, processes and OS services

## What it is

File streams and whole-file reads (`File`), directory walking and path helpers (`File_Utilities`), thread-backed asynchronous file requests (`File_Async`), a polling directory watcher (`File_Watcher`), child processes (`Process`), OS queries (`System`), clipboard text and bitmaps (`Clipboard`), SMTP mail (`Mail`) and a shared-memory ring (`Shared_Memory_Channel`).

## How it works

`File` stores an `s64` handle and converts it to a libc `FILE`/descriptor (or a Windows handle) at the call boundary. `file_open`, `file_read`, `file_write`, `file_seek`, `file_close` loop over partial transfers. `read_entire_file(path, log_errors)` and `write_entire_file(path, data)` are the common entry points; `file_length` returns `-1` on failure and `file_length_checked` returns `(length, success)`; `file_read` requires the full range while `file_read_checked` reports a short read. Unix paths are in `File/unix.jai`, Windows in `File/windows.jai` with UTF-16 conversion in `windows-encoding.jai`. Non-Windows `map_entire_file_start` reads into an owned buffer.

`File_Utilities` provides `visit_files` (recursive, with an optional symlink policy and a callback that can stop descent), `file_list`, `copy_file`, `copy_directory`, `delete_directory` and `path_*` helpers. `file_list` returns only an array, so a failed traversal can yield a partial list; use `visit_files` when failure matters.

`Process.run_command(args..., working_directory, capture_and_return_output, print_captured_output, timeout_ms, arg_quoting)` returns `(Process_Result, output, error, timeout_reached)`. The process starts directly without a shell, so `|` and `>` are literal arguments. `run_command_line(command, capture)` is a `jaic` extension that splits one string into arguments and returns `(exit_code, standard_output, standard_error, timed_out)`. `Process_Result` has `type`, `exit_code` and `signal`. POSIX launch uses a close-on-exec pipe to tell an exec failure from an exit code of 127.

```jai
#import "Basic";
#import "Process";

main :: () {
    result, out := run_command("echo", "hi", capture_and_return_output = true);
    print("% %", result.exit_code, out);   // 0 hi
}
```

`File_Async` runs one worker thread per `Queue`, with a bounded submission queue (default 64) and completion events; it is not io_uring or IOCP. `File_Watcher` compares directory snapshots (size and modification time) and merges repeated changes over a quiet interval, producing added/modified/removed events; short-lived changes and renames can be missed. `Clipboard` uses AppKit on macOS, Win32 on Windows, and `wl-copy`/`wl-paste` or `xclip` on Linux; bitmaps are converted to DIB/BMP (`make_dib`, `make_bmp`). `Mail` drives libcurl SMTP and encodes bodies and attachments as base64. `Shared_Memory_Channel` is a single-reader, single-writer ring over a named mapping (`writer_reserve_message`, `writer_commit_message`, `reader_poll_for_message`, `reader_done_with_message`).

## How to change it

- Platform splits: `File/{unix,windows}.jai`, `File_Utilities/os/{unix,windows}.jai`, `Process/{posix,windows}.jai`, `Shared_Memory_Channel/{posix,windows}.jai`. Keep portable logic in each `module.jai`.
- `Basic` holds `get_working_directory`/`set_working_directory`; do not redefine them in `File` or `System`.
- The manual roundtrip check `stdlib/tests/os-file-process/file-roundtrip.jai` expects one disposable, nonexistent path argument and deletes the file afterwards.
- `Process` captures output through pipes; the Windows variant uses SDK processes and a job object. A new capture feature needs both.

## Configuration

`run_command`: capture defaults to false, `timeout_ms` to `-1` (unlimited), quoting to `QUOTE_IF_NEEDED`. File_Async queue capacity defaults to 64. File_Watcher defaults to recursive traversal, all events and a 0.1 second merge window. Mail server, credentials, SSL flag, recipients and attachments are fields of its structs. Shared channel names must satisfy `shm_open` rules on POSIX.

## Dependencies

`Basic`, `String`, `Thread`, `Atomics`, `Pool`, `Hash_Table`; libc/POSIX or Win32 bindings; libcurl and `Base64` for `Mail`; AppKit through `Objective_C` for the macOS clipboard.
