# Windows_Utf8 implementation and verification limits

Both reviewed procedures are implemented for Windows, reexporting the original
procedure entities with exact parameter names/defaults/return types. Private code
calls the NEW Windows producer's Kernel32 declarations; no duplicate C binding or
substitute conversion backend is introduced.

utf8_to_wide uses two native conversion passes, allocates room for an additional
u16 terminator, reports encoded bytes excluding that terminator, and returns the
reviewed null/true/zero result for empty input. wide_to_utf8 distinguishes native
NUL-terminated input from explicit character counts, allocates/appends the proper
terminator, and excludes it from the returned string count. Embedded NULs survive
explicit lengths. Both return failure on invalid sizes, native errors, allocation
failure or inconsistent conversion-pass extents, freeing intermediate storage.
Both returned buffers use the active allocator; callers free with that allocator.

Independent policies needing review: zero native flags delegate malformed-sequence
replacement to Kernel32; explicit wide length zero returns native-style failure.
Input byte lengths exceeding s32 and UTF-16 byte-result overflow reject before
narrowing, improving the reviewed oversized-input robustness limitation. Buffer
mutation concurrent with conversion and invalid pointer extents remain caller
errors. No strict-input validation flag or exported helper is invented.

Official native ABI/length/termination facts:
[MultiByteToWideChar](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar)
and [WideCharToMultiByte](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-widechartomultibyte).
These supplied only native C contracts; no Jai implementation was consulted.

`python3 -B tools/check_portable_windows_utf8.py` type-checks both actual Windows
CPU configurations and all fixture bodies against NEW bindings. This is **not
runtime verification**. The fixture covers non-BMP surrogates, NUL termination,
explicit-length embedded NULs, empty inputs, native invalid arguments and injected
allocation failure. Host execution outside Windows fails explicitly. The runner's
--native likewise requires Windows, then executes interpreter/native O0/O2. No
Kernel32 result is mocked or counted as completed functionality. Initial fixture
used invalid block-form push_allocator syntax; using its exact reviewed expansion
call fixes the type-check without changing the public API.

Actual Windows execution remains a coordinator platform gate. Source-built
formatter/strict linter process the owned code with repository configuration;
host conditional compilation alone is not presented as Windows body checking.
The separate Windows x64/ARM64 compiler checks establish body/ABI type validity.
