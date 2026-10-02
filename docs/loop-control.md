# Loop control

## What it is

Integer range loops and named loop exits extend the scalar compiler subset. Supported forms are inclusive `for start..end`, named iterators, reverse `for < start..end`, `break`/`continue`, and `while name := expression` conditions.

## How it works

Parsing produces enums for direction, jump kind and optional target. Resolution assigns each loop an opaque `LoopId`; a jump must name an active enclosing loop, or select the innermost loop. LLVM construction consumes that resolved ID and concrete block handles, with no string label lookup.

```jai
main :: () -> int {
    total := 0;
    for outer: 1..4 {
        for < inner: 1..3 {
            if inner == 2 continue outer;
            total += outer;
        }
    }
    return total; // 10
}
```

Range endpoints evaluate once, from left to right, before introducing the iterator. Both endpoints are inclusive; a descending numeric range is empty even with `<`. Reversal changes traversal order, so `for < 1..3` visits 3, 2, 1. The unnamed iterator is `it`; nested iterators shadow outer variables only within their loop. Iterator values are mutable. The latch tests the endpoint before adding or subtracting one, preventing a final inclusive iteration at `s64` MAX/MIN from wrapping.

A range `continue` reaches the increment/decrement latch; a `while` continue reevaluates its condition. A named condition's value is assigned on every test, retains its scalar type, and is visible only inside that loop. Named outer exits can bypass inner loops. Blocks distinguish fallthrough from termination, allowing mixed return/break/continue branches without an invalid LLVM join.

Recent [Focus loop usage](https://github.com/focus-editor/focus/blob/c6b3ead7d4174527d0138e8a31f7c3c5663badec/src/utils/utils.jai) and [Jails reverse range usage](https://github.com/SogoCZE/Jails/blob/42fa76c816ad34c9f24a4bde586d145c992dc860/server/memory_files.jai) guide current syntax. The older tutorial's transitional `#v2` modifier is not accepted. These sources do not establish every corner-case runtime behavior; differential verification against the original compiler is still pending. In particular, the older tutorial records inconsistent endpoint reevaluation, while this implementation consistently snapshots endpoints.

## How to change it

Update syntax tags, semantic loop bindings and LLVM loop blocks together. Preserve early diagnostics for invalid targets, escaped bindings, non-integer range endpoints and unreachable statements. Native tests cover actual generated execution, including nested outer jumps, reverse/empty ranges, bound snapshots and MAX/MIN endpoints. Benchmarks separately exercise nested range resolution and LLVM construction.

Array iteration, pointer iterators, index bindings, custom `for_expansion`, `remove`, deferred cleanup and complete target-dependent integer typing are not implemented. Adding deferred cleanup will require processing each exit's crossed scopes before branching; do not treat every terminator as a procedure return.

## Configuration

No new flags or dependencies. `int`/`s64` are the implemented range element types. Return-flow checking is conservative: a loop does not prove that a value-returning procedure always returns, even if its bounds appear nonempty.

## Dependencies

`jai-syntax`, `jai-sema` and `jai-codegen`; LLVM 22 through Inkwell. Native tests use independently installed Clang. Compiler benchmarks use Divan's Rust allocator profiler; LLVM's native heap is excluded.
