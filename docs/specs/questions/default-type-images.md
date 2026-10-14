# Default Type initialization boundaries

Settled by sanitized official native observations: an implicit Type scalar,
record field or fixed-array element denotes void. Explicit void controls match.
An explicit null descriptor remains invalid; this is not a policy for formatting
null pointers as void.

The general default-image repair and local evidence are documented in
[default Type images](../../compiler/default-type-images.md).

Separate unresolved work remains required: consuming a null lvalue while boxing
Any, the main compiler's Windows import-library loader, and the eight reported
cross-source failures. Their expected results are not changed by this repair.
No conclusion about them is inferred from the Type identity controls.
