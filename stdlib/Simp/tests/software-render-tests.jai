S :: #import "Simp"(render_api=.SOFTWARE);
M :: #import "Math";
B :: #import "Basic";
software_render_cases :: () -> bool {
    size,stride:=S.get_image_size(.BC1,5,7);
    if size!=32||stride!=16 return false;
    target:=S.texture_create_render_target(4,4,.RGBA8);
    if !target return false;
    defer { S.deinit(target); B.free(target); }
    S.set_render_target(target); S.set_shader_for_color(true);
    S.clear_render_target(0,0,0,0);
    S.immediate_quad(0,0,4,4,M.Vector4.{1,0,0,0.5}); S.immediate_flush();
    bitmap:=S.texture_bitmap(target);
    for i:0..15 {
        // Every pixel receives the quad once, including its shared diagonal.
        if bitmap.data[i*4]!=128||bitmap.data[i*4+1]!=0||bitmap.data[i*4+3]!=128 return false;
    }
    S.set_scissor(1,1,3,3); S.set_shader_for_color(false);
    S.immediate_quad(0,0,4,4,M.Vector4.{0,1,0,1}); S.immediate_flush(); S.clear_scissor();
    for y:0..3 for x:0..3 {
        offset:=((3-y)*4+x)*4;
        inside:=x>=1&&x<3&&y>=1&&y<3;
        if inside&&bitmap.data[offset+1]!=255 return false;
        if !inside&&bitmap.data[offset]!=128 return false;
    }
    source:S.Bitmap; S.bitmap_alloc(*source,4,4,.R8); defer S.deinit(*source);
    for i:0..15 source.data[i]=cast(u8)i;
    S.bitmap_build_mipmaps(*source);
    if source.mipmap_count!=3||source.data.count!=21||source.data[16]!=3||source.data[20]!=8 return false;
    return true;
}
#assert #run software_render_cases();
main :: () { software_render_cases(); }
