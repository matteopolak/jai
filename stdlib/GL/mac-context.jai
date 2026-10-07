// Independent NSOpenGL pixel-format/context flow from the installed AppKit SDK.
#if OS == .MACOS {
    nsgl_create_context :: (win: *NSWindow, major_version: s32 = 0, minor_version: s32 = 0, compatibility := false, debug := false) -> *NSOpenGLContext {
        if win == null return null;
        glc, _ := nsgl_create_context(major_version, minor_version, compatibility, debug, wanted_msaa = DEFAULT_MSAA);
        if glc == null return null;
        view := NativeGLAppKit.NSWindow.contentView(win);
        if view == null {
            NativeGLObjC.release(glc);
            return null;
        }
        NativeGLAppKit.NSOpenGLContext.setView(glc, view);
        view_class := NativeGLObjC.object_getClass(cast(NativeGLObjC.id) view);
        setter := NativeGLObjC.sel_registerName(cast(*u8) "setOpenGLContext:\0");
        if NativeGLObjC.class_respondsToSelector(view_class, setter) != 0 {
            NativeGLViews.LightweightOpenGLView.setGlContext(cast(*NativeGLViews.LightweightOpenGLView) view, glc);
        }
        NativeGLAppKit.NSOpenGLContext.update(glc);
        return glc;
    }

    nsgl_create_context :: (major_version: s32 = 0, minor_version: s32 = 0, compatibility := false, debug := false, wanted_msaa: s32 = DEFAULT_MSAA) -> *NSOpenGLContext, chosen_msaa: s32 {
        if major_version < 0 || minor_version < 0 || wanted_msaa < 0 return null, 0;
        profile := NativeGLAppKit.NSOpenGLProfileVersion4_1Core;
        if compatibility {
            if major_version >= 3 return null, 0;
            profile = NativeGLAppKit.NSOpenGLProfileVersionLegacy;
        } else if major_version > 0 {
            if major_version < 3 {
                if major_version == 2 && minor_version > 1 return null, 0;
                profile = NativeGLAppKit.NSOpenGLProfileVersionLegacy;
            } else if major_version == 3 {
                if minor_version > 3 return null, 0;
                if minor_version <= 2 profile = NativeGLAppKit.NSOpenGLProfileVersion3_2Core;
            } else if major_version == 4 && minor_version <= 1 {
                profile = NativeGLAppKit.NSOpenGLProfileVersion4_1Core;
            } else return null, 0;
        }
        samples := wanted_msaa;
        while true {
            attributes: [18] NativeGLAppKit.NSOpenGLPixelFormatAttribute;
            attributes[0] = NativeGLAppKit.NSOpenGLPFAAccelerated;
            attributes[1] = NativeGLAppKit.NSOpenGLPFADoubleBuffer;
            attributes[2] = NativeGLAppKit.NSOpenGLPFAOpenGLProfile;
            attributes[3] = profile;
            attributes[4] = NativeGLAppKit.NSOpenGLPFAColorSize;
            attributes[5] = 24;
            attributes[6] = NativeGLAppKit.NSOpenGLPFAAlphaSize;
            attributes[7] = 8;
            attributes[8] = NativeGLAppKit.NSOpenGLPFADepthSize;
            attributes[9] = 24;
            attributes[10] = NativeGLAppKit.NSOpenGLPFAStencilSize;
            attributes[11] = 8;
            attributes[12] = 0;
            if samples > 1 {
                attributes[12] = NativeGLAppKit.NSOpenGLPFAMultisample;
                attributes[13] = NativeGLAppKit.NSOpenGLPFASampleBuffers;
                attributes[14] = 1;
                attributes[15] = NativeGLAppKit.NSOpenGLPFASamples;
                attributes[16] = cast(u32) samples;
                attributes[17] = 0;
            }
            pixel_class := NativeGLObjC.objc_getClass(cast(*u8) "NSOpenGLPixelFormat\0");
            format := NativeGLAppKit.NSOpenGLPixelFormat.initWithAttributes(NativeGLObjC.objc_alloc(pixel_class), *attributes[0]);
            if format != null {
                context_class := NativeGLObjC.objc_getClass(cast(*u8) "NSOpenGLContext\0");
                glc := NativeGLAppKit.NSOpenGLContext.initWithFormat(NativeGLObjC.objc_alloc(context_class), format, null);
                actual: s32 = 0;
                NativeGLAppKit.NSOpenGLPixelFormat.getValues(format, *actual, NativeGLAppKit.NSOpenGLPFASamples, 0);
                NativeGLObjC.release(format);
                if glc == null return null, 0;
                NativeGLAppKit.NSOpenGLContext.makeCurrentContext(glc);
                gl_load(*gl);
                if debug gl_enable_debug_output();
                return glc, actual;
            }
            if samples <= 1 return null, 0;
            samples /= 2;
            if samples <= 1 samples = 0;
        }
    }

    #scope_file
    NativeGLAppKit :: #import "Objective_C/AppKit";
    NativeGLObjC :: #import "Objective_C";
    NativeGLViews :: #import "Objective_C/LightweightRenderingView";
}
