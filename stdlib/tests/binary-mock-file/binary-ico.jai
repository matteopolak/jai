#import "Ico_File";
Files :: #import "File";

witness :: () -> bool {
    image, mask, total := get_bytes_for_image(4, 16);
    if image != 2088 || mask != 64 || total != 2216 return false;
    if get_total_bytes_for_size(3, 16) != 1704 return false;
    if get_total_bytes_for_size(4, 256) != 557096 return false;
    if get_total_bytes_for_size(4, 2147483647) != 0 return false;
    if create_ico_file(1, 1, 2, null) != "" return false;
    if create_ico_file(0, 1, 4, null) != "" return false;
    Files.archive = "unsupported input";
    if create_ico_file_from_bitmap_filename("mock.bmp") != "" return false;
    return true;
}

#assert(witness());
