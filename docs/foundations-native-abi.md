# Foundations native ABI notes

The Windows backend uses the bindings worker's NEW Windows module, copied
read-only into testing staging. Its public native functions provide wide
path queries/conversion, file copying, directory enumeration, handle queries
and directory creation. No old Jai library implementation was consulted.

Narrow missing native declarations live privately in
stdlib/internal/files/windows-abi.jai. They do not add facade exports:

- Attribute_Data follows WIN32_FILE_ATTRIBUTE_DATA: DWORD attributes, three
  FILETIME fields, then high/low DWORD file size. Its pointer is passed to
  GetFileAttributesExW with GetFileExInfoStandard (0).
  [Microsoft layout](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/ns-fileapi-win32_file_attribute_data),
  [native function](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfileattributesexw).
- File_Identity follows FILE_ID_INFO: ULONGLONG volume serial plus 16 file-ID
  bytes. GetFileInformationByHandleEx(FileIdInfo) supplies identities for cycle
  and destination-ancestor checks, including directory junctions. If the OS or
  filesystem cannot supply this class, traversal/copy returns failure rather
  than manufacturing an identity. This is a platform limit requiring Windows
  runtime coverage; it is not an exact filesystem-version compatibility claim.
  [Microsoft layout and identity semantics](https://learn.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-file_id_info).
- MoveFileExW with MOVEFILE_REPLACE_EXISTING (1) implements rename/replace;
  MOVEFILE_COPY_ALLOWED is deliberately absent so a cross-volume copy/delete
  is not presented as an atomic rename.
  [Microsoft native contract](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexw).

UTF-8 paths convert through MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS).
Embedded NUL and invalid input return failure. Names convert back through
WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS); a conversion failure is
reported by traversal, not replaced with a fabricated name.
[Microsoft conversion contract](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar).

FILETIME's 100 ns ticks since 1601 convert to Apollo through signed seconds
relative to 1970 plus subsecond nanoseconds. Metadata sizes exceeding signed
s64 report failure. Directory handles and search handles are closed, with
close failures included in the operation's success result.

Windows code has been type-checked with unused code enabled on x64/arm64,
including real callback and directory-copy specializations. It has not run on
a Windows host. The executable fixture asserts Windows at compile time; no
non-Windows no-op run is counted as verification.

The superseded floating conversion used the public C `snprintf` variadic interface with
float64 promotion and 32-bit precision. `localeconv` supplies its first
`lconv` member, `decimal_point`, so conversion output is normalized before
applying the reviewed separator bytes. Only this native prefix is declared;
no private C library layout is inferred. The official macOS SDK `_locale.h`
and `_stdio.h` declare these interfaces; the native contracts also appear in
[POSIX fprintf](https://pubs.opengroup.org/onlinepubs/9799919799/functions/fprintf.html)
and [Microsoft snprintf](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/snprintf-snprintf-snprintf-l-snwprintf-snwprintf-l).
These declarations are now removed from production Basic. The portable
numeric-conversion implementation uses original arbitrary-precision integer
arithmetic for exact decimal rendering and binary parsing, eliminating
snprintf/localeconv/strtod and global locale dependence on every target.
The earlier missing-import WASI failure is retained as historical evidence in
the deviations report; no env functions or tool-only substitute are supplied.

Native path strings must be representable in the called ABI. The shared private
native-path validator rejects embedded NUL before POSIX queries/copy/rename/
directory traversal/chdir, so operations cannot silently act on a prefix.
Windows UTF conversion uses the same check and retains its strict UTF-8 rules.
Pure byte path manipulation still preserves input data; this validation applies
to native filesystem operations. Original real-file tests verify destination
and working-directory preservation on rejected inputs.
