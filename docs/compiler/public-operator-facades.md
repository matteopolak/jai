# Canonical public operator facades

Ordinary operator visibility exposed missing public reexports in Basic, Math and
Bit_Array. Their reviewed contracts require S128/U128 arithmetic, Vector2 arithmetic
and bit indexing/mutation. Canonical independent implementations already existed;
the public type aliases alone did not export those overload sets.

The facades now use anonymous filtered imports of the original declarations.
Basic passes exactly its existing module parameters, preserving canonical storage.
No wrappers, procedure snapshots, new namespace exports or private-scope bypasses
are added. Names, overloads, parameter names, symmetric behavior and ABI retain
their defining declarations. Ordinary anonymous filtered imports explicitly
reexport the selected canonical declarations. An attempted module-valued
`using Impl;` did not export module entries in the current compiler; equivalence
of that separate language form needs review, so it is not treated as a proven
compiler defect or used as the facade's export mechanism.

Integration verifies28 checks: twelve real interpreter/native O0/O2 executions,
eight builds, three compile-time graph/default checks, three exact privacy negatives,
formatting and complete rooted strict lint. Tests cover all reviewed Vector2
overload signatures, named parameters, symmetric multiplication, integer carry/
borrow, Apollo_Time result identity, canonical reflected type names, repeated-import
procedure identity and actual Bit_Array storage mutation. Original Math literal/
variant and Bit_Array behavior fixtures retain every assertion and pass.
See the [machine receipt](../status/shared-operator-facades-verification.json).

The old compiler-resolved-nodes fixture expected New(Code_Ident).kind to be
UNINITIALIZED. The latest reviewed contract and coordinator oracle require IDENT.
Only that premise changes; graph reconstruction assertions stay active. Its
metaprogram explicitly disables output, so three successful compile-time modes
are recorded as compile-time checks, not native program executions. An initial
integration harness incorrectly attempted to launch its absent output; that failed
test construction is retained and corrected without fabricating an executable.

The coordinator's independent oracle confirms that a qualified-only namespace
import does not expose operators implicitly, while an ordinary lexical import
does. The existing Probe positive fixture now adds lexical `using Probe` and
retains every original operator/value assertion. Its namespace-only negative and
the compiler's private type-only facade negatives remain required. No old full
failed aggregate is rewritten or projected green from the focused followups.
