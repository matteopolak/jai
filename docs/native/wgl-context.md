# Native WGL constructor

`GL.wgl_create_context` forwards its exact public signature through the private
`internal/bindings/wgl` adapter. Native handles are canonical Windows aliases;
no SDK declarations become additional GL exports. Official C extension inputs
are hash-pinned in [windows-wgl-inputs.json](windows-wgl-inputs.json).

A hidden standard STATIC window placed on the target display bootstraps a
legacy context. Its acquired common DC is retained for the entire bootstrap
lifetime. Driver procedures are accepted only after checking their WGL
extension namespace, and sentinel failure addresses are rejected. The target
pixel format is set only when absent. Existing formats must support window
OpenGL rendering with double-buffered RGBA. Creation returns the new context,
its retained DC and actual sample count without making that context current;
the caller deletes the context and releases the DC.

Independently chosen format policy requests RGB24, alpha8, depth24 and double
buffering; MSAA candidates halve toward zero when no format matches. An existing
format cannot be changed by Win32, so its actual sample count is returned even
when different from the requested count. Explicit version/profile/debug requests
fail with null handles if the necessary driver route is unavailable. No fake
success or legacy fallback for an explicit unsupported request is provided.

Cleanup calls are checked. A failed cleanup or restoration aborts rather than
silently leaving a different current context. Failure after SetPixelFormat can
leave the target window's format installed, a Win32 irreversible property;
there is no specified portable rollback guarantee or uniform error object.
Last-error preservation is not currently promised. Exact default context/profile
and format ranking are not specified; those choices remain documented policy.

`wgl-context.jai` is a real executable SDK test for invalid handles, creation,
sharing, format reuse, caller resource ownership and current-context restoration.
Both Windows CPUs pass source checks. This macOS worker cannot execute its
native Windows assertions; Windows runtime and C layout probes remain required.
