# Generic current-context convenience wrapper

The refreshed GL contract specifies `gl_create_context`'s native current-context
side effects and intentionally supplies no ownership handle or destroy helper.
The implementation accepts the target's native window handle through the exact
generic signature, forwards version/profile/debug requests, and creates a real
context. Windows and macOS honor requested MSAA; Linux's framebuffer selection
belongs to window creation and ignores that argument here.

Windows makes the WGL constructor's result current. On failure to make current,
it deletes the new context, releases its DC, and logs the failure; failed cleanup
aborts. macOS creates NSOpenGL with the requested format, attaches the window's
content view and sends the native void `makeCurrentContext` selector. Linux
creates GLX and invokes `glXMakeCurrent`; its unchecked result is explicitly
specified for this convenience wrapper. Constructor failures are diagnosed.

Successful contexts remain native caller-owned, as specified. The void API
cannot deliver explicit ownership, chosen samples, or restoration handles.
Callers that need controlled lifetime should use the platform constructors.
This is a public API limitation, not a private registry or fabricated handle.
Tests retrieve the genuine native current context and clean it up through
native APIs. No extra public exports were added.

The macOS executable checks real current-context identity, attached view,
GL version, restoration and release. Windows executable tests check current
context/DC, real GL query, restoration and native deletion/release; Linux has
source coverage here and still needs real GLX server execution. Six desktop
source configurations and alternative extension/debug configurations are
checked separately from native execution.
