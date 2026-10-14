M :: #import "pl_mpeg";

main :: () {
    bytes := u8.[0xff, 0xfc, 0x80, 0xc0, 0, 0];
    buffer := M.buffer_create_with_memory(bytes, false);
    M.audio_create_with_buffer(buffer, true);
}
