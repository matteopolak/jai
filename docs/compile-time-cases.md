# Compile-time cases

## What it is

`#if value == { case key; ... }` selects source declarations and statements using checked compile-time values. The same retained case table works in files, procedure bodies, and record specializations.

## How it works

```jai
Tag :: enum { OTHER; CHOSEN; LAST; }
selected :: Tag.CHOSEN;
main :: () -> int {
    #if selected == {
        case .OTHER;
            answer := unavailable_function();
        case .CHOSEN;
            answer := 40;
            #through;
        case .LAST;
            answer += 2;
    }
    return answer;
}
```

The parser checks every branch's grammar and retains its original source spans. Semantic selection evaluates the selector once, contextualizes each label using the selector's canonical type, and validates duplicate labels before choosing the first matching arm. Enum comparisons preserve the actual enum declaration identity; type cases compare canonical type identities. A bare `case;` is the final default. `!=` chooses the first unequal label. `#through` includes following original bodies without comparing their labels again; an unmatched table without a default contributes no declarations.

Selected source-case braces do not introduce a lexical scope. Only selected declarations, imports, physical record fields, and statements bind into the surrounding scope. Inactive bodies remain parsed but do not resolve names or load dependencies. A malformed inactive body still produces a parser error.

File and lexical dependency discovery retain body-free original selectors and labels in `DeferredCase`. Semantic responses use an immutable arm/default/none choice, keyed by the defining file, source span, and actual source specialization. The regular compile-time scheduler supplies checked procedure dependencies, compiler effects, source substitutions, and readiness retries. Final binding reuses semantic decisions, avoiding selector replay. Pure scalar graph cases can resolve directly; enum and type cases defer to canonical semantic binding.

Final file binding rechecks scalar graph choices through the canonical selector and visits assertions only in the selected original bodies, including `#through`. A semantic choice is reused while its active assertions still run.

`#if #complete` requires coverage of a bool or declared enum value domain, or a default case. Duplicate aliases of the same canonical value and labels from incompatible nominal enums fail with their original label locations.

## How to change it

`jai-syntax/src/compile_time_cases.rs` owns the shared table and parser helpers; conditional parsers supply their actual file/statement/record grammar. `jai-sema/src/compile_time_cases.rs` owns checked values and common selection. Record specializations and local record resolution translate their real source bindings into this contract.

Graph requests and responses live in `jai-modules/src/deferred_cases.rs`. Keep specialization identity on both requests and cached selections, and retain each request's process-unique identity so responses cannot cross independent graph sessions. The scalar preflight inspects real bindings and aliases before evaluation; non-scalar module parameters and source members must reach typed discovery instead of a scalar conversion error. The semantic discovery adapter shares the normal source resolver and provider; the driver submits typed responses alongside module-parameter and source-specialization progress. Do not replace retained source tables with fabricated boolean conditions or use textual names to compare enum/type keys.

When extending supported selector domains, update both canonical semantic comparison and the scalar graph fast path. Preserve constant budgets, original branch wrappers, and `#through` behavior in all three source contexts.

## Configuration

Use `==` or `!=`, optional `#complete` immediately after `#if`, `case key;`, a final `case;`, and optional terminal `#through;`. Source selectors support type, bool, integer, enum, and string constants. Runtime storage cannot provide a compile-time selector.

There are no case-specific environment variables. Target tags such as `OS` use the selected build target and the designated source enum schema.

## Dependencies

The syntax parser, canonical `jai-types` identities, typed constants, semantic constant evaluation, retained module discovery, compile-time provider/readiness and effect replay, and source-specialization metadata. Source and native fixtures are independently authored; supplied reference native objects and libraries are never loaded or linked.


## Ordered defaults and fallthrough

A bare `case;` may occur anywhere in the original table. Its ordinal and `#through` flag remain attached through file/record insertion conversions. Selection still searches labeled cases first; the chosen body chain then follows original source order through a default without evaluating the next label. Duplicate defaults and physically last `#through` reject even in an inactive branch. This uses the shared `jai-types::CaseOrder` producer, with no source text rewriting or execution of supplied reference tools.
