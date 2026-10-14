# Typed struct argument questions

Confirmed: root reports actual official 0.2.030 build success for unchanged examples/31/31.8_channels.jai and for the independent three-line typed-capacity.jai probe. The failing u64-to-s64 reconstruction is a compiler bug, not an application overload or stdlib API gap.

Root's broader independent public.jai probe rejected named inference syntax Parcel(capacity = $Count, T = $Element). It supplied no semantic verdict for later hidden/baked/ordering assertions. That syntax is retained only as a clearly labeled existing compiler extension test and excluded from the compatibility fixture. No alternate reference syntax is guessed or implemented.

Pending root source-only verdict: corrected public.jai without named patterns, or split declaration-order/hidden-binding/direct-baked/qualified-baked controls. Worker asks for sanitized build verdicts only, never implementation bodies/raw logs or direct oracle execution.

The fix preserves the canonical typed constants already stored on each instance, and existing constructor identity/privacy/conversion validation. Variadic generic packs and arbitrary type-producing callable patterns are outside the bounded validation; no broader completeness claim is made.
