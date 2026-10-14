# Augmented keyframe restriction integration

No compiler sources or peer checkout were changed. The owner needs a language
semantics decision, not a GetRect/module-name workaround.

Minimal source: [augmented_generic_reproducer.jai](../../tests/numerics/augmented_generic_reproducer.jai).
It declares Key, Augmented with `using base: Key`, and `sample :: (keys: []*$T/Key)`.
Calling sample with pointers to Augmented fails on the locally source-built fresh
compiler:

```text
in call to sample: Augmented does not satisfy the restriction `Key`
```

Reproduce:

```sh
JAIC_STDLIB="$PWD/artifacts/stdlib-fresh" artifacts/target/debug/jaic \
  tests/numerics/augmented_generic_reproducer.jai -check
```

The reviewed public Augmented_Keyframe includes `using base: Color_Keyframe`, but
no #as relation. Color_Interpolation's sampling overloads require /Color_Keyframe.
Current production editor sampling copies canonical Color_Keyframe records; it
does not claim direct generic acceptance of augmented pointers. Do not change
the public shape or hardcode type names to satisfy this call.

If reviewed language semantics grant this using relationship, implement the
general restriction/projection rule in the compiler, including pointer field
access, generic inference and both interpreted/native lowering; add unrelated
record and invalid-base regressions. If using grants only member lookup, request
a corrected reviewed contract instead. This document does not assume the former
is correct. The corrective harness verifies the diagnostic as a blocker, not
completed functionality. Jailint cannot lint the rejected call body.
