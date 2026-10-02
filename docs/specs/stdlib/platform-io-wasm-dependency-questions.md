# File_Utilities WASM consumer dependency question

Status: pending reviewed availability/host-provider contract; no public exports
or filesystem fallback implemented by this worker.

Current independently authored `examples/tour/files/files.jai::tour_files`
unconditionally calls public `File_Utilities.visit_files` and `file_exists`.
The compiler tour WASI gate consumes this source. Reviewed
[File_Utilities inventory](modules/file-utilities.md) lists `visit_files` and
`file_exists` only for Android/Unix/Windows variants. Its platform-neutral path
operations do not establish a WASM filesystem enumeration ABI. Existing File
WASM operations alone do not establish File_Utilities exports.

Independent four-line reproducer, stored under own T7 captures:

```jai
F :: #import "File_Utilities";
main :: () {
    F.visit_files(".", false, 0, (info: *F.File_Visit_Info, data: int) {});
}
```

Fresh source-built `jaic ... -os wasm -check` exits 1 with
`module File_Utilities has no exported member visit_files` at the call. This is
an actual source failure, not a successful negative compatibility test.

Reviewer/compiler-owner resolution needed: does the public reviewed API include
a WASM variant, with which existing supported browser/WASI provider for directory
entries, metadata and symlink traversal? If not, the tour consumer needs a
reviewed target-specific contract. This worker has requested the exact provider
and public availability decision in the sanitized inbox. No native OS guard
override, invented public alias, fake filesystem or zero-result fallback is
authorized by this question. WASM core syscall work remains compiler-owned.
