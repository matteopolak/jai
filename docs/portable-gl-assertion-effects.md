# Real GL operations with optional assertions disabled

Three essential operations were inside optional assertion arguments: texture
upload in backend_realloc_texture's fallback, pixel-pack buffer unmapping, and
Mac context restoration. Genuine offscreen NSOpenGL4.1 controls passed with
assertions enabled. With the actual default Basic assertions disabled, the fresh
texture retained handle zero, the real SDK unmap observer saw zero calls, and the
second context remained selected after restoration. Those reds are retained in
`stdlib/shared-target/gl-assertions-avu180u4/before-fixes.json`.

The operations now run unconditionally. Failed fallback upload logs and asserts
without replacing the old texture. Unmap failure invalidates the copied bitmap
after reader/resource cleanup rather than publishing undefined data. Mac and
Linux restoration calls inspect their SDK results and log/assert failure. Windows
restoration and other Windows context operations were not changed. Optional GL
diagnostic polling was not reclassified as an omitted allocation or draw.

`tools/check_portable_gl_assertions_shared.py` builds the existing independent
gl-context.m producer and a small native observer from source into unique private
scratch. The observer passes the exact unmap target to real glUnmapBuffer and
returns its native result unchanged. No fake context, function result, device or
graphics implementation is used. It does not create a user window or modify any
immutable image/font fixture.

Final current shared-compiler receipt `gl-assertions-final-l922c7c2` passes 53 gates:
23 actual executions (20 offscreen native cases, plus three non-graphics projection
executions), ten native builds, the helper build, six source and six complete
requested-body strict lint contexts, private-unit lint and six formatting gates.
Both assertion defaults and native O0/O2 exercise upload/pixels, real unmap,
context selection, rejected-upload ownership retention, and live procedure-table
assignment/reload. Linux restoration is source checked, not natively executed.

GL procedure projection was independently repaired by the bindings owner and
committed at 209c2bca. This worker changed no GL facade/declaration/generator file.
Its independent projection test checks actual field address identity; the SDK
test clears/restores/reloads the canonical field and observes the same live value.
No immutable per-procedure snapshot alias was added.

The custom offscreen helper requires native execution; no interpreter GPU result
is claimed. Driver-reported unmap corruption recovery is implemented but was not
forced by a fake SDK result. Other fence/map/allocation failure guards and remaining
Windows context/window-class assertion effects are still explicit work; this is
not full rendering or combined GUI acceptance. A draft used Basic.Log_Info even
though Log_Info is a bootstrap type; the compiler rejected it, and the production
qualification was corrected without inventing a Basic export. That failed build
receipt remains separate from the genuine operation omissions.
