// Explicit assignments generated from authored ABI fields and current canonical GL names.
gl_load :: (procs: *GL_Procedures, GetProcAddress: GetProcAddressFunction = null) {
    if GetProcAddress == null GetProcAddress = _gl_platform_get_proc;
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
        procs.glNewList = cast(type_of(procs.glNewList)) GetProcAddress(cast(*u8) "glNewList\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEndList = cast(type_of(procs.glEndList)) GetProcAddress(cast(*u8) "glEndList\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glCallList = cast(type_of(procs.glCallList)) GetProcAddress(cast(*u8) "glCallList\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glCallLists = cast(type_of(procs.glCallLists)) GetProcAddress(cast(*u8) "glCallLists\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glDeleteLists = cast(type_of(procs.glDeleteLists)) GetProcAddress(cast(*u8) "glDeleteLists\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGenLists = cast(type_of(procs.glGenLists)) GetProcAddress(cast(*u8) "glGenLists\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glListBase = cast(type_of(procs.glListBase)) GetProcAddress(cast(*u8) "glListBase\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glBegin = cast(type_of(procs.glBegin)) GetProcAddress(cast(*u8) "glBegin\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glBitmap = cast(type_of(procs.glBitmap)) GetProcAddress(cast(*u8) "glBitmap\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3b = cast(type_of(procs.glColor3b)) GetProcAddress(cast(*u8) "glColor3b\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3bv = cast(type_of(procs.glColor3bv)) GetProcAddress(cast(*u8) "glColor3bv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3d = cast(type_of(procs.glColor3d)) GetProcAddress(cast(*u8) "glColor3d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3dv = cast(type_of(procs.glColor3dv)) GetProcAddress(cast(*u8) "glColor3dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3f = cast(type_of(procs.glColor3f)) GetProcAddress(cast(*u8) "glColor3f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3fv = cast(type_of(procs.glColor3fv)) GetProcAddress(cast(*u8) "glColor3fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3i = cast(type_of(procs.glColor3i)) GetProcAddress(cast(*u8) "glColor3i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3iv = cast(type_of(procs.glColor3iv)) GetProcAddress(cast(*u8) "glColor3iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3s = cast(type_of(procs.glColor3s)) GetProcAddress(cast(*u8) "glColor3s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3sv = cast(type_of(procs.glColor3sv)) GetProcAddress(cast(*u8) "glColor3sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3ub = cast(type_of(procs.glColor3ub)) GetProcAddress(cast(*u8) "glColor3ub\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3ubv = cast(type_of(procs.glColor3ubv)) GetProcAddress(cast(*u8) "glColor3ubv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3ui = cast(type_of(procs.glColor3ui)) GetProcAddress(cast(*u8) "glColor3ui\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3uiv = cast(type_of(procs.glColor3uiv)) GetProcAddress(cast(*u8) "glColor3uiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3us = cast(type_of(procs.glColor3us)) GetProcAddress(cast(*u8) "glColor3us\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor3usv = cast(type_of(procs.glColor3usv)) GetProcAddress(cast(*u8) "glColor3usv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4b = cast(type_of(procs.glColor4b)) GetProcAddress(cast(*u8) "glColor4b\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4bv = cast(type_of(procs.glColor4bv)) GetProcAddress(cast(*u8) "glColor4bv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4d = cast(type_of(procs.glColor4d)) GetProcAddress(cast(*u8) "glColor4d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4dv = cast(type_of(procs.glColor4dv)) GetProcAddress(cast(*u8) "glColor4dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4f = cast(type_of(procs.glColor4f)) GetProcAddress(cast(*u8) "glColor4f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4fv = cast(type_of(procs.glColor4fv)) GetProcAddress(cast(*u8) "glColor4fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4i = cast(type_of(procs.glColor4i)) GetProcAddress(cast(*u8) "glColor4i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4iv = cast(type_of(procs.glColor4iv)) GetProcAddress(cast(*u8) "glColor4iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4s = cast(type_of(procs.glColor4s)) GetProcAddress(cast(*u8) "glColor4s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4sv = cast(type_of(procs.glColor4sv)) GetProcAddress(cast(*u8) "glColor4sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4ub = cast(type_of(procs.glColor4ub)) GetProcAddress(cast(*u8) "glColor4ub\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4ubv = cast(type_of(procs.glColor4ubv)) GetProcAddress(cast(*u8) "glColor4ubv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4ui = cast(type_of(procs.glColor4ui)) GetProcAddress(cast(*u8) "glColor4ui\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4uiv = cast(type_of(procs.glColor4uiv)) GetProcAddress(cast(*u8) "glColor4uiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4us = cast(type_of(procs.glColor4us)) GetProcAddress(cast(*u8) "glColor4us\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColor4usv = cast(type_of(procs.glColor4usv)) GetProcAddress(cast(*u8) "glColor4usv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEdgeFlag = cast(type_of(procs.glEdgeFlag)) GetProcAddress(cast(*u8) "glEdgeFlag\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEdgeFlagv = cast(type_of(procs.glEdgeFlagv)) GetProcAddress(cast(*u8) "glEdgeFlagv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEnd = cast(type_of(procs.glEnd)) GetProcAddress(cast(*u8) "glEnd\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexd = cast(type_of(procs.glIndexd)) GetProcAddress(cast(*u8) "glIndexd\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexdv = cast(type_of(procs.glIndexdv)) GetProcAddress(cast(*u8) "glIndexdv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexf = cast(type_of(procs.glIndexf)) GetProcAddress(cast(*u8) "glIndexf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexfv = cast(type_of(procs.glIndexfv)) GetProcAddress(cast(*u8) "glIndexfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexi = cast(type_of(procs.glIndexi)) GetProcAddress(cast(*u8) "glIndexi\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexiv = cast(type_of(procs.glIndexiv)) GetProcAddress(cast(*u8) "glIndexiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexs = cast(type_of(procs.glIndexs)) GetProcAddress(cast(*u8) "glIndexs\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexsv = cast(type_of(procs.glIndexsv)) GetProcAddress(cast(*u8) "glIndexsv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3b = cast(type_of(procs.glNormal3b)) GetProcAddress(cast(*u8) "glNormal3b\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3bv = cast(type_of(procs.glNormal3bv)) GetProcAddress(cast(*u8) "glNormal3bv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3d = cast(type_of(procs.glNormal3d)) GetProcAddress(cast(*u8) "glNormal3d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3dv = cast(type_of(procs.glNormal3dv)) GetProcAddress(cast(*u8) "glNormal3dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3f = cast(type_of(procs.glNormal3f)) GetProcAddress(cast(*u8) "glNormal3f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3fv = cast(type_of(procs.glNormal3fv)) GetProcAddress(cast(*u8) "glNormal3fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3i = cast(type_of(procs.glNormal3i)) GetProcAddress(cast(*u8) "glNormal3i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3iv = cast(type_of(procs.glNormal3iv)) GetProcAddress(cast(*u8) "glNormal3iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3s = cast(type_of(procs.glNormal3s)) GetProcAddress(cast(*u8) "glNormal3s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glNormal3sv = cast(type_of(procs.glNormal3sv)) GetProcAddress(cast(*u8) "glNormal3sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2d = cast(type_of(procs.glRasterPos2d)) GetProcAddress(cast(*u8) "glRasterPos2d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2dv = cast(type_of(procs.glRasterPos2dv)) GetProcAddress(cast(*u8) "glRasterPos2dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2f = cast(type_of(procs.glRasterPos2f)) GetProcAddress(cast(*u8) "glRasterPos2f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2fv = cast(type_of(procs.glRasterPos2fv)) GetProcAddress(cast(*u8) "glRasterPos2fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2i = cast(type_of(procs.glRasterPos2i)) GetProcAddress(cast(*u8) "glRasterPos2i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2iv = cast(type_of(procs.glRasterPos2iv)) GetProcAddress(cast(*u8) "glRasterPos2iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2s = cast(type_of(procs.glRasterPos2s)) GetProcAddress(cast(*u8) "glRasterPos2s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos2sv = cast(type_of(procs.glRasterPos2sv)) GetProcAddress(cast(*u8) "glRasterPos2sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3d = cast(type_of(procs.glRasterPos3d)) GetProcAddress(cast(*u8) "glRasterPos3d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3dv = cast(type_of(procs.glRasterPos3dv)) GetProcAddress(cast(*u8) "glRasterPos3dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3f = cast(type_of(procs.glRasterPos3f)) GetProcAddress(cast(*u8) "glRasterPos3f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3fv = cast(type_of(procs.glRasterPos3fv)) GetProcAddress(cast(*u8) "glRasterPos3fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3i = cast(type_of(procs.glRasterPos3i)) GetProcAddress(cast(*u8) "glRasterPos3i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3iv = cast(type_of(procs.glRasterPos3iv)) GetProcAddress(cast(*u8) "glRasterPos3iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3s = cast(type_of(procs.glRasterPos3s)) GetProcAddress(cast(*u8) "glRasterPos3s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos3sv = cast(type_of(procs.glRasterPos3sv)) GetProcAddress(cast(*u8) "glRasterPos3sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4d = cast(type_of(procs.glRasterPos4d)) GetProcAddress(cast(*u8) "glRasterPos4d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4dv = cast(type_of(procs.glRasterPos4dv)) GetProcAddress(cast(*u8) "glRasterPos4dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4f = cast(type_of(procs.glRasterPos4f)) GetProcAddress(cast(*u8) "glRasterPos4f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4fv = cast(type_of(procs.glRasterPos4fv)) GetProcAddress(cast(*u8) "glRasterPos4fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4i = cast(type_of(procs.glRasterPos4i)) GetProcAddress(cast(*u8) "glRasterPos4i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4iv = cast(type_of(procs.glRasterPos4iv)) GetProcAddress(cast(*u8) "glRasterPos4iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4s = cast(type_of(procs.glRasterPos4s)) GetProcAddress(cast(*u8) "glRasterPos4s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRasterPos4sv = cast(type_of(procs.glRasterPos4sv)) GetProcAddress(cast(*u8) "glRasterPos4sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRectd = cast(type_of(procs.glRectd)) GetProcAddress(cast(*u8) "glRectd\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRectdv = cast(type_of(procs.glRectdv)) GetProcAddress(cast(*u8) "glRectdv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRectf = cast(type_of(procs.glRectf)) GetProcAddress(cast(*u8) "glRectf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRectfv = cast(type_of(procs.glRectfv)) GetProcAddress(cast(*u8) "glRectfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRecti = cast(type_of(procs.glRecti)) GetProcAddress(cast(*u8) "glRecti\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRectiv = cast(type_of(procs.glRectiv)) GetProcAddress(cast(*u8) "glRectiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRects = cast(type_of(procs.glRects)) GetProcAddress(cast(*u8) "glRects\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRectsv = cast(type_of(procs.glRectsv)) GetProcAddress(cast(*u8) "glRectsv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1d = cast(type_of(procs.glTexCoord1d)) GetProcAddress(cast(*u8) "glTexCoord1d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1dv = cast(type_of(procs.glTexCoord1dv)) GetProcAddress(cast(*u8) "glTexCoord1dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1f = cast(type_of(procs.glTexCoord1f)) GetProcAddress(cast(*u8) "glTexCoord1f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1fv = cast(type_of(procs.glTexCoord1fv)) GetProcAddress(cast(*u8) "glTexCoord1fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1i = cast(type_of(procs.glTexCoord1i)) GetProcAddress(cast(*u8) "glTexCoord1i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1iv = cast(type_of(procs.glTexCoord1iv)) GetProcAddress(cast(*u8) "glTexCoord1iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1s = cast(type_of(procs.glTexCoord1s)) GetProcAddress(cast(*u8) "glTexCoord1s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord1sv = cast(type_of(procs.glTexCoord1sv)) GetProcAddress(cast(*u8) "glTexCoord1sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2d = cast(type_of(procs.glTexCoord2d)) GetProcAddress(cast(*u8) "glTexCoord2d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2dv = cast(type_of(procs.glTexCoord2dv)) GetProcAddress(cast(*u8) "glTexCoord2dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2f = cast(type_of(procs.glTexCoord2f)) GetProcAddress(cast(*u8) "glTexCoord2f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2fv = cast(type_of(procs.glTexCoord2fv)) GetProcAddress(cast(*u8) "glTexCoord2fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2i = cast(type_of(procs.glTexCoord2i)) GetProcAddress(cast(*u8) "glTexCoord2i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2iv = cast(type_of(procs.glTexCoord2iv)) GetProcAddress(cast(*u8) "glTexCoord2iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2s = cast(type_of(procs.glTexCoord2s)) GetProcAddress(cast(*u8) "glTexCoord2s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord2sv = cast(type_of(procs.glTexCoord2sv)) GetProcAddress(cast(*u8) "glTexCoord2sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3d = cast(type_of(procs.glTexCoord3d)) GetProcAddress(cast(*u8) "glTexCoord3d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3dv = cast(type_of(procs.glTexCoord3dv)) GetProcAddress(cast(*u8) "glTexCoord3dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3f = cast(type_of(procs.glTexCoord3f)) GetProcAddress(cast(*u8) "glTexCoord3f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3fv = cast(type_of(procs.glTexCoord3fv)) GetProcAddress(cast(*u8) "glTexCoord3fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3i = cast(type_of(procs.glTexCoord3i)) GetProcAddress(cast(*u8) "glTexCoord3i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3iv = cast(type_of(procs.glTexCoord3iv)) GetProcAddress(cast(*u8) "glTexCoord3iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3s = cast(type_of(procs.glTexCoord3s)) GetProcAddress(cast(*u8) "glTexCoord3s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord3sv = cast(type_of(procs.glTexCoord3sv)) GetProcAddress(cast(*u8) "glTexCoord3sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4d = cast(type_of(procs.glTexCoord4d)) GetProcAddress(cast(*u8) "glTexCoord4d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4dv = cast(type_of(procs.glTexCoord4dv)) GetProcAddress(cast(*u8) "glTexCoord4dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4f = cast(type_of(procs.glTexCoord4f)) GetProcAddress(cast(*u8) "glTexCoord4f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4fv = cast(type_of(procs.glTexCoord4fv)) GetProcAddress(cast(*u8) "glTexCoord4fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4i = cast(type_of(procs.glTexCoord4i)) GetProcAddress(cast(*u8) "glTexCoord4i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4iv = cast(type_of(procs.glTexCoord4iv)) GetProcAddress(cast(*u8) "glTexCoord4iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4s = cast(type_of(procs.glTexCoord4s)) GetProcAddress(cast(*u8) "glTexCoord4s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexCoord4sv = cast(type_of(procs.glTexCoord4sv)) GetProcAddress(cast(*u8) "glTexCoord4sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2d = cast(type_of(procs.glVertex2d)) GetProcAddress(cast(*u8) "glVertex2d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2dv = cast(type_of(procs.glVertex2dv)) GetProcAddress(cast(*u8) "glVertex2dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2f = cast(type_of(procs.glVertex2f)) GetProcAddress(cast(*u8) "glVertex2f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2fv = cast(type_of(procs.glVertex2fv)) GetProcAddress(cast(*u8) "glVertex2fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2i = cast(type_of(procs.glVertex2i)) GetProcAddress(cast(*u8) "glVertex2i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2iv = cast(type_of(procs.glVertex2iv)) GetProcAddress(cast(*u8) "glVertex2iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2s = cast(type_of(procs.glVertex2s)) GetProcAddress(cast(*u8) "glVertex2s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex2sv = cast(type_of(procs.glVertex2sv)) GetProcAddress(cast(*u8) "glVertex2sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3d = cast(type_of(procs.glVertex3d)) GetProcAddress(cast(*u8) "glVertex3d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3dv = cast(type_of(procs.glVertex3dv)) GetProcAddress(cast(*u8) "glVertex3dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3f = cast(type_of(procs.glVertex3f)) GetProcAddress(cast(*u8) "glVertex3f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3fv = cast(type_of(procs.glVertex3fv)) GetProcAddress(cast(*u8) "glVertex3fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3i = cast(type_of(procs.glVertex3i)) GetProcAddress(cast(*u8) "glVertex3i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3iv = cast(type_of(procs.glVertex3iv)) GetProcAddress(cast(*u8) "glVertex3iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3s = cast(type_of(procs.glVertex3s)) GetProcAddress(cast(*u8) "glVertex3s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex3sv = cast(type_of(procs.glVertex3sv)) GetProcAddress(cast(*u8) "glVertex3sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4d = cast(type_of(procs.glVertex4d)) GetProcAddress(cast(*u8) "glVertex4d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4dv = cast(type_of(procs.glVertex4dv)) GetProcAddress(cast(*u8) "glVertex4dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4f = cast(type_of(procs.glVertex4f)) GetProcAddress(cast(*u8) "glVertex4f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4fv = cast(type_of(procs.glVertex4fv)) GetProcAddress(cast(*u8) "glVertex4fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4i = cast(type_of(procs.glVertex4i)) GetProcAddress(cast(*u8) "glVertex4i\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4iv = cast(type_of(procs.glVertex4iv)) GetProcAddress(cast(*u8) "glVertex4iv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4s = cast(type_of(procs.glVertex4s)) GetProcAddress(cast(*u8) "glVertex4s\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glVertex4sv = cast(type_of(procs.glVertex4sv)) GetProcAddress(cast(*u8) "glVertex4sv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glClipPlane = cast(type_of(procs.glClipPlane)) GetProcAddress(cast(*u8) "glClipPlane\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glColorMaterial = cast(type_of(procs.glColorMaterial)) GetProcAddress(cast(*u8) "glColorMaterial\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glFogf = cast(type_of(procs.glFogf)) GetProcAddress(cast(*u8) "glFogf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glFogfv = cast(type_of(procs.glFogfv)) GetProcAddress(cast(*u8) "glFogfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glFogi = cast(type_of(procs.glFogi)) GetProcAddress(cast(*u8) "glFogi\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glFogiv = cast(type_of(procs.glFogiv)) GetProcAddress(cast(*u8) "glFogiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightf = cast(type_of(procs.glLightf)) GetProcAddress(cast(*u8) "glLightf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightfv = cast(type_of(procs.glLightfv)) GetProcAddress(cast(*u8) "glLightfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLighti = cast(type_of(procs.glLighti)) GetProcAddress(cast(*u8) "glLighti\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightiv = cast(type_of(procs.glLightiv)) GetProcAddress(cast(*u8) "glLightiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightModelf = cast(type_of(procs.glLightModelf)) GetProcAddress(cast(*u8) "glLightModelf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightModelfv = cast(type_of(procs.glLightModelfv)) GetProcAddress(cast(*u8) "glLightModelfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightModeli = cast(type_of(procs.glLightModeli)) GetProcAddress(cast(*u8) "glLightModeli\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLightModeliv = cast(type_of(procs.glLightModeliv)) GetProcAddress(cast(*u8) "glLightModeliv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLineStipple = cast(type_of(procs.glLineStipple)) GetProcAddress(cast(*u8) "glLineStipple\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMaterialf = cast(type_of(procs.glMaterialf)) GetProcAddress(cast(*u8) "glMaterialf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMaterialfv = cast(type_of(procs.glMaterialfv)) GetProcAddress(cast(*u8) "glMaterialfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMateriali = cast(type_of(procs.glMateriali)) GetProcAddress(cast(*u8) "glMateriali\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMaterialiv = cast(type_of(procs.glMaterialiv)) GetProcAddress(cast(*u8) "glMaterialiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPolygonStipple = cast(type_of(procs.glPolygonStipple)) GetProcAddress(cast(*u8) "glPolygonStipple\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glShadeModel = cast(type_of(procs.glShadeModel)) GetProcAddress(cast(*u8) "glShadeModel\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexEnvf = cast(type_of(procs.glTexEnvf)) GetProcAddress(cast(*u8) "glTexEnvf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexEnvfv = cast(type_of(procs.glTexEnvfv)) GetProcAddress(cast(*u8) "glTexEnvfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexEnvi = cast(type_of(procs.glTexEnvi)) GetProcAddress(cast(*u8) "glTexEnvi\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexEnviv = cast(type_of(procs.glTexEnviv)) GetProcAddress(cast(*u8) "glTexEnviv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexGend = cast(type_of(procs.glTexGend)) GetProcAddress(cast(*u8) "glTexGend\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexGendv = cast(type_of(procs.glTexGendv)) GetProcAddress(cast(*u8) "glTexGendv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexGenf = cast(type_of(procs.glTexGenf)) GetProcAddress(cast(*u8) "glTexGenf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexGenfv = cast(type_of(procs.glTexGenfv)) GetProcAddress(cast(*u8) "glTexGenfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexGeni = cast(type_of(procs.glTexGeni)) GetProcAddress(cast(*u8) "glTexGeni\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTexGeniv = cast(type_of(procs.glTexGeniv)) GetProcAddress(cast(*u8) "glTexGeniv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glFeedbackBuffer = cast(type_of(procs.glFeedbackBuffer)) GetProcAddress(cast(*u8) "glFeedbackBuffer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glSelectBuffer = cast(type_of(procs.glSelectBuffer)) GetProcAddress(cast(*u8) "glSelectBuffer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRenderMode = cast(type_of(procs.glRenderMode)) GetProcAddress(cast(*u8) "glRenderMode\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glInitNames = cast(type_of(procs.glInitNames)) GetProcAddress(cast(*u8) "glInitNames\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLoadName = cast(type_of(procs.glLoadName)) GetProcAddress(cast(*u8) "glLoadName\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPassThrough = cast(type_of(procs.glPassThrough)) GetProcAddress(cast(*u8) "glPassThrough\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPopName = cast(type_of(procs.glPopName)) GetProcAddress(cast(*u8) "glPopName\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPushName = cast(type_of(procs.glPushName)) GetProcAddress(cast(*u8) "glPushName\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glClearAccum = cast(type_of(procs.glClearAccum)) GetProcAddress(cast(*u8) "glClearAccum\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glClearIndex = cast(type_of(procs.glClearIndex)) GetProcAddress(cast(*u8) "glClearIndex\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIndexMask = cast(type_of(procs.glIndexMask)) GetProcAddress(cast(*u8) "glIndexMask\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glAccum = cast(type_of(procs.glAccum)) GetProcAddress(cast(*u8) "glAccum\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPopAttrib = cast(type_of(procs.glPopAttrib)) GetProcAddress(cast(*u8) "glPopAttrib\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPushAttrib = cast(type_of(procs.glPushAttrib)) GetProcAddress(cast(*u8) "glPushAttrib\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMap1d = cast(type_of(procs.glMap1d)) GetProcAddress(cast(*u8) "glMap1d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMap1f = cast(type_of(procs.glMap1f)) GetProcAddress(cast(*u8) "glMap1f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMap2d = cast(type_of(procs.glMap2d)) GetProcAddress(cast(*u8) "glMap2d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMap2f = cast(type_of(procs.glMap2f)) GetProcAddress(cast(*u8) "glMap2f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMapGrid1d = cast(type_of(procs.glMapGrid1d)) GetProcAddress(cast(*u8) "glMapGrid1d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMapGrid1f = cast(type_of(procs.glMapGrid1f)) GetProcAddress(cast(*u8) "glMapGrid1f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMapGrid2d = cast(type_of(procs.glMapGrid2d)) GetProcAddress(cast(*u8) "glMapGrid2d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMapGrid2f = cast(type_of(procs.glMapGrid2f)) GetProcAddress(cast(*u8) "glMapGrid2f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord1d = cast(type_of(procs.glEvalCoord1d)) GetProcAddress(cast(*u8) "glEvalCoord1d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord1dv = cast(type_of(procs.glEvalCoord1dv)) GetProcAddress(cast(*u8) "glEvalCoord1dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord1f = cast(type_of(procs.glEvalCoord1f)) GetProcAddress(cast(*u8) "glEvalCoord1f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord1fv = cast(type_of(procs.glEvalCoord1fv)) GetProcAddress(cast(*u8) "glEvalCoord1fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord2d = cast(type_of(procs.glEvalCoord2d)) GetProcAddress(cast(*u8) "glEvalCoord2d\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord2dv = cast(type_of(procs.glEvalCoord2dv)) GetProcAddress(cast(*u8) "glEvalCoord2dv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord2f = cast(type_of(procs.glEvalCoord2f)) GetProcAddress(cast(*u8) "glEvalCoord2f\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalCoord2fv = cast(type_of(procs.glEvalCoord2fv)) GetProcAddress(cast(*u8) "glEvalCoord2fv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalMesh1 = cast(type_of(procs.glEvalMesh1)) GetProcAddress(cast(*u8) "glEvalMesh1\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalPoint1 = cast(type_of(procs.glEvalPoint1)) GetProcAddress(cast(*u8) "glEvalPoint1\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalMesh2 = cast(type_of(procs.glEvalMesh2)) GetProcAddress(cast(*u8) "glEvalMesh2\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glEvalPoint2 = cast(type_of(procs.glEvalPoint2)) GetProcAddress(cast(*u8) "glEvalPoint2\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glAlphaFunc = cast(type_of(procs.glAlphaFunc)) GetProcAddress(cast(*u8) "glAlphaFunc\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPixelZoom = cast(type_of(procs.glPixelZoom)) GetProcAddress(cast(*u8) "glPixelZoom\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPixelTransferf = cast(type_of(procs.glPixelTransferf)) GetProcAddress(cast(*u8) "glPixelTransferf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPixelTransferi = cast(type_of(procs.glPixelTransferi)) GetProcAddress(cast(*u8) "glPixelTransferi\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPixelMapfv = cast(type_of(procs.glPixelMapfv)) GetProcAddress(cast(*u8) "glPixelMapfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPixelMapuiv = cast(type_of(procs.glPixelMapuiv)) GetProcAddress(cast(*u8) "glPixelMapuiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPixelMapusv = cast(type_of(procs.glPixelMapusv)) GetProcAddress(cast(*u8) "glPixelMapusv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glCopyPixels = cast(type_of(procs.glCopyPixels)) GetProcAddress(cast(*u8) "glCopyPixels\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glDrawPixels = cast(type_of(procs.glDrawPixels)) GetProcAddress(cast(*u8) "glDrawPixels\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetClipPlane = cast(type_of(procs.glGetClipPlane)) GetProcAddress(cast(*u8) "glGetClipPlane\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetLightfv = cast(type_of(procs.glGetLightfv)) GetProcAddress(cast(*u8) "glGetLightfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetLightiv = cast(type_of(procs.glGetLightiv)) GetProcAddress(cast(*u8) "glGetLightiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetMapdv = cast(type_of(procs.glGetMapdv)) GetProcAddress(cast(*u8) "glGetMapdv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetMapfv = cast(type_of(procs.glGetMapfv)) GetProcAddress(cast(*u8) "glGetMapfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetMapiv = cast(type_of(procs.glGetMapiv)) GetProcAddress(cast(*u8) "glGetMapiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetMaterialfv = cast(type_of(procs.glGetMaterialfv)) GetProcAddress(cast(*u8) "glGetMaterialfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetMaterialiv = cast(type_of(procs.glGetMaterialiv)) GetProcAddress(cast(*u8) "glGetMaterialiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetPixelMapfv = cast(type_of(procs.glGetPixelMapfv)) GetProcAddress(cast(*u8) "glGetPixelMapfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetPixelMapuiv = cast(type_of(procs.glGetPixelMapuiv)) GetProcAddress(cast(*u8) "glGetPixelMapuiv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetPixelMapusv = cast(type_of(procs.glGetPixelMapusv)) GetProcAddress(cast(*u8) "glGetPixelMapusv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetPolygonStipple = cast(type_of(procs.glGetPolygonStipple)) GetProcAddress(cast(*u8) "glGetPolygonStipple\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetTexEnvfv = cast(type_of(procs.glGetTexEnvfv)) GetProcAddress(cast(*u8) "glGetTexEnvfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetTexEnviv = cast(type_of(procs.glGetTexEnviv)) GetProcAddress(cast(*u8) "glGetTexEnviv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetTexGendv = cast(type_of(procs.glGetTexGendv)) GetProcAddress(cast(*u8) "glGetTexGendv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetTexGenfv = cast(type_of(procs.glGetTexGenfv)) GetProcAddress(cast(*u8) "glGetTexGenfv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glGetTexGeniv = cast(type_of(procs.glGetTexGeniv)) GetProcAddress(cast(*u8) "glGetTexGeniv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glIsList = cast(type_of(procs.glIsList)) GetProcAddress(cast(*u8) "glIsList\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glFrustum = cast(type_of(procs.glFrustum)) GetProcAddress(cast(*u8) "glFrustum\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLoadIdentity = cast(type_of(procs.glLoadIdentity)) GetProcAddress(cast(*u8) "glLoadIdentity\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLoadMatrixf = cast(type_of(procs.glLoadMatrixf)) GetProcAddress(cast(*u8) "glLoadMatrixf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glLoadMatrixd = cast(type_of(procs.glLoadMatrixd)) GetProcAddress(cast(*u8) "glLoadMatrixd\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMatrixMode = cast(type_of(procs.glMatrixMode)) GetProcAddress(cast(*u8) "glMatrixMode\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMultMatrixf = cast(type_of(procs.glMultMatrixf)) GetProcAddress(cast(*u8) "glMultMatrixf\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glMultMatrixd = cast(type_of(procs.glMultMatrixd)) GetProcAddress(cast(*u8) "glMultMatrixd\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glOrtho = cast(type_of(procs.glOrtho)) GetProcAddress(cast(*u8) "glOrtho\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPopMatrix = cast(type_of(procs.glPopMatrix)) GetProcAddress(cast(*u8) "glPopMatrix\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glPushMatrix = cast(type_of(procs.glPushMatrix)) GetProcAddress(cast(*u8) "glPushMatrix\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRotated = cast(type_of(procs.glRotated)) GetProcAddress(cast(*u8) "glRotated\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glRotatef = cast(type_of(procs.glRotatef)) GetProcAddress(cast(*u8) "glRotatef\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glScaled = cast(type_of(procs.glScaled)) GetProcAddress(cast(*u8) "glScaled\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glScalef = cast(type_of(procs.glScalef)) GetProcAddress(cast(*u8) "glScalef\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTranslated = cast(type_of(procs.glTranslated)) GetProcAddress(cast(*u8) "glTranslated\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS || OS == .LINUX) {
        procs.glTranslatef = cast(type_of(procs.glTranslatef)) GetProcAddress(cast(*u8) "glTranslatef\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glDrawArrays = cast(type_of(procs.glDrawArrays)) GetProcAddress(cast(*u8) "glDrawArrays\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glDrawElements = cast(type_of(procs.glDrawElements)) GetProcAddress(cast(*u8) "glDrawElements\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glGetPointerv = cast(type_of(procs.glGetPointerv)) GetProcAddress(cast(*u8) "glGetPointerv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glPolygonOffset = cast(type_of(procs.glPolygonOffset)) GetProcAddress(cast(*u8) "glPolygonOffset\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glCopyTexImage1D = cast(type_of(procs.glCopyTexImage1D)) GetProcAddress(cast(*u8) "glCopyTexImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glCopyTexImage2D = cast(type_of(procs.glCopyTexImage2D)) GetProcAddress(cast(*u8) "glCopyTexImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glCopyTexSubImage1D = cast(type_of(procs.glCopyTexSubImage1D)) GetProcAddress(cast(*u8) "glCopyTexSubImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glCopyTexSubImage2D = cast(type_of(procs.glCopyTexSubImage2D)) GetProcAddress(cast(*u8) "glCopyTexSubImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glTexSubImage1D = cast(type_of(procs.glTexSubImage1D)) GetProcAddress(cast(*u8) "glTexSubImage1D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glTexSubImage2D = cast(type_of(procs.glTexSubImage2D)) GetProcAddress(cast(*u8) "glTexSubImage2D\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glBindTexture = cast(type_of(procs.glBindTexture)) GetProcAddress(cast(*u8) "glBindTexture\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glDeleteTextures = cast(type_of(procs.glDeleteTextures)) GetProcAddress(cast(*u8) "glDeleteTextures\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glGenTextures = cast(type_of(procs.glGenTextures)) GetProcAddress(cast(*u8) "glGenTextures\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glIsTexture = cast(type_of(procs.glIsTexture)) GetProcAddress(cast(*u8) "glIsTexture\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glArrayElement = cast(type_of(procs.glArrayElement)) GetProcAddress(cast(*u8) "glArrayElement\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glColorPointer = cast(type_of(procs.glColorPointer)) GetProcAddress(cast(*u8) "glColorPointer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glDisableClientState = cast(type_of(procs.glDisableClientState)) GetProcAddress(cast(*u8) "glDisableClientState\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glEdgeFlagPointer = cast(type_of(procs.glEdgeFlagPointer)) GetProcAddress(cast(*u8) "glEdgeFlagPointer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glEnableClientState = cast(type_of(procs.glEnableClientState)) GetProcAddress(cast(*u8) "glEnableClientState\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glIndexPointer = cast(type_of(procs.glIndexPointer)) GetProcAddress(cast(*u8) "glIndexPointer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glInterleavedArrays = cast(type_of(procs.glInterleavedArrays)) GetProcAddress(cast(*u8) "glInterleavedArrays\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glNormalPointer = cast(type_of(procs.glNormalPointer)) GetProcAddress(cast(*u8) "glNormalPointer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glTexCoordPointer = cast(type_of(procs.glTexCoordPointer)) GetProcAddress(cast(*u8) "glTexCoordPointer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glVertexPointer = cast(type_of(procs.glVertexPointer)) GetProcAddress(cast(*u8) "glVertexPointer\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glAreTexturesResident = cast(type_of(procs.glAreTexturesResident)) GetProcAddress(cast(*u8) "glAreTexturesResident\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glPrioritizeTextures = cast(type_of(procs.glPrioritizeTextures)) GetProcAddress(cast(*u8) "glPrioritizeTextures\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glIndexub = cast(type_of(procs.glIndexub)) GetProcAddress(cast(*u8) "glIndexub\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glIndexubv = cast(type_of(procs.glIndexubv)) GetProcAddress(cast(*u8) "glIndexubv\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glPopClientAttrib = cast(type_of(procs.glPopClientAttrib)) GetProcAddress(cast(*u8) "glPopClientAttrib\0");
    }
    #if !(OS == .WINDOWS || OS == .MACOS) {
        procs.glPushClientAttrib = cast(type_of(procs.glPushClientAttrib)) GetProcAddress(cast(*u8) "glPushClientAttrib\0");
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
    procs.glClientActiveTexture = cast(type_of(procs.glClientActiveTexture)) GetProcAddress(cast(*u8) "glClientActiveTexture\0");
    procs.glMultiTexCoord1d = cast(type_of(procs.glMultiTexCoord1d)) GetProcAddress(cast(*u8) "glMultiTexCoord1d\0");
    procs.glMultiTexCoord1dv = cast(type_of(procs.glMultiTexCoord1dv)) GetProcAddress(cast(*u8) "glMultiTexCoord1dv\0");
    procs.glMultiTexCoord1f = cast(type_of(procs.glMultiTexCoord1f)) GetProcAddress(cast(*u8) "glMultiTexCoord1f\0");
    procs.glMultiTexCoord1fv = cast(type_of(procs.glMultiTexCoord1fv)) GetProcAddress(cast(*u8) "glMultiTexCoord1fv\0");
    procs.glMultiTexCoord1i = cast(type_of(procs.glMultiTexCoord1i)) GetProcAddress(cast(*u8) "glMultiTexCoord1i\0");
    procs.glMultiTexCoord1iv = cast(type_of(procs.glMultiTexCoord1iv)) GetProcAddress(cast(*u8) "glMultiTexCoord1iv\0");
    procs.glMultiTexCoord1s = cast(type_of(procs.glMultiTexCoord1s)) GetProcAddress(cast(*u8) "glMultiTexCoord1s\0");
    procs.glMultiTexCoord1sv = cast(type_of(procs.glMultiTexCoord1sv)) GetProcAddress(cast(*u8) "glMultiTexCoord1sv\0");
    procs.glMultiTexCoord2d = cast(type_of(procs.glMultiTexCoord2d)) GetProcAddress(cast(*u8) "glMultiTexCoord2d\0");
    procs.glMultiTexCoord2dv = cast(type_of(procs.glMultiTexCoord2dv)) GetProcAddress(cast(*u8) "glMultiTexCoord2dv\0");
    procs.glMultiTexCoord2f = cast(type_of(procs.glMultiTexCoord2f)) GetProcAddress(cast(*u8) "glMultiTexCoord2f\0");
    procs.glMultiTexCoord2fv = cast(type_of(procs.glMultiTexCoord2fv)) GetProcAddress(cast(*u8) "glMultiTexCoord2fv\0");
    procs.glMultiTexCoord2i = cast(type_of(procs.glMultiTexCoord2i)) GetProcAddress(cast(*u8) "glMultiTexCoord2i\0");
    procs.glMultiTexCoord2iv = cast(type_of(procs.glMultiTexCoord2iv)) GetProcAddress(cast(*u8) "glMultiTexCoord2iv\0");
    procs.glMultiTexCoord2s = cast(type_of(procs.glMultiTexCoord2s)) GetProcAddress(cast(*u8) "glMultiTexCoord2s\0");
    procs.glMultiTexCoord2sv = cast(type_of(procs.glMultiTexCoord2sv)) GetProcAddress(cast(*u8) "glMultiTexCoord2sv\0");
    procs.glMultiTexCoord3d = cast(type_of(procs.glMultiTexCoord3d)) GetProcAddress(cast(*u8) "glMultiTexCoord3d\0");
    procs.glMultiTexCoord3dv = cast(type_of(procs.glMultiTexCoord3dv)) GetProcAddress(cast(*u8) "glMultiTexCoord3dv\0");
    procs.glMultiTexCoord3f = cast(type_of(procs.glMultiTexCoord3f)) GetProcAddress(cast(*u8) "glMultiTexCoord3f\0");
    procs.glMultiTexCoord3fv = cast(type_of(procs.glMultiTexCoord3fv)) GetProcAddress(cast(*u8) "glMultiTexCoord3fv\0");
    procs.glMultiTexCoord3i = cast(type_of(procs.glMultiTexCoord3i)) GetProcAddress(cast(*u8) "glMultiTexCoord3i\0");
    procs.glMultiTexCoord3iv = cast(type_of(procs.glMultiTexCoord3iv)) GetProcAddress(cast(*u8) "glMultiTexCoord3iv\0");
    procs.glMultiTexCoord3s = cast(type_of(procs.glMultiTexCoord3s)) GetProcAddress(cast(*u8) "glMultiTexCoord3s\0");
    procs.glMultiTexCoord3sv = cast(type_of(procs.glMultiTexCoord3sv)) GetProcAddress(cast(*u8) "glMultiTexCoord3sv\0");
    procs.glMultiTexCoord4d = cast(type_of(procs.glMultiTexCoord4d)) GetProcAddress(cast(*u8) "glMultiTexCoord4d\0");
    procs.glMultiTexCoord4dv = cast(type_of(procs.glMultiTexCoord4dv)) GetProcAddress(cast(*u8) "glMultiTexCoord4dv\0");
    procs.glMultiTexCoord4f = cast(type_of(procs.glMultiTexCoord4f)) GetProcAddress(cast(*u8) "glMultiTexCoord4f\0");
    procs.glMultiTexCoord4fv = cast(type_of(procs.glMultiTexCoord4fv)) GetProcAddress(cast(*u8) "glMultiTexCoord4fv\0");
    procs.glMultiTexCoord4i = cast(type_of(procs.glMultiTexCoord4i)) GetProcAddress(cast(*u8) "glMultiTexCoord4i\0");
    procs.glMultiTexCoord4iv = cast(type_of(procs.glMultiTexCoord4iv)) GetProcAddress(cast(*u8) "glMultiTexCoord4iv\0");
    procs.glMultiTexCoord4s = cast(type_of(procs.glMultiTexCoord4s)) GetProcAddress(cast(*u8) "glMultiTexCoord4s\0");
    procs.glMultiTexCoord4sv = cast(type_of(procs.glMultiTexCoord4sv)) GetProcAddress(cast(*u8) "glMultiTexCoord4sv\0");
    procs.glLoadTransposeMatrixf = cast(type_of(procs.glLoadTransposeMatrixf)) GetProcAddress(cast(*u8) "glLoadTransposeMatrixf\0");
    procs.glLoadTransposeMatrixd = cast(type_of(procs.glLoadTransposeMatrixd)) GetProcAddress(cast(*u8) "glLoadTransposeMatrixd\0");
    procs.glMultTransposeMatrixf = cast(type_of(procs.glMultTransposeMatrixf)) GetProcAddress(cast(*u8) "glMultTransposeMatrixf\0");
    procs.glMultTransposeMatrixd = cast(type_of(procs.glMultTransposeMatrixd)) GetProcAddress(cast(*u8) "glMultTransposeMatrixd\0");
    procs.glBlendFuncSeparate = cast(type_of(procs.glBlendFuncSeparate)) GetProcAddress(cast(*u8) "glBlendFuncSeparate\0");
    procs.glMultiDrawArrays = cast(type_of(procs.glMultiDrawArrays)) GetProcAddress(cast(*u8) "glMultiDrawArrays\0");
    procs.glMultiDrawElements = cast(type_of(procs.glMultiDrawElements)) GetProcAddress(cast(*u8) "glMultiDrawElements\0");
    procs.glPointParameterf = cast(type_of(procs.glPointParameterf)) GetProcAddress(cast(*u8) "glPointParameterf\0");
    procs.glPointParameterfv = cast(type_of(procs.glPointParameterfv)) GetProcAddress(cast(*u8) "glPointParameterfv\0");
    procs.glPointParameteri = cast(type_of(procs.glPointParameteri)) GetProcAddress(cast(*u8) "glPointParameteri\0");
    procs.glPointParameteriv = cast(type_of(procs.glPointParameteriv)) GetProcAddress(cast(*u8) "glPointParameteriv\0");
    procs.glFogCoordf = cast(type_of(procs.glFogCoordf)) GetProcAddress(cast(*u8) "glFogCoordf\0");
    procs.glFogCoordfv = cast(type_of(procs.glFogCoordfv)) GetProcAddress(cast(*u8) "glFogCoordfv\0");
    procs.glFogCoordd = cast(type_of(procs.glFogCoordd)) GetProcAddress(cast(*u8) "glFogCoordd\0");
    procs.glFogCoorddv = cast(type_of(procs.glFogCoorddv)) GetProcAddress(cast(*u8) "glFogCoorddv\0");
    procs.glFogCoordPointer = cast(type_of(procs.glFogCoordPointer)) GetProcAddress(cast(*u8) "glFogCoordPointer\0");
    procs.glSecondaryColor3b = cast(type_of(procs.glSecondaryColor3b)) GetProcAddress(cast(*u8) "glSecondaryColor3b\0");
    procs.glSecondaryColor3bv = cast(type_of(procs.glSecondaryColor3bv)) GetProcAddress(cast(*u8) "glSecondaryColor3bv\0");
    procs.glSecondaryColor3d = cast(type_of(procs.glSecondaryColor3d)) GetProcAddress(cast(*u8) "glSecondaryColor3d\0");
    procs.glSecondaryColor3dv = cast(type_of(procs.glSecondaryColor3dv)) GetProcAddress(cast(*u8) "glSecondaryColor3dv\0");
    procs.glSecondaryColor3f = cast(type_of(procs.glSecondaryColor3f)) GetProcAddress(cast(*u8) "glSecondaryColor3f\0");
    procs.glSecondaryColor3fv = cast(type_of(procs.glSecondaryColor3fv)) GetProcAddress(cast(*u8) "glSecondaryColor3fv\0");
    procs.glSecondaryColor3i = cast(type_of(procs.glSecondaryColor3i)) GetProcAddress(cast(*u8) "glSecondaryColor3i\0");
    procs.glSecondaryColor3iv = cast(type_of(procs.glSecondaryColor3iv)) GetProcAddress(cast(*u8) "glSecondaryColor3iv\0");
    procs.glSecondaryColor3s = cast(type_of(procs.glSecondaryColor3s)) GetProcAddress(cast(*u8) "glSecondaryColor3s\0");
    procs.glSecondaryColor3sv = cast(type_of(procs.glSecondaryColor3sv)) GetProcAddress(cast(*u8) "glSecondaryColor3sv\0");
    procs.glSecondaryColor3ub = cast(type_of(procs.glSecondaryColor3ub)) GetProcAddress(cast(*u8) "glSecondaryColor3ub\0");
    procs.glSecondaryColor3ubv = cast(type_of(procs.glSecondaryColor3ubv)) GetProcAddress(cast(*u8) "glSecondaryColor3ubv\0");
    procs.glSecondaryColor3ui = cast(type_of(procs.glSecondaryColor3ui)) GetProcAddress(cast(*u8) "glSecondaryColor3ui\0");
    procs.glSecondaryColor3uiv = cast(type_of(procs.glSecondaryColor3uiv)) GetProcAddress(cast(*u8) "glSecondaryColor3uiv\0");
    procs.glSecondaryColor3us = cast(type_of(procs.glSecondaryColor3us)) GetProcAddress(cast(*u8) "glSecondaryColor3us\0");
    procs.glSecondaryColor3usv = cast(type_of(procs.glSecondaryColor3usv)) GetProcAddress(cast(*u8) "glSecondaryColor3usv\0");
    procs.glSecondaryColorPointer = cast(type_of(procs.glSecondaryColorPointer)) GetProcAddress(cast(*u8) "glSecondaryColorPointer\0");
    procs.glWindowPos2d = cast(type_of(procs.glWindowPos2d)) GetProcAddress(cast(*u8) "glWindowPos2d\0");
    procs.glWindowPos2dv = cast(type_of(procs.glWindowPos2dv)) GetProcAddress(cast(*u8) "glWindowPos2dv\0");
    procs.glWindowPos2f = cast(type_of(procs.glWindowPos2f)) GetProcAddress(cast(*u8) "glWindowPos2f\0");
    procs.glWindowPos2fv = cast(type_of(procs.glWindowPos2fv)) GetProcAddress(cast(*u8) "glWindowPos2fv\0");
    procs.glWindowPos2i = cast(type_of(procs.glWindowPos2i)) GetProcAddress(cast(*u8) "glWindowPos2i\0");
    procs.glWindowPos2iv = cast(type_of(procs.glWindowPos2iv)) GetProcAddress(cast(*u8) "glWindowPos2iv\0");
    procs.glWindowPos2s = cast(type_of(procs.glWindowPos2s)) GetProcAddress(cast(*u8) "glWindowPos2s\0");
    procs.glWindowPos2sv = cast(type_of(procs.glWindowPos2sv)) GetProcAddress(cast(*u8) "glWindowPos2sv\0");
    procs.glWindowPos3d = cast(type_of(procs.glWindowPos3d)) GetProcAddress(cast(*u8) "glWindowPos3d\0");
    procs.glWindowPos3dv = cast(type_of(procs.glWindowPos3dv)) GetProcAddress(cast(*u8) "glWindowPos3dv\0");
    procs.glWindowPos3f = cast(type_of(procs.glWindowPos3f)) GetProcAddress(cast(*u8) "glWindowPos3f\0");
    procs.glWindowPos3fv = cast(type_of(procs.glWindowPos3fv)) GetProcAddress(cast(*u8) "glWindowPos3fv\0");
    procs.glWindowPos3i = cast(type_of(procs.glWindowPos3i)) GetProcAddress(cast(*u8) "glWindowPos3i\0");
    procs.glWindowPos3iv = cast(type_of(procs.glWindowPos3iv)) GetProcAddress(cast(*u8) "glWindowPos3iv\0");
    procs.glWindowPos3s = cast(type_of(procs.glWindowPos3s)) GetProcAddress(cast(*u8) "glWindowPos3s\0");
    procs.glWindowPos3sv = cast(type_of(procs.glWindowPos3sv)) GetProcAddress(cast(*u8) "glWindowPos3sv\0");
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
    procs.glTbufferMask3DFX = cast(type_of(procs.glTbufferMask3DFX)) GetProcAddress(cast(*u8) "glTbufferMask3DFX\0");
    procs.glDebugMessageEnableAMD = cast(type_of(procs.glDebugMessageEnableAMD)) GetProcAddress(cast(*u8) "glDebugMessageEnableAMD\0");
    procs.glDebugMessageInsertAMD = cast(type_of(procs.glDebugMessageInsertAMD)) GetProcAddress(cast(*u8) "glDebugMessageInsertAMD\0");
    procs.glDebugMessageCallbackAMD = cast(type_of(procs.glDebugMessageCallbackAMD)) GetProcAddress(cast(*u8) "glDebugMessageCallbackAMD\0");
    procs.glGetDebugMessageLogAMD = cast(type_of(procs.glGetDebugMessageLogAMD)) GetProcAddress(cast(*u8) "glGetDebugMessageLogAMD\0");
    procs.glBlendFuncIndexedAMD = cast(type_of(procs.glBlendFuncIndexedAMD)) GetProcAddress(cast(*u8) "glBlendFuncIndexedAMD\0");
    procs.glBlendFuncSeparateIndexedAMD = cast(type_of(procs.glBlendFuncSeparateIndexedAMD)) GetProcAddress(cast(*u8) "glBlendFuncSeparateIndexedAMD\0");
    procs.glBlendEquationIndexedAMD = cast(type_of(procs.glBlendEquationIndexedAMD)) GetProcAddress(cast(*u8) "glBlendEquationIndexedAMD\0");
    procs.glBlendEquationSeparateIndexedAMD = cast(type_of(procs.glBlendEquationSeparateIndexedAMD)) GetProcAddress(cast(*u8) "glBlendEquationSeparateIndexedAMD\0");
    procs.glFramebufferSamplePositionsfvAMD = cast(type_of(procs.glFramebufferSamplePositionsfvAMD)) GetProcAddress(cast(*u8) "glFramebufferSamplePositionsfvAMD\0");
    procs.glNamedFramebufferSamplePositionsfvAMD = cast(type_of(procs.glNamedFramebufferSamplePositionsfvAMD)) GetProcAddress(cast(*u8) "glNamedFramebufferSamplePositionsfvAMD\0");
    procs.glGetFramebufferParameterfvAMD = cast(type_of(procs.glGetFramebufferParameterfvAMD)) GetProcAddress(cast(*u8) "glGetFramebufferParameterfvAMD\0");
    procs.glGetNamedFramebufferParameterfvAMD = cast(type_of(procs.glGetNamedFramebufferParameterfvAMD)) GetProcAddress(cast(*u8) "glGetNamedFramebufferParameterfvAMD\0");
    procs.glUniform1i64NV = cast(type_of(procs.glUniform1i64NV)) GetProcAddress(cast(*u8) "glUniform1i64NV\0");
    procs.glUniform2i64NV = cast(type_of(procs.glUniform2i64NV)) GetProcAddress(cast(*u8) "glUniform2i64NV\0");
    procs.glUniform3i64NV = cast(type_of(procs.glUniform3i64NV)) GetProcAddress(cast(*u8) "glUniform3i64NV\0");
    procs.glUniform4i64NV = cast(type_of(procs.glUniform4i64NV)) GetProcAddress(cast(*u8) "glUniform4i64NV\0");
    procs.glUniform1i64vNV = cast(type_of(procs.glUniform1i64vNV)) GetProcAddress(cast(*u8) "glUniform1i64vNV\0");
    procs.glUniform2i64vNV = cast(type_of(procs.glUniform2i64vNV)) GetProcAddress(cast(*u8) "glUniform2i64vNV\0");
    procs.glUniform3i64vNV = cast(type_of(procs.glUniform3i64vNV)) GetProcAddress(cast(*u8) "glUniform3i64vNV\0");
    procs.glUniform4i64vNV = cast(type_of(procs.glUniform4i64vNV)) GetProcAddress(cast(*u8) "glUniform4i64vNV\0");
    procs.glUniform1ui64NV = cast(type_of(procs.glUniform1ui64NV)) GetProcAddress(cast(*u8) "glUniform1ui64NV\0");
    procs.glUniform2ui64NV = cast(type_of(procs.glUniform2ui64NV)) GetProcAddress(cast(*u8) "glUniform2ui64NV\0");
    procs.glUniform3ui64NV = cast(type_of(procs.glUniform3ui64NV)) GetProcAddress(cast(*u8) "glUniform3ui64NV\0");
    procs.glUniform4ui64NV = cast(type_of(procs.glUniform4ui64NV)) GetProcAddress(cast(*u8) "glUniform4ui64NV\0");
    procs.glUniform1ui64vNV = cast(type_of(procs.glUniform1ui64vNV)) GetProcAddress(cast(*u8) "glUniform1ui64vNV\0");
    procs.glUniform2ui64vNV = cast(type_of(procs.glUniform2ui64vNV)) GetProcAddress(cast(*u8) "glUniform2ui64vNV\0");
    procs.glUniform3ui64vNV = cast(type_of(procs.glUniform3ui64vNV)) GetProcAddress(cast(*u8) "glUniform3ui64vNV\0");
    procs.glUniform4ui64vNV = cast(type_of(procs.glUniform4ui64vNV)) GetProcAddress(cast(*u8) "glUniform4ui64vNV\0");
    procs.glGetUniformi64vNV = cast(type_of(procs.glGetUniformi64vNV)) GetProcAddress(cast(*u8) "glGetUniformi64vNV\0");
    procs.glGetUniformui64vNV = cast(type_of(procs.glGetUniformui64vNV)) GetProcAddress(cast(*u8) "glGetUniformui64vNV\0");
    procs.glProgramUniform1i64NV = cast(type_of(procs.glProgramUniform1i64NV)) GetProcAddress(cast(*u8) "glProgramUniform1i64NV\0");
    procs.glProgramUniform2i64NV = cast(type_of(procs.glProgramUniform2i64NV)) GetProcAddress(cast(*u8) "glProgramUniform2i64NV\0");
    procs.glProgramUniform3i64NV = cast(type_of(procs.glProgramUniform3i64NV)) GetProcAddress(cast(*u8) "glProgramUniform3i64NV\0");
    procs.glProgramUniform4i64NV = cast(type_of(procs.glProgramUniform4i64NV)) GetProcAddress(cast(*u8) "glProgramUniform4i64NV\0");
    procs.glProgramUniform1i64vNV = cast(type_of(procs.glProgramUniform1i64vNV)) GetProcAddress(cast(*u8) "glProgramUniform1i64vNV\0");
    procs.glProgramUniform2i64vNV = cast(type_of(procs.glProgramUniform2i64vNV)) GetProcAddress(cast(*u8) "glProgramUniform2i64vNV\0");
    procs.glProgramUniform3i64vNV = cast(type_of(procs.glProgramUniform3i64vNV)) GetProcAddress(cast(*u8) "glProgramUniform3i64vNV\0");
    procs.glProgramUniform4i64vNV = cast(type_of(procs.glProgramUniform4i64vNV)) GetProcAddress(cast(*u8) "glProgramUniform4i64vNV\0");
    procs.glProgramUniform1ui64NV = cast(type_of(procs.glProgramUniform1ui64NV)) GetProcAddress(cast(*u8) "glProgramUniform1ui64NV\0");
    procs.glProgramUniform2ui64NV = cast(type_of(procs.glProgramUniform2ui64NV)) GetProcAddress(cast(*u8) "glProgramUniform2ui64NV\0");
    procs.glProgramUniform3ui64NV = cast(type_of(procs.glProgramUniform3ui64NV)) GetProcAddress(cast(*u8) "glProgramUniform3ui64NV\0");
    procs.glProgramUniform4ui64NV = cast(type_of(procs.glProgramUniform4ui64NV)) GetProcAddress(cast(*u8) "glProgramUniform4ui64NV\0");
    procs.glProgramUniform1ui64vNV = cast(type_of(procs.glProgramUniform1ui64vNV)) GetProcAddress(cast(*u8) "glProgramUniform1ui64vNV\0");
    procs.glProgramUniform2ui64vNV = cast(type_of(procs.glProgramUniform2ui64vNV)) GetProcAddress(cast(*u8) "glProgramUniform2ui64vNV\0");
    procs.glProgramUniform3ui64vNV = cast(type_of(procs.glProgramUniform3ui64vNV)) GetProcAddress(cast(*u8) "glProgramUniform3ui64vNV\0");
    procs.glProgramUniform4ui64vNV = cast(type_of(procs.glProgramUniform4ui64vNV)) GetProcAddress(cast(*u8) "glProgramUniform4ui64vNV\0");
    procs.glVertexAttribParameteriAMD = cast(type_of(procs.glVertexAttribParameteriAMD)) GetProcAddress(cast(*u8) "glVertexAttribParameteriAMD\0");
    procs.glMultiDrawArraysIndirectAMD = cast(type_of(procs.glMultiDrawArraysIndirectAMD)) GetProcAddress(cast(*u8) "glMultiDrawArraysIndirectAMD\0");
    procs.glMultiDrawElementsIndirectAMD = cast(type_of(procs.glMultiDrawElementsIndirectAMD)) GetProcAddress(cast(*u8) "glMultiDrawElementsIndirectAMD\0");
    procs.glGenNamesAMD = cast(type_of(procs.glGenNamesAMD)) GetProcAddress(cast(*u8) "glGenNamesAMD\0");
    procs.glDeleteNamesAMD = cast(type_of(procs.glDeleteNamesAMD)) GetProcAddress(cast(*u8) "glDeleteNamesAMD\0");
    procs.glIsNameAMD = cast(type_of(procs.glIsNameAMD)) GetProcAddress(cast(*u8) "glIsNameAMD\0");
    procs.glQueryObjectParameteruiAMD = cast(type_of(procs.glQueryObjectParameteruiAMD)) GetProcAddress(cast(*u8) "glQueryObjectParameteruiAMD\0");
    procs.glGetPerfMonitorGroupsAMD = cast(type_of(procs.glGetPerfMonitorGroupsAMD)) GetProcAddress(cast(*u8) "glGetPerfMonitorGroupsAMD\0");
    procs.glGetPerfMonitorCountersAMD = cast(type_of(procs.glGetPerfMonitorCountersAMD)) GetProcAddress(cast(*u8) "glGetPerfMonitorCountersAMD\0");
    procs.glGetPerfMonitorGroupStringAMD = cast(type_of(procs.glGetPerfMonitorGroupStringAMD)) GetProcAddress(cast(*u8) "glGetPerfMonitorGroupStringAMD\0");
    procs.glGetPerfMonitorCounterStringAMD = cast(type_of(procs.glGetPerfMonitorCounterStringAMD)) GetProcAddress(cast(*u8) "glGetPerfMonitorCounterStringAMD\0");
    procs.glGetPerfMonitorCounterInfoAMD = cast(type_of(procs.glGetPerfMonitorCounterInfoAMD)) GetProcAddress(cast(*u8) "glGetPerfMonitorCounterInfoAMD\0");
    procs.glGenPerfMonitorsAMD = cast(type_of(procs.glGenPerfMonitorsAMD)) GetProcAddress(cast(*u8) "glGenPerfMonitorsAMD\0");
    procs.glDeletePerfMonitorsAMD = cast(type_of(procs.glDeletePerfMonitorsAMD)) GetProcAddress(cast(*u8) "glDeletePerfMonitorsAMD\0");
    procs.glSelectPerfMonitorCountersAMD = cast(type_of(procs.glSelectPerfMonitorCountersAMD)) GetProcAddress(cast(*u8) "glSelectPerfMonitorCountersAMD\0");
    procs.glBeginPerfMonitorAMD = cast(type_of(procs.glBeginPerfMonitorAMD)) GetProcAddress(cast(*u8) "glBeginPerfMonitorAMD\0");
    procs.glEndPerfMonitorAMD = cast(type_of(procs.glEndPerfMonitorAMD)) GetProcAddress(cast(*u8) "glEndPerfMonitorAMD\0");
    procs.glGetPerfMonitorCounterDataAMD = cast(type_of(procs.glGetPerfMonitorCounterDataAMD)) GetProcAddress(cast(*u8) "glGetPerfMonitorCounterDataAMD\0");
    procs.glSetMultisamplefvAMD = cast(type_of(procs.glSetMultisamplefvAMD)) GetProcAddress(cast(*u8) "glSetMultisamplefvAMD\0");
    procs.glTexStorageSparseAMD = cast(type_of(procs.glTexStorageSparseAMD)) GetProcAddress(cast(*u8) "glTexStorageSparseAMD\0");
    procs.glTextureStorageSparseAMD = cast(type_of(procs.glTextureStorageSparseAMD)) GetProcAddress(cast(*u8) "glTextureStorageSparseAMD\0");
    procs.glStencilOpValueAMD = cast(type_of(procs.glStencilOpValueAMD)) GetProcAddress(cast(*u8) "glStencilOpValueAMD\0");
    procs.glTessellationFactorAMD = cast(type_of(procs.glTessellationFactorAMD)) GetProcAddress(cast(*u8) "glTessellationFactorAMD\0");
    procs.glTessellationModeAMD = cast(type_of(procs.glTessellationModeAMD)) GetProcAddress(cast(*u8) "glTessellationModeAMD\0");
    procs.glElementPointerAPPLE = cast(type_of(procs.glElementPointerAPPLE)) GetProcAddress(cast(*u8) "glElementPointerAPPLE\0");
    procs.glDrawElementArrayAPPLE = cast(type_of(procs.glDrawElementArrayAPPLE)) GetProcAddress(cast(*u8) "glDrawElementArrayAPPLE\0");
    procs.glDrawRangeElementArrayAPPLE = cast(type_of(procs.glDrawRangeElementArrayAPPLE)) GetProcAddress(cast(*u8) "glDrawRangeElementArrayAPPLE\0");
    procs.glMultiDrawElementArrayAPPLE = cast(type_of(procs.glMultiDrawElementArrayAPPLE)) GetProcAddress(cast(*u8) "glMultiDrawElementArrayAPPLE\0");
    procs.glMultiDrawRangeElementArrayAPPLE = cast(type_of(procs.glMultiDrawRangeElementArrayAPPLE)) GetProcAddress(cast(*u8) "glMultiDrawRangeElementArrayAPPLE\0");
    procs.glGenFencesAPPLE = cast(type_of(procs.glGenFencesAPPLE)) GetProcAddress(cast(*u8) "glGenFencesAPPLE\0");
    procs.glDeleteFencesAPPLE = cast(type_of(procs.glDeleteFencesAPPLE)) GetProcAddress(cast(*u8) "glDeleteFencesAPPLE\0");
    procs.glSetFenceAPPLE = cast(type_of(procs.glSetFenceAPPLE)) GetProcAddress(cast(*u8) "glSetFenceAPPLE\0");
    procs.glIsFenceAPPLE = cast(type_of(procs.glIsFenceAPPLE)) GetProcAddress(cast(*u8) "glIsFenceAPPLE\0");
    procs.glTestFenceAPPLE = cast(type_of(procs.glTestFenceAPPLE)) GetProcAddress(cast(*u8) "glTestFenceAPPLE\0");
    procs.glFinishFenceAPPLE = cast(type_of(procs.glFinishFenceAPPLE)) GetProcAddress(cast(*u8) "glFinishFenceAPPLE\0");
    procs.glTestObjectAPPLE = cast(type_of(procs.glTestObjectAPPLE)) GetProcAddress(cast(*u8) "glTestObjectAPPLE\0");
    procs.glFinishObjectAPPLE = cast(type_of(procs.glFinishObjectAPPLE)) GetProcAddress(cast(*u8) "glFinishObjectAPPLE\0");
    procs.glBufferParameteriAPPLE = cast(type_of(procs.glBufferParameteriAPPLE)) GetProcAddress(cast(*u8) "glBufferParameteriAPPLE\0");
    procs.glFlushMappedBufferRangeAPPLE = cast(type_of(procs.glFlushMappedBufferRangeAPPLE)) GetProcAddress(cast(*u8) "glFlushMappedBufferRangeAPPLE\0");
    procs.glObjectPurgeableAPPLE = cast(type_of(procs.glObjectPurgeableAPPLE)) GetProcAddress(cast(*u8) "glObjectPurgeableAPPLE\0");
    procs.glObjectUnpurgeableAPPLE = cast(type_of(procs.glObjectUnpurgeableAPPLE)) GetProcAddress(cast(*u8) "glObjectUnpurgeableAPPLE\0");
    procs.glGetObjectParameterivAPPLE = cast(type_of(procs.glGetObjectParameterivAPPLE)) GetProcAddress(cast(*u8) "glGetObjectParameterivAPPLE\0");
    procs.glTextureRangeAPPLE = cast(type_of(procs.glTextureRangeAPPLE)) GetProcAddress(cast(*u8) "glTextureRangeAPPLE\0");
    procs.glGetTexParameterPointervAPPLE = cast(type_of(procs.glGetTexParameterPointervAPPLE)) GetProcAddress(cast(*u8) "glGetTexParameterPointervAPPLE\0");
    procs.glBindVertexArrayAPPLE = cast(type_of(procs.glBindVertexArrayAPPLE)) GetProcAddress(cast(*u8) "glBindVertexArrayAPPLE\0");
    procs.glDeleteVertexArraysAPPLE = cast(type_of(procs.glDeleteVertexArraysAPPLE)) GetProcAddress(cast(*u8) "glDeleteVertexArraysAPPLE\0");
    procs.glGenVertexArraysAPPLE = cast(type_of(procs.glGenVertexArraysAPPLE)) GetProcAddress(cast(*u8) "glGenVertexArraysAPPLE\0");
    procs.glIsVertexArrayAPPLE = cast(type_of(procs.glIsVertexArrayAPPLE)) GetProcAddress(cast(*u8) "glIsVertexArrayAPPLE\0");
    procs.glVertexArrayRangeAPPLE = cast(type_of(procs.glVertexArrayRangeAPPLE)) GetProcAddress(cast(*u8) "glVertexArrayRangeAPPLE\0");
    procs.glFlushVertexArrayRangeAPPLE = cast(type_of(procs.glFlushVertexArrayRangeAPPLE)) GetProcAddress(cast(*u8) "glFlushVertexArrayRangeAPPLE\0");
    procs.glVertexArrayParameteriAPPLE = cast(type_of(procs.glVertexArrayParameteriAPPLE)) GetProcAddress(cast(*u8) "glVertexArrayParameteriAPPLE\0");
    procs.glEnableVertexAttribAPPLE = cast(type_of(procs.glEnableVertexAttribAPPLE)) GetProcAddress(cast(*u8) "glEnableVertexAttribAPPLE\0");
    procs.glDisableVertexAttribAPPLE = cast(type_of(procs.glDisableVertexAttribAPPLE)) GetProcAddress(cast(*u8) "glDisableVertexAttribAPPLE\0");
    procs.glIsVertexAttribEnabledAPPLE = cast(type_of(procs.glIsVertexAttribEnabledAPPLE)) GetProcAddress(cast(*u8) "glIsVertexAttribEnabledAPPLE\0");
    procs.glMapVertexAttrib1dAPPLE = cast(type_of(procs.glMapVertexAttrib1dAPPLE)) GetProcAddress(cast(*u8) "glMapVertexAttrib1dAPPLE\0");
    procs.glMapVertexAttrib1fAPPLE = cast(type_of(procs.glMapVertexAttrib1fAPPLE)) GetProcAddress(cast(*u8) "glMapVertexAttrib1fAPPLE\0");
    procs.glMapVertexAttrib2dAPPLE = cast(type_of(procs.glMapVertexAttrib2dAPPLE)) GetProcAddress(cast(*u8) "glMapVertexAttrib2dAPPLE\0");
    procs.glMapVertexAttrib2fAPPLE = cast(type_of(procs.glMapVertexAttrib2fAPPLE)) GetProcAddress(cast(*u8) "glMapVertexAttrib2fAPPLE\0");
    procs.glPrimitiveBoundingBoxARB = cast(type_of(procs.glPrimitiveBoundingBoxARB)) GetProcAddress(cast(*u8) "glPrimitiveBoundingBoxARB\0");
    procs.glGetTextureHandleARB = cast(type_of(procs.glGetTextureHandleARB)) GetProcAddress(cast(*u8) "glGetTextureHandleARB\0");
    procs.glGetTextureSamplerHandleARB = cast(type_of(procs.glGetTextureSamplerHandleARB)) GetProcAddress(cast(*u8) "glGetTextureSamplerHandleARB\0");
    procs.glMakeTextureHandleResidentARB = cast(type_of(procs.glMakeTextureHandleResidentARB)) GetProcAddress(cast(*u8) "glMakeTextureHandleResidentARB\0");
    procs.glMakeTextureHandleNonResidentARB = cast(type_of(procs.glMakeTextureHandleNonResidentARB)) GetProcAddress(cast(*u8) "glMakeTextureHandleNonResidentARB\0");
    procs.glGetImageHandleARB = cast(type_of(procs.glGetImageHandleARB)) GetProcAddress(cast(*u8) "glGetImageHandleARB\0");
    procs.glMakeImageHandleResidentARB = cast(type_of(procs.glMakeImageHandleResidentARB)) GetProcAddress(cast(*u8) "glMakeImageHandleResidentARB\0");
    procs.glMakeImageHandleNonResidentARB = cast(type_of(procs.glMakeImageHandleNonResidentARB)) GetProcAddress(cast(*u8) "glMakeImageHandleNonResidentARB\0");
    procs.glUniformHandleui64ARB = cast(type_of(procs.glUniformHandleui64ARB)) GetProcAddress(cast(*u8) "glUniformHandleui64ARB\0");
    procs.glUniformHandleui64vARB = cast(type_of(procs.glUniformHandleui64vARB)) GetProcAddress(cast(*u8) "glUniformHandleui64vARB\0");
    procs.glProgramUniformHandleui64ARB = cast(type_of(procs.glProgramUniformHandleui64ARB)) GetProcAddress(cast(*u8) "glProgramUniformHandleui64ARB\0");
    procs.glProgramUniformHandleui64vARB = cast(type_of(procs.glProgramUniformHandleui64vARB)) GetProcAddress(cast(*u8) "glProgramUniformHandleui64vARB\0");
    procs.glIsTextureHandleResidentARB = cast(type_of(procs.glIsTextureHandleResidentARB)) GetProcAddress(cast(*u8) "glIsTextureHandleResidentARB\0");
    procs.glIsImageHandleResidentARB = cast(type_of(procs.glIsImageHandleResidentARB)) GetProcAddress(cast(*u8) "glIsImageHandleResidentARB\0");
    procs.glVertexAttribL1ui64ARB = cast(type_of(procs.glVertexAttribL1ui64ARB)) GetProcAddress(cast(*u8) "glVertexAttribL1ui64ARB\0");
    procs.glVertexAttribL1ui64vARB = cast(type_of(procs.glVertexAttribL1ui64vARB)) GetProcAddress(cast(*u8) "glVertexAttribL1ui64vARB\0");
    procs.glGetVertexAttribLui64vARB = cast(type_of(procs.glGetVertexAttribLui64vARB)) GetProcAddress(cast(*u8) "glGetVertexAttribLui64vARB\0");
    procs.glClampColorARB = cast(type_of(procs.glClampColorARB)) GetProcAddress(cast(*u8) "glClampColorARB\0");
    procs.glDispatchComputeGroupSizeARB = cast(type_of(procs.glDispatchComputeGroupSizeARB)) GetProcAddress(cast(*u8) "glDispatchComputeGroupSizeARB\0");
    procs.glDebugMessageControlARB = cast(type_of(procs.glDebugMessageControlARB)) GetProcAddress(cast(*u8) "glDebugMessageControlARB\0");
    procs.glDebugMessageInsertARB = cast(type_of(procs.glDebugMessageInsertARB)) GetProcAddress(cast(*u8) "glDebugMessageInsertARB\0");
    procs.glDebugMessageCallbackARB = cast(type_of(procs.glDebugMessageCallbackARB)) GetProcAddress(cast(*u8) "glDebugMessageCallbackARB\0");
    procs.glGetDebugMessageLogARB = cast(type_of(procs.glGetDebugMessageLogARB)) GetProcAddress(cast(*u8) "glGetDebugMessageLogARB\0");
    procs.glDrawBuffersARB = cast(type_of(procs.glDrawBuffersARB)) GetProcAddress(cast(*u8) "glDrawBuffersARB\0");
    procs.glBlendEquationiARB = cast(type_of(procs.glBlendEquationiARB)) GetProcAddress(cast(*u8) "glBlendEquationiARB\0");
    procs.glBlendEquationSeparateiARB = cast(type_of(procs.glBlendEquationSeparateiARB)) GetProcAddress(cast(*u8) "glBlendEquationSeparateiARB\0");
    procs.glBlendFunciARB = cast(type_of(procs.glBlendFunciARB)) GetProcAddress(cast(*u8) "glBlendFunciARB\0");
    procs.glBlendFuncSeparateiARB = cast(type_of(procs.glBlendFuncSeparateiARB)) GetProcAddress(cast(*u8) "glBlendFuncSeparateiARB\0");
    procs.glDrawArraysInstancedARB = cast(type_of(procs.glDrawArraysInstancedARB)) GetProcAddress(cast(*u8) "glDrawArraysInstancedARB\0");
    procs.glDrawElementsInstancedARB = cast(type_of(procs.glDrawElementsInstancedARB)) GetProcAddress(cast(*u8) "glDrawElementsInstancedARB\0");
    procs.glProgramStringARB = cast(type_of(procs.glProgramStringARB)) GetProcAddress(cast(*u8) "glProgramStringARB\0");
    procs.glBindProgramARB = cast(type_of(procs.glBindProgramARB)) GetProcAddress(cast(*u8) "glBindProgramARB\0");
    procs.glDeleteProgramsARB = cast(type_of(procs.glDeleteProgramsARB)) GetProcAddress(cast(*u8) "glDeleteProgramsARB\0");
    procs.glGenProgramsARB = cast(type_of(procs.glGenProgramsARB)) GetProcAddress(cast(*u8) "glGenProgramsARB\0");
    procs.glProgramEnvParameter4dARB = cast(type_of(procs.glProgramEnvParameter4dARB)) GetProcAddress(cast(*u8) "glProgramEnvParameter4dARB\0");
    procs.glProgramEnvParameter4dvARB = cast(type_of(procs.glProgramEnvParameter4dvARB)) GetProcAddress(cast(*u8) "glProgramEnvParameter4dvARB\0");
    procs.glProgramEnvParameter4fARB = cast(type_of(procs.glProgramEnvParameter4fARB)) GetProcAddress(cast(*u8) "glProgramEnvParameter4fARB\0");
    procs.glProgramEnvParameter4fvARB = cast(type_of(procs.glProgramEnvParameter4fvARB)) GetProcAddress(cast(*u8) "glProgramEnvParameter4fvARB\0");
    procs.glProgramLocalParameter4dARB = cast(type_of(procs.glProgramLocalParameter4dARB)) GetProcAddress(cast(*u8) "glProgramLocalParameter4dARB\0");
    procs.glProgramLocalParameter4dvARB = cast(type_of(procs.glProgramLocalParameter4dvARB)) GetProcAddress(cast(*u8) "glProgramLocalParameter4dvARB\0");
    procs.glProgramLocalParameter4fARB = cast(type_of(procs.glProgramLocalParameter4fARB)) GetProcAddress(cast(*u8) "glProgramLocalParameter4fARB\0");
    procs.glProgramLocalParameter4fvARB = cast(type_of(procs.glProgramLocalParameter4fvARB)) GetProcAddress(cast(*u8) "glProgramLocalParameter4fvARB\0");
    procs.glGetProgramEnvParameterdvARB = cast(type_of(procs.glGetProgramEnvParameterdvARB)) GetProcAddress(cast(*u8) "glGetProgramEnvParameterdvARB\0");
    procs.glGetProgramEnvParameterfvARB = cast(type_of(procs.glGetProgramEnvParameterfvARB)) GetProcAddress(cast(*u8) "glGetProgramEnvParameterfvARB\0");
    procs.glGetProgramLocalParameterdvARB = cast(type_of(procs.glGetProgramLocalParameterdvARB)) GetProcAddress(cast(*u8) "glGetProgramLocalParameterdvARB\0");
    procs.glGetProgramLocalParameterfvARB = cast(type_of(procs.glGetProgramLocalParameterfvARB)) GetProcAddress(cast(*u8) "glGetProgramLocalParameterfvARB\0");
    procs.glGetProgramivARB = cast(type_of(procs.glGetProgramivARB)) GetProcAddress(cast(*u8) "glGetProgramivARB\0");
    procs.glGetProgramStringARB = cast(type_of(procs.glGetProgramStringARB)) GetProcAddress(cast(*u8) "glGetProgramStringARB\0");
    procs.glIsProgramARB = cast(type_of(procs.glIsProgramARB)) GetProcAddress(cast(*u8) "glIsProgramARB\0");
    procs.glProgramParameteriARB = cast(type_of(procs.glProgramParameteriARB)) GetProcAddress(cast(*u8) "glProgramParameteriARB\0");
    procs.glFramebufferTextureARB = cast(type_of(procs.glFramebufferTextureARB)) GetProcAddress(cast(*u8) "glFramebufferTextureARB\0");
    procs.glFramebufferTextureLayerARB = cast(type_of(procs.glFramebufferTextureLayerARB)) GetProcAddress(cast(*u8) "glFramebufferTextureLayerARB\0");
    procs.glFramebufferTextureFaceARB = cast(type_of(procs.glFramebufferTextureFaceARB)) GetProcAddress(cast(*u8) "glFramebufferTextureFaceARB\0");
    procs.glSpecializeShaderARB = cast(type_of(procs.glSpecializeShaderARB)) GetProcAddress(cast(*u8) "glSpecializeShaderARB\0");
    procs.glUniform1i64ARB = cast(type_of(procs.glUniform1i64ARB)) GetProcAddress(cast(*u8) "glUniform1i64ARB\0");
    procs.glUniform2i64ARB = cast(type_of(procs.glUniform2i64ARB)) GetProcAddress(cast(*u8) "glUniform2i64ARB\0");
    procs.glUniform3i64ARB = cast(type_of(procs.glUniform3i64ARB)) GetProcAddress(cast(*u8) "glUniform3i64ARB\0");
    procs.glUniform4i64ARB = cast(type_of(procs.glUniform4i64ARB)) GetProcAddress(cast(*u8) "glUniform4i64ARB\0");
    procs.glUniform1i64vARB = cast(type_of(procs.glUniform1i64vARB)) GetProcAddress(cast(*u8) "glUniform1i64vARB\0");
    procs.glUniform2i64vARB = cast(type_of(procs.glUniform2i64vARB)) GetProcAddress(cast(*u8) "glUniform2i64vARB\0");
    procs.glUniform3i64vARB = cast(type_of(procs.glUniform3i64vARB)) GetProcAddress(cast(*u8) "glUniform3i64vARB\0");
    procs.glUniform4i64vARB = cast(type_of(procs.glUniform4i64vARB)) GetProcAddress(cast(*u8) "glUniform4i64vARB\0");
    procs.glUniform1ui64ARB = cast(type_of(procs.glUniform1ui64ARB)) GetProcAddress(cast(*u8) "glUniform1ui64ARB\0");
    procs.glUniform2ui64ARB = cast(type_of(procs.glUniform2ui64ARB)) GetProcAddress(cast(*u8) "glUniform2ui64ARB\0");
    procs.glUniform3ui64ARB = cast(type_of(procs.glUniform3ui64ARB)) GetProcAddress(cast(*u8) "glUniform3ui64ARB\0");
    procs.glUniform4ui64ARB = cast(type_of(procs.glUniform4ui64ARB)) GetProcAddress(cast(*u8) "glUniform4ui64ARB\0");
    procs.glUniform1ui64vARB = cast(type_of(procs.glUniform1ui64vARB)) GetProcAddress(cast(*u8) "glUniform1ui64vARB\0");
    procs.glUniform2ui64vARB = cast(type_of(procs.glUniform2ui64vARB)) GetProcAddress(cast(*u8) "glUniform2ui64vARB\0");
    procs.glUniform3ui64vARB = cast(type_of(procs.glUniform3ui64vARB)) GetProcAddress(cast(*u8) "glUniform3ui64vARB\0");
    procs.glUniform4ui64vARB = cast(type_of(procs.glUniform4ui64vARB)) GetProcAddress(cast(*u8) "glUniform4ui64vARB\0");
    procs.glGetUniformi64vARB = cast(type_of(procs.glGetUniformi64vARB)) GetProcAddress(cast(*u8) "glGetUniformi64vARB\0");
    procs.glGetUniformui64vARB = cast(type_of(procs.glGetUniformui64vARB)) GetProcAddress(cast(*u8) "glGetUniformui64vARB\0");
    procs.glGetnUniformi64vARB = cast(type_of(procs.glGetnUniformi64vARB)) GetProcAddress(cast(*u8) "glGetnUniformi64vARB\0");
    procs.glGetnUniformui64vARB = cast(type_of(procs.glGetnUniformui64vARB)) GetProcAddress(cast(*u8) "glGetnUniformui64vARB\0");
    procs.glProgramUniform1i64ARB = cast(type_of(procs.glProgramUniform1i64ARB)) GetProcAddress(cast(*u8) "glProgramUniform1i64ARB\0");
    procs.glProgramUniform2i64ARB = cast(type_of(procs.glProgramUniform2i64ARB)) GetProcAddress(cast(*u8) "glProgramUniform2i64ARB\0");
    procs.glProgramUniform3i64ARB = cast(type_of(procs.glProgramUniform3i64ARB)) GetProcAddress(cast(*u8) "glProgramUniform3i64ARB\0");
    procs.glProgramUniform4i64ARB = cast(type_of(procs.glProgramUniform4i64ARB)) GetProcAddress(cast(*u8) "glProgramUniform4i64ARB\0");
    procs.glProgramUniform1i64vARB = cast(type_of(procs.glProgramUniform1i64vARB)) GetProcAddress(cast(*u8) "glProgramUniform1i64vARB\0");
    procs.glProgramUniform2i64vARB = cast(type_of(procs.glProgramUniform2i64vARB)) GetProcAddress(cast(*u8) "glProgramUniform2i64vARB\0");
    procs.glProgramUniform3i64vARB = cast(type_of(procs.glProgramUniform3i64vARB)) GetProcAddress(cast(*u8) "glProgramUniform3i64vARB\0");
    procs.glProgramUniform4i64vARB = cast(type_of(procs.glProgramUniform4i64vARB)) GetProcAddress(cast(*u8) "glProgramUniform4i64vARB\0");
    procs.glProgramUniform1ui64ARB = cast(type_of(procs.glProgramUniform1ui64ARB)) GetProcAddress(cast(*u8) "glProgramUniform1ui64ARB\0");
    procs.glProgramUniform2ui64ARB = cast(type_of(procs.glProgramUniform2ui64ARB)) GetProcAddress(cast(*u8) "glProgramUniform2ui64ARB\0");
    procs.glProgramUniform3ui64ARB = cast(type_of(procs.glProgramUniform3ui64ARB)) GetProcAddress(cast(*u8) "glProgramUniform3ui64ARB\0");
    procs.glProgramUniform4ui64ARB = cast(type_of(procs.glProgramUniform4ui64ARB)) GetProcAddress(cast(*u8) "glProgramUniform4ui64ARB\0");
    procs.glProgramUniform1ui64vARB = cast(type_of(procs.glProgramUniform1ui64vARB)) GetProcAddress(cast(*u8) "glProgramUniform1ui64vARB\0");
    procs.glProgramUniform2ui64vARB = cast(type_of(procs.glProgramUniform2ui64vARB)) GetProcAddress(cast(*u8) "glProgramUniform2ui64vARB\0");
    procs.glProgramUniform3ui64vARB = cast(type_of(procs.glProgramUniform3ui64vARB)) GetProcAddress(cast(*u8) "glProgramUniform3ui64vARB\0");
    procs.glProgramUniform4ui64vARB = cast(type_of(procs.glProgramUniform4ui64vARB)) GetProcAddress(cast(*u8) "glProgramUniform4ui64vARB\0");
    procs.glColorTable = cast(type_of(procs.glColorTable)) GetProcAddress(cast(*u8) "glColorTable\0");
    procs.glColorTableParameterfv = cast(type_of(procs.glColorTableParameterfv)) GetProcAddress(cast(*u8) "glColorTableParameterfv\0");
    procs.glColorTableParameteriv = cast(type_of(procs.glColorTableParameteriv)) GetProcAddress(cast(*u8) "glColorTableParameteriv\0");
    procs.glCopyColorTable = cast(type_of(procs.glCopyColorTable)) GetProcAddress(cast(*u8) "glCopyColorTable\0");
    procs.glGetColorTable = cast(type_of(procs.glGetColorTable)) GetProcAddress(cast(*u8) "glGetColorTable\0");
    procs.glGetColorTableParameterfv = cast(type_of(procs.glGetColorTableParameterfv)) GetProcAddress(cast(*u8) "glGetColorTableParameterfv\0");
    procs.glGetColorTableParameteriv = cast(type_of(procs.glGetColorTableParameteriv)) GetProcAddress(cast(*u8) "glGetColorTableParameteriv\0");
    procs.glColorSubTable = cast(type_of(procs.glColorSubTable)) GetProcAddress(cast(*u8) "glColorSubTable\0");
    procs.glCopyColorSubTable = cast(type_of(procs.glCopyColorSubTable)) GetProcAddress(cast(*u8) "glCopyColorSubTable\0");
    procs.glConvolutionFilter1D = cast(type_of(procs.glConvolutionFilter1D)) GetProcAddress(cast(*u8) "glConvolutionFilter1D\0");
    procs.glConvolutionFilter2D = cast(type_of(procs.glConvolutionFilter2D)) GetProcAddress(cast(*u8) "glConvolutionFilter2D\0");
    procs.glConvolutionParameterf = cast(type_of(procs.glConvolutionParameterf)) GetProcAddress(cast(*u8) "glConvolutionParameterf\0");
    procs.glConvolutionParameterfv = cast(type_of(procs.glConvolutionParameterfv)) GetProcAddress(cast(*u8) "glConvolutionParameterfv\0");
    procs.glConvolutionParameteri = cast(type_of(procs.glConvolutionParameteri)) GetProcAddress(cast(*u8) "glConvolutionParameteri\0");
    procs.glConvolutionParameteriv = cast(type_of(procs.glConvolutionParameteriv)) GetProcAddress(cast(*u8) "glConvolutionParameteriv\0");
    procs.glCopyConvolutionFilter1D = cast(type_of(procs.glCopyConvolutionFilter1D)) GetProcAddress(cast(*u8) "glCopyConvolutionFilter1D\0");
    procs.glCopyConvolutionFilter2D = cast(type_of(procs.glCopyConvolutionFilter2D)) GetProcAddress(cast(*u8) "glCopyConvolutionFilter2D\0");
    procs.glGetConvolutionFilter = cast(type_of(procs.glGetConvolutionFilter)) GetProcAddress(cast(*u8) "glGetConvolutionFilter\0");
    procs.glGetConvolutionParameterfv = cast(type_of(procs.glGetConvolutionParameterfv)) GetProcAddress(cast(*u8) "glGetConvolutionParameterfv\0");
    procs.glGetConvolutionParameteriv = cast(type_of(procs.glGetConvolutionParameteriv)) GetProcAddress(cast(*u8) "glGetConvolutionParameteriv\0");
    procs.glGetSeparableFilter = cast(type_of(procs.glGetSeparableFilter)) GetProcAddress(cast(*u8) "glGetSeparableFilter\0");
    procs.glSeparableFilter2D = cast(type_of(procs.glSeparableFilter2D)) GetProcAddress(cast(*u8) "glSeparableFilter2D\0");
    procs.glGetHistogram = cast(type_of(procs.glGetHistogram)) GetProcAddress(cast(*u8) "glGetHistogram\0");
    procs.glGetHistogramParameterfv = cast(type_of(procs.glGetHistogramParameterfv)) GetProcAddress(cast(*u8) "glGetHistogramParameterfv\0");
    procs.glGetHistogramParameteriv = cast(type_of(procs.glGetHistogramParameteriv)) GetProcAddress(cast(*u8) "glGetHistogramParameteriv\0");
    procs.glGetMinmax = cast(type_of(procs.glGetMinmax)) GetProcAddress(cast(*u8) "glGetMinmax\0");
    procs.glGetMinmaxParameterfv = cast(type_of(procs.glGetMinmaxParameterfv)) GetProcAddress(cast(*u8) "glGetMinmaxParameterfv\0");
    procs.glGetMinmaxParameteriv = cast(type_of(procs.glGetMinmaxParameteriv)) GetProcAddress(cast(*u8) "glGetMinmaxParameteriv\0");
    procs.glHistogram = cast(type_of(procs.glHistogram)) GetProcAddress(cast(*u8) "glHistogram\0");
    procs.glMinmax = cast(type_of(procs.glMinmax)) GetProcAddress(cast(*u8) "glMinmax\0");
    procs.glResetHistogram = cast(type_of(procs.glResetHistogram)) GetProcAddress(cast(*u8) "glResetHistogram\0");
    procs.glResetMinmax = cast(type_of(procs.glResetMinmax)) GetProcAddress(cast(*u8) "glResetMinmax\0");
    procs.glMultiDrawArraysIndirectCountARB = cast(type_of(procs.glMultiDrawArraysIndirectCountARB)) GetProcAddress(cast(*u8) "glMultiDrawArraysIndirectCountARB\0");
    procs.glMultiDrawElementsIndirectCountARB = cast(type_of(procs.glMultiDrawElementsIndirectCountARB)) GetProcAddress(cast(*u8) "glMultiDrawElementsIndirectCountARB\0");
    procs.glVertexAttribDivisorARB = cast(type_of(procs.glVertexAttribDivisorARB)) GetProcAddress(cast(*u8) "glVertexAttribDivisorARB\0");
    procs.glCurrentPaletteMatrixARB = cast(type_of(procs.glCurrentPaletteMatrixARB)) GetProcAddress(cast(*u8) "glCurrentPaletteMatrixARB\0");
    procs.glMatrixIndexubvARB = cast(type_of(procs.glMatrixIndexubvARB)) GetProcAddress(cast(*u8) "glMatrixIndexubvARB\0");
    procs.glMatrixIndexusvARB = cast(type_of(procs.glMatrixIndexusvARB)) GetProcAddress(cast(*u8) "glMatrixIndexusvARB\0");
    procs.glMatrixIndexuivARB = cast(type_of(procs.glMatrixIndexuivARB)) GetProcAddress(cast(*u8) "glMatrixIndexuivARB\0");
    procs.glMatrixIndexPointerARB = cast(type_of(procs.glMatrixIndexPointerARB)) GetProcAddress(cast(*u8) "glMatrixIndexPointerARB\0");
    procs.glSampleCoverageARB = cast(type_of(procs.glSampleCoverageARB)) GetProcAddress(cast(*u8) "glSampleCoverageARB\0");
    procs.glActiveTextureARB = cast(type_of(procs.glActiveTextureARB)) GetProcAddress(cast(*u8) "glActiveTextureARB\0");
    procs.glClientActiveTextureARB = cast(type_of(procs.glClientActiveTextureARB)) GetProcAddress(cast(*u8) "glClientActiveTextureARB\0");
    procs.glMultiTexCoord1dARB = cast(type_of(procs.glMultiTexCoord1dARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1dARB\0");
    procs.glMultiTexCoord1dvARB = cast(type_of(procs.glMultiTexCoord1dvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1dvARB\0");
    procs.glMultiTexCoord1fARB = cast(type_of(procs.glMultiTexCoord1fARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1fARB\0");
    procs.glMultiTexCoord1fvARB = cast(type_of(procs.glMultiTexCoord1fvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1fvARB\0");
    procs.glMultiTexCoord1iARB = cast(type_of(procs.glMultiTexCoord1iARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1iARB\0");
    procs.glMultiTexCoord1ivARB = cast(type_of(procs.glMultiTexCoord1ivARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1ivARB\0");
    procs.glMultiTexCoord1sARB = cast(type_of(procs.glMultiTexCoord1sARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1sARB\0");
    procs.glMultiTexCoord1svARB = cast(type_of(procs.glMultiTexCoord1svARB)) GetProcAddress(cast(*u8) "glMultiTexCoord1svARB\0");
    procs.glMultiTexCoord2dARB = cast(type_of(procs.glMultiTexCoord2dARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2dARB\0");
    procs.glMultiTexCoord2dvARB = cast(type_of(procs.glMultiTexCoord2dvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2dvARB\0");
    procs.glMultiTexCoord2fARB = cast(type_of(procs.glMultiTexCoord2fARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2fARB\0");
    procs.glMultiTexCoord2fvARB = cast(type_of(procs.glMultiTexCoord2fvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2fvARB\0");
    procs.glMultiTexCoord2iARB = cast(type_of(procs.glMultiTexCoord2iARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2iARB\0");
    procs.glMultiTexCoord2ivARB = cast(type_of(procs.glMultiTexCoord2ivARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2ivARB\0");
    procs.glMultiTexCoord2sARB = cast(type_of(procs.glMultiTexCoord2sARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2sARB\0");
    procs.glMultiTexCoord2svARB = cast(type_of(procs.glMultiTexCoord2svARB)) GetProcAddress(cast(*u8) "glMultiTexCoord2svARB\0");
    procs.glMultiTexCoord3dARB = cast(type_of(procs.glMultiTexCoord3dARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3dARB\0");
    procs.glMultiTexCoord3dvARB = cast(type_of(procs.glMultiTexCoord3dvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3dvARB\0");
    procs.glMultiTexCoord3fARB = cast(type_of(procs.glMultiTexCoord3fARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3fARB\0");
    procs.glMultiTexCoord3fvARB = cast(type_of(procs.glMultiTexCoord3fvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3fvARB\0");
    procs.glMultiTexCoord3iARB = cast(type_of(procs.glMultiTexCoord3iARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3iARB\0");
    procs.glMultiTexCoord3ivARB = cast(type_of(procs.glMultiTexCoord3ivARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3ivARB\0");
    procs.glMultiTexCoord3sARB = cast(type_of(procs.glMultiTexCoord3sARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3sARB\0");
    procs.glMultiTexCoord3svARB = cast(type_of(procs.glMultiTexCoord3svARB)) GetProcAddress(cast(*u8) "glMultiTexCoord3svARB\0");
    procs.glMultiTexCoord4dARB = cast(type_of(procs.glMultiTexCoord4dARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4dARB\0");
    procs.glMultiTexCoord4dvARB = cast(type_of(procs.glMultiTexCoord4dvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4dvARB\0");
    procs.glMultiTexCoord4fARB = cast(type_of(procs.glMultiTexCoord4fARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4fARB\0");
    procs.glMultiTexCoord4fvARB = cast(type_of(procs.glMultiTexCoord4fvARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4fvARB\0");
    procs.glMultiTexCoord4iARB = cast(type_of(procs.glMultiTexCoord4iARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4iARB\0");
    procs.glMultiTexCoord4ivARB = cast(type_of(procs.glMultiTexCoord4ivARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4ivARB\0");
    procs.glMultiTexCoord4sARB = cast(type_of(procs.glMultiTexCoord4sARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4sARB\0");
    procs.glMultiTexCoord4svARB = cast(type_of(procs.glMultiTexCoord4svARB)) GetProcAddress(cast(*u8) "glMultiTexCoord4svARB\0");
    procs.glGenQueriesARB = cast(type_of(procs.glGenQueriesARB)) GetProcAddress(cast(*u8) "glGenQueriesARB\0");
    procs.glDeleteQueriesARB = cast(type_of(procs.glDeleteQueriesARB)) GetProcAddress(cast(*u8) "glDeleteQueriesARB\0");
    procs.glIsQueryARB = cast(type_of(procs.glIsQueryARB)) GetProcAddress(cast(*u8) "glIsQueryARB\0");
    procs.glBeginQueryARB = cast(type_of(procs.glBeginQueryARB)) GetProcAddress(cast(*u8) "glBeginQueryARB\0");
    procs.glEndQueryARB = cast(type_of(procs.glEndQueryARB)) GetProcAddress(cast(*u8) "glEndQueryARB\0");
    procs.glGetQueryivARB = cast(type_of(procs.glGetQueryivARB)) GetProcAddress(cast(*u8) "glGetQueryivARB\0");
    procs.glGetQueryObjectivARB = cast(type_of(procs.glGetQueryObjectivARB)) GetProcAddress(cast(*u8) "glGetQueryObjectivARB\0");
    procs.glGetQueryObjectuivARB = cast(type_of(procs.glGetQueryObjectuivARB)) GetProcAddress(cast(*u8) "glGetQueryObjectuivARB\0");
    procs.glMaxShaderCompilerThreadsARB = cast(type_of(procs.glMaxShaderCompilerThreadsARB)) GetProcAddress(cast(*u8) "glMaxShaderCompilerThreadsARB\0");
    procs.glPointParameterfARB = cast(type_of(procs.glPointParameterfARB)) GetProcAddress(cast(*u8) "glPointParameterfARB\0");
    procs.glPointParameterfvARB = cast(type_of(procs.glPointParameterfvARB)) GetProcAddress(cast(*u8) "glPointParameterfvARB\0");
    procs.glGetGraphicsResetStatusARB = cast(type_of(procs.glGetGraphicsResetStatusARB)) GetProcAddress(cast(*u8) "glGetGraphicsResetStatusARB\0");
    procs.glGetnTexImageARB = cast(type_of(procs.glGetnTexImageARB)) GetProcAddress(cast(*u8) "glGetnTexImageARB\0");
    procs.glReadnPixelsARB = cast(type_of(procs.glReadnPixelsARB)) GetProcAddress(cast(*u8) "glReadnPixelsARB\0");
    procs.glGetnCompressedTexImageARB = cast(type_of(procs.glGetnCompressedTexImageARB)) GetProcAddress(cast(*u8) "glGetnCompressedTexImageARB\0");
    procs.glGetnUniformfvARB = cast(type_of(procs.glGetnUniformfvARB)) GetProcAddress(cast(*u8) "glGetnUniformfvARB\0");
    procs.glGetnUniformivARB = cast(type_of(procs.glGetnUniformivARB)) GetProcAddress(cast(*u8) "glGetnUniformivARB\0");
    procs.glGetnUniformuivARB = cast(type_of(procs.glGetnUniformuivARB)) GetProcAddress(cast(*u8) "glGetnUniformuivARB\0");
    procs.glGetnUniformdvARB = cast(type_of(procs.glGetnUniformdvARB)) GetProcAddress(cast(*u8) "glGetnUniformdvARB\0");
    procs.glGetnMapdvARB = cast(type_of(procs.glGetnMapdvARB)) GetProcAddress(cast(*u8) "glGetnMapdvARB\0");
    procs.glGetnMapfvARB = cast(type_of(procs.glGetnMapfvARB)) GetProcAddress(cast(*u8) "glGetnMapfvARB\0");
    procs.glGetnMapivARB = cast(type_of(procs.glGetnMapivARB)) GetProcAddress(cast(*u8) "glGetnMapivARB\0");
    procs.glGetnPixelMapfvARB = cast(type_of(procs.glGetnPixelMapfvARB)) GetProcAddress(cast(*u8) "glGetnPixelMapfvARB\0");
    procs.glGetnPixelMapuivARB = cast(type_of(procs.glGetnPixelMapuivARB)) GetProcAddress(cast(*u8) "glGetnPixelMapuivARB\0");
    procs.glGetnPixelMapusvARB = cast(type_of(procs.glGetnPixelMapusvARB)) GetProcAddress(cast(*u8) "glGetnPixelMapusvARB\0");
    procs.glGetnPolygonStippleARB = cast(type_of(procs.glGetnPolygonStippleARB)) GetProcAddress(cast(*u8) "glGetnPolygonStippleARB\0");
    procs.glGetnColorTableARB = cast(type_of(procs.glGetnColorTableARB)) GetProcAddress(cast(*u8) "glGetnColorTableARB\0");
    procs.glGetnConvolutionFilterARB = cast(type_of(procs.glGetnConvolutionFilterARB)) GetProcAddress(cast(*u8) "glGetnConvolutionFilterARB\0");
    procs.glGetnSeparableFilterARB = cast(type_of(procs.glGetnSeparableFilterARB)) GetProcAddress(cast(*u8) "glGetnSeparableFilterARB\0");
    procs.glGetnHistogramARB = cast(type_of(procs.glGetnHistogramARB)) GetProcAddress(cast(*u8) "glGetnHistogramARB\0");
    procs.glGetnMinmaxARB = cast(type_of(procs.glGetnMinmaxARB)) GetProcAddress(cast(*u8) "glGetnMinmaxARB\0");
    procs.glFramebufferSampleLocationsfvARB = cast(type_of(procs.glFramebufferSampleLocationsfvARB)) GetProcAddress(cast(*u8) "glFramebufferSampleLocationsfvARB\0");
    procs.glNamedFramebufferSampleLocationsfvARB = cast(type_of(procs.glNamedFramebufferSampleLocationsfvARB)) GetProcAddress(cast(*u8) "glNamedFramebufferSampleLocationsfvARB\0");
    procs.glEvaluateDepthValuesARB = cast(type_of(procs.glEvaluateDepthValuesARB)) GetProcAddress(cast(*u8) "glEvaluateDepthValuesARB\0");
    procs.glMinSampleShadingARB = cast(type_of(procs.glMinSampleShadingARB)) GetProcAddress(cast(*u8) "glMinSampleShadingARB\0");
    procs.glDeleteObjectARB = cast(type_of(procs.glDeleteObjectARB)) GetProcAddress(cast(*u8) "glDeleteObjectARB\0");
    procs.glGetHandleARB = cast(type_of(procs.glGetHandleARB)) GetProcAddress(cast(*u8) "glGetHandleARB\0");
    procs.glDetachObjectARB = cast(type_of(procs.glDetachObjectARB)) GetProcAddress(cast(*u8) "glDetachObjectARB\0");
    procs.glCreateShaderObjectARB = cast(type_of(procs.glCreateShaderObjectARB)) GetProcAddress(cast(*u8) "glCreateShaderObjectARB\0");
    procs.glShaderSourceARB = cast(type_of(procs.glShaderSourceARB)) GetProcAddress(cast(*u8) "glShaderSourceARB\0");
    procs.glCompileShaderARB = cast(type_of(procs.glCompileShaderARB)) GetProcAddress(cast(*u8) "glCompileShaderARB\0");
    procs.glCreateProgramObjectARB = cast(type_of(procs.glCreateProgramObjectARB)) GetProcAddress(cast(*u8) "glCreateProgramObjectARB\0");
    procs.glAttachObjectARB = cast(type_of(procs.glAttachObjectARB)) GetProcAddress(cast(*u8) "glAttachObjectARB\0");
    procs.glLinkProgramARB = cast(type_of(procs.glLinkProgramARB)) GetProcAddress(cast(*u8) "glLinkProgramARB\0");
    procs.glUseProgramObjectARB = cast(type_of(procs.glUseProgramObjectARB)) GetProcAddress(cast(*u8) "glUseProgramObjectARB\0");
    procs.glValidateProgramARB = cast(type_of(procs.glValidateProgramARB)) GetProcAddress(cast(*u8) "glValidateProgramARB\0");
    procs.glUniform1fARB = cast(type_of(procs.glUniform1fARB)) GetProcAddress(cast(*u8) "glUniform1fARB\0");
    procs.glUniform2fARB = cast(type_of(procs.glUniform2fARB)) GetProcAddress(cast(*u8) "glUniform2fARB\0");
    procs.glUniform3fARB = cast(type_of(procs.glUniform3fARB)) GetProcAddress(cast(*u8) "glUniform3fARB\0");
    procs.glUniform4fARB = cast(type_of(procs.glUniform4fARB)) GetProcAddress(cast(*u8) "glUniform4fARB\0");
    procs.glUniform1iARB = cast(type_of(procs.glUniform1iARB)) GetProcAddress(cast(*u8) "glUniform1iARB\0");
    procs.glUniform2iARB = cast(type_of(procs.glUniform2iARB)) GetProcAddress(cast(*u8) "glUniform2iARB\0");
    procs.glUniform3iARB = cast(type_of(procs.glUniform3iARB)) GetProcAddress(cast(*u8) "glUniform3iARB\0");
    procs.glUniform4iARB = cast(type_of(procs.glUniform4iARB)) GetProcAddress(cast(*u8) "glUniform4iARB\0");
    procs.glUniform1fvARB = cast(type_of(procs.glUniform1fvARB)) GetProcAddress(cast(*u8) "glUniform1fvARB\0");
    procs.glUniform2fvARB = cast(type_of(procs.glUniform2fvARB)) GetProcAddress(cast(*u8) "glUniform2fvARB\0");
    procs.glUniform3fvARB = cast(type_of(procs.glUniform3fvARB)) GetProcAddress(cast(*u8) "glUniform3fvARB\0");
    procs.glUniform4fvARB = cast(type_of(procs.glUniform4fvARB)) GetProcAddress(cast(*u8) "glUniform4fvARB\0");
    procs.glUniform1ivARB = cast(type_of(procs.glUniform1ivARB)) GetProcAddress(cast(*u8) "glUniform1ivARB\0");
    procs.glUniform2ivARB = cast(type_of(procs.glUniform2ivARB)) GetProcAddress(cast(*u8) "glUniform2ivARB\0");
    procs.glUniform3ivARB = cast(type_of(procs.glUniform3ivARB)) GetProcAddress(cast(*u8) "glUniform3ivARB\0");
    procs.glUniform4ivARB = cast(type_of(procs.glUniform4ivARB)) GetProcAddress(cast(*u8) "glUniform4ivARB\0");
    procs.glUniformMatrix2fvARB = cast(type_of(procs.glUniformMatrix2fvARB)) GetProcAddress(cast(*u8) "glUniformMatrix2fvARB\0");
    procs.glUniformMatrix3fvARB = cast(type_of(procs.glUniformMatrix3fvARB)) GetProcAddress(cast(*u8) "glUniformMatrix3fvARB\0");
    procs.glUniformMatrix4fvARB = cast(type_of(procs.glUniformMatrix4fvARB)) GetProcAddress(cast(*u8) "glUniformMatrix4fvARB\0");
    procs.glGetObjectParameterfvARB = cast(type_of(procs.glGetObjectParameterfvARB)) GetProcAddress(cast(*u8) "glGetObjectParameterfvARB\0");
    procs.glGetObjectParameterivARB = cast(type_of(procs.glGetObjectParameterivARB)) GetProcAddress(cast(*u8) "glGetObjectParameterivARB\0");
    procs.glGetInfoLogARB = cast(type_of(procs.glGetInfoLogARB)) GetProcAddress(cast(*u8) "glGetInfoLogARB\0");
    procs.glGetAttachedObjectsARB = cast(type_of(procs.glGetAttachedObjectsARB)) GetProcAddress(cast(*u8) "glGetAttachedObjectsARB\0");
    procs.glGetUniformLocationARB = cast(type_of(procs.glGetUniformLocationARB)) GetProcAddress(cast(*u8) "glGetUniformLocationARB\0");
    procs.glGetActiveUniformARB = cast(type_of(procs.glGetActiveUniformARB)) GetProcAddress(cast(*u8) "glGetActiveUniformARB\0");
    procs.glGetUniformfvARB = cast(type_of(procs.glGetUniformfvARB)) GetProcAddress(cast(*u8) "glGetUniformfvARB\0");
    procs.glGetUniformivARB = cast(type_of(procs.glGetUniformivARB)) GetProcAddress(cast(*u8) "glGetUniformivARB\0");
    procs.glGetShaderSourceARB = cast(type_of(procs.glGetShaderSourceARB)) GetProcAddress(cast(*u8) "glGetShaderSourceARB\0");
    procs.glNamedStringARB = cast(type_of(procs.glNamedStringARB)) GetProcAddress(cast(*u8) "glNamedStringARB\0");
    procs.glDeleteNamedStringARB = cast(type_of(procs.glDeleteNamedStringARB)) GetProcAddress(cast(*u8) "glDeleteNamedStringARB\0");
    procs.glCompileShaderIncludeARB = cast(type_of(procs.glCompileShaderIncludeARB)) GetProcAddress(cast(*u8) "glCompileShaderIncludeARB\0");
    procs.glIsNamedStringARB = cast(type_of(procs.glIsNamedStringARB)) GetProcAddress(cast(*u8) "glIsNamedStringARB\0");
    procs.glGetNamedStringARB = cast(type_of(procs.glGetNamedStringARB)) GetProcAddress(cast(*u8) "glGetNamedStringARB\0");
    procs.glGetNamedStringivARB = cast(type_of(procs.glGetNamedStringivARB)) GetProcAddress(cast(*u8) "glGetNamedStringivARB\0");
    procs.glBufferPageCommitmentARB = cast(type_of(procs.glBufferPageCommitmentARB)) GetProcAddress(cast(*u8) "glBufferPageCommitmentARB\0");
    procs.glNamedBufferPageCommitmentEXT = cast(type_of(procs.glNamedBufferPageCommitmentEXT)) GetProcAddress(cast(*u8) "glNamedBufferPageCommitmentEXT\0");
    procs.glNamedBufferPageCommitmentARB = cast(type_of(procs.glNamedBufferPageCommitmentARB)) GetProcAddress(cast(*u8) "glNamedBufferPageCommitmentARB\0");
    procs.glTexPageCommitmentARB = cast(type_of(procs.glTexPageCommitmentARB)) GetProcAddress(cast(*u8) "glTexPageCommitmentARB\0");
    procs.glTexBufferARB = cast(type_of(procs.glTexBufferARB)) GetProcAddress(cast(*u8) "glTexBufferARB\0");
    procs.glCompressedTexImage3DARB = cast(type_of(procs.glCompressedTexImage3DARB)) GetProcAddress(cast(*u8) "glCompressedTexImage3DARB\0");
    procs.glCompressedTexImage2DARB = cast(type_of(procs.glCompressedTexImage2DARB)) GetProcAddress(cast(*u8) "glCompressedTexImage2DARB\0");
    procs.glCompressedTexImage1DARB = cast(type_of(procs.glCompressedTexImage1DARB)) GetProcAddress(cast(*u8) "glCompressedTexImage1DARB\0");
    procs.glCompressedTexSubImage3DARB = cast(type_of(procs.glCompressedTexSubImage3DARB)) GetProcAddress(cast(*u8) "glCompressedTexSubImage3DARB\0");
    procs.glCompressedTexSubImage2DARB = cast(type_of(procs.glCompressedTexSubImage2DARB)) GetProcAddress(cast(*u8) "glCompressedTexSubImage2DARB\0");
    procs.glCompressedTexSubImage1DARB = cast(type_of(procs.glCompressedTexSubImage1DARB)) GetProcAddress(cast(*u8) "glCompressedTexSubImage1DARB\0");
    procs.glGetCompressedTexImageARB = cast(type_of(procs.glGetCompressedTexImageARB)) GetProcAddress(cast(*u8) "glGetCompressedTexImageARB\0");
    procs.glLoadTransposeMatrixfARB = cast(type_of(procs.glLoadTransposeMatrixfARB)) GetProcAddress(cast(*u8) "glLoadTransposeMatrixfARB\0");
    procs.glLoadTransposeMatrixdARB = cast(type_of(procs.glLoadTransposeMatrixdARB)) GetProcAddress(cast(*u8) "glLoadTransposeMatrixdARB\0");
    procs.glMultTransposeMatrixfARB = cast(type_of(procs.glMultTransposeMatrixfARB)) GetProcAddress(cast(*u8) "glMultTransposeMatrixfARB\0");
    procs.glMultTransposeMatrixdARB = cast(type_of(procs.glMultTransposeMatrixdARB)) GetProcAddress(cast(*u8) "glMultTransposeMatrixdARB\0");
    procs.glWeightbvARB = cast(type_of(procs.glWeightbvARB)) GetProcAddress(cast(*u8) "glWeightbvARB\0");
    procs.glWeightsvARB = cast(type_of(procs.glWeightsvARB)) GetProcAddress(cast(*u8) "glWeightsvARB\0");
    procs.glWeightivARB = cast(type_of(procs.glWeightivARB)) GetProcAddress(cast(*u8) "glWeightivARB\0");
    procs.glWeightfvARB = cast(type_of(procs.glWeightfvARB)) GetProcAddress(cast(*u8) "glWeightfvARB\0");
    procs.glWeightdvARB = cast(type_of(procs.glWeightdvARB)) GetProcAddress(cast(*u8) "glWeightdvARB\0");
    procs.glWeightubvARB = cast(type_of(procs.glWeightubvARB)) GetProcAddress(cast(*u8) "glWeightubvARB\0");
    procs.glWeightusvARB = cast(type_of(procs.glWeightusvARB)) GetProcAddress(cast(*u8) "glWeightusvARB\0");
    procs.glWeightuivARB = cast(type_of(procs.glWeightuivARB)) GetProcAddress(cast(*u8) "glWeightuivARB\0");
    procs.glWeightPointerARB = cast(type_of(procs.glWeightPointerARB)) GetProcAddress(cast(*u8) "glWeightPointerARB\0");
    procs.glVertexBlendARB = cast(type_of(procs.glVertexBlendARB)) GetProcAddress(cast(*u8) "glVertexBlendARB\0");
    procs.glBindBufferARB = cast(type_of(procs.glBindBufferARB)) GetProcAddress(cast(*u8) "glBindBufferARB\0");
    procs.glDeleteBuffersARB = cast(type_of(procs.glDeleteBuffersARB)) GetProcAddress(cast(*u8) "glDeleteBuffersARB\0");
    procs.glGenBuffersARB = cast(type_of(procs.glGenBuffersARB)) GetProcAddress(cast(*u8) "glGenBuffersARB\0");
    procs.glIsBufferARB = cast(type_of(procs.glIsBufferARB)) GetProcAddress(cast(*u8) "glIsBufferARB\0");
    procs.glBufferDataARB = cast(type_of(procs.glBufferDataARB)) GetProcAddress(cast(*u8) "glBufferDataARB\0");
    procs.glBufferSubDataARB = cast(type_of(procs.glBufferSubDataARB)) GetProcAddress(cast(*u8) "glBufferSubDataARB\0");
    procs.glGetBufferSubDataARB = cast(type_of(procs.glGetBufferSubDataARB)) GetProcAddress(cast(*u8) "glGetBufferSubDataARB\0");
    procs.glMapBufferARB = cast(type_of(procs.glMapBufferARB)) GetProcAddress(cast(*u8) "glMapBufferARB\0");
    procs.glUnmapBufferARB = cast(type_of(procs.glUnmapBufferARB)) GetProcAddress(cast(*u8) "glUnmapBufferARB\0");
    procs.glGetBufferParameterivARB = cast(type_of(procs.glGetBufferParameterivARB)) GetProcAddress(cast(*u8) "glGetBufferParameterivARB\0");
    procs.glGetBufferPointervARB = cast(type_of(procs.glGetBufferPointervARB)) GetProcAddress(cast(*u8) "glGetBufferPointervARB\0");
    procs.glVertexAttrib1dARB = cast(type_of(procs.glVertexAttrib1dARB)) GetProcAddress(cast(*u8) "glVertexAttrib1dARB\0");
    procs.glVertexAttrib1dvARB = cast(type_of(procs.glVertexAttrib1dvARB)) GetProcAddress(cast(*u8) "glVertexAttrib1dvARB\0");
    procs.glVertexAttrib1fARB = cast(type_of(procs.glVertexAttrib1fARB)) GetProcAddress(cast(*u8) "glVertexAttrib1fARB\0");
    procs.glVertexAttrib1fvARB = cast(type_of(procs.glVertexAttrib1fvARB)) GetProcAddress(cast(*u8) "glVertexAttrib1fvARB\0");
    procs.glVertexAttrib1sARB = cast(type_of(procs.glVertexAttrib1sARB)) GetProcAddress(cast(*u8) "glVertexAttrib1sARB\0");
    procs.glVertexAttrib1svARB = cast(type_of(procs.glVertexAttrib1svARB)) GetProcAddress(cast(*u8) "glVertexAttrib1svARB\0");
    procs.glVertexAttrib2dARB = cast(type_of(procs.glVertexAttrib2dARB)) GetProcAddress(cast(*u8) "glVertexAttrib2dARB\0");
    procs.glVertexAttrib2dvARB = cast(type_of(procs.glVertexAttrib2dvARB)) GetProcAddress(cast(*u8) "glVertexAttrib2dvARB\0");
    procs.glVertexAttrib2fARB = cast(type_of(procs.glVertexAttrib2fARB)) GetProcAddress(cast(*u8) "glVertexAttrib2fARB\0");
    procs.glVertexAttrib2fvARB = cast(type_of(procs.glVertexAttrib2fvARB)) GetProcAddress(cast(*u8) "glVertexAttrib2fvARB\0");
    procs.glVertexAttrib2sARB = cast(type_of(procs.glVertexAttrib2sARB)) GetProcAddress(cast(*u8) "glVertexAttrib2sARB\0");
    procs.glVertexAttrib2svARB = cast(type_of(procs.glVertexAttrib2svARB)) GetProcAddress(cast(*u8) "glVertexAttrib2svARB\0");
    procs.glVertexAttrib3dARB = cast(type_of(procs.glVertexAttrib3dARB)) GetProcAddress(cast(*u8) "glVertexAttrib3dARB\0");
    procs.glVertexAttrib3dvARB = cast(type_of(procs.glVertexAttrib3dvARB)) GetProcAddress(cast(*u8) "glVertexAttrib3dvARB\0");
    procs.glVertexAttrib3fARB = cast(type_of(procs.glVertexAttrib3fARB)) GetProcAddress(cast(*u8) "glVertexAttrib3fARB\0");
    procs.glVertexAttrib3fvARB = cast(type_of(procs.glVertexAttrib3fvARB)) GetProcAddress(cast(*u8) "glVertexAttrib3fvARB\0");
    procs.glVertexAttrib3sARB = cast(type_of(procs.glVertexAttrib3sARB)) GetProcAddress(cast(*u8) "glVertexAttrib3sARB\0");
    procs.glVertexAttrib3svARB = cast(type_of(procs.glVertexAttrib3svARB)) GetProcAddress(cast(*u8) "glVertexAttrib3svARB\0");
    procs.glVertexAttrib4NbvARB = cast(type_of(procs.glVertexAttrib4NbvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NbvARB\0");
    procs.glVertexAttrib4NivARB = cast(type_of(procs.glVertexAttrib4NivARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NivARB\0");
    procs.glVertexAttrib4NsvARB = cast(type_of(procs.glVertexAttrib4NsvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NsvARB\0");
    procs.glVertexAttrib4NubARB = cast(type_of(procs.glVertexAttrib4NubARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NubARB\0");
    procs.glVertexAttrib4NubvARB = cast(type_of(procs.glVertexAttrib4NubvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NubvARB\0");
    procs.glVertexAttrib4NuivARB = cast(type_of(procs.glVertexAttrib4NuivARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NuivARB\0");
    procs.glVertexAttrib4NusvARB = cast(type_of(procs.glVertexAttrib4NusvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4NusvARB\0");
    procs.glVertexAttrib4bvARB = cast(type_of(procs.glVertexAttrib4bvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4bvARB\0");
    procs.glVertexAttrib4dARB = cast(type_of(procs.glVertexAttrib4dARB)) GetProcAddress(cast(*u8) "glVertexAttrib4dARB\0");
    procs.glVertexAttrib4dvARB = cast(type_of(procs.glVertexAttrib4dvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4dvARB\0");
    procs.glVertexAttrib4fARB = cast(type_of(procs.glVertexAttrib4fARB)) GetProcAddress(cast(*u8) "glVertexAttrib4fARB\0");
    procs.glVertexAttrib4fvARB = cast(type_of(procs.glVertexAttrib4fvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4fvARB\0");
    procs.glVertexAttrib4ivARB = cast(type_of(procs.glVertexAttrib4ivARB)) GetProcAddress(cast(*u8) "glVertexAttrib4ivARB\0");
    procs.glVertexAttrib4sARB = cast(type_of(procs.glVertexAttrib4sARB)) GetProcAddress(cast(*u8) "glVertexAttrib4sARB\0");
    procs.glVertexAttrib4svARB = cast(type_of(procs.glVertexAttrib4svARB)) GetProcAddress(cast(*u8) "glVertexAttrib4svARB\0");
    procs.glVertexAttrib4ubvARB = cast(type_of(procs.glVertexAttrib4ubvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4ubvARB\0");
    procs.glVertexAttrib4uivARB = cast(type_of(procs.glVertexAttrib4uivARB)) GetProcAddress(cast(*u8) "glVertexAttrib4uivARB\0");
    procs.glVertexAttrib4usvARB = cast(type_of(procs.glVertexAttrib4usvARB)) GetProcAddress(cast(*u8) "glVertexAttrib4usvARB\0");
    procs.glVertexAttribPointerARB = cast(type_of(procs.glVertexAttribPointerARB)) GetProcAddress(cast(*u8) "glVertexAttribPointerARB\0");
    procs.glEnableVertexAttribArrayARB = cast(type_of(procs.glEnableVertexAttribArrayARB)) GetProcAddress(cast(*u8) "glEnableVertexAttribArrayARB\0");
    procs.glDisableVertexAttribArrayARB = cast(type_of(procs.glDisableVertexAttribArrayARB)) GetProcAddress(cast(*u8) "glDisableVertexAttribArrayARB\0");
    procs.glGetVertexAttribdvARB = cast(type_of(procs.glGetVertexAttribdvARB)) GetProcAddress(cast(*u8) "glGetVertexAttribdvARB\0");
    procs.glGetVertexAttribfvARB = cast(type_of(procs.glGetVertexAttribfvARB)) GetProcAddress(cast(*u8) "glGetVertexAttribfvARB\0");
    procs.glGetVertexAttribivARB = cast(type_of(procs.glGetVertexAttribivARB)) GetProcAddress(cast(*u8) "glGetVertexAttribivARB\0");
    procs.glGetVertexAttribPointervARB = cast(type_of(procs.glGetVertexAttribPointervARB)) GetProcAddress(cast(*u8) "glGetVertexAttribPointervARB\0");
    procs.glBindAttribLocationARB = cast(type_of(procs.glBindAttribLocationARB)) GetProcAddress(cast(*u8) "glBindAttribLocationARB\0");
    procs.glGetActiveAttribARB = cast(type_of(procs.glGetActiveAttribARB)) GetProcAddress(cast(*u8) "glGetActiveAttribARB\0");
    procs.glGetAttribLocationARB = cast(type_of(procs.glGetAttribLocationARB)) GetProcAddress(cast(*u8) "glGetAttribLocationARB\0");
    procs.glWindowPos2dARB = cast(type_of(procs.glWindowPos2dARB)) GetProcAddress(cast(*u8) "glWindowPos2dARB\0");
    procs.glWindowPos2dvARB = cast(type_of(procs.glWindowPos2dvARB)) GetProcAddress(cast(*u8) "glWindowPos2dvARB\0");
    procs.glWindowPos2fARB = cast(type_of(procs.glWindowPos2fARB)) GetProcAddress(cast(*u8) "glWindowPos2fARB\0");
    procs.glWindowPos2fvARB = cast(type_of(procs.glWindowPos2fvARB)) GetProcAddress(cast(*u8) "glWindowPos2fvARB\0");
    procs.glWindowPos2iARB = cast(type_of(procs.glWindowPos2iARB)) GetProcAddress(cast(*u8) "glWindowPos2iARB\0");
    procs.glWindowPos2ivARB = cast(type_of(procs.glWindowPos2ivARB)) GetProcAddress(cast(*u8) "glWindowPos2ivARB\0");
    procs.glWindowPos2sARB = cast(type_of(procs.glWindowPos2sARB)) GetProcAddress(cast(*u8) "glWindowPos2sARB\0");
    procs.glWindowPos2svARB = cast(type_of(procs.glWindowPos2svARB)) GetProcAddress(cast(*u8) "glWindowPos2svARB\0");
    procs.glWindowPos3dARB = cast(type_of(procs.glWindowPos3dARB)) GetProcAddress(cast(*u8) "glWindowPos3dARB\0");
    procs.glWindowPos3dvARB = cast(type_of(procs.glWindowPos3dvARB)) GetProcAddress(cast(*u8) "glWindowPos3dvARB\0");
    procs.glWindowPos3fARB = cast(type_of(procs.glWindowPos3fARB)) GetProcAddress(cast(*u8) "glWindowPos3fARB\0");
    procs.glWindowPos3fvARB = cast(type_of(procs.glWindowPos3fvARB)) GetProcAddress(cast(*u8) "glWindowPos3fvARB\0");
    procs.glWindowPos3iARB = cast(type_of(procs.glWindowPos3iARB)) GetProcAddress(cast(*u8) "glWindowPos3iARB\0");
    procs.glWindowPos3ivARB = cast(type_of(procs.glWindowPos3ivARB)) GetProcAddress(cast(*u8) "glWindowPos3ivARB\0");
    procs.glWindowPos3sARB = cast(type_of(procs.glWindowPos3sARB)) GetProcAddress(cast(*u8) "glWindowPos3sARB\0");
    procs.glWindowPos3svARB = cast(type_of(procs.glWindowPos3svARB)) GetProcAddress(cast(*u8) "glWindowPos3svARB\0");
    procs.glDrawBuffersATI = cast(type_of(procs.glDrawBuffersATI)) GetProcAddress(cast(*u8) "glDrawBuffersATI\0");
    procs.glElementPointerATI = cast(type_of(procs.glElementPointerATI)) GetProcAddress(cast(*u8) "glElementPointerATI\0");
    procs.glDrawElementArrayATI = cast(type_of(procs.glDrawElementArrayATI)) GetProcAddress(cast(*u8) "glDrawElementArrayATI\0");
    procs.glDrawRangeElementArrayATI = cast(type_of(procs.glDrawRangeElementArrayATI)) GetProcAddress(cast(*u8) "glDrawRangeElementArrayATI\0");
    procs.glTexBumpParameterivATI = cast(type_of(procs.glTexBumpParameterivATI)) GetProcAddress(cast(*u8) "glTexBumpParameterivATI\0");
    procs.glTexBumpParameterfvATI = cast(type_of(procs.glTexBumpParameterfvATI)) GetProcAddress(cast(*u8) "glTexBumpParameterfvATI\0");
    procs.glGetTexBumpParameterivATI = cast(type_of(procs.glGetTexBumpParameterivATI)) GetProcAddress(cast(*u8) "glGetTexBumpParameterivATI\0");
    procs.glGetTexBumpParameterfvATI = cast(type_of(procs.glGetTexBumpParameterfvATI)) GetProcAddress(cast(*u8) "glGetTexBumpParameterfvATI\0");
    procs.glGenFragmentShadersATI = cast(type_of(procs.glGenFragmentShadersATI)) GetProcAddress(cast(*u8) "glGenFragmentShadersATI\0");
    procs.glBindFragmentShaderATI = cast(type_of(procs.glBindFragmentShaderATI)) GetProcAddress(cast(*u8) "glBindFragmentShaderATI\0");
    procs.glDeleteFragmentShaderATI = cast(type_of(procs.glDeleteFragmentShaderATI)) GetProcAddress(cast(*u8) "glDeleteFragmentShaderATI\0");
    procs.glBeginFragmentShaderATI = cast(type_of(procs.glBeginFragmentShaderATI)) GetProcAddress(cast(*u8) "glBeginFragmentShaderATI\0");
    procs.glEndFragmentShaderATI = cast(type_of(procs.glEndFragmentShaderATI)) GetProcAddress(cast(*u8) "glEndFragmentShaderATI\0");
    procs.glPassTexCoordATI = cast(type_of(procs.glPassTexCoordATI)) GetProcAddress(cast(*u8) "glPassTexCoordATI\0");
    procs.glSampleMapATI = cast(type_of(procs.glSampleMapATI)) GetProcAddress(cast(*u8) "glSampleMapATI\0");
    procs.glColorFragmentOp1ATI = cast(type_of(procs.glColorFragmentOp1ATI)) GetProcAddress(cast(*u8) "glColorFragmentOp1ATI\0");
    procs.glColorFragmentOp2ATI = cast(type_of(procs.glColorFragmentOp2ATI)) GetProcAddress(cast(*u8) "glColorFragmentOp2ATI\0");
    procs.glColorFragmentOp3ATI = cast(type_of(procs.glColorFragmentOp3ATI)) GetProcAddress(cast(*u8) "glColorFragmentOp3ATI\0");
    procs.glAlphaFragmentOp1ATI = cast(type_of(procs.glAlphaFragmentOp1ATI)) GetProcAddress(cast(*u8) "glAlphaFragmentOp1ATI\0");
    procs.glAlphaFragmentOp2ATI = cast(type_of(procs.glAlphaFragmentOp2ATI)) GetProcAddress(cast(*u8) "glAlphaFragmentOp2ATI\0");
    procs.glAlphaFragmentOp3ATI = cast(type_of(procs.glAlphaFragmentOp3ATI)) GetProcAddress(cast(*u8) "glAlphaFragmentOp3ATI\0");
    procs.glSetFragmentShaderConstantATI = cast(type_of(procs.glSetFragmentShaderConstantATI)) GetProcAddress(cast(*u8) "glSetFragmentShaderConstantATI\0");
    procs.glMapObjectBufferATI = cast(type_of(procs.glMapObjectBufferATI)) GetProcAddress(cast(*u8) "glMapObjectBufferATI\0");
    procs.glUnmapObjectBufferATI = cast(type_of(procs.glUnmapObjectBufferATI)) GetProcAddress(cast(*u8) "glUnmapObjectBufferATI\0");
    procs.glPNTrianglesiATI = cast(type_of(procs.glPNTrianglesiATI)) GetProcAddress(cast(*u8) "glPNTrianglesiATI\0");
    procs.glPNTrianglesfATI = cast(type_of(procs.glPNTrianglesfATI)) GetProcAddress(cast(*u8) "glPNTrianglesfATI\0");
    procs.glStencilOpSeparateATI = cast(type_of(procs.glStencilOpSeparateATI)) GetProcAddress(cast(*u8) "glStencilOpSeparateATI\0");
    procs.glStencilFuncSeparateATI = cast(type_of(procs.glStencilFuncSeparateATI)) GetProcAddress(cast(*u8) "glStencilFuncSeparateATI\0");
    procs.glNewObjectBufferATI = cast(type_of(procs.glNewObjectBufferATI)) GetProcAddress(cast(*u8) "glNewObjectBufferATI\0");
    procs.glIsObjectBufferATI = cast(type_of(procs.glIsObjectBufferATI)) GetProcAddress(cast(*u8) "glIsObjectBufferATI\0");
    procs.glUpdateObjectBufferATI = cast(type_of(procs.glUpdateObjectBufferATI)) GetProcAddress(cast(*u8) "glUpdateObjectBufferATI\0");
    procs.glGetObjectBufferfvATI = cast(type_of(procs.glGetObjectBufferfvATI)) GetProcAddress(cast(*u8) "glGetObjectBufferfvATI\0");
    procs.glGetObjectBufferivATI = cast(type_of(procs.glGetObjectBufferivATI)) GetProcAddress(cast(*u8) "glGetObjectBufferivATI\0");
    procs.glFreeObjectBufferATI = cast(type_of(procs.glFreeObjectBufferATI)) GetProcAddress(cast(*u8) "glFreeObjectBufferATI\0");
    procs.glArrayObjectATI = cast(type_of(procs.glArrayObjectATI)) GetProcAddress(cast(*u8) "glArrayObjectATI\0");
    procs.glGetArrayObjectfvATI = cast(type_of(procs.glGetArrayObjectfvATI)) GetProcAddress(cast(*u8) "glGetArrayObjectfvATI\0");
    procs.glGetArrayObjectivATI = cast(type_of(procs.glGetArrayObjectivATI)) GetProcAddress(cast(*u8) "glGetArrayObjectivATI\0");
    procs.glVariantArrayObjectATI = cast(type_of(procs.glVariantArrayObjectATI)) GetProcAddress(cast(*u8) "glVariantArrayObjectATI\0");
    procs.glGetVariantArrayObjectfvATI = cast(type_of(procs.glGetVariantArrayObjectfvATI)) GetProcAddress(cast(*u8) "glGetVariantArrayObjectfvATI\0");
    procs.glGetVariantArrayObjectivATI = cast(type_of(procs.glGetVariantArrayObjectivATI)) GetProcAddress(cast(*u8) "glGetVariantArrayObjectivATI\0");
    procs.glVertexAttribArrayObjectATI = cast(type_of(procs.glVertexAttribArrayObjectATI)) GetProcAddress(cast(*u8) "glVertexAttribArrayObjectATI\0");
    procs.glGetVertexAttribArrayObjectfvATI = cast(type_of(procs.glGetVertexAttribArrayObjectfvATI)) GetProcAddress(cast(*u8) "glGetVertexAttribArrayObjectfvATI\0");
    procs.glGetVertexAttribArrayObjectivATI = cast(type_of(procs.glGetVertexAttribArrayObjectivATI)) GetProcAddress(cast(*u8) "glGetVertexAttribArrayObjectivATI\0");
    procs.glVertexStream1sATI = cast(type_of(procs.glVertexStream1sATI)) GetProcAddress(cast(*u8) "glVertexStream1sATI\0");
    procs.glVertexStream1svATI = cast(type_of(procs.glVertexStream1svATI)) GetProcAddress(cast(*u8) "glVertexStream1svATI\0");
    procs.glVertexStream1iATI = cast(type_of(procs.glVertexStream1iATI)) GetProcAddress(cast(*u8) "glVertexStream1iATI\0");
    procs.glVertexStream1ivATI = cast(type_of(procs.glVertexStream1ivATI)) GetProcAddress(cast(*u8) "glVertexStream1ivATI\0");
    procs.glVertexStream1fATI = cast(type_of(procs.glVertexStream1fATI)) GetProcAddress(cast(*u8) "glVertexStream1fATI\0");
    procs.glVertexStream1fvATI = cast(type_of(procs.glVertexStream1fvATI)) GetProcAddress(cast(*u8) "glVertexStream1fvATI\0");
    procs.glVertexStream1dATI = cast(type_of(procs.glVertexStream1dATI)) GetProcAddress(cast(*u8) "glVertexStream1dATI\0");
    procs.glVertexStream1dvATI = cast(type_of(procs.glVertexStream1dvATI)) GetProcAddress(cast(*u8) "glVertexStream1dvATI\0");
    procs.glVertexStream2sATI = cast(type_of(procs.glVertexStream2sATI)) GetProcAddress(cast(*u8) "glVertexStream2sATI\0");
    procs.glVertexStream2svATI = cast(type_of(procs.glVertexStream2svATI)) GetProcAddress(cast(*u8) "glVertexStream2svATI\0");
    procs.glVertexStream2iATI = cast(type_of(procs.glVertexStream2iATI)) GetProcAddress(cast(*u8) "glVertexStream2iATI\0");
    procs.glVertexStream2ivATI = cast(type_of(procs.glVertexStream2ivATI)) GetProcAddress(cast(*u8) "glVertexStream2ivATI\0");
    procs.glVertexStream2fATI = cast(type_of(procs.glVertexStream2fATI)) GetProcAddress(cast(*u8) "glVertexStream2fATI\0");
    procs.glVertexStream2fvATI = cast(type_of(procs.glVertexStream2fvATI)) GetProcAddress(cast(*u8) "glVertexStream2fvATI\0");
    procs.glVertexStream2dATI = cast(type_of(procs.glVertexStream2dATI)) GetProcAddress(cast(*u8) "glVertexStream2dATI\0");
    procs.glVertexStream2dvATI = cast(type_of(procs.glVertexStream2dvATI)) GetProcAddress(cast(*u8) "glVertexStream2dvATI\0");
    procs.glVertexStream3sATI = cast(type_of(procs.glVertexStream3sATI)) GetProcAddress(cast(*u8) "glVertexStream3sATI\0");
    procs.glVertexStream3svATI = cast(type_of(procs.glVertexStream3svATI)) GetProcAddress(cast(*u8) "glVertexStream3svATI\0");
    procs.glVertexStream3iATI = cast(type_of(procs.glVertexStream3iATI)) GetProcAddress(cast(*u8) "glVertexStream3iATI\0");
    procs.glVertexStream3ivATI = cast(type_of(procs.glVertexStream3ivATI)) GetProcAddress(cast(*u8) "glVertexStream3ivATI\0");
    procs.glVertexStream3fATI = cast(type_of(procs.glVertexStream3fATI)) GetProcAddress(cast(*u8) "glVertexStream3fATI\0");
    procs.glVertexStream3fvATI = cast(type_of(procs.glVertexStream3fvATI)) GetProcAddress(cast(*u8) "glVertexStream3fvATI\0");
    procs.glVertexStream3dATI = cast(type_of(procs.glVertexStream3dATI)) GetProcAddress(cast(*u8) "glVertexStream3dATI\0");
    procs.glVertexStream3dvATI = cast(type_of(procs.glVertexStream3dvATI)) GetProcAddress(cast(*u8) "glVertexStream3dvATI\0");
    procs.glVertexStream4sATI = cast(type_of(procs.glVertexStream4sATI)) GetProcAddress(cast(*u8) "glVertexStream4sATI\0");
    procs.glVertexStream4svATI = cast(type_of(procs.glVertexStream4svATI)) GetProcAddress(cast(*u8) "glVertexStream4svATI\0");
    procs.glVertexStream4iATI = cast(type_of(procs.glVertexStream4iATI)) GetProcAddress(cast(*u8) "glVertexStream4iATI\0");
    procs.glVertexStream4ivATI = cast(type_of(procs.glVertexStream4ivATI)) GetProcAddress(cast(*u8) "glVertexStream4ivATI\0");
    procs.glVertexStream4fATI = cast(type_of(procs.glVertexStream4fATI)) GetProcAddress(cast(*u8) "glVertexStream4fATI\0");
    procs.glVertexStream4fvATI = cast(type_of(procs.glVertexStream4fvATI)) GetProcAddress(cast(*u8) "glVertexStream4fvATI\0");
    procs.glVertexStream4dATI = cast(type_of(procs.glVertexStream4dATI)) GetProcAddress(cast(*u8) "glVertexStream4dATI\0");
    procs.glVertexStream4dvATI = cast(type_of(procs.glVertexStream4dvATI)) GetProcAddress(cast(*u8) "glVertexStream4dvATI\0");
    procs.glNormalStream3bATI = cast(type_of(procs.glNormalStream3bATI)) GetProcAddress(cast(*u8) "glNormalStream3bATI\0");
    procs.glNormalStream3bvATI = cast(type_of(procs.glNormalStream3bvATI)) GetProcAddress(cast(*u8) "glNormalStream3bvATI\0");
    procs.glNormalStream3sATI = cast(type_of(procs.glNormalStream3sATI)) GetProcAddress(cast(*u8) "glNormalStream3sATI\0");
    procs.glNormalStream3svATI = cast(type_of(procs.glNormalStream3svATI)) GetProcAddress(cast(*u8) "glNormalStream3svATI\0");
    procs.glNormalStream3iATI = cast(type_of(procs.glNormalStream3iATI)) GetProcAddress(cast(*u8) "glNormalStream3iATI\0");
    procs.glNormalStream3ivATI = cast(type_of(procs.glNormalStream3ivATI)) GetProcAddress(cast(*u8) "glNormalStream3ivATI\0");
    procs.glNormalStream3fATI = cast(type_of(procs.glNormalStream3fATI)) GetProcAddress(cast(*u8) "glNormalStream3fATI\0");
    procs.glNormalStream3fvATI = cast(type_of(procs.glNormalStream3fvATI)) GetProcAddress(cast(*u8) "glNormalStream3fvATI\0");
    procs.glNormalStream3dATI = cast(type_of(procs.glNormalStream3dATI)) GetProcAddress(cast(*u8) "glNormalStream3dATI\0");
    procs.glNormalStream3dvATI = cast(type_of(procs.glNormalStream3dvATI)) GetProcAddress(cast(*u8) "glNormalStream3dvATI\0");
    procs.glClientActiveVertexStreamATI = cast(type_of(procs.glClientActiveVertexStreamATI)) GetProcAddress(cast(*u8) "glClientActiveVertexStreamATI\0");
    procs.glVertexBlendEnviATI = cast(type_of(procs.glVertexBlendEnviATI)) GetProcAddress(cast(*u8) "glVertexBlendEnviATI\0");
    procs.glVertexBlendEnvfATI = cast(type_of(procs.glVertexBlendEnvfATI)) GetProcAddress(cast(*u8) "glVertexBlendEnvfATI\0");
    procs.glUniformBufferEXT = cast(type_of(procs.glUniformBufferEXT)) GetProcAddress(cast(*u8) "glUniformBufferEXT\0");
    procs.glGetUniformBufferSizeEXT = cast(type_of(procs.glGetUniformBufferSizeEXT)) GetProcAddress(cast(*u8) "glGetUniformBufferSizeEXT\0");
    procs.glGetUniformOffsetEXT = cast(type_of(procs.glGetUniformOffsetEXT)) GetProcAddress(cast(*u8) "glGetUniformOffsetEXT\0");
    procs.glBlendColorEXT = cast(type_of(procs.glBlendColorEXT)) GetProcAddress(cast(*u8) "glBlendColorEXT\0");
    procs.glBlendEquationSeparateEXT = cast(type_of(procs.glBlendEquationSeparateEXT)) GetProcAddress(cast(*u8) "glBlendEquationSeparateEXT\0");
    procs.glBlendFuncSeparateEXT = cast(type_of(procs.glBlendFuncSeparateEXT)) GetProcAddress(cast(*u8) "glBlendFuncSeparateEXT\0");
    procs.glBlendEquationEXT = cast(type_of(procs.glBlendEquationEXT)) GetProcAddress(cast(*u8) "glBlendEquationEXT\0");
    procs.glColorSubTableEXT = cast(type_of(procs.glColorSubTableEXT)) GetProcAddress(cast(*u8) "glColorSubTableEXT\0");
    procs.glCopyColorSubTableEXT = cast(type_of(procs.glCopyColorSubTableEXT)) GetProcAddress(cast(*u8) "glCopyColorSubTableEXT\0");
    procs.glLockArraysEXT = cast(type_of(procs.glLockArraysEXT)) GetProcAddress(cast(*u8) "glLockArraysEXT\0");
    procs.glUnlockArraysEXT = cast(type_of(procs.glUnlockArraysEXT)) GetProcAddress(cast(*u8) "glUnlockArraysEXT\0");
    procs.glConvolutionFilter1DEXT = cast(type_of(procs.glConvolutionFilter1DEXT)) GetProcAddress(cast(*u8) "glConvolutionFilter1DEXT\0");
    procs.glConvolutionFilter2DEXT = cast(type_of(procs.glConvolutionFilter2DEXT)) GetProcAddress(cast(*u8) "glConvolutionFilter2DEXT\0");
    procs.glConvolutionParameterfEXT = cast(type_of(procs.glConvolutionParameterfEXT)) GetProcAddress(cast(*u8) "glConvolutionParameterfEXT\0");
    procs.glConvolutionParameterfvEXT = cast(type_of(procs.glConvolutionParameterfvEXT)) GetProcAddress(cast(*u8) "glConvolutionParameterfvEXT\0");
    procs.glConvolutionParameteriEXT = cast(type_of(procs.glConvolutionParameteriEXT)) GetProcAddress(cast(*u8) "glConvolutionParameteriEXT\0");
    procs.glConvolutionParameterivEXT = cast(type_of(procs.glConvolutionParameterivEXT)) GetProcAddress(cast(*u8) "glConvolutionParameterivEXT\0");
    procs.glCopyConvolutionFilter1DEXT = cast(type_of(procs.glCopyConvolutionFilter1DEXT)) GetProcAddress(cast(*u8) "glCopyConvolutionFilter1DEXT\0");
    procs.glCopyConvolutionFilter2DEXT = cast(type_of(procs.glCopyConvolutionFilter2DEXT)) GetProcAddress(cast(*u8) "glCopyConvolutionFilter2DEXT\0");
    procs.glGetConvolutionFilterEXT = cast(type_of(procs.glGetConvolutionFilterEXT)) GetProcAddress(cast(*u8) "glGetConvolutionFilterEXT\0");
    procs.glGetConvolutionParameterfvEXT = cast(type_of(procs.glGetConvolutionParameterfvEXT)) GetProcAddress(cast(*u8) "glGetConvolutionParameterfvEXT\0");
    procs.glGetConvolutionParameterivEXT = cast(type_of(procs.glGetConvolutionParameterivEXT)) GetProcAddress(cast(*u8) "glGetConvolutionParameterivEXT\0");
    procs.glGetSeparableFilterEXT = cast(type_of(procs.glGetSeparableFilterEXT)) GetProcAddress(cast(*u8) "glGetSeparableFilterEXT\0");
    procs.glSeparableFilter2DEXT = cast(type_of(procs.glSeparableFilter2DEXT)) GetProcAddress(cast(*u8) "glSeparableFilter2DEXT\0");
    procs.glTangent3bEXT = cast(type_of(procs.glTangent3bEXT)) GetProcAddress(cast(*u8) "glTangent3bEXT\0");
    procs.glTangent3bvEXT = cast(type_of(procs.glTangent3bvEXT)) GetProcAddress(cast(*u8) "glTangent3bvEXT\0");
    procs.glTangent3dEXT = cast(type_of(procs.glTangent3dEXT)) GetProcAddress(cast(*u8) "glTangent3dEXT\0");
    procs.glTangent3dvEXT = cast(type_of(procs.glTangent3dvEXT)) GetProcAddress(cast(*u8) "glTangent3dvEXT\0");
    procs.glTangent3fEXT = cast(type_of(procs.glTangent3fEXT)) GetProcAddress(cast(*u8) "glTangent3fEXT\0");
    procs.glTangent3fvEXT = cast(type_of(procs.glTangent3fvEXT)) GetProcAddress(cast(*u8) "glTangent3fvEXT\0");
    procs.glTangent3iEXT = cast(type_of(procs.glTangent3iEXT)) GetProcAddress(cast(*u8) "glTangent3iEXT\0");
    procs.glTangent3ivEXT = cast(type_of(procs.glTangent3ivEXT)) GetProcAddress(cast(*u8) "glTangent3ivEXT\0");
    procs.glTangent3sEXT = cast(type_of(procs.glTangent3sEXT)) GetProcAddress(cast(*u8) "glTangent3sEXT\0");
    procs.glTangent3svEXT = cast(type_of(procs.glTangent3svEXT)) GetProcAddress(cast(*u8) "glTangent3svEXT\0");
    procs.glBinormal3bEXT = cast(type_of(procs.glBinormal3bEXT)) GetProcAddress(cast(*u8) "glBinormal3bEXT\0");
    procs.glBinormal3bvEXT = cast(type_of(procs.glBinormal3bvEXT)) GetProcAddress(cast(*u8) "glBinormal3bvEXT\0");
    procs.glBinormal3dEXT = cast(type_of(procs.glBinormal3dEXT)) GetProcAddress(cast(*u8) "glBinormal3dEXT\0");
    procs.glBinormal3dvEXT = cast(type_of(procs.glBinormal3dvEXT)) GetProcAddress(cast(*u8) "glBinormal3dvEXT\0");
    procs.glBinormal3fEXT = cast(type_of(procs.glBinormal3fEXT)) GetProcAddress(cast(*u8) "glBinormal3fEXT\0");
    procs.glBinormal3fvEXT = cast(type_of(procs.glBinormal3fvEXT)) GetProcAddress(cast(*u8) "glBinormal3fvEXT\0");
    procs.glBinormal3iEXT = cast(type_of(procs.glBinormal3iEXT)) GetProcAddress(cast(*u8) "glBinormal3iEXT\0");
    procs.glBinormal3ivEXT = cast(type_of(procs.glBinormal3ivEXT)) GetProcAddress(cast(*u8) "glBinormal3ivEXT\0");
    procs.glBinormal3sEXT = cast(type_of(procs.glBinormal3sEXT)) GetProcAddress(cast(*u8) "glBinormal3sEXT\0");
    procs.glBinormal3svEXT = cast(type_of(procs.glBinormal3svEXT)) GetProcAddress(cast(*u8) "glBinormal3svEXT\0");
    procs.glTangentPointerEXT = cast(type_of(procs.glTangentPointerEXT)) GetProcAddress(cast(*u8) "glTangentPointerEXT\0");
    procs.glBinormalPointerEXT = cast(type_of(procs.glBinormalPointerEXT)) GetProcAddress(cast(*u8) "glBinormalPointerEXT\0");
    procs.glCopyTexImage1DEXT = cast(type_of(procs.glCopyTexImage1DEXT)) GetProcAddress(cast(*u8) "glCopyTexImage1DEXT\0");
    procs.glCopyTexImage2DEXT = cast(type_of(procs.glCopyTexImage2DEXT)) GetProcAddress(cast(*u8) "glCopyTexImage2DEXT\0");
    procs.glCopyTexSubImage1DEXT = cast(type_of(procs.glCopyTexSubImage1DEXT)) GetProcAddress(cast(*u8) "glCopyTexSubImage1DEXT\0");
    procs.glCopyTexSubImage2DEXT = cast(type_of(procs.glCopyTexSubImage2DEXT)) GetProcAddress(cast(*u8) "glCopyTexSubImage2DEXT\0");
    procs.glCopyTexSubImage3DEXT = cast(type_of(procs.glCopyTexSubImage3DEXT)) GetProcAddress(cast(*u8) "glCopyTexSubImage3DEXT\0");
    procs.glCullParameterdvEXT = cast(type_of(procs.glCullParameterdvEXT)) GetProcAddress(cast(*u8) "glCullParameterdvEXT\0");
    procs.glCullParameterfvEXT = cast(type_of(procs.glCullParameterfvEXT)) GetProcAddress(cast(*u8) "glCullParameterfvEXT\0");
    procs.glLabelObjectEXT = cast(type_of(procs.glLabelObjectEXT)) GetProcAddress(cast(*u8) "glLabelObjectEXT\0");
    procs.glGetObjectLabelEXT = cast(type_of(procs.glGetObjectLabelEXT)) GetProcAddress(cast(*u8) "glGetObjectLabelEXT\0");
    procs.glInsertEventMarkerEXT = cast(type_of(procs.glInsertEventMarkerEXT)) GetProcAddress(cast(*u8) "glInsertEventMarkerEXT\0");
    procs.glPushGroupMarkerEXT = cast(type_of(procs.glPushGroupMarkerEXT)) GetProcAddress(cast(*u8) "glPushGroupMarkerEXT\0");
    procs.glPopGroupMarkerEXT = cast(type_of(procs.glPopGroupMarkerEXT)) GetProcAddress(cast(*u8) "glPopGroupMarkerEXT\0");
    procs.glDepthBoundsEXT = cast(type_of(procs.glDepthBoundsEXT)) GetProcAddress(cast(*u8) "glDepthBoundsEXT\0");
    procs.glMatrixLoadfEXT = cast(type_of(procs.glMatrixLoadfEXT)) GetProcAddress(cast(*u8) "glMatrixLoadfEXT\0");
    procs.glMatrixLoaddEXT = cast(type_of(procs.glMatrixLoaddEXT)) GetProcAddress(cast(*u8) "glMatrixLoaddEXT\0");
    procs.glMatrixMultfEXT = cast(type_of(procs.glMatrixMultfEXT)) GetProcAddress(cast(*u8) "glMatrixMultfEXT\0");
    procs.glMatrixMultdEXT = cast(type_of(procs.glMatrixMultdEXT)) GetProcAddress(cast(*u8) "glMatrixMultdEXT\0");
    procs.glMatrixLoadIdentityEXT = cast(type_of(procs.glMatrixLoadIdentityEXT)) GetProcAddress(cast(*u8) "glMatrixLoadIdentityEXT\0");
    procs.glMatrixRotatefEXT = cast(type_of(procs.glMatrixRotatefEXT)) GetProcAddress(cast(*u8) "glMatrixRotatefEXT\0");
    procs.glMatrixRotatedEXT = cast(type_of(procs.glMatrixRotatedEXT)) GetProcAddress(cast(*u8) "glMatrixRotatedEXT\0");
    procs.glMatrixScalefEXT = cast(type_of(procs.glMatrixScalefEXT)) GetProcAddress(cast(*u8) "glMatrixScalefEXT\0");
    procs.glMatrixScaledEXT = cast(type_of(procs.glMatrixScaledEXT)) GetProcAddress(cast(*u8) "glMatrixScaledEXT\0");
    procs.glMatrixTranslatefEXT = cast(type_of(procs.glMatrixTranslatefEXT)) GetProcAddress(cast(*u8) "glMatrixTranslatefEXT\0");
    procs.glMatrixTranslatedEXT = cast(type_of(procs.glMatrixTranslatedEXT)) GetProcAddress(cast(*u8) "glMatrixTranslatedEXT\0");
    procs.glMatrixFrustumEXT = cast(type_of(procs.glMatrixFrustumEXT)) GetProcAddress(cast(*u8) "glMatrixFrustumEXT\0");
    procs.glMatrixOrthoEXT = cast(type_of(procs.glMatrixOrthoEXT)) GetProcAddress(cast(*u8) "glMatrixOrthoEXT\0");
    procs.glMatrixPopEXT = cast(type_of(procs.glMatrixPopEXT)) GetProcAddress(cast(*u8) "glMatrixPopEXT\0");
    procs.glMatrixPushEXT = cast(type_of(procs.glMatrixPushEXT)) GetProcAddress(cast(*u8) "glMatrixPushEXT\0");
    procs.glClientAttribDefaultEXT = cast(type_of(procs.glClientAttribDefaultEXT)) GetProcAddress(cast(*u8) "glClientAttribDefaultEXT\0");
    procs.glPushClientAttribDefaultEXT = cast(type_of(procs.glPushClientAttribDefaultEXT)) GetProcAddress(cast(*u8) "glPushClientAttribDefaultEXT\0");
    procs.glTextureParameterfEXT = cast(type_of(procs.glTextureParameterfEXT)) GetProcAddress(cast(*u8) "glTextureParameterfEXT\0");
    procs.glTextureParameterfvEXT = cast(type_of(procs.glTextureParameterfvEXT)) GetProcAddress(cast(*u8) "glTextureParameterfvEXT\0");
    procs.glTextureParameteriEXT = cast(type_of(procs.glTextureParameteriEXT)) GetProcAddress(cast(*u8) "glTextureParameteriEXT\0");
    procs.glTextureParameterivEXT = cast(type_of(procs.glTextureParameterivEXT)) GetProcAddress(cast(*u8) "glTextureParameterivEXT\0");
    procs.glTextureImage1DEXT = cast(type_of(procs.glTextureImage1DEXT)) GetProcAddress(cast(*u8) "glTextureImage1DEXT\0");
    procs.glTextureImage2DEXT = cast(type_of(procs.glTextureImage2DEXT)) GetProcAddress(cast(*u8) "glTextureImage2DEXT\0");
    procs.glTextureSubImage1DEXT = cast(type_of(procs.glTextureSubImage1DEXT)) GetProcAddress(cast(*u8) "glTextureSubImage1DEXT\0");
    procs.glTextureSubImage2DEXT = cast(type_of(procs.glTextureSubImage2DEXT)) GetProcAddress(cast(*u8) "glTextureSubImage2DEXT\0");
    procs.glCopyTextureImage1DEXT = cast(type_of(procs.glCopyTextureImage1DEXT)) GetProcAddress(cast(*u8) "glCopyTextureImage1DEXT\0");
    procs.glCopyTextureImage2DEXT = cast(type_of(procs.glCopyTextureImage2DEXT)) GetProcAddress(cast(*u8) "glCopyTextureImage2DEXT\0");
    procs.glCopyTextureSubImage1DEXT = cast(type_of(procs.glCopyTextureSubImage1DEXT)) GetProcAddress(cast(*u8) "glCopyTextureSubImage1DEXT\0");
    procs.glCopyTextureSubImage2DEXT = cast(type_of(procs.glCopyTextureSubImage2DEXT)) GetProcAddress(cast(*u8) "glCopyTextureSubImage2DEXT\0");
    procs.glGetTextureImageEXT = cast(type_of(procs.glGetTextureImageEXT)) GetProcAddress(cast(*u8) "glGetTextureImageEXT\0");
    procs.glGetTextureParameterfvEXT = cast(type_of(procs.glGetTextureParameterfvEXT)) GetProcAddress(cast(*u8) "glGetTextureParameterfvEXT\0");
    procs.glGetTextureParameterivEXT = cast(type_of(procs.glGetTextureParameterivEXT)) GetProcAddress(cast(*u8) "glGetTextureParameterivEXT\0");
    procs.glGetTextureLevelParameterfvEXT = cast(type_of(procs.glGetTextureLevelParameterfvEXT)) GetProcAddress(cast(*u8) "glGetTextureLevelParameterfvEXT\0");
    procs.glGetTextureLevelParameterivEXT = cast(type_of(procs.glGetTextureLevelParameterivEXT)) GetProcAddress(cast(*u8) "glGetTextureLevelParameterivEXT\0");
    procs.glTextureImage3DEXT = cast(type_of(procs.glTextureImage3DEXT)) GetProcAddress(cast(*u8) "glTextureImage3DEXT\0");
    procs.glTextureSubImage3DEXT = cast(type_of(procs.glTextureSubImage3DEXT)) GetProcAddress(cast(*u8) "glTextureSubImage3DEXT\0");
    procs.glCopyTextureSubImage3DEXT = cast(type_of(procs.glCopyTextureSubImage3DEXT)) GetProcAddress(cast(*u8) "glCopyTextureSubImage3DEXT\0");
    procs.glBindMultiTextureEXT = cast(type_of(procs.glBindMultiTextureEXT)) GetProcAddress(cast(*u8) "glBindMultiTextureEXT\0");
    procs.glMultiTexCoordPointerEXT = cast(type_of(procs.glMultiTexCoordPointerEXT)) GetProcAddress(cast(*u8) "glMultiTexCoordPointerEXT\0");
    procs.glMultiTexEnvfEXT = cast(type_of(procs.glMultiTexEnvfEXT)) GetProcAddress(cast(*u8) "glMultiTexEnvfEXT\0");
    procs.glMultiTexEnvfvEXT = cast(type_of(procs.glMultiTexEnvfvEXT)) GetProcAddress(cast(*u8) "glMultiTexEnvfvEXT\0");
    procs.glMultiTexEnviEXT = cast(type_of(procs.glMultiTexEnviEXT)) GetProcAddress(cast(*u8) "glMultiTexEnviEXT\0");
    procs.glMultiTexEnvivEXT = cast(type_of(procs.glMultiTexEnvivEXT)) GetProcAddress(cast(*u8) "glMultiTexEnvivEXT\0");
    procs.glMultiTexGendEXT = cast(type_of(procs.glMultiTexGendEXT)) GetProcAddress(cast(*u8) "glMultiTexGendEXT\0");
    procs.glMultiTexGendvEXT = cast(type_of(procs.glMultiTexGendvEXT)) GetProcAddress(cast(*u8) "glMultiTexGendvEXT\0");
    procs.glMultiTexGenfEXT = cast(type_of(procs.glMultiTexGenfEXT)) GetProcAddress(cast(*u8) "glMultiTexGenfEXT\0");
    procs.glMultiTexGenfvEXT = cast(type_of(procs.glMultiTexGenfvEXT)) GetProcAddress(cast(*u8) "glMultiTexGenfvEXT\0");
    procs.glMultiTexGeniEXT = cast(type_of(procs.glMultiTexGeniEXT)) GetProcAddress(cast(*u8) "glMultiTexGeniEXT\0");
    procs.glMultiTexGenivEXT = cast(type_of(procs.glMultiTexGenivEXT)) GetProcAddress(cast(*u8) "glMultiTexGenivEXT\0");
    procs.glGetMultiTexEnvfvEXT = cast(type_of(procs.glGetMultiTexEnvfvEXT)) GetProcAddress(cast(*u8) "glGetMultiTexEnvfvEXT\0");
    procs.glGetMultiTexEnvivEXT = cast(type_of(procs.glGetMultiTexEnvivEXT)) GetProcAddress(cast(*u8) "glGetMultiTexEnvivEXT\0");
    procs.glGetMultiTexGendvEXT = cast(type_of(procs.glGetMultiTexGendvEXT)) GetProcAddress(cast(*u8) "glGetMultiTexGendvEXT\0");
    procs.glGetMultiTexGenfvEXT = cast(type_of(procs.glGetMultiTexGenfvEXT)) GetProcAddress(cast(*u8) "glGetMultiTexGenfvEXT\0");
    procs.glGetMultiTexGenivEXT = cast(type_of(procs.glGetMultiTexGenivEXT)) GetProcAddress(cast(*u8) "glGetMultiTexGenivEXT\0");
    procs.glMultiTexParameteriEXT = cast(type_of(procs.glMultiTexParameteriEXT)) GetProcAddress(cast(*u8) "glMultiTexParameteriEXT\0");
    procs.glMultiTexParameterivEXT = cast(type_of(procs.glMultiTexParameterivEXT)) GetProcAddress(cast(*u8) "glMultiTexParameterivEXT\0");
    procs.glMultiTexParameterfEXT = cast(type_of(procs.glMultiTexParameterfEXT)) GetProcAddress(cast(*u8) "glMultiTexParameterfEXT\0");
    procs.glMultiTexParameterfvEXT = cast(type_of(procs.glMultiTexParameterfvEXT)) GetProcAddress(cast(*u8) "glMultiTexParameterfvEXT\0");
    procs.glMultiTexImage1DEXT = cast(type_of(procs.glMultiTexImage1DEXT)) GetProcAddress(cast(*u8) "glMultiTexImage1DEXT\0");
    procs.glMultiTexImage2DEXT = cast(type_of(procs.glMultiTexImage2DEXT)) GetProcAddress(cast(*u8) "glMultiTexImage2DEXT\0");
    procs.glMultiTexSubImage1DEXT = cast(type_of(procs.glMultiTexSubImage1DEXT)) GetProcAddress(cast(*u8) "glMultiTexSubImage1DEXT\0");
    procs.glMultiTexSubImage2DEXT = cast(type_of(procs.glMultiTexSubImage2DEXT)) GetProcAddress(cast(*u8) "glMultiTexSubImage2DEXT\0");
    procs.glCopyMultiTexImage1DEXT = cast(type_of(procs.glCopyMultiTexImage1DEXT)) GetProcAddress(cast(*u8) "glCopyMultiTexImage1DEXT\0");
    procs.glCopyMultiTexImage2DEXT = cast(type_of(procs.glCopyMultiTexImage2DEXT)) GetProcAddress(cast(*u8) "glCopyMultiTexImage2DEXT\0");
    procs.glCopyMultiTexSubImage1DEXT = cast(type_of(procs.glCopyMultiTexSubImage1DEXT)) GetProcAddress(cast(*u8) "glCopyMultiTexSubImage1DEXT\0");
    procs.glCopyMultiTexSubImage2DEXT = cast(type_of(procs.glCopyMultiTexSubImage2DEXT)) GetProcAddress(cast(*u8) "glCopyMultiTexSubImage2DEXT\0");
    procs.glGetMultiTexImageEXT = cast(type_of(procs.glGetMultiTexImageEXT)) GetProcAddress(cast(*u8) "glGetMultiTexImageEXT\0");
    procs.glGetMultiTexParameterfvEXT = cast(type_of(procs.glGetMultiTexParameterfvEXT)) GetProcAddress(cast(*u8) "glGetMultiTexParameterfvEXT\0");
    procs.glGetMultiTexParameterivEXT = cast(type_of(procs.glGetMultiTexParameterivEXT)) GetProcAddress(cast(*u8) "glGetMultiTexParameterivEXT\0");
    procs.glGetMultiTexLevelParameterfvEXT = cast(type_of(procs.glGetMultiTexLevelParameterfvEXT)) GetProcAddress(cast(*u8) "glGetMultiTexLevelParameterfvEXT\0");
    procs.glGetMultiTexLevelParameterivEXT = cast(type_of(procs.glGetMultiTexLevelParameterivEXT)) GetProcAddress(cast(*u8) "glGetMultiTexLevelParameterivEXT\0");
    procs.glMultiTexImage3DEXT = cast(type_of(procs.glMultiTexImage3DEXT)) GetProcAddress(cast(*u8) "glMultiTexImage3DEXT\0");
    procs.glMultiTexSubImage3DEXT = cast(type_of(procs.glMultiTexSubImage3DEXT)) GetProcAddress(cast(*u8) "glMultiTexSubImage3DEXT\0");
    procs.glCopyMultiTexSubImage3DEXT = cast(type_of(procs.glCopyMultiTexSubImage3DEXT)) GetProcAddress(cast(*u8) "glCopyMultiTexSubImage3DEXT\0");
    procs.glEnableClientStateIndexedEXT = cast(type_of(procs.glEnableClientStateIndexedEXT)) GetProcAddress(cast(*u8) "glEnableClientStateIndexedEXT\0");
    procs.glDisableClientStateIndexedEXT = cast(type_of(procs.glDisableClientStateIndexedEXT)) GetProcAddress(cast(*u8) "glDisableClientStateIndexedEXT\0");
    procs.glGetFloatIndexedvEXT = cast(type_of(procs.glGetFloatIndexedvEXT)) GetProcAddress(cast(*u8) "glGetFloatIndexedvEXT\0");
    procs.glGetDoubleIndexedvEXT = cast(type_of(procs.glGetDoubleIndexedvEXT)) GetProcAddress(cast(*u8) "glGetDoubleIndexedvEXT\0");
    procs.glGetPointerIndexedvEXT = cast(type_of(procs.glGetPointerIndexedvEXT)) GetProcAddress(cast(*u8) "glGetPointerIndexedvEXT\0");
    procs.glEnableIndexedEXT = cast(type_of(procs.glEnableIndexedEXT)) GetProcAddress(cast(*u8) "glEnableIndexedEXT\0");
    procs.glDisableIndexedEXT = cast(type_of(procs.glDisableIndexedEXT)) GetProcAddress(cast(*u8) "glDisableIndexedEXT\0");
    procs.glIsEnabledIndexedEXT = cast(type_of(procs.glIsEnabledIndexedEXT)) GetProcAddress(cast(*u8) "glIsEnabledIndexedEXT\0");
    procs.glGetIntegerIndexedvEXT = cast(type_of(procs.glGetIntegerIndexedvEXT)) GetProcAddress(cast(*u8) "glGetIntegerIndexedvEXT\0");
    procs.glGetBooleanIndexedvEXT = cast(type_of(procs.glGetBooleanIndexedvEXT)) GetProcAddress(cast(*u8) "glGetBooleanIndexedvEXT\0");
    procs.glCompressedTextureImage3DEXT = cast(type_of(procs.glCompressedTextureImage3DEXT)) GetProcAddress(cast(*u8) "glCompressedTextureImage3DEXT\0");
    procs.glCompressedTextureImage2DEXT = cast(type_of(procs.glCompressedTextureImage2DEXT)) GetProcAddress(cast(*u8) "glCompressedTextureImage2DEXT\0");
    procs.glCompressedTextureImage1DEXT = cast(type_of(procs.glCompressedTextureImage1DEXT)) GetProcAddress(cast(*u8) "glCompressedTextureImage1DEXT\0");
    procs.glCompressedTextureSubImage3DEXT = cast(type_of(procs.glCompressedTextureSubImage3DEXT)) GetProcAddress(cast(*u8) "glCompressedTextureSubImage3DEXT\0");
    procs.glCompressedTextureSubImage2DEXT = cast(type_of(procs.glCompressedTextureSubImage2DEXT)) GetProcAddress(cast(*u8) "glCompressedTextureSubImage2DEXT\0");
    procs.glCompressedTextureSubImage1DEXT = cast(type_of(procs.glCompressedTextureSubImage1DEXT)) GetProcAddress(cast(*u8) "glCompressedTextureSubImage1DEXT\0");
    procs.glGetCompressedTextureImageEXT = cast(type_of(procs.glGetCompressedTextureImageEXT)) GetProcAddress(cast(*u8) "glGetCompressedTextureImageEXT\0");
    procs.glCompressedMultiTexImage3DEXT = cast(type_of(procs.glCompressedMultiTexImage3DEXT)) GetProcAddress(cast(*u8) "glCompressedMultiTexImage3DEXT\0");
    procs.glCompressedMultiTexImage2DEXT = cast(type_of(procs.glCompressedMultiTexImage2DEXT)) GetProcAddress(cast(*u8) "glCompressedMultiTexImage2DEXT\0");
    procs.glCompressedMultiTexImage1DEXT = cast(type_of(procs.glCompressedMultiTexImage1DEXT)) GetProcAddress(cast(*u8) "glCompressedMultiTexImage1DEXT\0");
    procs.glCompressedMultiTexSubImage3DEXT = cast(type_of(procs.glCompressedMultiTexSubImage3DEXT)) GetProcAddress(cast(*u8) "glCompressedMultiTexSubImage3DEXT\0");
    procs.glCompressedMultiTexSubImage2DEXT = cast(type_of(procs.glCompressedMultiTexSubImage2DEXT)) GetProcAddress(cast(*u8) "glCompressedMultiTexSubImage2DEXT\0");
    procs.glCompressedMultiTexSubImage1DEXT = cast(type_of(procs.glCompressedMultiTexSubImage1DEXT)) GetProcAddress(cast(*u8) "glCompressedMultiTexSubImage1DEXT\0");
    procs.glGetCompressedMultiTexImageEXT = cast(type_of(procs.glGetCompressedMultiTexImageEXT)) GetProcAddress(cast(*u8) "glGetCompressedMultiTexImageEXT\0");
    procs.glMatrixLoadTransposefEXT = cast(type_of(procs.glMatrixLoadTransposefEXT)) GetProcAddress(cast(*u8) "glMatrixLoadTransposefEXT\0");
    procs.glMatrixLoadTransposedEXT = cast(type_of(procs.glMatrixLoadTransposedEXT)) GetProcAddress(cast(*u8) "glMatrixLoadTransposedEXT\0");
    procs.glMatrixMultTransposefEXT = cast(type_of(procs.glMatrixMultTransposefEXT)) GetProcAddress(cast(*u8) "glMatrixMultTransposefEXT\0");
    procs.glMatrixMultTransposedEXT = cast(type_of(procs.glMatrixMultTransposedEXT)) GetProcAddress(cast(*u8) "glMatrixMultTransposedEXT\0");
    procs.glNamedBufferDataEXT = cast(type_of(procs.glNamedBufferDataEXT)) GetProcAddress(cast(*u8) "glNamedBufferDataEXT\0");
    procs.glNamedBufferSubDataEXT = cast(type_of(procs.glNamedBufferSubDataEXT)) GetProcAddress(cast(*u8) "glNamedBufferSubDataEXT\0");
    procs.glMapNamedBufferEXT = cast(type_of(procs.glMapNamedBufferEXT)) GetProcAddress(cast(*u8) "glMapNamedBufferEXT\0");
    procs.glUnmapNamedBufferEXT = cast(type_of(procs.glUnmapNamedBufferEXT)) GetProcAddress(cast(*u8) "glUnmapNamedBufferEXT\0");
    procs.glGetNamedBufferParameterivEXT = cast(type_of(procs.glGetNamedBufferParameterivEXT)) GetProcAddress(cast(*u8) "glGetNamedBufferParameterivEXT\0");
    procs.glGetNamedBufferPointervEXT = cast(type_of(procs.glGetNamedBufferPointervEXT)) GetProcAddress(cast(*u8) "glGetNamedBufferPointervEXT\0");
    procs.glGetNamedBufferSubDataEXT = cast(type_of(procs.glGetNamedBufferSubDataEXT)) GetProcAddress(cast(*u8) "glGetNamedBufferSubDataEXT\0");
    procs.glProgramUniform1fEXT = cast(type_of(procs.glProgramUniform1fEXT)) GetProcAddress(cast(*u8) "glProgramUniform1fEXT\0");
    procs.glProgramUniform2fEXT = cast(type_of(procs.glProgramUniform2fEXT)) GetProcAddress(cast(*u8) "glProgramUniform2fEXT\0");
    procs.glProgramUniform3fEXT = cast(type_of(procs.glProgramUniform3fEXT)) GetProcAddress(cast(*u8) "glProgramUniform3fEXT\0");
    procs.glProgramUniform4fEXT = cast(type_of(procs.glProgramUniform4fEXT)) GetProcAddress(cast(*u8) "glProgramUniform4fEXT\0");
    procs.glProgramUniform1iEXT = cast(type_of(procs.glProgramUniform1iEXT)) GetProcAddress(cast(*u8) "glProgramUniform1iEXT\0");
    procs.glProgramUniform2iEXT = cast(type_of(procs.glProgramUniform2iEXT)) GetProcAddress(cast(*u8) "glProgramUniform2iEXT\0");
    procs.glProgramUniform3iEXT = cast(type_of(procs.glProgramUniform3iEXT)) GetProcAddress(cast(*u8) "glProgramUniform3iEXT\0");
    procs.glProgramUniform4iEXT = cast(type_of(procs.glProgramUniform4iEXT)) GetProcAddress(cast(*u8) "glProgramUniform4iEXT\0");
    procs.glProgramUniform1fvEXT = cast(type_of(procs.glProgramUniform1fvEXT)) GetProcAddress(cast(*u8) "glProgramUniform1fvEXT\0");
    procs.glProgramUniform2fvEXT = cast(type_of(procs.glProgramUniform2fvEXT)) GetProcAddress(cast(*u8) "glProgramUniform2fvEXT\0");
    procs.glProgramUniform3fvEXT = cast(type_of(procs.glProgramUniform3fvEXT)) GetProcAddress(cast(*u8) "glProgramUniform3fvEXT\0");
    procs.glProgramUniform4fvEXT = cast(type_of(procs.glProgramUniform4fvEXT)) GetProcAddress(cast(*u8) "glProgramUniform4fvEXT\0");
    procs.glProgramUniform1ivEXT = cast(type_of(procs.glProgramUniform1ivEXT)) GetProcAddress(cast(*u8) "glProgramUniform1ivEXT\0");
    procs.glProgramUniform2ivEXT = cast(type_of(procs.glProgramUniform2ivEXT)) GetProcAddress(cast(*u8) "glProgramUniform2ivEXT\0");
    procs.glProgramUniform3ivEXT = cast(type_of(procs.glProgramUniform3ivEXT)) GetProcAddress(cast(*u8) "glProgramUniform3ivEXT\0");
    procs.glProgramUniform4ivEXT = cast(type_of(procs.glProgramUniform4ivEXT)) GetProcAddress(cast(*u8) "glProgramUniform4ivEXT\0");
    procs.glProgramUniformMatrix2fvEXT = cast(type_of(procs.glProgramUniformMatrix2fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2fvEXT\0");
    procs.glProgramUniformMatrix3fvEXT = cast(type_of(procs.glProgramUniformMatrix3fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3fvEXT\0");
    procs.glProgramUniformMatrix4fvEXT = cast(type_of(procs.glProgramUniformMatrix4fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4fvEXT\0");
    procs.glProgramUniformMatrix2x3fvEXT = cast(type_of(procs.glProgramUniformMatrix2x3fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x3fvEXT\0");
    procs.glProgramUniformMatrix3x2fvEXT = cast(type_of(procs.glProgramUniformMatrix3x2fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x2fvEXT\0");
    procs.glProgramUniformMatrix2x4fvEXT = cast(type_of(procs.glProgramUniformMatrix2x4fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x4fvEXT\0");
    procs.glProgramUniformMatrix4x2fvEXT = cast(type_of(procs.glProgramUniformMatrix4x2fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x2fvEXT\0");
    procs.glProgramUniformMatrix3x4fvEXT = cast(type_of(procs.glProgramUniformMatrix3x4fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x4fvEXT\0");
    procs.glProgramUniformMatrix4x3fvEXT = cast(type_of(procs.glProgramUniformMatrix4x3fvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x3fvEXT\0");
    procs.glTextureBufferEXT = cast(type_of(procs.glTextureBufferEXT)) GetProcAddress(cast(*u8) "glTextureBufferEXT\0");
    procs.glMultiTexBufferEXT = cast(type_of(procs.glMultiTexBufferEXT)) GetProcAddress(cast(*u8) "glMultiTexBufferEXT\0");
    procs.glTextureParameterIivEXT = cast(type_of(procs.glTextureParameterIivEXT)) GetProcAddress(cast(*u8) "glTextureParameterIivEXT\0");
    procs.glTextureParameterIuivEXT = cast(type_of(procs.glTextureParameterIuivEXT)) GetProcAddress(cast(*u8) "glTextureParameterIuivEXT\0");
    procs.glGetTextureParameterIivEXT = cast(type_of(procs.glGetTextureParameterIivEXT)) GetProcAddress(cast(*u8) "glGetTextureParameterIivEXT\0");
    procs.glGetTextureParameterIuivEXT = cast(type_of(procs.glGetTextureParameterIuivEXT)) GetProcAddress(cast(*u8) "glGetTextureParameterIuivEXT\0");
    procs.glMultiTexParameterIivEXT = cast(type_of(procs.glMultiTexParameterIivEXT)) GetProcAddress(cast(*u8) "glMultiTexParameterIivEXT\0");
    procs.glMultiTexParameterIuivEXT = cast(type_of(procs.glMultiTexParameterIuivEXT)) GetProcAddress(cast(*u8) "glMultiTexParameterIuivEXT\0");
    procs.glGetMultiTexParameterIivEXT = cast(type_of(procs.glGetMultiTexParameterIivEXT)) GetProcAddress(cast(*u8) "glGetMultiTexParameterIivEXT\0");
    procs.glGetMultiTexParameterIuivEXT = cast(type_of(procs.glGetMultiTexParameterIuivEXT)) GetProcAddress(cast(*u8) "glGetMultiTexParameterIuivEXT\0");
    procs.glProgramUniform1uiEXT = cast(type_of(procs.glProgramUniform1uiEXT)) GetProcAddress(cast(*u8) "glProgramUniform1uiEXT\0");
    procs.glProgramUniform2uiEXT = cast(type_of(procs.glProgramUniform2uiEXT)) GetProcAddress(cast(*u8) "glProgramUniform2uiEXT\0");
    procs.glProgramUniform3uiEXT = cast(type_of(procs.glProgramUniform3uiEXT)) GetProcAddress(cast(*u8) "glProgramUniform3uiEXT\0");
    procs.glProgramUniform4uiEXT = cast(type_of(procs.glProgramUniform4uiEXT)) GetProcAddress(cast(*u8) "glProgramUniform4uiEXT\0");
    procs.glProgramUniform1uivEXT = cast(type_of(procs.glProgramUniform1uivEXT)) GetProcAddress(cast(*u8) "glProgramUniform1uivEXT\0");
    procs.glProgramUniform2uivEXT = cast(type_of(procs.glProgramUniform2uivEXT)) GetProcAddress(cast(*u8) "glProgramUniform2uivEXT\0");
    procs.glProgramUniform3uivEXT = cast(type_of(procs.glProgramUniform3uivEXT)) GetProcAddress(cast(*u8) "glProgramUniform3uivEXT\0");
    procs.glProgramUniform4uivEXT = cast(type_of(procs.glProgramUniform4uivEXT)) GetProcAddress(cast(*u8) "glProgramUniform4uivEXT\0");
    procs.glNamedProgramLocalParameters4fvEXT = cast(type_of(procs.glNamedProgramLocalParameters4fvEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameters4fvEXT\0");
    procs.glNamedProgramLocalParameterI4iEXT = cast(type_of(procs.glNamedProgramLocalParameterI4iEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameterI4iEXT\0");
    procs.glNamedProgramLocalParameterI4ivEXT = cast(type_of(procs.glNamedProgramLocalParameterI4ivEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameterI4ivEXT\0");
    procs.glNamedProgramLocalParametersI4ivEXT = cast(type_of(procs.glNamedProgramLocalParametersI4ivEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParametersI4ivEXT\0");
    procs.glNamedProgramLocalParameterI4uiEXT = cast(type_of(procs.glNamedProgramLocalParameterI4uiEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameterI4uiEXT\0");
    procs.glNamedProgramLocalParameterI4uivEXT = cast(type_of(procs.glNamedProgramLocalParameterI4uivEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameterI4uivEXT\0");
    procs.glNamedProgramLocalParametersI4uivEXT = cast(type_of(procs.glNamedProgramLocalParametersI4uivEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParametersI4uivEXT\0");
    procs.glGetNamedProgramLocalParameterIivEXT = cast(type_of(procs.glGetNamedProgramLocalParameterIivEXT)) GetProcAddress(cast(*u8) "glGetNamedProgramLocalParameterIivEXT\0");
    procs.glGetNamedProgramLocalParameterIuivEXT = cast(type_of(procs.glGetNamedProgramLocalParameterIuivEXT)) GetProcAddress(cast(*u8) "glGetNamedProgramLocalParameterIuivEXT\0");
    procs.glEnableClientStateiEXT = cast(type_of(procs.glEnableClientStateiEXT)) GetProcAddress(cast(*u8) "glEnableClientStateiEXT\0");
    procs.glDisableClientStateiEXT = cast(type_of(procs.glDisableClientStateiEXT)) GetProcAddress(cast(*u8) "glDisableClientStateiEXT\0");
    procs.glGetFloati_vEXT = cast(type_of(procs.glGetFloati_vEXT)) GetProcAddress(cast(*u8) "glGetFloati_vEXT\0");
    procs.glGetDoublei_vEXT = cast(type_of(procs.glGetDoublei_vEXT)) GetProcAddress(cast(*u8) "glGetDoublei_vEXT\0");
    procs.glGetPointeri_vEXT = cast(type_of(procs.glGetPointeri_vEXT)) GetProcAddress(cast(*u8) "glGetPointeri_vEXT\0");
    procs.glNamedProgramStringEXT = cast(type_of(procs.glNamedProgramStringEXT)) GetProcAddress(cast(*u8) "glNamedProgramStringEXT\0");
    procs.glNamedProgramLocalParameter4dEXT = cast(type_of(procs.glNamedProgramLocalParameter4dEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameter4dEXT\0");
    procs.glNamedProgramLocalParameter4dvEXT = cast(type_of(procs.glNamedProgramLocalParameter4dvEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameter4dvEXT\0");
    procs.glNamedProgramLocalParameter4fEXT = cast(type_of(procs.glNamedProgramLocalParameter4fEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameter4fEXT\0");
    procs.glNamedProgramLocalParameter4fvEXT = cast(type_of(procs.glNamedProgramLocalParameter4fvEXT)) GetProcAddress(cast(*u8) "glNamedProgramLocalParameter4fvEXT\0");
    procs.glGetNamedProgramLocalParameterdvEXT = cast(type_of(procs.glGetNamedProgramLocalParameterdvEXT)) GetProcAddress(cast(*u8) "glGetNamedProgramLocalParameterdvEXT\0");
    procs.glGetNamedProgramLocalParameterfvEXT = cast(type_of(procs.glGetNamedProgramLocalParameterfvEXT)) GetProcAddress(cast(*u8) "glGetNamedProgramLocalParameterfvEXT\0");
    procs.glGetNamedProgramivEXT = cast(type_of(procs.glGetNamedProgramivEXT)) GetProcAddress(cast(*u8) "glGetNamedProgramivEXT\0");
    procs.glGetNamedProgramStringEXT = cast(type_of(procs.glGetNamedProgramStringEXT)) GetProcAddress(cast(*u8) "glGetNamedProgramStringEXT\0");
    procs.glNamedRenderbufferStorageEXT = cast(type_of(procs.glNamedRenderbufferStorageEXT)) GetProcAddress(cast(*u8) "glNamedRenderbufferStorageEXT\0");
    procs.glGetNamedRenderbufferParameterivEXT = cast(type_of(procs.glGetNamedRenderbufferParameterivEXT)) GetProcAddress(cast(*u8) "glGetNamedRenderbufferParameterivEXT\0");
    procs.glNamedRenderbufferStorageMultisampleEXT = cast(type_of(procs.glNamedRenderbufferStorageMultisampleEXT)) GetProcAddress(cast(*u8) "glNamedRenderbufferStorageMultisampleEXT\0");
    procs.glNamedRenderbufferStorageMultisampleCoverageEXT = cast(type_of(procs.glNamedRenderbufferStorageMultisampleCoverageEXT)) GetProcAddress(cast(*u8) "glNamedRenderbufferStorageMultisampleCoverageEXT\0");
    procs.glCheckNamedFramebufferStatusEXT = cast(type_of(procs.glCheckNamedFramebufferStatusEXT)) GetProcAddress(cast(*u8) "glCheckNamedFramebufferStatusEXT\0");
    procs.glNamedFramebufferTexture1DEXT = cast(type_of(procs.glNamedFramebufferTexture1DEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferTexture1DEXT\0");
    procs.glNamedFramebufferTexture2DEXT = cast(type_of(procs.glNamedFramebufferTexture2DEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferTexture2DEXT\0");
    procs.glNamedFramebufferTexture3DEXT = cast(type_of(procs.glNamedFramebufferTexture3DEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferTexture3DEXT\0");
    procs.glNamedFramebufferRenderbufferEXT = cast(type_of(procs.glNamedFramebufferRenderbufferEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferRenderbufferEXT\0");
    procs.glGetNamedFramebufferAttachmentParameterivEXT = cast(type_of(procs.glGetNamedFramebufferAttachmentParameterivEXT)) GetProcAddress(cast(*u8) "glGetNamedFramebufferAttachmentParameterivEXT\0");
    procs.glGenerateTextureMipmapEXT = cast(type_of(procs.glGenerateTextureMipmapEXT)) GetProcAddress(cast(*u8) "glGenerateTextureMipmapEXT\0");
    procs.glGenerateMultiTexMipmapEXT = cast(type_of(procs.glGenerateMultiTexMipmapEXT)) GetProcAddress(cast(*u8) "glGenerateMultiTexMipmapEXT\0");
    procs.glFramebufferDrawBufferEXT = cast(type_of(procs.glFramebufferDrawBufferEXT)) GetProcAddress(cast(*u8) "glFramebufferDrawBufferEXT\0");
    procs.glFramebufferDrawBuffersEXT = cast(type_of(procs.glFramebufferDrawBuffersEXT)) GetProcAddress(cast(*u8) "glFramebufferDrawBuffersEXT\0");
    procs.glFramebufferReadBufferEXT = cast(type_of(procs.glFramebufferReadBufferEXT)) GetProcAddress(cast(*u8) "glFramebufferReadBufferEXT\0");
    procs.glGetFramebufferParameterivEXT = cast(type_of(procs.glGetFramebufferParameterivEXT)) GetProcAddress(cast(*u8) "glGetFramebufferParameterivEXT\0");
    procs.glNamedCopyBufferSubDataEXT = cast(type_of(procs.glNamedCopyBufferSubDataEXT)) GetProcAddress(cast(*u8) "glNamedCopyBufferSubDataEXT\0");
    procs.glNamedFramebufferTextureEXT = cast(type_of(procs.glNamedFramebufferTextureEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferTextureEXT\0");
    procs.glNamedFramebufferTextureLayerEXT = cast(type_of(procs.glNamedFramebufferTextureLayerEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferTextureLayerEXT\0");
    procs.glNamedFramebufferTextureFaceEXT = cast(type_of(procs.glNamedFramebufferTextureFaceEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferTextureFaceEXT\0");
    procs.glTextureRenderbufferEXT = cast(type_of(procs.glTextureRenderbufferEXT)) GetProcAddress(cast(*u8) "glTextureRenderbufferEXT\0");
    procs.glMultiTexRenderbufferEXT = cast(type_of(procs.glMultiTexRenderbufferEXT)) GetProcAddress(cast(*u8) "glMultiTexRenderbufferEXT\0");
    procs.glVertexArrayVertexOffsetEXT = cast(type_of(procs.glVertexArrayVertexOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexOffsetEXT\0");
    procs.glVertexArrayColorOffsetEXT = cast(type_of(procs.glVertexArrayColorOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayColorOffsetEXT\0");
    procs.glVertexArrayEdgeFlagOffsetEXT = cast(type_of(procs.glVertexArrayEdgeFlagOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayEdgeFlagOffsetEXT\0");
    procs.glVertexArrayIndexOffsetEXT = cast(type_of(procs.glVertexArrayIndexOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayIndexOffsetEXT\0");
    procs.glVertexArrayNormalOffsetEXT = cast(type_of(procs.glVertexArrayNormalOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayNormalOffsetEXT\0");
    procs.glVertexArrayTexCoordOffsetEXT = cast(type_of(procs.glVertexArrayTexCoordOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayTexCoordOffsetEXT\0");
    procs.glVertexArrayMultiTexCoordOffsetEXT = cast(type_of(procs.glVertexArrayMultiTexCoordOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayMultiTexCoordOffsetEXT\0");
    procs.glVertexArrayFogCoordOffsetEXT = cast(type_of(procs.glVertexArrayFogCoordOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayFogCoordOffsetEXT\0");
    procs.glVertexArraySecondaryColorOffsetEXT = cast(type_of(procs.glVertexArraySecondaryColorOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArraySecondaryColorOffsetEXT\0");
    procs.glVertexArrayVertexAttribOffsetEXT = cast(type_of(procs.glVertexArrayVertexAttribOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribOffsetEXT\0");
    procs.glVertexArrayVertexAttribIOffsetEXT = cast(type_of(procs.glVertexArrayVertexAttribIOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribIOffsetEXT\0");
    procs.glEnableVertexArrayEXT = cast(type_of(procs.glEnableVertexArrayEXT)) GetProcAddress(cast(*u8) "glEnableVertexArrayEXT\0");
    procs.glDisableVertexArrayEXT = cast(type_of(procs.glDisableVertexArrayEXT)) GetProcAddress(cast(*u8) "glDisableVertexArrayEXT\0");
    procs.glEnableVertexArrayAttribEXT = cast(type_of(procs.glEnableVertexArrayAttribEXT)) GetProcAddress(cast(*u8) "glEnableVertexArrayAttribEXT\0");
    procs.glDisableVertexArrayAttribEXT = cast(type_of(procs.glDisableVertexArrayAttribEXT)) GetProcAddress(cast(*u8) "glDisableVertexArrayAttribEXT\0");
    procs.glGetVertexArrayIntegervEXT = cast(type_of(procs.glGetVertexArrayIntegervEXT)) GetProcAddress(cast(*u8) "glGetVertexArrayIntegervEXT\0");
    procs.glGetVertexArrayPointervEXT = cast(type_of(procs.glGetVertexArrayPointervEXT)) GetProcAddress(cast(*u8) "glGetVertexArrayPointervEXT\0");
    procs.glGetVertexArrayIntegeri_vEXT = cast(type_of(procs.glGetVertexArrayIntegeri_vEXT)) GetProcAddress(cast(*u8) "glGetVertexArrayIntegeri_vEXT\0");
    procs.glGetVertexArrayPointeri_vEXT = cast(type_of(procs.glGetVertexArrayPointeri_vEXT)) GetProcAddress(cast(*u8) "glGetVertexArrayPointeri_vEXT\0");
    procs.glMapNamedBufferRangeEXT = cast(type_of(procs.glMapNamedBufferRangeEXT)) GetProcAddress(cast(*u8) "glMapNamedBufferRangeEXT\0");
    procs.glFlushMappedNamedBufferRangeEXT = cast(type_of(procs.glFlushMappedNamedBufferRangeEXT)) GetProcAddress(cast(*u8) "glFlushMappedNamedBufferRangeEXT\0");
    procs.glNamedBufferStorageEXT = cast(type_of(procs.glNamedBufferStorageEXT)) GetProcAddress(cast(*u8) "glNamedBufferStorageEXT\0");
    procs.glClearNamedBufferDataEXT = cast(type_of(procs.glClearNamedBufferDataEXT)) GetProcAddress(cast(*u8) "glClearNamedBufferDataEXT\0");
    procs.glClearNamedBufferSubDataEXT = cast(type_of(procs.glClearNamedBufferSubDataEXT)) GetProcAddress(cast(*u8) "glClearNamedBufferSubDataEXT\0");
    procs.glNamedFramebufferParameteriEXT = cast(type_of(procs.glNamedFramebufferParameteriEXT)) GetProcAddress(cast(*u8) "glNamedFramebufferParameteriEXT\0");
    procs.glGetNamedFramebufferParameterivEXT = cast(type_of(procs.glGetNamedFramebufferParameterivEXT)) GetProcAddress(cast(*u8) "glGetNamedFramebufferParameterivEXT\0");
    procs.glProgramUniform1dEXT = cast(type_of(procs.glProgramUniform1dEXT)) GetProcAddress(cast(*u8) "glProgramUniform1dEXT\0");
    procs.glProgramUniform2dEXT = cast(type_of(procs.glProgramUniform2dEXT)) GetProcAddress(cast(*u8) "glProgramUniform2dEXT\0");
    procs.glProgramUniform3dEXT = cast(type_of(procs.glProgramUniform3dEXT)) GetProcAddress(cast(*u8) "glProgramUniform3dEXT\0");
    procs.glProgramUniform4dEXT = cast(type_of(procs.glProgramUniform4dEXT)) GetProcAddress(cast(*u8) "glProgramUniform4dEXT\0");
    procs.glProgramUniform1dvEXT = cast(type_of(procs.glProgramUniform1dvEXT)) GetProcAddress(cast(*u8) "glProgramUniform1dvEXT\0");
    procs.glProgramUniform2dvEXT = cast(type_of(procs.glProgramUniform2dvEXT)) GetProcAddress(cast(*u8) "glProgramUniform2dvEXT\0");
    procs.glProgramUniform3dvEXT = cast(type_of(procs.glProgramUniform3dvEXT)) GetProcAddress(cast(*u8) "glProgramUniform3dvEXT\0");
    procs.glProgramUniform4dvEXT = cast(type_of(procs.glProgramUniform4dvEXT)) GetProcAddress(cast(*u8) "glProgramUniform4dvEXT\0");
    procs.glProgramUniformMatrix2dvEXT = cast(type_of(procs.glProgramUniformMatrix2dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2dvEXT\0");
    procs.glProgramUniformMatrix3dvEXT = cast(type_of(procs.glProgramUniformMatrix3dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3dvEXT\0");
    procs.glProgramUniformMatrix4dvEXT = cast(type_of(procs.glProgramUniformMatrix4dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4dvEXT\0");
    procs.glProgramUniformMatrix2x3dvEXT = cast(type_of(procs.glProgramUniformMatrix2x3dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x3dvEXT\0");
    procs.glProgramUniformMatrix2x4dvEXT = cast(type_of(procs.glProgramUniformMatrix2x4dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix2x4dvEXT\0");
    procs.glProgramUniformMatrix3x2dvEXT = cast(type_of(procs.glProgramUniformMatrix3x2dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x2dvEXT\0");
    procs.glProgramUniformMatrix3x4dvEXT = cast(type_of(procs.glProgramUniformMatrix3x4dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix3x4dvEXT\0");
    procs.glProgramUniformMatrix4x2dvEXT = cast(type_of(procs.glProgramUniformMatrix4x2dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x2dvEXT\0");
    procs.glProgramUniformMatrix4x3dvEXT = cast(type_of(procs.glProgramUniformMatrix4x3dvEXT)) GetProcAddress(cast(*u8) "glProgramUniformMatrix4x3dvEXT\0");
    procs.glTextureBufferRangeEXT = cast(type_of(procs.glTextureBufferRangeEXT)) GetProcAddress(cast(*u8) "glTextureBufferRangeEXT\0");
    procs.glTextureStorage1DEXT = cast(type_of(procs.glTextureStorage1DEXT)) GetProcAddress(cast(*u8) "glTextureStorage1DEXT\0");
    procs.glTextureStorage2DEXT = cast(type_of(procs.glTextureStorage2DEXT)) GetProcAddress(cast(*u8) "glTextureStorage2DEXT\0");
    procs.glTextureStorage3DEXT = cast(type_of(procs.glTextureStorage3DEXT)) GetProcAddress(cast(*u8) "glTextureStorage3DEXT\0");
    procs.glTextureStorage2DMultisampleEXT = cast(type_of(procs.glTextureStorage2DMultisampleEXT)) GetProcAddress(cast(*u8) "glTextureStorage2DMultisampleEXT\0");
    procs.glTextureStorage3DMultisampleEXT = cast(type_of(procs.glTextureStorage3DMultisampleEXT)) GetProcAddress(cast(*u8) "glTextureStorage3DMultisampleEXT\0");
    procs.glVertexArrayBindVertexBufferEXT = cast(type_of(procs.glVertexArrayBindVertexBufferEXT)) GetProcAddress(cast(*u8) "glVertexArrayBindVertexBufferEXT\0");
    procs.glVertexArrayVertexAttribFormatEXT = cast(type_of(procs.glVertexArrayVertexAttribFormatEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribFormatEXT\0");
    procs.glVertexArrayVertexAttribIFormatEXT = cast(type_of(procs.glVertexArrayVertexAttribIFormatEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribIFormatEXT\0");
    procs.glVertexArrayVertexAttribLFormatEXT = cast(type_of(procs.glVertexArrayVertexAttribLFormatEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribLFormatEXT\0");
    procs.glVertexArrayVertexAttribBindingEXT = cast(type_of(procs.glVertexArrayVertexAttribBindingEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribBindingEXT\0");
    procs.glVertexArrayVertexBindingDivisorEXT = cast(type_of(procs.glVertexArrayVertexBindingDivisorEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexBindingDivisorEXT\0");
    procs.glVertexArrayVertexAttribLOffsetEXT = cast(type_of(procs.glVertexArrayVertexAttribLOffsetEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribLOffsetEXT\0");
    procs.glTexturePageCommitmentEXT = cast(type_of(procs.glTexturePageCommitmentEXT)) GetProcAddress(cast(*u8) "glTexturePageCommitmentEXT\0");
    procs.glVertexArrayVertexAttribDivisorEXT = cast(type_of(procs.glVertexArrayVertexAttribDivisorEXT)) GetProcAddress(cast(*u8) "glVertexArrayVertexAttribDivisorEXT\0");
    procs.glColorMaskIndexedEXT = cast(type_of(procs.glColorMaskIndexedEXT)) GetProcAddress(cast(*u8) "glColorMaskIndexedEXT\0");
    procs.glDrawArraysInstancedEXT = cast(type_of(procs.glDrawArraysInstancedEXT)) GetProcAddress(cast(*u8) "glDrawArraysInstancedEXT\0");
    procs.glDrawElementsInstancedEXT = cast(type_of(procs.glDrawElementsInstancedEXT)) GetProcAddress(cast(*u8) "glDrawElementsInstancedEXT\0");
    procs.glDrawRangeElementsEXT = cast(type_of(procs.glDrawRangeElementsEXT)) GetProcAddress(cast(*u8) "glDrawRangeElementsEXT\0");
    procs.glFogCoordfEXT = cast(type_of(procs.glFogCoordfEXT)) GetProcAddress(cast(*u8) "glFogCoordfEXT\0");
    procs.glFogCoordfvEXT = cast(type_of(procs.glFogCoordfvEXT)) GetProcAddress(cast(*u8) "glFogCoordfvEXT\0");
    procs.glFogCoorddEXT = cast(type_of(procs.glFogCoorddEXT)) GetProcAddress(cast(*u8) "glFogCoorddEXT\0");
    procs.glFogCoorddvEXT = cast(type_of(procs.glFogCoorddvEXT)) GetProcAddress(cast(*u8) "glFogCoorddvEXT\0");
    procs.glFogCoordPointerEXT = cast(type_of(procs.glFogCoordPointerEXT)) GetProcAddress(cast(*u8) "glFogCoordPointerEXT\0");
    procs.glBlitFramebufferEXT = cast(type_of(procs.glBlitFramebufferEXT)) GetProcAddress(cast(*u8) "glBlitFramebufferEXT\0");
    procs.glRenderbufferStorageMultisampleEXT = cast(type_of(procs.glRenderbufferStorageMultisampleEXT)) GetProcAddress(cast(*u8) "glRenderbufferStorageMultisampleEXT\0");
    procs.glIsRenderbufferEXT = cast(type_of(procs.glIsRenderbufferEXT)) GetProcAddress(cast(*u8) "glIsRenderbufferEXT\0");
    procs.glBindRenderbufferEXT = cast(type_of(procs.glBindRenderbufferEXT)) GetProcAddress(cast(*u8) "glBindRenderbufferEXT\0");
    procs.glDeleteRenderbuffersEXT = cast(type_of(procs.glDeleteRenderbuffersEXT)) GetProcAddress(cast(*u8) "glDeleteRenderbuffersEXT\0");
    procs.glGenRenderbuffersEXT = cast(type_of(procs.glGenRenderbuffersEXT)) GetProcAddress(cast(*u8) "glGenRenderbuffersEXT\0");
    procs.glRenderbufferStorageEXT = cast(type_of(procs.glRenderbufferStorageEXT)) GetProcAddress(cast(*u8) "glRenderbufferStorageEXT\0");
    procs.glGetRenderbufferParameterivEXT = cast(type_of(procs.glGetRenderbufferParameterivEXT)) GetProcAddress(cast(*u8) "glGetRenderbufferParameterivEXT\0");
    procs.glIsFramebufferEXT = cast(type_of(procs.glIsFramebufferEXT)) GetProcAddress(cast(*u8) "glIsFramebufferEXT\0");
    procs.glBindFramebufferEXT = cast(type_of(procs.glBindFramebufferEXT)) GetProcAddress(cast(*u8) "glBindFramebufferEXT\0");
    procs.glDeleteFramebuffersEXT = cast(type_of(procs.glDeleteFramebuffersEXT)) GetProcAddress(cast(*u8) "glDeleteFramebuffersEXT\0");
    procs.glGenFramebuffersEXT = cast(type_of(procs.glGenFramebuffersEXT)) GetProcAddress(cast(*u8) "glGenFramebuffersEXT\0");
    procs.glCheckFramebufferStatusEXT = cast(type_of(procs.glCheckFramebufferStatusEXT)) GetProcAddress(cast(*u8) "glCheckFramebufferStatusEXT\0");
    procs.glFramebufferTexture1DEXT = cast(type_of(procs.glFramebufferTexture1DEXT)) GetProcAddress(cast(*u8) "glFramebufferTexture1DEXT\0");
    procs.glFramebufferTexture2DEXT = cast(type_of(procs.glFramebufferTexture2DEXT)) GetProcAddress(cast(*u8) "glFramebufferTexture2DEXT\0");
    procs.glFramebufferTexture3DEXT = cast(type_of(procs.glFramebufferTexture3DEXT)) GetProcAddress(cast(*u8) "glFramebufferTexture3DEXT\0");
    procs.glFramebufferRenderbufferEXT = cast(type_of(procs.glFramebufferRenderbufferEXT)) GetProcAddress(cast(*u8) "glFramebufferRenderbufferEXT\0");
    procs.glGetFramebufferAttachmentParameterivEXT = cast(type_of(procs.glGetFramebufferAttachmentParameterivEXT)) GetProcAddress(cast(*u8) "glGetFramebufferAttachmentParameterivEXT\0");
    procs.glGenerateMipmapEXT = cast(type_of(procs.glGenerateMipmapEXT)) GetProcAddress(cast(*u8) "glGenerateMipmapEXT\0");
    procs.glProgramParameteriEXT = cast(type_of(procs.glProgramParameteriEXT)) GetProcAddress(cast(*u8) "glProgramParameteriEXT\0");
    procs.glProgramEnvParameters4fvEXT = cast(type_of(procs.glProgramEnvParameters4fvEXT)) GetProcAddress(cast(*u8) "glProgramEnvParameters4fvEXT\0");
    procs.glProgramLocalParameters4fvEXT = cast(type_of(procs.glProgramLocalParameters4fvEXT)) GetProcAddress(cast(*u8) "glProgramLocalParameters4fvEXT\0");
    procs.glGetUniformuivEXT = cast(type_of(procs.glGetUniformuivEXT)) GetProcAddress(cast(*u8) "glGetUniformuivEXT\0");
    procs.glBindFragDataLocationEXT = cast(type_of(procs.glBindFragDataLocationEXT)) GetProcAddress(cast(*u8) "glBindFragDataLocationEXT\0");
    procs.glGetFragDataLocationEXT = cast(type_of(procs.glGetFragDataLocationEXT)) GetProcAddress(cast(*u8) "glGetFragDataLocationEXT\0");
    procs.glUniform1uiEXT = cast(type_of(procs.glUniform1uiEXT)) GetProcAddress(cast(*u8) "glUniform1uiEXT\0");
    procs.glUniform2uiEXT = cast(type_of(procs.glUniform2uiEXT)) GetProcAddress(cast(*u8) "glUniform2uiEXT\0");
    procs.glUniform3uiEXT = cast(type_of(procs.glUniform3uiEXT)) GetProcAddress(cast(*u8) "glUniform3uiEXT\0");
    procs.glUniform4uiEXT = cast(type_of(procs.glUniform4uiEXT)) GetProcAddress(cast(*u8) "glUniform4uiEXT\0");
    procs.glUniform1uivEXT = cast(type_of(procs.glUniform1uivEXT)) GetProcAddress(cast(*u8) "glUniform1uivEXT\0");
    procs.glUniform2uivEXT = cast(type_of(procs.glUniform2uivEXT)) GetProcAddress(cast(*u8) "glUniform2uivEXT\0");
    procs.glUniform3uivEXT = cast(type_of(procs.glUniform3uivEXT)) GetProcAddress(cast(*u8) "glUniform3uivEXT\0");
    procs.glUniform4uivEXT = cast(type_of(procs.glUniform4uivEXT)) GetProcAddress(cast(*u8) "glUniform4uivEXT\0");
    procs.glGetHistogramEXT = cast(type_of(procs.glGetHistogramEXT)) GetProcAddress(cast(*u8) "glGetHistogramEXT\0");
    procs.glGetHistogramParameterfvEXT = cast(type_of(procs.glGetHistogramParameterfvEXT)) GetProcAddress(cast(*u8) "glGetHistogramParameterfvEXT\0");
    procs.glGetHistogramParameterivEXT = cast(type_of(procs.glGetHistogramParameterivEXT)) GetProcAddress(cast(*u8) "glGetHistogramParameterivEXT\0");
    procs.glGetMinmaxEXT = cast(type_of(procs.glGetMinmaxEXT)) GetProcAddress(cast(*u8) "glGetMinmaxEXT\0");
    procs.glGetMinmaxParameterfvEXT = cast(type_of(procs.glGetMinmaxParameterfvEXT)) GetProcAddress(cast(*u8) "glGetMinmaxParameterfvEXT\0");
    procs.glGetMinmaxParameterivEXT = cast(type_of(procs.glGetMinmaxParameterivEXT)) GetProcAddress(cast(*u8) "glGetMinmaxParameterivEXT\0");
    procs.glHistogramEXT = cast(type_of(procs.glHistogramEXT)) GetProcAddress(cast(*u8) "glHistogramEXT\0");
    procs.glMinmaxEXT = cast(type_of(procs.glMinmaxEXT)) GetProcAddress(cast(*u8) "glMinmaxEXT\0");
    procs.glResetHistogramEXT = cast(type_of(procs.glResetHistogramEXT)) GetProcAddress(cast(*u8) "glResetHistogramEXT\0");
    procs.glResetMinmaxEXT = cast(type_of(procs.glResetMinmaxEXT)) GetProcAddress(cast(*u8) "glResetMinmaxEXT\0");
    procs.glIndexFuncEXT = cast(type_of(procs.glIndexFuncEXT)) GetProcAddress(cast(*u8) "glIndexFuncEXT\0");
    procs.glIndexMaterialEXT = cast(type_of(procs.glIndexMaterialEXT)) GetProcAddress(cast(*u8) "glIndexMaterialEXT\0");
    procs.glApplyTextureEXT = cast(type_of(procs.glApplyTextureEXT)) GetProcAddress(cast(*u8) "glApplyTextureEXT\0");
    procs.glTextureLightEXT = cast(type_of(procs.glTextureLightEXT)) GetProcAddress(cast(*u8) "glTextureLightEXT\0");
    procs.glTextureMaterialEXT = cast(type_of(procs.glTextureMaterialEXT)) GetProcAddress(cast(*u8) "glTextureMaterialEXT\0");
    procs.glGetUnsignedBytevEXT = cast(type_of(procs.glGetUnsignedBytevEXT)) GetProcAddress(cast(*u8) "glGetUnsignedBytevEXT\0");
    procs.glGetUnsignedBytei_vEXT = cast(type_of(procs.glGetUnsignedBytei_vEXT)) GetProcAddress(cast(*u8) "glGetUnsignedBytei_vEXT\0");
    procs.glDeleteMemoryObjectsEXT = cast(type_of(procs.glDeleteMemoryObjectsEXT)) GetProcAddress(cast(*u8) "glDeleteMemoryObjectsEXT\0");
    procs.glIsMemoryObjectEXT = cast(type_of(procs.glIsMemoryObjectEXT)) GetProcAddress(cast(*u8) "glIsMemoryObjectEXT\0");
    procs.glCreateMemoryObjectsEXT = cast(type_of(procs.glCreateMemoryObjectsEXT)) GetProcAddress(cast(*u8) "glCreateMemoryObjectsEXT\0");
    procs.glMemoryObjectParameterivEXT = cast(type_of(procs.glMemoryObjectParameterivEXT)) GetProcAddress(cast(*u8) "glMemoryObjectParameterivEXT\0");
    procs.glGetMemoryObjectParameterivEXT = cast(type_of(procs.glGetMemoryObjectParameterivEXT)) GetProcAddress(cast(*u8) "glGetMemoryObjectParameterivEXT\0");
    procs.glTexStorageMem2DEXT = cast(type_of(procs.glTexStorageMem2DEXT)) GetProcAddress(cast(*u8) "glTexStorageMem2DEXT\0");
    procs.glTexStorageMem2DMultisampleEXT = cast(type_of(procs.glTexStorageMem2DMultisampleEXT)) GetProcAddress(cast(*u8) "glTexStorageMem2DMultisampleEXT\0");
    procs.glTexStorageMem3DEXT = cast(type_of(procs.glTexStorageMem3DEXT)) GetProcAddress(cast(*u8) "glTexStorageMem3DEXT\0");
    procs.glTexStorageMem3DMultisampleEXT = cast(type_of(procs.glTexStorageMem3DMultisampleEXT)) GetProcAddress(cast(*u8) "glTexStorageMem3DMultisampleEXT\0");
    procs.glBufferStorageMemEXT = cast(type_of(procs.glBufferStorageMemEXT)) GetProcAddress(cast(*u8) "glBufferStorageMemEXT\0");
    procs.glTextureStorageMem2DEXT = cast(type_of(procs.glTextureStorageMem2DEXT)) GetProcAddress(cast(*u8) "glTextureStorageMem2DEXT\0");
    procs.glTextureStorageMem2DMultisampleEXT = cast(type_of(procs.glTextureStorageMem2DMultisampleEXT)) GetProcAddress(cast(*u8) "glTextureStorageMem2DMultisampleEXT\0");
    procs.glTextureStorageMem3DEXT = cast(type_of(procs.glTextureStorageMem3DEXT)) GetProcAddress(cast(*u8) "glTextureStorageMem3DEXT\0");
    procs.glTextureStorageMem3DMultisampleEXT = cast(type_of(procs.glTextureStorageMem3DMultisampleEXT)) GetProcAddress(cast(*u8) "glTextureStorageMem3DMultisampleEXT\0");
    procs.glNamedBufferStorageMemEXT = cast(type_of(procs.glNamedBufferStorageMemEXT)) GetProcAddress(cast(*u8) "glNamedBufferStorageMemEXT\0");
    procs.glTexStorageMem1DEXT = cast(type_of(procs.glTexStorageMem1DEXT)) GetProcAddress(cast(*u8) "glTexStorageMem1DEXT\0");
    procs.glTextureStorageMem1DEXT = cast(type_of(procs.glTextureStorageMem1DEXT)) GetProcAddress(cast(*u8) "glTextureStorageMem1DEXT\0");
    procs.glImportMemoryFdEXT = cast(type_of(procs.glImportMemoryFdEXT)) GetProcAddress(cast(*u8) "glImportMemoryFdEXT\0");
    procs.glImportMemoryWin32HandleEXT = cast(type_of(procs.glImportMemoryWin32HandleEXT)) GetProcAddress(cast(*u8) "glImportMemoryWin32HandleEXT\0");
    procs.glImportMemoryWin32NameEXT = cast(type_of(procs.glImportMemoryWin32NameEXT)) GetProcAddress(cast(*u8) "glImportMemoryWin32NameEXT\0");
    procs.glMultiDrawArraysEXT = cast(type_of(procs.glMultiDrawArraysEXT)) GetProcAddress(cast(*u8) "glMultiDrawArraysEXT\0");
    procs.glMultiDrawElementsEXT = cast(type_of(procs.glMultiDrawElementsEXT)) GetProcAddress(cast(*u8) "glMultiDrawElementsEXT\0");
    procs.glSampleMaskEXT = cast(type_of(procs.glSampleMaskEXT)) GetProcAddress(cast(*u8) "glSampleMaskEXT\0");
    procs.glSamplePatternEXT = cast(type_of(procs.glSamplePatternEXT)) GetProcAddress(cast(*u8) "glSamplePatternEXT\0");
    procs.glColorTableEXT = cast(type_of(procs.glColorTableEXT)) GetProcAddress(cast(*u8) "glColorTableEXT\0");
    procs.glGetColorTableEXT = cast(type_of(procs.glGetColorTableEXT)) GetProcAddress(cast(*u8) "glGetColorTableEXT\0");
    procs.glGetColorTableParameterivEXT = cast(type_of(procs.glGetColorTableParameterivEXT)) GetProcAddress(cast(*u8) "glGetColorTableParameterivEXT\0");
    procs.glGetColorTableParameterfvEXT = cast(type_of(procs.glGetColorTableParameterfvEXT)) GetProcAddress(cast(*u8) "glGetColorTableParameterfvEXT\0");
    procs.glPixelTransformParameteriEXT = cast(type_of(procs.glPixelTransformParameteriEXT)) GetProcAddress(cast(*u8) "glPixelTransformParameteriEXT\0");
    procs.glPixelTransformParameterfEXT = cast(type_of(procs.glPixelTransformParameterfEXT)) GetProcAddress(cast(*u8) "glPixelTransformParameterfEXT\0");
    procs.glPixelTransformParameterivEXT = cast(type_of(procs.glPixelTransformParameterivEXT)) GetProcAddress(cast(*u8) "glPixelTransformParameterivEXT\0");
    procs.glPixelTransformParameterfvEXT = cast(type_of(procs.glPixelTransformParameterfvEXT)) GetProcAddress(cast(*u8) "glPixelTransformParameterfvEXT\0");
    procs.glGetPixelTransformParameterivEXT = cast(type_of(procs.glGetPixelTransformParameterivEXT)) GetProcAddress(cast(*u8) "glGetPixelTransformParameterivEXT\0");
    procs.glGetPixelTransformParameterfvEXT = cast(type_of(procs.glGetPixelTransformParameterfvEXT)) GetProcAddress(cast(*u8) "glGetPixelTransformParameterfvEXT\0");
    procs.glPointParameterfEXT = cast(type_of(procs.glPointParameterfEXT)) GetProcAddress(cast(*u8) "glPointParameterfEXT\0");
    procs.glPointParameterfvEXT = cast(type_of(procs.glPointParameterfvEXT)) GetProcAddress(cast(*u8) "glPointParameterfvEXT\0");
    procs.glPolygonOffsetEXT = cast(type_of(procs.glPolygonOffsetEXT)) GetProcAddress(cast(*u8) "glPolygonOffsetEXT\0");
    procs.glPolygonOffsetClampEXT = cast(type_of(procs.glPolygonOffsetClampEXT)) GetProcAddress(cast(*u8) "glPolygonOffsetClampEXT\0");
    procs.glProvokingVertexEXT = cast(type_of(procs.glProvokingVertexEXT)) GetProcAddress(cast(*u8) "glProvokingVertexEXT\0");
    procs.glRasterSamplesEXT = cast(type_of(procs.glRasterSamplesEXT)) GetProcAddress(cast(*u8) "glRasterSamplesEXT\0");
    procs.glSecondaryColor3bEXT = cast(type_of(procs.glSecondaryColor3bEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3bEXT\0");
    procs.glSecondaryColor3bvEXT = cast(type_of(procs.glSecondaryColor3bvEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3bvEXT\0");
    procs.glSecondaryColor3dEXT = cast(type_of(procs.glSecondaryColor3dEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3dEXT\0");
    procs.glSecondaryColor3dvEXT = cast(type_of(procs.glSecondaryColor3dvEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3dvEXT\0");
    procs.glSecondaryColor3fEXT = cast(type_of(procs.glSecondaryColor3fEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3fEXT\0");
    procs.glSecondaryColor3fvEXT = cast(type_of(procs.glSecondaryColor3fvEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3fvEXT\0");
    procs.glSecondaryColor3iEXT = cast(type_of(procs.glSecondaryColor3iEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3iEXT\0");
    procs.glSecondaryColor3ivEXT = cast(type_of(procs.glSecondaryColor3ivEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3ivEXT\0");
    procs.glSecondaryColor3sEXT = cast(type_of(procs.glSecondaryColor3sEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3sEXT\0");
    procs.glSecondaryColor3svEXT = cast(type_of(procs.glSecondaryColor3svEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3svEXT\0");
    procs.glSecondaryColor3ubEXT = cast(type_of(procs.glSecondaryColor3ubEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3ubEXT\0");
    procs.glSecondaryColor3ubvEXT = cast(type_of(procs.glSecondaryColor3ubvEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3ubvEXT\0");
    procs.glSecondaryColor3uiEXT = cast(type_of(procs.glSecondaryColor3uiEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3uiEXT\0");
    procs.glSecondaryColor3uivEXT = cast(type_of(procs.glSecondaryColor3uivEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3uivEXT\0");
    procs.glSecondaryColor3usEXT = cast(type_of(procs.glSecondaryColor3usEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3usEXT\0");
    procs.glSecondaryColor3usvEXT = cast(type_of(procs.glSecondaryColor3usvEXT)) GetProcAddress(cast(*u8) "glSecondaryColor3usvEXT\0");
    procs.glSecondaryColorPointerEXT = cast(type_of(procs.glSecondaryColorPointerEXT)) GetProcAddress(cast(*u8) "glSecondaryColorPointerEXT\0");
    procs.glGenSemaphoresEXT = cast(type_of(procs.glGenSemaphoresEXT)) GetProcAddress(cast(*u8) "glGenSemaphoresEXT\0");
    procs.glDeleteSemaphoresEXT = cast(type_of(procs.glDeleteSemaphoresEXT)) GetProcAddress(cast(*u8) "glDeleteSemaphoresEXT\0");
    procs.glIsSemaphoreEXT = cast(type_of(procs.glIsSemaphoreEXT)) GetProcAddress(cast(*u8) "glIsSemaphoreEXT\0");
    procs.glSemaphoreParameterui64vEXT = cast(type_of(procs.glSemaphoreParameterui64vEXT)) GetProcAddress(cast(*u8) "glSemaphoreParameterui64vEXT\0");
    procs.glGetSemaphoreParameterui64vEXT = cast(type_of(procs.glGetSemaphoreParameterui64vEXT)) GetProcAddress(cast(*u8) "glGetSemaphoreParameterui64vEXT\0");
    procs.glWaitSemaphoreEXT = cast(type_of(procs.glWaitSemaphoreEXT)) GetProcAddress(cast(*u8) "glWaitSemaphoreEXT\0");
    procs.glSignalSemaphoreEXT = cast(type_of(procs.glSignalSemaphoreEXT)) GetProcAddress(cast(*u8) "glSignalSemaphoreEXT\0");
    procs.glImportSemaphoreFdEXT = cast(type_of(procs.glImportSemaphoreFdEXT)) GetProcAddress(cast(*u8) "glImportSemaphoreFdEXT\0");
    procs.glImportSemaphoreWin32HandleEXT = cast(type_of(procs.glImportSemaphoreWin32HandleEXT)) GetProcAddress(cast(*u8) "glImportSemaphoreWin32HandleEXT\0");
    procs.glImportSemaphoreWin32NameEXT = cast(type_of(procs.glImportSemaphoreWin32NameEXT)) GetProcAddress(cast(*u8) "glImportSemaphoreWin32NameEXT\0");
    procs.glUseShaderProgramEXT = cast(type_of(procs.glUseShaderProgramEXT)) GetProcAddress(cast(*u8) "glUseShaderProgramEXT\0");
    procs.glActiveProgramEXT = cast(type_of(procs.glActiveProgramEXT)) GetProcAddress(cast(*u8) "glActiveProgramEXT\0");
    procs.glCreateShaderProgramEXT = cast(type_of(procs.glCreateShaderProgramEXT)) GetProcAddress(cast(*u8) "glCreateShaderProgramEXT\0");
    procs.glActiveShaderProgramEXT = cast(type_of(procs.glActiveShaderProgramEXT)) GetProcAddress(cast(*u8) "glActiveShaderProgramEXT\0");
    procs.glBindProgramPipelineEXT = cast(type_of(procs.glBindProgramPipelineEXT)) GetProcAddress(cast(*u8) "glBindProgramPipelineEXT\0");
    procs.glCreateShaderProgramvEXT = cast(type_of(procs.glCreateShaderProgramvEXT)) GetProcAddress(cast(*u8) "glCreateShaderProgramvEXT\0");
    procs.glDeleteProgramPipelinesEXT = cast(type_of(procs.glDeleteProgramPipelinesEXT)) GetProcAddress(cast(*u8) "glDeleteProgramPipelinesEXT\0");
    procs.glGenProgramPipelinesEXT = cast(type_of(procs.glGenProgramPipelinesEXT)) GetProcAddress(cast(*u8) "glGenProgramPipelinesEXT\0");
    procs.glGetProgramPipelineInfoLogEXT = cast(type_of(procs.glGetProgramPipelineInfoLogEXT)) GetProcAddress(cast(*u8) "glGetProgramPipelineInfoLogEXT\0");
    procs.glGetProgramPipelineivEXT = cast(type_of(procs.glGetProgramPipelineivEXT)) GetProcAddress(cast(*u8) "glGetProgramPipelineivEXT\0");
    procs.glIsProgramPipelineEXT = cast(type_of(procs.glIsProgramPipelineEXT)) GetProcAddress(cast(*u8) "glIsProgramPipelineEXT\0");
    procs.glUseProgramStagesEXT = cast(type_of(procs.glUseProgramStagesEXT)) GetProcAddress(cast(*u8) "glUseProgramStagesEXT\0");
    procs.glValidateProgramPipelineEXT = cast(type_of(procs.glValidateProgramPipelineEXT)) GetProcAddress(cast(*u8) "glValidateProgramPipelineEXT\0");
    procs.glFramebufferFetchBarrierEXT = cast(type_of(procs.glFramebufferFetchBarrierEXT)) GetProcAddress(cast(*u8) "glFramebufferFetchBarrierEXT\0");
    procs.glBindImageTextureEXT = cast(type_of(procs.glBindImageTextureEXT)) GetProcAddress(cast(*u8) "glBindImageTextureEXT\0");
    procs.glMemoryBarrierEXT = cast(type_of(procs.glMemoryBarrierEXT)) GetProcAddress(cast(*u8) "glMemoryBarrierEXT\0");
    procs.glStencilClearTagEXT = cast(type_of(procs.glStencilClearTagEXT)) GetProcAddress(cast(*u8) "glStencilClearTagEXT\0");
    procs.glActiveStencilFaceEXT = cast(type_of(procs.glActiveStencilFaceEXT)) GetProcAddress(cast(*u8) "glActiveStencilFaceEXT\0");
    procs.glTexSubImage1DEXT = cast(type_of(procs.glTexSubImage1DEXT)) GetProcAddress(cast(*u8) "glTexSubImage1DEXT\0");
    procs.glTexSubImage2DEXT = cast(type_of(procs.glTexSubImage2DEXT)) GetProcAddress(cast(*u8) "glTexSubImage2DEXT\0");
    procs.glTexImage3DEXT = cast(type_of(procs.glTexImage3DEXT)) GetProcAddress(cast(*u8) "glTexImage3DEXT\0");
    procs.glTexSubImage3DEXT = cast(type_of(procs.glTexSubImage3DEXT)) GetProcAddress(cast(*u8) "glTexSubImage3DEXT\0");
    procs.glFramebufferTextureLayerEXT = cast(type_of(procs.glFramebufferTextureLayerEXT)) GetProcAddress(cast(*u8) "glFramebufferTextureLayerEXT\0");
    procs.glTexBufferEXT = cast(type_of(procs.glTexBufferEXT)) GetProcAddress(cast(*u8) "glTexBufferEXT\0");
    procs.glTexParameterIivEXT = cast(type_of(procs.glTexParameterIivEXT)) GetProcAddress(cast(*u8) "glTexParameterIivEXT\0");
    procs.glTexParameterIuivEXT = cast(type_of(procs.glTexParameterIuivEXT)) GetProcAddress(cast(*u8) "glTexParameterIuivEXT\0");
    procs.glGetTexParameterIivEXT = cast(type_of(procs.glGetTexParameterIivEXT)) GetProcAddress(cast(*u8) "glGetTexParameterIivEXT\0");
    procs.glGetTexParameterIuivEXT = cast(type_of(procs.glGetTexParameterIuivEXT)) GetProcAddress(cast(*u8) "glGetTexParameterIuivEXT\0");
    procs.glClearColorIiEXT = cast(type_of(procs.glClearColorIiEXT)) GetProcAddress(cast(*u8) "glClearColorIiEXT\0");
    procs.glClearColorIuiEXT = cast(type_of(procs.glClearColorIuiEXT)) GetProcAddress(cast(*u8) "glClearColorIuiEXT\0");
    procs.glAreTexturesResidentEXT = cast(type_of(procs.glAreTexturesResidentEXT)) GetProcAddress(cast(*u8) "glAreTexturesResidentEXT\0");
    procs.glBindTextureEXT = cast(type_of(procs.glBindTextureEXT)) GetProcAddress(cast(*u8) "glBindTextureEXT\0");
    procs.glDeleteTexturesEXT = cast(type_of(procs.glDeleteTexturesEXT)) GetProcAddress(cast(*u8) "glDeleteTexturesEXT\0");
    procs.glGenTexturesEXT = cast(type_of(procs.glGenTexturesEXT)) GetProcAddress(cast(*u8) "glGenTexturesEXT\0");
    procs.glIsTextureEXT = cast(type_of(procs.glIsTextureEXT)) GetProcAddress(cast(*u8) "glIsTextureEXT\0");
    procs.glPrioritizeTexturesEXT = cast(type_of(procs.glPrioritizeTexturesEXT)) GetProcAddress(cast(*u8) "glPrioritizeTexturesEXT\0");
    procs.glTextureNormalEXT = cast(type_of(procs.glTextureNormalEXT)) GetProcAddress(cast(*u8) "glTextureNormalEXT\0");
    procs.glGetQueryObjecti64vEXT = cast(type_of(procs.glGetQueryObjecti64vEXT)) GetProcAddress(cast(*u8) "glGetQueryObjecti64vEXT\0");
    procs.glGetQueryObjectui64vEXT = cast(type_of(procs.glGetQueryObjectui64vEXT)) GetProcAddress(cast(*u8) "glGetQueryObjectui64vEXT\0");
    procs.glBeginTransformFeedbackEXT = cast(type_of(procs.glBeginTransformFeedbackEXT)) GetProcAddress(cast(*u8) "glBeginTransformFeedbackEXT\0");
    procs.glEndTransformFeedbackEXT = cast(type_of(procs.glEndTransformFeedbackEXT)) GetProcAddress(cast(*u8) "glEndTransformFeedbackEXT\0");
    procs.glBindBufferRangeEXT = cast(type_of(procs.glBindBufferRangeEXT)) GetProcAddress(cast(*u8) "glBindBufferRangeEXT\0");
    procs.glBindBufferOffsetEXT = cast(type_of(procs.glBindBufferOffsetEXT)) GetProcAddress(cast(*u8) "glBindBufferOffsetEXT\0");
    procs.glBindBufferBaseEXT = cast(type_of(procs.glBindBufferBaseEXT)) GetProcAddress(cast(*u8) "glBindBufferBaseEXT\0");
    procs.glTransformFeedbackVaryingsEXT = cast(type_of(procs.glTransformFeedbackVaryingsEXT)) GetProcAddress(cast(*u8) "glTransformFeedbackVaryingsEXT\0");
    procs.glGetTransformFeedbackVaryingEXT = cast(type_of(procs.glGetTransformFeedbackVaryingEXT)) GetProcAddress(cast(*u8) "glGetTransformFeedbackVaryingEXT\0");
    procs.glArrayElementEXT = cast(type_of(procs.glArrayElementEXT)) GetProcAddress(cast(*u8) "glArrayElementEXT\0");
    procs.glColorPointerEXT = cast(type_of(procs.glColorPointerEXT)) GetProcAddress(cast(*u8) "glColorPointerEXT\0");
    procs.glDrawArraysEXT = cast(type_of(procs.glDrawArraysEXT)) GetProcAddress(cast(*u8) "glDrawArraysEXT\0");
    procs.glEdgeFlagPointerEXT = cast(type_of(procs.glEdgeFlagPointerEXT)) GetProcAddress(cast(*u8) "glEdgeFlagPointerEXT\0");
    procs.glGetPointervEXT = cast(type_of(procs.glGetPointervEXT)) GetProcAddress(cast(*u8) "glGetPointervEXT\0");
    procs.glIndexPointerEXT = cast(type_of(procs.glIndexPointerEXT)) GetProcAddress(cast(*u8) "glIndexPointerEXT\0");
    procs.glNormalPointerEXT = cast(type_of(procs.glNormalPointerEXT)) GetProcAddress(cast(*u8) "glNormalPointerEXT\0");
    procs.glTexCoordPointerEXT = cast(type_of(procs.glTexCoordPointerEXT)) GetProcAddress(cast(*u8) "glTexCoordPointerEXT\0");
    procs.glVertexPointerEXT = cast(type_of(procs.glVertexPointerEXT)) GetProcAddress(cast(*u8) "glVertexPointerEXT\0");
    procs.glVertexAttribL1dEXT = cast(type_of(procs.glVertexAttribL1dEXT)) GetProcAddress(cast(*u8) "glVertexAttribL1dEXT\0");
    procs.glVertexAttribL2dEXT = cast(type_of(procs.glVertexAttribL2dEXT)) GetProcAddress(cast(*u8) "glVertexAttribL2dEXT\0");
    procs.glVertexAttribL3dEXT = cast(type_of(procs.glVertexAttribL3dEXT)) GetProcAddress(cast(*u8) "glVertexAttribL3dEXT\0");
    procs.glVertexAttribL4dEXT = cast(type_of(procs.glVertexAttribL4dEXT)) GetProcAddress(cast(*u8) "glVertexAttribL4dEXT\0");
    procs.glVertexAttribL1dvEXT = cast(type_of(procs.glVertexAttribL1dvEXT)) GetProcAddress(cast(*u8) "glVertexAttribL1dvEXT\0");
    procs.glVertexAttribL2dvEXT = cast(type_of(procs.glVertexAttribL2dvEXT)) GetProcAddress(cast(*u8) "glVertexAttribL2dvEXT\0");
    procs.glVertexAttribL3dvEXT = cast(type_of(procs.glVertexAttribL3dvEXT)) GetProcAddress(cast(*u8) "glVertexAttribL3dvEXT\0");
    procs.glVertexAttribL4dvEXT = cast(type_of(procs.glVertexAttribL4dvEXT)) GetProcAddress(cast(*u8) "glVertexAttribL4dvEXT\0");
    procs.glVertexAttribLPointerEXT = cast(type_of(procs.glVertexAttribLPointerEXT)) GetProcAddress(cast(*u8) "glVertexAttribLPointerEXT\0");
    procs.glGetVertexAttribLdvEXT = cast(type_of(procs.glGetVertexAttribLdvEXT)) GetProcAddress(cast(*u8) "glGetVertexAttribLdvEXT\0");
    procs.glBeginVertexShaderEXT = cast(type_of(procs.glBeginVertexShaderEXT)) GetProcAddress(cast(*u8) "glBeginVertexShaderEXT\0");
    procs.glEndVertexShaderEXT = cast(type_of(procs.glEndVertexShaderEXT)) GetProcAddress(cast(*u8) "glEndVertexShaderEXT\0");
    procs.glBindVertexShaderEXT = cast(type_of(procs.glBindVertexShaderEXT)) GetProcAddress(cast(*u8) "glBindVertexShaderEXT\0");
    procs.glGenVertexShadersEXT = cast(type_of(procs.glGenVertexShadersEXT)) GetProcAddress(cast(*u8) "glGenVertexShadersEXT\0");
    procs.glDeleteVertexShaderEXT = cast(type_of(procs.glDeleteVertexShaderEXT)) GetProcAddress(cast(*u8) "glDeleteVertexShaderEXT\0");
    procs.glShaderOp1EXT = cast(type_of(procs.glShaderOp1EXT)) GetProcAddress(cast(*u8) "glShaderOp1EXT\0");
    procs.glShaderOp2EXT = cast(type_of(procs.glShaderOp2EXT)) GetProcAddress(cast(*u8) "glShaderOp2EXT\0");
    procs.glShaderOp3EXT = cast(type_of(procs.glShaderOp3EXT)) GetProcAddress(cast(*u8) "glShaderOp3EXT\0");
    procs.glSwizzleEXT = cast(type_of(procs.glSwizzleEXT)) GetProcAddress(cast(*u8) "glSwizzleEXT\0");
    procs.glWriteMaskEXT = cast(type_of(procs.glWriteMaskEXT)) GetProcAddress(cast(*u8) "glWriteMaskEXT\0");
    procs.glInsertComponentEXT = cast(type_of(procs.glInsertComponentEXT)) GetProcAddress(cast(*u8) "glInsertComponentEXT\0");
    procs.glExtractComponentEXT = cast(type_of(procs.glExtractComponentEXT)) GetProcAddress(cast(*u8) "glExtractComponentEXT\0");
    procs.glGenSymbolsEXT = cast(type_of(procs.glGenSymbolsEXT)) GetProcAddress(cast(*u8) "glGenSymbolsEXT\0");
    procs.glSetInvariantEXT = cast(type_of(procs.glSetInvariantEXT)) GetProcAddress(cast(*u8) "glSetInvariantEXT\0");
    procs.glSetLocalConstantEXT = cast(type_of(procs.glSetLocalConstantEXT)) GetProcAddress(cast(*u8) "glSetLocalConstantEXT\0");
    procs.glVariantbvEXT = cast(type_of(procs.glVariantbvEXT)) GetProcAddress(cast(*u8) "glVariantbvEXT\0");
    procs.glVariantsvEXT = cast(type_of(procs.glVariantsvEXT)) GetProcAddress(cast(*u8) "glVariantsvEXT\0");
    procs.glVariantivEXT = cast(type_of(procs.glVariantivEXT)) GetProcAddress(cast(*u8) "glVariantivEXT\0");
    procs.glVariantfvEXT = cast(type_of(procs.glVariantfvEXT)) GetProcAddress(cast(*u8) "glVariantfvEXT\0");
    procs.glVariantdvEXT = cast(type_of(procs.glVariantdvEXT)) GetProcAddress(cast(*u8) "glVariantdvEXT\0");
    procs.glVariantubvEXT = cast(type_of(procs.glVariantubvEXT)) GetProcAddress(cast(*u8) "glVariantubvEXT\0");
    procs.glVariantusvEXT = cast(type_of(procs.glVariantusvEXT)) GetProcAddress(cast(*u8) "glVariantusvEXT\0");
    procs.glVariantuivEXT = cast(type_of(procs.glVariantuivEXT)) GetProcAddress(cast(*u8) "glVariantuivEXT\0");
    procs.glVariantPointerEXT = cast(type_of(procs.glVariantPointerEXT)) GetProcAddress(cast(*u8) "glVariantPointerEXT\0");
    procs.glEnableVariantClientStateEXT = cast(type_of(procs.glEnableVariantClientStateEXT)) GetProcAddress(cast(*u8) "glEnableVariantClientStateEXT\0");
    procs.glDisableVariantClientStateEXT = cast(type_of(procs.glDisableVariantClientStateEXT)) GetProcAddress(cast(*u8) "glDisableVariantClientStateEXT\0");
    procs.glBindLightParameterEXT = cast(type_of(procs.glBindLightParameterEXT)) GetProcAddress(cast(*u8) "glBindLightParameterEXT\0");
    procs.glBindMaterialParameterEXT = cast(type_of(procs.glBindMaterialParameterEXT)) GetProcAddress(cast(*u8) "glBindMaterialParameterEXT\0");
    procs.glBindTexGenParameterEXT = cast(type_of(procs.glBindTexGenParameterEXT)) GetProcAddress(cast(*u8) "glBindTexGenParameterEXT\0");
    procs.glBindTextureUnitParameterEXT = cast(type_of(procs.glBindTextureUnitParameterEXT)) GetProcAddress(cast(*u8) "glBindTextureUnitParameterEXT\0");
    procs.glBindParameterEXT = cast(type_of(procs.glBindParameterEXT)) GetProcAddress(cast(*u8) "glBindParameterEXT\0");
    procs.glIsVariantEnabledEXT = cast(type_of(procs.glIsVariantEnabledEXT)) GetProcAddress(cast(*u8) "glIsVariantEnabledEXT\0");
    procs.glGetVariantBooleanvEXT = cast(type_of(procs.glGetVariantBooleanvEXT)) GetProcAddress(cast(*u8) "glGetVariantBooleanvEXT\0");
    procs.glGetVariantIntegervEXT = cast(type_of(procs.glGetVariantIntegervEXT)) GetProcAddress(cast(*u8) "glGetVariantIntegervEXT\0");
    procs.glGetVariantFloatvEXT = cast(type_of(procs.glGetVariantFloatvEXT)) GetProcAddress(cast(*u8) "glGetVariantFloatvEXT\0");
    procs.glGetVariantPointervEXT = cast(type_of(procs.glGetVariantPointervEXT)) GetProcAddress(cast(*u8) "glGetVariantPointervEXT\0");
    procs.glGetInvariantBooleanvEXT = cast(type_of(procs.glGetInvariantBooleanvEXT)) GetProcAddress(cast(*u8) "glGetInvariantBooleanvEXT\0");
    procs.glGetInvariantIntegervEXT = cast(type_of(procs.glGetInvariantIntegervEXT)) GetProcAddress(cast(*u8) "glGetInvariantIntegervEXT\0");
    procs.glGetInvariantFloatvEXT = cast(type_of(procs.glGetInvariantFloatvEXT)) GetProcAddress(cast(*u8) "glGetInvariantFloatvEXT\0");
    procs.glGetLocalConstantBooleanvEXT = cast(type_of(procs.glGetLocalConstantBooleanvEXT)) GetProcAddress(cast(*u8) "glGetLocalConstantBooleanvEXT\0");
    procs.glGetLocalConstantIntegervEXT = cast(type_of(procs.glGetLocalConstantIntegervEXT)) GetProcAddress(cast(*u8) "glGetLocalConstantIntegervEXT\0");
    procs.glGetLocalConstantFloatvEXT = cast(type_of(procs.glGetLocalConstantFloatvEXT)) GetProcAddress(cast(*u8) "glGetLocalConstantFloatvEXT\0");
    procs.glVertexWeightfEXT = cast(type_of(procs.glVertexWeightfEXT)) GetProcAddress(cast(*u8) "glVertexWeightfEXT\0");
    procs.glVertexWeightfvEXT = cast(type_of(procs.glVertexWeightfvEXT)) GetProcAddress(cast(*u8) "glVertexWeightfvEXT\0");
    procs.glVertexWeightPointerEXT = cast(type_of(procs.glVertexWeightPointerEXT)) GetProcAddress(cast(*u8) "glVertexWeightPointerEXT\0");
    procs.glAcquireKeyedMutexWin32EXT = cast(type_of(procs.glAcquireKeyedMutexWin32EXT)) GetProcAddress(cast(*u8) "glAcquireKeyedMutexWin32EXT\0");
    procs.glReleaseKeyedMutexWin32EXT = cast(type_of(procs.glReleaseKeyedMutexWin32EXT)) GetProcAddress(cast(*u8) "glReleaseKeyedMutexWin32EXT\0");
    procs.glWindowRectanglesEXT = cast(type_of(procs.glWindowRectanglesEXT)) GetProcAddress(cast(*u8) "glWindowRectanglesEXT\0");
    procs.glImportSyncEXT = cast(type_of(procs.glImportSyncEXT)) GetProcAddress(cast(*u8) "glImportSyncEXT\0");
    procs.glFrameTerminatorGREMEDY = cast(type_of(procs.glFrameTerminatorGREMEDY)) GetProcAddress(cast(*u8) "glFrameTerminatorGREMEDY\0");
    procs.glStringMarkerGREMEDY = cast(type_of(procs.glStringMarkerGREMEDY)) GetProcAddress(cast(*u8) "glStringMarkerGREMEDY\0");
    procs.glImageTransformParameteriHP = cast(type_of(procs.glImageTransformParameteriHP)) GetProcAddress(cast(*u8) "glImageTransformParameteriHP\0");
    procs.glImageTransformParameterfHP = cast(type_of(procs.glImageTransformParameterfHP)) GetProcAddress(cast(*u8) "glImageTransformParameterfHP\0");
    procs.glImageTransformParameterivHP = cast(type_of(procs.glImageTransformParameterivHP)) GetProcAddress(cast(*u8) "glImageTransformParameterivHP\0");
    procs.glImageTransformParameterfvHP = cast(type_of(procs.glImageTransformParameterfvHP)) GetProcAddress(cast(*u8) "glImageTransformParameterfvHP\0");
    procs.glGetImageTransformParameterivHP = cast(type_of(procs.glGetImageTransformParameterivHP)) GetProcAddress(cast(*u8) "glGetImageTransformParameterivHP\0");
    procs.glGetImageTransformParameterfvHP = cast(type_of(procs.glGetImageTransformParameterfvHP)) GetProcAddress(cast(*u8) "glGetImageTransformParameterfvHP\0");
    procs.glMultiModeDrawArraysIBM = cast(type_of(procs.glMultiModeDrawArraysIBM)) GetProcAddress(cast(*u8) "glMultiModeDrawArraysIBM\0");
    procs.glMultiModeDrawElementsIBM = cast(type_of(procs.glMultiModeDrawElementsIBM)) GetProcAddress(cast(*u8) "glMultiModeDrawElementsIBM\0");
    procs.glFlushStaticDataIBM = cast(type_of(procs.glFlushStaticDataIBM)) GetProcAddress(cast(*u8) "glFlushStaticDataIBM\0");
    procs.glColorPointerListIBM = cast(type_of(procs.glColorPointerListIBM)) GetProcAddress(cast(*u8) "glColorPointerListIBM\0");
    procs.glSecondaryColorPointerListIBM = cast(type_of(procs.glSecondaryColorPointerListIBM)) GetProcAddress(cast(*u8) "glSecondaryColorPointerListIBM\0");
    procs.glEdgeFlagPointerListIBM = cast(type_of(procs.glEdgeFlagPointerListIBM)) GetProcAddress(cast(*u8) "glEdgeFlagPointerListIBM\0");
    procs.glFogCoordPointerListIBM = cast(type_of(procs.glFogCoordPointerListIBM)) GetProcAddress(cast(*u8) "glFogCoordPointerListIBM\0");
    procs.glIndexPointerListIBM = cast(type_of(procs.glIndexPointerListIBM)) GetProcAddress(cast(*u8) "glIndexPointerListIBM\0");
    procs.glNormalPointerListIBM = cast(type_of(procs.glNormalPointerListIBM)) GetProcAddress(cast(*u8) "glNormalPointerListIBM\0");
    procs.glTexCoordPointerListIBM = cast(type_of(procs.glTexCoordPointerListIBM)) GetProcAddress(cast(*u8) "glTexCoordPointerListIBM\0");
    procs.glVertexPointerListIBM = cast(type_of(procs.glVertexPointerListIBM)) GetProcAddress(cast(*u8) "glVertexPointerListIBM\0");
    procs.glBlendFuncSeparateINGR = cast(type_of(procs.glBlendFuncSeparateINGR)) GetProcAddress(cast(*u8) "glBlendFuncSeparateINGR\0");
    procs.glApplyFramebufferAttachmentCMAAINTEL = cast(type_of(procs.glApplyFramebufferAttachmentCMAAINTEL)) GetProcAddress(cast(*u8) "glApplyFramebufferAttachmentCMAAINTEL\0");
    procs.glSyncTextureINTEL = cast(type_of(procs.glSyncTextureINTEL)) GetProcAddress(cast(*u8) "glSyncTextureINTEL\0");
    procs.glUnmapTexture2DINTEL = cast(type_of(procs.glUnmapTexture2DINTEL)) GetProcAddress(cast(*u8) "glUnmapTexture2DINTEL\0");
    procs.glMapTexture2DINTEL = cast(type_of(procs.glMapTexture2DINTEL)) GetProcAddress(cast(*u8) "glMapTexture2DINTEL\0");
    procs.glVertexPointervINTEL = cast(type_of(procs.glVertexPointervINTEL)) GetProcAddress(cast(*u8) "glVertexPointervINTEL\0");
    procs.glNormalPointervINTEL = cast(type_of(procs.glNormalPointervINTEL)) GetProcAddress(cast(*u8) "glNormalPointervINTEL\0");
    procs.glColorPointervINTEL = cast(type_of(procs.glColorPointervINTEL)) GetProcAddress(cast(*u8) "glColorPointervINTEL\0");
    procs.glTexCoordPointervINTEL = cast(type_of(procs.glTexCoordPointervINTEL)) GetProcAddress(cast(*u8) "glTexCoordPointervINTEL\0");
    procs.glBeginPerfQueryINTEL = cast(type_of(procs.glBeginPerfQueryINTEL)) GetProcAddress(cast(*u8) "glBeginPerfQueryINTEL\0");
    procs.glCreatePerfQueryINTEL = cast(type_of(procs.glCreatePerfQueryINTEL)) GetProcAddress(cast(*u8) "glCreatePerfQueryINTEL\0");
    procs.glDeletePerfQueryINTEL = cast(type_of(procs.glDeletePerfQueryINTEL)) GetProcAddress(cast(*u8) "glDeletePerfQueryINTEL\0");
    procs.glEndPerfQueryINTEL = cast(type_of(procs.glEndPerfQueryINTEL)) GetProcAddress(cast(*u8) "glEndPerfQueryINTEL\0");
    procs.glGetFirstPerfQueryIdINTEL = cast(type_of(procs.glGetFirstPerfQueryIdINTEL)) GetProcAddress(cast(*u8) "glGetFirstPerfQueryIdINTEL\0");
    procs.glGetNextPerfQueryIdINTEL = cast(type_of(procs.glGetNextPerfQueryIdINTEL)) GetProcAddress(cast(*u8) "glGetNextPerfQueryIdINTEL\0");
    procs.glGetPerfCounterInfoINTEL = cast(type_of(procs.glGetPerfCounterInfoINTEL)) GetProcAddress(cast(*u8) "glGetPerfCounterInfoINTEL\0");
    procs.glGetPerfQueryDataINTEL = cast(type_of(procs.glGetPerfQueryDataINTEL)) GetProcAddress(cast(*u8) "glGetPerfQueryDataINTEL\0");
    procs.glGetPerfQueryIdByNameINTEL = cast(type_of(procs.glGetPerfQueryIdByNameINTEL)) GetProcAddress(cast(*u8) "glGetPerfQueryIdByNameINTEL\0");
    procs.glGetPerfQueryInfoINTEL = cast(type_of(procs.glGetPerfQueryInfoINTEL)) GetProcAddress(cast(*u8) "glGetPerfQueryInfoINTEL\0");
    procs.glBlendBarrierKHR = cast(type_of(procs.glBlendBarrierKHR)) GetProcAddress(cast(*u8) "glBlendBarrierKHR\0");
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
    procs.glMaxShaderCompilerThreadsKHR = cast(type_of(procs.glMaxShaderCompilerThreadsKHR)) GetProcAddress(cast(*u8) "glMaxShaderCompilerThreadsKHR\0");
    procs.glGetGraphicsResetStatusKHR = cast(type_of(procs.glGetGraphicsResetStatusKHR)) GetProcAddress(cast(*u8) "glGetGraphicsResetStatusKHR\0");
    procs.glReadnPixelsKHR = cast(type_of(procs.glReadnPixelsKHR)) GetProcAddress(cast(*u8) "glReadnPixelsKHR\0");
    procs.glGetnUniformfvKHR = cast(type_of(procs.glGetnUniformfvKHR)) GetProcAddress(cast(*u8) "glGetnUniformfvKHR\0");
    procs.glGetnUniformivKHR = cast(type_of(procs.glGetnUniformivKHR)) GetProcAddress(cast(*u8) "glGetnUniformivKHR\0");
    procs.glGetnUniformuivKHR = cast(type_of(procs.glGetnUniformuivKHR)) GetProcAddress(cast(*u8) "glGetnUniformuivKHR\0");
    procs.glResizeBuffersMESA = cast(type_of(procs.glResizeBuffersMESA)) GetProcAddress(cast(*u8) "glResizeBuffersMESA\0");
    procs.glWindowPos2dMESA = cast(type_of(procs.glWindowPos2dMESA)) GetProcAddress(cast(*u8) "glWindowPos2dMESA\0");
    procs.glWindowPos2dvMESA = cast(type_of(procs.glWindowPos2dvMESA)) GetProcAddress(cast(*u8) "glWindowPos2dvMESA\0");
    procs.glWindowPos2fMESA = cast(type_of(procs.glWindowPos2fMESA)) GetProcAddress(cast(*u8) "glWindowPos2fMESA\0");
    procs.glWindowPos2fvMESA = cast(type_of(procs.glWindowPos2fvMESA)) GetProcAddress(cast(*u8) "glWindowPos2fvMESA\0");
    procs.glWindowPos2iMESA = cast(type_of(procs.glWindowPos2iMESA)) GetProcAddress(cast(*u8) "glWindowPos2iMESA\0");
    procs.glWindowPos2ivMESA = cast(type_of(procs.glWindowPos2ivMESA)) GetProcAddress(cast(*u8) "glWindowPos2ivMESA\0");
    procs.glWindowPos2sMESA = cast(type_of(procs.glWindowPos2sMESA)) GetProcAddress(cast(*u8) "glWindowPos2sMESA\0");
    procs.glWindowPos2svMESA = cast(type_of(procs.glWindowPos2svMESA)) GetProcAddress(cast(*u8) "glWindowPos2svMESA\0");
    procs.glWindowPos3dMESA = cast(type_of(procs.glWindowPos3dMESA)) GetProcAddress(cast(*u8) "glWindowPos3dMESA\0");
    procs.glWindowPos3dvMESA = cast(type_of(procs.glWindowPos3dvMESA)) GetProcAddress(cast(*u8) "glWindowPos3dvMESA\0");
    procs.glWindowPos3fMESA = cast(type_of(procs.glWindowPos3fMESA)) GetProcAddress(cast(*u8) "glWindowPos3fMESA\0");
    procs.glWindowPos3fvMESA = cast(type_of(procs.glWindowPos3fvMESA)) GetProcAddress(cast(*u8) "glWindowPos3fvMESA\0");
    procs.glWindowPos3iMESA = cast(type_of(procs.glWindowPos3iMESA)) GetProcAddress(cast(*u8) "glWindowPos3iMESA\0");
    procs.glWindowPos3ivMESA = cast(type_of(procs.glWindowPos3ivMESA)) GetProcAddress(cast(*u8) "glWindowPos3ivMESA\0");
    procs.glWindowPos3sMESA = cast(type_of(procs.glWindowPos3sMESA)) GetProcAddress(cast(*u8) "glWindowPos3sMESA\0");
    procs.glWindowPos3svMESA = cast(type_of(procs.glWindowPos3svMESA)) GetProcAddress(cast(*u8) "glWindowPos3svMESA\0");
    procs.glWindowPos4dMESA = cast(type_of(procs.glWindowPos4dMESA)) GetProcAddress(cast(*u8) "glWindowPos4dMESA\0");
    procs.glWindowPos4dvMESA = cast(type_of(procs.glWindowPos4dvMESA)) GetProcAddress(cast(*u8) "glWindowPos4dvMESA\0");
    procs.glWindowPos4fMESA = cast(type_of(procs.glWindowPos4fMESA)) GetProcAddress(cast(*u8) "glWindowPos4fMESA\0");
    procs.glWindowPos4fvMESA = cast(type_of(procs.glWindowPos4fvMESA)) GetProcAddress(cast(*u8) "glWindowPos4fvMESA\0");
    procs.glWindowPos4iMESA = cast(type_of(procs.glWindowPos4iMESA)) GetProcAddress(cast(*u8) "glWindowPos4iMESA\0");
    procs.glWindowPos4ivMESA = cast(type_of(procs.glWindowPos4ivMESA)) GetProcAddress(cast(*u8) "glWindowPos4ivMESA\0");
    procs.glWindowPos4sMESA = cast(type_of(procs.glWindowPos4sMESA)) GetProcAddress(cast(*u8) "glWindowPos4sMESA\0");
    procs.glWindowPos4svMESA = cast(type_of(procs.glWindowPos4svMESA)) GetProcAddress(cast(*u8) "glWindowPos4svMESA\0");
    procs.glBeginConditionalRenderNVX = cast(type_of(procs.glBeginConditionalRenderNVX)) GetProcAddress(cast(*u8) "glBeginConditionalRenderNVX\0");
    procs.glEndConditionalRenderNVX = cast(type_of(procs.glEndConditionalRenderNVX)) GetProcAddress(cast(*u8) "glEndConditionalRenderNVX\0");
    procs.glLGPUNamedBufferSubDataNVX = cast(type_of(procs.glLGPUNamedBufferSubDataNVX)) GetProcAddress(cast(*u8) "glLGPUNamedBufferSubDataNVX\0");
    procs.glLGPUCopyImageSubDataNVX = cast(type_of(procs.glLGPUCopyImageSubDataNVX)) GetProcAddress(cast(*u8) "glLGPUCopyImageSubDataNVX\0");
    procs.glLGPUInterlockNVX = cast(type_of(procs.glLGPUInterlockNVX)) GetProcAddress(cast(*u8) "glLGPUInterlockNVX\0");
    procs.glAlphaToCoverageDitherControlNV = cast(type_of(procs.glAlphaToCoverageDitherControlNV)) GetProcAddress(cast(*u8) "glAlphaToCoverageDitherControlNV\0");
    procs.glMultiDrawArraysIndirectBindlessNV = cast(type_of(procs.glMultiDrawArraysIndirectBindlessNV)) GetProcAddress(cast(*u8) "glMultiDrawArraysIndirectBindlessNV\0");
    procs.glMultiDrawElementsIndirectBindlessNV = cast(type_of(procs.glMultiDrawElementsIndirectBindlessNV)) GetProcAddress(cast(*u8) "glMultiDrawElementsIndirectBindlessNV\0");
    procs.glMultiDrawArraysIndirectBindlessCountNV = cast(type_of(procs.glMultiDrawArraysIndirectBindlessCountNV)) GetProcAddress(cast(*u8) "glMultiDrawArraysIndirectBindlessCountNV\0");
    procs.glMultiDrawElementsIndirectBindlessCountNV = cast(type_of(procs.glMultiDrawElementsIndirectBindlessCountNV)) GetProcAddress(cast(*u8) "glMultiDrawElementsIndirectBindlessCountNV\0");
    procs.glGetTextureHandleNV = cast(type_of(procs.glGetTextureHandleNV)) GetProcAddress(cast(*u8) "glGetTextureHandleNV\0");
    procs.glGetTextureSamplerHandleNV = cast(type_of(procs.glGetTextureSamplerHandleNV)) GetProcAddress(cast(*u8) "glGetTextureSamplerHandleNV\0");
    procs.glMakeTextureHandleResidentNV = cast(type_of(procs.glMakeTextureHandleResidentNV)) GetProcAddress(cast(*u8) "glMakeTextureHandleResidentNV\0");
    procs.glMakeTextureHandleNonResidentNV = cast(type_of(procs.glMakeTextureHandleNonResidentNV)) GetProcAddress(cast(*u8) "glMakeTextureHandleNonResidentNV\0");
    procs.glGetImageHandleNV = cast(type_of(procs.glGetImageHandleNV)) GetProcAddress(cast(*u8) "glGetImageHandleNV\0");
    procs.glMakeImageHandleResidentNV = cast(type_of(procs.glMakeImageHandleResidentNV)) GetProcAddress(cast(*u8) "glMakeImageHandleResidentNV\0");
    procs.glMakeImageHandleNonResidentNV = cast(type_of(procs.glMakeImageHandleNonResidentNV)) GetProcAddress(cast(*u8) "glMakeImageHandleNonResidentNV\0");
    procs.glUniformHandleui64NV = cast(type_of(procs.glUniformHandleui64NV)) GetProcAddress(cast(*u8) "glUniformHandleui64NV\0");
    procs.glUniformHandleui64vNV = cast(type_of(procs.glUniformHandleui64vNV)) GetProcAddress(cast(*u8) "glUniformHandleui64vNV\0");
    procs.glProgramUniformHandleui64NV = cast(type_of(procs.glProgramUniformHandleui64NV)) GetProcAddress(cast(*u8) "glProgramUniformHandleui64NV\0");
    procs.glProgramUniformHandleui64vNV = cast(type_of(procs.glProgramUniformHandleui64vNV)) GetProcAddress(cast(*u8) "glProgramUniformHandleui64vNV\0");
    procs.glIsTextureHandleResidentNV = cast(type_of(procs.glIsTextureHandleResidentNV)) GetProcAddress(cast(*u8) "glIsTextureHandleResidentNV\0");
    procs.glIsImageHandleResidentNV = cast(type_of(procs.glIsImageHandleResidentNV)) GetProcAddress(cast(*u8) "glIsImageHandleResidentNV\0");
    procs.glBlendParameteriNV = cast(type_of(procs.glBlendParameteriNV)) GetProcAddress(cast(*u8) "glBlendParameteriNV\0");
    procs.glBlendBarrierNV = cast(type_of(procs.glBlendBarrierNV)) GetProcAddress(cast(*u8) "glBlendBarrierNV\0");
    procs.glViewportPositionWScaleNV = cast(type_of(procs.glViewportPositionWScaleNV)) GetProcAddress(cast(*u8) "glViewportPositionWScaleNV\0");
    procs.glCreateStatesNV = cast(type_of(procs.glCreateStatesNV)) GetProcAddress(cast(*u8) "glCreateStatesNV\0");
    procs.glDeleteStatesNV = cast(type_of(procs.glDeleteStatesNV)) GetProcAddress(cast(*u8) "glDeleteStatesNV\0");
    procs.glIsStateNV = cast(type_of(procs.glIsStateNV)) GetProcAddress(cast(*u8) "glIsStateNV\0");
    procs.glStateCaptureNV = cast(type_of(procs.glStateCaptureNV)) GetProcAddress(cast(*u8) "glStateCaptureNV\0");
    procs.glGetCommandHeaderNV = cast(type_of(procs.glGetCommandHeaderNV)) GetProcAddress(cast(*u8) "glGetCommandHeaderNV\0");
    procs.glGetStageIndexNV = cast(type_of(procs.glGetStageIndexNV)) GetProcAddress(cast(*u8) "glGetStageIndexNV\0");
    procs.glDrawCommandsNV = cast(type_of(procs.glDrawCommandsNV)) GetProcAddress(cast(*u8) "glDrawCommandsNV\0");
    procs.glDrawCommandsAddressNV = cast(type_of(procs.glDrawCommandsAddressNV)) GetProcAddress(cast(*u8) "glDrawCommandsAddressNV\0");
    procs.glDrawCommandsStatesNV = cast(type_of(procs.glDrawCommandsStatesNV)) GetProcAddress(cast(*u8) "glDrawCommandsStatesNV\0");
    procs.glDrawCommandsStatesAddressNV = cast(type_of(procs.glDrawCommandsStatesAddressNV)) GetProcAddress(cast(*u8) "glDrawCommandsStatesAddressNV\0");
    procs.glCreateCommandListsNV = cast(type_of(procs.glCreateCommandListsNV)) GetProcAddress(cast(*u8) "glCreateCommandListsNV\0");
    procs.glDeleteCommandListsNV = cast(type_of(procs.glDeleteCommandListsNV)) GetProcAddress(cast(*u8) "glDeleteCommandListsNV\0");
    procs.glIsCommandListNV = cast(type_of(procs.glIsCommandListNV)) GetProcAddress(cast(*u8) "glIsCommandListNV\0");
    procs.glListDrawCommandsStatesClientNV = cast(type_of(procs.glListDrawCommandsStatesClientNV)) GetProcAddress(cast(*u8) "glListDrawCommandsStatesClientNV\0");
    procs.glCommandListSegmentsNV = cast(type_of(procs.glCommandListSegmentsNV)) GetProcAddress(cast(*u8) "glCommandListSegmentsNV\0");
    procs.glCompileCommandListNV = cast(type_of(procs.glCompileCommandListNV)) GetProcAddress(cast(*u8) "glCompileCommandListNV\0");
    procs.glCallCommandListNV = cast(type_of(procs.glCallCommandListNV)) GetProcAddress(cast(*u8) "glCallCommandListNV\0");
    procs.glBeginConditionalRenderNV = cast(type_of(procs.glBeginConditionalRenderNV)) GetProcAddress(cast(*u8) "glBeginConditionalRenderNV\0");
    procs.glEndConditionalRenderNV = cast(type_of(procs.glEndConditionalRenderNV)) GetProcAddress(cast(*u8) "glEndConditionalRenderNV\0");
    procs.glSubpixelPrecisionBiasNV = cast(type_of(procs.glSubpixelPrecisionBiasNV)) GetProcAddress(cast(*u8) "glSubpixelPrecisionBiasNV\0");
    procs.glConservativeRasterParameterfNV = cast(type_of(procs.glConservativeRasterParameterfNV)) GetProcAddress(cast(*u8) "glConservativeRasterParameterfNV\0");
    procs.glConservativeRasterParameteriNV = cast(type_of(procs.glConservativeRasterParameteriNV)) GetProcAddress(cast(*u8) "glConservativeRasterParameteriNV\0");
    procs.glCopyImageSubDataNV = cast(type_of(procs.glCopyImageSubDataNV)) GetProcAddress(cast(*u8) "glCopyImageSubDataNV\0");
    procs.glDepthRangedNV = cast(type_of(procs.glDepthRangedNV)) GetProcAddress(cast(*u8) "glDepthRangedNV\0");
    procs.glClearDepthdNV = cast(type_of(procs.glClearDepthdNV)) GetProcAddress(cast(*u8) "glClearDepthdNV\0");
    procs.glDepthBoundsdNV = cast(type_of(procs.glDepthBoundsdNV)) GetProcAddress(cast(*u8) "glDepthBoundsdNV\0");
    procs.glDrawTextureNV = cast(type_of(procs.glDrawTextureNV)) GetProcAddress(cast(*u8) "glDrawTextureNV\0");
    procs.glDrawVkImageNV = cast(type_of(procs.glDrawVkImageNV)) GetProcAddress(cast(*u8) "glDrawVkImageNV\0");
    procs.glWaitVkSemaphoreNV = cast(type_of(procs.glWaitVkSemaphoreNV)) GetProcAddress(cast(*u8) "glWaitVkSemaphoreNV\0");
    procs.glSignalVkSemaphoreNV = cast(type_of(procs.glSignalVkSemaphoreNV)) GetProcAddress(cast(*u8) "glSignalVkSemaphoreNV\0");
    procs.glSignalVkFenceNV = cast(type_of(procs.glSignalVkFenceNV)) GetProcAddress(cast(*u8) "glSignalVkFenceNV\0");
    procs.glMapControlPointsNV = cast(type_of(procs.glMapControlPointsNV)) GetProcAddress(cast(*u8) "glMapControlPointsNV\0");
    procs.glMapParameterivNV = cast(type_of(procs.glMapParameterivNV)) GetProcAddress(cast(*u8) "glMapParameterivNV\0");
    procs.glMapParameterfvNV = cast(type_of(procs.glMapParameterfvNV)) GetProcAddress(cast(*u8) "glMapParameterfvNV\0");
    procs.glGetMapControlPointsNV = cast(type_of(procs.glGetMapControlPointsNV)) GetProcAddress(cast(*u8) "glGetMapControlPointsNV\0");
    procs.glGetMapParameterivNV = cast(type_of(procs.glGetMapParameterivNV)) GetProcAddress(cast(*u8) "glGetMapParameterivNV\0");
    procs.glGetMapParameterfvNV = cast(type_of(procs.glGetMapParameterfvNV)) GetProcAddress(cast(*u8) "glGetMapParameterfvNV\0");
    procs.glGetMapAttribParameterivNV = cast(type_of(procs.glGetMapAttribParameterivNV)) GetProcAddress(cast(*u8) "glGetMapAttribParameterivNV\0");
    procs.glGetMapAttribParameterfvNV = cast(type_of(procs.glGetMapAttribParameterfvNV)) GetProcAddress(cast(*u8) "glGetMapAttribParameterfvNV\0");
    procs.glEvalMapsNV = cast(type_of(procs.glEvalMapsNV)) GetProcAddress(cast(*u8) "glEvalMapsNV\0");
    procs.glGetMultisamplefvNV = cast(type_of(procs.glGetMultisamplefvNV)) GetProcAddress(cast(*u8) "glGetMultisamplefvNV\0");
    procs.glSampleMaskIndexedNV = cast(type_of(procs.glSampleMaskIndexedNV)) GetProcAddress(cast(*u8) "glSampleMaskIndexedNV\0");
    procs.glTexRenderbufferNV = cast(type_of(procs.glTexRenderbufferNV)) GetProcAddress(cast(*u8) "glTexRenderbufferNV\0");
    procs.glDeleteFencesNV = cast(type_of(procs.glDeleteFencesNV)) GetProcAddress(cast(*u8) "glDeleteFencesNV\0");
    procs.glGenFencesNV = cast(type_of(procs.glGenFencesNV)) GetProcAddress(cast(*u8) "glGenFencesNV\0");
    procs.glIsFenceNV = cast(type_of(procs.glIsFenceNV)) GetProcAddress(cast(*u8) "glIsFenceNV\0");
    procs.glTestFenceNV = cast(type_of(procs.glTestFenceNV)) GetProcAddress(cast(*u8) "glTestFenceNV\0");
    procs.glGetFenceivNV = cast(type_of(procs.glGetFenceivNV)) GetProcAddress(cast(*u8) "glGetFenceivNV\0");
    procs.glFinishFenceNV = cast(type_of(procs.glFinishFenceNV)) GetProcAddress(cast(*u8) "glFinishFenceNV\0");
    procs.glSetFenceNV = cast(type_of(procs.glSetFenceNV)) GetProcAddress(cast(*u8) "glSetFenceNV\0");
    procs.glFragmentCoverageColorNV = cast(type_of(procs.glFragmentCoverageColorNV)) GetProcAddress(cast(*u8) "glFragmentCoverageColorNV\0");
    procs.glProgramNamedParameter4fNV = cast(type_of(procs.glProgramNamedParameter4fNV)) GetProcAddress(cast(*u8) "glProgramNamedParameter4fNV\0");
    procs.glProgramNamedParameter4fvNV = cast(type_of(procs.glProgramNamedParameter4fvNV)) GetProcAddress(cast(*u8) "glProgramNamedParameter4fvNV\0");
    procs.glProgramNamedParameter4dNV = cast(type_of(procs.glProgramNamedParameter4dNV)) GetProcAddress(cast(*u8) "glProgramNamedParameter4dNV\0");
    procs.glProgramNamedParameter4dvNV = cast(type_of(procs.glProgramNamedParameter4dvNV)) GetProcAddress(cast(*u8) "glProgramNamedParameter4dvNV\0");
    procs.glGetProgramNamedParameterfvNV = cast(type_of(procs.glGetProgramNamedParameterfvNV)) GetProcAddress(cast(*u8) "glGetProgramNamedParameterfvNV\0");
    procs.glGetProgramNamedParameterdvNV = cast(type_of(procs.glGetProgramNamedParameterdvNV)) GetProcAddress(cast(*u8) "glGetProgramNamedParameterdvNV\0");
    procs.glCoverageModulationTableNV = cast(type_of(procs.glCoverageModulationTableNV)) GetProcAddress(cast(*u8) "glCoverageModulationTableNV\0");
    procs.glGetCoverageModulationTableNV = cast(type_of(procs.glGetCoverageModulationTableNV)) GetProcAddress(cast(*u8) "glGetCoverageModulationTableNV\0");
    procs.glCoverageModulationNV = cast(type_of(procs.glCoverageModulationNV)) GetProcAddress(cast(*u8) "glCoverageModulationNV\0");
    procs.glRenderbufferStorageMultisampleCoverageNV = cast(type_of(procs.glRenderbufferStorageMultisampleCoverageNV)) GetProcAddress(cast(*u8) "glRenderbufferStorageMultisampleCoverageNV\0");
    procs.glProgramVertexLimitNV = cast(type_of(procs.glProgramVertexLimitNV)) GetProcAddress(cast(*u8) "glProgramVertexLimitNV\0");
    procs.glFramebufferTextureEXT = cast(type_of(procs.glFramebufferTextureEXT)) GetProcAddress(cast(*u8) "glFramebufferTextureEXT\0");
    procs.glFramebufferTextureFaceEXT = cast(type_of(procs.glFramebufferTextureFaceEXT)) GetProcAddress(cast(*u8) "glFramebufferTextureFaceEXT\0");
    procs.glRenderGpuMaskNV = cast(type_of(procs.glRenderGpuMaskNV)) GetProcAddress(cast(*u8) "glRenderGpuMaskNV\0");
    procs.glMulticastBufferSubDataNV = cast(type_of(procs.glMulticastBufferSubDataNV)) GetProcAddress(cast(*u8) "glMulticastBufferSubDataNV\0");
    procs.glMulticastCopyBufferSubDataNV = cast(type_of(procs.glMulticastCopyBufferSubDataNV)) GetProcAddress(cast(*u8) "glMulticastCopyBufferSubDataNV\0");
    procs.glMulticastCopyImageSubDataNV = cast(type_of(procs.glMulticastCopyImageSubDataNV)) GetProcAddress(cast(*u8) "glMulticastCopyImageSubDataNV\0");
    procs.glMulticastBlitFramebufferNV = cast(type_of(procs.glMulticastBlitFramebufferNV)) GetProcAddress(cast(*u8) "glMulticastBlitFramebufferNV\0");
    procs.glMulticastFramebufferSampleLocationsfvNV = cast(type_of(procs.glMulticastFramebufferSampleLocationsfvNV)) GetProcAddress(cast(*u8) "glMulticastFramebufferSampleLocationsfvNV\0");
    procs.glMulticastBarrierNV = cast(type_of(procs.glMulticastBarrierNV)) GetProcAddress(cast(*u8) "glMulticastBarrierNV\0");
    procs.glMulticastWaitSyncNV = cast(type_of(procs.glMulticastWaitSyncNV)) GetProcAddress(cast(*u8) "glMulticastWaitSyncNV\0");
    procs.glMulticastGetQueryObjectivNV = cast(type_of(procs.glMulticastGetQueryObjectivNV)) GetProcAddress(cast(*u8) "glMulticastGetQueryObjectivNV\0");
    procs.glMulticastGetQueryObjectuivNV = cast(type_of(procs.glMulticastGetQueryObjectuivNV)) GetProcAddress(cast(*u8) "glMulticastGetQueryObjectuivNV\0");
    procs.glMulticastGetQueryObjecti64vNV = cast(type_of(procs.glMulticastGetQueryObjecti64vNV)) GetProcAddress(cast(*u8) "glMulticastGetQueryObjecti64vNV\0");
    procs.glMulticastGetQueryObjectui64vNV = cast(type_of(procs.glMulticastGetQueryObjectui64vNV)) GetProcAddress(cast(*u8) "glMulticastGetQueryObjectui64vNV\0");
    procs.glProgramLocalParameterI4iNV = cast(type_of(procs.glProgramLocalParameterI4iNV)) GetProcAddress(cast(*u8) "glProgramLocalParameterI4iNV\0");
    procs.glProgramLocalParameterI4ivNV = cast(type_of(procs.glProgramLocalParameterI4ivNV)) GetProcAddress(cast(*u8) "glProgramLocalParameterI4ivNV\0");
    procs.glProgramLocalParametersI4ivNV = cast(type_of(procs.glProgramLocalParametersI4ivNV)) GetProcAddress(cast(*u8) "glProgramLocalParametersI4ivNV\0");
    procs.glProgramLocalParameterI4uiNV = cast(type_of(procs.glProgramLocalParameterI4uiNV)) GetProcAddress(cast(*u8) "glProgramLocalParameterI4uiNV\0");
    procs.glProgramLocalParameterI4uivNV = cast(type_of(procs.glProgramLocalParameterI4uivNV)) GetProcAddress(cast(*u8) "glProgramLocalParameterI4uivNV\0");
    procs.glProgramLocalParametersI4uivNV = cast(type_of(procs.glProgramLocalParametersI4uivNV)) GetProcAddress(cast(*u8) "glProgramLocalParametersI4uivNV\0");
    procs.glProgramEnvParameterI4iNV = cast(type_of(procs.glProgramEnvParameterI4iNV)) GetProcAddress(cast(*u8) "glProgramEnvParameterI4iNV\0");
    procs.glProgramEnvParameterI4ivNV = cast(type_of(procs.glProgramEnvParameterI4ivNV)) GetProcAddress(cast(*u8) "glProgramEnvParameterI4ivNV\0");
    procs.glProgramEnvParametersI4ivNV = cast(type_of(procs.glProgramEnvParametersI4ivNV)) GetProcAddress(cast(*u8) "glProgramEnvParametersI4ivNV\0");
    procs.glProgramEnvParameterI4uiNV = cast(type_of(procs.glProgramEnvParameterI4uiNV)) GetProcAddress(cast(*u8) "glProgramEnvParameterI4uiNV\0");
    procs.glProgramEnvParameterI4uivNV = cast(type_of(procs.glProgramEnvParameterI4uivNV)) GetProcAddress(cast(*u8) "glProgramEnvParameterI4uivNV\0");
    procs.glProgramEnvParametersI4uivNV = cast(type_of(procs.glProgramEnvParametersI4uivNV)) GetProcAddress(cast(*u8) "glProgramEnvParametersI4uivNV\0");
    procs.glGetProgramLocalParameterIivNV = cast(type_of(procs.glGetProgramLocalParameterIivNV)) GetProcAddress(cast(*u8) "glGetProgramLocalParameterIivNV\0");
    procs.glGetProgramLocalParameterIuivNV = cast(type_of(procs.glGetProgramLocalParameterIuivNV)) GetProcAddress(cast(*u8) "glGetProgramLocalParameterIuivNV\0");
    procs.glGetProgramEnvParameterIivNV = cast(type_of(procs.glGetProgramEnvParameterIivNV)) GetProcAddress(cast(*u8) "glGetProgramEnvParameterIivNV\0");
    procs.glGetProgramEnvParameterIuivNV = cast(type_of(procs.glGetProgramEnvParameterIuivNV)) GetProcAddress(cast(*u8) "glGetProgramEnvParameterIuivNV\0");
    procs.glProgramSubroutineParametersuivNV = cast(type_of(procs.glProgramSubroutineParametersuivNV)) GetProcAddress(cast(*u8) "glProgramSubroutineParametersuivNV\0");
    procs.glGetProgramSubroutineParameteruivNV = cast(type_of(procs.glGetProgramSubroutineParameteruivNV)) GetProcAddress(cast(*u8) "glGetProgramSubroutineParameteruivNV\0");
    procs.glVertex2hNV = cast(type_of(procs.glVertex2hNV)) GetProcAddress(cast(*u8) "glVertex2hNV\0");
    procs.glVertex2hvNV = cast(type_of(procs.glVertex2hvNV)) GetProcAddress(cast(*u8) "glVertex2hvNV\0");
    procs.glVertex3hNV = cast(type_of(procs.glVertex3hNV)) GetProcAddress(cast(*u8) "glVertex3hNV\0");
    procs.glVertex3hvNV = cast(type_of(procs.glVertex3hvNV)) GetProcAddress(cast(*u8) "glVertex3hvNV\0");
    procs.glVertex4hNV = cast(type_of(procs.glVertex4hNV)) GetProcAddress(cast(*u8) "glVertex4hNV\0");
    procs.glVertex4hvNV = cast(type_of(procs.glVertex4hvNV)) GetProcAddress(cast(*u8) "glVertex4hvNV\0");
    procs.glNormal3hNV = cast(type_of(procs.glNormal3hNV)) GetProcAddress(cast(*u8) "glNormal3hNV\0");
    procs.glNormal3hvNV = cast(type_of(procs.glNormal3hvNV)) GetProcAddress(cast(*u8) "glNormal3hvNV\0");
    procs.glColor3hNV = cast(type_of(procs.glColor3hNV)) GetProcAddress(cast(*u8) "glColor3hNV\0");
    procs.glColor3hvNV = cast(type_of(procs.glColor3hvNV)) GetProcAddress(cast(*u8) "glColor3hvNV\0");
    procs.glColor4hNV = cast(type_of(procs.glColor4hNV)) GetProcAddress(cast(*u8) "glColor4hNV\0");
    procs.glColor4hvNV = cast(type_of(procs.glColor4hvNV)) GetProcAddress(cast(*u8) "glColor4hvNV\0");
    procs.glTexCoord1hNV = cast(type_of(procs.glTexCoord1hNV)) GetProcAddress(cast(*u8) "glTexCoord1hNV\0");
    procs.glTexCoord1hvNV = cast(type_of(procs.glTexCoord1hvNV)) GetProcAddress(cast(*u8) "glTexCoord1hvNV\0");
    procs.glTexCoord2hNV = cast(type_of(procs.glTexCoord2hNV)) GetProcAddress(cast(*u8) "glTexCoord2hNV\0");
    procs.glTexCoord2hvNV = cast(type_of(procs.glTexCoord2hvNV)) GetProcAddress(cast(*u8) "glTexCoord2hvNV\0");
    procs.glTexCoord3hNV = cast(type_of(procs.glTexCoord3hNV)) GetProcAddress(cast(*u8) "glTexCoord3hNV\0");
    procs.glTexCoord3hvNV = cast(type_of(procs.glTexCoord3hvNV)) GetProcAddress(cast(*u8) "glTexCoord3hvNV\0");
    procs.glTexCoord4hNV = cast(type_of(procs.glTexCoord4hNV)) GetProcAddress(cast(*u8) "glTexCoord4hNV\0");
    procs.glTexCoord4hvNV = cast(type_of(procs.glTexCoord4hvNV)) GetProcAddress(cast(*u8) "glTexCoord4hvNV\0");
    procs.glMultiTexCoord1hNV = cast(type_of(procs.glMultiTexCoord1hNV)) GetProcAddress(cast(*u8) "glMultiTexCoord1hNV\0");
    procs.glMultiTexCoord1hvNV = cast(type_of(procs.glMultiTexCoord1hvNV)) GetProcAddress(cast(*u8) "glMultiTexCoord1hvNV\0");
    procs.glMultiTexCoord2hNV = cast(type_of(procs.glMultiTexCoord2hNV)) GetProcAddress(cast(*u8) "glMultiTexCoord2hNV\0");
    procs.glMultiTexCoord2hvNV = cast(type_of(procs.glMultiTexCoord2hvNV)) GetProcAddress(cast(*u8) "glMultiTexCoord2hvNV\0");
    procs.glMultiTexCoord3hNV = cast(type_of(procs.glMultiTexCoord3hNV)) GetProcAddress(cast(*u8) "glMultiTexCoord3hNV\0");
    procs.glMultiTexCoord3hvNV = cast(type_of(procs.glMultiTexCoord3hvNV)) GetProcAddress(cast(*u8) "glMultiTexCoord3hvNV\0");
    procs.glMultiTexCoord4hNV = cast(type_of(procs.glMultiTexCoord4hNV)) GetProcAddress(cast(*u8) "glMultiTexCoord4hNV\0");
    procs.glMultiTexCoord4hvNV = cast(type_of(procs.glMultiTexCoord4hvNV)) GetProcAddress(cast(*u8) "glMultiTexCoord4hvNV\0");
    procs.glFogCoordhNV = cast(type_of(procs.glFogCoordhNV)) GetProcAddress(cast(*u8) "glFogCoordhNV\0");
    procs.glFogCoordhvNV = cast(type_of(procs.glFogCoordhvNV)) GetProcAddress(cast(*u8) "glFogCoordhvNV\0");
    procs.glSecondaryColor3hNV = cast(type_of(procs.glSecondaryColor3hNV)) GetProcAddress(cast(*u8) "glSecondaryColor3hNV\0");
    procs.glSecondaryColor3hvNV = cast(type_of(procs.glSecondaryColor3hvNV)) GetProcAddress(cast(*u8) "glSecondaryColor3hvNV\0");
    procs.glVertexWeighthNV = cast(type_of(procs.glVertexWeighthNV)) GetProcAddress(cast(*u8) "glVertexWeighthNV\0");
    procs.glVertexWeighthvNV = cast(type_of(procs.glVertexWeighthvNV)) GetProcAddress(cast(*u8) "glVertexWeighthvNV\0");
    procs.glVertexAttrib1hNV = cast(type_of(procs.glVertexAttrib1hNV)) GetProcAddress(cast(*u8) "glVertexAttrib1hNV\0");
    procs.glVertexAttrib1hvNV = cast(type_of(procs.glVertexAttrib1hvNV)) GetProcAddress(cast(*u8) "glVertexAttrib1hvNV\0");
    procs.glVertexAttrib2hNV = cast(type_of(procs.glVertexAttrib2hNV)) GetProcAddress(cast(*u8) "glVertexAttrib2hNV\0");
    procs.glVertexAttrib2hvNV = cast(type_of(procs.glVertexAttrib2hvNV)) GetProcAddress(cast(*u8) "glVertexAttrib2hvNV\0");
    procs.glVertexAttrib3hNV = cast(type_of(procs.glVertexAttrib3hNV)) GetProcAddress(cast(*u8) "glVertexAttrib3hNV\0");
    procs.glVertexAttrib3hvNV = cast(type_of(procs.glVertexAttrib3hvNV)) GetProcAddress(cast(*u8) "glVertexAttrib3hvNV\0");
    procs.glVertexAttrib4hNV = cast(type_of(procs.glVertexAttrib4hNV)) GetProcAddress(cast(*u8) "glVertexAttrib4hNV\0");
    procs.glVertexAttrib4hvNV = cast(type_of(procs.glVertexAttrib4hvNV)) GetProcAddress(cast(*u8) "glVertexAttrib4hvNV\0");
    procs.glVertexAttribs1hvNV = cast(type_of(procs.glVertexAttribs1hvNV)) GetProcAddress(cast(*u8) "glVertexAttribs1hvNV\0");
    procs.glVertexAttribs2hvNV = cast(type_of(procs.glVertexAttribs2hvNV)) GetProcAddress(cast(*u8) "glVertexAttribs2hvNV\0");
    procs.glVertexAttribs3hvNV = cast(type_of(procs.glVertexAttribs3hvNV)) GetProcAddress(cast(*u8) "glVertexAttribs3hvNV\0");
    procs.glVertexAttribs4hvNV = cast(type_of(procs.glVertexAttribs4hvNV)) GetProcAddress(cast(*u8) "glVertexAttribs4hvNV\0");
    procs.glGetInternalformatSampleivNV = cast(type_of(procs.glGetInternalformatSampleivNV)) GetProcAddress(cast(*u8) "glGetInternalformatSampleivNV\0");
    procs.glGenOcclusionQueriesNV = cast(type_of(procs.glGenOcclusionQueriesNV)) GetProcAddress(cast(*u8) "glGenOcclusionQueriesNV\0");
    procs.glDeleteOcclusionQueriesNV = cast(type_of(procs.glDeleteOcclusionQueriesNV)) GetProcAddress(cast(*u8) "glDeleteOcclusionQueriesNV\0");
    procs.glIsOcclusionQueryNV = cast(type_of(procs.glIsOcclusionQueryNV)) GetProcAddress(cast(*u8) "glIsOcclusionQueryNV\0");
    procs.glBeginOcclusionQueryNV = cast(type_of(procs.glBeginOcclusionQueryNV)) GetProcAddress(cast(*u8) "glBeginOcclusionQueryNV\0");
    procs.glEndOcclusionQueryNV = cast(type_of(procs.glEndOcclusionQueryNV)) GetProcAddress(cast(*u8) "glEndOcclusionQueryNV\0");
    procs.glGetOcclusionQueryivNV = cast(type_of(procs.glGetOcclusionQueryivNV)) GetProcAddress(cast(*u8) "glGetOcclusionQueryivNV\0");
    procs.glGetOcclusionQueryuivNV = cast(type_of(procs.glGetOcclusionQueryuivNV)) GetProcAddress(cast(*u8) "glGetOcclusionQueryuivNV\0");
    procs.glProgramBufferParametersfvNV = cast(type_of(procs.glProgramBufferParametersfvNV)) GetProcAddress(cast(*u8) "glProgramBufferParametersfvNV\0");
    procs.glProgramBufferParametersIivNV = cast(type_of(procs.glProgramBufferParametersIivNV)) GetProcAddress(cast(*u8) "glProgramBufferParametersIivNV\0");
    procs.glProgramBufferParametersIuivNV = cast(type_of(procs.glProgramBufferParametersIuivNV)) GetProcAddress(cast(*u8) "glProgramBufferParametersIuivNV\0");
    procs.glGenPathsNV = cast(type_of(procs.glGenPathsNV)) GetProcAddress(cast(*u8) "glGenPathsNV\0");
    procs.glDeletePathsNV = cast(type_of(procs.glDeletePathsNV)) GetProcAddress(cast(*u8) "glDeletePathsNV\0");
    procs.glIsPathNV = cast(type_of(procs.glIsPathNV)) GetProcAddress(cast(*u8) "glIsPathNV\0");
    procs.glPathCommandsNV = cast(type_of(procs.glPathCommandsNV)) GetProcAddress(cast(*u8) "glPathCommandsNV\0");
    procs.glPathCoordsNV = cast(type_of(procs.glPathCoordsNV)) GetProcAddress(cast(*u8) "glPathCoordsNV\0");
    procs.glPathSubCommandsNV = cast(type_of(procs.glPathSubCommandsNV)) GetProcAddress(cast(*u8) "glPathSubCommandsNV\0");
    procs.glPathSubCoordsNV = cast(type_of(procs.glPathSubCoordsNV)) GetProcAddress(cast(*u8) "glPathSubCoordsNV\0");
    procs.glPathStringNV = cast(type_of(procs.glPathStringNV)) GetProcAddress(cast(*u8) "glPathStringNV\0");
    procs.glPathGlyphsNV = cast(type_of(procs.glPathGlyphsNV)) GetProcAddress(cast(*u8) "glPathGlyphsNV\0");
    procs.glPathGlyphRangeNV = cast(type_of(procs.glPathGlyphRangeNV)) GetProcAddress(cast(*u8) "glPathGlyphRangeNV\0");
    procs.glWeightPathsNV = cast(type_of(procs.glWeightPathsNV)) GetProcAddress(cast(*u8) "glWeightPathsNV\0");
    procs.glCopyPathNV = cast(type_of(procs.glCopyPathNV)) GetProcAddress(cast(*u8) "glCopyPathNV\0");
    procs.glInterpolatePathsNV = cast(type_of(procs.glInterpolatePathsNV)) GetProcAddress(cast(*u8) "glInterpolatePathsNV\0");
    procs.glTransformPathNV = cast(type_of(procs.glTransformPathNV)) GetProcAddress(cast(*u8) "glTransformPathNV\0");
    procs.glPathParameterivNV = cast(type_of(procs.glPathParameterivNV)) GetProcAddress(cast(*u8) "glPathParameterivNV\0");
    procs.glPathParameteriNV = cast(type_of(procs.glPathParameteriNV)) GetProcAddress(cast(*u8) "glPathParameteriNV\0");
    procs.glPathParameterfvNV = cast(type_of(procs.glPathParameterfvNV)) GetProcAddress(cast(*u8) "glPathParameterfvNV\0");
    procs.glPathParameterfNV = cast(type_of(procs.glPathParameterfNV)) GetProcAddress(cast(*u8) "glPathParameterfNV\0");
    procs.glPathDashArrayNV = cast(type_of(procs.glPathDashArrayNV)) GetProcAddress(cast(*u8) "glPathDashArrayNV\0");
    procs.glPathStencilFuncNV = cast(type_of(procs.glPathStencilFuncNV)) GetProcAddress(cast(*u8) "glPathStencilFuncNV\0");
    procs.glPathStencilDepthOffsetNV = cast(type_of(procs.glPathStencilDepthOffsetNV)) GetProcAddress(cast(*u8) "glPathStencilDepthOffsetNV\0");
    procs.glStencilFillPathNV = cast(type_of(procs.glStencilFillPathNV)) GetProcAddress(cast(*u8) "glStencilFillPathNV\0");
    procs.glStencilStrokePathNV = cast(type_of(procs.glStencilStrokePathNV)) GetProcAddress(cast(*u8) "glStencilStrokePathNV\0");
    procs.glStencilFillPathInstancedNV = cast(type_of(procs.glStencilFillPathInstancedNV)) GetProcAddress(cast(*u8) "glStencilFillPathInstancedNV\0");
    procs.glStencilStrokePathInstancedNV = cast(type_of(procs.glStencilStrokePathInstancedNV)) GetProcAddress(cast(*u8) "glStencilStrokePathInstancedNV\0");
    procs.glPathCoverDepthFuncNV = cast(type_of(procs.glPathCoverDepthFuncNV)) GetProcAddress(cast(*u8) "glPathCoverDepthFuncNV\0");
    procs.glCoverFillPathNV = cast(type_of(procs.glCoverFillPathNV)) GetProcAddress(cast(*u8) "glCoverFillPathNV\0");
    procs.glCoverStrokePathNV = cast(type_of(procs.glCoverStrokePathNV)) GetProcAddress(cast(*u8) "glCoverStrokePathNV\0");
    procs.glCoverFillPathInstancedNV = cast(type_of(procs.glCoverFillPathInstancedNV)) GetProcAddress(cast(*u8) "glCoverFillPathInstancedNV\0");
    procs.glCoverStrokePathInstancedNV = cast(type_of(procs.glCoverStrokePathInstancedNV)) GetProcAddress(cast(*u8) "glCoverStrokePathInstancedNV\0");
    procs.glGetPathParameterivNV = cast(type_of(procs.glGetPathParameterivNV)) GetProcAddress(cast(*u8) "glGetPathParameterivNV\0");
    procs.glGetPathParameterfvNV = cast(type_of(procs.glGetPathParameterfvNV)) GetProcAddress(cast(*u8) "glGetPathParameterfvNV\0");
    procs.glGetPathCommandsNV = cast(type_of(procs.glGetPathCommandsNV)) GetProcAddress(cast(*u8) "glGetPathCommandsNV\0");
    procs.glGetPathCoordsNV = cast(type_of(procs.glGetPathCoordsNV)) GetProcAddress(cast(*u8) "glGetPathCoordsNV\0");
    procs.glGetPathDashArrayNV = cast(type_of(procs.glGetPathDashArrayNV)) GetProcAddress(cast(*u8) "glGetPathDashArrayNV\0");
    procs.glGetPathMetricsNV = cast(type_of(procs.glGetPathMetricsNV)) GetProcAddress(cast(*u8) "glGetPathMetricsNV\0");
    procs.glGetPathMetricRangeNV = cast(type_of(procs.glGetPathMetricRangeNV)) GetProcAddress(cast(*u8) "glGetPathMetricRangeNV\0");
    procs.glGetPathSpacingNV = cast(type_of(procs.glGetPathSpacingNV)) GetProcAddress(cast(*u8) "glGetPathSpacingNV\0");
    procs.glIsPointInFillPathNV = cast(type_of(procs.glIsPointInFillPathNV)) GetProcAddress(cast(*u8) "glIsPointInFillPathNV\0");
    procs.glIsPointInStrokePathNV = cast(type_of(procs.glIsPointInStrokePathNV)) GetProcAddress(cast(*u8) "glIsPointInStrokePathNV\0");
    procs.glGetPathLengthNV = cast(type_of(procs.glGetPathLengthNV)) GetProcAddress(cast(*u8) "glGetPathLengthNV\0");
    procs.glPointAlongPathNV = cast(type_of(procs.glPointAlongPathNV)) GetProcAddress(cast(*u8) "glPointAlongPathNV\0");
    procs.glMatrixLoad3x2fNV = cast(type_of(procs.glMatrixLoad3x2fNV)) GetProcAddress(cast(*u8) "glMatrixLoad3x2fNV\0");
    procs.glMatrixLoad3x3fNV = cast(type_of(procs.glMatrixLoad3x3fNV)) GetProcAddress(cast(*u8) "glMatrixLoad3x3fNV\0");
    procs.glMatrixLoadTranspose3x3fNV = cast(type_of(procs.glMatrixLoadTranspose3x3fNV)) GetProcAddress(cast(*u8) "glMatrixLoadTranspose3x3fNV\0");
    procs.glMatrixMult3x2fNV = cast(type_of(procs.glMatrixMult3x2fNV)) GetProcAddress(cast(*u8) "glMatrixMult3x2fNV\0");
    procs.glMatrixMult3x3fNV = cast(type_of(procs.glMatrixMult3x3fNV)) GetProcAddress(cast(*u8) "glMatrixMult3x3fNV\0");
    procs.glMatrixMultTranspose3x3fNV = cast(type_of(procs.glMatrixMultTranspose3x3fNV)) GetProcAddress(cast(*u8) "glMatrixMultTranspose3x3fNV\0");
    procs.glStencilThenCoverFillPathNV = cast(type_of(procs.glStencilThenCoverFillPathNV)) GetProcAddress(cast(*u8) "glStencilThenCoverFillPathNV\0");
    procs.glStencilThenCoverStrokePathNV = cast(type_of(procs.glStencilThenCoverStrokePathNV)) GetProcAddress(cast(*u8) "glStencilThenCoverStrokePathNV\0");
    procs.glStencilThenCoverFillPathInstancedNV = cast(type_of(procs.glStencilThenCoverFillPathInstancedNV)) GetProcAddress(cast(*u8) "glStencilThenCoverFillPathInstancedNV\0");
    procs.glStencilThenCoverStrokePathInstancedNV = cast(type_of(procs.glStencilThenCoverStrokePathInstancedNV)) GetProcAddress(cast(*u8) "glStencilThenCoverStrokePathInstancedNV\0");
    procs.glPathGlyphIndexRangeNV = cast(type_of(procs.glPathGlyphIndexRangeNV)) GetProcAddress(cast(*u8) "glPathGlyphIndexRangeNV\0");
    procs.glPathGlyphIndexArrayNV = cast(type_of(procs.glPathGlyphIndexArrayNV)) GetProcAddress(cast(*u8) "glPathGlyphIndexArrayNV\0");
    procs.glPathMemoryGlyphIndexArrayNV = cast(type_of(procs.glPathMemoryGlyphIndexArrayNV)) GetProcAddress(cast(*u8) "glPathMemoryGlyphIndexArrayNV\0");
    procs.glProgramPathFragmentInputGenNV = cast(type_of(procs.glProgramPathFragmentInputGenNV)) GetProcAddress(cast(*u8) "glProgramPathFragmentInputGenNV\0");
    procs.glGetProgramResourcefvNV = cast(type_of(procs.glGetProgramResourcefvNV)) GetProcAddress(cast(*u8) "glGetProgramResourcefvNV\0");
    procs.glPathColorGenNV = cast(type_of(procs.glPathColorGenNV)) GetProcAddress(cast(*u8) "glPathColorGenNV\0");
    procs.glPathTexGenNV = cast(type_of(procs.glPathTexGenNV)) GetProcAddress(cast(*u8) "glPathTexGenNV\0");
    procs.glPathFogGenNV = cast(type_of(procs.glPathFogGenNV)) GetProcAddress(cast(*u8) "glPathFogGenNV\0");
    procs.glGetPathColorGenivNV = cast(type_of(procs.glGetPathColorGenivNV)) GetProcAddress(cast(*u8) "glGetPathColorGenivNV\0");
    procs.glGetPathColorGenfvNV = cast(type_of(procs.glGetPathColorGenfvNV)) GetProcAddress(cast(*u8) "glGetPathColorGenfvNV\0");
    procs.glGetPathTexGenivNV = cast(type_of(procs.glGetPathTexGenivNV)) GetProcAddress(cast(*u8) "glGetPathTexGenivNV\0");
    procs.glGetPathTexGenfvNV = cast(type_of(procs.glGetPathTexGenfvNV)) GetProcAddress(cast(*u8) "glGetPathTexGenfvNV\0");
    procs.glPixelDataRangeNV = cast(type_of(procs.glPixelDataRangeNV)) GetProcAddress(cast(*u8) "glPixelDataRangeNV\0");
    procs.glFlushPixelDataRangeNV = cast(type_of(procs.glFlushPixelDataRangeNV)) GetProcAddress(cast(*u8) "glFlushPixelDataRangeNV\0");
    procs.glPointParameteriNV = cast(type_of(procs.glPointParameteriNV)) GetProcAddress(cast(*u8) "glPointParameteriNV\0");
    procs.glPointParameterivNV = cast(type_of(procs.glPointParameterivNV)) GetProcAddress(cast(*u8) "glPointParameterivNV\0");
    procs.glPresentFrameKeyedNV = cast(type_of(procs.glPresentFrameKeyedNV)) GetProcAddress(cast(*u8) "glPresentFrameKeyedNV\0");
    procs.glPresentFrameDualFillNV = cast(type_of(procs.glPresentFrameDualFillNV)) GetProcAddress(cast(*u8) "glPresentFrameDualFillNV\0");
    procs.glGetVideoivNV = cast(type_of(procs.glGetVideoivNV)) GetProcAddress(cast(*u8) "glGetVideoivNV\0");
    procs.glGetVideouivNV = cast(type_of(procs.glGetVideouivNV)) GetProcAddress(cast(*u8) "glGetVideouivNV\0");
    procs.glGetVideoi64vNV = cast(type_of(procs.glGetVideoi64vNV)) GetProcAddress(cast(*u8) "glGetVideoi64vNV\0");
    procs.glGetVideoui64vNV = cast(type_of(procs.glGetVideoui64vNV)) GetProcAddress(cast(*u8) "glGetVideoui64vNV\0");
    procs.glPrimitiveRestartNV = cast(type_of(procs.glPrimitiveRestartNV)) GetProcAddress(cast(*u8) "glPrimitiveRestartNV\0");
    procs.glPrimitiveRestartIndexNV = cast(type_of(procs.glPrimitiveRestartIndexNV)) GetProcAddress(cast(*u8) "glPrimitiveRestartIndexNV\0");
    procs.glQueryResourceNV = cast(type_of(procs.glQueryResourceNV)) GetProcAddress(cast(*u8) "glQueryResourceNV\0");
    procs.glGenQueryResourceTagNV = cast(type_of(procs.glGenQueryResourceTagNV)) GetProcAddress(cast(*u8) "glGenQueryResourceTagNV\0");
    procs.glDeleteQueryResourceTagNV = cast(type_of(procs.glDeleteQueryResourceTagNV)) GetProcAddress(cast(*u8) "glDeleteQueryResourceTagNV\0");
    procs.glQueryResourceTagNV = cast(type_of(procs.glQueryResourceTagNV)) GetProcAddress(cast(*u8) "glQueryResourceTagNV\0");
    procs.glCombinerParameterfvNV = cast(type_of(procs.glCombinerParameterfvNV)) GetProcAddress(cast(*u8) "glCombinerParameterfvNV\0");
    procs.glCombinerParameterfNV = cast(type_of(procs.glCombinerParameterfNV)) GetProcAddress(cast(*u8) "glCombinerParameterfNV\0");
    procs.glCombinerParameterivNV = cast(type_of(procs.glCombinerParameterivNV)) GetProcAddress(cast(*u8) "glCombinerParameterivNV\0");
    procs.glCombinerParameteriNV = cast(type_of(procs.glCombinerParameteriNV)) GetProcAddress(cast(*u8) "glCombinerParameteriNV\0");
    procs.glCombinerInputNV = cast(type_of(procs.glCombinerInputNV)) GetProcAddress(cast(*u8) "glCombinerInputNV\0");
    procs.glCombinerOutputNV = cast(type_of(procs.glCombinerOutputNV)) GetProcAddress(cast(*u8) "glCombinerOutputNV\0");
    procs.glFinalCombinerInputNV = cast(type_of(procs.glFinalCombinerInputNV)) GetProcAddress(cast(*u8) "glFinalCombinerInputNV\0");
    procs.glGetCombinerInputParameterfvNV = cast(type_of(procs.glGetCombinerInputParameterfvNV)) GetProcAddress(cast(*u8) "glGetCombinerInputParameterfvNV\0");
    procs.glGetCombinerInputParameterivNV = cast(type_of(procs.glGetCombinerInputParameterivNV)) GetProcAddress(cast(*u8) "glGetCombinerInputParameterivNV\0");
    procs.glGetCombinerOutputParameterfvNV = cast(type_of(procs.glGetCombinerOutputParameterfvNV)) GetProcAddress(cast(*u8) "glGetCombinerOutputParameterfvNV\0");
    procs.glGetCombinerOutputParameterivNV = cast(type_of(procs.glGetCombinerOutputParameterivNV)) GetProcAddress(cast(*u8) "glGetCombinerOutputParameterivNV\0");
    procs.glGetFinalCombinerInputParameterfvNV = cast(type_of(procs.glGetFinalCombinerInputParameterfvNV)) GetProcAddress(cast(*u8) "glGetFinalCombinerInputParameterfvNV\0");
    procs.glGetFinalCombinerInputParameterivNV = cast(type_of(procs.glGetFinalCombinerInputParameterivNV)) GetProcAddress(cast(*u8) "glGetFinalCombinerInputParameterivNV\0");
    procs.glCombinerStageParameterfvNV = cast(type_of(procs.glCombinerStageParameterfvNV)) GetProcAddress(cast(*u8) "glCombinerStageParameterfvNV\0");
    procs.glGetCombinerStageParameterfvNV = cast(type_of(procs.glGetCombinerStageParameterfvNV)) GetProcAddress(cast(*u8) "glGetCombinerStageParameterfvNV\0");
    procs.glFramebufferSampleLocationsfvNV = cast(type_of(procs.glFramebufferSampleLocationsfvNV)) GetProcAddress(cast(*u8) "glFramebufferSampleLocationsfvNV\0");
    procs.glNamedFramebufferSampleLocationsfvNV = cast(type_of(procs.glNamedFramebufferSampleLocationsfvNV)) GetProcAddress(cast(*u8) "glNamedFramebufferSampleLocationsfvNV\0");
    procs.glResolveDepthValuesNV = cast(type_of(procs.glResolveDepthValuesNV)) GetProcAddress(cast(*u8) "glResolveDepthValuesNV\0");
    procs.glMakeBufferResidentNV = cast(type_of(procs.glMakeBufferResidentNV)) GetProcAddress(cast(*u8) "glMakeBufferResidentNV\0");
    procs.glMakeBufferNonResidentNV = cast(type_of(procs.glMakeBufferNonResidentNV)) GetProcAddress(cast(*u8) "glMakeBufferNonResidentNV\0");
    procs.glIsBufferResidentNV = cast(type_of(procs.glIsBufferResidentNV)) GetProcAddress(cast(*u8) "glIsBufferResidentNV\0");
    procs.glMakeNamedBufferResidentNV = cast(type_of(procs.glMakeNamedBufferResidentNV)) GetProcAddress(cast(*u8) "glMakeNamedBufferResidentNV\0");
    procs.glMakeNamedBufferNonResidentNV = cast(type_of(procs.glMakeNamedBufferNonResidentNV)) GetProcAddress(cast(*u8) "glMakeNamedBufferNonResidentNV\0");
    procs.glIsNamedBufferResidentNV = cast(type_of(procs.glIsNamedBufferResidentNV)) GetProcAddress(cast(*u8) "glIsNamedBufferResidentNV\0");
    procs.glGetBufferParameterui64vNV = cast(type_of(procs.glGetBufferParameterui64vNV)) GetProcAddress(cast(*u8) "glGetBufferParameterui64vNV\0");
    procs.glGetNamedBufferParameterui64vNV = cast(type_of(procs.glGetNamedBufferParameterui64vNV)) GetProcAddress(cast(*u8) "glGetNamedBufferParameterui64vNV\0");
    procs.glGetIntegerui64vNV = cast(type_of(procs.glGetIntegerui64vNV)) GetProcAddress(cast(*u8) "glGetIntegerui64vNV\0");
    procs.glUniformui64NV = cast(type_of(procs.glUniformui64NV)) GetProcAddress(cast(*u8) "glUniformui64NV\0");
    procs.glUniformui64vNV = cast(type_of(procs.glUniformui64vNV)) GetProcAddress(cast(*u8) "glUniformui64vNV\0");
    procs.glProgramUniformui64NV = cast(type_of(procs.glProgramUniformui64NV)) GetProcAddress(cast(*u8) "glProgramUniformui64NV\0");
    procs.glProgramUniformui64vNV = cast(type_of(procs.glProgramUniformui64vNV)) GetProcAddress(cast(*u8) "glProgramUniformui64vNV\0");
    procs.glTextureBarrierNV = cast(type_of(procs.glTextureBarrierNV)) GetProcAddress(cast(*u8) "glTextureBarrierNV\0");
    procs.glTexImage2DMultisampleCoverageNV = cast(type_of(procs.glTexImage2DMultisampleCoverageNV)) GetProcAddress(cast(*u8) "glTexImage2DMultisampleCoverageNV\0");
    procs.glTexImage3DMultisampleCoverageNV = cast(type_of(procs.glTexImage3DMultisampleCoverageNV)) GetProcAddress(cast(*u8) "glTexImage3DMultisampleCoverageNV\0");
    procs.glTextureImage2DMultisampleNV = cast(type_of(procs.glTextureImage2DMultisampleNV)) GetProcAddress(cast(*u8) "glTextureImage2DMultisampleNV\0");
    procs.glTextureImage3DMultisampleNV = cast(type_of(procs.glTextureImage3DMultisampleNV)) GetProcAddress(cast(*u8) "glTextureImage3DMultisampleNV\0");
    procs.glTextureImage2DMultisampleCoverageNV = cast(type_of(procs.glTextureImage2DMultisampleCoverageNV)) GetProcAddress(cast(*u8) "glTextureImage2DMultisampleCoverageNV\0");
    procs.glTextureImage3DMultisampleCoverageNV = cast(type_of(procs.glTextureImage3DMultisampleCoverageNV)) GetProcAddress(cast(*u8) "glTextureImage3DMultisampleCoverageNV\0");
    procs.glBeginTransformFeedbackNV = cast(type_of(procs.glBeginTransformFeedbackNV)) GetProcAddress(cast(*u8) "glBeginTransformFeedbackNV\0");
    procs.glEndTransformFeedbackNV = cast(type_of(procs.glEndTransformFeedbackNV)) GetProcAddress(cast(*u8) "glEndTransformFeedbackNV\0");
    procs.glTransformFeedbackAttribsNV = cast(type_of(procs.glTransformFeedbackAttribsNV)) GetProcAddress(cast(*u8) "glTransformFeedbackAttribsNV\0");
    procs.glBindBufferRangeNV = cast(type_of(procs.glBindBufferRangeNV)) GetProcAddress(cast(*u8) "glBindBufferRangeNV\0");
    procs.glBindBufferOffsetNV = cast(type_of(procs.glBindBufferOffsetNV)) GetProcAddress(cast(*u8) "glBindBufferOffsetNV\0");
    procs.glBindBufferBaseNV = cast(type_of(procs.glBindBufferBaseNV)) GetProcAddress(cast(*u8) "glBindBufferBaseNV\0");
    procs.glTransformFeedbackVaryingsNV = cast(type_of(procs.glTransformFeedbackVaryingsNV)) GetProcAddress(cast(*u8) "glTransformFeedbackVaryingsNV\0");
    procs.glActiveVaryingNV = cast(type_of(procs.glActiveVaryingNV)) GetProcAddress(cast(*u8) "glActiveVaryingNV\0");
    procs.glGetVaryingLocationNV = cast(type_of(procs.glGetVaryingLocationNV)) GetProcAddress(cast(*u8) "glGetVaryingLocationNV\0");
    procs.glGetActiveVaryingNV = cast(type_of(procs.glGetActiveVaryingNV)) GetProcAddress(cast(*u8) "glGetActiveVaryingNV\0");
    procs.glGetTransformFeedbackVaryingNV = cast(type_of(procs.glGetTransformFeedbackVaryingNV)) GetProcAddress(cast(*u8) "glGetTransformFeedbackVaryingNV\0");
    procs.glTransformFeedbackStreamAttribsNV = cast(type_of(procs.glTransformFeedbackStreamAttribsNV)) GetProcAddress(cast(*u8) "glTransformFeedbackStreamAttribsNV\0");
    procs.glBindTransformFeedbackNV = cast(type_of(procs.glBindTransformFeedbackNV)) GetProcAddress(cast(*u8) "glBindTransformFeedbackNV\0");
    procs.glDeleteTransformFeedbacksNV = cast(type_of(procs.glDeleteTransformFeedbacksNV)) GetProcAddress(cast(*u8) "glDeleteTransformFeedbacksNV\0");
    procs.glGenTransformFeedbacksNV = cast(type_of(procs.glGenTransformFeedbacksNV)) GetProcAddress(cast(*u8) "glGenTransformFeedbacksNV\0");
    procs.glIsTransformFeedbackNV = cast(type_of(procs.glIsTransformFeedbackNV)) GetProcAddress(cast(*u8) "glIsTransformFeedbackNV\0");
    procs.glPauseTransformFeedbackNV = cast(type_of(procs.glPauseTransformFeedbackNV)) GetProcAddress(cast(*u8) "glPauseTransformFeedbackNV\0");
    procs.glResumeTransformFeedbackNV = cast(type_of(procs.glResumeTransformFeedbackNV)) GetProcAddress(cast(*u8) "glResumeTransformFeedbackNV\0");
    procs.glDrawTransformFeedbackNV = cast(type_of(procs.glDrawTransformFeedbackNV)) GetProcAddress(cast(*u8) "glDrawTransformFeedbackNV\0");
    procs.glVDPAUInitNV = cast(type_of(procs.glVDPAUInitNV)) GetProcAddress(cast(*u8) "glVDPAUInitNV\0");
    procs.glVDPAUFiniNV = cast(type_of(procs.glVDPAUFiniNV)) GetProcAddress(cast(*u8) "glVDPAUFiniNV\0");
    procs.glFlushVertexArrayRangeNV = cast(type_of(procs.glFlushVertexArrayRangeNV)) GetProcAddress(cast(*u8) "glFlushVertexArrayRangeNV\0");
    procs.glVertexArrayRangeNV = cast(type_of(procs.glVertexArrayRangeNV)) GetProcAddress(cast(*u8) "glVertexArrayRangeNV\0");
    procs.glVertexAttribL1i64NV = cast(type_of(procs.glVertexAttribL1i64NV)) GetProcAddress(cast(*u8) "glVertexAttribL1i64NV\0");
    procs.glVertexAttribL2i64NV = cast(type_of(procs.glVertexAttribL2i64NV)) GetProcAddress(cast(*u8) "glVertexAttribL2i64NV\0");
    procs.glVertexAttribL3i64NV = cast(type_of(procs.glVertexAttribL3i64NV)) GetProcAddress(cast(*u8) "glVertexAttribL3i64NV\0");
    procs.glVertexAttribL4i64NV = cast(type_of(procs.glVertexAttribL4i64NV)) GetProcAddress(cast(*u8) "glVertexAttribL4i64NV\0");
    procs.glVertexAttribL1i64vNV = cast(type_of(procs.glVertexAttribL1i64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL1i64vNV\0");
    procs.glVertexAttribL2i64vNV = cast(type_of(procs.glVertexAttribL2i64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL2i64vNV\0");
    procs.glVertexAttribL3i64vNV = cast(type_of(procs.glVertexAttribL3i64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL3i64vNV\0");
    procs.glVertexAttribL4i64vNV = cast(type_of(procs.glVertexAttribL4i64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL4i64vNV\0");
    procs.glVertexAttribL1ui64NV = cast(type_of(procs.glVertexAttribL1ui64NV)) GetProcAddress(cast(*u8) "glVertexAttribL1ui64NV\0");
    procs.glVertexAttribL2ui64NV = cast(type_of(procs.glVertexAttribL2ui64NV)) GetProcAddress(cast(*u8) "glVertexAttribL2ui64NV\0");
    procs.glVertexAttribL3ui64NV = cast(type_of(procs.glVertexAttribL3ui64NV)) GetProcAddress(cast(*u8) "glVertexAttribL3ui64NV\0");
    procs.glVertexAttribL4ui64NV = cast(type_of(procs.glVertexAttribL4ui64NV)) GetProcAddress(cast(*u8) "glVertexAttribL4ui64NV\0");
    procs.glVertexAttribL1ui64vNV = cast(type_of(procs.glVertexAttribL1ui64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL1ui64vNV\0");
    procs.glVertexAttribL2ui64vNV = cast(type_of(procs.glVertexAttribL2ui64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL2ui64vNV\0");
    procs.glVertexAttribL3ui64vNV = cast(type_of(procs.glVertexAttribL3ui64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL3ui64vNV\0");
    procs.glVertexAttribL4ui64vNV = cast(type_of(procs.glVertexAttribL4ui64vNV)) GetProcAddress(cast(*u8) "glVertexAttribL4ui64vNV\0");
    procs.glGetVertexAttribLi64vNV = cast(type_of(procs.glGetVertexAttribLi64vNV)) GetProcAddress(cast(*u8) "glGetVertexAttribLi64vNV\0");
    procs.glGetVertexAttribLui64vNV = cast(type_of(procs.glGetVertexAttribLui64vNV)) GetProcAddress(cast(*u8) "glGetVertexAttribLui64vNV\0");
    procs.glVertexAttribLFormatNV = cast(type_of(procs.glVertexAttribLFormatNV)) GetProcAddress(cast(*u8) "glVertexAttribLFormatNV\0");
    procs.glBufferAddressRangeNV = cast(type_of(procs.glBufferAddressRangeNV)) GetProcAddress(cast(*u8) "glBufferAddressRangeNV\0");
    procs.glVertexFormatNV = cast(type_of(procs.glVertexFormatNV)) GetProcAddress(cast(*u8) "glVertexFormatNV\0");
    procs.glNormalFormatNV = cast(type_of(procs.glNormalFormatNV)) GetProcAddress(cast(*u8) "glNormalFormatNV\0");
    procs.glColorFormatNV = cast(type_of(procs.glColorFormatNV)) GetProcAddress(cast(*u8) "glColorFormatNV\0");
    procs.glIndexFormatNV = cast(type_of(procs.glIndexFormatNV)) GetProcAddress(cast(*u8) "glIndexFormatNV\0");
    procs.glTexCoordFormatNV = cast(type_of(procs.glTexCoordFormatNV)) GetProcAddress(cast(*u8) "glTexCoordFormatNV\0");
    procs.glEdgeFlagFormatNV = cast(type_of(procs.glEdgeFlagFormatNV)) GetProcAddress(cast(*u8) "glEdgeFlagFormatNV\0");
    procs.glSecondaryColorFormatNV = cast(type_of(procs.glSecondaryColorFormatNV)) GetProcAddress(cast(*u8) "glSecondaryColorFormatNV\0");
    procs.glFogCoordFormatNV = cast(type_of(procs.glFogCoordFormatNV)) GetProcAddress(cast(*u8) "glFogCoordFormatNV\0");
    procs.glVertexAttribFormatNV = cast(type_of(procs.glVertexAttribFormatNV)) GetProcAddress(cast(*u8) "glVertexAttribFormatNV\0");
    procs.glVertexAttribIFormatNV = cast(type_of(procs.glVertexAttribIFormatNV)) GetProcAddress(cast(*u8) "glVertexAttribIFormatNV\0");
    procs.glGetIntegerui64i_vNV = cast(type_of(procs.glGetIntegerui64i_vNV)) GetProcAddress(cast(*u8) "glGetIntegerui64i_vNV\0");
    procs.glAreProgramsResidentNV = cast(type_of(procs.glAreProgramsResidentNV)) GetProcAddress(cast(*u8) "glAreProgramsResidentNV\0");
    procs.glBindProgramNV = cast(type_of(procs.glBindProgramNV)) GetProcAddress(cast(*u8) "glBindProgramNV\0");
    procs.glDeleteProgramsNV = cast(type_of(procs.glDeleteProgramsNV)) GetProcAddress(cast(*u8) "glDeleteProgramsNV\0");
    procs.glExecuteProgramNV = cast(type_of(procs.glExecuteProgramNV)) GetProcAddress(cast(*u8) "glExecuteProgramNV\0");
    procs.glGenProgramsNV = cast(type_of(procs.glGenProgramsNV)) GetProcAddress(cast(*u8) "glGenProgramsNV\0");
    procs.glGetProgramParameterdvNV = cast(type_of(procs.glGetProgramParameterdvNV)) GetProcAddress(cast(*u8) "glGetProgramParameterdvNV\0");
    procs.glGetProgramParameterfvNV = cast(type_of(procs.glGetProgramParameterfvNV)) GetProcAddress(cast(*u8) "glGetProgramParameterfvNV\0");
    procs.glGetProgramivNV = cast(type_of(procs.glGetProgramivNV)) GetProcAddress(cast(*u8) "glGetProgramivNV\0");
    procs.glGetProgramStringNV = cast(type_of(procs.glGetProgramStringNV)) GetProcAddress(cast(*u8) "glGetProgramStringNV\0");
    procs.glGetTrackMatrixivNV = cast(type_of(procs.glGetTrackMatrixivNV)) GetProcAddress(cast(*u8) "glGetTrackMatrixivNV\0");
    procs.glGetVertexAttribdvNV = cast(type_of(procs.glGetVertexAttribdvNV)) GetProcAddress(cast(*u8) "glGetVertexAttribdvNV\0");
    procs.glGetVertexAttribfvNV = cast(type_of(procs.glGetVertexAttribfvNV)) GetProcAddress(cast(*u8) "glGetVertexAttribfvNV\0");
    procs.glGetVertexAttribivNV = cast(type_of(procs.glGetVertexAttribivNV)) GetProcAddress(cast(*u8) "glGetVertexAttribivNV\0");
    procs.glGetVertexAttribPointervNV = cast(type_of(procs.glGetVertexAttribPointervNV)) GetProcAddress(cast(*u8) "glGetVertexAttribPointervNV\0");
    procs.glIsProgramNV = cast(type_of(procs.glIsProgramNV)) GetProcAddress(cast(*u8) "glIsProgramNV\0");
    procs.glLoadProgramNV = cast(type_of(procs.glLoadProgramNV)) GetProcAddress(cast(*u8) "glLoadProgramNV\0");
    procs.glProgramParameter4dNV = cast(type_of(procs.glProgramParameter4dNV)) GetProcAddress(cast(*u8) "glProgramParameter4dNV\0");
    procs.glProgramParameter4dvNV = cast(type_of(procs.glProgramParameter4dvNV)) GetProcAddress(cast(*u8) "glProgramParameter4dvNV\0");
    procs.glProgramParameter4fNV = cast(type_of(procs.glProgramParameter4fNV)) GetProcAddress(cast(*u8) "glProgramParameter4fNV\0");
    procs.glProgramParameter4fvNV = cast(type_of(procs.glProgramParameter4fvNV)) GetProcAddress(cast(*u8) "glProgramParameter4fvNV\0");
    procs.glProgramParameters4dvNV = cast(type_of(procs.glProgramParameters4dvNV)) GetProcAddress(cast(*u8) "glProgramParameters4dvNV\0");
    procs.glProgramParameters4fvNV = cast(type_of(procs.glProgramParameters4fvNV)) GetProcAddress(cast(*u8) "glProgramParameters4fvNV\0");
    procs.glRequestResidentProgramsNV = cast(type_of(procs.glRequestResidentProgramsNV)) GetProcAddress(cast(*u8) "glRequestResidentProgramsNV\0");
    procs.glTrackMatrixNV = cast(type_of(procs.glTrackMatrixNV)) GetProcAddress(cast(*u8) "glTrackMatrixNV\0");
    procs.glVertexAttribPointerNV = cast(type_of(procs.glVertexAttribPointerNV)) GetProcAddress(cast(*u8) "glVertexAttribPointerNV\0");
    procs.glVertexAttrib1dNV = cast(type_of(procs.glVertexAttrib1dNV)) GetProcAddress(cast(*u8) "glVertexAttrib1dNV\0");
    procs.glVertexAttrib1dvNV = cast(type_of(procs.glVertexAttrib1dvNV)) GetProcAddress(cast(*u8) "glVertexAttrib1dvNV\0");
    procs.glVertexAttrib1fNV = cast(type_of(procs.glVertexAttrib1fNV)) GetProcAddress(cast(*u8) "glVertexAttrib1fNV\0");
    procs.glVertexAttrib1fvNV = cast(type_of(procs.glVertexAttrib1fvNV)) GetProcAddress(cast(*u8) "glVertexAttrib1fvNV\0");
    procs.glVertexAttrib1sNV = cast(type_of(procs.glVertexAttrib1sNV)) GetProcAddress(cast(*u8) "glVertexAttrib1sNV\0");
    procs.glVertexAttrib1svNV = cast(type_of(procs.glVertexAttrib1svNV)) GetProcAddress(cast(*u8) "glVertexAttrib1svNV\0");
    procs.glVertexAttrib2dNV = cast(type_of(procs.glVertexAttrib2dNV)) GetProcAddress(cast(*u8) "glVertexAttrib2dNV\0");
    procs.glVertexAttrib2dvNV = cast(type_of(procs.glVertexAttrib2dvNV)) GetProcAddress(cast(*u8) "glVertexAttrib2dvNV\0");
    procs.glVertexAttrib2fNV = cast(type_of(procs.glVertexAttrib2fNV)) GetProcAddress(cast(*u8) "glVertexAttrib2fNV\0");
    procs.glVertexAttrib2fvNV = cast(type_of(procs.glVertexAttrib2fvNV)) GetProcAddress(cast(*u8) "glVertexAttrib2fvNV\0");
    procs.glVertexAttrib2sNV = cast(type_of(procs.glVertexAttrib2sNV)) GetProcAddress(cast(*u8) "glVertexAttrib2sNV\0");
    procs.glVertexAttrib2svNV = cast(type_of(procs.glVertexAttrib2svNV)) GetProcAddress(cast(*u8) "glVertexAttrib2svNV\0");
    procs.glVertexAttrib3dNV = cast(type_of(procs.glVertexAttrib3dNV)) GetProcAddress(cast(*u8) "glVertexAttrib3dNV\0");
    procs.glVertexAttrib3dvNV = cast(type_of(procs.glVertexAttrib3dvNV)) GetProcAddress(cast(*u8) "glVertexAttrib3dvNV\0");
    procs.glVertexAttrib3fNV = cast(type_of(procs.glVertexAttrib3fNV)) GetProcAddress(cast(*u8) "glVertexAttrib3fNV\0");
    procs.glVertexAttrib3fvNV = cast(type_of(procs.glVertexAttrib3fvNV)) GetProcAddress(cast(*u8) "glVertexAttrib3fvNV\0");
    procs.glVertexAttrib3sNV = cast(type_of(procs.glVertexAttrib3sNV)) GetProcAddress(cast(*u8) "glVertexAttrib3sNV\0");
    procs.glVertexAttrib3svNV = cast(type_of(procs.glVertexAttrib3svNV)) GetProcAddress(cast(*u8) "glVertexAttrib3svNV\0");
    procs.glVertexAttrib4dNV = cast(type_of(procs.glVertexAttrib4dNV)) GetProcAddress(cast(*u8) "glVertexAttrib4dNV\0");
    procs.glVertexAttrib4dvNV = cast(type_of(procs.glVertexAttrib4dvNV)) GetProcAddress(cast(*u8) "glVertexAttrib4dvNV\0");
    procs.glVertexAttrib4fNV = cast(type_of(procs.glVertexAttrib4fNV)) GetProcAddress(cast(*u8) "glVertexAttrib4fNV\0");
    procs.glVertexAttrib4fvNV = cast(type_of(procs.glVertexAttrib4fvNV)) GetProcAddress(cast(*u8) "glVertexAttrib4fvNV\0");
    procs.glVertexAttrib4sNV = cast(type_of(procs.glVertexAttrib4sNV)) GetProcAddress(cast(*u8) "glVertexAttrib4sNV\0");
    procs.glVertexAttrib4svNV = cast(type_of(procs.glVertexAttrib4svNV)) GetProcAddress(cast(*u8) "glVertexAttrib4svNV\0");
    procs.glVertexAttrib4ubNV = cast(type_of(procs.glVertexAttrib4ubNV)) GetProcAddress(cast(*u8) "glVertexAttrib4ubNV\0");
    procs.glVertexAttrib4ubvNV = cast(type_of(procs.glVertexAttrib4ubvNV)) GetProcAddress(cast(*u8) "glVertexAttrib4ubvNV\0");
    procs.glVertexAttribs1dvNV = cast(type_of(procs.glVertexAttribs1dvNV)) GetProcAddress(cast(*u8) "glVertexAttribs1dvNV\0");
    procs.glVertexAttribs1fvNV = cast(type_of(procs.glVertexAttribs1fvNV)) GetProcAddress(cast(*u8) "glVertexAttribs1fvNV\0");
    procs.glVertexAttribs1svNV = cast(type_of(procs.glVertexAttribs1svNV)) GetProcAddress(cast(*u8) "glVertexAttribs1svNV\0");
    procs.glVertexAttribs2dvNV = cast(type_of(procs.glVertexAttribs2dvNV)) GetProcAddress(cast(*u8) "glVertexAttribs2dvNV\0");
    procs.glVertexAttribs2fvNV = cast(type_of(procs.glVertexAttribs2fvNV)) GetProcAddress(cast(*u8) "glVertexAttribs2fvNV\0");
    procs.glVertexAttribs2svNV = cast(type_of(procs.glVertexAttribs2svNV)) GetProcAddress(cast(*u8) "glVertexAttribs2svNV\0");
    procs.glVertexAttribs3dvNV = cast(type_of(procs.glVertexAttribs3dvNV)) GetProcAddress(cast(*u8) "glVertexAttribs3dvNV\0");
    procs.glVertexAttribs3fvNV = cast(type_of(procs.glVertexAttribs3fvNV)) GetProcAddress(cast(*u8) "glVertexAttribs3fvNV\0");
    procs.glVertexAttribs3svNV = cast(type_of(procs.glVertexAttribs3svNV)) GetProcAddress(cast(*u8) "glVertexAttribs3svNV\0");
    procs.glVertexAttribs4dvNV = cast(type_of(procs.glVertexAttribs4dvNV)) GetProcAddress(cast(*u8) "glVertexAttribs4dvNV\0");
    procs.glVertexAttribs4fvNV = cast(type_of(procs.glVertexAttribs4fvNV)) GetProcAddress(cast(*u8) "glVertexAttribs4fvNV\0");
    procs.glVertexAttribs4svNV = cast(type_of(procs.glVertexAttribs4svNV)) GetProcAddress(cast(*u8) "glVertexAttribs4svNV\0");
    procs.glVertexAttribs4ubvNV = cast(type_of(procs.glVertexAttribs4ubvNV)) GetProcAddress(cast(*u8) "glVertexAttribs4ubvNV\0");
    procs.glVertexAttribI1iEXT = cast(type_of(procs.glVertexAttribI1iEXT)) GetProcAddress(cast(*u8) "glVertexAttribI1iEXT\0");
    procs.glVertexAttribI2iEXT = cast(type_of(procs.glVertexAttribI2iEXT)) GetProcAddress(cast(*u8) "glVertexAttribI2iEXT\0");
    procs.glVertexAttribI3iEXT = cast(type_of(procs.glVertexAttribI3iEXT)) GetProcAddress(cast(*u8) "glVertexAttribI3iEXT\0");
    procs.glVertexAttribI4iEXT = cast(type_of(procs.glVertexAttribI4iEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4iEXT\0");
    procs.glVertexAttribI1uiEXT = cast(type_of(procs.glVertexAttribI1uiEXT)) GetProcAddress(cast(*u8) "glVertexAttribI1uiEXT\0");
    procs.glVertexAttribI2uiEXT = cast(type_of(procs.glVertexAttribI2uiEXT)) GetProcAddress(cast(*u8) "glVertexAttribI2uiEXT\0");
    procs.glVertexAttribI3uiEXT = cast(type_of(procs.glVertexAttribI3uiEXT)) GetProcAddress(cast(*u8) "glVertexAttribI3uiEXT\0");
    procs.glVertexAttribI4uiEXT = cast(type_of(procs.glVertexAttribI4uiEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4uiEXT\0");
    procs.glVertexAttribI1ivEXT = cast(type_of(procs.glVertexAttribI1ivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI1ivEXT\0");
    procs.glVertexAttribI2ivEXT = cast(type_of(procs.glVertexAttribI2ivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI2ivEXT\0");
    procs.glVertexAttribI3ivEXT = cast(type_of(procs.glVertexAttribI3ivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI3ivEXT\0");
    procs.glVertexAttribI4ivEXT = cast(type_of(procs.glVertexAttribI4ivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4ivEXT\0");
    procs.glVertexAttribI1uivEXT = cast(type_of(procs.glVertexAttribI1uivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI1uivEXT\0");
    procs.glVertexAttribI2uivEXT = cast(type_of(procs.glVertexAttribI2uivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI2uivEXT\0");
    procs.glVertexAttribI3uivEXT = cast(type_of(procs.glVertexAttribI3uivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI3uivEXT\0");
    procs.glVertexAttribI4uivEXT = cast(type_of(procs.glVertexAttribI4uivEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4uivEXT\0");
    procs.glVertexAttribI4bvEXT = cast(type_of(procs.glVertexAttribI4bvEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4bvEXT\0");
    procs.glVertexAttribI4svEXT = cast(type_of(procs.glVertexAttribI4svEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4svEXT\0");
    procs.glVertexAttribI4ubvEXT = cast(type_of(procs.glVertexAttribI4ubvEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4ubvEXT\0");
    procs.glVertexAttribI4usvEXT = cast(type_of(procs.glVertexAttribI4usvEXT)) GetProcAddress(cast(*u8) "glVertexAttribI4usvEXT\0");
    procs.glVertexAttribIPointerEXT = cast(type_of(procs.glVertexAttribIPointerEXT)) GetProcAddress(cast(*u8) "glVertexAttribIPointerEXT\0");
    procs.glGetVertexAttribIivEXT = cast(type_of(procs.glGetVertexAttribIivEXT)) GetProcAddress(cast(*u8) "glGetVertexAttribIivEXT\0");
    procs.glGetVertexAttribIuivEXT = cast(type_of(procs.glGetVertexAttribIuivEXT)) GetProcAddress(cast(*u8) "glGetVertexAttribIuivEXT\0");
    procs.glBeginVideoCaptureNV = cast(type_of(procs.glBeginVideoCaptureNV)) GetProcAddress(cast(*u8) "glBeginVideoCaptureNV\0");
    procs.glBindVideoCaptureStreamBufferNV = cast(type_of(procs.glBindVideoCaptureStreamBufferNV)) GetProcAddress(cast(*u8) "glBindVideoCaptureStreamBufferNV\0");
    procs.glBindVideoCaptureStreamTextureNV = cast(type_of(procs.glBindVideoCaptureStreamTextureNV)) GetProcAddress(cast(*u8) "glBindVideoCaptureStreamTextureNV\0");
    procs.glEndVideoCaptureNV = cast(type_of(procs.glEndVideoCaptureNV)) GetProcAddress(cast(*u8) "glEndVideoCaptureNV\0");
    procs.glGetVideoCaptureivNV = cast(type_of(procs.glGetVideoCaptureivNV)) GetProcAddress(cast(*u8) "glGetVideoCaptureivNV\0");
    procs.glGetVideoCaptureStreamivNV = cast(type_of(procs.glGetVideoCaptureStreamivNV)) GetProcAddress(cast(*u8) "glGetVideoCaptureStreamivNV\0");
    procs.glGetVideoCaptureStreamfvNV = cast(type_of(procs.glGetVideoCaptureStreamfvNV)) GetProcAddress(cast(*u8) "glGetVideoCaptureStreamfvNV\0");
    procs.glGetVideoCaptureStreamdvNV = cast(type_of(procs.glGetVideoCaptureStreamdvNV)) GetProcAddress(cast(*u8) "glGetVideoCaptureStreamdvNV\0");
    procs.glVideoCaptureNV = cast(type_of(procs.glVideoCaptureNV)) GetProcAddress(cast(*u8) "glVideoCaptureNV\0");
    procs.glVideoCaptureStreamParameterivNV = cast(type_of(procs.glVideoCaptureStreamParameterivNV)) GetProcAddress(cast(*u8) "glVideoCaptureStreamParameterivNV\0");
    procs.glVideoCaptureStreamParameterfvNV = cast(type_of(procs.glVideoCaptureStreamParameterfvNV)) GetProcAddress(cast(*u8) "glVideoCaptureStreamParameterfvNV\0");
    procs.glVideoCaptureStreamParameterdvNV = cast(type_of(procs.glVideoCaptureStreamParameterdvNV)) GetProcAddress(cast(*u8) "glVideoCaptureStreamParameterdvNV\0");
    procs.glViewportSwizzleNV = cast(type_of(procs.glViewportSwizzleNV)) GetProcAddress(cast(*u8) "glViewportSwizzleNV\0");
    procs.glMultiTexCoord1bOES = cast(type_of(procs.glMultiTexCoord1bOES)) GetProcAddress(cast(*u8) "glMultiTexCoord1bOES\0");
    procs.glMultiTexCoord1bvOES = cast(type_of(procs.glMultiTexCoord1bvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord1bvOES\0");
    procs.glMultiTexCoord2bOES = cast(type_of(procs.glMultiTexCoord2bOES)) GetProcAddress(cast(*u8) "glMultiTexCoord2bOES\0");
    procs.glMultiTexCoord2bvOES = cast(type_of(procs.glMultiTexCoord2bvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord2bvOES\0");
    procs.glMultiTexCoord3bOES = cast(type_of(procs.glMultiTexCoord3bOES)) GetProcAddress(cast(*u8) "glMultiTexCoord3bOES\0");
    procs.glMultiTexCoord3bvOES = cast(type_of(procs.glMultiTexCoord3bvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord3bvOES\0");
    procs.glMultiTexCoord4bOES = cast(type_of(procs.glMultiTexCoord4bOES)) GetProcAddress(cast(*u8) "glMultiTexCoord4bOES\0");
    procs.glMultiTexCoord4bvOES = cast(type_of(procs.glMultiTexCoord4bvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord4bvOES\0");
    procs.glTexCoord1bOES = cast(type_of(procs.glTexCoord1bOES)) GetProcAddress(cast(*u8) "glTexCoord1bOES\0");
    procs.glTexCoord1bvOES = cast(type_of(procs.glTexCoord1bvOES)) GetProcAddress(cast(*u8) "glTexCoord1bvOES\0");
    procs.glTexCoord2bOES = cast(type_of(procs.glTexCoord2bOES)) GetProcAddress(cast(*u8) "glTexCoord2bOES\0");
    procs.glTexCoord2bvOES = cast(type_of(procs.glTexCoord2bvOES)) GetProcAddress(cast(*u8) "glTexCoord2bvOES\0");
    procs.glTexCoord3bOES = cast(type_of(procs.glTexCoord3bOES)) GetProcAddress(cast(*u8) "glTexCoord3bOES\0");
    procs.glTexCoord3bvOES = cast(type_of(procs.glTexCoord3bvOES)) GetProcAddress(cast(*u8) "glTexCoord3bvOES\0");
    procs.glTexCoord4bOES = cast(type_of(procs.glTexCoord4bOES)) GetProcAddress(cast(*u8) "glTexCoord4bOES\0");
    procs.glTexCoord4bvOES = cast(type_of(procs.glTexCoord4bvOES)) GetProcAddress(cast(*u8) "glTexCoord4bvOES\0");
    procs.glVertex2bOES = cast(type_of(procs.glVertex2bOES)) GetProcAddress(cast(*u8) "glVertex2bOES\0");
    procs.glVertex2bvOES = cast(type_of(procs.glVertex2bvOES)) GetProcAddress(cast(*u8) "glVertex2bvOES\0");
    procs.glVertex3bOES = cast(type_of(procs.glVertex3bOES)) GetProcAddress(cast(*u8) "glVertex3bOES\0");
    procs.glVertex3bvOES = cast(type_of(procs.glVertex3bvOES)) GetProcAddress(cast(*u8) "glVertex3bvOES\0");
    procs.glVertex4bOES = cast(type_of(procs.glVertex4bOES)) GetProcAddress(cast(*u8) "glVertex4bOES\0");
    procs.glVertex4bvOES = cast(type_of(procs.glVertex4bvOES)) GetProcAddress(cast(*u8) "glVertex4bvOES\0");
    procs.glAlphaFuncxOES = cast(type_of(procs.glAlphaFuncxOES)) GetProcAddress(cast(*u8) "glAlphaFuncxOES\0");
    procs.glClearColorxOES = cast(type_of(procs.glClearColorxOES)) GetProcAddress(cast(*u8) "glClearColorxOES\0");
    procs.glClearDepthxOES = cast(type_of(procs.glClearDepthxOES)) GetProcAddress(cast(*u8) "glClearDepthxOES\0");
    procs.glClipPlanexOES = cast(type_of(procs.glClipPlanexOES)) GetProcAddress(cast(*u8) "glClipPlanexOES\0");
    procs.glColor4xOES = cast(type_of(procs.glColor4xOES)) GetProcAddress(cast(*u8) "glColor4xOES\0");
    procs.glDepthRangexOES = cast(type_of(procs.glDepthRangexOES)) GetProcAddress(cast(*u8) "glDepthRangexOES\0");
    procs.glFogxOES = cast(type_of(procs.glFogxOES)) GetProcAddress(cast(*u8) "glFogxOES\0");
    procs.glFogxvOES = cast(type_of(procs.glFogxvOES)) GetProcAddress(cast(*u8) "glFogxvOES\0");
    procs.glFrustumxOES = cast(type_of(procs.glFrustumxOES)) GetProcAddress(cast(*u8) "glFrustumxOES\0");
    procs.glGetClipPlanexOES = cast(type_of(procs.glGetClipPlanexOES)) GetProcAddress(cast(*u8) "glGetClipPlanexOES\0");
    procs.glGetFixedvOES = cast(type_of(procs.glGetFixedvOES)) GetProcAddress(cast(*u8) "glGetFixedvOES\0");
    procs.glGetTexEnvxvOES = cast(type_of(procs.glGetTexEnvxvOES)) GetProcAddress(cast(*u8) "glGetTexEnvxvOES\0");
    procs.glGetTexParameterxvOES = cast(type_of(procs.glGetTexParameterxvOES)) GetProcAddress(cast(*u8) "glGetTexParameterxvOES\0");
    procs.glLightModelxOES = cast(type_of(procs.glLightModelxOES)) GetProcAddress(cast(*u8) "glLightModelxOES\0");
    procs.glLightModelxvOES = cast(type_of(procs.glLightModelxvOES)) GetProcAddress(cast(*u8) "glLightModelxvOES\0");
    procs.glLightxOES = cast(type_of(procs.glLightxOES)) GetProcAddress(cast(*u8) "glLightxOES\0");
    procs.glLightxvOES = cast(type_of(procs.glLightxvOES)) GetProcAddress(cast(*u8) "glLightxvOES\0");
    procs.glLineWidthxOES = cast(type_of(procs.glLineWidthxOES)) GetProcAddress(cast(*u8) "glLineWidthxOES\0");
    procs.glLoadMatrixxOES = cast(type_of(procs.glLoadMatrixxOES)) GetProcAddress(cast(*u8) "glLoadMatrixxOES\0");
    procs.glMaterialxOES = cast(type_of(procs.glMaterialxOES)) GetProcAddress(cast(*u8) "glMaterialxOES\0");
    procs.glMaterialxvOES = cast(type_of(procs.glMaterialxvOES)) GetProcAddress(cast(*u8) "glMaterialxvOES\0");
    procs.glMultMatrixxOES = cast(type_of(procs.glMultMatrixxOES)) GetProcAddress(cast(*u8) "glMultMatrixxOES\0");
    procs.glMultiTexCoord4xOES = cast(type_of(procs.glMultiTexCoord4xOES)) GetProcAddress(cast(*u8) "glMultiTexCoord4xOES\0");
    procs.glNormal3xOES = cast(type_of(procs.glNormal3xOES)) GetProcAddress(cast(*u8) "glNormal3xOES\0");
    procs.glOrthoxOES = cast(type_of(procs.glOrthoxOES)) GetProcAddress(cast(*u8) "glOrthoxOES\0");
    procs.glPointParameterxvOES = cast(type_of(procs.glPointParameterxvOES)) GetProcAddress(cast(*u8) "glPointParameterxvOES\0");
    procs.glPointSizexOES = cast(type_of(procs.glPointSizexOES)) GetProcAddress(cast(*u8) "glPointSizexOES\0");
    procs.glPolygonOffsetxOES = cast(type_of(procs.glPolygonOffsetxOES)) GetProcAddress(cast(*u8) "glPolygonOffsetxOES\0");
    procs.glRotatexOES = cast(type_of(procs.glRotatexOES)) GetProcAddress(cast(*u8) "glRotatexOES\0");
    procs.glScalexOES = cast(type_of(procs.glScalexOES)) GetProcAddress(cast(*u8) "glScalexOES\0");
    procs.glTexEnvxOES = cast(type_of(procs.glTexEnvxOES)) GetProcAddress(cast(*u8) "glTexEnvxOES\0");
    procs.glTexEnvxvOES = cast(type_of(procs.glTexEnvxvOES)) GetProcAddress(cast(*u8) "glTexEnvxvOES\0");
    procs.glTexParameterxOES = cast(type_of(procs.glTexParameterxOES)) GetProcAddress(cast(*u8) "glTexParameterxOES\0");
    procs.glTexParameterxvOES = cast(type_of(procs.glTexParameterxvOES)) GetProcAddress(cast(*u8) "glTexParameterxvOES\0");
    procs.glTranslatexOES = cast(type_of(procs.glTranslatexOES)) GetProcAddress(cast(*u8) "glTranslatexOES\0");
    procs.glGetLightxvOES = cast(type_of(procs.glGetLightxvOES)) GetProcAddress(cast(*u8) "glGetLightxvOES\0");
    procs.glGetMaterialxvOES = cast(type_of(procs.glGetMaterialxvOES)) GetProcAddress(cast(*u8) "glGetMaterialxvOES\0");
    procs.glPointParameterxOES = cast(type_of(procs.glPointParameterxOES)) GetProcAddress(cast(*u8) "glPointParameterxOES\0");
    procs.glSampleCoveragexOES = cast(type_of(procs.glSampleCoveragexOES)) GetProcAddress(cast(*u8) "glSampleCoveragexOES\0");
    procs.glAccumxOES = cast(type_of(procs.glAccumxOES)) GetProcAddress(cast(*u8) "glAccumxOES\0");
    procs.glBitmapxOES = cast(type_of(procs.glBitmapxOES)) GetProcAddress(cast(*u8) "glBitmapxOES\0");
    procs.glBlendColorxOES = cast(type_of(procs.glBlendColorxOES)) GetProcAddress(cast(*u8) "glBlendColorxOES\0");
    procs.glClearAccumxOES = cast(type_of(procs.glClearAccumxOES)) GetProcAddress(cast(*u8) "glClearAccumxOES\0");
    procs.glColor3xOES = cast(type_of(procs.glColor3xOES)) GetProcAddress(cast(*u8) "glColor3xOES\0");
    procs.glColor3xvOES = cast(type_of(procs.glColor3xvOES)) GetProcAddress(cast(*u8) "glColor3xvOES\0");
    procs.glColor4xvOES = cast(type_of(procs.glColor4xvOES)) GetProcAddress(cast(*u8) "glColor4xvOES\0");
    procs.glConvolutionParameterxOES = cast(type_of(procs.glConvolutionParameterxOES)) GetProcAddress(cast(*u8) "glConvolutionParameterxOES\0");
    procs.glConvolutionParameterxvOES = cast(type_of(procs.glConvolutionParameterxvOES)) GetProcAddress(cast(*u8) "glConvolutionParameterxvOES\0");
    procs.glEvalCoord1xOES = cast(type_of(procs.glEvalCoord1xOES)) GetProcAddress(cast(*u8) "glEvalCoord1xOES\0");
    procs.glEvalCoord1xvOES = cast(type_of(procs.glEvalCoord1xvOES)) GetProcAddress(cast(*u8) "glEvalCoord1xvOES\0");
    procs.glEvalCoord2xOES = cast(type_of(procs.glEvalCoord2xOES)) GetProcAddress(cast(*u8) "glEvalCoord2xOES\0");
    procs.glEvalCoord2xvOES = cast(type_of(procs.glEvalCoord2xvOES)) GetProcAddress(cast(*u8) "glEvalCoord2xvOES\0");
    procs.glFeedbackBufferxOES = cast(type_of(procs.glFeedbackBufferxOES)) GetProcAddress(cast(*u8) "glFeedbackBufferxOES\0");
    procs.glGetConvolutionParameterxvOES = cast(type_of(procs.glGetConvolutionParameterxvOES)) GetProcAddress(cast(*u8) "glGetConvolutionParameterxvOES\0");
    procs.glGetHistogramParameterxvOES = cast(type_of(procs.glGetHistogramParameterxvOES)) GetProcAddress(cast(*u8) "glGetHistogramParameterxvOES\0");
    procs.glGetLightxOES = cast(type_of(procs.glGetLightxOES)) GetProcAddress(cast(*u8) "glGetLightxOES\0");
    procs.glGetMapxvOES = cast(type_of(procs.glGetMapxvOES)) GetProcAddress(cast(*u8) "glGetMapxvOES\0");
    procs.glGetMaterialxOES = cast(type_of(procs.glGetMaterialxOES)) GetProcAddress(cast(*u8) "glGetMaterialxOES\0");
    procs.glGetPixelMapxv = cast(type_of(procs.glGetPixelMapxv)) GetProcAddress(cast(*u8) "glGetPixelMapxv\0");
    procs.glGetTexGenxvOES = cast(type_of(procs.glGetTexGenxvOES)) GetProcAddress(cast(*u8) "glGetTexGenxvOES\0");
    procs.glGetTexLevelParameterxvOES = cast(type_of(procs.glGetTexLevelParameterxvOES)) GetProcAddress(cast(*u8) "glGetTexLevelParameterxvOES\0");
    procs.glIndexxOES = cast(type_of(procs.glIndexxOES)) GetProcAddress(cast(*u8) "glIndexxOES\0");
    procs.glIndexxvOES = cast(type_of(procs.glIndexxvOES)) GetProcAddress(cast(*u8) "glIndexxvOES\0");
    procs.glLoadTransposeMatrixxOES = cast(type_of(procs.glLoadTransposeMatrixxOES)) GetProcAddress(cast(*u8) "glLoadTransposeMatrixxOES\0");
    procs.glMap1xOES = cast(type_of(procs.glMap1xOES)) GetProcAddress(cast(*u8) "glMap1xOES\0");
    procs.glMap2xOES = cast(type_of(procs.glMap2xOES)) GetProcAddress(cast(*u8) "glMap2xOES\0");
    procs.glMapGrid1xOES = cast(type_of(procs.glMapGrid1xOES)) GetProcAddress(cast(*u8) "glMapGrid1xOES\0");
    procs.glMapGrid2xOES = cast(type_of(procs.glMapGrid2xOES)) GetProcAddress(cast(*u8) "glMapGrid2xOES\0");
    procs.glMultTransposeMatrixxOES = cast(type_of(procs.glMultTransposeMatrixxOES)) GetProcAddress(cast(*u8) "glMultTransposeMatrixxOES\0");
    procs.glMultiTexCoord1xOES = cast(type_of(procs.glMultiTexCoord1xOES)) GetProcAddress(cast(*u8) "glMultiTexCoord1xOES\0");
    procs.glMultiTexCoord1xvOES = cast(type_of(procs.glMultiTexCoord1xvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord1xvOES\0");
    procs.glMultiTexCoord2xOES = cast(type_of(procs.glMultiTexCoord2xOES)) GetProcAddress(cast(*u8) "glMultiTexCoord2xOES\0");
    procs.glMultiTexCoord2xvOES = cast(type_of(procs.glMultiTexCoord2xvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord2xvOES\0");
    procs.glMultiTexCoord3xOES = cast(type_of(procs.glMultiTexCoord3xOES)) GetProcAddress(cast(*u8) "glMultiTexCoord3xOES\0");
    procs.glMultiTexCoord3xvOES = cast(type_of(procs.glMultiTexCoord3xvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord3xvOES\0");
    procs.glMultiTexCoord4xvOES = cast(type_of(procs.glMultiTexCoord4xvOES)) GetProcAddress(cast(*u8) "glMultiTexCoord4xvOES\0");
    procs.glNormal3xvOES = cast(type_of(procs.glNormal3xvOES)) GetProcAddress(cast(*u8) "glNormal3xvOES\0");
    procs.glPassThroughxOES = cast(type_of(procs.glPassThroughxOES)) GetProcAddress(cast(*u8) "glPassThroughxOES\0");
    procs.glPixelMapx = cast(type_of(procs.glPixelMapx)) GetProcAddress(cast(*u8) "glPixelMapx\0");
    procs.glPixelStorex = cast(type_of(procs.glPixelStorex)) GetProcAddress(cast(*u8) "glPixelStorex\0");
    procs.glPixelTransferxOES = cast(type_of(procs.glPixelTransferxOES)) GetProcAddress(cast(*u8) "glPixelTransferxOES\0");
    procs.glPixelZoomxOES = cast(type_of(procs.glPixelZoomxOES)) GetProcAddress(cast(*u8) "glPixelZoomxOES\0");
    procs.glPrioritizeTexturesxOES = cast(type_of(procs.glPrioritizeTexturesxOES)) GetProcAddress(cast(*u8) "glPrioritizeTexturesxOES\0");
    procs.glRasterPos2xOES = cast(type_of(procs.glRasterPos2xOES)) GetProcAddress(cast(*u8) "glRasterPos2xOES\0");
    procs.glRasterPos2xvOES = cast(type_of(procs.glRasterPos2xvOES)) GetProcAddress(cast(*u8) "glRasterPos2xvOES\0");
    procs.glRasterPos3xOES = cast(type_of(procs.glRasterPos3xOES)) GetProcAddress(cast(*u8) "glRasterPos3xOES\0");
    procs.glRasterPos3xvOES = cast(type_of(procs.glRasterPos3xvOES)) GetProcAddress(cast(*u8) "glRasterPos3xvOES\0");
    procs.glRasterPos4xOES = cast(type_of(procs.glRasterPos4xOES)) GetProcAddress(cast(*u8) "glRasterPos4xOES\0");
    procs.glRasterPos4xvOES = cast(type_of(procs.glRasterPos4xvOES)) GetProcAddress(cast(*u8) "glRasterPos4xvOES\0");
    procs.glRectxOES = cast(type_of(procs.glRectxOES)) GetProcAddress(cast(*u8) "glRectxOES\0");
    procs.glRectxvOES = cast(type_of(procs.glRectxvOES)) GetProcAddress(cast(*u8) "glRectxvOES\0");
    procs.glTexCoord1xOES = cast(type_of(procs.glTexCoord1xOES)) GetProcAddress(cast(*u8) "glTexCoord1xOES\0");
    procs.glTexCoord1xvOES = cast(type_of(procs.glTexCoord1xvOES)) GetProcAddress(cast(*u8) "glTexCoord1xvOES\0");
    procs.glTexCoord2xOES = cast(type_of(procs.glTexCoord2xOES)) GetProcAddress(cast(*u8) "glTexCoord2xOES\0");
    procs.glTexCoord2xvOES = cast(type_of(procs.glTexCoord2xvOES)) GetProcAddress(cast(*u8) "glTexCoord2xvOES\0");
    procs.glTexCoord3xOES = cast(type_of(procs.glTexCoord3xOES)) GetProcAddress(cast(*u8) "glTexCoord3xOES\0");
    procs.glTexCoord3xvOES = cast(type_of(procs.glTexCoord3xvOES)) GetProcAddress(cast(*u8) "glTexCoord3xvOES\0");
    procs.glTexCoord4xOES = cast(type_of(procs.glTexCoord4xOES)) GetProcAddress(cast(*u8) "glTexCoord4xOES\0");
    procs.glTexCoord4xvOES = cast(type_of(procs.glTexCoord4xvOES)) GetProcAddress(cast(*u8) "glTexCoord4xvOES\0");
    procs.glTexGenxOES = cast(type_of(procs.glTexGenxOES)) GetProcAddress(cast(*u8) "glTexGenxOES\0");
    procs.glTexGenxvOES = cast(type_of(procs.glTexGenxvOES)) GetProcAddress(cast(*u8) "glTexGenxvOES\0");
    procs.glVertex2xOES = cast(type_of(procs.glVertex2xOES)) GetProcAddress(cast(*u8) "glVertex2xOES\0");
    procs.glVertex2xvOES = cast(type_of(procs.glVertex2xvOES)) GetProcAddress(cast(*u8) "glVertex2xvOES\0");
    procs.glVertex3xOES = cast(type_of(procs.glVertex3xOES)) GetProcAddress(cast(*u8) "glVertex3xOES\0");
    procs.glVertex3xvOES = cast(type_of(procs.glVertex3xvOES)) GetProcAddress(cast(*u8) "glVertex3xvOES\0");
    procs.glVertex4xOES = cast(type_of(procs.glVertex4xOES)) GetProcAddress(cast(*u8) "glVertex4xOES\0");
    procs.glVertex4xvOES = cast(type_of(procs.glVertex4xvOES)) GetProcAddress(cast(*u8) "glVertex4xvOES\0");
    procs.glQueryMatrixxOES = cast(type_of(procs.glQueryMatrixxOES)) GetProcAddress(cast(*u8) "glQueryMatrixxOES\0");
    procs.glClearDepthfOES = cast(type_of(procs.glClearDepthfOES)) GetProcAddress(cast(*u8) "glClearDepthfOES\0");
    procs.glClipPlanefOES = cast(type_of(procs.glClipPlanefOES)) GetProcAddress(cast(*u8) "glClipPlanefOES\0");
    procs.glDepthRangefOES = cast(type_of(procs.glDepthRangefOES)) GetProcAddress(cast(*u8) "glDepthRangefOES\0");
    procs.glFrustumfOES = cast(type_of(procs.glFrustumfOES)) GetProcAddress(cast(*u8) "glFrustumfOES\0");
    procs.glGetClipPlanefOES = cast(type_of(procs.glGetClipPlanefOES)) GetProcAddress(cast(*u8) "glGetClipPlanefOES\0");
    procs.glOrthofOES = cast(type_of(procs.glOrthofOES)) GetProcAddress(cast(*u8) "glOrthofOES\0");
    procs.glFramebufferTextureMultiviewOVR = cast(type_of(procs.glFramebufferTextureMultiviewOVR)) GetProcAddress(cast(*u8) "glFramebufferTextureMultiviewOVR\0");
    procs.glHintPGI = cast(type_of(procs.glHintPGI)) GetProcAddress(cast(*u8) "glHintPGI\0");
    procs.glDetailTexFuncSGIS = cast(type_of(procs.glDetailTexFuncSGIS)) GetProcAddress(cast(*u8) "glDetailTexFuncSGIS\0");
    procs.glGetDetailTexFuncSGIS = cast(type_of(procs.glGetDetailTexFuncSGIS)) GetProcAddress(cast(*u8) "glGetDetailTexFuncSGIS\0");
    procs.glFogFuncSGIS = cast(type_of(procs.glFogFuncSGIS)) GetProcAddress(cast(*u8) "glFogFuncSGIS\0");
    procs.glGetFogFuncSGIS = cast(type_of(procs.glGetFogFuncSGIS)) GetProcAddress(cast(*u8) "glGetFogFuncSGIS\0");
    procs.glSampleMaskSGIS = cast(type_of(procs.glSampleMaskSGIS)) GetProcAddress(cast(*u8) "glSampleMaskSGIS\0");
    procs.glSamplePatternSGIS = cast(type_of(procs.glSamplePatternSGIS)) GetProcAddress(cast(*u8) "glSamplePatternSGIS\0");
    procs.glPixelTexGenParameteriSGIS = cast(type_of(procs.glPixelTexGenParameteriSGIS)) GetProcAddress(cast(*u8) "glPixelTexGenParameteriSGIS\0");
    procs.glPixelTexGenParameterivSGIS = cast(type_of(procs.glPixelTexGenParameterivSGIS)) GetProcAddress(cast(*u8) "glPixelTexGenParameterivSGIS\0");
    procs.glPixelTexGenParameterfSGIS = cast(type_of(procs.glPixelTexGenParameterfSGIS)) GetProcAddress(cast(*u8) "glPixelTexGenParameterfSGIS\0");
    procs.glPixelTexGenParameterfvSGIS = cast(type_of(procs.glPixelTexGenParameterfvSGIS)) GetProcAddress(cast(*u8) "glPixelTexGenParameterfvSGIS\0");
    procs.glGetPixelTexGenParameterivSGIS = cast(type_of(procs.glGetPixelTexGenParameterivSGIS)) GetProcAddress(cast(*u8) "glGetPixelTexGenParameterivSGIS\0");
    procs.glGetPixelTexGenParameterfvSGIS = cast(type_of(procs.glGetPixelTexGenParameterfvSGIS)) GetProcAddress(cast(*u8) "glGetPixelTexGenParameterfvSGIS\0");
    procs.glPointParameterfSGIS = cast(type_of(procs.glPointParameterfSGIS)) GetProcAddress(cast(*u8) "glPointParameterfSGIS\0");
    procs.glPointParameterfvSGIS = cast(type_of(procs.glPointParameterfvSGIS)) GetProcAddress(cast(*u8) "glPointParameterfvSGIS\0");
    procs.glSharpenTexFuncSGIS = cast(type_of(procs.glSharpenTexFuncSGIS)) GetProcAddress(cast(*u8) "glSharpenTexFuncSGIS\0");
    procs.glGetSharpenTexFuncSGIS = cast(type_of(procs.glGetSharpenTexFuncSGIS)) GetProcAddress(cast(*u8) "glGetSharpenTexFuncSGIS\0");
    procs.glTexImage4DSGIS = cast(type_of(procs.glTexImage4DSGIS)) GetProcAddress(cast(*u8) "glTexImage4DSGIS\0");
    procs.glTexSubImage4DSGIS = cast(type_of(procs.glTexSubImage4DSGIS)) GetProcAddress(cast(*u8) "glTexSubImage4DSGIS\0");
    procs.glTextureColorMaskSGIS = cast(type_of(procs.glTextureColorMaskSGIS)) GetProcAddress(cast(*u8) "glTextureColorMaskSGIS\0");
    procs.glGetTexFilterFuncSGIS = cast(type_of(procs.glGetTexFilterFuncSGIS)) GetProcAddress(cast(*u8) "glGetTexFilterFuncSGIS\0");
    procs.glTexFilterFuncSGIS = cast(type_of(procs.glTexFilterFuncSGIS)) GetProcAddress(cast(*u8) "glTexFilterFuncSGIS\0");
    procs.glAsyncMarkerSGIX = cast(type_of(procs.glAsyncMarkerSGIX)) GetProcAddress(cast(*u8) "glAsyncMarkerSGIX\0");
    procs.glFinishAsyncSGIX = cast(type_of(procs.glFinishAsyncSGIX)) GetProcAddress(cast(*u8) "glFinishAsyncSGIX\0");
    procs.glPollAsyncSGIX = cast(type_of(procs.glPollAsyncSGIX)) GetProcAddress(cast(*u8) "glPollAsyncSGIX\0");
    procs.glGenAsyncMarkersSGIX = cast(type_of(procs.glGenAsyncMarkersSGIX)) GetProcAddress(cast(*u8) "glGenAsyncMarkersSGIX\0");
    procs.glDeleteAsyncMarkersSGIX = cast(type_of(procs.glDeleteAsyncMarkersSGIX)) GetProcAddress(cast(*u8) "glDeleteAsyncMarkersSGIX\0");
    procs.glIsAsyncMarkerSGIX = cast(type_of(procs.glIsAsyncMarkerSGIX)) GetProcAddress(cast(*u8) "glIsAsyncMarkerSGIX\0");
    procs.glFlushRasterSGIX = cast(type_of(procs.glFlushRasterSGIX)) GetProcAddress(cast(*u8) "glFlushRasterSGIX\0");
    procs.glFragmentColorMaterialSGIX = cast(type_of(procs.glFragmentColorMaterialSGIX)) GetProcAddress(cast(*u8) "glFragmentColorMaterialSGIX\0");
    procs.glFragmentLightfSGIX = cast(type_of(procs.glFragmentLightfSGIX)) GetProcAddress(cast(*u8) "glFragmentLightfSGIX\0");
    procs.glFragmentLightfvSGIX = cast(type_of(procs.glFragmentLightfvSGIX)) GetProcAddress(cast(*u8) "glFragmentLightfvSGIX\0");
    procs.glFragmentLightiSGIX = cast(type_of(procs.glFragmentLightiSGIX)) GetProcAddress(cast(*u8) "glFragmentLightiSGIX\0");
    procs.glFragmentLightivSGIX = cast(type_of(procs.glFragmentLightivSGIX)) GetProcAddress(cast(*u8) "glFragmentLightivSGIX\0");
    procs.glFragmentLightModelfSGIX = cast(type_of(procs.glFragmentLightModelfSGIX)) GetProcAddress(cast(*u8) "glFragmentLightModelfSGIX\0");
    procs.glFragmentLightModelfvSGIX = cast(type_of(procs.glFragmentLightModelfvSGIX)) GetProcAddress(cast(*u8) "glFragmentLightModelfvSGIX\0");
    procs.glFragmentLightModeliSGIX = cast(type_of(procs.glFragmentLightModeliSGIX)) GetProcAddress(cast(*u8) "glFragmentLightModeliSGIX\0");
    procs.glFragmentLightModelivSGIX = cast(type_of(procs.glFragmentLightModelivSGIX)) GetProcAddress(cast(*u8) "glFragmentLightModelivSGIX\0");
    procs.glFragmentMaterialfSGIX = cast(type_of(procs.glFragmentMaterialfSGIX)) GetProcAddress(cast(*u8) "glFragmentMaterialfSGIX\0");
    procs.glFragmentMaterialfvSGIX = cast(type_of(procs.glFragmentMaterialfvSGIX)) GetProcAddress(cast(*u8) "glFragmentMaterialfvSGIX\0");
    procs.glFragmentMaterialiSGIX = cast(type_of(procs.glFragmentMaterialiSGIX)) GetProcAddress(cast(*u8) "glFragmentMaterialiSGIX\0");
    procs.glFragmentMaterialivSGIX = cast(type_of(procs.glFragmentMaterialivSGIX)) GetProcAddress(cast(*u8) "glFragmentMaterialivSGIX\0");
    procs.glGetFragmentLightfvSGIX = cast(type_of(procs.glGetFragmentLightfvSGIX)) GetProcAddress(cast(*u8) "glGetFragmentLightfvSGIX\0");
    procs.glGetFragmentLightivSGIX = cast(type_of(procs.glGetFragmentLightivSGIX)) GetProcAddress(cast(*u8) "glGetFragmentLightivSGIX\0");
    procs.glGetFragmentMaterialfvSGIX = cast(type_of(procs.glGetFragmentMaterialfvSGIX)) GetProcAddress(cast(*u8) "glGetFragmentMaterialfvSGIX\0");
    procs.glGetFragmentMaterialivSGIX = cast(type_of(procs.glGetFragmentMaterialivSGIX)) GetProcAddress(cast(*u8) "glGetFragmentMaterialivSGIX\0");
    procs.glLightEnviSGIX = cast(type_of(procs.glLightEnviSGIX)) GetProcAddress(cast(*u8) "glLightEnviSGIX\0");
    procs.glFrameZoomSGIX = cast(type_of(procs.glFrameZoomSGIX)) GetProcAddress(cast(*u8) "glFrameZoomSGIX\0");
    procs.glIglooInterfaceSGIX = cast(type_of(procs.glIglooInterfaceSGIX)) GetProcAddress(cast(*u8) "glIglooInterfaceSGIX\0");
    procs.glGetInstrumentsSGIX = cast(type_of(procs.glGetInstrumentsSGIX)) GetProcAddress(cast(*u8) "glGetInstrumentsSGIX\0");
    procs.glInstrumentsBufferSGIX = cast(type_of(procs.glInstrumentsBufferSGIX)) GetProcAddress(cast(*u8) "glInstrumentsBufferSGIX\0");
    procs.glPollInstrumentsSGIX = cast(type_of(procs.glPollInstrumentsSGIX)) GetProcAddress(cast(*u8) "glPollInstrumentsSGIX\0");
    procs.glReadInstrumentsSGIX = cast(type_of(procs.glReadInstrumentsSGIX)) GetProcAddress(cast(*u8) "glReadInstrumentsSGIX\0");
    procs.glStartInstrumentsSGIX = cast(type_of(procs.glStartInstrumentsSGIX)) GetProcAddress(cast(*u8) "glStartInstrumentsSGIX\0");
    procs.glStopInstrumentsSGIX = cast(type_of(procs.glStopInstrumentsSGIX)) GetProcAddress(cast(*u8) "glStopInstrumentsSGIX\0");
    procs.glGetListParameterfvSGIX = cast(type_of(procs.glGetListParameterfvSGIX)) GetProcAddress(cast(*u8) "glGetListParameterfvSGIX\0");
    procs.glGetListParameterivSGIX = cast(type_of(procs.glGetListParameterivSGIX)) GetProcAddress(cast(*u8) "glGetListParameterivSGIX\0");
    procs.glListParameterfSGIX = cast(type_of(procs.glListParameterfSGIX)) GetProcAddress(cast(*u8) "glListParameterfSGIX\0");
    procs.glListParameterfvSGIX = cast(type_of(procs.glListParameterfvSGIX)) GetProcAddress(cast(*u8) "glListParameterfvSGIX\0");
    procs.glListParameteriSGIX = cast(type_of(procs.glListParameteriSGIX)) GetProcAddress(cast(*u8) "glListParameteriSGIX\0");
    procs.glListParameterivSGIX = cast(type_of(procs.glListParameterivSGIX)) GetProcAddress(cast(*u8) "glListParameterivSGIX\0");
    procs.glPixelTexGenSGIX = cast(type_of(procs.glPixelTexGenSGIX)) GetProcAddress(cast(*u8) "glPixelTexGenSGIX\0");
    procs.glDeformationMap3dSGIX = cast(type_of(procs.glDeformationMap3dSGIX)) GetProcAddress(cast(*u8) "glDeformationMap3dSGIX\0");
    procs.glDeformationMap3fSGIX = cast(type_of(procs.glDeformationMap3fSGIX)) GetProcAddress(cast(*u8) "glDeformationMap3fSGIX\0");
    procs.glDeformSGIX = cast(type_of(procs.glDeformSGIX)) GetProcAddress(cast(*u8) "glDeformSGIX\0");
    procs.glLoadIdentityDeformationMapSGIX = cast(type_of(procs.glLoadIdentityDeformationMapSGIX)) GetProcAddress(cast(*u8) "glLoadIdentityDeformationMapSGIX\0");
    procs.glReferencePlaneSGIX = cast(type_of(procs.glReferencePlaneSGIX)) GetProcAddress(cast(*u8) "glReferencePlaneSGIX\0");
    procs.glSpriteParameterfSGIX = cast(type_of(procs.glSpriteParameterfSGIX)) GetProcAddress(cast(*u8) "glSpriteParameterfSGIX\0");
    procs.glSpriteParameterfvSGIX = cast(type_of(procs.glSpriteParameterfvSGIX)) GetProcAddress(cast(*u8) "glSpriteParameterfvSGIX\0");
    procs.glSpriteParameteriSGIX = cast(type_of(procs.glSpriteParameteriSGIX)) GetProcAddress(cast(*u8) "glSpriteParameteriSGIX\0");
    procs.glSpriteParameterivSGIX = cast(type_of(procs.glSpriteParameterivSGIX)) GetProcAddress(cast(*u8) "glSpriteParameterivSGIX\0");
    procs.glTagSampleBufferSGIX = cast(type_of(procs.glTagSampleBufferSGIX)) GetProcAddress(cast(*u8) "glTagSampleBufferSGIX\0");
    procs.glColorTableSGI = cast(type_of(procs.glColorTableSGI)) GetProcAddress(cast(*u8) "glColorTableSGI\0");
    procs.glColorTableParameterfvSGI = cast(type_of(procs.glColorTableParameterfvSGI)) GetProcAddress(cast(*u8) "glColorTableParameterfvSGI\0");
    procs.glColorTableParameterivSGI = cast(type_of(procs.glColorTableParameterivSGI)) GetProcAddress(cast(*u8) "glColorTableParameterivSGI\0");
    procs.glCopyColorTableSGI = cast(type_of(procs.glCopyColorTableSGI)) GetProcAddress(cast(*u8) "glCopyColorTableSGI\0");
    procs.glGetColorTableSGI = cast(type_of(procs.glGetColorTableSGI)) GetProcAddress(cast(*u8) "glGetColorTableSGI\0");
    procs.glGetColorTableParameterfvSGI = cast(type_of(procs.glGetColorTableParameterfvSGI)) GetProcAddress(cast(*u8) "glGetColorTableParameterfvSGI\0");
    procs.glGetColorTableParameterivSGI = cast(type_of(procs.glGetColorTableParameterivSGI)) GetProcAddress(cast(*u8) "glGetColorTableParameterivSGI\0");
    procs.glFinishTextureSUNX = cast(type_of(procs.glFinishTextureSUNX)) GetProcAddress(cast(*u8) "glFinishTextureSUNX\0");
    procs.glGlobalAlphaFactorbSUN = cast(type_of(procs.glGlobalAlphaFactorbSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactorbSUN\0");
    procs.glGlobalAlphaFactorsSUN = cast(type_of(procs.glGlobalAlphaFactorsSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactorsSUN\0");
    procs.glGlobalAlphaFactoriSUN = cast(type_of(procs.glGlobalAlphaFactoriSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactoriSUN\0");
    procs.glGlobalAlphaFactorfSUN = cast(type_of(procs.glGlobalAlphaFactorfSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactorfSUN\0");
    procs.glGlobalAlphaFactordSUN = cast(type_of(procs.glGlobalAlphaFactordSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactordSUN\0");
    procs.glGlobalAlphaFactorubSUN = cast(type_of(procs.glGlobalAlphaFactorubSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactorubSUN\0");
    procs.glGlobalAlphaFactorusSUN = cast(type_of(procs.glGlobalAlphaFactorusSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactorusSUN\0");
    procs.glGlobalAlphaFactoruiSUN = cast(type_of(procs.glGlobalAlphaFactoruiSUN)) GetProcAddress(cast(*u8) "glGlobalAlphaFactoruiSUN\0");
    procs.glDrawMeshArraysSUN = cast(type_of(procs.glDrawMeshArraysSUN)) GetProcAddress(cast(*u8) "glDrawMeshArraysSUN\0");
    procs.glReplacementCodeuiSUN = cast(type_of(procs.glReplacementCodeuiSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiSUN\0");
    procs.glReplacementCodeusSUN = cast(type_of(procs.glReplacementCodeusSUN)) GetProcAddress(cast(*u8) "glReplacementCodeusSUN\0");
    procs.glReplacementCodeubSUN = cast(type_of(procs.glReplacementCodeubSUN)) GetProcAddress(cast(*u8) "glReplacementCodeubSUN\0");
    procs.glReplacementCodeuivSUN = cast(type_of(procs.glReplacementCodeuivSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuivSUN\0");
    procs.glReplacementCodeusvSUN = cast(type_of(procs.glReplacementCodeusvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeusvSUN\0");
    procs.glReplacementCodeubvSUN = cast(type_of(procs.glReplacementCodeubvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeubvSUN\0");
    procs.glReplacementCodePointerSUN = cast(type_of(procs.glReplacementCodePointerSUN)) GetProcAddress(cast(*u8) "glReplacementCodePointerSUN\0");
    procs.glColor4ubVertex2fSUN = cast(type_of(procs.glColor4ubVertex2fSUN)) GetProcAddress(cast(*u8) "glColor4ubVertex2fSUN\0");
    procs.glColor4ubVertex2fvSUN = cast(type_of(procs.glColor4ubVertex2fvSUN)) GetProcAddress(cast(*u8) "glColor4ubVertex2fvSUN\0");
    procs.glColor4ubVertex3fSUN = cast(type_of(procs.glColor4ubVertex3fSUN)) GetProcAddress(cast(*u8) "glColor4ubVertex3fSUN\0");
    procs.glColor4ubVertex3fvSUN = cast(type_of(procs.glColor4ubVertex3fvSUN)) GetProcAddress(cast(*u8) "glColor4ubVertex3fvSUN\0");
    procs.glColor3fVertex3fSUN = cast(type_of(procs.glColor3fVertex3fSUN)) GetProcAddress(cast(*u8) "glColor3fVertex3fSUN\0");
    procs.glColor3fVertex3fvSUN = cast(type_of(procs.glColor3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glColor3fVertex3fvSUN\0");
    procs.glNormal3fVertex3fSUN = cast(type_of(procs.glNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glNormal3fVertex3fSUN\0");
    procs.glNormal3fVertex3fvSUN = cast(type_of(procs.glNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glNormal3fVertex3fvSUN\0");
    procs.glColor4fNormal3fVertex3fSUN = cast(type_of(procs.glColor4fNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glColor4fNormal3fVertex3fSUN\0");
    procs.glColor4fNormal3fVertex3fvSUN = cast(type_of(procs.glColor4fNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glColor4fNormal3fVertex3fvSUN\0");
    procs.glTexCoord2fVertex3fSUN = cast(type_of(procs.glTexCoord2fVertex3fSUN)) GetProcAddress(cast(*u8) "glTexCoord2fVertex3fSUN\0");
    procs.glTexCoord2fVertex3fvSUN = cast(type_of(procs.glTexCoord2fVertex3fvSUN)) GetProcAddress(cast(*u8) "glTexCoord2fVertex3fvSUN\0");
    procs.glTexCoord4fVertex4fSUN = cast(type_of(procs.glTexCoord4fVertex4fSUN)) GetProcAddress(cast(*u8) "glTexCoord4fVertex4fSUN\0");
    procs.glTexCoord4fVertex4fvSUN = cast(type_of(procs.glTexCoord4fVertex4fvSUN)) GetProcAddress(cast(*u8) "glTexCoord4fVertex4fvSUN\0");
    procs.glTexCoord2fColor4ubVertex3fSUN = cast(type_of(procs.glTexCoord2fColor4ubVertex3fSUN)) GetProcAddress(cast(*u8) "glTexCoord2fColor4ubVertex3fSUN\0");
    procs.glTexCoord2fColor4ubVertex3fvSUN = cast(type_of(procs.glTexCoord2fColor4ubVertex3fvSUN)) GetProcAddress(cast(*u8) "glTexCoord2fColor4ubVertex3fvSUN\0");
    procs.glTexCoord2fColor3fVertex3fSUN = cast(type_of(procs.glTexCoord2fColor3fVertex3fSUN)) GetProcAddress(cast(*u8) "glTexCoord2fColor3fVertex3fSUN\0");
    procs.glTexCoord2fColor3fVertex3fvSUN = cast(type_of(procs.glTexCoord2fColor3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glTexCoord2fColor3fVertex3fvSUN\0");
    procs.glTexCoord2fNormal3fVertex3fSUN = cast(type_of(procs.glTexCoord2fNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glTexCoord2fNormal3fVertex3fSUN\0");
    procs.glTexCoord2fNormal3fVertex3fvSUN = cast(type_of(procs.glTexCoord2fNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glTexCoord2fNormal3fVertex3fvSUN\0");
    procs.glTexCoord2fColor4fNormal3fVertex3fSUN = cast(type_of(procs.glTexCoord2fColor4fNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glTexCoord2fColor4fNormal3fVertex3fSUN\0");
    procs.glTexCoord2fColor4fNormal3fVertex3fvSUN = cast(type_of(procs.glTexCoord2fColor4fNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glTexCoord2fColor4fNormal3fVertex3fvSUN\0");
    procs.glTexCoord4fColor4fNormal3fVertex4fSUN = cast(type_of(procs.glTexCoord4fColor4fNormal3fVertex4fSUN)) GetProcAddress(cast(*u8) "glTexCoord4fColor4fNormal3fVertex4fSUN\0");
    procs.glTexCoord4fColor4fNormal3fVertex4fvSUN = cast(type_of(procs.glTexCoord4fColor4fNormal3fVertex4fvSUN)) GetProcAddress(cast(*u8) "glTexCoord4fColor4fNormal3fVertex4fvSUN\0");
    procs.glReplacementCodeuiVertex3fSUN = cast(type_of(procs.glReplacementCodeuiVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiVertex3fSUN\0");
    procs.glReplacementCodeuiVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiVertex3fvSUN\0");
    procs.glReplacementCodeuiColor4ubVertex3fSUN = cast(type_of(procs.glReplacementCodeuiColor4ubVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiColor4ubVertex3fSUN\0");
    procs.glReplacementCodeuiColor4ubVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiColor4ubVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiColor4ubVertex3fvSUN\0");
    procs.glReplacementCodeuiColor3fVertex3fSUN = cast(type_of(procs.glReplacementCodeuiColor3fVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiColor3fVertex3fSUN\0");
    procs.glReplacementCodeuiColor3fVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiColor3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiColor3fVertex3fvSUN\0");
    procs.glReplacementCodeuiNormal3fVertex3fSUN = cast(type_of(procs.glReplacementCodeuiNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiNormal3fVertex3fSUN\0");
    procs.glReplacementCodeuiNormal3fVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiNormal3fVertex3fvSUN\0");
    procs.glReplacementCodeuiColor4fNormal3fVertex3fSUN = cast(type_of(procs.glReplacementCodeuiColor4fNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiColor4fNormal3fVertex3fSUN\0");
    procs.glReplacementCodeuiColor4fNormal3fVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiColor4fNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiColor4fNormal3fVertex3fvSUN\0");
    procs.glReplacementCodeuiTexCoord2fVertex3fSUN = cast(type_of(procs.glReplacementCodeuiTexCoord2fVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiTexCoord2fVertex3fSUN\0");
    procs.glReplacementCodeuiTexCoord2fVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiTexCoord2fVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiTexCoord2fVertex3fvSUN\0");
    procs.glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN = cast(type_of(procs.glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN\0");
    procs.glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN\0");
    procs.glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN = cast(type_of(procs.glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN\0");
    procs.glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN = cast(type_of(procs.glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN)) GetProcAddress(cast(*u8) "glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN\0");
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
    procs.GL_3DFX_multisample = _gl_has_extension(procs, "GL_3DFX_multisample");
    procs.GL_3DFX_tbuffer = _gl_has_extension(procs, "GL_3DFX_tbuffer");
    procs.GL_3DFX_texture_compression_FXT1 = _gl_has_extension(procs, "GL_3DFX_texture_compression_FXT1");
    procs.GL_AMD_blend_minmax_factor = _gl_has_extension(procs, "GL_AMD_blend_minmax_factor");
    procs.GL_AMD_conservative_depth = _gl_has_extension(procs, "GL_AMD_conservative_depth");
    procs.GL_AMD_debug_output = _gl_has_extension(procs, "GL_AMD_debug_output");
    procs.GL_AMD_depth_clamp_separate = _gl_has_extension(procs, "GL_AMD_depth_clamp_separate");
    procs.GL_AMD_draw_buffers_blend = _gl_has_extension(procs, "GL_AMD_draw_buffers_blend");
    procs.GL_AMD_framebuffer_sample_positions = _gl_has_extension(procs, "GL_AMD_framebuffer_sample_positions");
    procs.GL_AMD_gcn_shader = _gl_has_extension(procs, "GL_AMD_gcn_shader");
    procs.GL_AMD_gpu_shader_half_float = _gl_has_extension(procs, "GL_AMD_gpu_shader_half_float");
    procs.GL_AMD_gpu_shader_int16 = _gl_has_extension(procs, "GL_AMD_gpu_shader_int16");
    procs.GL_AMD_gpu_shader_int64 = _gl_has_extension(procs, "GL_AMD_gpu_shader_int64");
    procs.GL_AMD_interleaved_elements = _gl_has_extension(procs, "GL_AMD_interleaved_elements");
    procs.GL_AMD_multi_draw_indirect = _gl_has_extension(procs, "GL_AMD_multi_draw_indirect");
    procs.GL_AMD_name_gen_delete = _gl_has_extension(procs, "GL_AMD_name_gen_delete");
    procs.GL_AMD_occlusion_query_event = _gl_has_extension(procs, "GL_AMD_occlusion_query_event");
    procs.GL_AMD_performance_monitor = _gl_has_extension(procs, "GL_AMD_performance_monitor");
    procs.GL_AMD_pinned_memory = _gl_has_extension(procs, "GL_AMD_pinned_memory");
    procs.GL_AMD_query_buffer_object = _gl_has_extension(procs, "GL_AMD_query_buffer_object");
    procs.GL_AMD_sample_positions = _gl_has_extension(procs, "GL_AMD_sample_positions");
    procs.GL_AMD_seamless_cubemap_per_texture = _gl_has_extension(procs, "GL_AMD_seamless_cubemap_per_texture");
    procs.GL_AMD_shader_atomic_counter_ops = _gl_has_extension(procs, "GL_AMD_shader_atomic_counter_ops");
    procs.GL_AMD_shader_ballot = _gl_has_extension(procs, "GL_AMD_shader_ballot");
    procs.GL_AMD_shader_explicit_vertex_parameter = _gl_has_extension(procs, "GL_AMD_shader_explicit_vertex_parameter");
    procs.GL_AMD_shader_gpu_shader_half_float_fetch = _gl_has_extension(procs, "GL_AMD_shader_gpu_shader_half_float_fetch");
    procs.GL_AMD_shader_image_load_store_lod = _gl_has_extension(procs, "GL_AMD_shader_image_load_store_lod");
    procs.GL_AMD_shader_stencil_export = _gl_has_extension(procs, "GL_AMD_shader_stencil_export");
    procs.GL_AMD_shader_trinary_minmax = _gl_has_extension(procs, "GL_AMD_shader_trinary_minmax");
    procs.GL_AMD_sparse_texture = _gl_has_extension(procs, "GL_AMD_sparse_texture");
    procs.GL_AMD_stencil_operation_extended = _gl_has_extension(procs, "GL_AMD_stencil_operation_extended");
    procs.GL_AMD_texture_gather_bias_lod = _gl_has_extension(procs, "GL_AMD_texture_gather_bias_lod");
    procs.GL_AMD_texture_texture4 = _gl_has_extension(procs, "GL_AMD_texture_texture4");
    procs.GL_AMD_transform_feedback3_lines_triangles = _gl_has_extension(procs, "GL_AMD_transform_feedback3_lines_triangles");
    procs.GL_AMD_transform_feedback4 = _gl_has_extension(procs, "GL_AMD_transform_feedback4");
    procs.GL_AMD_vertex_shader_layer = _gl_has_extension(procs, "GL_AMD_vertex_shader_layer");
    procs.GL_AMD_vertex_shader_tessellator = _gl_has_extension(procs, "GL_AMD_vertex_shader_tessellator");
    procs.GL_AMD_vertex_shader_viewport_index = _gl_has_extension(procs, "GL_AMD_vertex_shader_viewport_index");
    procs.GL_APPLE_aux_depth_stencil = _gl_has_extension(procs, "GL_APPLE_aux_depth_stencil");
    procs.GL_APPLE_client_storage = _gl_has_extension(procs, "GL_APPLE_client_storage");
    procs.GL_APPLE_element_array = _gl_has_extension(procs, "GL_APPLE_element_array");
    procs.GL_APPLE_fence = _gl_has_extension(procs, "GL_APPLE_fence");
    procs.GL_APPLE_float_pixels = _gl_has_extension(procs, "GL_APPLE_float_pixels");
    procs.GL_APPLE_flush_buffer_range = _gl_has_extension(procs, "GL_APPLE_flush_buffer_range");
    procs.GL_APPLE_object_purgeable = _gl_has_extension(procs, "GL_APPLE_object_purgeable");
    procs.GL_APPLE_rgb_422 = _gl_has_extension(procs, "GL_APPLE_rgb_422");
    procs.GL_APPLE_row_bytes = _gl_has_extension(procs, "GL_APPLE_row_bytes");
    procs.GL_APPLE_specular_vector = _gl_has_extension(procs, "GL_APPLE_specular_vector");
    procs.GL_APPLE_texture_range = _gl_has_extension(procs, "GL_APPLE_texture_range");
    procs.GL_APPLE_transform_hint = _gl_has_extension(procs, "GL_APPLE_transform_hint");
    procs.GL_APPLE_vertex_array_object = _gl_has_extension(procs, "GL_APPLE_vertex_array_object");
    procs.GL_APPLE_vertex_array_range = _gl_has_extension(procs, "GL_APPLE_vertex_array_range");
    procs.GL_APPLE_vertex_program_evaluators = _gl_has_extension(procs, "GL_APPLE_vertex_program_evaluators");
    procs.GL_APPLE_ycbcr_422 = _gl_has_extension(procs, "GL_APPLE_ycbcr_422");
    procs.GL_ARB_ES2_compatibility = _gl_has_extension(procs, "GL_ARB_ES2_compatibility");
    procs.GL_ARB_ES3_1_compatibility = _gl_has_extension(procs, "GL_ARB_ES3_1_compatibility");
    procs.GL_ARB_ES3_2_compatibility = _gl_has_extension(procs, "GL_ARB_ES3_2_compatibility");
    procs.GL_ARB_ES3_compatibility = _gl_has_extension(procs, "GL_ARB_ES3_compatibility");
    procs.GL_ARB_arrays_of_arrays = _gl_has_extension(procs, "GL_ARB_arrays_of_arrays");
    procs.GL_ARB_base_instance = _gl_has_extension(procs, "GL_ARB_base_instance");
    procs.GL_ARB_bindless_texture = _gl_has_extension(procs, "GL_ARB_bindless_texture");
    procs.GL_ARB_blend_func_extended = _gl_has_extension(procs, "GL_ARB_blend_func_extended");
    procs.GL_ARB_buffer_storage = _gl_has_extension(procs, "GL_ARB_buffer_storage");
    procs.GL_ARB_cl_event = _gl_has_extension(procs, "GL_ARB_cl_event");
    procs.GL_ARB_clear_buffer_object = _gl_has_extension(procs, "GL_ARB_clear_buffer_object");
    procs.GL_ARB_clear_texture = _gl_has_extension(procs, "GL_ARB_clear_texture");
    procs.GL_ARB_clip_control = _gl_has_extension(procs, "GL_ARB_clip_control");
    procs.GL_ARB_color_buffer_float = _gl_has_extension(procs, "GL_ARB_color_buffer_float");
    procs.GL_ARB_compatibility = _gl_has_extension(procs, "GL_ARB_compatibility");
    procs.GL_ARB_compressed_texture_pixel_storage = _gl_has_extension(procs, "GL_ARB_compressed_texture_pixel_storage");
    procs.GL_ARB_compute_shader = _gl_has_extension(procs, "GL_ARB_compute_shader");
    procs.GL_ARB_compute_variable_group_size = _gl_has_extension(procs, "GL_ARB_compute_variable_group_size");
    procs.GL_ARB_conditional_render_inverted = _gl_has_extension(procs, "GL_ARB_conditional_render_inverted");
    procs.GL_ARB_conservative_depth = _gl_has_extension(procs, "GL_ARB_conservative_depth");
    procs.GL_ARB_copy_buffer = _gl_has_extension(procs, "GL_ARB_copy_buffer");
    procs.GL_ARB_copy_image = _gl_has_extension(procs, "GL_ARB_copy_image");
    procs.GL_ARB_cull_distance = _gl_has_extension(procs, "GL_ARB_cull_distance");
    procs.GL_ARB_debug_output = _gl_has_extension(procs, "GL_ARB_debug_output");
    procs.GL_ARB_depth_buffer_float = _gl_has_extension(procs, "GL_ARB_depth_buffer_float");
    procs.GL_ARB_depth_clamp = _gl_has_extension(procs, "GL_ARB_depth_clamp");
    procs.GL_ARB_depth_texture = _gl_has_extension(procs, "GL_ARB_depth_texture");
    procs.GL_ARB_derivative_control = _gl_has_extension(procs, "GL_ARB_derivative_control");
    procs.GL_ARB_direct_state_access = _gl_has_extension(procs, "GL_ARB_direct_state_access");
    procs.GL_ARB_draw_buffers = _gl_has_extension(procs, "GL_ARB_draw_buffers");
    procs.GL_ARB_draw_buffers_blend = _gl_has_extension(procs, "GL_ARB_draw_buffers_blend");
    procs.GL_ARB_draw_elements_base_vertex = _gl_has_extension(procs, "GL_ARB_draw_elements_base_vertex");
    procs.GL_ARB_draw_indirect = _gl_has_extension(procs, "GL_ARB_draw_indirect");
    procs.GL_ARB_draw_instanced = _gl_has_extension(procs, "GL_ARB_draw_instanced");
    procs.GL_ARB_enhanced_layouts = _gl_has_extension(procs, "GL_ARB_enhanced_layouts");
    procs.GL_ARB_explicit_attrib_location = _gl_has_extension(procs, "GL_ARB_explicit_attrib_location");
    procs.GL_ARB_explicit_uniform_location = _gl_has_extension(procs, "GL_ARB_explicit_uniform_location");
    procs.GL_ARB_fragment_coord_conventions = _gl_has_extension(procs, "GL_ARB_fragment_coord_conventions");
    procs.GL_ARB_fragment_layer_viewport = _gl_has_extension(procs, "GL_ARB_fragment_layer_viewport");
    procs.GL_ARB_fragment_program = _gl_has_extension(procs, "GL_ARB_fragment_program");
    procs.GL_ARB_fragment_program_shadow = _gl_has_extension(procs, "GL_ARB_fragment_program_shadow");
    procs.GL_ARB_fragment_shader = _gl_has_extension(procs, "GL_ARB_fragment_shader");
    procs.GL_ARB_fragment_shader_interlock = _gl_has_extension(procs, "GL_ARB_fragment_shader_interlock");
    procs.GL_ARB_framebuffer_no_attachments = _gl_has_extension(procs, "GL_ARB_framebuffer_no_attachments");
    procs.GL_ARB_framebuffer_object = _gl_has_extension(procs, "GL_ARB_framebuffer_object");
    procs.GL_ARB_framebuffer_sRGB = _gl_has_extension(procs, "GL_ARB_framebuffer_sRGB");
    procs.GL_ARB_geometry_shader4 = _gl_has_extension(procs, "GL_ARB_geometry_shader4");
    procs.GL_ARB_get_program_binary = _gl_has_extension(procs, "GL_ARB_get_program_binary");
    procs.GL_ARB_get_texture_sub_image = _gl_has_extension(procs, "GL_ARB_get_texture_sub_image");
    procs.GL_ARB_gl_spirv = _gl_has_extension(procs, "GL_ARB_gl_spirv");
    procs.GL_ARB_gpu_shader5 = _gl_has_extension(procs, "GL_ARB_gpu_shader5");
    procs.GL_ARB_gpu_shader_fp64 = _gl_has_extension(procs, "GL_ARB_gpu_shader_fp64");
    procs.GL_ARB_gpu_shader_int64 = _gl_has_extension(procs, "GL_ARB_gpu_shader_int64");
    procs.GL_ARB_half_float_pixel = _gl_has_extension(procs, "GL_ARB_half_float_pixel");
    procs.GL_ARB_half_float_vertex = _gl_has_extension(procs, "GL_ARB_half_float_vertex");
    procs.GL_ARB_imaging = _gl_has_extension(procs, "GL_ARB_imaging");
    procs.GL_ARB_indirect_parameters = _gl_has_extension(procs, "GL_ARB_indirect_parameters");
    procs.GL_ARB_instanced_arrays = _gl_has_extension(procs, "GL_ARB_instanced_arrays");
    procs.GL_ARB_internalformat_query = _gl_has_extension(procs, "GL_ARB_internalformat_query");
    procs.GL_ARB_internalformat_query2 = _gl_has_extension(procs, "GL_ARB_internalformat_query2");
    procs.GL_ARB_invalidate_subdata = _gl_has_extension(procs, "GL_ARB_invalidate_subdata");
    procs.GL_ARB_map_buffer_alignment = _gl_has_extension(procs, "GL_ARB_map_buffer_alignment");
    procs.GL_ARB_map_buffer_range = _gl_has_extension(procs, "GL_ARB_map_buffer_range");
    procs.GL_ARB_matrix_palette = _gl_has_extension(procs, "GL_ARB_matrix_palette");
    procs.GL_ARB_multi_bind = _gl_has_extension(procs, "GL_ARB_multi_bind");
    procs.GL_ARB_multi_draw_indirect = _gl_has_extension(procs, "GL_ARB_multi_draw_indirect");
    procs.GL_ARB_multisample = _gl_has_extension(procs, "GL_ARB_multisample");
    procs.GL_ARB_multitexture = _gl_has_extension(procs, "GL_ARB_multitexture");
    procs.GL_ARB_occlusion_query = _gl_has_extension(procs, "GL_ARB_occlusion_query");
    procs.GL_ARB_occlusion_query2 = _gl_has_extension(procs, "GL_ARB_occlusion_query2");
    procs.GL_ARB_parallel_shader_compile = _gl_has_extension(procs, "GL_ARB_parallel_shader_compile");
    procs.GL_ARB_pipeline_statistics_query = _gl_has_extension(procs, "GL_ARB_pipeline_statistics_query");
    procs.GL_ARB_pixel_buffer_object = _gl_has_extension(procs, "GL_ARB_pixel_buffer_object");
    procs.GL_ARB_point_parameters = _gl_has_extension(procs, "GL_ARB_point_parameters");
    procs.GL_ARB_point_sprite = _gl_has_extension(procs, "GL_ARB_point_sprite");
    procs.GL_ARB_polygon_offset_clamp = _gl_has_extension(procs, "GL_ARB_polygon_offset_clamp");
    procs.GL_ARB_post_depth_coverage = _gl_has_extension(procs, "GL_ARB_post_depth_coverage");
    procs.GL_ARB_program_interface_query = _gl_has_extension(procs, "GL_ARB_program_interface_query");
    procs.GL_ARB_provoking_vertex = _gl_has_extension(procs, "GL_ARB_provoking_vertex");
    procs.GL_ARB_query_buffer_object = _gl_has_extension(procs, "GL_ARB_query_buffer_object");
    procs.GL_ARB_robust_buffer_access_behavior = _gl_has_extension(procs, "GL_ARB_robust_buffer_access_behavior");
    procs.GL_ARB_robustness = _gl_has_extension(procs, "GL_ARB_robustness");
    procs.GL_ARB_robustness_isolation = _gl_has_extension(procs, "GL_ARB_robustness_isolation");
    procs.GL_ARB_sample_locations = _gl_has_extension(procs, "GL_ARB_sample_locations");
    procs.GL_ARB_sample_shading = _gl_has_extension(procs, "GL_ARB_sample_shading");
    procs.GL_ARB_sampler_objects = _gl_has_extension(procs, "GL_ARB_sampler_objects");
    procs.GL_ARB_seamless_cube_map = _gl_has_extension(procs, "GL_ARB_seamless_cube_map");
    procs.GL_ARB_seamless_cubemap_per_texture = _gl_has_extension(procs, "GL_ARB_seamless_cubemap_per_texture");
    procs.GL_ARB_separate_shader_objects = _gl_has_extension(procs, "GL_ARB_separate_shader_objects");
    procs.GL_ARB_shader_atomic_counter_ops = _gl_has_extension(procs, "GL_ARB_shader_atomic_counter_ops");
    procs.GL_ARB_shader_atomic_counters = _gl_has_extension(procs, "GL_ARB_shader_atomic_counters");
    procs.GL_ARB_shader_ballot = _gl_has_extension(procs, "GL_ARB_shader_ballot");
    procs.GL_ARB_shader_bit_encoding = _gl_has_extension(procs, "GL_ARB_shader_bit_encoding");
    procs.GL_ARB_shader_clock = _gl_has_extension(procs, "GL_ARB_shader_clock");
    procs.GL_ARB_shader_draw_parameters = _gl_has_extension(procs, "GL_ARB_shader_draw_parameters");
    procs.GL_ARB_shader_group_vote = _gl_has_extension(procs, "GL_ARB_shader_group_vote");
    procs.GL_ARB_shader_image_load_store = _gl_has_extension(procs, "GL_ARB_shader_image_load_store");
    procs.GL_ARB_shader_image_size = _gl_has_extension(procs, "GL_ARB_shader_image_size");
    procs.GL_ARB_shader_objects = _gl_has_extension(procs, "GL_ARB_shader_objects");
    procs.GL_ARB_shader_precision = _gl_has_extension(procs, "GL_ARB_shader_precision");
    procs.GL_ARB_shader_stencil_export = _gl_has_extension(procs, "GL_ARB_shader_stencil_export");
    procs.GL_ARB_shader_storage_buffer_object = _gl_has_extension(procs, "GL_ARB_shader_storage_buffer_object");
    procs.GL_ARB_shader_subroutine = _gl_has_extension(procs, "GL_ARB_shader_subroutine");
    procs.GL_ARB_shader_texture_image_samples = _gl_has_extension(procs, "GL_ARB_shader_texture_image_samples");
    procs.GL_ARB_shader_texture_lod = _gl_has_extension(procs, "GL_ARB_shader_texture_lod");
    procs.GL_ARB_shader_viewport_layer_array = _gl_has_extension(procs, "GL_ARB_shader_viewport_layer_array");
    procs.GL_ARB_shading_language_100 = _gl_has_extension(procs, "GL_ARB_shading_language_100");
    procs.GL_ARB_shading_language_420pack = _gl_has_extension(procs, "GL_ARB_shading_language_420pack");
    procs.GL_ARB_shading_language_include = _gl_has_extension(procs, "GL_ARB_shading_language_include");
    procs.GL_ARB_shading_language_packing = _gl_has_extension(procs, "GL_ARB_shading_language_packing");
    procs.GL_ARB_shadow = _gl_has_extension(procs, "GL_ARB_shadow");
    procs.GL_ARB_shadow_ambient = _gl_has_extension(procs, "GL_ARB_shadow_ambient");
    procs.GL_ARB_sparse_buffer = _gl_has_extension(procs, "GL_ARB_sparse_buffer");
    procs.GL_ARB_sparse_texture = _gl_has_extension(procs, "GL_ARB_sparse_texture");
    procs.GL_ARB_sparse_texture2 = _gl_has_extension(procs, "GL_ARB_sparse_texture2");
    procs.GL_ARB_sparse_texture_clamp = _gl_has_extension(procs, "GL_ARB_sparse_texture_clamp");
    procs.GL_ARB_spirv_extensions = _gl_has_extension(procs, "GL_ARB_spirv_extensions");
    procs.GL_ARB_stencil_texturing = _gl_has_extension(procs, "GL_ARB_stencil_texturing");
    procs.GL_ARB_sync = _gl_has_extension(procs, "GL_ARB_sync");
    procs.GL_ARB_tessellation_shader = _gl_has_extension(procs, "GL_ARB_tessellation_shader");
    procs.GL_ARB_texture_barrier = _gl_has_extension(procs, "GL_ARB_texture_barrier");
    procs.GL_ARB_texture_border_clamp = _gl_has_extension(procs, "GL_ARB_texture_border_clamp");
    procs.GL_ARB_texture_buffer_object = _gl_has_extension(procs, "GL_ARB_texture_buffer_object");
    procs.GL_ARB_texture_buffer_object_rgb32 = _gl_has_extension(procs, "GL_ARB_texture_buffer_object_rgb32");
    procs.GL_ARB_texture_buffer_range = _gl_has_extension(procs, "GL_ARB_texture_buffer_range");
    procs.GL_ARB_texture_compression = _gl_has_extension(procs, "GL_ARB_texture_compression");
    procs.GL_ARB_texture_compression_bptc = _gl_has_extension(procs, "GL_ARB_texture_compression_bptc");
    procs.GL_ARB_texture_compression_rgtc = _gl_has_extension(procs, "GL_ARB_texture_compression_rgtc");
    procs.GL_ARB_texture_cube_map = _gl_has_extension(procs, "GL_ARB_texture_cube_map");
    procs.GL_ARB_texture_cube_map_array = _gl_has_extension(procs, "GL_ARB_texture_cube_map_array");
    procs.GL_ARB_texture_env_add = _gl_has_extension(procs, "GL_ARB_texture_env_add");
    procs.GL_ARB_texture_env_combine = _gl_has_extension(procs, "GL_ARB_texture_env_combine");
    procs.GL_ARB_texture_env_crossbar = _gl_has_extension(procs, "GL_ARB_texture_env_crossbar");
    procs.GL_ARB_texture_env_dot3 = _gl_has_extension(procs, "GL_ARB_texture_env_dot3");
    procs.GL_ARB_texture_filter_anisotropic = _gl_has_extension(procs, "GL_ARB_texture_filter_anisotropic");
    procs.GL_ARB_texture_filter_minmax = _gl_has_extension(procs, "GL_ARB_texture_filter_minmax");
    procs.GL_ARB_texture_float = _gl_has_extension(procs, "GL_ARB_texture_float");
    procs.GL_ARB_texture_gather = _gl_has_extension(procs, "GL_ARB_texture_gather");
    procs.GL_ARB_texture_mirror_clamp_to_edge = _gl_has_extension(procs, "GL_ARB_texture_mirror_clamp_to_edge");
    procs.GL_ARB_texture_mirrored_repeat = _gl_has_extension(procs, "GL_ARB_texture_mirrored_repeat");
    procs.GL_ARB_texture_multisample = _gl_has_extension(procs, "GL_ARB_texture_multisample");
    procs.GL_ARB_texture_non_power_of_two = _gl_has_extension(procs, "GL_ARB_texture_non_power_of_two");
    procs.GL_ARB_texture_query_levels = _gl_has_extension(procs, "GL_ARB_texture_query_levels");
    procs.GL_ARB_texture_query_lod = _gl_has_extension(procs, "GL_ARB_texture_query_lod");
    procs.GL_ARB_texture_rectangle = _gl_has_extension(procs, "GL_ARB_texture_rectangle");
    procs.GL_ARB_texture_rg = _gl_has_extension(procs, "GL_ARB_texture_rg");
    procs.GL_ARB_texture_rgb10_a2ui = _gl_has_extension(procs, "GL_ARB_texture_rgb10_a2ui");
    procs.GL_ARB_texture_stencil8 = _gl_has_extension(procs, "GL_ARB_texture_stencil8");
    procs.GL_ARB_texture_storage = _gl_has_extension(procs, "GL_ARB_texture_storage");
    procs.GL_ARB_texture_storage_multisample = _gl_has_extension(procs, "GL_ARB_texture_storage_multisample");
    procs.GL_ARB_texture_swizzle = _gl_has_extension(procs, "GL_ARB_texture_swizzle");
    procs.GL_ARB_texture_view = _gl_has_extension(procs, "GL_ARB_texture_view");
    procs.GL_ARB_timer_query = _gl_has_extension(procs, "GL_ARB_timer_query");
    procs.GL_ARB_transform_feedback2 = _gl_has_extension(procs, "GL_ARB_transform_feedback2");
    procs.GL_ARB_transform_feedback3 = _gl_has_extension(procs, "GL_ARB_transform_feedback3");
    procs.GL_ARB_transform_feedback_instanced = _gl_has_extension(procs, "GL_ARB_transform_feedback_instanced");
    procs.GL_ARB_transform_feedback_overflow_query = _gl_has_extension(procs, "GL_ARB_transform_feedback_overflow_query");
    procs.GL_ARB_transpose_matrix = _gl_has_extension(procs, "GL_ARB_transpose_matrix");
    procs.GL_ARB_uniform_buffer_object = _gl_has_extension(procs, "GL_ARB_uniform_buffer_object");
    procs.GL_ARB_vertex_array_bgra = _gl_has_extension(procs, "GL_ARB_vertex_array_bgra");
    procs.GL_ARB_vertex_array_object = _gl_has_extension(procs, "GL_ARB_vertex_array_object");
    procs.GL_ARB_vertex_attrib_64bit = _gl_has_extension(procs, "GL_ARB_vertex_attrib_64bit");
    procs.GL_ARB_vertex_attrib_binding = _gl_has_extension(procs, "GL_ARB_vertex_attrib_binding");
    procs.GL_ARB_vertex_blend = _gl_has_extension(procs, "GL_ARB_vertex_blend");
    procs.GL_ARB_vertex_buffer_object = _gl_has_extension(procs, "GL_ARB_vertex_buffer_object");
    procs.GL_ARB_vertex_program = _gl_has_extension(procs, "GL_ARB_vertex_program");
    procs.GL_ARB_vertex_shader = _gl_has_extension(procs, "GL_ARB_vertex_shader");
    procs.GL_ARB_vertex_type_10f_11f_11f_rev = _gl_has_extension(procs, "GL_ARB_vertex_type_10f_11f_11f_rev");
    procs.GL_ARB_vertex_type_2_10_10_10_rev = _gl_has_extension(procs, "GL_ARB_vertex_type_2_10_10_10_rev");
    procs.GL_ARB_viewport_array = _gl_has_extension(procs, "GL_ARB_viewport_array");
    procs.GL_ARB_window_pos = _gl_has_extension(procs, "GL_ARB_window_pos");
    procs.GL_ATI_draw_buffers = _gl_has_extension(procs, "GL_ATI_draw_buffers");
    procs.GL_ATI_element_array = _gl_has_extension(procs, "GL_ATI_element_array");
    procs.GL_ATI_envmap_bumpmap = _gl_has_extension(procs, "GL_ATI_envmap_bumpmap");
    procs.GL_ATI_fragment_shader = _gl_has_extension(procs, "GL_ATI_fragment_shader");
    procs.GL_ATI_map_object_buffer = _gl_has_extension(procs, "GL_ATI_map_object_buffer");
    procs.GL_ATI_meminfo = _gl_has_extension(procs, "GL_ATI_meminfo");
    procs.GL_ATI_pixel_format_float = _gl_has_extension(procs, "GL_ATI_pixel_format_float");
    procs.GL_ATI_pn_triangles = _gl_has_extension(procs, "GL_ATI_pn_triangles");
    procs.GL_ATI_separate_stencil = _gl_has_extension(procs, "GL_ATI_separate_stencil");
    procs.GL_ATI_text_fragment_shader = _gl_has_extension(procs, "GL_ATI_text_fragment_shader");
    procs.GL_ATI_texture_env_combine3 = _gl_has_extension(procs, "GL_ATI_texture_env_combine3");
    procs.GL_ATI_texture_float = _gl_has_extension(procs, "GL_ATI_texture_float");
    procs.GL_ATI_texture_mirror_once = _gl_has_extension(procs, "GL_ATI_texture_mirror_once");
    procs.GL_ATI_vertex_array_object = _gl_has_extension(procs, "GL_ATI_vertex_array_object");
    procs.GL_ATI_vertex_attrib_array_object = _gl_has_extension(procs, "GL_ATI_vertex_attrib_array_object");
    procs.GL_ATI_vertex_streams = _gl_has_extension(procs, "GL_ATI_vertex_streams");
    procs.GL_EXT_422_pixels = _gl_has_extension(procs, "GL_EXT_422_pixels");
    procs.GL_EXT_abgr = _gl_has_extension(procs, "GL_EXT_abgr");
    procs.GL_EXT_bgra = _gl_has_extension(procs, "GL_EXT_bgra");
    procs.GL_EXT_bindable_uniform = _gl_has_extension(procs, "GL_EXT_bindable_uniform");
    procs.GL_EXT_blend_color = _gl_has_extension(procs, "GL_EXT_blend_color");
    procs.GL_EXT_blend_equation_separate = _gl_has_extension(procs, "GL_EXT_blend_equation_separate");
    procs.GL_EXT_blend_func_separate = _gl_has_extension(procs, "GL_EXT_blend_func_separate");
    procs.GL_EXT_blend_logic_op = _gl_has_extension(procs, "GL_EXT_blend_logic_op");
    procs.GL_EXT_blend_minmax = _gl_has_extension(procs, "GL_EXT_blend_minmax");
    procs.GL_EXT_blend_subtract = _gl_has_extension(procs, "GL_EXT_blend_subtract");
    procs.GL_EXT_clip_volume_hint = _gl_has_extension(procs, "GL_EXT_clip_volume_hint");
    procs.GL_EXT_cmyka = _gl_has_extension(procs, "GL_EXT_cmyka");
    procs.GL_EXT_color_subtable = _gl_has_extension(procs, "GL_EXT_color_subtable");
    procs.GL_EXT_compiled_vertex_array = _gl_has_extension(procs, "GL_EXT_compiled_vertex_array");
    procs.GL_EXT_convolution = _gl_has_extension(procs, "GL_EXT_convolution");
    procs.GL_EXT_coordinate_frame = _gl_has_extension(procs, "GL_EXT_coordinate_frame");
    procs.GL_EXT_copy_texture = _gl_has_extension(procs, "GL_EXT_copy_texture");
    procs.GL_EXT_cull_vertex = _gl_has_extension(procs, "GL_EXT_cull_vertex");
    procs.GL_EXT_debug_label = _gl_has_extension(procs, "GL_EXT_debug_label");
    procs.GL_EXT_debug_marker = _gl_has_extension(procs, "GL_EXT_debug_marker");
    procs.GL_EXT_depth_bounds_test = _gl_has_extension(procs, "GL_EXT_depth_bounds_test");
    procs.GL_EXT_direct_state_access = _gl_has_extension(procs, "GL_EXT_direct_state_access");
    procs.GL_EXT_draw_buffers2 = _gl_has_extension(procs, "GL_EXT_draw_buffers2");
    procs.GL_EXT_draw_instanced = _gl_has_extension(procs, "GL_EXT_draw_instanced");
    procs.GL_EXT_draw_range_elements = _gl_has_extension(procs, "GL_EXT_draw_range_elements");
    procs.GL_EXT_external_buffer = _gl_has_extension(procs, "GL_EXT_external_buffer");
    procs.GL_EXT_fog_coord = _gl_has_extension(procs, "GL_EXT_fog_coord");
    procs.GL_EXT_framebuffer_blit = _gl_has_extension(procs, "GL_EXT_framebuffer_blit");
    procs.GL_EXT_framebuffer_multisample = _gl_has_extension(procs, "GL_EXT_framebuffer_multisample");
    procs.GL_EXT_framebuffer_multisample_blit_scaled = _gl_has_extension(procs, "GL_EXT_framebuffer_multisample_blit_scaled");
    procs.GL_EXT_framebuffer_object = _gl_has_extension(procs, "GL_EXT_framebuffer_object");
    procs.GL_EXT_framebuffer_sRGB = _gl_has_extension(procs, "GL_EXT_framebuffer_sRGB");
    procs.GL_EXT_geometry_shader4 = _gl_has_extension(procs, "GL_EXT_geometry_shader4");
    procs.GL_EXT_gpu_program_parameters = _gl_has_extension(procs, "GL_EXT_gpu_program_parameters");
    procs.GL_EXT_gpu_shader4 = _gl_has_extension(procs, "GL_EXT_gpu_shader4");
    procs.GL_EXT_histogram = _gl_has_extension(procs, "GL_EXT_histogram");
    procs.GL_EXT_index_array_formats = _gl_has_extension(procs, "GL_EXT_index_array_formats");
    procs.GL_EXT_index_func = _gl_has_extension(procs, "GL_EXT_index_func");
    procs.GL_EXT_index_material = _gl_has_extension(procs, "GL_EXT_index_material");
    procs.GL_EXT_index_texture = _gl_has_extension(procs, "GL_EXT_index_texture");
    procs.GL_EXT_light_texture = _gl_has_extension(procs, "GL_EXT_light_texture");
    procs.GL_EXT_memory_object = _gl_has_extension(procs, "GL_EXT_memory_object");
    procs.GL_EXT_memory_object_fd = _gl_has_extension(procs, "GL_EXT_memory_object_fd");
    procs.GL_EXT_memory_object_win32 = _gl_has_extension(procs, "GL_EXT_memory_object_win32");
    procs.GL_EXT_misc_attribute = _gl_has_extension(procs, "GL_EXT_misc_attribute");
    procs.GL_EXT_multi_draw_arrays = _gl_has_extension(procs, "GL_EXT_multi_draw_arrays");
    procs.GL_EXT_multisample = _gl_has_extension(procs, "GL_EXT_multisample");
    procs.GL_EXT_packed_depth_stencil = _gl_has_extension(procs, "GL_EXT_packed_depth_stencil");
    procs.GL_EXT_packed_float = _gl_has_extension(procs, "GL_EXT_packed_float");
    procs.GL_EXT_packed_pixels = _gl_has_extension(procs, "GL_EXT_packed_pixels");
    procs.GL_EXT_paletted_texture = _gl_has_extension(procs, "GL_EXT_paletted_texture");
    procs.GL_EXT_pixel_buffer_object = _gl_has_extension(procs, "GL_EXT_pixel_buffer_object");
    procs.GL_EXT_pixel_transform = _gl_has_extension(procs, "GL_EXT_pixel_transform");
    procs.GL_EXT_pixel_transform_color_table = _gl_has_extension(procs, "GL_EXT_pixel_transform_color_table");
    procs.GL_EXT_point_parameters = _gl_has_extension(procs, "GL_EXT_point_parameters");
    procs.GL_EXT_polygon_offset = _gl_has_extension(procs, "GL_EXT_polygon_offset");
    procs.GL_EXT_polygon_offset_clamp = _gl_has_extension(procs, "GL_EXT_polygon_offset_clamp");
    procs.GL_EXT_post_depth_coverage = _gl_has_extension(procs, "GL_EXT_post_depth_coverage");
    procs.GL_EXT_provoking_vertex = _gl_has_extension(procs, "GL_EXT_provoking_vertex");
    procs.GL_EXT_raster_multisample = _gl_has_extension(procs, "GL_EXT_raster_multisample");
    procs.GL_EXT_rescale_normal = _gl_has_extension(procs, "GL_EXT_rescale_normal");
    procs.GL_EXT_secondary_color = _gl_has_extension(procs, "GL_EXT_secondary_color");
    procs.GL_EXT_semaphore = _gl_has_extension(procs, "GL_EXT_semaphore");
    procs.GL_EXT_semaphore_fd = _gl_has_extension(procs, "GL_EXT_semaphore_fd");
    procs.GL_EXT_semaphore_win32 = _gl_has_extension(procs, "GL_EXT_semaphore_win32");
    procs.GL_EXT_separate_shader_objects = _gl_has_extension(procs, "GL_EXT_separate_shader_objects");
    procs.GL_EXT_separate_specular_color = _gl_has_extension(procs, "GL_EXT_separate_specular_color");
    procs.GL_EXT_shader_framebuffer_fetch = _gl_has_extension(procs, "GL_EXT_shader_framebuffer_fetch");
    procs.GL_EXT_shader_framebuffer_fetch_non_coherent = _gl_has_extension(procs, "GL_EXT_shader_framebuffer_fetch_non_coherent");
    procs.GL_EXT_shader_image_load_formatted = _gl_has_extension(procs, "GL_EXT_shader_image_load_formatted");
    procs.GL_EXT_shader_image_load_store = _gl_has_extension(procs, "GL_EXT_shader_image_load_store");
    procs.GL_EXT_shader_integer_mix = _gl_has_extension(procs, "GL_EXT_shader_integer_mix");
    procs.GL_EXT_shadow_funcs = _gl_has_extension(procs, "GL_EXT_shadow_funcs");
    procs.GL_EXT_shared_texture_palette = _gl_has_extension(procs, "GL_EXT_shared_texture_palette");
    procs.GL_EXT_sparse_texture2 = _gl_has_extension(procs, "GL_EXT_sparse_texture2");
    procs.GL_EXT_stencil_clear_tag = _gl_has_extension(procs, "GL_EXT_stencil_clear_tag");
    procs.GL_EXT_stencil_two_side = _gl_has_extension(procs, "GL_EXT_stencil_two_side");
    procs.GL_EXT_stencil_wrap = _gl_has_extension(procs, "GL_EXT_stencil_wrap");
    procs.GL_EXT_subtexture = _gl_has_extension(procs, "GL_EXT_subtexture");
    procs.GL_EXT_texture = _gl_has_extension(procs, "GL_EXT_texture");
    procs.GL_EXT_texture3D = _gl_has_extension(procs, "GL_EXT_texture3D");
    procs.GL_EXT_texture_array = _gl_has_extension(procs, "GL_EXT_texture_array");
    procs.GL_EXT_texture_buffer_object = _gl_has_extension(procs, "GL_EXT_texture_buffer_object");
    procs.GL_EXT_texture_compression_latc = _gl_has_extension(procs, "GL_EXT_texture_compression_latc");
    procs.GL_EXT_texture_compression_rgtc = _gl_has_extension(procs, "GL_EXT_texture_compression_rgtc");
    procs.GL_EXT_texture_compression_s3tc = _gl_has_extension(procs, "GL_EXT_texture_compression_s3tc");
    procs.GL_EXT_texture_cube_map = _gl_has_extension(procs, "GL_EXT_texture_cube_map");
    procs.GL_EXT_texture_env_add = _gl_has_extension(procs, "GL_EXT_texture_env_add");
    procs.GL_EXT_texture_env_combine = _gl_has_extension(procs, "GL_EXT_texture_env_combine");
    procs.GL_EXT_texture_env_dot3 = _gl_has_extension(procs, "GL_EXT_texture_env_dot3");
    procs.GL_EXT_texture_filter_anisotropic = _gl_has_extension(procs, "GL_EXT_texture_filter_anisotropic");
    procs.GL_EXT_texture_filter_minmax = _gl_has_extension(procs, "GL_EXT_texture_filter_minmax");
    procs.GL_EXT_texture_integer = _gl_has_extension(procs, "GL_EXT_texture_integer");
    procs.GL_EXT_texture_lod_bias = _gl_has_extension(procs, "GL_EXT_texture_lod_bias");
    procs.GL_EXT_texture_mirror_clamp = _gl_has_extension(procs, "GL_EXT_texture_mirror_clamp");
    procs.GL_EXT_texture_object = _gl_has_extension(procs, "GL_EXT_texture_object");
    procs.GL_EXT_texture_perturb_normal = _gl_has_extension(procs, "GL_EXT_texture_perturb_normal");
    procs.GL_EXT_texture_sRGB = _gl_has_extension(procs, "GL_EXT_texture_sRGB");
    procs.GL_EXT_texture_sRGB_decode = _gl_has_extension(procs, "GL_EXT_texture_sRGB_decode");
    procs.GL_EXT_texture_shared_exponent = _gl_has_extension(procs, "GL_EXT_texture_shared_exponent");
    procs.GL_EXT_texture_snorm = _gl_has_extension(procs, "GL_EXT_texture_snorm");
    procs.GL_EXT_texture_swizzle = _gl_has_extension(procs, "GL_EXT_texture_swizzle");
    procs.GL_EXT_timer_query = _gl_has_extension(procs, "GL_EXT_timer_query");
    procs.GL_EXT_transform_feedback = _gl_has_extension(procs, "GL_EXT_transform_feedback");
    procs.GL_EXT_vertex_array = _gl_has_extension(procs, "GL_EXT_vertex_array");
    procs.GL_EXT_vertex_array_bgra = _gl_has_extension(procs, "GL_EXT_vertex_array_bgra");
    procs.GL_EXT_vertex_attrib_64bit = _gl_has_extension(procs, "GL_EXT_vertex_attrib_64bit");
    procs.GL_EXT_vertex_shader = _gl_has_extension(procs, "GL_EXT_vertex_shader");
    procs.GL_EXT_vertex_weighting = _gl_has_extension(procs, "GL_EXT_vertex_weighting");
    procs.GL_EXT_win32_keyed_mutex = _gl_has_extension(procs, "GL_EXT_win32_keyed_mutex");
    procs.GL_EXT_window_rectangles = _gl_has_extension(procs, "GL_EXT_window_rectangles");
    procs.GL_EXT_x11_sync_object = _gl_has_extension(procs, "GL_EXT_x11_sync_object");
    procs.GL_GREMEDY_frame_terminator = _gl_has_extension(procs, "GL_GREMEDY_frame_terminator");
    procs.GL_GREMEDY_string_marker = _gl_has_extension(procs, "GL_GREMEDY_string_marker");
    procs.GL_HP_convolution_border_modes = _gl_has_extension(procs, "GL_HP_convolution_border_modes");
    procs.GL_HP_image_transform = _gl_has_extension(procs, "GL_HP_image_transform");
    procs.GL_HP_occlusion_test = _gl_has_extension(procs, "GL_HP_occlusion_test");
    procs.GL_HP_texture_lighting = _gl_has_extension(procs, "GL_HP_texture_lighting");
    procs.GL_IBM_cull_vertex = _gl_has_extension(procs, "GL_IBM_cull_vertex");
    procs.GL_IBM_multimode_draw_arrays = _gl_has_extension(procs, "GL_IBM_multimode_draw_arrays");
    procs.GL_IBM_rasterpos_clip = _gl_has_extension(procs, "GL_IBM_rasterpos_clip");
    procs.GL_IBM_static_data = _gl_has_extension(procs, "GL_IBM_static_data");
    procs.GL_IBM_texture_mirrored_repeat = _gl_has_extension(procs, "GL_IBM_texture_mirrored_repeat");
    procs.GL_IBM_vertex_array_lists = _gl_has_extension(procs, "GL_IBM_vertex_array_lists");
    procs.GL_INGR_blend_func_separate = _gl_has_extension(procs, "GL_INGR_blend_func_separate");
    procs.GL_INGR_color_clamp = _gl_has_extension(procs, "GL_INGR_color_clamp");
    procs.GL_INGR_interlace_read = _gl_has_extension(procs, "GL_INGR_interlace_read");
    procs.GL_INTEL_conservative_rasterization = _gl_has_extension(procs, "GL_INTEL_conservative_rasterization");
    procs.GL_INTEL_fragment_shader_ordering = _gl_has_extension(procs, "GL_INTEL_fragment_shader_ordering");
    procs.GL_INTEL_framebuffer_CMAA = _gl_has_extension(procs, "GL_INTEL_framebuffer_CMAA");
    procs.GL_INTEL_map_texture = _gl_has_extension(procs, "GL_INTEL_map_texture");
    procs.GL_INTEL_parallel_arrays = _gl_has_extension(procs, "GL_INTEL_parallel_arrays");
    procs.GL_INTEL_performance_query = _gl_has_extension(procs, "GL_INTEL_performance_query");
    procs.GL_KHR_blend_equation_advanced = _gl_has_extension(procs, "GL_KHR_blend_equation_advanced");
    procs.GL_KHR_blend_equation_advanced_coherent = _gl_has_extension(procs, "GL_KHR_blend_equation_advanced_coherent");
    procs.GL_KHR_context_flush_control = _gl_has_extension(procs, "GL_KHR_context_flush_control");
    procs.GL_KHR_debug = _gl_has_extension(procs, "GL_KHR_debug");
    procs.GL_KHR_no_error = _gl_has_extension(procs, "GL_KHR_no_error");
    procs.GL_KHR_parallel_shader_compile = _gl_has_extension(procs, "GL_KHR_parallel_shader_compile");
    procs.GL_KHR_robust_buffer_access_behavior = _gl_has_extension(procs, "GL_KHR_robust_buffer_access_behavior");
    procs.GL_KHR_robustness = _gl_has_extension(procs, "GL_KHR_robustness");
    procs.GL_KHR_texture_compression_astc_hdr = _gl_has_extension(procs, "GL_KHR_texture_compression_astc_hdr");
    procs.GL_KHR_texture_compression_astc_ldr = _gl_has_extension(procs, "GL_KHR_texture_compression_astc_ldr");
    procs.GL_KHR_texture_compression_astc_sliced_3d = _gl_has_extension(procs, "GL_KHR_texture_compression_astc_sliced_3d");
    procs.GL_MESAX_texture_stack = _gl_has_extension(procs, "GL_MESAX_texture_stack");
    procs.GL_MESA_pack_invert = _gl_has_extension(procs, "GL_MESA_pack_invert");
    procs.GL_MESA_program_binary_formats = _gl_has_extension(procs, "GL_MESA_program_binary_formats");
    procs.GL_MESA_resize_buffers = _gl_has_extension(procs, "GL_MESA_resize_buffers");
    procs.GL_MESA_shader_integer_functions = _gl_has_extension(procs, "GL_MESA_shader_integer_functions");
    procs.GL_MESA_tile_raster_order = _gl_has_extension(procs, "GL_MESA_tile_raster_order");
    procs.GL_MESA_window_pos = _gl_has_extension(procs, "GL_MESA_window_pos");
    procs.GL_MESA_ycbcr_texture = _gl_has_extension(procs, "GL_MESA_ycbcr_texture");
    procs.GL_NVX_blend_equation_advanced_multi_draw_buffers = _gl_has_extension(procs, "GL_NVX_blend_equation_advanced_multi_draw_buffers");
    procs.GL_NVX_conditional_render = _gl_has_extension(procs, "GL_NVX_conditional_render");
    procs.GL_NVX_gpu_memory_info = _gl_has_extension(procs, "GL_NVX_gpu_memory_info");
    procs.GL_NVX_linked_gpu_multicast = _gl_has_extension(procs, "GL_NVX_linked_gpu_multicast");
    procs.GL_NV_alpha_to_coverage_dither_control = _gl_has_extension(procs, "GL_NV_alpha_to_coverage_dither_control");
    procs.GL_NV_bindless_multi_draw_indirect = _gl_has_extension(procs, "GL_NV_bindless_multi_draw_indirect");
    procs.GL_NV_bindless_multi_draw_indirect_count = _gl_has_extension(procs, "GL_NV_bindless_multi_draw_indirect_count");
    procs.GL_NV_bindless_texture = _gl_has_extension(procs, "GL_NV_bindless_texture");
    procs.GL_NV_blend_equation_advanced = _gl_has_extension(procs, "GL_NV_blend_equation_advanced");
    procs.GL_NV_blend_equation_advanced_coherent = _gl_has_extension(procs, "GL_NV_blend_equation_advanced_coherent");
    procs.GL_NV_blend_minmax_factor = _gl_has_extension(procs, "GL_NV_blend_minmax_factor");
    procs.GL_NV_blend_square = _gl_has_extension(procs, "GL_NV_blend_square");
    procs.GL_NV_clip_space_w_scaling = _gl_has_extension(procs, "GL_NV_clip_space_w_scaling");
    procs.GL_NV_command_list = _gl_has_extension(procs, "GL_NV_command_list");
    procs.GL_NV_compute_program5 = _gl_has_extension(procs, "GL_NV_compute_program5");
    procs.GL_NV_conditional_render = _gl_has_extension(procs, "GL_NV_conditional_render");
    procs.GL_NV_conservative_raster = _gl_has_extension(procs, "GL_NV_conservative_raster");
    procs.GL_NV_conservative_raster_dilate = _gl_has_extension(procs, "GL_NV_conservative_raster_dilate");
    procs.GL_NV_conservative_raster_pre_snap = _gl_has_extension(procs, "GL_NV_conservative_raster_pre_snap");
    procs.GL_NV_conservative_raster_pre_snap_triangles = _gl_has_extension(procs, "GL_NV_conservative_raster_pre_snap_triangles");
    procs.GL_NV_conservative_raster_underestimation = _gl_has_extension(procs, "GL_NV_conservative_raster_underestimation");
    procs.GL_NV_copy_depth_to_color = _gl_has_extension(procs, "GL_NV_copy_depth_to_color");
    procs.GL_NV_copy_image = _gl_has_extension(procs, "GL_NV_copy_image");
    procs.GL_NV_deep_texture3D = _gl_has_extension(procs, "GL_NV_deep_texture3D");
    procs.GL_NV_depth_buffer_float = _gl_has_extension(procs, "GL_NV_depth_buffer_float");
    procs.GL_NV_depth_clamp = _gl_has_extension(procs, "GL_NV_depth_clamp");
    procs.GL_NV_draw_texture = _gl_has_extension(procs, "GL_NV_draw_texture");
    procs.GL_NV_draw_vulkan_image = _gl_has_extension(procs, "GL_NV_draw_vulkan_image");
    procs.GL_NV_evaluators = _gl_has_extension(procs, "GL_NV_evaluators");
    procs.GL_NV_explicit_multisample = _gl_has_extension(procs, "GL_NV_explicit_multisample");
    procs.GL_NV_fence = _gl_has_extension(procs, "GL_NV_fence");
    procs.GL_NV_fill_rectangle = _gl_has_extension(procs, "GL_NV_fill_rectangle");
    procs.GL_NV_float_buffer = _gl_has_extension(procs, "GL_NV_float_buffer");
    procs.GL_NV_fog_distance = _gl_has_extension(procs, "GL_NV_fog_distance");
    procs.GL_NV_fragment_coverage_to_color = _gl_has_extension(procs, "GL_NV_fragment_coverage_to_color");
    procs.GL_NV_fragment_program = _gl_has_extension(procs, "GL_NV_fragment_program");
    procs.GL_NV_fragment_program2 = _gl_has_extension(procs, "GL_NV_fragment_program2");
    procs.GL_NV_fragment_program4 = _gl_has_extension(procs, "GL_NV_fragment_program4");
    procs.GL_NV_fragment_program_option = _gl_has_extension(procs, "GL_NV_fragment_program_option");
    procs.GL_NV_fragment_shader_interlock = _gl_has_extension(procs, "GL_NV_fragment_shader_interlock");
    procs.GL_NV_framebuffer_mixed_samples = _gl_has_extension(procs, "GL_NV_framebuffer_mixed_samples");
    procs.GL_NV_framebuffer_multisample_coverage = _gl_has_extension(procs, "GL_NV_framebuffer_multisample_coverage");
    procs.GL_NV_geometry_program4 = _gl_has_extension(procs, "GL_NV_geometry_program4");
    procs.GL_NV_geometry_shader4 = _gl_has_extension(procs, "GL_NV_geometry_shader4");
    procs.GL_NV_geometry_shader_passthrough = _gl_has_extension(procs, "GL_NV_geometry_shader_passthrough");
    procs.GL_NV_gpu_multicast = _gl_has_extension(procs, "GL_NV_gpu_multicast");
    procs.GL_NV_gpu_program4 = _gl_has_extension(procs, "GL_NV_gpu_program4");
    procs.GL_NV_gpu_program5 = _gl_has_extension(procs, "GL_NV_gpu_program5");
    procs.GL_NV_gpu_program5_mem_extended = _gl_has_extension(procs, "GL_NV_gpu_program5_mem_extended");
    procs.GL_NV_gpu_shader5 = _gl_has_extension(procs, "GL_NV_gpu_shader5");
    procs.GL_NV_half_float = _gl_has_extension(procs, "GL_NV_half_float");
    procs.GL_NV_internalformat_sample_query = _gl_has_extension(procs, "GL_NV_internalformat_sample_query");
    procs.GL_NV_light_max_exponent = _gl_has_extension(procs, "GL_NV_light_max_exponent");
    procs.GL_NV_multisample_coverage = _gl_has_extension(procs, "GL_NV_multisample_coverage");
    procs.GL_NV_multisample_filter_hint = _gl_has_extension(procs, "GL_NV_multisample_filter_hint");
    procs.GL_NV_occlusion_query = _gl_has_extension(procs, "GL_NV_occlusion_query");
    procs.GL_NV_packed_depth_stencil = _gl_has_extension(procs, "GL_NV_packed_depth_stencil");
    procs.GL_NV_parameter_buffer_object = _gl_has_extension(procs, "GL_NV_parameter_buffer_object");
    procs.GL_NV_parameter_buffer_object2 = _gl_has_extension(procs, "GL_NV_parameter_buffer_object2");
    procs.GL_NV_path_rendering = _gl_has_extension(procs, "GL_NV_path_rendering");
    procs.GL_NV_path_rendering_shared_edge = _gl_has_extension(procs, "GL_NV_path_rendering_shared_edge");
    procs.GL_NV_pixel_data_range = _gl_has_extension(procs, "GL_NV_pixel_data_range");
    procs.GL_NV_point_sprite = _gl_has_extension(procs, "GL_NV_point_sprite");
    procs.GL_NV_present_video = _gl_has_extension(procs, "GL_NV_present_video");
    procs.GL_NV_primitive_restart = _gl_has_extension(procs, "GL_NV_primitive_restart");
    procs.GL_NV_query_resource = _gl_has_extension(procs, "GL_NV_query_resource");
    procs.GL_NV_query_resource_tag = _gl_has_extension(procs, "GL_NV_query_resource_tag");
    procs.GL_NV_register_combiners = _gl_has_extension(procs, "GL_NV_register_combiners");
    procs.GL_NV_register_combiners2 = _gl_has_extension(procs, "GL_NV_register_combiners2");
    procs.GL_NV_robustness_video_memory_purge = _gl_has_extension(procs, "GL_NV_robustness_video_memory_purge");
    procs.GL_NV_sample_locations = _gl_has_extension(procs, "GL_NV_sample_locations");
    procs.GL_NV_sample_mask_override_coverage = _gl_has_extension(procs, "GL_NV_sample_mask_override_coverage");
    procs.GL_NV_shader_atomic_counters = _gl_has_extension(procs, "GL_NV_shader_atomic_counters");
    procs.GL_NV_shader_atomic_float = _gl_has_extension(procs, "GL_NV_shader_atomic_float");
    procs.GL_NV_shader_atomic_float64 = _gl_has_extension(procs, "GL_NV_shader_atomic_float64");
    procs.GL_NV_shader_atomic_fp16_vector = _gl_has_extension(procs, "GL_NV_shader_atomic_fp16_vector");
    procs.GL_NV_shader_atomic_int64 = _gl_has_extension(procs, "GL_NV_shader_atomic_int64");
    procs.GL_NV_shader_buffer_load = _gl_has_extension(procs, "GL_NV_shader_buffer_load");
    procs.GL_NV_shader_buffer_store = _gl_has_extension(procs, "GL_NV_shader_buffer_store");
    procs.GL_NV_shader_storage_buffer_object = _gl_has_extension(procs, "GL_NV_shader_storage_buffer_object");
    procs.GL_NV_shader_thread_group = _gl_has_extension(procs, "GL_NV_shader_thread_group");
    procs.GL_NV_shader_thread_shuffle = _gl_has_extension(procs, "GL_NV_shader_thread_shuffle");
    procs.GL_NV_stereo_view_rendering = _gl_has_extension(procs, "GL_NV_stereo_view_rendering");
    procs.GL_NV_tessellation_program5 = _gl_has_extension(procs, "GL_NV_tessellation_program5");
    procs.GL_NV_texgen_emboss = _gl_has_extension(procs, "GL_NV_texgen_emboss");
    procs.GL_NV_texgen_reflection = _gl_has_extension(procs, "GL_NV_texgen_reflection");
    procs.GL_NV_texture_barrier = _gl_has_extension(procs, "GL_NV_texture_barrier");
    procs.GL_NV_texture_compression_vtc = _gl_has_extension(procs, "GL_NV_texture_compression_vtc");
    procs.GL_NV_texture_env_combine4 = _gl_has_extension(procs, "GL_NV_texture_env_combine4");
    procs.GL_NV_texture_expand_normal = _gl_has_extension(procs, "GL_NV_texture_expand_normal");
    procs.GL_NV_texture_multisample = _gl_has_extension(procs, "GL_NV_texture_multisample");
    procs.GL_NV_texture_rectangle = _gl_has_extension(procs, "GL_NV_texture_rectangle");
    procs.GL_NV_texture_rectangle_compressed = _gl_has_extension(procs, "GL_NV_texture_rectangle_compressed");
    procs.GL_NV_texture_shader = _gl_has_extension(procs, "GL_NV_texture_shader");
    procs.GL_NV_texture_shader2 = _gl_has_extension(procs, "GL_NV_texture_shader2");
    procs.GL_NV_texture_shader3 = _gl_has_extension(procs, "GL_NV_texture_shader3");
    procs.GL_NV_transform_feedback = _gl_has_extension(procs, "GL_NV_transform_feedback");
    procs.GL_NV_transform_feedback2 = _gl_has_extension(procs, "GL_NV_transform_feedback2");
    procs.GL_NV_uniform_buffer_unified_memory = _gl_has_extension(procs, "GL_NV_uniform_buffer_unified_memory");
    procs.GL_NV_vdpau_interop = _gl_has_extension(procs, "GL_NV_vdpau_interop");
    procs.GL_NV_vertex_array_range = _gl_has_extension(procs, "GL_NV_vertex_array_range");
    procs.GL_NV_vertex_array_range2 = _gl_has_extension(procs, "GL_NV_vertex_array_range2");
    procs.GL_NV_vertex_attrib_integer_64bit = _gl_has_extension(procs, "GL_NV_vertex_attrib_integer_64bit");
    procs.GL_NV_vertex_buffer_unified_memory = _gl_has_extension(procs, "GL_NV_vertex_buffer_unified_memory");
    procs.GL_NV_vertex_program = _gl_has_extension(procs, "GL_NV_vertex_program");
    procs.GL_NV_vertex_program1_1 = _gl_has_extension(procs, "GL_NV_vertex_program1_1");
    procs.GL_NV_vertex_program2 = _gl_has_extension(procs, "GL_NV_vertex_program2");
    procs.GL_NV_vertex_program2_option = _gl_has_extension(procs, "GL_NV_vertex_program2_option");
    procs.GL_NV_vertex_program3 = _gl_has_extension(procs, "GL_NV_vertex_program3");
    procs.GL_NV_vertex_program4 = _gl_has_extension(procs, "GL_NV_vertex_program4");
    procs.GL_NV_video_capture = _gl_has_extension(procs, "GL_NV_video_capture");
    procs.GL_NV_viewport_array2 = _gl_has_extension(procs, "GL_NV_viewport_array2");
    procs.GL_NV_viewport_swizzle = _gl_has_extension(procs, "GL_NV_viewport_swizzle");
    procs.GL_OES_byte_coordinates = _gl_has_extension(procs, "GL_OES_byte_coordinates");
    procs.GL_OES_compressed_paletted_texture = _gl_has_extension(procs, "GL_OES_compressed_paletted_texture");
    procs.GL_OES_fixed_point = _gl_has_extension(procs, "GL_OES_fixed_point");
    procs.GL_OES_query_matrix = _gl_has_extension(procs, "GL_OES_query_matrix");
    procs.GL_OES_read_format = _gl_has_extension(procs, "GL_OES_read_format");
    procs.GL_OES_single_precision = _gl_has_extension(procs, "GL_OES_single_precision");
    procs.GL_OML_interlace = _gl_has_extension(procs, "GL_OML_interlace");
    procs.GL_OML_resample = _gl_has_extension(procs, "GL_OML_resample");
    procs.GL_OML_subsample = _gl_has_extension(procs, "GL_OML_subsample");
    procs.GL_OVR_multiview = _gl_has_extension(procs, "GL_OVR_multiview");
    procs.GL_OVR_multiview2 = _gl_has_extension(procs, "GL_OVR_multiview2");
    procs.GL_PGI_misc_hints = _gl_has_extension(procs, "GL_PGI_misc_hints");
    procs.GL_PGI_vertex_hints = _gl_has_extension(procs, "GL_PGI_vertex_hints");
    procs.GL_REND_screen_coordinates = _gl_has_extension(procs, "GL_REND_screen_coordinates");
    procs.GL_S3_s3tc = _gl_has_extension(procs, "GL_S3_s3tc");
    procs.GL_SGIS_detail_texture = _gl_has_extension(procs, "GL_SGIS_detail_texture");
    procs.GL_SGIS_fog_function = _gl_has_extension(procs, "GL_SGIS_fog_function");
    procs.GL_SGIS_generate_mipmap = _gl_has_extension(procs, "GL_SGIS_generate_mipmap");
    procs.GL_SGIS_multisample = _gl_has_extension(procs, "GL_SGIS_multisample");
    procs.GL_SGIS_pixel_texture = _gl_has_extension(procs, "GL_SGIS_pixel_texture");
    procs.GL_SGIS_point_line_texgen = _gl_has_extension(procs, "GL_SGIS_point_line_texgen");
    procs.GL_SGIS_point_parameters = _gl_has_extension(procs, "GL_SGIS_point_parameters");
    procs.GL_SGIS_sharpen_texture = _gl_has_extension(procs, "GL_SGIS_sharpen_texture");
    procs.GL_SGIS_texture4D = _gl_has_extension(procs, "GL_SGIS_texture4D");
    procs.GL_SGIS_texture_border_clamp = _gl_has_extension(procs, "GL_SGIS_texture_border_clamp");
    procs.GL_SGIS_texture_color_mask = _gl_has_extension(procs, "GL_SGIS_texture_color_mask");
    procs.GL_SGIS_texture_edge_clamp = _gl_has_extension(procs, "GL_SGIS_texture_edge_clamp");
    procs.GL_SGIS_texture_filter4 = _gl_has_extension(procs, "GL_SGIS_texture_filter4");
    procs.GL_SGIS_texture_lod = _gl_has_extension(procs, "GL_SGIS_texture_lod");
    procs.GL_SGIS_texture_select = _gl_has_extension(procs, "GL_SGIS_texture_select");
    procs.GL_SGIX_async = _gl_has_extension(procs, "GL_SGIX_async");
    procs.GL_SGIX_async_histogram = _gl_has_extension(procs, "GL_SGIX_async_histogram");
    procs.GL_SGIX_async_pixel = _gl_has_extension(procs, "GL_SGIX_async_pixel");
    procs.GL_SGIX_blend_alpha_minmax = _gl_has_extension(procs, "GL_SGIX_blend_alpha_minmax");
    procs.GL_SGIX_calligraphic_fragment = _gl_has_extension(procs, "GL_SGIX_calligraphic_fragment");
    procs.GL_SGIX_clipmap = _gl_has_extension(procs, "GL_SGIX_clipmap");
    procs.GL_SGIX_convolution_accuracy = _gl_has_extension(procs, "GL_SGIX_convolution_accuracy");
    procs.GL_SGIX_depth_pass_instrument = _gl_has_extension(procs, "GL_SGIX_depth_pass_instrument");
    procs.GL_SGIX_depth_texture = _gl_has_extension(procs, "GL_SGIX_depth_texture");
    procs.GL_SGIX_flush_raster = _gl_has_extension(procs, "GL_SGIX_flush_raster");
    procs.GL_SGIX_fog_offset = _gl_has_extension(procs, "GL_SGIX_fog_offset");
    procs.GL_SGIX_fragment_lighting = _gl_has_extension(procs, "GL_SGIX_fragment_lighting");
    procs.GL_SGIX_framezoom = _gl_has_extension(procs, "GL_SGIX_framezoom");
    procs.GL_SGIX_igloo_interface = _gl_has_extension(procs, "GL_SGIX_igloo_interface");
    procs.GL_SGIX_instruments = _gl_has_extension(procs, "GL_SGIX_instruments");
    procs.GL_SGIX_interlace = _gl_has_extension(procs, "GL_SGIX_interlace");
    procs.GL_SGIX_ir_instrument1 = _gl_has_extension(procs, "GL_SGIX_ir_instrument1");
    procs.GL_SGIX_list_priority = _gl_has_extension(procs, "GL_SGIX_list_priority");
    procs.GL_SGIX_pixel_texture = _gl_has_extension(procs, "GL_SGIX_pixel_texture");
    procs.GL_SGIX_pixel_tiles = _gl_has_extension(procs, "GL_SGIX_pixel_tiles");
    procs.GL_SGIX_polynomial_ffd = _gl_has_extension(procs, "GL_SGIX_polynomial_ffd");
    procs.GL_SGIX_reference_plane = _gl_has_extension(procs, "GL_SGIX_reference_plane");
    procs.GL_SGIX_resample = _gl_has_extension(procs, "GL_SGIX_resample");
    procs.GL_SGIX_scalebias_hint = _gl_has_extension(procs, "GL_SGIX_scalebias_hint");
    procs.GL_SGIX_shadow = _gl_has_extension(procs, "GL_SGIX_shadow");
    procs.GL_SGIX_shadow_ambient = _gl_has_extension(procs, "GL_SGIX_shadow_ambient");
    procs.GL_SGIX_sprite = _gl_has_extension(procs, "GL_SGIX_sprite");
    procs.GL_SGIX_subsample = _gl_has_extension(procs, "GL_SGIX_subsample");
    procs.GL_SGIX_tag_sample_buffer = _gl_has_extension(procs, "GL_SGIX_tag_sample_buffer");
    procs.GL_SGIX_texture_add_env = _gl_has_extension(procs, "GL_SGIX_texture_add_env");
    procs.GL_SGIX_texture_coordinate_clamp = _gl_has_extension(procs, "GL_SGIX_texture_coordinate_clamp");
    procs.GL_SGIX_texture_lod_bias = _gl_has_extension(procs, "GL_SGIX_texture_lod_bias");
    procs.GL_SGIX_texture_multi_buffer = _gl_has_extension(procs, "GL_SGIX_texture_multi_buffer");
    procs.GL_SGIX_texture_scale_bias = _gl_has_extension(procs, "GL_SGIX_texture_scale_bias");
    procs.GL_SGIX_vertex_preclip = _gl_has_extension(procs, "GL_SGIX_vertex_preclip");
    procs.GL_SGIX_ycrcb = _gl_has_extension(procs, "GL_SGIX_ycrcb");
    procs.GL_SGIX_ycrcb_subsample = _gl_has_extension(procs, "GL_SGIX_ycrcb_subsample");
    procs.GL_SGIX_ycrcba = _gl_has_extension(procs, "GL_SGIX_ycrcba");
    procs.GL_SGI_color_matrix = _gl_has_extension(procs, "GL_SGI_color_matrix");
    procs.GL_SGI_color_table = _gl_has_extension(procs, "GL_SGI_color_table");
    procs.GL_SGI_texture_color_table = _gl_has_extension(procs, "GL_SGI_texture_color_table");
    procs.GL_SUNX_constant_data = _gl_has_extension(procs, "GL_SUNX_constant_data");
    procs.GL_SUN_convolution_border_modes = _gl_has_extension(procs, "GL_SUN_convolution_border_modes");
    procs.GL_SUN_global_alpha = _gl_has_extension(procs, "GL_SUN_global_alpha");
    procs.GL_SUN_mesh_array = _gl_has_extension(procs, "GL_SUN_mesh_array");
    procs.GL_SUN_slice_accum = _gl_has_extension(procs, "GL_SUN_slice_accum");
    procs.GL_SUN_triangle_list = _gl_has_extension(procs, "GL_SUN_triangle_list");
    procs.GL_SUN_vertex = _gl_has_extension(procs, "GL_SUN_vertex");
    procs.GL_WIN_phong_shading = _gl_has_extension(procs, "GL_WIN_phong_shading");
    procs.GL_WIN_specular_fog = _gl_has_extension(procs, "GL_WIN_specular_fog");
}
