# Executable container parsing

The `executable_formats` facade currently loads independently authored archive
parsing under `internal/executable`. `Archive` and `Archive_File` preserve reviewed
field order and canonical reflected names. Implemented exports are `is_ar`,
`parse_ar`, `parse_ar_file` and `is_apple_universal`. This is a partial module;
COFF/ELF/Mach-O object parsing, debug formats and text dylib parsing remain work.

The archive parser bounds every member/header/padding/name/index read. It supports
ordinary names, BSD embedded names, GNU newline and COFF NUL long-name tables,
32-bit big-endian GNU/first linker indexes, little-endian COFF second indexes and
32-bit BSD ranlib indexes in either byte order. Symbol offsets must identify an
actual returned member header; a binary search checks the ordered member list.
Special index/name-table members are represented through metadata rather than
ordinary files. Thin, 64-bit-index and unknown archive formats return failure.
The BSD format has no endian tag: little endian is attempted first, then big
endian after bounded validation. Ambiguous interpretations require contract review.
The COFF second index supplies returned ordering; both indexes are validated,
but their symbol sets are not cross-compared. Empty symbol names reject.

`parse_ar` borrows its input bytes, member names/data and symbol names. The caller
owns the three separately allocated result arrays and frees them with Basic's
array deinitializer under the matching allocator. `parse_ar_file` also transfers
its allocated `content` to the caller on success; failure releases that buffer.
Failure returns a fully empty aggregate after cleaning temporary arrays. The
reviewed API has no archive deinitializer or allocator field, so none is invented.
Exact special-member visibility, diagnostic text, endian selection and returned
ownership conventions need review. Allocation failures currently use Basic's
checked allocation behavior rather than promising recoverable false status.

The universal predicate recognizes the four native fat magic byte sequences.
It identifies a signature, not a structurally validated binary. The reviewed
`Apple_Universal_Binary.files` refers to an unspecified `Arch_File`; its type and
parsers are withheld pending that public shape. No replacement type is invented.

Format facts were checked against official native SDK `ar.h`, `ranlib.h` and
`mach-o/fat.h`, the [GNU ar manual](https://sourceware.org/binutils/docs/binutils/ar.html),
the [LLVM native archive header](https://github.com/llvm/llvm-project/blob/main/llvm/include/llvm/Object/Archive.h)
and Microsoft's [archive format documentation](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#archive-library-file-format).
No parser implementation bodies were copied.

`tools/build_portable_archive_fixtures.py` builds original wire fixtures and a
real native object/archive from original C source using host tools. Tests check
borrowed pointers, layouts, all supported index variants, native symbols,
malformed counts/offsets/strings/headers/padding, every truncated simple-member
prefix and zero outstanding allocations. Tests run interpreter/native; the
current File dependency still prevents Windows target verification until peer
platform integration. Fixture regeneration is deterministic for original wire
data; host native archives may carry tool/platform metadata.
