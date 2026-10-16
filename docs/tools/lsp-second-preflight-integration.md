# IDE preflight failure reuse

Integrated exact combined source670ee627 and causal test0bcebea4 from3c6bfe01+a411d75c. The earlier1a5996 patch is superseded and was not applied. Both source pre/post SHA guards match the current combined files exactly; no old whole-file copy was used. Native Windows, context/library-phase, Type and ifx implementation files are untouched.

IDE-final common body preflight now shares lenient failure facts, keyed by source/namespace progress and exact procedure AST identity. Sketch recovery and strict non-IDE lowering do not reuse those facts. Body replacement (including parked bodies), visible namespace progress and removal of IDE facts have explicit invalidation controls. The added editor fixture preserves diagnostics, compiles healthy independent code, avoids repeated failed-generator lowering and succeeds after new source supplies its dependency.

Producer four invalidation controls, five editor controls and prior100 LSP checks passed. Local merged verification follows. Root original unchanged60-second timing gate on718 plus this source is pending; earlier first-repair115s remains RED. No timeout/scope waiver, fake IR, ignored error or blanket partial-editor fallback is introduced. Namespace epoch scanning adds IDE-only work and remains subject to the original responsiveness gate; no performance acceptance is projected from focused controls.
