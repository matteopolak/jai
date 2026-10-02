// Normalized API contracts; reference procedure bodies were discarded.
EGL_DONT_CARE :: -1;
EGL_UNKNOWN :: -1;
EGL_NO_CONTEXT: EGLContext : null;
EGL_NO_DISPLAY: EGLDisplay : null;
EGL_NO_SURFACE: EGLSurface : null;
EGL_DEFAULT_DISPLAY: EGLNativeDisplayType : null;
EGL_NO_SYNC: EGLSync : null;
EGL_NO_IMAGE: EGLImage : null;
egl_create_context :: (window: *ANativeWindow, wanted_msaa: s32 = 0) -> EGLContext, EGLDisplay, EGLSurface, chosen_msaa: s32 #foreign Native_Adapters "jai_stdlib_Android_EGL_module_jai_egl_create_context_e2a876206fe6";
#load "bindings.jai";
#import "Android";
#import "Basic";

#scope_file
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
