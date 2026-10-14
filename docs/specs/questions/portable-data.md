# Remaining portable data/resource questions

The detailed synchronized review resolves frame count/order/padding and channel
orientation, Windows IDs/language/destructive flag/tool discovery/console effects,
Icon option/lifecycle/post-write protocol, subtitle positional fields/owned
results/CSV counter offset/empty rows, and duplicate/separate-buffer packages.
These contracts are now implemented. Do not reopen those resolved questions.

Only fine-grained observables still omitted from the pages remain:

- ICO resizing: confirm native colorspace, edge/filter defaults and alpha flags
  if exact nonuniform pixels are part of compatibility. Current implementation
  uses actual stbir_resize_uint8_srgb, default filters, clamp edges, flags zero,
  alpha channel 3 for BGRA and none for BGR. Every frame starts from original input.
- Manifest: enumerate the fixed supportedOS GUID subset/order if those exact
  entries are required. Current output uses the five SDK Vista/7/8/8.1/10 IDs.
  No assemblyIdentity is added, as the refreshed contract explicitly directs.
- CSV grouping: does an empty-speaker instant split two otherwise equal speakers,
  or disappear before adjacency grouping? Current code splits that group.
- SDK discovery: confirm selected root means the selected Lib/version directory
  (current behavior), and registry fallback uses SxS/VS7 installation roots.
  These details are not spelled out as registry key/path literals in the page.

No source bodies/reference binaries are requested. Native Windows update/discovery
and positive Icon attachment remain execution gates, not unanswered API shapes.
WASI image/resize support is not established by the reviewed contract; the official
SDK wasm32/our compiler wasm64 mismatch is recorded separately. No fake imports.

Safety policy remains explicit: checked malformed package/ICO extents and subtitle
headers fail safely before borrowed views or native mutation. Reinitializing a
populated Load_Package is outside the reviewed lifecycle contract. Returned
serializer/csv_quote strings are caller released, now explicitly resolved.
