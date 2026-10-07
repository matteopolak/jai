// This checks the actual production format arithmetic without importing a GPU SDK.
#load "../texture_format.jai";

texture_format_cases :: () -> bool {
    size, stride := get_image_size(.RGBA8, 13, 7);
    if size != 364 || stride != 52 return false;
    size, stride = get_image_size(.BC1, 5, 7);
    if size != 32 || stride != 16 return false;
    size, stride = get_image_size(.ETC_RGBA, 1, 1);
    if size != 16 || stride != 16 return false;
    size, stride = get_image_size(.Unknown, 7, 9);
    if size != 0 || stride != 0 return false;
    size, stride = get_image_size(.RGBA8, -1, 9);
    if size != 0 || stride != 0 return false;
    if get_image_bytes_per_texel(.RGBA32F) != 16 || get_image_bytes_per_texel(.BC7) != 0 return false;
    if get_image_bytes_per_block(.BC4) != 8 || get_image_bytes_per_block(.ETC_RG) != 16 return false;
    size, stride = get_image_size(.RGBA32F, 0x7fff_ffff_ffff_ffff, 2);
    if size != 0 || stride != 0 return false;
    return true;
}

#assert #run texture_format_cases();

main :: () {
    texture_format_cases();
}
