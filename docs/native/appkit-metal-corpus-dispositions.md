# beec AppKit and Metal surface repair

The beec9491 corpus failures exposed two public binding omissions, now repaired
using the refreshed reviewed contracts and public Apple SDK controls. Historical
reference failures were not used as waivers or as an API oracle.

| Case | Root cause and repair | Current application evidence |
| --- | --- | --- |
| `sgpu-build` | AppKit used short collection-behavior names and omitted `using`. It now declares exactly thirteen prefixed members in the canonical `enum_flags NSUInteger`; no short aliases or three newer SDK constants. | The independent original-name reduction passes. The unchanged admitted build replay stops at excluded `modules/Vulkan_With_VMA/module.jai`; coordinator must replay with its permitted dependency. |
| `ui-builder-demo-check` | Render lacked the reviewed first field `using #as mtlcommandencder: MTLCommandEncoder`. Exact regeneration adds that field; existing general promotion exposes all seven base operations and pointer conversion. | The independent inherited-method reduction passes. The unchanged admitted demo replay stops at excluded `Pixel_Maker`; coordinator must replay with its permitted dependency. |

The other three encoder wrappers intentionally have no stored base or NSObject
fields under the reviewed contract. Their 21 absent inherited methods are
required negative checks, although the native SDK protocols inherit those
operations. `MTLCommandEncoder` itself remains seven methods with no stored
fields. No native protocol edge, overload, public alias, or compiler exception
was invented.

The refreshed Metal page separates a field fence from its method inventory.
The spec parser now joins simple named-field fences to exactly one matching
owner/target member list, preserving field order and directives and rejecting
conflicts. It does not flatten anonymous aggregates, merge complete alternate
records, or borrow across targets. Five independent parser tests cover those
boundaries. Auditing current reviewed pages shows only Metal changes: two
Render fragments become one record. Generated production Metal differs by
exactly one field line. AppKit directly reflects its complete reviewed enum.

Focused verification checks both Mac CPU sources, complete AppKit and Metal
strict lint, public/root privacy, exact alias exclusions, all thirteen SDK
flag values, deterministic Metal regeneration, and actual ARM64 O0/O2 and
ASan/UBSan programs. The Render test uses a real SDK-allocated encoder with an
offscreen texture, verifies base/member/receiver pointer identity, calls all
seven inherited operations, and requires actual command-buffer completion.
It releases its objects after completion. No nil substitute, fake GPU result,
window, event loop, or GUI activation is used. Retained AppKit and Metal ABI
programs also execute at O0/O2. Mac x64 has source/SDK compilation only;
Linux/Windows/iOS native evidence is not implied.

The two prior pending reductions are promoted to positive fixtures. The first
verification attempt is preserved: its new method calls omitted explicit self,
its lint context included an unvisited fixture, and one negative diagnostic
matcher was wrong. Corrected tests retain all safety/value assertions and use
exact reviewed self parameters; production methods did not change. They are
not compiler or SDK defects. Final receipt counts and exact immutable hashes
are in `ready_appkit_metal_surface_checkpoint` in the bindings status document.

All thirty admitted application inputs were hash-verified and left unchanged.
Only those inputs were staged under the bindings T7 namespace; excluded
bundled modules were neither read nor staged. Application-frontier failures
remain explicit and do not count as complete application acceptance. Root is
asked for sanitized configured replay diagnostics after source adoption. The
historical UI-builder reference failure was a dynamic-library load failure;
sgpu had no supplied historical first diagnostic.
