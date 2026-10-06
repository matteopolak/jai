// Format recognition is independent of host byte order and pointer alignment.
// Full decoders remain absent until their validation and ownership are supported.

MS_DOS_MAGIC_PREFIX :: 0x5a4d;
PE_MAGIC_PREFIX :: 0x00004550;
EXPECTED_MAGIC :: 0x464c457f;
APPLE_UNIVERSAL_FILE_MAGIC: u32 : 0xbebafeca;
AR_FILE_MAGIC :: "!<arch>\n";

string_from_zero_padded_array :: (padded: [] u8) -> string {
    result: string;
    result.data = padded.data;
    result.count = padded.count;
    while result.count > 0 {
        if result[result.count - 1] != 0 break;
        result.count -= 1;
    }
    return result;
}

is_ar :: (file_content: string) -> bool {
    if file_content.count < AR_FILE_MAGIC.count return false;
    for byte, index: AR_FILE_MAGIC {
        if file_content[index] != byte return false;
    }
    return true;
}

is_apple_universal :: (file_content: string) -> bool {
    return file_content.count >= 8 && read_le_u32(file_content, 0) == APPLE_UNIVERSAL_FILE_MAGIC;
}

is_coff :: (file_content: string) -> bool {
    return file_content.count >= 20 && file_content[0] == 0x64 && file_content[1] == 0x86;
}

is_elf :: (file_content: string) -> bool {
    return file_content.count >= 64 && read_le_u32(file_content, 0) == EXPECTED_MAGIC;
}

is_macho :: (file_content: string) -> bool {
    return file_content.count >= 32 && read_le_u32(file_content, 0) == 0xfeedfacf;
}

is_pe :: (file_content: string) -> bool, coff_start: int {
    if file_content.count < 64 return false, 0;
    if file_content[0] != 0x4d || file_content[1] != 0x5a return false, 0;
    offset := cast(int) read_le_u32(file_content, 60);
    if offset > file_content.count - 4 return false, 0;
    if read_le_u32(file_content, offset) != PE_MAGIC_PREFIX return false, 0;
    coff_start := offset + 4;
    rest: string;
    rest.data = file_content.data + coff_start;
    rest.count = file_content.count - coff_start;
    return is_coff(rest), coff_start;
}

#scope_module

read_le_u32 :: (data: string, offset: int) -> u32 {
    return (cast(u32) data[offset]) | ((cast(u32) data[offset + 1]) << 8) |
           ((cast(u32) data[offset + 2]) << 16) | ((cast(u32) data[offset + 3]) << 24);
}
