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
