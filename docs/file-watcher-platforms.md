# File_Watcher platform implementation

The facade selects independent inotify and Windows overlapped-I/O backends.
Existing Mac implementation and FSEvents native source are unchanged. Exact
receipts and integration hashes are in `docs/status/stdlib-tools-shared-audit.json`
under `file_watcher`. Source verification on Mac is not native platform acceptance.

## Public API audit

| API | Implemented behavior | Verification boundary |
| --- | --- | --- |
| `File_Change_Event` | Exact eight flags and `ALL_EVENTS` expression | Both platform CPU targets |
| `File_Change` | Exact fields and inferred float default | Both platform CPU targets |
| `DEFAULT_BUFFER_SIZE` | 8000 | Source |
| `File_Watcher(User_Data = void)` | Canonical Pool/Table storage, typed callback/user data, exact conditional fields/defaults | Source; Windows record remains private |
| `init` | Exact defaults; captured allocator, real Linux descriptor/buffer/path pool; Windows native acquisition deferred to registration | Native ownership fixtures pending CI |
| `add_directories` | Variadic roots, duplicate detection, OS registration and Linux recursive enumeration; reports native errors | Native filesystem fixtures pending CI |
| `process_changes` | Native reads/completions, bounded decoding, owned paths, elapsed timestamps, coalescing deadlines and callback/wait behavior | Interpreter/native decoder proof; actual notifications pending CI |
| `deinit` | Captured allocator cleanup; Linux fd close; Windows cancellation and completion retirement before releasing OVERLAPPED/buffer/event/handle | Native pending-cancel/resource fixtures pending CI |

Windows uses canonical `Windows.HANDLE`, `OVERLAPPED`, and existing reviewed SDK
declarations. Private `CancelIoEx` fills an SDK declaration gap without a public
export or ABI record duplicate. Cancellation waits for operation completion before
freeing storage, following the
[official cancellation contract](https://learn.microsoft.com/en-us/windows/win32/api/ioapiset/nf-ioapiset-cancelioex).
The native test observes handle counts through the
[official GetProcessHandleCount API](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesshandlecount).
Linux uses canonical Linux/POSIX APIs; private libc `free` releases `realpath`'s
native allocation. No new C helper, source pin, fetched implementation, native
asset, compiler exception, or SDK provider edit is required.

## Focused verification

`tools/check_file_watcher_platforms.py` requires assigned `CARGO_TARGET_DIR` and
an actual source-built `jaifmt` there. It builds CLI/lint from source, uses the
shared stdlib, records exact tool/source hashes and rejects source drift. Checks
cover Linux/Windows x64/arm64 bodies, complete strict lint contexts, Mac source
compatibility, and library-owned bounded record interpreter tests.
`--native-records` adds host O0/O2 decoder execution only. Synthetic buffers follow
actual inotify and FILE_NOTIFY_INFORMATION layouts: native header sizes excluding
flexible members, malformed extents/termination, Windows alignment/UTF-16 lengths,
and multiple records. Private unit placement does not expose decoder exports.

On an actual Linux or Windows CI host, after coordinator authorization, use
`--native-runtime` for interpreter and native O0/O2 filesystem tests. Each run
receives a distinct fresh directory and executable in its assigned target.
Mac refuses this option. Fixtures cover create, independent modification, both
rename sides, remove, recursive child registration, renamed child paths, duplicate
roots, moved-out subtree retirement, nonrecursive watches, failed registration
and retry, pending cancellation, no callback after deinit, captured allocator
ownership, Linux fd closure and Windows handle counts. The contract fixture is
source-only: do not run it as a watcher of the shared checkout.
No GUI, fault injection, platform emulation or full corpus run is included.

## Implementation policies and deviations

- Events coalesce by full path and OR flags; latest occurrence resets its deadline.
  `changed` means callbacks delivered. Its exact predicate is unspecified.
- Linux cookie pairs update cached descendant paths. Unpaired moved-out trees
  retire after 0.1 seconds. Cached strings are pool-owned until deinit; repeated
  renames/registrations retain historical path bytes to preserve stable views.
  State lookup and event coalescing use linear searches; recursive registration
  and draining are synchronous. Sustained notification traffic can delay callback
  delivery while draining. No throughput or concurrency claim is made.
- Overflow/lost-buffer events request child rescans, not reconstruction of lost
  individual events. Overflow recovery and whole-root rename policy need review.
- Failed multi-root registration may retain earlier registered roots and returns
  false with their real ownership preserved. Unrecoverable drain errors log and
  mark state failed. Windows failed retirement retains storage for deinit retry.
- By-value deinit consumes resources without resetting the caller's record; reset
  explicitly before reuse. Relocation/reentrant polling and invalid public Linux
  buffer extents are rejected. No thread safety is promised.
- Tiny positive buffers can fail actual reads/registration; no undocumented size
  clamp or polling substitute is used. Dynamic-array OOM behavior follows canonical
  Basic allocation/assertion semantics.
- Full `OS_HAS_INOTIFY` predicate and empty PS5/NN_SWITCH2 declarations remain
  unavailable. This batch implements Linux/Windows and preserves Mac; it does not
  claim Android/consoles or unsupported CLI triples.

Precise requests and the preserved Mac timestamp-origin audit are in
`docs/specs/stdlib/file-watcher-questions.md`. Actual Linux/Windows SDK linking,
runtime acceptance and normal CI remain required. Integration owns staging and
global documentation indexing.

## Integration CI tool paths

The runner accepts --compiler, --linter and --formatter together for explicit matching source-built tools. Defaults retain the fresh CLI/lint build. This avoids guessing Windows MSVC target subdirectories and preserves static-LLVM build flags from the native CI job; supplied tools are hashed and are not counted as a fresh runner build. Normal Linux jobs and both existing native Windows jobs run --native-runtime; Linux failure is included in the existing final enforcement step, and Windows runs after other native suites even if earlier checks failed. No platform runtime success is claimed from this wiring. Full workflow actionlint retains seven pre-existing shellcheck diagnostics with zero introduced diagnostics; originals and comparison are preserved.
