# Classic ZIP directory reader

The `Zip_File_Directory` facade loads canonical public records and private
archive parsing operations. The implementation seeks to the bounded end-record
search window, finds a complete end record including its comment, and reads only
the central directory. It decodes little-endian fields without assuming alignment.
Names borrow slices of the directory's owned buffer; the input path is copied.

Record count, directory bounds, variable-length name/extra/comment extents,
disk numbers and classic-size limits are checked before access. ZIP64 sentinels
and ZIP64 extra fields are rejected. Unexpected central signatures and
data-descriptor flag bit 3 assert, as required by the reviewed contract. Other
malformed/unsupported inputs return false and an empty result, releasing partial
entries, buffers and the opened file. No decompression or local-entry CRC check
is performed or claimed.

The default load closes its file before returning. With `close_file=false`,
`deinit` frees directory allocations and preserves the retained `File`; the
caller must close it. A filename view is invalid after deinit. Allocations use
the active allocator, and callers must maintain the corresponding allocator
lifetime through deinit.

The oracle does not define `position_in_file`. Currently it records the absolute
central-directory record offset; `chunk_offset` retains the separately encoded
local-header offset. This choice needs contract review and is not claimed as
reference conformance. Trailing bytes after the end-record comment and directory
digital-signature records are rejected; support requirements for those extensions
are likewise unresolved.

Fixtures are independently constructed using Python's standard ZIP writer under
`target/portable-tests/zip`, never the public corpus. Tests cover two entries,
binary bytes, an end-record signature inside the archive comment, empty archives,
borrowed names, explicit retained handles, truncation, invalid extents/counts,
ZIP64 and multidisk rejection. A malformed second record verifies cleanup after
one entry was allocated; a counting allocator checks zero remaining allocations.
Separate failing programs require the descriptor/signature assertion diagnostics.
The current File backend supports Unix; Windows native integration is unfinished.
