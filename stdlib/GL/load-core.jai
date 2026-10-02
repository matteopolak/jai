// Explicit assignments generated from authored ABI fields and current canonical GL names.
gl_load :: (procs: *GL_Procedures, GetProcAddress: GetProcAddressFunction = null) {
    if GetProcAddress == null GetProcAddress = _gl_platform_get_proc;
    #if OS == .LINUX {
        __gl_swap_interval_ext = cast(type_of(__gl_swap_interval_ext)) GetProcAddress(cast(*u8) "glXSwapIntervalEXT\0");
        __gl_swap_interval_mesa = cast(type_of(__gl_swap_interval_mesa)) GetProcAddress(cast(*u8) "glXSwapIntervalMESA\0");
        procs.glXSwapIntervalEXT = null;
        procs.glXSwapIntervalMESA = null;
        if __gl_swap_interval_ext procs.glXSwapIntervalEXT = _gl_swap_interval_ext_compat;
        if __gl_swap_interval_mesa procs.glXSwapIntervalMESA = _gl_swap_interval_mesa_compat;
        procs.glXSwapIntervalSGI = cast(type_of(procs.glXSwapIntervalSGI)) GetProcAddress(cast(*u8) "glXSwapIntervalSGI\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glCullFace = cast(type_of(procs.glCullFace)) GetProcAddress(cast(*u8) "glCullFace\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glFrontFace = cast(type_of(procs.glFrontFace)) GetProcAddress(cast(*u8) "glFrontFace\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glHint = cast(type_of(procs.glHint)) GetProcAddress(cast(*u8) "glHint\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glLineWidth = cast(type_of(procs.glLineWidth)) GetProcAddress(cast(*u8) "glLineWidth\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glPointSize = cast(type_of(procs.glPointSize)) GetProcAddress(cast(*u8) "glPointSize\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glPolygonMode = cast(type_of(procs.glPolygonMode)) GetProcAddress(cast(*u8) "glPolygonMode\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glScissor = cast(type_of(procs.glScissor)) GetProcAddress(cast(*u8) "glScissor\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexParameterf = cast(type_of(procs.glTexParameterf)) GetProcAddress(cast(*u8) "glTexParameterf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexParameterfv = cast(type_of(procs.glTexParameterfv)) GetProcAddress(cast(*u8) "glTexParameterfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexParameteri = cast(type_of(procs.glTexParameteri)) GetProcAddress(cast(*u8) "glTexParameteri\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexParameteriv = cast(type_of(procs.glTexParameteriv)) GetProcAddress(cast(*u8) "glTexParameteriv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexImage1D = cast(type_of(procs.glTexImage1D)) GetProcAddress(cast(*u8) "glTexImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexImage2D = cast(type_of(procs.glTexImage2D)) GetProcAddress(cast(*u8) "glTexImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDrawBuffer = cast(type_of(procs.glDrawBuffer)) GetProcAddress(cast(*u8) "glDrawBuffer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glClear = cast(type_of(procs.glClear)) GetProcAddress(cast(*u8) "glClear\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glClearColor = cast(type_of(procs.glClearColor)) GetProcAddress(cast(*u8) "glClearColor\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glClearStencil = cast(type_of(procs.glClearStencil)) GetProcAddress(cast(*u8) "glClearStencil\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glClearDepth = cast(type_of(procs.glClearDepth)) GetProcAddress(cast(*u8) "glClearDepth\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glStencilMask = cast(type_of(procs.glStencilMask)) GetProcAddress(cast(*u8) "glStencilMask\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glColorMask = cast(type_of(procs.glColorMask)) GetProcAddress(cast(*u8) "glColorMask\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDepthMask = cast(type_of(procs.glDepthMask)) GetProcAddress(cast(*u8) "glDepthMask\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDisable = cast(type_of(procs.glDisable)) GetProcAddress(cast(*u8) "glDisable\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glEnable = cast(type_of(procs.glEnable)) GetProcAddress(cast(*u8) "glEnable\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glFinish = cast(type_of(procs.glFinish)) GetProcAddress(cast(*u8) "glFinish\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glFlush = cast(type_of(procs.glFlush)) GetProcAddress(cast(*u8) "glFlush\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glBlendFunc = cast(type_of(procs.glBlendFunc)) GetProcAddress(cast(*u8) "glBlendFunc\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glLogicOp = cast(type_of(procs.glLogicOp)) GetProcAddress(cast(*u8) "glLogicOp\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glStencilFunc = cast(type_of(procs.glStencilFunc)) GetProcAddress(cast(*u8) "glStencilFunc\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glStencilOp = cast(type_of(procs.glStencilOp)) GetProcAddress(cast(*u8) "glStencilOp\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDepthFunc = cast(type_of(procs.glDepthFunc)) GetProcAddress(cast(*u8) "glDepthFunc\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glPixelStoref = cast(type_of(procs.glPixelStoref)) GetProcAddress(cast(*u8) "glPixelStoref\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glPixelStorei = cast(type_of(procs.glPixelStorei)) GetProcAddress(cast(*u8) "glPixelStorei\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glReadBuffer = cast(type_of(procs.glReadBuffer)) GetProcAddress(cast(*u8) "glReadBuffer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glReadPixels = cast(type_of(procs.glReadPixels)) GetProcAddress(cast(*u8) "glReadPixels\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetBooleanv = cast(type_of(procs.glGetBooleanv)) GetProcAddress(cast(*u8) "glGetBooleanv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetDoublev = cast(type_of(procs.glGetDoublev)) GetProcAddress(cast(*u8) "glGetDoublev\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetError = cast(type_of(procs.glGetError)) GetProcAddress(cast(*u8) "glGetError\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetFloatv = cast(type_of(procs.glGetFloatv)) GetProcAddress(cast(*u8) "glGetFloatv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetIntegerv = cast(type_of(procs.glGetIntegerv)) GetProcAddress(cast(*u8) "glGetIntegerv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetString = cast(type_of(procs.glGetString)) GetProcAddress(cast(*u8) "glGetString\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetTexImage = cast(type_of(procs.glGetTexImage)) GetProcAddress(cast(*u8) "glGetTexImage\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetTexParameterfv = cast(type_of(procs.glGetTexParameterfv)) GetProcAddress(cast(*u8) "glGetTexParameterfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetTexParameteriv = cast(type_of(procs.glGetTexParameteriv)) GetProcAddress(cast(*u8) "glGetTexParameteriv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetTexLevelParameterfv = cast(type_of(procs.glGetTexLevelParameterfv)) GetProcAddress(cast(*u8) "glGetTexLevelParameterfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGetTexLevelParameteriv = cast(type_of(procs.glGetTexLevelParameteriv)) GetProcAddress(cast(*u8) "glGetTexLevelParameteriv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glIsEnabled = cast(type_of(procs.glIsEnabled)) GetProcAddress(cast(*u8) "glIsEnabled\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDepthRange = cast(type_of(procs.glDepthRange)) GetProcAddress(cast(*u8) "glDepthRange\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glViewport = cast(type_of(procs.glViewport)) GetProcAddress(cast(*u8) "glViewport\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDrawArrays = cast(type_of(procs.glDrawArrays)) GetProcAddress(cast(*u8) "glDrawArrays\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDrawElements = cast(type_of(procs.glDrawElements)) GetProcAddress(cast(*u8) "glDrawElements\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glPolygonOffset = cast(type_of(procs.glPolygonOffset)) GetProcAddress(cast(*u8) "glPolygonOffset\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glCopyTexImage1D = cast(type_of(procs.glCopyTexImage1D)) GetProcAddress(cast(*u8) "glCopyTexImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glCopyTexImage2D = cast(type_of(procs.glCopyTexImage2D)) GetProcAddress(cast(*u8) "glCopyTexImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glCopyTexSubImage1D = cast(type_of(procs.glCopyTexSubImage1D)) GetProcAddress(cast(*u8) "glCopyTexSubImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glCopyTexSubImage2D = cast(type_of(procs.glCopyTexSubImage2D)) GetProcAddress(cast(*u8) "glCopyTexSubImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexSubImage1D = cast(type_of(procs.glTexSubImage1D)) GetProcAddress(cast(*u8) "glTexSubImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glTexSubImage2D = cast(type_of(procs.glTexSubImage2D)) GetProcAddress(cast(*u8) "glTexSubImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glBindTexture = cast(type_of(procs.glBindTexture)) GetProcAddress(cast(*u8) "glBindTexture\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glDeleteTextures = cast(type_of(procs.glDeleteTextures)) GetProcAddress(cast(*u8) "glDeleteTextures\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glGenTextures = cast(type_of(procs.glGenTextures)) GetProcAddress(cast(*u8) "glGenTextures\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
    procs.glIsTexture = cast(type_of(procs.glIsTexture)) GetProcAddress(cast(*u8) "glIsTexture\0");
    }
    procs.glDrawRangeElements = cast(type_of(procs.glDrawRangeElements)) GetProcAddress(cast(*u8) "glDrawRangeElements\0");
    procs.glTexImage3D = cast(type_of(procs.glTexImage3D)) GetProcAddress(cast(*u8) "glTexImage3D\0");
    procs.glTexSubImage3D = cast(type_of(procs.glTexSubImage3D)) GetProcAddress(cast(*u8) "glTexSubImage3D\0");
    procs.glCopyTexSubImage3D = cast(type_of(procs.glCopyTexSubImage3D)) GetProcAddress(cast(*u8) "glCopyTexSubImage3D\0");
    procs.glActiveTexture = cast(type_of(procs.glActiveTexture)) GetProcAddress(cast(*u8) "glActiveTexture\0");
    procs.glSampleCoverage = cast(type_of(procs.glSampleCoverage)) GetProcAddress(cast(*u8) "glSampleCoverage\0");
    procs.glCompressedTexImage3D = cast(type_of(procs.glCompressedTexImage3D)) GetProcAddress(cast(*u8) "glCompressedTexImage3D\0");
    procs.glCompressedTexImage2D = cast(type_of(procs.glCompressedTexImage2D)) GetProcAddress(cast(*u8) "glCompressedTexImage2D\0");
    procs.glCompressedTexImage1D = cast(type_of(procs.glCompressedTexImage1D)) GetProcAddress(cast(*u8) "glCompressedTexImage1D\0");
    procs.glCompressedTexSubImage3D = cast(type_of(procs.glCompressedTexSubImage3D)) GetProcAddress(cast(*u8) "glCompressedTexSubImage3D\0");
    procs.glCompressedTexSubImage2D = cast(type_of(procs.glCompressedTexSubImage2D)) GetProcAddress(cast(*u8) "glCompressedTexSubImage2D\0");
    procs.glCompressedTexSubImage1D = cast(type_of(procs.glCompressedTexSubImage1D)) GetProcAddress(cast(*u8) "glCompressedTexSubImage1D\0");
    procs.glGetCompressedTexImage = cast(type_of(procs.glGetCompressedTexImage)) GetProcAddress(cast(*u8) "glGetCompressedTexImage\0");
    procs.glBlendFuncSeparate = cast(type_of(procs.glBlendFuncSeparate)) GetProcAddress(cast(*u8) "glBlendFuncSeparate\0");
    procs.glMultiDrawArrays = cast(type_of(procs.glMultiDrawArrays)) GetProcAddress(cast(*u8) "glMultiDrawArrays\0");
    procs.glMultiDrawElements = cast(type_of(procs.glMultiDrawElements)) GetProcAddress(cast(*u8) "glMultiDrawElements\0");
    procs.glPointParameterf = cast(type_of(procs.glPointParameterf)) GetProcAddress(cast(*u8) "glPointParameterf\0");
    procs.glPointParameterfv = cast(type_of(procs.glPointParameterfv)) GetProcAddress(cast(*u8) "glPointParameterfv\0");
    procs.glPointParameteri = cast(type_of(procs.glPointParameteri)) GetProcAddress(cast(*u8) "glPointParameteri\0");
    procs.glPointParameteriv = cast(type_of(procs.glPointParameteriv)) GetProcAddress(cast(*u8) "glPointParameteriv\0");
    procs.glBlendColor = cast(type_of(procs.glBlendColor)) GetProcAddress(cast(*u8) "glBlendColor\0");
    procs.glBlendEquation = cast(type_of(procs.glBlendEquation)) GetProcAddress(cast(*u8) "glBlendEquation\0");
    procs.glGenQueries = cast(type_of(procs.glGenQueries)) GetProcAddress(cast(*u8) "glGenQueries\0");
    procs.glDeleteQueries = cast(type_of(procs.glDeleteQueries)) GetProcAddress(cast(*u8) "glDeleteQueries\0");
    procs.glIsQuery = cast(type_of(procs.glIsQuery)) GetProcAddress(cast(*u8) "glIsQuery\0");
    procs.glBeginQuery = cast(type_of(procs.glBeginQuery)) GetProcAddress(cast(*u8) "glBeginQuery\0");
    procs.glEndQuery = cast(type_of(procs.glEndQuery)) GetProcAddress(cast(*u8) "glEndQuery\0");
    procs.glGetQueryiv = cast(type_of(procs.glGetQueryiv)) GetProcAddress(cast(*u8) "glGetQueryiv\0");
    procs.glGetQueryObjectiv = cast(type_of(procs.glGetQueryObjectiv)) GetProcAddress(cast(*u8) "glGetQueryObjectiv\0");
    procs.glGetQueryObjectuiv = cast(type_of(procs.glGetQueryObjectuiv)) GetProcAddress(cast(*u8) "glGetQueryObjectuiv\0");
    procs.glBindBuffer = cast(type_of(procs.glBindBuffer)) GetProcAddress(cast(*u8) "glBindBuffer\0");
    procs.glDeleteBuffers = cast(type_of(procs.glDeleteBuffers)) GetProcAddress(cast(*u8) "glDeleteBuffers\0");
    procs.glGenBuffers = cast(type_of(procs.glGenBuffers)) GetProcAddress(cast(*u8) "glGenBuffers\0");
    procs.glIsBuffer = cast(type_of(procs.glIsBuffer)) GetProcAddress(cast(*u8) "glIsBuffer\0");
    procs.glBufferData = cast(type_of(procs.glBufferData)) GetProcAddress(cast(*u8) "glBufferData\0");
    procs.glBufferSubData = cast(type_of(procs.glBufferSubData)) GetProcAddress(cast(*u8) "glBufferSubData\0");
    procs.glGetBufferSubData = cast(type_of(procs.glGetBufferSubData)) GetProcAddress(cast(*u8) "glGetBufferSubData\0");
    procs.glMapBuffer = cast(type_of(procs.glMapBuffer)) GetProcAddress(cast(*u8) "glMapBuffer\0");
    procs.glUnmapBuffer = cast(type_of(procs.glUnmapBuffer)) GetProcAddress(cast(*u8) "glUnmapBuffer\0");
    procs.glGetBufferParameteriv = cast(type_of(procs.glGetBufferParameteriv)) GetProcAddress(cast(*u8) "glGetBufferParameteriv\0");
    procs.glGetBufferPointerv = cast(type_of(procs.glGetBufferPointerv)) GetProcAddress(cast(*u8) "glGetBufferPointerv\0");
    procs.glBlendEquationSeparate = cast(type_of(procs.glBlendEquationSeparate)) GetProcAddress(cast(*u8) "glBlendEquationSeparate\0");
    procs.glDrawBuffers = cast(type_of(procs.glDrawBuffers)) GetProcAddress(cast(*u8) "glDrawBuffers\0");
    procs.glStencilOpSeparate = cast(type_of(procs.glStencilOpSeparate)) GetProcAddress(cast(*u8) "glStencilOpSeparate\0");
    procs.glStencilFuncSeparate = cast(type_of(procs.glStencilFuncSeparate)) GetProcAddress(cast(*u8) "glStencilFuncSeparate\0");
    procs.glStencilMaskSeparate = cast(type_of(procs.glStencilMaskSeparate)) GetProcAddress(cast(*u8) "glStencilMaskSeparate\0");
    procs.glAttachShader = cast(type_of(procs.glAttachShader)) GetProcAddress(cast(*u8) "glAttachShader\0");
    procs.glBindAttribLocation = cast(type_of(procs.glBindAttribLocation)) GetProcAddress(cast(*u8) "glBindAttribLocation\0");
    procs.glCompileShader = cast(type_of(procs.glCompileShader)) GetProcAddress(cast(*u8) "glCompileShader\0");
    procs.glCreateProgram = cast(type_of(procs.glCreateProgram)) GetProcAddress(cast(*u8) "glCreateProgram\0");
    procs.glCreateShader = cast(type_of(procs.glCreateShader)) GetProcAddress(cast(*u8) "glCreateShader\0");
    procs.glDeleteProgram = cast(type_of(procs.glDeleteProgram)) GetProcAddress(cast(*u8) "glDeleteProgram\0");
    procs.glDeleteShader = cast(type_of(procs.glDeleteShader)) GetProcAddress(cast(*u8) "glDeleteShader\0");
    procs.glDetachShader = cast(type_of(procs.glDetachShader)) GetProcAddress(cast(*u8) "glDetachShader\0");
    procs.glDisableVertexAttribArray = cast(type_of(procs.glDisableVertexAttribArray)) GetProcAddress(cast(*u8) "glDisableVertexAttribArray\0");
    procs.glEnableVertexAttribArray = cast(type_of(procs.glEnableVertexAttribArray)) GetProcAddress(cast(*u8) "glEnableVertexAttribArray\0");
    procs.glGetActiveAttrib = cast(type_of(procs.glGetActiveAttrib)) GetProcAddress(cast(*u8) "glGetActiveAttrib\0");
    procs.glGetActiveUniform = cast(type_of(procs.glGetActiveUniform)) GetProcAddress(cast(*u8) "glGetActiveUniform\0");
    procs.glGetAttachedShaders = cast(type_of(procs.glGetAttachedShaders)) GetProcAddress(cast(*u8) "glGetAttachedShaders\0");
    procs.glGetAttribLocation = cast(type_of(procs.glGetAttribLocation)) GetProcAddress(cast(*u8) "glGetAttribLocation\0");
    procs.glGetProgramiv = cast(type_of(procs.glGetProgramiv)) GetProcAddress(cast(*u8) "glGetProgramiv\0");
    procs.glGetProgramInfoLog = cast(type_of(procs.glGetProgramInfoLog)) GetProcAddress(cast(*u8) "glGetProgramInfoLog\0");
    procs.glGetShaderiv = cast(type_of(procs.glGetShaderiv)) GetProcAddress(cast(*u8) "glGetShaderiv\0");
    procs.glGetShaderInfoLog = cast(type_of(procs.glGetShaderInfoLog)) GetProcAddress(cast(*u8) "glGetShaderInfoLog\0");
    procs.glGetShaderSource = cast(type_of(procs.glGetShaderSource)) GetProcAddress(cast(*u8) "glGetShaderSource\0");
    procs.glGetUniformLocation = cast(type_of(procs.glGetUniformLocation)) GetProcAddress(cast(*u8) "glGetUniformLocation\0");
    procs.glGetUniformfv = cast(type_of(procs.glGetUniformfv)) GetProcAddress(cast(*u8) "glGetUniformfv\0");
    procs.glGetUniformiv = cast(type_of(procs.glGetUniformiv)) GetProcAddress(cast(*u8) "glGetUniformiv\0");
    procs.glGetVertexAttribdv = cast(type_of(procs.glGetVertexAttribdv)) GetProcAddress(cast(*u8) "glGetVertexAttribdv\0");
    procs.glGetVertexAttribfv = cast(type_of(procs.glGetVertexAttribfv)) GetProcAddress(cast(*u8) "glGetVertexAttribfv\0");
    procs.glGetVertexAttribiv = cast(type_of(procs.glGetVertexAttribiv)) GetProcAddress(cast(*u8) "glGetVertexAttribiv\0");
    procs.glGetVertexAttribPointerv = cast(type_of(procs.glGetVertexAttribPointerv)) GetProcAddress(cast(*u8) "glGetVertexAttribPointerv\0");
    procs.glIsProgram = cast(type_of(procs.glIsProgram)) GetProcAddress(cast(*u8) "glIsProgram\0");
    procs.glIsShader = cast(type_of(procs.glIsShader)) GetProcAddress(cast(*u8) "glIsShader\0");
    procs.glLinkProgram = cast(type_of(procs.glLinkProgram)) GetProcAddress(cast(*u8) "glLinkProgram\0");
    procs.glShaderSource = cast(type_of(procs.glShaderSource)) GetProcAddress(cast(*u8) "glShaderSource\0");
    procs.glUseProgram = cast(type_of(procs.glUseProgram)) GetProcAddress(cast(*u8) "glUseProgram\0");
    procs.glUniform1f = cast(type_of(procs.glUniform1f)) GetProcAddress(cast(*u8) "glUniform1f\0");
    procs.glUniform2f = cast(type_of(procs.glUniform2f)) GetProcAddress(cast(*u8) "glUniform2f\0");
    procs.glUniform3f = cast(type_of(procs.glUniform3f)) GetProcAddress(cast(*u8) "glUniform3f\0");
    procs.glUniform4f = cast(type_of(procs.glUniform4f)) GetProcAddress(cast(*u8) "glUniform4f\0");
    procs.glUniform1i = cast(type_of(procs.glUniform1i)) GetProcAddress(cast(*u8) "glUniform1i\0");
    procs.glUniform2i = cast(type_of(procs.glUniform2i)) GetProcAddress(cast(*u8) "glUniform2i\0");
    procs.glUniform3i = cast(type_of(procs.glUniform3i)) GetProcAddress(cast(*u8) "glUniform3i\0");
    procs.glUniform4i = cast(type_of(procs.glUniform4i)) GetProcAddress(cast(*u8) "glUniform4i\0");
    procs.glUniform1fv = cast(type_of(procs.glUniform1fv)) GetProcAddress(cast(*u8) "glUniform1fv\0");
    procs.glUniform2fv = cast(type_of(procs.glUniform2fv)) GetProcAddress(cast(*u8) "glUniform2fv\0");
    procs.glUniform3fv = cast(type_of(procs.glUniform3fv)) GetProcAddress(cast(*u8) "glUniform3fv\0");
    procs.glUniform4fv = cast(type_of(procs.glUniform4fv)) GetProcAddress(cast(*u8) "glUniform4fv\0");
    procs.glUniform1iv = cast(type_of(procs.glUniform1iv)) GetProcAddress(cast(*u8) "glUniform1iv\0");
    procs.glUniform2iv = cast(type_of(procs.glUniform2iv)) GetProcAddress(cast(*u8) "glUniform2iv\0");
    procs.glUniform3iv = cast(type_of(procs.glUniform3iv)) GetProcAddress(cast(*u8) "glUniform3iv\0");
    procs.glUniform4iv = cast(type_of(procs.glUniform4iv)) GetProcAddress(cast(*u8) "glUniform4iv\0");
    procs.glUniformMatrix2fv = cast(type_of(procs.glUniformMatrix2fv)) GetProcAddress(cast(*u8) "glUniformMatrix2fv\0");
    procs.glUniformMatrix3fv = cast(type_of(procs.glUniformMatrix3fv)) GetProcAddress(cast(*u8) "glUniformMatrix3fv\0");
    procs.glUniformMatrix4fv = cast(type_of(procs.glUniformMatrix4fv)) GetProcAddress(cast(*u8) "glUniformMatrix4fv\0");
    procs.glValidateProgram = cast(type_of(procs.glValidateProgram)) GetProcAddress(cast(*u8) "glValidateProgram\0");
    procs.glVertexAttrib1d = cast(type_of(procs.glVertexAttrib1d)) GetProcAddress(cast(*u8) "glVertexAttrib1d\0");
    procs.glVertexAttrib1dv = cast(type_of(procs.glVertexAttrib1dv)) GetProcAddress(cast(*u8) "glVertexAttrib1dv\0");
    procs.glVertexAttrib1f = cast(type_of(procs.glVertexAttrib1f)) GetProcAddress(cast(*u8) "glVertexAttrib1f\0");
    procs.glVertexAttrib1fv = cast(type_of(procs.glVertexAttrib1fv)) GetProcAddress(cast(*u8) "glVertexAttrib1fv\0");
    procs.glVertexAttrib1s = cast(type_of(procs.glVertexAttrib1s)) GetProcAddress(cast(*u8) "glVertexAttrib1s\0");
    procs.glVertexAttrib1sv = cast(type_of(procs.glVertexAttrib1sv)) GetProcAddress(cast(*u8) "glVertexAttrib1sv\0");
    procs.glVertexAttrib2d = cast(type_of(procs.glVertexAttrib2d)) GetProcAddress(cast(*u8) "glVertexAttrib2d\0");
    procs.glVertexAttrib2dv = cast(type_of(procs.glVertexAttrib2dv)) GetProcAddress(cast(*u8) "glVertexAttrib2dv\0");
    procs.glVertexAttrib2f = cast(type_of(procs.glVertexAttrib2f)) GetProcAddress(cast(*u8) "glVertexAttrib2f\0");
    procs.glVertexAttrib2fv = cast(type_of(procs.glVertexAttrib2fv)) GetProcAddress(cast(*u8) "glVertexAttrib2fv\0");
    procs.glVertexAttrib2s = cast(type_of(procs.glVertexAttrib2s)) GetProcAddress(cast(*u8) "glVertexAttrib2s\0");
    procs.glVertexAttrib2sv = cast(type_of(procs.glVertexAttrib2sv)) GetProcAddress(cast(*u8) "glVertexAttrib2sv\0");
    procs.glVertexAttrib3d = cast(type_of(procs.glVertexAttrib3d)) GetProcAddress(cast(*u8) "glVertexAttrib3d\0");
    procs.glVertexAttrib3dv = cast(type_of(procs.glVertexAttrib3dv)) GetProcAddress(cast(*u8) "glVertexAttrib3dv\0");
    procs.glVertexAttrib3f = cast(type_of(procs.glVertexAttrib3f)) GetProcAddress(cast(*u8) "glVertexAttrib3f\0");
    procs.glVertexAttrib3fv = cast(type_of(procs.glVertexAttrib3fv)) GetProcAddress(cast(*u8) "glVertexAttrib3fv\0");
    procs.glVertexAttrib3s = cast(type_of(procs.glVertexAttrib3s)) GetProcAddress(cast(*u8) "glVertexAttrib3s\0");
    procs.glVertexAttrib3sv = cast(type_of(procs.glVertexAttrib3sv)) GetProcAddress(cast(*u8) "glVertexAttrib3sv\0");
    procs.glVertexAttrib4Nbv = cast(type_of(procs.glVertexAttrib4Nbv)) GetProcAddress(cast(*u8) "glVertexAttrib4Nbv\0");
    procs.glVertexAttrib4Niv = cast(type_of(procs.glVertexAttrib4Niv)) GetProcAddress(cast(*u8) "glVertexAttrib4Niv\0");
    procs.glVertexAttrib4Nsv = cast(type_of(procs.glVertexAttrib4Nsv)) GetProcAddress(cast(*u8) "glVertexAttrib4Nsv\0");
    procs.glVertexAttrib4Nub = cast(type_of(procs.glVertexAttrib4Nub)) GetProcAddress(cast(*u8) "glVertexAttrib4Nub\0");
    procs.glVertexAttrib4Nubv = cast(type_of(procs.glVertexAttrib4Nubv)) GetProcAddress(cast(*u8) "glVertexAttrib4Nubv\0");
    procs.glVertexAttrib4Nuiv = cast(type_of(procs.glVertexAttrib4Nuiv)) GetProcAddress(cast(*u8) "glVertexAttrib4Nuiv\0");
    procs.glVertexAttrib4Nusv = cast(type_of(procs.glVertexAttrib4Nusv)) GetProcAddress(cast(*u8) "glVertexAttrib4Nusv\0");
    procs.glVertexAttrib4bv = cast(type_of(procs.glVertexAttrib4bv)) GetProcAddress(cast(*u8) "glVertexAttrib4bv\0");
    procs.glVertexAttrib4d = cast(type_of(procs.glVertexAttrib4d)) GetProcAddress(cast(*u8) "glVertexAttrib4d\0");
    procs.glVertexAttrib4dv = cast(type_of(procs.glVertexAttrib4dv)) GetProcAddress(cast(*u8) "glVertexAttrib4dv\0");
    procs.glVertexAttrib4f = cast(type_of(procs.glVertexAttrib4f)) GetProcAddress(cast(*u8) "glVertexAttrib4f\0");
    procs.glVertexAttrib4fv = cast(type_of(procs.glVertexAttrib4fv)) GetProcAddress(cast(*u8) "glVertexAttrib4fv\0");
    procs.glVertexAttrib4iv = cast(type_of(procs.glVertexAttrib4iv)) GetProcAddress(cast(*u8) "glVertexAttrib4iv\0");
    procs.glVertexAttrib4s = cast(type_of(procs.glVertexAttrib4s)) GetProcAddress(cast(*u8) "glVertexAttrib4s\0");
    procs.glVertexAttrib4sv = cast(type_of(procs.glVertexAttrib4sv)) GetProcAddress(cast(*u8) "glVertexAttrib4sv\0");
    procs.glVertexAttrib4ubv = cast(type_of(procs.glVertexAttrib4ubv)) GetProcAddress(cast(*u8) "glVertexAttrib4ubv\0");
    procs.glVertexAttrib4uiv = cast(type_of(procs.glVertexAttrib4uiv)) GetProcAddress(cast(*u8) "glVertexAttrib4uiv\0");
    procs.glVertexAttrib4usv = cast(type_of(procs.glVertexAttrib4usv)) GetProcAddress(cast(*u8) "glVertexAttrib4usv\0");
    procs.glVertexAttribPointer = cast(type_of(procs.glVertexAttribPointer)) GetProcAddress(cast(*u8) "glVertexAttribPointer\0");
    procs.glUniformMatrix2x3fv = cast(type_of(procs.glUniformMatrix2x3fv)) GetProcAddress(cast(*u8) "glUniformMatrix2x3fv\0");
    procs.glUniformMatrix3x2fv = cast(type_of(procs.glUniformMatrix3x2fv)) GetProcAddress(cast(*u8) "glUniformMatrix3x2fv\0");
    procs.glUniformMatrix2x4fv = cast(type_of(procs.glUniformMatrix2x4fv)) GetProcAddress(cast(*u8) "glUniformMatrix2x4fv\0");
    procs.glUniformMatrix4x2fv = cast(type_of(procs.glUniformMatrix4x2fv)) GetProcAddress(cast(*u8) "glUniformMatrix4x2fv\0");
    procs.glUniformMatrix3x4fv = cast(type_of(procs.glUniformMatrix3x4fv)) GetProcAddress(cast(*u8) "glUniformMatrix3x4fv\0");
    procs.glUniformMatrix4x3fv = cast(type_of(procs.glUniformMatrix4x3fv)) GetProcAddress(cast(*u8) "glUniformMatrix4x3fv\0");
    procs.glColorMaski = cast(type_of(procs.glColorMaski)) GetProcAddress(cast(*u8) "glColorMaski\0");
    procs.glGetBooleani_v = cast(type_of(procs.glGetBooleani_v)) GetProcAddress(cast(*u8) "glGetBooleani_v\0");
    procs.glGetIntegeri_v = cast(type_of(procs.glGetIntegeri_v)) GetProcAddress(cast(*u8) "glGetIntegeri_v\0");
    procs.glEnablei = cast(type_of(procs.glEnablei)) GetProcAddress(cast(*u8) "glEnablei\0");
    procs.glDisablei = cast(type_of(procs.glDisablei)) GetProcAddress(cast(*u8) "glDisablei\0");
    procs.glIsEnabledi = cast(type_of(procs.glIsEnabledi)) GetProcAddress(cast(*u8) "glIsEnabledi\0");
    procs.glBeginTransformFeedback = cast(type_of(procs.glBeginTransformFeedback)) GetProcAddress(cast(*u8) "glBeginTransformFeedback\0");
    procs.glEndTransformFeedback = cast(type_of(procs.glEndTransformFeedback)) GetProcAddress(cast(*u8) "glEndTransformFeedback\0");
    procs.glBindBufferRange = cast(type_of(procs.glBindBufferRange)) GetProcAddress(cast(*u8) "glBindBufferRange\0");
    procs.glBindBufferBase = cast(type_of(procs.glBindBufferBase)) GetProcAddress(cast(*u8) "glBindBufferBase\0");
    procs.glTransformFeedbackVaryings = cast(type_of(procs.glTransformFeedbackVaryings)) GetProcAddress(cast(*u8) "glTransformFeedbackVaryings\0");
    procs.glGetTransformFeedbackVarying = cast(type_of(procs.glGetTransformFeedbackVarying)) GetProcAddress(cast(*u8) "glGetTransformFeedbackVarying\0");
    procs.glClampColor = cast(type_of(procs.glClampColor)) GetProcAddress(cast(*u8) "glClampColor\0");
    procs.glBeginConditionalRender = cast(type_of(procs.glBeginConditionalRender)) GetProcAddress(cast(*u8) "glBeginConditionalRender\0");
    procs.glEndConditionalRender = cast(type_of(procs.glEndConditionalRender)) GetProcAddress(cast(*u8) "glEndConditionalRender\0");
    procs.glVertexAttribIPointer = cast(type_of(procs.glVertexAttribIPointer)) GetProcAddress(cast(*u8) "glVertexAttribIPointer\0");
    procs.glGetVertexAttribIiv = cast(type_of(procs.glGetVertexAttribIiv)) GetProcAddress(cast(*u8) "glGetVertexAttribIiv\0");
    procs.glGetVertexAttribIuiv = cast(type_of(procs.glGetVertexAttribIuiv)) GetProcAddress(cast(*u8) "glGetVertexAttribIuiv\0");
    procs.glVertexAttribI1i = cast(type_of(procs.glVertexAttribI1i)) GetProcAddress(cast(*u8) "glVertexAttribI1i\0");
    procs.glVertexAttribI2i = cast(type_of(procs.glVertexAttribI2i)) GetProcAddress(cast(*u8) "glVertexAttribI2i\0");
    procs.glVertexAttribI3i = cast(type_of(procs.glVertexAttribI3i)) GetProcAddress(cast(*u8) "glVertexAttribI3i\0");
    procs.glVertexAttribI4i = cast(type_of(procs.glVertexAttribI4i)) GetProcAddress(cast(*u8) "glVertexAttribI4i\0");
    procs.glVertexAttribI1ui = cast(type_of(procs.glVertexAttribI1ui)) GetProcAddress(cast(*u8) "glVertexAttribI1ui\0");
    procs.glVertexAttribI2ui = cast(type_of(procs.glVertexAttribI2ui)) GetProcAddress(cast(*u8) "glVertexAttribI2ui\0");
    procs.glVertexAttribI3ui = cast(type_of(procs.glVertexAttribI3ui)) GetProcAddress(cast(*u8) "glVertexAttribI3ui\0");
    procs.glVertexAttribI4ui = cast(type_of(procs.glVertexAttribI4ui)) GetProcAddress(cast(*u8) "glVertexAttribI4ui\0");
    procs.glVertexAttribI1iv = cast(type_of(procs.glVertexAttribI1iv)) GetProcAddress(cast(*u8) "glVertexAttribI1iv\0");
    procs.glVertexAttribI2iv = cast(type_of(procs.glVertexAttribI2iv)) GetProcAddress(cast(*u8) "glVertexAttribI2iv\0");
    procs.glVertexAttribI3iv = cast(type_of(procs.glVertexAttribI3iv)) GetProcAddress(cast(*u8) "glVertexAttribI3iv\0");
    procs.glVertexAttribI4iv = cast(type_of(procs.glVertexAttribI4iv)) GetProcAddress(cast(*u8) "glVertexAttribI4iv\0");
    procs.glVertexAttribI1uiv = cast(type_of(procs.glVertexAttribI1uiv)) GetProcAddress(cast(*u8) "glVertexAttribI1uiv\0");
    procs.glVertexAttribI2uiv = cast(type_of(procs.glVertexAttribI2uiv)) GetProcAddress(cast(*u8) "glVertexAttribI2uiv\0");
    procs.glVertexAttribI3uiv = cast(type_of(procs.glVertexAttribI3uiv)) GetProcAddress(cast(*u8) "glVertexAttribI3uiv\0");
    procs.glVertexAttribI4uiv = cast(type_of(procs.glVertexAttribI4uiv)) GetProcAddress(cast(*u8) "glVertexAttribI4uiv\0");
    procs.glVertexAttribI4bv = cast(type_of(procs.glVertexAttribI4bv)) GetProcAddress(cast(*u8) "glVertexAttribI4bv\0");
    procs.glVertexAttribI4sv = cast(type_of(procs.glVertexAttribI4sv)) GetProcAddress(cast(*u8) "glVertexAttribI4sv\0");
    procs.glVertexAttribI4ubv = cast(type_of(procs.glVertexAttribI4ubv)) GetProcAddress(cast(*u8) "glVertexAttribI4ubv\0");
    procs.glVertexAttribI4usv = cast(type_of(procs.glVertexAttribI4usv)) GetProcAddress(cast(*u8) "glVertexAttribI4usv\0");
    procs.glGetUniformuiv = cast(type_of(procs.glGetUniformuiv)) GetProcAddress(cast(*u8) "glGetUniformuiv\0");
    procs.glBindFragDataLocation = cast(type_of(procs.glBindFragDataLocation)) GetProcAddress(cast(*u8) "glBindFragDataLocation\0");
    procs.glGetFragDataLocation = cast(type_of(procs.glGetFragDataLocation)) GetProcAddress(cast(*u8) "glGetFragDataLocation\0");
    procs.glUniform1ui = cast(type_of(procs.glUniform1ui)) GetProcAddress(cast(*u8) "glUniform1ui\0");
    procs.glUniform2ui = cast(type_of(procs.glUniform2ui)) GetProcAddress(cast(*u8) "glUniform2ui\0");
    procs.glUniform3ui = cast(type_of(procs.glUniform3ui)) GetProcAddress(cast(*u8) "glUniform3ui\0");
    procs.glUniform4ui = cast(type_of(procs.glUniform4ui)) GetProcAddress(cast(*u8) "glUniform4ui\0");
    procs.glUniform1uiv = cast(type_of(procs.glUniform1uiv)) GetProcAddress(cast(*u8) "glUniform1uiv\0");
    procs.glUniform2uiv = cast(type_of(procs.glUniform2uiv)) GetProcAddress(cast(*u8) "glUniform2uiv\0");
    procs.glUniform3uiv = cast(type_of(procs.glUniform3uiv)) GetProcAddress(cast(*u8) "glUniform3uiv\0");
    procs.glUniform4uiv = cast(type_of(procs.glUniform4uiv)) GetProcAddress(cast(*u8) "glUniform4uiv\0");
    procs.glTexParameterIiv = cast(type_of(procs.glTexParameterIiv)) GetProcAddress(cast(*u8) "glTexParameterIiv\0");
    procs.glTexParameterIuiv = cast(type_of(procs.glTexParameterIuiv)) GetProcAddress(cast(*u8) "glTexParameterIuiv\0");
    procs.glGetTexParameterIiv = cast(type_of(procs.glGetTexParameterIiv)) GetProcAddress(cast(*u8) "glGetTexParameterIiv\0");
    procs.glGetTexParameterIuiv = cast(type_of(procs.glGetTexParameterIuiv)) GetProcAddress(cast(*u8) "glGetTexParameterIuiv\0");
    procs.glClearBufferiv = cast(type_of(procs.glClearBufferiv)) GetProcAddress(cast(*u8) "glClearBufferiv\0");
    procs.glClearBufferuiv = cast(type_of(procs.glClearBufferuiv)) GetProcAddress(cast(*u8) "glClearBufferuiv\0");
    procs.glClearBufferfv = cast(type_of(procs.glClearBufferfv)) GetProcAddress(cast(*u8) "glClearBufferfv\0");
    procs.glClearBufferfi = cast(type_of(procs.glClearBufferfi)) GetProcAddress(cast(*u8) "glClearBufferfi\0");
    procs.glGetStringi = cast(type_of(procs.glGetStringi)) GetProcAddress(cast(*u8) "glGetStringi\0");
    procs.glIsRenderbuffer = cast(type_of(procs.glIsRenderbuffer)) GetProcAddress(cast(*u8) "glIsRenderbuffer\0");
    procs.glBindRenderbuffer = cast(type_of(procs.glBindRenderbuffer)) GetProcAddress(cast(*u8) "glBindRenderbuffer\0");
    procs.glDeleteRenderbuffers = cast(type_of(procs.glDeleteRenderbuffers)) GetProcAddress(cast(*u8) "glDeleteRenderbuffers\0");
    procs.glGenRenderbuffers = cast(type_of(procs.glGenRenderbuffers)) GetProcAddress(cast(*u8) "glGenRenderbuffers\0");
    procs.glRenderbufferStorage = cast(type_of(procs.glRenderbufferStorage)) GetProcAddress(cast(*u8) "glRenderbufferStorage\0");
    procs.glGetRenderbufferParameteriv = cast(type_of(procs.glGetRenderbufferParameteriv)) GetProcAddress(cast(*u8) "glGetRenderbufferParameteriv\0");
    procs.glIsFramebuffer = cast(type_of(procs.glIsFramebuffer)) GetProcAddress(cast(*u8) "glIsFramebuffer\0");
    procs.glBindFramebuffer = cast(type_of(procs.glBindFramebuffer)) GetProcAddress(cast(*u8) "glBindFramebuffer\0");
    procs.glDeleteFramebuffers = cast(type_of(procs.glDeleteFramebuffers)) GetProcAddress(cast(*u8) "glDeleteFramebuffers\0");
    procs.glGenFramebuffers = cast(type_of(procs.glGenFramebuffers)) GetProcAddress(cast(*u8) "glGenFramebuffers\0");
    procs.glCheckFramebufferStatus = cast(type_of(procs.glCheckFramebufferStatus)) GetProcAddress(cast(*u8) "glCheckFramebufferStatus\0");
    procs.glFramebufferTexture1D = cast(type_of(procs.glFramebufferTexture1D)) GetProcAddress(cast(*u8) "glFramebufferTexture1D\0");
    procs.glFramebufferTexture2D = cast(type_of(procs.glFramebufferTexture2D)) GetProcAddress(cast(*u8) "glFramebufferTexture2D\0");
    procs.glFramebufferTexture3D = cast(type_of(procs.glFramebufferTexture3D)) GetProcAddress(cast(*u8) "glFramebufferTexture3D\0");
    procs.glFramebufferRenderbuffer = cast(type_of(procs.glFramebufferRenderbuffer)) GetProcAddress(cast(*u8) "glFramebufferRenderbuffer\0");
    procs.glGetFramebufferAttachmentParameteriv = cast(type_of(procs.glGetFramebufferAttachmentParameteriv)) GetProcAddress(cast(*u8) "glGetFramebufferAttachmentParameteriv\0");
    procs.glGenerateMipmap = cast(type_of(procs.glGenerateMipmap)) GetProcAddress(cast(*u8) "glGenerateMipmap\0");
    procs.glBlitFramebuffer = cast(type_of(procs.glBlitFramebuffer)) GetProcAddress(cast(*u8) "glBlitFramebuffer\0");
    procs.glRenderbufferStorageMultisample = cast(type_of(procs.glRenderbufferStorageMultisample)) GetProcAddress(cast(*u8) "glRenderbufferStorageMultisample\0");
    procs.glFramebufferTextureLayer = cast(type_of(procs.glFramebufferTextureLayer)) GetProcAddress(cast(*u8) "glFramebufferTextureLayer\0");
    procs.glMapBufferRange = cast(type_of(procs.glMapBufferRange)) GetProcAddress(cast(*u8) "glMapBufferRange\0");
    procs.glFlushMappedBufferRange = cast(type_of(procs.glFlushMappedBufferRange)) GetProcAddress(cast(*u8) "glFlushMappedBufferRange\0");
    procs.glBindVertexArray = cast(type_of(procs.glBindVertexArray)) GetProcAddress(cast(*u8) "glBindVertexArray\0");
    procs.glDeleteVertexArrays = cast(type_of(procs.glDeleteVertexArrays)) GetProcAddress(cast(*u8) "glDeleteVertexArrays\0");
    procs.glGenVertexArrays = cast(type_of(procs.glGenVertexArrays)) GetProcAddress(cast(*u8) "glGenVertexArrays\0");
    procs.glIsVertexArray = cast(type_of(procs.glIsVertexArray)) GetProcAddress(cast(*u8) "glIsVertexArray\0");
    procs.glDrawArraysInstanced = cast(type_of(procs.glDrawArraysInstanced)) GetProcAddress(cast(*u8) "glDrawArraysInstanced\0");
    procs.glDrawElementsInstanced = cast(type_of(procs.glDrawElementsInstanced)) GetProcAddress(cast(*u8) "glDrawElementsInstanced\0");
    procs.glTexBuffer = cast(type_of(procs.glTexBuffer)) GetProcAddress(cast(*u8) "glTexBuffer\0");
    procs.glPrimitiveRestartIndex = cast(type_of(procs.glPrimitiveRestartIndex)) GetProcAddress(cast(*u8) "glPrimitiveRestartIndex\0");
    procs.glCopyBufferSubData = cast(type_of(procs.glCopyBufferSubData)) GetProcAddress(cast(*u8) "glCopyBufferSubData\0");
    procs.glGetUniformIndices = cast(type_of(procs.glGetUniformIndices)) GetProcAddress(cast(*u8) "glGetUniformIndices\0");
    procs.glGetActiveUniformsiv = cast(type_of(procs.glGetActiveUniformsiv)) GetProcAddress(cast(*u8) "glGetActiveUniformsiv\0");
    procs.glGetActiveUniformName = cast(type_of(procs.glGetActiveUniformName)) GetProcAddress(cast(*u8) "glGetActiveUniformName\0");
    procs.glGetUniformBlockIndex = cast(type_of(procs.glGetUniformBlockIndex)) GetProcAddress(cast(*u8) "glGetUniformBlockIndex\0");
    procs.glGetActiveUniformBlockiv = cast(type_of(procs.glGetActiveUniformBlockiv)) GetProcAddress(cast(*u8) "glGetActiveUniformBlockiv\0");
    procs.glGetActiveUniformBlockName = cast(type_of(procs.glGetActiveUniformBlockName)) GetProcAddress(cast(*u8) "glGetActiveUniformBlockName\0");
    procs.glUniformBlockBinding = cast(type_of(procs.glUniformBlockBinding)) GetProcAddress(cast(*u8) "glUniformBlockBinding\0");
    procs.glDrawElementsBaseVertex = cast(type_of(procs.glDrawElementsBaseVertex)) GetProcAddress(cast(*u8) "glDrawElementsBaseVertex\0");
    procs.glDrawRangeElementsBaseVertex = cast(type_of(procs.glDrawRangeElementsBaseVertex)) GetProcAddress(cast(*u8) "glDrawRangeElementsBaseVertex\0");
    procs.glDrawElementsInstancedBaseVertex = cast(type_of(procs.glDrawElementsInstancedBaseVertex)) GetProcAddress(cast(*u8) "glDrawElementsInstancedBaseVertex\0");
    procs.glMultiDrawElementsBaseVertex = cast(type_of(procs.glMultiDrawElementsBaseVertex)) GetProcAddress(cast(*u8) "glMultiDrawElementsBaseVertex\0");
    procs.glProvokingVertex = cast(type_of(procs.glProvokingVertex)) GetProcAddress(cast(*u8) "glProvokingVertex\0");
    procs.glFenceSync = cast(type_of(procs.glFenceSync)) GetProcAddress(cast(*u8) "glFenceSync\0");
    procs.glIsSync = cast(type_of(procs.glIsSync)) GetProcAddress(cast(*u8) "glIsSync\0");
    procs.glDeleteSync = cast(type_of(procs.glDeleteSync)) GetProcAddress(cast(*u8) "glDeleteSync\0");
    procs.glClientWaitSync = cast(type_of(procs.glClientWaitSync)) GetProcAddress(cast(*u8) "glClientWaitSync\0");
    procs.glWaitSync = cast(type_of(procs.glWaitSync)) GetProcAddress(cast(*u8) "glWaitSync\0");
    procs.glGetInteger64v = cast(type_of(procs.glGetInteger64v)) GetProcAddress(cast(*u8) "glGetInteger64v\0");
    procs.glGetSynciv = cast(type_of(procs.glGetSynciv)) GetProcAddress(cast(*u8) "glGetSynciv\0");
    procs.glGetInteger64i_v = cast(type_of(procs.glGetInteger64i_v)) GetProcAddress(cast(*u8) "glGetInteger64i_v\0");
    procs.glGetBufferParameteri64v = cast(type_of(procs.glGetBufferParameteri64v)) GetProcAddress(cast(*u8) "glGetBufferParameteri64v\0");
    procs.glFramebufferTexture = cast(type_of(procs.glFramebufferTexture)) GetProcAddress(cast(*u8) "glFramebufferTexture\0");
    procs.glTexImage2DMultisample = cast(type_of(procs.glTexImage2DMultisample)) GetProcAddress(cast(*u8) "glTexImage2DMultisample\0");
    procs.glTexImage3DMultisample = cast(type_of(procs.glTexImage3DMultisample)) GetProcAddress(cast(*u8) "glTexImage3DMultisample\0");
    procs.glGetMultisamplefv = cast(type_of(procs.glGetMultisamplefv)) GetProcAddress(cast(*u8) "glGetMultisamplefv\0");
    procs.glSampleMaski = cast(type_of(procs.glSampleMaski)) GetProcAddress(cast(*u8) "glSampleMaski\0");
    procs.glBindFragDataLocationIndexed = cast(type_of(procs.glBindFragDataLocationIndexed)) GetProcAddress(cast(*u8) "glBindFragDataLocationIndexed\0");
    procs.glGetFragDataIndex = cast(type_of(procs.glGetFragDataIndex)) GetProcAddress(cast(*u8) "glGetFragDataIndex\0");
    procs.glGenSamplers = cast(type_of(procs.glGenSamplers)) GetProcAddress(cast(*u8) "glGenSamplers\0");
    procs.glDeleteSamplers = cast(type_of(procs.glDeleteSamplers)) GetProcAddress(cast(*u8) "glDeleteSamplers\0");
    procs.glIsSampler = cast(type_of(procs.glIsSampler)) GetProcAddress(cast(*u8) "glIsSampler\0");
    procs.glBindSampler = cast(type_of(procs.glBindSampler)) GetProcAddress(cast(*u8) "glBindSampler\0");
    procs.glSamplerParameteri = cast(type_of(procs.glSamplerParameteri)) GetProcAddress(cast(*u8) "glSamplerParameteri\0");
    procs.glSamplerParameteriv = cast(type_of(procs.glSamplerParameteriv)) GetProcAddress(cast(*u8) "glSamplerParameteriv\0");
    procs.glSamplerParameterf = cast(type_of(procs.glSamplerParameterf)) GetProcAddress(cast(*u8) "glSamplerParameterf\0");
    procs.glSamplerParameterfv = cast(type_of(procs.glSamplerParameterfv)) GetProcAddress(cast(*u8) "glSamplerParameterfv\0");
    procs.glSamplerParameterIiv = cast(type_of(procs.glSamplerParameterIiv)) GetProcAddress(cast(*u8) "glSamplerParameterIiv\0");
    procs.glSamplerParameterIuiv = cast(type_of(procs.glSamplerParameterIuiv)) GetProcAddress(cast(*u8) "glSamplerParameterIuiv\0");
    procs.glGetSamplerParameteriv = cast(type_of(procs.glGetSamplerParameteriv)) GetProcAddress(cast(*u8) "glGetSamplerParameteriv\0");
    procs.glGetSamplerParameterIiv = cast(type_of(procs.glGetSamplerParameterIiv)) GetProcAddress(cast(*u8) "glGetSamplerParameterIiv\0");
    procs.glGetSamplerParameterfv = cast(type_of(procs.glGetSamplerParameterfv)) GetProcAddress(cast(*u8) "glGetSamplerParameterfv\0");
    procs.glGetSamplerParameterIuiv = cast(type_of(procs.glGetSamplerParameterIuiv)) GetProcAddress(cast(*u8) "glGetSamplerParameterIuiv\0");
    procs.glQueryCounter = cast(type_of(procs.glQueryCounter)) GetProcAddress(cast(*u8) "glQueryCounter\0");
    procs.glGetQueryObjecti64v = cast(type_of(procs.glGetQueryObjecti64v)) GetProcAddress(cast(*u8) "glGetQueryObjecti64v\0");
    procs.glGetQueryObjectui64v = cast(type_of(procs.glGetQueryObjectui64v)) GetProcAddress(cast(*u8) "glGetQueryObjectui64v\0");
    procs.glVertexAttribDivisor = cast(type_of(procs.glVertexAttribDivisor)) GetProcAddress(cast(*u8) "glVertexAttribDivisor\0");
    procs.glVertexAttribP1ui = cast(type_of(procs.glVertexAttribP1ui)) GetProcAddress(cast(*u8) "glVertexAttribP1ui\0");
    procs.glVertexAttribP1uiv = cast(type_of(procs.glVertexAttribP1uiv)) GetProcAddress(cast(*u8) "glVertexAttribP1uiv\0");
    procs.glVertexAttribP2ui = cast(type_of(procs.glVertexAttribP2ui)) GetProcAddress(cast(*u8) "glVertexAttribP2ui\0");
    procs.glVertexAttribP2uiv = cast(type_of(procs.glVertexAttribP2uiv)) GetProcAddress(cast(*u8) "glVertexAttribP2uiv\0");
    procs.glVertexAttribP3ui = cast(type_of(procs.glVertexAttribP3ui)) GetProcAddress(cast(*u8) "glVertexAttribP3ui\0");
    procs.glVertexAttribP3uiv = cast(type_of(procs.glVertexAttribP3uiv)) GetProcAddress(cast(*u8) "glVertexAttribP3uiv\0");
    procs.glVertexAttribP4ui = cast(type_of(procs.glVertexAttribP4ui)) GetProcAddress(cast(*u8) "glVertexAttribP4ui\0");
    procs.glVertexAttribP4uiv = cast(type_of(procs.glVertexAttribP4uiv)) GetProcAddress(cast(*u8) "glVertexAttribP4uiv\0");
    procs.glVertexP2ui = cast(type_of(procs.glVertexP2ui)) GetProcAddress(cast(*u8) "glVertexP2ui\0");
    procs.glVertexP2uiv = cast(type_of(procs.glVertexP2uiv)) GetProcAddress(cast(*u8) "glVertexP2uiv\0");
    procs.glVertexP3ui = cast(type_of(procs.glVertexP3ui)) GetProcAddress(cast(*u8) "glVertexP3ui\0");
    procs.glVertexP3uiv = cast(type_of(procs.glVertexP3uiv)) GetProcAddress(cast(*u8) "glVertexP3uiv\0");
    procs.glVertexP4ui = cast(type_of(procs.glVertexP4ui)) GetProcAddress(cast(*u8) "glVertexP4ui\0");
    procs.glVertexP4uiv = cast(type_of(procs.glVertexP4uiv)) GetProcAddress(cast(*u8) "glVertexP4uiv\0");
    procs.glTexCoordP1ui = cast(type_of(procs.glTexCoordP1ui)) GetProcAddress(cast(*u8) "glTexCoordP1ui\0");
    procs.glTexCoordP1uiv = cast(type_of(procs.glTexCoordP1uiv)) GetProcAddress(cast(*u8) "glTexCoordP1uiv\0");
    procs.glTexCoordP2ui = cast(type_of(procs.glTexCoordP2ui)) GetProcAddress(cast(*u8) "glTexCoordP2ui\0");
    procs.glTexCoordP2uiv = cast(type_of(procs.glTexCoordP2uiv)) GetProcAddress(cast(*u8) "glTexCoordP2uiv\0");
    procs.glTexCoordP3ui = cast(type_of(procs.glTexCoordP3ui)) GetProcAddress(cast(*u8) "glTexCoordP3ui\0");
    procs.glTexCoordP3uiv = cast(type_of(procs.glTexCoordP3uiv)) GetProcAddress(cast(*u8) "glTexCoordP3uiv\0");
    procs.glTexCoordP4ui = cast(type_of(procs.glTexCoordP4ui)) GetProcAddress(cast(*u8) "glTexCoordP4ui\0");
    procs.glTexCoordP4uiv = cast(type_of(procs.glTexCoordP4uiv)) GetProcAddress(cast(*u8) "glTexCoordP4uiv\0");
    procs.glMultiTexCoordP1ui = cast(type_of(procs.glMultiTexCoordP1ui)) GetProcAddress(cast(*u8) "glMultiTexCoordP1ui\0");
    procs.glMultiTexCoordP1uiv = cast(type_of(procs.glMultiTexCoordP1uiv)) GetProcAddress(cast(*u8) "glMultiTexCoordP1uiv\0");
    procs.glMultiTexCoordP2ui = cast(type_of(procs.glMultiTexCoordP2ui)) GetProcAddress(cast(*u8) "glMultiTexCoordP2ui\0");
    procs.glMultiTexCoordP2uiv = cast(type_of(procs.glMultiTexCoordP2uiv)) GetProcAddress(cast(*u8) "glMultiTexCoordP2uiv\0");
    procs.glMultiTexCoordP3ui = cast(type_of(procs.glMultiTexCoordP3ui)) GetProcAddress(cast(*u8) "glMultiTexCoordP3ui\0");
    procs.glMultiTexCoordP3uiv = cast(type_of(procs.glMultiTexCoordP3uiv)) GetProcAddress(cast(*u8) "glMultiTexCoordP3uiv\0");
    procs.glMultiTexCoordP4ui = cast(type_of(procs.glMultiTexCoordP4ui)) GetProcAddress(cast(*u8) "glMultiTexCoordP4ui\0");
    procs.glMultiTexCoordP4uiv = cast(type_of(procs.glMultiTexCoordP4uiv)) GetProcAddress(cast(*u8) "glMultiTexCoordP4uiv\0");
    procs.glNormalP3ui = cast(type_of(procs.glNormalP3ui)) GetProcAddress(cast(*u8) "glNormalP3ui\0");
    procs.glNormalP3uiv = cast(type_of(procs.glNormalP3uiv)) GetProcAddress(cast(*u8) "glNormalP3uiv\0");
    procs.glColorP3ui = cast(type_of(procs.glColorP3ui)) GetProcAddress(cast(*u8) "glColorP3ui\0");
    procs.glColorP3uiv = cast(type_of(procs.glColorP3uiv)) GetProcAddress(cast(*u8) "glColorP3uiv\0");
    procs.glColorP4ui = cast(type_of(procs.glColorP4ui)) GetProcAddress(cast(*u8) "glColorP4ui\0");
    procs.glColorP4uiv = cast(type_of(procs.glColorP4uiv)) GetProcAddress(cast(*u8) "glColorP4uiv\0");
    procs.glSecondaryColorP3ui = cast(type_of(procs.glSecondaryColorP3ui)) GetProcAddress(cast(*u8) "glSecondaryColorP3ui\0");
    procs.glSecondaryColorP3uiv = cast(type_of(procs.glSecondaryColorP3uiv)) GetProcAddress(cast(*u8) "glSecondaryColorP3uiv\0");
    procs.glMinSampleShading = cast(type_of(procs.glMinSampleShading)) GetProcAddress(cast(*u8) "glMinSampleShading\0");
    procs.glBlendEquationi = cast(type_of(procs.glBlendEquationi)) GetProcAddress(cast(*u8) "glBlendEquationi\0");
    procs.glBlendEquationSeparatei = cast(type_of(procs.glBlendEquationSeparatei)) GetProcAddress(cast(*u8) "glBlendEquationSeparatei\0");
    procs.glBlendFunci = cast(type_of(procs.glBlendFunci)) GetProcAddress(cast(*u8) "glBlendFunci\0");
    procs.glBlendFuncSeparatei = cast(type_of(procs.glBlendFuncSeparatei)) GetProcAddress(cast(*u8) "glBlendFuncSeparatei\0");
    procs.glDrawArraysIndirect = cast(type_of(procs.glDrawArraysIndirect)) GetProcAddress(cast(*u8) "glDrawArraysIndirect\0");
    procs.glDrawElementsIndirect = cast(type_of(procs.glDrawElementsIndirect)) GetProcAddress(cast(*u8) "glDrawElementsIndirect\0");
    procs.glUniform1d = cast(type_of(procs.glUniform1d)) GetProcAddress(cast(*u8) "glUniform1d\0");
    procs.glUniform2d = cast(type_of(procs.glUniform2d)) GetProcAddress(cast(*u8) "glUniform2d\0");
    procs.glUniform3d = cast(type_of(procs.glUniform3d)) GetProcAddress(cast(*u8) "glUniform3d\0");
    procs.glUniform4d = cast(type_of(procs.glUniform4d)) GetProcAddress(cast(*u8) "glUniform4d\0");
    procs.glUniform1dv = cast(type_of(procs.glUniform1dv)) GetProcAddress(cast(*u8) "glUniform1dv\0");
    procs.glUniform2dv = cast(type_of(procs.glUniform2dv)) GetProcAddress(cast(*u8) "glUniform2dv\0");
    procs.glUniform3dv = cast(type_of(procs.glUniform3dv)) GetProcAddress(cast(*u8) "glUniform3dv\0");
    procs.glUniform4dv = cast(type_of(procs.glUniform4dv)) GetProcAddress(cast(*u8) "glUniform4dv\0");
    procs.glUniformMatrix2dv = cast(type_of(procs.glUniformMatrix2dv)) GetProcAddress(cast(*u8) "glUniformMatrix2dv\0");
    procs.glUniformMatrix3dv = cast(type_of(procs.glUniformMatrix3dv)) GetProcAddress(cast(*u8) "glUniformMatrix3dv\0");
    procs.glUniformMatrix4dv = cast(type_of(procs.glUniformMatrix4dv)) GetProcAddress(cast(*u8) "glUniformMatrix4dv\0");
    procs.glUniformMatrix2x3dv = cast(type_of(procs.glUniformMatrix2x3dv)) GetProcAddress(cast(*u8) "glUniformMatrix2x3dv\0");
    procs.glUniformMatrix2x4dv = cast(type_of(procs.glUniformMatrix2x4dv)) GetProcAddress(cast(*u8) "glUniformMatrix2x4dv\0");
    procs.glUniformMatrix3x2dv = cast(type_of(procs.glUniformMatrix3x2dv)) GetProcAddress(cast(*u8) "glUniformMatrix3x2dv\0");
    procs.glUniformMatrix3x4dv = cast(type_of(procs.glUniformMatrix3x4dv)) GetProcAddress(cast(*u8) "glUniformMatrix3x4dv\0");
    procs.glUniformMatrix4x2dv = cast(type_of(procs.glUniformMatrix4x2dv)) GetProcAddress(cast(*u8) "glUniformMatrix4x2dv\0");
    procs.glUniformMatrix4x3dv = cast(type_of(procs.glUniformMatrix4x3dv)) GetProcAddress(cast(*u8) "glUniformMatrix4x3dv\0");
    procs.glGetUniformdv = cast(type_of(procs.glGetUniformdv)) GetProcAddress(cast(*u8) "glGetUniformdv\0");
    procs.glGetSubroutineUniformLocation = cast(type_of(procs.glGetSubroutineUniformLocation)) GetProcAddress(cast(*u8) "glGetSubroutineUniformLocation\0");
    procs.glGetSubroutineIndex = cast(type_of(procs.glGetSubroutineIndex)) GetProcAddress(cast(*u8) "glGetSubroutineIndex\0");
    procs.glGetActiveSubroutineUniformiv = cast(type_of(procs.glGetActiveSubroutineUniformiv)) GetProcAddress(cast(*u8) "glGetActiveSubroutineUniformiv\0");
    procs.glGetActiveSubroutineUniformName = cast(type_of(procs.glGetActiveSubroutineUniformName)) GetProcAddress(cast(*u8) "glGetActiveSubroutineUniformName\0");
    procs.glGetActiveSubroutineName = cast(type_of(procs.glGetActiveSubroutineName)) GetProcAddress(cast(*u8) "glGetActiveSubroutineName\0");
    procs.glUniformSubroutinesuiv = cast(type_of(procs.glUniformSubroutinesuiv)) GetProcAddress(cast(*u8) "glUniformSubroutinesuiv\0");
    procs.glGetUniformSubroutineuiv = cast(type_of(procs.glGetUniformSubroutineuiv)) GetProcAddress(cast(*u8) "glGetUniformSubroutineuiv\0");
    procs.glGetProgramStageiv = cast(type_of(procs.glGetProgramStageiv)) GetProcAddress(cast(*u8) "glGetProgramStageiv\0");
    procs.glPatchParameteri = cast(type_of(procs.glPatchParameteri)) GetProcAddress(cast(*u8) "glPatchParameteri\0");
    procs.glPatchParameterfv = cast(type_of(procs.glPatchParameterfv)) GetProcAddress(cast(*u8) "glPatchParameterfv\0");
    procs.glBindTransformFeedback = cast(type_of(procs.glBindTransformFeedback)) GetProcAddress(cast(*u8) "glBindTransformFeedback\0");
    procs.glDeleteTransformFeedbacks = cast(type_of(procs.glDeleteTransformFeedbacks)) GetProcAddress(cast(*u8) "glDeleteTransformFeedbacks\0");
    procs.glGenTransformFeedbacks = cast(type_of(procs.glGenTransformFeedbacks)) GetProcAddress(cast(*u8) "glGenTransformFeedbacks\0");
    procs.glIsTransformFeedback = cast(type_of(procs.glIsTransformFeedback)) GetProcAddress(cast(*u8) "glIsTransformFeedback\0");
    procs.glPauseTransformFeedback = cast(type_of(procs.glPauseTransformFeedback)) GetProcAddress(cast(*u8) "glPauseTransformFeedback\0");
    procs.glResumeTransformFeedback = cast(type_of(procs.glResumeTransformFeedback)) GetProcAddress(cast(*u8) "glResumeTransformFeedback\0");
    procs.glDrawTransformFeedback = cast(type_of(procs.glDrawTransformFeedback)) GetProcAddress(cast(*u8) "glDrawTransformFeedback\0");
    procs.glDrawTransformFeedbackStream = cast(type_of(procs.glDrawTransformFeedbackStream)) GetProcAddress(cast(*u8) "glDrawTransformFeedbackStream\0");
    procs.glBeginQueryIndexed = cast(type_of(procs.glBeginQueryIndexed)) GetProcAddress(cast(*u8) "glBeginQueryIndexed\0");
    procs.glEndQueryIndexed = cast(type_of(procs.glEndQueryIndexed)) GetProcAddress(cast(*u8) "glEndQueryIndexed\0");
    procs.glGetQueryIndexediv = cast(type_of(procs.glGetQueryIndexediv)) GetProcAddress(cast(*u8) "glGetQueryIndexediv\0");
    procs.glReleaseShaderCompiler = cast(type_of(procs.glReleaseShaderCompiler)) GetProcAddress(cast(*u8) "glReleaseShaderCompiler\0");
    procs.glShaderBinary = cast(type_of(procs.glShaderBinary)) GetProcAddress(cast(*u8) "glShaderBinary\0");
    procs.glGetShaderPrecisionFormat = cast(type_of(procs.glGetShaderPrecisionFormat)) GetProcAddress(cast(*u8) "glGetShaderPrecisionFormat\0");
    procs.glDepthRangef = cast(type_of(procs.glDepthRangef)) GetProcAddress(cast(*u8) "glDepthRangef\0");
    procs.glClearDepthf = cast(type_of(procs.glClearDepthf)) GetProcAddress(cast(*u8) "glClearDepthf\0");
    procs.glGetProgramBinary = cast(type_of(procs.glGetProgramBinary)) GetProcAddress(cast(*u8) "glGetProgramBinary\0");
    procs.glProgramBinary = cast(type_of(procs.glProgramBinary)) GetProcAddress(cast(*u8) "glProgramBinary\0");
    procs.glProgramParameteri = cast(type_of(procs.glProgramParameteri)) GetProcAddress(cast(*u8) "glProgramParameteri\0");
    procs.glUseProgramStages = cast(type_of(procs.glUseProgramStages)) GetProcAddress(cast(*u8) "glUseProgramStages\0");
    procs.glActiveShaderProgram = cast(type_of(procs.glActiveShaderProgram)) GetProcAddress(cast(*u8) "glActiveShaderProgram\0");
    procs.glCreateShaderProgramv = cast(type_of(procs.glCreateShaderProgramv)) GetProcAddress(cast(*u8) "glCreateShaderProgramv\0");
    procs.glBindProgramPipeline = cast(type_of(procs.glBindProgramPipeline)) GetProcAddress(cast(*u8) "glBindProgramPipeline\0");
    procs.glDeleteProgramPipelines = cast(type_of(procs.glDeleteProgramPipelines)) GetProcAddress(cast(*u8) "glDeleteProgramPipelines\0");
    procs.glGenProgramPipelines = cast(type_of(procs.glGenProgramPipelines)) GetProcAddress(cast(*u8) "glGenProgramPipelines\0");
    procs.glIsProgramPipeline = cast(type_of(procs.glIsProgramPipeline)) GetProcAddress(cast(*u8) "glIsProgramPipeline\0");
    procs.glGetProgramPipelineiv = cast(type_of(procs.glGetProgramPipelineiv)) GetProcAddress(cast(*u8) "glGetProgramPipelineiv\0");
    procs.glProgramUniform1i = cast(type_of(procs.glProgramUniform1i)) GetProcAddress(cast(*u8) "glProgramUniform1i\0");
    procs.glProgramUniform1iv = cast(type_of(procs.glProgramUniform1iv)) GetProcAddress(cast(*u8) "glProgramUniform1iv\0");
    procs.glProgramUniform1f = cast(type_of(procs.glProgramUniform1f)) GetProcAddress(cast(*u8) "glProgramUniform1f\0");
    procs.glProgramUniform1fv = cast(type_of(procs.glProgramUniform1fv)) GetProcAddress(cast(*u8) "glProgramUniform1fv\0");
    procs.glProgramUniform1d = cast(type_of(procs.glProgramUniform1d)) GetProcAddress(cast(*u8) "glProgramUniform1d\0");
    procs.glProgramUniform1dv = cast(type_of(procs.glProgramUniform1dv)) GetProcAddress(cast(*u8) "glProgramUniform1dv\0");
    procs.glProgramUniform1ui = cast(type_of(procs.glProgramUniform1ui)) GetProcAddress(cast(*u8) "glProgramUniform1ui\0");
    procs.glProgramUniform1uiv = cast(type_of(procs.glProgramUniform1uiv)) GetProcAddress(cast(*u8) "glProgramUniform1uiv\0");
    procs.glProgramUniform2i = cast(type_of(procs.glProgramUniform2i)) GetProcAddress(cast(*u8) "glProgramUniform2i\0");
    procs.glProgramUniform2iv = cast(type_of(procs.glProgramUniform2iv)) GetProcAddress(cast(*u8) "glProgramUniform2iv\0");
    procs.glProgramUniform2f = cast(type_of(procs.glProgramUniform2f)) GetProcAddress(cast(*u8) "glProgramUniform2f\0");
    procs.glProgramUniform2fv = cast(type_of(procs.glProgramUniform2fv)) GetProcAddress(cast(*u8) "glProgramUniform2fv\0");
    procs.glProgramUniform2d = cast(type_of(procs.glProgramUniform2d)) GetProcAddress(cast(*u8) "glProgramUniform2d\0");
    procs.glProgramUniform2dv = cast(type_of(procs.glProgramUniform2dv)) GetProcAddress(cast(*u8) "glProgramUniform2dv\0");
    procs.glProgramUniform2ui = cast(type_of(procs.glProgramUniform2ui)) GetProcAddress(cast(*u8) "glProgramUniform2ui\0");
    procs.glProgramUniform2uiv = cast(type_of(procs.glProgramUniform2uiv)) GetProcAddress(cast(*u8) "glProgramUniform2uiv\0");
    procs.glProgramUniform3i = cast(type_of(procs.glProgramUniform3i)) GetProcAddress(cast(*u8) "glProgramUniform3i\0");
    procs.glProgramUniform3iv = cast(type_of(procs.glProgramUniform3iv)) GetProcAddress(cast(*u8) "glProgramUniform3iv\0");
    procs.glProgramUniform3f = cast(type_of(procs.glProgramUniform3f)) GetProcAddress(cast(*u8) "glProgramUniform3f\0");
    procs.glProgramUniform3fv = cast(type_of(procs.glProgramUniform3fv)) GetProcAddress(cast(*u8) "glProgramUniform3fv\0");
    procs.glProgramUniform3d = cast(type_of(procs.glProgramUniform3d)) GetProcAddress(cast(*u8) "glProgramUniform3d\0");
    procs.glProgramUniform3dv = cast(type_of(procs.glProgramUniform3dv)) GetProcAddress(cast(*u8) "glProgramUniform3dv\0");
    procs.glProgramUniform3ui = cast(type_of(procs.glProgramUniform3ui)) GetProcAddress(cast(*u8) "glProgramUniform3ui\0");
    procs.glProgramUniform3uiv = cast(type_of(procs.glProgramUniform3uiv)) GetProcAddress(cast(*u8) "glProgramUniform3uiv\0");
    procs.glProgramUniform4i = cast(type_of(procs.glProgramUniform4i)) GetProcAddress(cast(*u8) "glProgramUniform4i\0");
    procs.glProgramUniform4iv = cast(type_of(procs.glProgramUniform4iv)) GetProcAddress(cast(*u8) "glProgramUniform4iv\0");
    procs.glProgramUniform4f = cast(type_of(procs.glProgramUniform4f)) GetProcAddress(cast(*u8) "glProgramUniform4f\0");
    procs.glProgramUniform4fv = cast(type_of(procs.glProgramUniform4fv)) GetProcAddress(cast(*u8) "glProgramUniform4fv\0");
    procs.glProgramUniform4d = cast(type_of(procs.glProgramUniform4d)) GetProcAddress(cast(*u8) "glProgramUniform4d\0");
    procs.glProgramUniform4dv = cast(type_of(procs.glProgramUniform4dv)) GetProcAddress(cast(*u8) "glProgramUniform4dv\0");
    procs.glProgramUniform4ui = cast(type_of(procs.glProgramUniform4ui)) GetProcAddress(cast(*u8) "glProgramUniform4ui\0");
    procs.glProgramUniform4uiv = cast(type_of(procs.glProgramUniform4uiv)) GetProcAddress(cast(*u8) "glProgramUniform4uiv\0");
    procs.glProgramUniformMatrix2fv = cast(type_of(procs.glProgramUniformMatrix2fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2fv\0");
    procs.glProgramUniformMatrix3fv = cast(type_of(procs.glProgramUniformMatrix3fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3fv\0");
    procs.glProgramUniformMatrix4fv = cast(type_of(procs.glProgramUniformMatrix4fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4fv\0");
    procs.glProgramUniformMatrix2dv = cast(type_of(procs.glProgramUniformMatrix2dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2dv\0");
    procs.glProgramUniformMatrix3dv = cast(type_of(procs.glProgramUniformMatrix3dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3dv\0");
    procs.glProgramUniformMatrix4dv = cast(type_of(procs.glProgramUniformMatrix4dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4dv\0");
    procs.glProgramUniformMatrix2x3fv = cast(type_of(procs.glProgramUniformMatrix2x3fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x3fv\0");
    procs.glProgramUniformMatrix3x2fv = cast(type_of(procs.glProgramUniformMatrix3x2fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x2fv\0");
    procs.glProgramUniformMatrix2x4fv = cast(type_of(procs.glProgramUniformMatrix2x4fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x4fv\0");
    procs.glProgramUniformMatrix4x2fv = cast(type_of(procs.glProgramUniformMatrix4x2fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x2fv\0");
    procs.glProgramUniformMatrix3x4fv = cast(type_of(procs.glProgramUniformMatrix3x4fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x4fv\0");
    procs.glProgramUniformMatrix4x3fv = cast(type_of(procs.glProgramUniformMatrix4x3fv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x3fv\0");
    procs.glProgramUniformMatrix2x3dv = cast(type_of(procs.glProgramUniformMatrix2x3dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x3dv\0");
    procs.glProgramUniformMatrix3x2dv = cast(type_of(procs.glProgramUniformMatrix3x2dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x2dv\0");
    procs.glProgramUniformMatrix2x4dv = cast(type_of(procs.glProgramUniformMatrix2x4dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x4dv\0");
    procs.glProgramUniformMatrix4x2dv = cast(type_of(procs.glProgramUniformMatrix4x2dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x2dv\0");
    procs.glProgramUniformMatrix3x4dv = cast(type_of(procs.glProgramUniformMatrix3x4dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x4dv\0");
    procs.glProgramUniformMatrix4x3dv = cast(type_of(procs.glProgramUniformMatrix4x3dv)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x3dv\0");
    procs.glValidateProgramPipeline = cast(type_of(procs.glValidateProgramPipeline)) GetProcAddress(cast(*u8) "glValidateProgramPipeline\0");
    procs.glGetProgramPipelineInfoLog = cast(type_of(procs.glGetProgramPipelineInfoLog)) GetProcAddress(cast(*u8) "glGetProgramPipelineInfoLog\0");
    procs.glVertexAttribL1d = cast(type_of(procs.glVertexAttribL1d)) GetProcAddress(cast(*u8) "glVertexAttribL1d\0");
    procs.glVertexAttribL2d = cast(type_of(procs.glVertexAttribL2d)) GetProcAddress(cast(*u8) "glVertexAttribL2d\0");
    procs.glVertexAttribL3d = cast(type_of(procs.glVertexAttribL3d)) GetProcAddress(cast(*u8) "glVertexAttribL3d\0");
    procs.glVertexAttribL4d = cast(type_of(procs.glVertexAttribL4d)) GetProcAddress(cast(*u8) "glVertexAttribL4d\0");
    procs.glVertexAttribL1dv = cast(type_of(procs.glVertexAttribL1dv)) GetProcAddress(cast(*u8) "glVertexAttribL1dv\0");
    procs.glVertexAttribL2dv = cast(type_of(procs.glVertexAttribL2dv)) GetProcAddress(cast(*u8) "glVertexAttribL2dv\0");
    procs.glVertexAttribL3dv = cast(type_of(procs.glVertexAttribL3dv)) GetProcAddress(cast(*u8) "glVertexAttribL3dv\0");
    procs.glVertexAttribL4dv = cast(type_of(procs.glVertexAttribL4dv)) GetProcAddress(cast(*u8) "glVertexAttribL4dv\0");
    procs.glVertexAttribLPointer = cast(type_of(procs.glVertexAttribLPointer)) GetProcAddress(cast(*u8) "glVertexAttribLPointer\0");
    procs.glGetVertexAttribLdv = cast(type_of(procs.glGetVertexAttribLdv)) GetProcAddress(cast(*u8) "glGetVertexAttribLdv\0");
    procs.glViewportArrayv = cast(type_of(procs.glViewportArrayv)) GetProcAddress(cast(*u8) "glViewportArrayv\0");
    procs.glViewportIndexedf = cast(type_of(procs.glViewportIndexedf)) GetProcAddress(cast(*u8) "glViewportIndexedf\0");
    procs.glViewportIndexedfv = cast(type_of(procs.glViewportIndexedfv)) GetProcAddress(cast(*u8) "glViewportIndexedfv\0");
    procs.glScissorArrayv = cast(type_of(procs.glScissorArrayv)) GetProcAddress(cast(*u8) "glScissorArrayv\0");
    procs.glScissorIndexed = cast(type_of(procs.glScissorIndexed)) GetProcAddress(cast(*u8) "glScissorIndexed\0");
    procs.glScissorIndexedv = cast(type_of(procs.glScissorIndexedv)) GetProcAddress(cast(*u8) "glScissorIndexedv\0");
    procs.glDepthRangeArrayv = cast(type_of(procs.glDepthRangeArrayv)) GetProcAddress(cast(*u8) "glDepthRangeArrayv\0");
    procs.glDepthRangeIndexed = cast(type_of(procs.glDepthRangeIndexed)) GetProcAddress(cast(*u8) "glDepthRangeIndexed\0");
    procs.glGetFloati_v = cast(type_of(procs.glGetFloati_v)) GetProcAddress(cast(*u8) "glGetFloati_v\0");
    procs.glGetDoublei_v = cast(type_of(procs.glGetDoublei_v)) GetProcAddress(cast(*u8) "glGetDoublei_v\0");
    procs.glDrawArraysInstancedBaseInstance = cast(type_of(procs.glDrawArraysInstancedBaseInstance)) GetProcAddress(cast(*u8) "glDrawArraysInstancedBaseInstance\0");
    procs.glDrawElementsInstancedBaseInstance = cast(type_of(procs.glDrawElementsInstancedBaseInstance)) GetProcAddress(cast(*u8) "glDrawElementsInstancedBaseInstance\0");
    procs.glDrawElementsInstancedBaseVertexBaseInstance = cast(type_of(procs.glDrawElementsInstancedBaseVertexBaseInstance)) GetProcAddress(cast(*u8) "glDrawElementsInstancedBaseVertexBaseInstance\0");
    procs.glGetInternalformativ = cast(type_of(procs.glGetInternalformativ)) GetProcAddress(cast(*u8) "glGetInternalformativ\0");
    procs.glGetActiveAtomicCounterBufferiv = cast(type_of(procs.glGetActiveAtomicCounterBufferiv)) GetProcAddress(cast(*u8) "glGetActiveAtomicCounterBufferiv\0");
    procs.glBindImageTexture = cast(type_of(procs.glBindImageTexture)) GetProcAddress(cast(*u8) "glBindImageTexture\0");
    procs.glMemoryBarrier = cast(type_of(procs.glMemoryBarrier)) GetProcAddress(cast(*u8) "glMemoryBarrier\0");
    procs.glTexStorage1D = cast(type_of(procs.glTexStorage1D)) GetProcAddress(cast(*u8) "glTexStorage1D\0");
    procs.glTexStorage2D = cast(type_of(procs.glTexStorage2D)) GetProcAddress(cast(*u8) "glTexStorage2D\0");
    procs.glTexStorage3D = cast(type_of(procs.glTexStorage3D)) GetProcAddress(cast(*u8) "glTexStorage3D\0");
    procs.glDrawTransformFeedbackInstanced = cast(type_of(procs.glDrawTransformFeedbackInstanced)) GetProcAddress(cast(*u8) "glDrawTransformFeedbackInstanced\0");
    procs.glDrawTransformFeedbackStreamInstanced = cast(type_of(procs.glDrawTransformFeedbackStreamInstanced)) GetProcAddress(cast(*u8) "glDrawTransformFeedbackStreamInstanced\0");
    procs.glClearBufferData = cast(type_of(procs.glClearBufferData)) GetProcAddress(cast(*u8) "glClearBufferData\0");
    procs.glClearBufferSubData = cast(type_of(procs.glClearBufferSubData)) GetProcAddress(cast(*u8) "glClearBufferSubData\0");
    procs.glDispatchCompute = cast(type_of(procs.glDispatchCompute)) GetProcAddress(cast(*u8) "glDispatchCompute\0");
    procs.glDispatchComputeIndirect = cast(type_of(procs.glDispatchComputeIndirect)) GetProcAddress(cast(*u8) "glDispatchComputeIndirect\0");
    procs.glCopyImageSubData = cast(type_of(procs.glCopyImageSubData)) GetProcAddress(cast(*u8) "glCopyImageSubData\0");
    procs.glFramebufferParameteri = cast(type_of(procs.glFramebufferParameteri)) GetProcAddress(cast(*u8) "glFramebufferParameteri\0");
    procs.glGetFramebufferParameteriv = cast(type_of(procs.glGetFramebufferParameteriv)) GetProcAddress(cast(*u8) "glGetFramebufferParameteriv\0");
    procs.glGetInternalformati64v = cast(type_of(procs.glGetInternalformati64v)) GetProcAddress(cast(*u8) "glGetInternalformati64v\0");
    procs.glInvalidateTexSubImage = cast(type_of(procs.glInvalidateTexSubImage)) GetProcAddress(cast(*u8) "glInvalidateTexSubImage\0");
    procs.glInvalidateTexImage = cast(type_of(procs.glInvalidateTexImage)) GetProcAddress(cast(*u8) "glInvalidateTexImage\0");
    procs.glInvalidateBufferSubData = cast(type_of(procs.glInvalidateBufferSubData)) GetProcAddress(cast(*u8) "glInvalidateBufferSubData\0");
    procs.glInvalidateBufferData = cast(type_of(procs.glInvalidateBufferData)) GetProcAddress(cast(*u8) "glInvalidateBufferData\0");
    procs.glInvalidateFramebuffer = cast(type_of(procs.glInvalidateFramebuffer)) GetProcAddress(cast(*u8) "glInvalidateFramebuffer\0");
    procs.glInvalidateSubFramebuffer = cast(type_of(procs.glInvalidateSubFramebuffer)) GetProcAddress(cast(*u8) "glInvalidateSubFramebuffer\0");
    procs.glMultiDrawArraysIndirect = cast(type_of(procs.glMultiDrawArraysIndirect)) GetProcAddress(cast(*u8) "glMultiDrawArraysIndirect\0");
    procs.glMultiDrawElementsIndirect = cast(type_of(procs.glMultiDrawElementsIndirect)) GetProcAddress(cast(*u8) "glMultiDrawElementsIndirect\0");
    procs.glGetProgramInterfaceiv = cast(type_of(procs.glGetProgramInterfaceiv)) GetProcAddress(cast(*u8) "glGetProgramInterfaceiv\0");
    procs.glGetProgramResourceIndex = cast(type_of(procs.glGetProgramResourceIndex)) GetProcAddress(cast(*u8) "glGetProgramResourceIndex\0");
    procs.glGetProgramResourceName = cast(type_of(procs.glGetProgramResourceName)) GetProcAddress(cast(*u8) "glGetProgramResourceName\0");
    procs.glGetProgramResourceiv = cast(type_of(procs.glGetProgramResourceiv)) GetProcAddress(cast(*u8) "glGetProgramResourceiv\0");
    procs.glGetProgramResourceLocation = cast(type_of(procs.glGetProgramResourceLocation)) GetProcAddress(cast(*u8) "glGetProgramResourceLocation\0");
    procs.glGetProgramResourceLocationIndex = cast(type_of(procs.glGetProgramResourceLocationIndex)) GetProcAddress(cast(*u8) "glGetProgramResourceLocationIndex\0");
    procs.glShaderStorageBlockBinding = cast(type_of(procs.glShaderStorageBlockBinding)) GetProcAddress(cast(*u8) "glShaderStorageBlockBinding\0");
    procs.glTexBufferRange = cast(type_of(procs.glTexBufferRange)) GetProcAddress(cast(*u8) "glTexBufferRange\0");
    procs.glTexStorage2DMultisample = cast(type_of(procs.glTexStorage2DMultisample)) GetProcAddress(cast(*u8) "glTexStorage2DMultisample\0");
    procs.glTexStorage3DMultisample = cast(type_of(procs.glTexStorage3DMultisample)) GetProcAddress(cast(*u8) "glTexStorage3DMultisample\0");
    procs.glTextureView = cast(type_of(procs.glTextureView)) GetProcAddress(cast(*u8) "glTextureView\0");
    procs.glBindVertexBuffer = cast(type_of(procs.glBindVertexBuffer)) GetProcAddress(cast(*u8) "glBindVertexBuffer\0");
    procs.glVertexAttribFormat = cast(type_of(procs.glVertexAttribFormat)) GetProcAddress(cast(*u8) "glVertexAttribFormat\0");
    procs.glVertexAttribIFormat = cast(type_of(procs.glVertexAttribIFormat)) GetProcAddress(cast(*u8) "glVertexAttribIFormat\0");
    procs.glVertexAttribLFormat = cast(type_of(procs.glVertexAttribLFormat)) GetProcAddress(cast(*u8) "glVertexAttribLFormat\0");
    procs.glVertexAttribBinding = cast(type_of(procs.glVertexAttribBinding)) GetProcAddress(cast(*u8) "glVertexAttribBinding\0");
    procs.glVertexBindingDivisor = cast(type_of(procs.glVertexBindingDivisor)) GetProcAddress(cast(*u8) "glVertexBindingDivisor\0");
    procs.glDebugMessageControl = cast(type_of(procs.glDebugMessageControl)) GetProcAddress(cast(*u8) "glDebugMessageControl\0");
    procs.glDebugMessageInsert = cast(type_of(procs.glDebugMessageInsert)) GetProcAddress(cast(*u8) "glDebugMessageInsert\0");
    procs.glDebugMessageCallback = cast(type_of(procs.glDebugMessageCallback)) GetProcAddress(cast(*u8) "glDebugMessageCallback\0");
    procs.glGetDebugMessageLog = cast(type_of(procs.glGetDebugMessageLog)) GetProcAddress(cast(*u8) "glGetDebugMessageLog\0");
    procs.glPushDebugGroup = cast(type_of(procs.glPushDebugGroup)) GetProcAddress(cast(*u8) "glPushDebugGroup\0");
    procs.glPopDebugGroup = cast(type_of(procs.glPopDebugGroup)) GetProcAddress(cast(*u8) "glPopDebugGroup\0");
    procs.glObjectLabel = cast(type_of(procs.glObjectLabel)) GetProcAddress(cast(*u8) "glObjectLabel\0");
    procs.glGetObjectLabel = cast(type_of(procs.glGetObjectLabel)) GetProcAddress(cast(*u8) "glGetObjectLabel\0");
    procs.glObjectPtrLabel = cast(type_of(procs.glObjectPtrLabel)) GetProcAddress(cast(*u8) "glObjectPtrLabel\0");
    procs.glGetObjectPtrLabel = cast(type_of(procs.glGetObjectPtrLabel)) GetProcAddress(cast(*u8) "glGetObjectPtrLabel\0");
    procs.glBufferStorage = cast(type_of(procs.glBufferStorage)) GetProcAddress(cast(*u8) "glBufferStorage\0");
    procs.glClearTexImage = cast(type_of(procs.glClearTexImage)) GetProcAddress(cast(*u8) "glClearTexImage\0");
    procs.glClearTexSubImage = cast(type_of(procs.glClearTexSubImage)) GetProcAddress(cast(*u8) "glClearTexSubImage\0");
    procs.glBindBuffersBase = cast(type_of(procs.glBindBuffersBase)) GetProcAddress(cast(*u8) "glBindBuffersBase\0");
    procs.glBindBuffersRange = cast(type_of(procs.glBindBuffersRange)) GetProcAddress(cast(*u8) "glBindBuffersRange\0");
    procs.glBindTextures = cast(type_of(procs.glBindTextures)) GetProcAddress(cast(*u8) "glBindTextures\0");
    procs.glBindSamplers = cast(type_of(procs.glBindSamplers)) GetProcAddress(cast(*u8) "glBindSamplers\0");
    procs.glBindImageTextures = cast(type_of(procs.glBindImageTextures)) GetProcAddress(cast(*u8) "glBindImageTextures\0");
    procs.glBindVertexBuffers = cast(type_of(procs.glBindVertexBuffers)) GetProcAddress(cast(*u8) "glBindVertexBuffers\0");
    procs.glClipControl = cast(type_of(procs.glClipControl)) GetProcAddress(cast(*u8) "glClipControl\0");
    procs.glCreateTransformFeedbacks = cast(type_of(procs.glCreateTransformFeedbacks)) GetProcAddress(cast(*u8) "glCreateTransformFeedbacks\0");
    procs.glTransformFeedbackBufferBase = cast(type_of(procs.glTransformFeedbackBufferBase)) GetProcAddress(cast(*u8) "glTransformFeedbackBufferBase\0");
    procs.glTransformFeedbackBufferRange = cast(type_of(procs.glTransformFeedbackBufferRange)) GetProcAddress(cast(*u8) "glTransformFeedbackBufferRange\0");
    procs.glGetTransformFeedbackiv = cast(type_of(procs.glGetTransformFeedbackiv)) GetProcAddress(cast(*u8) "glGetTransformFeedbackiv\0");
    procs.glGetTransformFeedbacki_v = cast(type_of(procs.glGetTransformFeedbacki_v)) GetProcAddress(cast(*u8) "glGetTransformFeedbacki_v\0");
    procs.glGetTransformFeedbacki64_v = cast(type_of(procs.glGetTransformFeedbacki64_v)) GetProcAddress(cast(*u8) "glGetTransformFeedbacki64_v\0");
    procs.glCreateBuffers = cast(type_of(procs.glCreateBuffers)) GetProcAddress(cast(*u8) "glCreateBuffers\0");
    procs.glNamedBufferStorage = cast(type_of(procs.glNamedBufferStorage)) GetProcAddress(cast(*u8) "glNamedBufferStorage\0");
    procs.glNamedBufferData = cast(type_of(procs.glNamedBufferData)) GetProcAddress(cast(*u8) "glNamedBufferData\0");
    procs.glNamedBufferSubData = cast(type_of(procs.glNamedBufferSubData)) GetProcAddress(cast(*u8) "glNamedBufferSubData\0");
    procs.glCopyNamedBufferSubData = cast(type_of(procs.glCopyNamedBufferSubData)) GetProcAddress(cast(*u8) "glCopyNamedBufferSubData\0");
    procs.glClearNamedBufferData = cast(type_of(procs.glClearNamedBufferData)) GetProcAddress(cast(*u8) "glClearNamedBufferData\0");
    procs.glClearNamedBufferSubData = cast(type_of(procs.glClearNamedBufferSubData)) GetProcAddress(cast(*u8) "glClearNamedBufferSubData\0");
    procs.glMapNamedBuffer = cast(type_of(procs.glMapNamedBuffer)) GetProcAddress(cast(*u8) "glMapNamedBuffer\0");
    procs.glMapNamedBufferRange = cast(type_of(procs.glMapNamedBufferRange)) GetProcAddress(cast(*u8) "glMapNamedBufferRange\0");
    procs.glUnmapNamedBuffer = cast(type_of(procs.glUnmapNamedBuffer)) GetProcAddress(cast(*u8) "glUnmapNamedBuffer\0");
    procs.glFlushMappedNamedBufferRange = cast(type_of(procs.glFlushMappedNamedBufferRange)) GetProcAddress(cast(*u8) "glFlushMappedNamedBufferRange\0");
    procs.glGetNamedBufferParameteriv = cast(type_of(procs.glGetNamedBufferParameteriv)) GetProcAddress(cast(*u8) "glGetNamedBufferParameteriv\0");
    procs.glGetNamedBufferParameteri64v = cast(type_of(procs.glGetNamedBufferParameteri64v)) GetProcAddress(cast(*u8) "glGetNamedBufferParameteri64v\0");
    procs.glGetNamedBufferPointerv = cast(type_of(procs.glGetNamedBufferPointerv)) GetProcAddress(cast(*u8) "glGetNamedBufferPointerv\0");
    procs.glGetNamedBufferSubData = cast(type_of(procs.glGetNamedBufferSubData)) GetProcAddress(cast(*u8) "glGetNamedBufferSubData\0");
    procs.glCreateFramebuffers = cast(type_of(procs.glCreateFramebuffers)) GetProcAddress(cast(*u8) "glCreateFramebuffers\0");
    procs.glNamedFramebufferRenderbuffer = cast(type_of(procs.glNamedFramebufferRenderbuffer)) GetProcAddress(cast(*u8) "glNamedFramebufferRenderbuffer\0");
    procs.glNamedFramebufferParameteri = cast(type_of(procs.glNamedFramebufferParameteri)) GetProcAddress(cast(*u8) "glNamedFramebufferParameteri\0");
    procs.glNamedFramebufferTexture = cast(type_of(procs.glNamedFramebufferTexture)) GetProcAddress(cast(*u8) "glNamedFramebufferTexture\0");
    procs.glNamedFramebufferTextureLayer = cast(type_of(procs.glNamedFramebufferTextureLayer)) GetProcAddress(cast(*u8) "glNamedFramebufferTextureLayer\0");
    procs.glNamedFramebufferDrawBuffer = cast(type_of(procs.glNamedFramebufferDrawBuffer)) GetProcAddress(cast(*u8) "glNamedFramebufferDrawBuffer\0");
    procs.glNamedFramebufferDrawBuffers = cast(type_of(procs.glNamedFramebufferDrawBuffers)) GetProcAddress(cast(*u8) "glNamedFramebufferDrawBuffers\0");
    procs.glNamedFramebufferReadBuffer = cast(type_of(procs.glNamedFramebufferReadBuffer)) GetProcAddress(cast(*u8) "glNamedFramebufferReadBuffer\0");
    procs.glInvalidateNamedFramebufferData = cast(type_of(procs.glInvalidateNamedFramebufferData)) GetProcAddress(cast(*u8) "glInvalidateNamedFramebufferData\0");
    procs.glInvalidateNamedFramebufferSubData = cast(type_of(procs.glInvalidateNamedFramebufferSubData)) GetProcAddress(cast(*u8) "glInvalidateNamedFramebufferSubData\0");
    procs.glClearNamedFramebufferiv = cast(type_of(procs.glClearNamedFramebufferiv)) GetProcAddress(cast(*u8) "glClearNamedFramebufferiv\0");
    procs.glClearNamedFramebufferuiv = cast(type_of(procs.glClearNamedFramebufferuiv)) GetProcAddress(cast(*u8) "glClearNamedFramebufferuiv\0");
    procs.glClearNamedFramebufferfv = cast(type_of(procs.glClearNamedFramebufferfv)) GetProcAddress(cast(*u8) "glClearNamedFramebufferfv\0");
    procs.glClearNamedFramebufferfi = cast(type_of(procs.glClearNamedFramebufferfi)) GetProcAddress(cast(*u8) "glClearNamedFramebufferfi\0");
    procs.glBlitNamedFramebuffer = cast(type_of(procs.glBlitNamedFramebuffer)) GetProcAddress(cast(*u8) "glBlitNamedFramebuffer\0");
    procs.glCheckNamedFramebufferStatus = cast(type_of(procs.glCheckNamedFramebufferStatus)) GetProcAddress(cast(*u8) "glCheckNamedFramebufferStatus\0");
    procs.glGetNamedFramebufferParameteriv = cast(type_of(procs.glGetNamedFramebufferParameteriv)) GetProcAddress(cast(*u8) "glGetNamedFramebufferParameteriv\0");
    procs.glGetNamedFramebufferAttachmentParameteriv = cast(type_of(procs.glGetNamedFramebufferAttachmentParameteriv)) GetProcAddress(cast(*u8) "glGetNamedFramebufferAttachmentParameteriv\0");
    procs.glCreateRenderbuffers = cast(type_of(procs.glCreateRenderbuffers)) GetProcAddress(cast(*u8) "glCreateRenderbuffers\0");
    procs.glNamedRenderbufferStorage = cast(type_of(procs.glNamedRenderbufferStorage)) GetProcAddress(cast(*u8) "glNamedRenderbufferStorage\0");
    procs.glNamedRenderbufferStorageMultisample = cast(type_of(procs.glNamedRenderbufferStorageMultisample)) GetProcAddress(cast(*u8) "glNamedRenderbufferStorageMultisample\0");
    procs.glGetNamedRenderbufferParameteriv = cast(type_of(procs.glGetNamedRenderbufferParameteriv)) GetProcAddress(cast(*u8) "glGetNamedRenderbufferParameteriv\0");
    procs.glCreateTextures = cast(type_of(procs.glCreateTextures)) GetProcAddress(cast(*u8) "glCreateTextures\0");
    procs.glTextureBuffer = cast(type_of(procs.glTextureBuffer)) GetProcAddress(cast(*u8) "glTextureBuffer\0");
    procs.glTextureBufferRange = cast(type_of(procs.glTextureBufferRange)) GetProcAddress(cast(*u8) "glTextureBufferRange\0");
    procs.glTextureStorage1D = cast(type_of(procs.glTextureStorage1D)) GetProcAddress(cast(*u8) "glTextureStorage1D\0");
    procs.glTextureStorage2D = cast(type_of(procs.glTextureStorage2D)) GetProcAddress(cast(*u8) "glTextureStorage2D\0");
    procs.glTextureStorage3D = cast(type_of(procs.glTextureStorage3D)) GetProcAddress(cast(*u8) "glTextureStorage3D\0");
    procs.glTextureStorage2DMultisample = cast(type_of(procs.glTextureStorage2DMultisample)) GetProcAddress(cast(*u8) "glTextureStorage2DMultisample\0");
    procs.glTextureStorage3DMultisample = cast(type_of(procs.glTextureStorage3DMultisample)) GetProcAddress(cast(*u8) "glTextureStorage3DMultisample\0");
    procs.glTextureSubImage1D = cast(type_of(procs.glTextureSubImage1D)) GetProcAddress(cast(*u8) "glTextureSubImage1D\0");
    procs.glTextureSubImage2D = cast(type_of(procs.glTextureSubImage2D)) GetProcAddress(cast(*u8) "glTextureSubImage2D\0");
    procs.glTextureSubImage3D = cast(type_of(procs.glTextureSubImage3D)) GetProcAddress(cast(*u8) "glTextureSubImage3D\0");
    procs.glCompressedTextureSubImage1D = cast(type_of(procs.glCompressedTextureSubImage1D)) GetProcAddress(cast(*u8) "glCompressedTextureSubImage1D\0");
    procs.glCompressedTextureSubImage2D = cast(type_of(procs.glCompressedTextureSubImage2D)) GetProcAddress(cast(*u8) "glCompressedTextureSubImage2D\0");
    procs.glCompressedTextureSubImage3D = cast(type_of(procs.glCompressedTextureSubImage3D)) GetProcAddress(cast(*u8) "glCompressedTextureSubImage3D\0");
    procs.glCopyTextureSubImage1D = cast(type_of(procs.glCopyTextureSubImage1D)) GetProcAddress(cast(*u8) "glCopyTextureSubImage1D\0");
    procs.glCopyTextureSubImage2D = cast(type_of(procs.glCopyTextureSubImage2D)) GetProcAddress(cast(*u8) "glCopyTextureSubImage2D\0");
    procs.glCopyTextureSubImage3D = cast(type_of(procs.glCopyTextureSubImage3D)) GetProcAddress(cast(*u8) "glCopyTextureSubImage3D\0");
    procs.glTextureParameterf = cast(type_of(procs.glTextureParameterf)) GetProcAddress(cast(*u8) "glTextureParameterf\0");
    procs.glTextureParameterfv = cast(type_of(procs.glTextureParameterfv)) GetProcAddress(cast(*u8) "glTextureParameterfv\0");
    procs.glTextureParameteri = cast(type_of(procs.glTextureParameteri)) GetProcAddress(cast(*u8) "glTextureParameteri\0");
    procs.glTextureParameterIiv = cast(type_of(procs.glTextureParameterIiv)) GetProcAddress(cast(*u8) "glTextureParameterIiv\0");
    procs.glTextureParameterIuiv = cast(type_of(procs.glTextureParameterIuiv)) GetProcAddress(cast(*u8) "glTextureParameterIuiv\0");
    procs.glTextureParameteriv = cast(type_of(procs.glTextureParameteriv)) GetProcAddress(cast(*u8) "glTextureParameteriv\0");
    procs.glGenerateTextureMipmap = cast(type_of(procs.glGenerateTextureMipmap)) GetProcAddress(cast(*u8) "glGenerateTextureMipmap\0");
    procs.glBindTextureUnit = cast(type_of(procs.glBindTextureUnit)) GetProcAddress(cast(*u8) "glBindTextureUnit\0");
    procs.glGetTextureImage = cast(type_of(procs.glGetTextureImage)) GetProcAddress(cast(*u8) "glGetTextureImage\0");
    procs.glGetCompressedTextureImage = cast(type_of(procs.glGetCompressedTextureImage)) GetProcAddress(cast(*u8) "glGetCompressedTextureImage\0");
    procs.glGetTextureLevelParameterfv = cast(type_of(procs.glGetTextureLevelParameterfv)) GetProcAddress(cast(*u8) "glGetTextureLevelParameterfv\0");
    procs.glGetTextureLevelParameteriv = cast(type_of(procs.glGetTextureLevelParameteriv)) GetProcAddress(cast(*u8) "glGetTextureLevelParameteriv\0");
    procs.glGetTextureParameterfv = cast(type_of(procs.glGetTextureParameterfv)) GetProcAddress(cast(*u8) "glGetTextureParameterfv\0");
    procs.glGetTextureParameterIiv = cast(type_of(procs.glGetTextureParameterIiv)) GetProcAddress(cast(*u8) "glGetTextureParameterIiv\0");
    procs.glGetTextureParameterIuiv = cast(type_of(procs.glGetTextureParameterIuiv)) GetProcAddress(cast(*u8) "glGetTextureParameterIuiv\0");
    procs.glGetTextureParameteriv = cast(type_of(procs.glGetTextureParameteriv)) GetProcAddress(cast(*u8) "glGetTextureParameteriv\0");
    procs.glCreateVertexArrays = cast(type_of(procs.glCreateVertexArrays)) GetProcAddress(cast(*u8) "glCreateVertexArrays\0");
    procs.glDisableVertexArrayAttrib = cast(type_of(procs.glDisableVertexArrayAttrib)) GetProcAddress(cast(*u8) "glDisableVertexArrayAttrib\0");
    procs.glEnableVertexArrayAttrib = cast(type_of(procs.glEnableVertexArrayAttrib)) GetProcAddress(cast(*u8) "glEnableVertexArrayAttrib\0");
    procs.glVertexArrayElementBuffer = cast(type_of(procs.glVertexArrayElementBuffer)) GetProcAddress(cast(*u8) "glVertexArrayElementBuffer\0");
    procs.glVertexArrayVertexBuffer = cast(type_of(procs.glVertexArrayVertexBuffer)) GetProcAddress(cast(*u8) "glVertexArrayVertexBuffer\0");
    procs.glVertexArrayVertexBuffers = cast(type_of(procs.glVertexArrayVertexBuffers)) GetProcAddress(cast(*u8) "glVertexArrayVertexBuffers\0");
    procs.glVertexArrayAttribBinding = cast(type_of(procs.glVertexArrayAttribBinding)) GetProcAddress(cast(*u8) "glVertexArrayAttribBinding\0");
    procs.glVertexArrayAttribFormat = cast(type_of(procs.glVertexArrayAttribFormat)) GetProcAddress(cast(*u8) "glVertexArrayAttribFormat\0");
    procs.glVertexArrayAttribIFormat = cast(type_of(procs.glVertexArrayAttribIFormat)) GetProcAddress(cast(*u8) "glVertexArrayAttribIFormat\0");
    procs.glVertexArrayAttribLFormat = cast(type_of(procs.glVertexArrayAttribLFormat)) GetProcAddress(cast(*u8) "glVertexArrayAttribLFormat\0");
    procs.glVertexArrayBindingDivisor = cast(type_of(procs.glVertexArrayBindingDivisor)) GetProcAddress(cast(*u8) "glVertexArrayBindingDivisor\0");
    procs.glGetVertexArrayiv = cast(type_of(procs.glGetVertexArrayiv)) GetProcAddress(cast(*u8) "glGetVertexArrayiv\0");
    procs.glGetVertexArrayIndexediv = cast(type_of(procs.glGetVertexArrayIndexediv)) GetProcAddress(cast(*u8) "glGetVertexArrayIndexediv\0");
    procs.glGetVertexArrayIndexed64iv = cast(type_of(procs.glGetVertexArrayIndexed64iv)) GetProcAddress(cast(*u8) "glGetVertexArrayIndexed64iv\0");
    procs.glCreateSamplers = cast(type_of(procs.glCreateSamplers)) GetProcAddress(cast(*u8) "glCreateSamplers\0");
    procs.glCreateProgramPipelines = cast(type_of(procs.glCreateProgramPipelines)) GetProcAddress(cast(*u8) "glCreateProgramPipelines\0");
    procs.glCreateQueries = cast(type_of(procs.glCreateQueries)) GetProcAddress(cast(*u8) "glCreateQueries\0");
    procs.glGetQueryBufferObjecti64v = cast(type_of(procs.glGetQueryBufferObjecti64v)) GetProcAddress(cast(*u8) "glGetQueryBufferObjecti64v\0");
    procs.glGetQueryBufferObjectiv = cast(type_of(procs.glGetQueryBufferObjectiv)) GetProcAddress(cast(*u8) "glGetQueryBufferObjectiv\0");
    procs.glGetQueryBufferObjectui64v = cast(type_of(procs.glGetQueryBufferObjectui64v)) GetProcAddress(cast(*u8) "glGetQueryBufferObjectui64v\0");
    procs.glGetQueryBufferObjectuiv = cast(type_of(procs.glGetQueryBufferObjectuiv)) GetProcAddress(cast(*u8) "glGetQueryBufferObjectuiv\0");
    procs.glMemoryBarrierByRegion = cast(type_of(procs.glMemoryBarrierByRegion)) GetProcAddress(cast(*u8) "glMemoryBarrierByRegion\0");
    procs.glGetTextureSubImage = cast(type_of(procs.glGetTextureSubImage)) GetProcAddress(cast(*u8) "glGetTextureSubImage\0");
    procs.glGetCompressedTextureSubImage = cast(type_of(procs.glGetCompressedTextureSubImage)) GetProcAddress(cast(*u8) "glGetCompressedTextureSubImage\0");
    procs.glGetGraphicsResetStatus = cast(type_of(procs.glGetGraphicsResetStatus)) GetProcAddress(cast(*u8) "glGetGraphicsResetStatus\0");
    procs.glGetnCompressedTexImage = cast(type_of(procs.glGetnCompressedTexImage)) GetProcAddress(cast(*u8) "glGetnCompressedTexImage\0");
    procs.glGetnTexImage = cast(type_of(procs.glGetnTexImage)) GetProcAddress(cast(*u8) "glGetnTexImage\0");
    procs.glGetnUniformdv = cast(type_of(procs.glGetnUniformdv)) GetProcAddress(cast(*u8) "glGetnUniformdv\0");
    procs.glGetnUniformfv = cast(type_of(procs.glGetnUniformfv)) GetProcAddress(cast(*u8) "glGetnUniformfv\0");
    procs.glGetnUniformiv = cast(type_of(procs.glGetnUniformiv)) GetProcAddress(cast(*u8) "glGetnUniformiv\0");
    procs.glGetnUniformuiv = cast(type_of(procs.glGetnUniformuiv)) GetProcAddress(cast(*u8) "glGetnUniformuiv\0");
    procs.glReadnPixels = cast(type_of(procs.glReadnPixels)) GetProcAddress(cast(*u8) "glReadnPixels\0");
    procs.glGetnMapdv = cast(type_of(procs.glGetnMapdv)) GetProcAddress(cast(*u8) "glGetnMapdv\0");
    procs.glGetnMapfv = cast(type_of(procs.glGetnMapfv)) GetProcAddress(cast(*u8) "glGetnMapfv\0");
    procs.glGetnMapiv = cast(type_of(procs.glGetnMapiv)) GetProcAddress(cast(*u8) "glGetnMapiv\0");
    procs.glGetnPixelMapfv = cast(type_of(procs.glGetnPixelMapfv)) GetProcAddress(cast(*u8) "glGetnPixelMapfv\0");
    procs.glGetnPixelMapuiv = cast(type_of(procs.glGetnPixelMapuiv)) GetProcAddress(cast(*u8) "glGetnPixelMapuiv\0");
    procs.glGetnPixelMapusv = cast(type_of(procs.glGetnPixelMapusv)) GetProcAddress(cast(*u8) "glGetnPixelMapusv\0");
    procs.glGetnPolygonStipple = cast(type_of(procs.glGetnPolygonStipple)) GetProcAddress(cast(*u8) "glGetnPolygonStipple\0");
    procs.glGetnColorTable = cast(type_of(procs.glGetnColorTable)) GetProcAddress(cast(*u8) "glGetnColorTable\0");
    procs.glGetnConvolutionFilter = cast(type_of(procs.glGetnConvolutionFilter)) GetProcAddress(cast(*u8) "glGetnConvolutionFilter\0");
    procs.glGetnSeparableFilter = cast(type_of(procs.glGetnSeparableFilter)) GetProcAddress(cast(*u8) "glGetnSeparableFilter\0");
    procs.glGetnHistogram = cast(type_of(procs.glGetnHistogram)) GetProcAddress(cast(*u8) "glGetnHistogram\0");
    procs.glGetnMinmax = cast(type_of(procs.glGetnMinmax)) GetProcAddress(cast(*u8) "glGetnMinmax\0");
    procs.glTextureBarrier = cast(type_of(procs.glTextureBarrier)) GetProcAddress(cast(*u8) "glTextureBarrier\0");
    procs.glSpecializeShader = cast(type_of(procs.glSpecializeShader)) GetProcAddress(cast(*u8) "glSpecializeShader\0");
    procs.glMultiDrawArraysIndirectCount = cast(type_of(procs.glMultiDrawArraysIndirectCount)) GetProcAddress(cast(*u8) "glMultiDrawArraysIndirectCount\0");
    procs.glMultiDrawElementsIndirectCount = cast(type_of(procs.glMultiDrawElementsIndirectCount)) GetProcAddress(cast(*u8) "glMultiDrawElementsIndirectCount\0");
    procs.glPolygonOffsetClamp = cast(type_of(procs.glPolygonOffsetClamp)) GetProcAddress(cast(*u8) "glPolygonOffsetClamp\0");
    procs.glDebugMessageControlARB = cast(type_of(procs.glDebugMessageControlARB)) GetProcAddress(cast(*u8) "glDebugMessageControlARB\0");
    procs.glDebugMessageInsertARB = cast(type_of(procs.glDebugMessageInsertARB)) GetProcAddress(cast(*u8) "glDebugMessageInsertARB\0");
    procs.glDebugMessageCallbackARB = cast(type_of(procs.glDebugMessageCallbackARB)) GetProcAddress(cast(*u8) "glDebugMessageCallbackARB\0");
    procs.glGetDebugMessageLogARB = cast(type_of(procs.glGetDebugMessageLogARB)) GetProcAddress(cast(*u8) "glGetDebugMessageLogARB\0");
    procs.glLabelObjectEXT = cast(type_of(procs.glLabelObjectEXT)) GetProcAddress(cast(*u8) "glLabelObjectEXT\0");
    procs.glGetObjectLabelEXT = cast(type_of(procs.glGetObjectLabelEXT)) GetProcAddress(cast(*u8) "glGetObjectLabelEXT\0");
    procs.glInsertEventMarkerEXT = cast(type_of(procs.glInsertEventMarkerEXT)) GetProcAddress(cast(*u8) "glInsertEventMarkerEXT\0");
    procs.glPushGroupMarkerEXT = cast(type_of(procs.glPushGroupMarkerEXT)) GetProcAddress(cast(*u8) "glPushGroupMarkerEXT\0");
    procs.glPopGroupMarkerEXT = cast(type_of(procs.glPopGroupMarkerEXT)) GetProcAddress(cast(*u8) "glPopGroupMarkerEXT\0");
    procs.glGetPointerv = cast(type_of(procs.glGetPointerv)) GetProcAddress(cast(*u8) "glGetPointerv\0");
    procs.glDebugMessageControlKHR = cast(type_of(procs.glDebugMessageControlKHR)) GetProcAddress(cast(*u8) "glDebugMessageControlKHR\0");
    procs.glDebugMessageInsertKHR = cast(type_of(procs.glDebugMessageInsertKHR)) GetProcAddress(cast(*u8) "glDebugMessageInsertKHR\0");
    procs.glDebugMessageCallbackKHR = cast(type_of(procs.glDebugMessageCallbackKHR)) GetProcAddress(cast(*u8) "glDebugMessageCallbackKHR\0");
    procs.glGetDebugMessageLogKHR = cast(type_of(procs.glGetDebugMessageLogKHR)) GetProcAddress(cast(*u8) "glGetDebugMessageLogKHR\0");
    procs.glPushDebugGroupKHR = cast(type_of(procs.glPushDebugGroupKHR)) GetProcAddress(cast(*u8) "glPushDebugGroupKHR\0");
    procs.glPopDebugGroupKHR = cast(type_of(procs.glPopDebugGroupKHR)) GetProcAddress(cast(*u8) "glPopDebugGroupKHR\0");
    procs.glObjectLabelKHR = cast(type_of(procs.glObjectLabelKHR)) GetProcAddress(cast(*u8) "glObjectLabelKHR\0");
    procs.glGetObjectLabelKHR = cast(type_of(procs.glGetObjectLabelKHR)) GetProcAddress(cast(*u8) "glGetObjectLabelKHR\0");
    procs.glObjectPtrLabelKHR = cast(type_of(procs.glObjectPtrLabelKHR)) GetProcAddress(cast(*u8) "glObjectPtrLabelKHR\0");
    procs.glGetObjectPtrLabelKHR = cast(type_of(procs.glGetObjectPtrLabelKHR)) GetProcAddress(cast(*u8) "glGetObjectPtrLabelKHR\0");
    procs.glGetPointervKHR = cast(type_of(procs.glGetPointervKHR)) GetProcAddress(cast(*u8) "glGetPointervKHR\0");
    procs.glDepthRangedNV = cast(type_of(procs.glDepthRangedNV)) GetProcAddress(cast(*u8) "glDepthRangedNV\0");
    procs.glClearDepthdNV = cast(type_of(procs.glClearDepthdNV)) GetProcAddress(cast(*u8) "glClearDepthdNV\0");
    procs.glDepthBoundsdNV = cast(type_of(procs.glDepthBoundsdNV)) GetProcAddress(cast(*u8) "glDepthBoundsdNV\0");
    raw_version := procs.glGetString(GL_VERSION);
    major, minor := gl_parse_version(_gl_string(raw_version));
    procs.gl_version_major = major;
    procs.gl_version_minor = minor;
    procs.GL_VERSION_1_0 = major > 1 || (major == 1 && minor >= 0);
    procs.GL_VERSION_1_1 = major > 1 || (major == 1 && minor >= 1);
    procs.GL_VERSION_1_2 = major > 1 || (major == 1 && minor >= 2);
    procs.GL_VERSION_1_3 = major > 1 || (major == 1 && minor >= 3);
    procs.GL_VERSION_1_4 = major > 1 || (major == 1 && minor >= 4);
    procs.GL_VERSION_1_5 = major > 1 || (major == 1 && minor >= 5);
    procs.GL_VERSION_2_0 = major > 2 || (major == 2 && minor >= 0);
    procs.GL_VERSION_2_1 = major > 2 || (major == 2 && minor >= 1);
    procs.GL_VERSION_3_0 = major > 3 || (major == 3 && minor >= 0);
    procs.GL_VERSION_3_1 = major > 3 || (major == 3 && minor >= 1);
    procs.GL_VERSION_3_2 = major > 3 || (major == 3 && minor >= 2);
    procs.GL_VERSION_3_3 = major > 3 || (major == 3 && minor >= 3);
    procs.GL_VERSION_4_0 = major > 4 || (major == 4 && minor >= 0);
    procs.GL_VERSION_4_1 = major > 4 || (major == 4 && minor >= 1);
    procs.GL_VERSION_4_2 = major > 4 || (major == 4 && minor >= 2);
    procs.GL_VERSION_4_3 = major > 4 || (major == 4 && minor >= 3);
    procs.GL_VERSION_4_4 = major > 4 || (major == 4 && minor >= 4);
    procs.GL_VERSION_4_5 = major > 4 || (major == 4 && minor >= 5);
    procs.GL_VERSION_4_6 = major > 4 || (major == 4 && minor >= 6);
    procs.GL_ARB_clip_control = _gl_has_extension(procs, "GL_ARB_clip_control");
    procs.GL_ARB_debug_output = _gl_has_extension(procs, "GL_ARB_debug_output");
    procs.GL_ARB_direct_state_access = _gl_has_extension(procs, "GL_ARB_direct_state_access");
    procs.GL_ARB_parallel_shader_compile = _gl_has_extension(procs, "GL_ARB_parallel_shader_compile");
    procs.GL_ARB_sampler_objects = _gl_has_extension(procs, "GL_ARB_sampler_objects");
    procs.GL_ARB_seamless_cube_map = _gl_has_extension(procs, "GL_ARB_seamless_cube_map");
    procs.GL_ARB_shader_viewport_layer_array = _gl_has_extension(procs, "GL_ARB_shader_viewport_layer_array");
    procs.GL_ARB_texture_storage = _gl_has_extension(procs, "GL_ARB_texture_storage");
    procs.GL_ARB_vertex_attrib_binding = _gl_has_extension(procs, "GL_ARB_vertex_attrib_binding");
    procs.GL_AMD_vertex_shader_viewport_index = _gl_has_extension(procs, "GL_AMD_vertex_shader_viewport_index");
    procs.GL_EXT_debug_label = _gl_has_extension(procs, "GL_EXT_debug_label");
    procs.GL_EXT_debug_marker = _gl_has_extension(procs, "GL_EXT_debug_marker");
    procs.GL_EXT_texture_compression_latc = _gl_has_extension(procs, "GL_EXT_texture_compression_latc");
    procs.GL_EXT_texture_compression_rgtc = _gl_has_extension(procs, "GL_EXT_texture_compression_rgtc");
    procs.GL_EXT_texture_compression_s3tc = _gl_has_extension(procs, "GL_EXT_texture_compression_s3tc");
    procs.GL_EXT_texture_filter_anisotropic = _gl_has_extension(procs, "GL_EXT_texture_filter_anisotropic");
    procs.GL_EXT_texture_sRGB = _gl_has_extension(procs, "GL_EXT_texture_sRGB");
    procs.GL_KHR_debug = _gl_has_extension(procs, "GL_KHR_debug");
    procs.GL_NV_depth_buffer_float = _gl_has_extension(procs, "GL_NV_depth_buffer_float");
    procs.GL_S3_s3tc = _gl_has_extension(procs, "GL_S3_s3tc");
}
