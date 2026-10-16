# Metal render-pass attachment fields

The reviewed Color wrapper has the first field
`using #as mtlrenderpassattachmentdescriptor: MTLRenderPassAttachmentDescriptor`.
Depth and Stencil instead each have an ordinary first field with the same
name and type. Regeneration adds only the missing Color field; Depth and
Stencil already match. Existing general `using` lookup and `#as` conversion
expose Color's 22 canonical base accessors without new method bodies or casts.
No other inheritance edge or NSObject field is added.

The focused Jai test checks all three public field offsets and wrapper sizes,
Color's canonical reflected name, its implicit base conversion, and all 22
promoted accessors. Depth and Stencil use their named base members explicitly.
Independent negative controls reject their direct `setTexture` lookup and
implicit base conversion on both Mac CPUs. Wrapper size assertions describe
the reviewed public prefix, not full native Objective-C instance allocation.

The independent official-SDK probe allocates a real device, queue, texture and
render-pass descriptor. The native test assigns and detaches Color's texture,
checks SDK storage observations and pointer identity, selects mip level 1,
sets clear/store behavior, and checks explicit Depth/Stencil base access.
The probe then executes an actual offscreen clear, requires command-buffer
completion, and checks every opaque-red pixel plus readback buffer canaries.
It releases owned objects on completion and creation failure. Missing hardware
or any SDK failure produces a failing test, not substituted success. No window,
application activation, event loop, or application-local module is needed.

`tools/native_bindings/verify_metal_attachments.py` captures current shared
inputs, checks both Mac CPU sources and complete Metal strict lint, compiles
both SDK targets, links host O0/O2/sanitizer programs, checks exact regeneration
and formatting, and verifies immutable source hashes. It retains the existing
Metal ABI fixture as source checks. Its default mode does not execute or load
the SDK helper. `--native` additionally runs the three programs and requires
a fresh integration execution lease; a released integration lease does not
automatically authorize overlap with root's full workspace gate.

The pre-fix missing-field reduction, exact source/checkpoint hashes, focused
receipts and execution status are recorded under
`ready_metal_attachment_checkpoint` in the bindings audit. Native evidence is
reported separately from source, SDK object compilation and linking. Mac x64
execution and other-platform native checks are not implied. Root alone replays
the original UI-builder application with its permitted excluded dependencies
after adoption; this clean batch does not read or stage those bodies.
