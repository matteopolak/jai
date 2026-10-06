// Independent counted-string, shader diagnostic, label and debug callbacks.
_glShaderSource :: (shader: GLuint, source: string) {
    Basic.assert(source.count <= 0x7fff_ffff);
    data := source.data;
    count := cast(GLint) source.count;
    glShaderSource(shader, 1, *data, *count);
}
_glShaderSource :: (shader: GLuint, sources: [] string) {
    Basic.assert(sources.count <= 0x7fff_ffff);
    if sources.count == 0 {
        glShaderSource(shader, 0, null, null);
        return;
    }
    pointers := cast(**u8) Basic.temporary_alloc(sources.count * size_of(*u8));
    lengths := cast(*GLint) Basic.temporary_alloc(sources.count * size_of(GLint));
    Basic.assert(pointers != null && lengths != null);
    for index: 0..sources.count - 1 {
        Basic.assert(sources[index].count <= 0x7fff_ffff);
        pointers[index] = sources[index].data;
        lengths[index] = cast(GLint) sources[index].count;
    }
    glShaderSource(shader, cast(GLsizei) sources.count, pointers, lengths);
}
_glGetUniformLocation :: (program: u32, $$name: string) -> s32 {
    return glGetUniformLocation(program, Basic.temp_c_string(name));
}
_glBindAttribLocation :: (program: u32, index: u32, $$name: string) {
    glBindAttribLocation(program, index, Basic.temp_c_string(name));
}
_glGetAttribLocation :: (program: GLuint, $$name: string) -> GLint {
    return glGetAttribLocation(program, Basic.temp_c_string(name));
}
gl_label_object :: (identifier: GLenum, name: GLuint, label: string) {
    if glObjectLabel == null return;
    Basic.assert(label.count <= 0x7fff_ffff);
    glObjectLabel(identifier, name, cast(GLsizei) label.count, label.data);
}
DumpShaderInfoLog :: (shader: GLuint, name: string) {
    size: GLint = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, *size);
    if size <= 1 return;
    bytes := cast(*u8) Basic.temporary_alloc(size);
    Basic.assert(bytes != null);
    written: GLsizei = 0;
    glGetShaderInfoLog(shader, size, *written, bytes);
    if written > 0 Basic.log("Shader %: %\n", name, Basic.to_string(bytes, written));
}
DumpProgramInfoLog :: (program: GLuint, name: string) {
    size: GLint = 0;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, *size);
    if size <= 1 return;
    bytes := cast(*u8) Basic.temporary_alloc(size);
    Basic.assert(bytes != null);
    written: GLsizei = 0;
    glGetProgramInfoLog(program, size, *written, bytes);
    if written > 0 Basic.log("Program %: %\n", name, Basic.to_string(bytes, written));
}
gl_enable_debug_output :: (break_on_error: bool = false) {
    if glDebugMessageCallback == null return;
    debug_log_params.break_on_error = break_on_error;
    debug_log_params.logger = context.logger;
    __gl_debug_logger_data = context.logger_data;
    glEnable(GL_DEBUG_OUTPUT);
    glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS);
    glDebugMessageCallback(gl_debug_log, *debug_log_params);
    is_debug_context = true;
}
#if DUMP_GL_ERRORS {
    DumpGLErrors :: (tag: string, loc := #caller_location) -> bool {
        any_error := false;
        // A bad context/driver must not trap the application in an endless log.
        for 0..1023 {
            error := glGetError();
            if error == GL_NO_ERROR return any_error;
            any_error = true;
            Basic.log_error("OpenGL error % at %\n", error, tag, loc = loc);
        }
        return any_error;
    }
} else {
    DumpGLErrors :: (#discard tag: string, #discard loc := #caller_location) -> bool {
        return false;
    }
}

#scope_file
Basic :: #import "Basic";
is_debug_context: bool;
debug_log_params: struct {
    break_on_error: bool;
    logger: Basic.Logger;
};
__gl_debug_logger_data: *void;
get_string_for_type :: (type: GLenum) -> string {
    if type == GL_DEBUG_TYPE_ERROR return "API error";
    if type == GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR return "Deprecated behavior";
    if type == GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR return "Undefined behavior";
    if type == GL_DEBUG_TYPE_PORTABILITY return "Portability";
    if type == GL_DEBUG_TYPE_PERFORMANCE return "Performance";
    return "Other";
}
get_string_for_source :: (source: GLenum) -> string {
    if source == GL_DEBUG_SOURCE_API return "GL API";
    if source == GL_DEBUG_SOURCE_WINDOW_SYSTEM return "Window system";
    if source == GL_DEBUG_SOURCE_SHADER_COMPILER return "Shader compiler";
    if source == GL_DEBUG_SOURCE_THIRD_PARTY return "Third party";
    if source == GL_DEBUG_SOURCE_APPLICATION return "Application";
    return "Other";
}
get_string_for_severity :: (severity: GLenum) -> string {
    if severity == GL_DEBUG_SEVERITY_HIGH return "High";
    if severity == GL_DEBUG_SEVERITY_MEDIUM return "Medium";
    if severity == GL_DEBUG_SEVERITY_LOW return "Low";
    return "Notification";
}
gl_debug_log :: (source: GLenum, type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: *u8, userParam: *void) #c_call {
    push_context {
        context.logger = debug_log_params.logger;
        context.logger_data = __gl_debug_logger_data;
        if message != null && cast,no_check(s32) length >= 0 {
            Basic.log("GL %/%/% [%]: %\n", get_string_for_source(source), get_string_for_type(type), get_string_for_severity(severity), id, Basic.to_string(message, length));
        }
        if type == GL_DEBUG_TYPE_ERROR && debug_log_params.break_on_error Basic.debug_break();
    }
}
