# Clean-room implementation workspace

Implement from docs/specs and this sanitized source snapshot only. Do not seek another source checkout, reference distribution, old stdlib implementation, agent transcripts, or upstream Jai implementation. External native library public headers and official documentation may be used for bindings. Never execute a supplied reference compiler or other supplied reference binaries.

Keep stdlib/Extensions intact. Put newly designed stdlib internals in stdlib/internal, public compatibility facades in module folders, and bootstrap definitions in the single stdlib/prelude location. Retain exact public compatibility signatures. Do not infer a private implementation from a public declaration.

Maintain docs/ for meaningful functionality and update docs/README.md. Record unresolved behavior in docs/specs questions without inventing answers. Use the repository's own compiler and tests; no reference binaries. Do not publish, push, retag, or manage releases from this workspace.
