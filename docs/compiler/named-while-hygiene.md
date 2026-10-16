# Caller-visible named while conditions

The NEW independent coordinator fixture macro-while-condition-value-binding.jai
rejects an inserted read of a backtick-named condition. Ordinary named conditions
and inserted labelled break already typecheck. The parser accepted the backtick
but discarded it; semantic lowering therefore declared only the private local.

WhileStmt now retains backtick_label. Named condition lowering and for-loop
iterator lowering share declare_loop_var: a backtick publishes the same local
storage to the active expansion caller, while preserving the private loop binding.
The condition expression is still evaluated at the head on each iteration, with
its actual type and truth conversion. The loop frame remains the target of labelled
break/continue. No library/name/path exceptions or copied variable values are used.
Ordinary private names remain private; backticks outside an expansion do not make
loop locals escape. Exact declaration metadata now uses the label's source span.

Independent tests read and mutate the condition from inserted code, verify the
macro observes the mutation, recompute the condition, and exercise labelled
continue/break. Negative tests retain private-name and invalid-label diagnostics.
Parser and syntax-export tests distinguish backtick binding, private binding and
label-only loops. The private syntax record key __syntax_backtick_label retains
the bit alongside existing label metadata; public Code_While layout is unchanged.

Integration pairs this with the Program_Print WHILE branch emitting that private
bit before the label. Actual edited-record reconstruction and caller-visible
roundtrip now pass interpreter/native O0/O2. Broader nested-expansion visibility
contracts are not inferred from this reduction.

Verification artifacts are local artifacts/compiler-mac-repairs/named-while-*.log.
The independent interpreter reduction fails with unknown condition_value before
the fix and passes afterward. Native and WASM64 execution pass at O0/O2. All three
supplied producer fixtures print ok and exit0 in interpreter/native O0/native O2
(nine actual executions).193 core/unit/focused semantic tests and71 selected
language-server/jailint tests pass. All-target strict clippy for jaic/jaic-llvm/
jai-language-server/jailint, rustfmt and item-spacing checks pass.

Strict -D warnings lint reaches and completes all three producer roots with no
unvisited inputs. It exits1 solely for unused_import on Basic in the label-only
companion; the fixture and warning are preserved, with no suppression. The two
value-binding roots pass strict lint separately. Lint coverage is source-check
evidence; it is distinct from the actual native executions above.
No original corpus body or reference implementation was used.

The separate memory-boundary investigation remains suspended after the disclosed
service rejection; neither it nor project036's unconfirmed cause is addressed by
this ordinary semantic repair. A repository-root filename listing attempted while
locating the owned printer was denied at tests/corpus/negative/modules; no bodies
were read. Subsequent searches use explicitly scoped owned source directories.
