# Objective-C runtime helper implementation

Implement the reviewed encoding, method-validation/installation and fragile
class-creation signatures through private encoding and ownership boundaries.
Apple's public runtime encoding grammar and runtime C declarations supply the
native ABI. Canonical bootstrap reflection and Basic builder/allocator types
remain shared; public records and aliases do not change.

Support C-compatible scalar, enum, pointer, fixed-array and naturally laid-out
record encodings. Native method implementations must use C calling convention,
explicit receiver/selector pointer arguments and at most one return. Validate
before installing the real IMP; class methods target the metaclass. Class
creation checks the actual parent instance size and every native ivar offset
before returning an unregistered class, preserving the separate finalize step.
Dispose the unregistered class on failure; do not expose a mismatched layout.

Remaining public review questions stay explicit: exact encoding text for Jai
aliases/unsupported reflection categories, returned-string ownership, class
naming/collision/default-initialization policy, validation error channel and
member-stub output. Supported native behavior will be tested independently;
these helpers will not be counted as fully reviewed compatibility until those
questions are resolved. Reject unrepresentable ABI inputs explicitly rather
than installing unsafe methods or inventing metadata. No public placeholder
for the member-stub generator will be introduced.

Native oracle: Apple's Objective-C Runtime Programming Guide, Type Encodings:
https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
Use installed official SDK runtime headers and independently authored native
programs for method invocation, ivar layout, type sizes, ownership and rollback.

All eight previously missing helper bodies are present. The member-stub helper
now follows the refreshed lowercased-field/instance-size-delta contract and
closes its temporary framework handle. The documented path omits .framework;
the implementation tries that exact spelling first, then the actual installed
bundle spelling. This is an explicit SDK-path workaround pending prose review,
not a claim that the source established the fallback. No instance layout is
created by the generated declaration text.

Native tests pass on x64 and ARM64 Mac: real class allocation, ivar offsets,
instance and metaclass method calls, 32-byte structure-return dispatch, native
NSGetSizeAndAlignment/NSMethodSignature parsing, native object release and
partial-class failure disposal. Contextful IMP implementations are rejected by
the active assertion mechanism (actual signal6/diagnostic retained). Full
Objective_C module sweep:8 source checks,6 host build/run checks and20 relevant
privacy checks pass; unavailable targets are separately marked unsupported.
Production formatting, strict lint, regeneration and68 Python tests pass.
Reports: .work/objc-runtime-complete/checks.json, negative.json and
.work/objc-helper-module.json. The initial native fixture incorrectly called a
contextful constructor from a C callback; adding the required push_context
corrects the test, without changing calling conventions or compiler behavior.

Seven helpers remain conservatively partial in the declaration ledger: native
C-compatible behavior is real, but unsupported reflected categories and exact
Jai-specific policy questions remain. In particular, view/resizable arrays,
strings/Any and non-native overlays are not silently encoded as another ABI.
A private alias to canonical Basic.String_Builder avoids an extra root export.
Native Windows/Linux are inapplicable to this target-specific module; iOS
runtime is unverified. Worker staging is not coordinator combined corpus proof.
