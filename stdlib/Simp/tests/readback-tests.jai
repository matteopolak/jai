S :: #import "Simp"(render_api=.SOFTWARE);
B :: #import "Basic";
readback_cases :: ()->bool {
    texture:=S.texture_create_render_target(2,2,.RGBA8); if !texture return false;
    defer { S.deinit(texture); B.free(texture); }
    bitmap:=S.texture_bitmap(texture);
    // Top row red, bottom row blue in the actual target storage.
    for x:0..1 {
        bitmap.data[x*4]=255; bitmap.data[x*4+3]=255;
        bitmap.data[bitmap.stride+x*4+2]=255; bitmap.data[bitmap.stride+x*4+3]=255;
    }
    reader:=S.pixel_read_begin(texture,.BGRA8,1,2,false,true); if !reader||!S.pixel_read_is_done(reader) return false;
    result:=S.pixel_read_end(reader); defer S.deinit(*result);
    if result.width!=1||result.height!=2||result.stride!=4||result.data[2]!=255||result.data[4]!=255 return false;
    reader=S.pixel_read_begin(texture,.RGBA8,2,2,false,false); if !reader return false;
    result2:=S.pixel_read_end(reader); defer S.deinit(*result2);
    if result2.data[2]!=255||result2.data[result2.stride]!=255 return false;
    if S.pixel_read_begin(texture,.BC1)!=null return false;
    reader=S.pixel_read_begin(texture,.RGB8); if !reader return false; S.pixel_read_cancel(reader);
    return true;
}
#assert #run readback_cases();
main :: () { readback_cases(); }
