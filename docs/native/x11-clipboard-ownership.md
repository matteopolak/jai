# X11 clipboard buffer ownership

`x_release_clipboard_data` now locks the initialized global Display, frees the
module-owned text and pixel allocations, clears both pointers/string count and
all three dimensions, then unlocks. It uses canonical Basic allocation/free
hooks in the caller's allocator domain; module-owned buffers must belong to
that domain. Xlib-owned resources still require their matching Xlib routines.
No public buffer field, layout, storage location or allocator type changed.

The private generic ownership operation supports an independent Mac regression
with actual allocations and a delegating tracking allocator. It verifies one
free for each original pointer, cleared fields, unchanged surrounding canaries
and idempotent second release. Both Mac CPUs pass. This does not execute or
pretend to execute an X server. The real public X11 fixture opens a Display,
transfers real buffers into public module storage and performs the same cleanup;
its Linux x64/ARM64 source checks pass, with real Linux/X server execution still
a required later gate. Production Linux-target strict lint, owned formatting
and regeneration pass.

The remaining X11 initialization, drag-and-drop and selection-predicate
contracts are separately requested in native-bindings-questions.md. The page's
new clipboard paragraph does not specify those helpers' atom strings, type-list
property policy or opaque predicate argument layout. They remain unresolved
rather than receiving guessed bodies or fabricated success.
