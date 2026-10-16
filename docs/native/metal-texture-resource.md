# Metal texture resource promotion

The reviewed public `MTLTexture` record begins with exactly `using MTLResource;`.
The facade now retains this unnamed member through the ordinary spec generator.
It promotes all ten existing Resource procedures, preserving their canonical
`*MTLResource` receiver signatures and implementation identity. No `#as`, named
base, copied methods, or additional SDK-derived inheritance edges are added.
Render/Color attachment inheritance and the AppKit backing-scale alias are unchanged.

`metal-resource-source-controls.jai` checks all ten promoted procedure types,
the canonical reflected Texture name, and the reviewed wrapper size. Independent
ordinary-field and MTLBuffer controls reject unreviewed promotion. The generic
generator test retains unnamed using in first-member order without synthesizing
an alias. The focused verifier also requires exact full Metal regeneration,
both Mac CPU source checks, complete strict lint, SDK object compilation and
production formatting. Its immutable capture identity accompanies each result.

`metal-texture-resource.jai` and `metal_resource_probe.m` prepare real SDK-owned
shared and heap-backed textures. Calls use the promoted public namespace with
the canonical Resource receiver explicitly viewed from the same native object
pointer. The test does not require implicit child-pointer conversion, infer a
name for the unnamed member, or treat public wrapper size as native object size.
Checks cover actual SDK label set/get in both directions, null reset, device and
heap identity, allocation size, cache/storage policy, purgeability query and
heap-only aliasability. `makeAliasable` is last and is never sent to the shared
texture. SDK allocation failure remains a test failure, with retained objects
released on every initialization failure and normal finish.

Run `tools/native_bindings/verify_metal_resource.py` with own source-built compiler,
lint, formatter and an own T7 output directory. `--native` executes exactly three
sequential programs at O0, O2 and ASan/UBSan and requires a fresh integration lease.
Without it, source/object/link evidence does not establish runtime behavior.
No window, NSApplication or GUI state is created. Mac x64 runtime is a separate
gate; Windows/Linux are outside the reviewed Mac-only Metal target contract.

The original UI-builder replay uses protected application dependencies and is
performed by the coordinator after adopting this stable source. It is not replaced
by these independent positive controls. An optional general unnamed-using pointer
conversion discriminator is recorded separately; no compiler defect or required
conversion is inferred merely from this public declaration.

The granted native cohort completed exactly three ARM64 executions (O0, O2 and
ASan/UBSan), each with exit zero and empty stdout/stderr. All ten promoted
procedure addresses equal their canonical Resource addresses; real SDK shared
and heap textures passed the label, identity and resource-state checks above.
Snapshot hashes matched before/after each execution. The original 27-check
source/link receipt is unchanged. The corrected Basic program-parameter header
was already present in this capture and matches current shared bytes
(`d78e4945a2957822a70ff0baf062ec18b61a5475b9ba71c318de7226d261b407`).
This is proof for the captured source and own pinned compiler, not a later
combined compiler pin. The Jai sanitizer executable was instrumented; the SDK
helper and Apple frameworks were not. The native lease is released.

Root separately reports the protected original UI-builder check now passes.
Root's independent official controls reject both a storage-bearing Base used
without a storage declaration and implicit `*Child` to `*Base` conversion for a
zero-size unnamed-using base. Its explicit-autocast application-style method
call accepts. These verdicts support retaining the exact public edge and
canonical receiver, with no compiler conversion change or `#as` substitute.
