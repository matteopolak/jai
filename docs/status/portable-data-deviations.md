# Portable data/resource deviations and availability

ICO size-helper formulas are exact. Current encoder is provisional single-frame
standard ICO/DIB: reviewed fixed frame sizes/layout/resize policy are missing.
It is real wire output accepted by LLVM RC; ImageIO decodes 16x16. No full ICO
compatibility is claimed. Filename decoding uses real official stb C, including
Unicode paths, tested in interpreter/native O0/O2. No mock decoder or zero data.

Simple_Package validates counts, extents, names, and table overlap before forming
views. TOC-only checks now also use the real header payload boundary. Every
truncated fixture prefix is rejected. The reviewed exact-EOF empty-package
rejection remains, including for the writer's empty output. Undefined unsafe
malformed-input behavior is not reproduced. Duplicate/reinit policies pending.

Subtitles implements reviewed supported grammar and all public procedures; narrow
event field/lifetime/initial-counter questions remain. Owned serializer/csv_quote
results are currently caller released; this choice awaits lifetime review.
Malformed version headers fail safely. HTML deliberately inserts raw markup,
and section/filename CSV columns are raw as specified.

Native evidence is macOS ARM64 plus compiled WASI under Node. LLVM resource
consumption and cross checks do not establish Win32 update/discovery effects.
Native Windows CI is required. Icon host protocol and Windows resource defaults/
discovery still need reviewed contracts. No declaration stubs count as functionality.

No shared dependency manifest, peer source, Extensions or old foundations staging
is modified. Native dependencies live under this worktree's target/.
