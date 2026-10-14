# SDL3 open questions and boundaries

- docs/implementation-ownership.md was absent at initial implementation and supplied during coordinator review. It has now been read: foundations owns Basic builder/formatting/missing exports; portable owns argument/runtime and remaining portable work. SDL3 ownership remains the new extension and necessary tooling/docs/tests. No peer checkout or other Extensions/SDL2 source was changed.
- SDL3 is a new extension, without a reviewed Jai compatibility API in docs/specs. Its API oracle is exclusively the pinned official public SDL3 C headers; no SDL2 compatibility conveniences are inferred.

- Resolved: the parser consumes bare `remove:` as a control-flow statement. A backtick declaration preserves the canonical `SDL_StorageInterface.remove` field name without changing reflection, storage or ABI; cross-target layout checks cover the field. No public rename is used.
- va_list APIs, statement/generic macros, non-desktop platform declarations and standalone GL/intrinsic headers are explicitly excluded in the extension documentation and generated inventory, rather than represented by placeholder declarations.
