# Collection expression contracts requiring compiler review

These are independent expression reductions, not missing collection bodies or established reference guarantees. Supported explicit forms continue to be tested; no library wrapper or private visibility bypass was added.

1. `stdlib/Soa/tests/probes/contextual-index-store.jai`: after the canonical public operators are exposed, `values[0] = .{17}` fails to infer the contextual record type, while `values[0] = Item.{17}` executes correctly. The operator's value parameter is the dependent `S.T`, already determined by the array operand. Do the reviewed contextual-literal rules require inference in this dependent operator assignment? If yes, the compiler needs a general dependent-parameter inference fix. The public Soa record assignment behavior is tested with explicit typed values; the failed shorthand reduction remains preserved.

2. `stdlib/Xar/tests/probes/index-operator-value.jai`: `X.operator *[]` in a typed procedure-value expression is rejected by the current parser at the closing bracket. The operator declaration, ordinary indexing and address-of indexing execute correctly after the public filtered reexport. The language examples establish named operator values for arithmetic, without specifically establishing pointer-index operator-value spelling. Is this expression the required spelling, or is there another reviewed form? No alternate public accessor or wrapper is invented to manufacture a function-identity result.

The Soa positive fixture retains concrete procedure-identity checks for repeated imports. Xar checks real indexed storage addresses, stable element pointers, all iterators and allocator ownership. Neither pending expression is counted as passing functionality.
