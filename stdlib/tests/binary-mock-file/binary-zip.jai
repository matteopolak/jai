#import "Zip_File_Directory";
Files :: #import "File";

witness :: () -> bool {
    bytes := u8.[80, 75, 3, 4, 20, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 6, 0, 102, 69, 88, 2, 0, 120, 120, 97, 98, 99, 80, 75, 7, 8, 194, 65, 36, 53, 3, 0, 0, 0, 3, 0, 0, 0, 80, 75, 1, 2, 20, 0, 20, 0, 8, 0, 0, 0, 0, 0, 0, 0, 194, 65, 36, 53, 3, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 102, 80, 75, 5, 6, 0, 0, 0, 0, 1, 0, 1, 0, 47, 0, 0, 0, 56, 0, 0, 0, 7, 0, 99, 111, 109, 109, 101, 110, 116];
    data: string;
    data.data = bytes.data;
    data.count = bytes.count;
    Files.archive = data;
    success, dir := load_zip_directory("mock.zip", false);
    if !success || dir.entries.count != 1 || dir.name != "mock.zip" return false;
    entry := dir.entries[0];
    if entry.filename != "f" || entry.chunk_offset != 37 || entry.position_in_file != 56 || entry.chunk_len != 3 || entry.compressed_len != 3 || entry.bit_flag != 8 return false;
    if !dir.file.handle || dir.file.handle.closed return false;
    deinit(*dir);
    if dir.entries.count != 0 || dir.memory_block.count != 0 || dir.name.count != 0 || dir.file.handle.closed return false;
    Files.file_close(*dir.file);
    // Invalid end-record disk number must fail with released empty storage.
    bytes[103 + 4] = 1;
    bad_success, bad := load_zip_directory("mock.zip");
    if bad_success || bad.entries.count != 0 || bad.memory_block.count != 0 || bad.file.handle return false;
    return true;
}

#assert(witness());
