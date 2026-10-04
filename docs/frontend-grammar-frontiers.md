# Remaining frontend grammar

## What it is

The second held grammar layer extends the immutable [header packet](frontend-header-grammar.md) with source-preserving conditional expressions, notes, array type targets, empty statements, and separated declaration sigils. It is a private parser/lexer component and a paired bounded quotation visitor, not live compiler activation.

## How it works

`IfxSyntax` distinguishes an omitted `then` from explicit expression and statement-valued branches. It retains the original condition once, each original block and range, the optional fallback, and whether the source used `#ifx`. Ordinary explicit runtime expression branches continue to use the existing `ConditionalExpression`. Postfix operations still apply to the conditional result.

The supplied `025_ifx.jai` tutorial explains that implicit results can come from a boolean operand or a procedure call's first argument. The parser therefore does not clone the condition into a fabricated `then` expression. `visit_children` borrows actual children without allocating a replacement tree; the quotation budget visits the condition exactly once and charges block statements and owned selector bytes before retaining a clone.

Array literal targets now use the existing `TypeSyntax` carrier for pointer and `type_of` targets, as well as names and applications. Prefix and suffix record notes remain one ordered sequence. Quoted note names retain their original enclosing note range, while selector arguments such as `@selector(didReceive:notification:)` retain exact uninterpreted bytes and their argument span.

The lexer recognizes source forms such as `value : = 111.0`, `Alias : : X11.Window`, and `# import "Basic"`. Tokens cover the original separators; the input is never rewritten. Contextual `no_inline` and `interface` names keep their original symbols. Bare runtime semicolons become `StatementKind::Empty` with their own range. Block `#code` initializers keep their self-terminating declaration boundary.

The [readiness receipt](../artifacts/frontend-grammar-layer2-readiness.json) records the additive patch and consumer dependencies. Direct private checks pass 14 lexer tests, 193 parser tests and six quotation-budget tests, including the unchanged two MiB parser nesting guards. The [source frontier](../artifacts/frontend-grammar-layer2-source-frontier.json) compares both frozen components on 378 complete unchanged files named by the original failure receipt and previous header frontier: 98 parse with the first layer and 139 with the second. The second layer clears 41 additional complete files, with no regressions and no stale captured original hashes. Seven of the prior 23 retained failures parse; 16 remain. Across this selected set, 239 files still fail parsing. These are direct source parsing counts, not full dependency graph, semantic, runtime, native or whole-corpus acceptance.

A separate [source50 producer receipt](../artifacts/frontend-source50-grammar-readiness.json) isolates two fixes against committed `73121e7`, without activating the broader schemas. Anonymous procedure lookahead requires an empty parameter list or an actual top-level `:`/`:=` formal marker before accepting a following block. Grouped allocator conditions and parenthesized range bounds therefore retain their ordinary expression and statement carriers. A narrow array target helper preserves pointer, `type_of` and application targets in the existing `ArrayLiteral.element_type: Option<TypeSyntax>` carrier; it does not register the older aggregate helper whose struct carriers remain held. The source50 component passes 182 parser tests, including exact condition, range and pointer-array regressions. All four unchanged complete files previously failed: the pinned allocator, Focus Runtime_Support and SGPU now parse; Vk's deferred context push remains a failure. The [separate frontier](../artifacts/frontend-source50-grammar-source-frontier.json) retains both results and original hashes. These parser checks do not establish semantic or native acceptance.

## How to change it

Keep the first packet immutable. Apply the second syntax patch to that exact base, with the captured lexer change, and layer the quotation visitor onto the canonical callback carrier's budget file. Its private consumer also includes the earlier literal target, relative place and record namespace directive traversal obligations. The two empty-statement consumers are separately staged: runtime lowering produces a fallthrough operation, and declaration quotation conversion creates no fictitious member for an empty statement. Main compiler compilation of those arms remains held.

The private `assembly-handoff.json` beside the second packet lists authoritative patch hashes, captured baselines, dependency order and outstanding consumers for the compiler assembler. Rebase the recorded edits surgically onto the current parent; an older full snapshot would erase intervening source work. Preserve the cumulative quotation budget's typed syntax, scope and substitution accounting and `admit_value` visibility, plus the callback contract visitor's heap wrapper arms. The callback packet's ready-only test harness is excluded from production assembly.

The source50 repair is an independent four-file patch with no new AST fields or variants. Preserve its formal lookahead when merging callback header changes. Its `array_literal_targets` registration is narrow: merge its conversion into a later registered aggregate helper rather than retaining two competing target implementations. Existing runtime array annotation, source constant and quotation consumers already inspect original target `TypeSyntax`; new target support must continue to prepare that type before element expressions.

Implicit `ifx` lowering must prepare a genuine subject capture before evaluating its condition, extract the supported operand or actual first argument, and reuse that checked value once. Preserve per-use callable contracts alongside the subject binding. Statement-valued branches need their original lexical scope and final expression result. `#ifx` needs actual compile-time predicate readiness and selected-source publication; lowering it as an ordinary runtime conditional would lose its contract. These semantic producers remain unresolved, so activation must wait for their paired consumers.

Update every relevant expression, statement, source-preparation and argument visitor when adding a carrier. The conservative inventory in the readiness receipt is a search aid, not proof that consumers are complete. Existing callback-default worklists, grouped-global identities, variadic packs, non-POD ABI flags, caller references, baked applications, deferred context pushes, ordered cases and field overlays retain their separate gates. Do not replace supplied fixtures or relabel captured failures as successes.

## Configuration

No flag activates this layer. Selector payloads are bounded to 1,048,576 bytes before allocation. Existing quotation limits remain 65,536 nodes, depth 128 and 1,048,576 owned payload bytes. Existing parser conditional depth limits remain unchanged. Checks use direct `rustc -D warnings` against captured trusted rewrite dependencies and do not invoke Cargo or acquire the main target.

## Dependencies

The layer depends on `jai-lexer`, `jai-source`, `jai-types`, `jai-ir`, the first private syntax packet, and the canonical anonymous-procedure callback quotation visitor. Production integration also needs source preparation, argument and callback contracts, compiler quotation/capture, and runtime conditional lowering. Original inputs are read and parsed only; supplied native compiler assets are never executed or loaded.
