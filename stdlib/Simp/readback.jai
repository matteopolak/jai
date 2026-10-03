// Public screenshot contracts, with independent capture/lifetime implementation.
Pixel_Read :: struct {
    dest_format: Texture_Format;
    dest_srgb: bool;
    dest_width, dest_height: s32;
    flip := false;
    using platform_specific: Pixel_Read_Platform;
}
Pixel_Read_Platform :: struct {
    intermediate_texture: *Texture;
    pbo: GLuint;
    src\_fbo_handle: GLuint;
    dest_fbo_handle: GLuint;
}
pixel_read_begin :: (source: *Texture, dest_format: Texture_Format, width: s32 = -1, height: s32 = -1, srgb := false, flip := false) -> *Pixel_Read {
    if dest_format!=.R8&&dest_format!=.RG8&&dest_format!=.RGB8&&dest_format!=.RGBA8&&dest_format!=.BGRA8 return null;
    if source&&(source.flags&(.Cube|.Array|.Volume|.Buffer|.Multisampled)) return null;
    CheckInit(); immediate_flush();
    source_width:s32; source_height:s32;
    if source { source_width=source.width; source_height=source.height; }
    else if context.simp.texture_render_target { source_width=context.simp.texture_render_target.width; source_height=context.simp.texture_render_target.height; }
    else { source_width=context.simp.current_window_info.window_width; source_height=context.simp.current_window_info.window_height; }
    if source_width<=0||source_height<=0 return null;
    raw_bytes,raw_stride:=get_image_size(.RGBA8,source_width,source_height);
    if raw_bytes<=0||raw_stride>0x7fff_ffff return null;
    if width<0 width=source_width; if height<0 height=source_height;
    bytes,stride:=get_image_size(dest_format,width,height);
    if width<=0||height<=0||bytes<=0||stride>0x7fff_ffff return null;
    reader:=New(Pixel_Read); reader.dest_format=dest_format; reader.dest_width=width; reader.dest_height=height; reader.dest_srgb=srgb; reader.flip=flip;
    record:=New(Pixel_Read_Record); record.reader=reader;
    if source record.source_srgb=(source.flags&.sRGB)!=0;
    else if context.simp.texture_render_target record.source_srgb=(context.simp.texture_render_target.flags&.sRGB)!=0;
    bitmap_alloc(*record.raw,source_width,source_height,.RGBA8);
    if record.raw.data.count<=0||!record.raw.data.data { readback_destroy(record); return null; }
    success:=false;
    #if render_api==.SOFTWARE {
        bitmap:=ifx source then texture_bitmap(source) else context.simp.specific.software_target;
        if bitmap&&bitmap.width==source_width&&bitmap.height==source_height&&(bitmap.format==.R8||bitmap.format==.RG8||bitmap.format==.RGB8||bitmap.format==.RGBA8||bitmap.format==.BGRA8) {
            record.source_srgb=(bitmap.flags&.IS_SRGB)!=0;
            for y:0..source_height-1 for x:0..source_width-1 {
                color:=readback_bitmap_color(bitmap,x,y); pixel:=record.raw.data.data+y*record.raw.stride+x*4;
                pixel[0]=readback_byte(color.x); pixel[1]=readback_byte(color.y); pixel[2]=readback_byte(color.z); pixel[3]=readback_byte(color.w);
            }
            record.top_first=true; record.done=true; success=true;
        }
    } else #if render_api==.OPENGL { success=gl_readback_begin(record,source); }
    if !success { readback_destroy(record); return null; }
    array_add(*pixel_reads,record); return reader;
}
pixel_read_is_done :: (reader: *Pixel_Read) -> bool {
    record:=readback_find(reader); if !record||record.failed return false;
    if record.done return true;
    #if render_api==.OPENGL {
        result:=gl_api.glClientWaitSync(record.fence,0,0);
        if result==GL.GL_WAIT_FAILED { record.failed=true; return false; }
        return result==GL.GL_ALREADY_SIGNALED||result==GL.GL_CONDITION_SATISFIED;
    }
    return false;
}
pixel_read_end :: (reader: *Pixel_Read, bitmap: *Bitmap) {
    record:=readback_find(reader); assert(record!=null&&bitmap!=null,"Invalid screenshot reader or destination");
    if !record||!bitmap return;
    defer readback_destroy(record);
    #if render_api==.OPENGL { if !record.done&&!record.failed gl_readback_finish(record); }
    if !record.done||record.failed { assert(false,"Native screenshot read failed"); return; }
    bitmap_alloc(bitmap,reader.dest_width,reader.dest_height,reader.dest_format);
    if bitmap.data.count<=0||!bitmap.data.data { assert(false,"Could not allocate screenshot destination"); return; }
    if reader.dest_srgb bitmap.flags|=.IS_SRGB;
    for y:0..reader.dest_height-1 for x:0..reader.dest_width-1 {
        sx:=min(cast(int)x*record.raw.width/reader.dest_width,record.raw.width-1);
        sy:=min(cast(int)y*record.raw.height/reader.dest_height,record.raw.height-1);
        if record.top_first!=reader.flip sy=record.raw.height-1-sy;
        color:=readback_bitmap_color(*record.raw,sx,sy);
        if record.source_srgb!=reader.dest_srgb {
            if record.source_srgb { color.x=readback_decode_srgb(color.x); color.y=readback_decode_srgb(color.y); color.z=readback_decode_srgb(color.z); }
            else { color.x=readback_encode_srgb(color.x); color.y=readback_encode_srgb(color.y); color.z=readback_encode_srgb(color.z); }
        }
        readback_store_color(bitmap,x,y,color);
    }
}
pixel_read_end :: (reader: *Pixel_Read) -> Bitmap { result:Bitmap; pixel_read_end(reader,*result); return result; }
// Explicit cancellation releases pending native/CPU storage while its context is current.
pixel_read_cancel :: (reader:*Pixel_Read) { record:=readback_find(reader); if record readback_destroy(record); }
#scope_module
Pixel_Read_Record :: struct {
    reader:*Pixel_Read; raw:Bitmap; source_srgb:bool; top_first:bool; done:bool; failed:bool;
    #if render_api==.OPENGL { fence:GL.GLsync; }
}
pixel_reads:[..]*Pixel_Read_Record;
readback_find :: (reader:*Pixel_Read)->*Pixel_Read_Record { for record:pixel_reads if record.reader==reader return record; return null; }
readback_destroy :: (record:*Pixel_Read_Record) {
    #if render_api==.OPENGL {
        if gl_api {
            if record.fence gl_api.glDeleteSync(record.fence);
            if record.reader.pbo gl_api.glDeleteBuffers(1,*record.reader.pbo);
            if record.reader.dest_fbo_handle gl_api.glDeleteFramebuffers(1,*record.reader.dest_fbo_handle);
        }
    }
    for value,index:pixel_reads if value==record { for i:index+1..pixel_reads.count-1 pixel_reads[i-1]=pixel_reads[i]; pixel_reads.count-=1; break; }
    deinit(*record.raw); free(record.reader); free(record);
}
readback_byte :: (value:float)->u8 { return cast(u8)clamp(floor(cast(float64)value*255+0.5),0.0,255.0); }
readback_decode_srgb :: (value:float)->float { if value<=0.04045 return value/12.92; return cast(float)pow((value+0.055)/1.055,2.4); }
readback_encode_srgb :: (value:float)->float { if value<=0.0031308 return value*12.92; return cast(float)(1.055*pow(value,1/2.4)-0.055); }
readback_bitmap_color :: (bitmap:*Bitmap,x:int,y:int)->Vector4 {
    count:=get_image_bytes_per_texel(bitmap.format); p:=bitmap.data.data+y*bitmap.stride+x*count;
    if bitmap.format==.R8 return .{p[0]/255.0,0,0,1};
    if bitmap.format==.RG8 return .{p[0]/255.0,p[1]/255.0,0,1};
    if bitmap.format==.RGB8 return .{p[0]/255.0,p[1]/255.0,p[2]/255.0,1};
    if bitmap.format==.BGRA8 return .{p[2]/255.0,p[1]/255.0,p[0]/255.0,p[3]/255.0};
    assert(bitmap.format==.RGBA8,"CPU screenshots require an 8-bit source format");
    return .{p[0]/255.0,p[1]/255.0,p[2]/255.0,p[3]/255.0};
}
readback_store_color :: (bitmap:*Bitmap,x:int,y:int,color:Vector4) {
    count:=get_image_bytes_per_texel(bitmap.format); p:=bitmap.data.data+y*bitmap.stride+x*count;
    p[0]=readback_byte(ifx bitmap.format==.BGRA8 then color.z else color.x);
    if count>1 p[1]=readback_byte(color.y);
    if count>2 p[2]=readback_byte(ifx bitmap.format==.BGRA8 then color.x else color.z);
    if count>3 p[3]=readback_byte(color.w);
}
#if render_api==.OPENGL {
gl_readback_begin :: (record:*Pixel_Read_Record,source:*Texture)->bool {
    if !gl_api return false;
    if !gl_api.glReadPixels||!gl_api.glFenceSync||!gl_api.glMapBufferRange||!gl_api.glClientWaitSync||!gl_api.glDeleteSync||!gl_api.glFlush||!gl_api.glGetIntegerv||!gl_api.glBindFramebuffer||!gl_api.glBindBuffer||!gl_api.glBufferData||!gl_api.glPixelStorei||!gl_api.glGenFramebuffers||!gl_api.glFramebufferTexture2D||!gl_api.glCheckFramebufferStatus||!gl_api.glReadBuffer||!gl_api.glGenBuffers||!gl_api.glDeleteFramebuffers||!gl_api.glDeleteBuffers||!gl_api.glUnmapBuffer||!gl_api.glGetError return false;
    if gl_api.glGetError()!=GL.GL_NO_ERROR return false;
    old_framebuffer:s32; old_buffer:s32; old_alignment:s32; old_row_length:s32;
    gl_api.glGetIntegerv(GL.GL_READ_FRAMEBUFFER_BINDING,*old_framebuffer); gl_api.glGetIntegerv(GL.GL_PIXEL_PACK_BUFFER_BINDING,*old_buffer);
    gl_api.glGetIntegerv(GL.GL_PACK_ALIGNMENT,*old_alignment); gl_api.glGetIntegerv(GL.GL_PACK_ROW_LENGTH,*old_row_length);
    defer {
        gl_api.glBindFramebuffer(GL.GL_READ_FRAMEBUFFER,cast(u32)old_framebuffer); gl_api.glBindBuffer(GL.GL_PIXEL_PACK_BUFFER,cast(u32)old_buffer);
        gl_api.glPixelStorei(GL.GL_PACK_ALIGNMENT,old_alignment); gl_api.glPixelStorei(GL.GL_PACK_ROW_LENGTH,old_row_length);
    }
    if source {
        if !source.gl_handle return false;
        gl_api.glGenFramebuffers(1,*record.reader.dest_fbo_handle);
        if !record.reader.dest_fbo_handle return false;
        gl_api.glBindFramebuffer(GL.GL_READ_FRAMEBUFFER,record.reader.dest_fbo_handle);
        gl_api.glFramebufferTexture2D(GL.GL_READ_FRAMEBUFFER,GL.GL_COLOR_ATTACHMENT0,GL.GL_TEXTURE_2D,source.gl_handle,0);
        if gl_api.glCheckFramebufferStatus(GL.GL_READ_FRAMEBUFFER)!=GL.GL_FRAMEBUFFER_COMPLETE return false;
        gl_api.glReadBuffer(GL.GL_COLOR_ATTACHMENT0);
    }
    gl_api.glGenBuffers(1,*record.reader.pbo); if !record.reader.pbo return false;
    gl_api.glBindBuffer(GL.GL_PIXEL_PACK_BUFFER,record.reader.pbo);
    gl_api.glBufferData(GL.GL_PIXEL_PACK_BUFFER,record.raw.data.count,null,GL.GL_STREAM_READ);
    gl_api.glPixelStorei(GL.GL_PACK_ALIGNMENT,1); gl_api.glPixelStorei(GL.GL_PACK_ROW_LENGTH,0);
    gl_api.glReadPixels(0,0,record.raw.width,record.raw.height,GL.GL_RGBA,GL.GL_UNSIGNED_BYTE,null);
    if gl_api.glGetError()!=GL.GL_NO_ERROR return false;
    record.fence=gl_api.glFenceSync(GL.GL_SYNC_GPU_COMMANDS_COMPLETE,0);
    if !record.fence return false;
    gl_api.glFlush(); return true;
}
gl_readback_finish :: (record:*Pixel_Read_Record) {
    while true {
        result:=gl_api.glClientWaitSync(record.fence,GL.GL_SYNC_FLUSH_COMMANDS_BIT,1_000_000_000);
        if result==GL.GL_WAIT_FAILED { record.failed=true; return; }
        if result==GL.GL_ALREADY_SIGNALED||result==GL.GL_CONDITION_SATISFIED break;
    }
    old_buffer:s32; gl_api.glGetIntegerv(GL.GL_PIXEL_PACK_BUFFER_BINDING,*old_buffer);
    gl_api.glBindBuffer(GL.GL_PIXEL_PACK_BUFFER,record.reader.pbo);
    defer gl_api.glBindBuffer(GL.GL_PIXEL_PACK_BUFFER,cast(u32)old_buffer);
    mapped:=gl_api.glMapBufferRange(GL.GL_PIXEL_PACK_BUFFER,0,record.raw.data.count,GL.GL_MAP_READ_BIT);
    if !mapped { record.failed=true; return; }
    memcpy(record.raw.data.data,mapped,record.raw.data.count);
    if !gl_api.glUnmapBuffer(GL.GL_PIXEL_PACK_BUFFER) { record.failed=true; return; }
    record.done=true;
}
}
