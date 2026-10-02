// Package metadata and header validation. Entry loading/writing remains pending.
KNOWN_HEADER_SIZE :: 64;
KNOWN_TABLE_OF_CONTENTS_SIZE :: 64;

Entry_Info :: struct {
    name: string;
    data: [] u8;
    offset_from_start_of_file: s64;
    size_of_entry: s64;
}

Package_Header :: struct {
    magic: u32;
    version: u32;
    flags: u32;
    reserved0: u32;
    table_of_contents_offset: s64;
    reserved: [5] u64;
}

Table_Of_Contents :: struct {
    table_of_contents_magic: u32;
    reserved0: u32;
    number_of_entries: s64;
    reserved: [6] u64;
}

#scope_file
MAGIC :: 0x706d6973;
TABLE_OF_CONTENTS_MAGIC :: 0x21636f74;
FILE_VERSION :: 1;
TARGET_IS_LITTLE_ENDIAN :: true;

check_header :: (header: *Package_Header, name: string, file_size_in_bytes_or_minus_1: s64) -> bool {
    if !header return false;
    if header.magic != MAGIC || header.version > FILE_VERSION return false;
    if header.table_of_contents_offset < KNOWN_HEADER_SIZE return false;
    size := file_size_in_bytes_or_minus_1;
    if size >= 0 {
        if size < KNOWN_TABLE_OF_CONTENTS_SIZE return false;
        if header.table_of_contents_offset > size - KNOWN_TABLE_OF_CONTENTS_SIZE return false;
    }
    return true;
}
