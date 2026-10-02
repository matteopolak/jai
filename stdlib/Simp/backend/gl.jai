#scope_module
GL :: #import "GL";
gl_api: *GL.GL_Procedures;
gl_vertex_array: u32;
gl_vertex_buffer: u32;
Shader_Pointer :: *Shader;
// Caller makes its trusted native context current before every target switch.
#scope_export
opengl_make_window_current: (window: Window_Type) -> bool = null;
initialize_opengl_renderer :: (procs: *GL.GL_Procedures) -> bool {
    if !procs || !procs.glCreateShader || !procs.glShaderSource || !procs.glGenVertexArrays || !procs.glBufferData return false;
    gl_api=procs;
    gl_api.glGenVertexArrays(1,*gl_vertex_array); gl_api.glGenBuffers(1,*gl_vertex_buffer);
    if !gl_vertex_array || !gl_vertex_buffer return false;
    shaders:=Shader_Pointer.[*shader_color,*shader_color_with_blend,*shader_sprite,*shader_text_normal,*shader_text_lcd,*shader_rounded_rect,*shader_gradient];
    bodies:=string.[fragment_color,fragment_color,fragment_image,fragment_text,fragment_text,fragment_rounded,fragment_gradient];
    for shader,i:shaders {
        if !gl_build_program(shader,bodies[i]) { shutdown_opengl_renderer(); return false; }
    }
    return true;
}
shutdown_opengl_renderer :: () {
    if !gl_api return;
    shaders:=Shader_Pointer.[*shader_color,*shader_color_with_blend,*shader_sprite,*shader_text_normal,*shader_text_lcd,*shader_rounded_rect,*shader_gradient];
    for shader:shaders { if shader.gl_handle gl_api.glDeleteProgram(shader.gl_handle); shader.gl_handle=0; }
    if gl_vertex_buffer gl_api.glDeleteBuffers(1,*gl_vertex_buffer);
    if gl_vertex_array gl_api.glDeleteVertexArrays(1,*gl_vertex_array);
    gl_vertex_buffer=0; gl_vertex_array=0; gl_api=null;
}
#scope_module
gl_clear_target :: (r:float,g:float,b:float,a:float) {
    assert(gl_api!=null&&gl_api.glClearColor&&gl_api.glClear,"Initialize the OpenGL clear procedures");
    if !gl_api||!gl_api.glClearColor||!gl_api.glClear return;
    gl_api.glClearColor(r,g,b,a); gl_api.glClear(GL.GL_COLOR_BUFFER_BIT);
}
gl_select_window :: (info:*Window_Info) {
    assert(gl_api != null, "Initialize the Simp OpenGL renderer before selecting a target");
    if !gl_api return;
    if opengl_make_window_current assert(opengl_make_window_current(info.window), "Could not make the window's graphics context current");
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER,0);
    gl_api.glViewport(0,0,cast(u32)info.window_width,cast(u32)info.window_height);
    info.backend_initted_for_this_window=true;
}
gl_select_texture :: (texture:*Texture) {
    record:=texture_record(texture,false);
    assert(gl_api != null && record != null && record.framebuffer != 0, "Texture has no native framebuffer");
    if !gl_api || !record || !record.framebuffer return;
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER,record.framebuffer);
    gl_api.glViewport(0,0,cast(u32)texture.width,cast(u32)texture.height);
}
gl_compile :: (kind:u32,source:string)->u32 {
    shader:=gl_api.glCreateShader(kind); if !shader return 0;
    pointer:=source.data; length:=cast(s32)source.count;
    gl_api.glShaderSource(shader,1,*pointer,*length); gl_api.glCompileShader(shader);
    status:s32; gl_api.glGetShaderiv(shader,GL.GL_COMPILE_STATUS,*status);
    if !status { gl_api.glDeleteShader(shader); return 0; }
    return shader;
}
gl_build_program :: (shader:*Shader,fragment:string)->bool {
    vertex:=gl_compile(GL.GL_VERTEX_SHADER,vertex_source); if !vertex return false;
    defer gl_api.glDeleteShader(vertex);
    pixel:=gl_compile(GL.GL_FRAGMENT_SHADER,fragment); if !pixel return false;
    defer gl_api.glDeleteShader(pixel);
    program:=gl_api.glCreateProgram(); if !program return false;
    gl_api.glAttachShader(program,vertex); gl_api.glAttachShader(program,pixel); gl_api.glLinkProgram(program);
    linked:s32; gl_api.glGetProgramiv(program,GL.GL_LINK_STATUS,*linked);
    if !linked { gl_api.glDeleteProgram(program); return false; }
    shader.gl_handle=program;
    shader.position_loc=0; shader.color_scale_loc=1; shader.uv_0_loc=2;
    shader.rect_center_loc=3; shader.rect_size_loc=4; shader.rect_corner_radius_loc=5; shader.rect_edge_softness_loc=6;
    return true;
}
gl_use_shader :: (shader:*Shader) {
    assert(gl_api != null && shader != null && shader.gl_handle != 0, "Shader has no native program");
    if !gl_api || !shader || !shader.gl_handle return;
    gl_api.glUseProgram(shader.gl_handle);
    if shader.alpha_blend { gl_api.glEnable(GL.GL_BLEND); gl_api.glBlendFuncSeparate(GL.GL_SRC_ALPHA,GL.GL_ONE_MINUS_SRC_ALPHA,GL.GL_ONE,GL.GL_ONE_MINUS_SRC_ALPHA); }
    else gl_api.glDisable(GL.GL_BLEND);
}
gl_set_projection :: (width:s32,height:s32) {
    if !context.simp.current_shader || !gl_api || width<=0 || height<=0 return;
    location:=get_uniform_location(context.simp.current_shader.gl_handle,"target_size");
    if location>=0 gl_api.glUniform2f(location,cast(float)width,cast(float)height);
}
gl_bind_texture :: (texture:*Texture) {
    if !gl_api return;
    gl_api.glActiveTexture(GL.GL_TEXTURE0);
    gl_api.glBindTexture(GL.GL_TEXTURE_2D,ifx texture then texture.gl_handle else 0);
    if context.simp.current_shader {
        location:=get_uniform_location(context.simp.current_shader.gl_handle,"image");
        if location>=0 gl_api.glUniform1i(location,0);
    }
}
gl_apply_scissor :: () {
    if !gl_api return;
    if !context.simp.specific.scissor_enabled { gl_api.glDisable(GL.GL_SCISSOR_TEST); return; }
    rect:=context.simp.specific.scissor;
    gl_api.glEnable(GL.GL_SCISSOR_TEST);
    gl_api.glScissor(cast(s32)rect.x,cast(s32)rect.y,cast(u32)max(rect.z-rect.x,0.0),cast(u32)max(rect.w-rect.y,0.0));
}
gl_vertex_format :: (shader:*Shader) {
    gl_api.glBindVertexArray(gl_vertex_array); gl_api.glBindBuffer(GL.GL_ARRAY_BUFFER,gl_vertex_buffer);
    offsets:=s64.[0,size_of(Vector2),size_of(Vector2)+size_of(Vector4),size_of(Vector2)*2+size_of(Vector4),size_of(Vector2)*3+size_of(Vector4),size_of(Vector2)*4+size_of(Vector4),size_of(Vector2)*4+size_of(Vector4)+size_of(float)];
    sizes:=s32.[2,4,2,2,2,1,1];
    for i:0..6 {
        gl_api.glEnableVertexAttribArray(cast(u32)i);
        gl_api.glVertexAttribPointer(cast(u32)i,sizes[i],GL.GL_FLOAT,false,size_of(Immediate_Vertex),cast(*void)offsets[i]);
    }
}
gl_submit :: (state:*Immediate_State) {
    assert(gl_api != null && state.current_shader.gl_handle != 0, "Simp OpenGL renderer is not initialized");
    if !gl_api || !state.current_shader.gl_handle return;
    gl_vertex_format(state.current_shader);
    gl_api.glBufferData(GL.GL_ARRAY_BUFFER,state.num_vertices*size_of(Immediate_Vertex),*state.vertices[0],GL.GL_STREAM_DRAW);
    gl_api.glDrawArrays(GL.GL_TRIANGLES,0,cast(u32)state.num_vertices);
}
gl_texture_format :: (format:Texture_Format)->u32,u32,u32 {
    if format==.R8 return GL.GL_R8,GL.GL_RED,GL.GL_UNSIGNED_BYTE;
    if format==.RG8 return GL.GL_RG8,GL.GL_RG,GL.GL_UNSIGNED_BYTE;
    if format==.RGB8 return GL.GL_RGB8,GL.GL_RGB,GL.GL_UNSIGNED_BYTE;
    if format==.RGBA8 return GL.GL_RGBA8,GL.GL_RGBA,GL.GL_UNSIGNED_BYTE;
    if format==.BGRA8 return GL.GL_RGBA8,GL.GL_BGRA,GL.GL_UNSIGNED_BYTE;
    if format==.R16F return GL.GL_R16F,GL.GL_RED,GL.GL_HALF_FLOAT;
    if format==.RG16F return GL.GL_RG16F,GL.GL_RG,GL.GL_HALF_FLOAT;
    if format==.RGBA16F return GL.GL_RGBA16F,GL.GL_RGBA,GL.GL_HALF_FLOAT;
    if format==.R32F return GL.GL_R32F,GL.GL_RED,GL.GL_FLOAT;
    if format==.RG32F return GL.GL_RG32F,GL.GL_RG,GL.GL_FLOAT;
    if format==.RGBA32F return GL.GL_RGBA32F,GL.GL_RGBA,GL.GL_FLOAT;
    return 0,0,0;
}
gl_upload_texture :: (texture:*Texture,bitmap:*Bitmap)->bool {
    if !gl_api return false;
    internal,external,type:=gl_texture_format(bitmap.format); if !internal return false;
    if bitmap.flags & .IS_SRGB {
        if bitmap.format==.RGB8 internal=GL.GL_SRGB8;
        if bitmap.format==.RGBA8||bitmap.format==.BGRA8 internal=GL.GL_SRGB8_ALPHA8;
    }
    if !texture.gl_handle gl_api.glGenTextures(1,*texture.gl_handle);
    if !texture.gl_handle return false;
    gl_api.glBindTexture(GL.GL_TEXTURE_2D,texture.gl_handle);
    gl_api.glPixelStorei(GL.GL_UNPACK_ALIGNMENT,1);
    w:=bitmap.width; h:=bitmap.height; offset:int;
    for level:0..bitmap.mipmap_count-1 {
        stride:=w*get_image_bytes_per_texel(bitmap.format); if level==0 stride=bitmap.stride;
        bytes:=stride*h; if offset+bytes>bitmap.data.count return false;
        gl_api.glPixelStorei(GL.GL_UNPACK_ROW_LENGTH,stride/cast(s32)get_image_bytes_per_texel(bitmap.format));
        gl_api.glTexImage2D(GL.GL_TEXTURE_2D,level,cast(s32)internal,cast(u32)w,cast(u32)h,0,external,type,bitmap.data.data+offset);
        offset+=bytes; w=max(w/2,1); h=max(h/2,1);
    }
    gl_api.glPixelStorei(GL.GL_UNPACK_ROW_LENGTH,0);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_MIN_FILTER,ifx bitmap.mipmap_count>1 then GL.GL_LINEAR_MIPMAP_LINEAR else GL.GL_LINEAR);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_MAG_FILTER,GL.GL_LINEAR);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_WRAP_S,GL.GL_CLAMP_TO_EDGE);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_WRAP_T,GL.GL_CLAMP_TO_EDGE);
    return gl_api.glGetError()==GL.GL_NO_ERROR;
}
gl_create_render_target :: (texture:*Texture)->bool {
    if !gl_api return false;
    bitmap:Bitmap; bitmap_alloc(*bitmap,texture.width,texture.height,texture.format); defer deinit(*bitmap);
    if !gl_upload_texture(texture,*bitmap) return false;
    record:=texture_record(texture,true);
    gl_api.glGenFramebuffers(1,*record.framebuffer);
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER,record.framebuffer);
    gl_api.glFramebufferTexture2D(GL.GL_FRAMEBUFFER,GL.GL_COLOR_ATTACHMENT0,GL.GL_TEXTURE_2D,texture.gl_handle,0);
    success:=gl_api.glCheckFramebufferStatus(GL.GL_FRAMEBUFFER)==GL.GL_FRAMEBUFFER_COMPLETE;
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER,0);
    if !success gl_delete_texture(texture);
    return success;
}
gl_delete_texture :: (texture:*Texture) {
    if !gl_api return;
    record:=texture_record(texture,false);
    if record && record.framebuffer { gl_api.glDeleteFramebuffers(1,*record.framebuffer); record.framebuffer=0; }
    if texture.gl_handle { gl_api.glDeleteTextures(1,*texture.gl_handle); texture.gl_handle=0; }
}
gl_set_gradient :: (rect:Vector4,mode:u8,value:float) {
    gl_api.glUniform4f(get_uniform_location(shader_gradient.gl_handle,"gradient_rect"),rect.x,rect.y,rect.z,rect.w);
    gl_api.glUniform1i(get_uniform_location(shader_gradient.gl_handle,"gradient_mode"),mode);
    gl_api.glUniform1f(get_uniform_location(shader_gradient.gl_handle,"gradient_value"),value);
}
vertex_source :: "#version 330 core\nlayout(location=0) in vec2 position; layout(location=1) in vec4 color; layout(location=2) in vec2 uv; layout(location=3) in vec2 center; layout(location=4) in vec2 rect_size; layout(location=5) in float radius; layout(location=6) in float softness; uniform vec2 target_size; out vec4 tint; out vec2 texcoord; out vec2 point; out vec2 rc; out vec2 rs; out float rr; out float re; void main(){gl_Position=vec4(position/target_size*2.0-1.0,0,1); tint=color; texcoord=uv; point=position; rc=center; rs=rect_size; rr=radius; re=softness;}";
fragment_color :: "#version 330 core\nin vec4 tint; out vec4 pixel; void main(){pixel=tint;}";
fragment_image :: "#version 330 core\nin vec4 tint; in vec2 texcoord; uniform sampler2D image; out vec4 pixel; void main(){pixel=tint*texture(image,vec2(texcoord.x,1.0-texcoord.y));}";
fragment_text :: "#version 330 core\nin vec4 tint; in vec2 texcoord; uniform sampler2D image; out vec4 pixel; void main(){vec3 mask=texture(image,texcoord).rgb; pixel=vec4(tint.rgb,tint.a*dot(mask,vec3(1.0/3.0)));}";
fragment_rounded :: "#version 330 core\nin vec4 tint; in vec2 point; in vec2 rc; in vec2 rs; in float rr; in float re; out vec4 pixel; void main(){vec2 q=abs(point-rc)-rs+rr; float d=length(max(q,0))+min(max(q.x,q.y),0)-rr; float soft=clamp(d/max(re,0.001),0,1); pixel=vec4(tint.rgb,tint.a*(1-soft*soft*(3-2*soft)));}";
fragment_gradient :: "#version 330 core\nin vec4 tint; in vec2 point; uniform vec4 gradient_rect; uniform int gradient_mode; uniform float gradient_value; out vec4 pixel; vec3 hsl(float h,float s,float l){vec3 k=mod(vec3(0,8,4)+h*12,12); float a=s*min(l,1-l); return l-a*max(vec3(-1),min(k-3,min(9-k,vec3(1))));} void main(){vec2 uv=clamp((point-gradient_rect.xy)/max(gradient_rect.zw,vec2(0.001)),0,1); float z=gradient_value; int kind=gradient_mode&15; vec3 rgb=vec3(0); if(gradient_mode<16){if(kind==0)rgb=vec3(z,uv); if(kind==1)rgb=vec3(uv.x,z,uv.y); if(kind==2)rgb=vec3(uv,z); if(kind==3)rgb=hsl(z,uv.x,uv.y); if(kind==4)rgb=hsl(uv.x,z,uv.y); if(kind==5)rgb=hsl(uv.x,uv.y,z);}else{float t=(gradient_mode&32)!=0?uv.x:uv.y; if(kind==0)rgb=vec3(t,0,0); if(kind==1)rgb=vec3(0,t,0); if(kind==2)rgb=vec3(0,0,t); if(kind==3)rgb=hsl(t,1,0.5); if(kind==4)rgb=hsl(z,t,0.5); if(kind==5)rgb=hsl(z,1,t); if(kind==6)rgb=vec3(t);} pixel=vec4(rgb,tint.a);}";
