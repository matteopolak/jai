# Current compiler scratch-context regression

The current NEW compiler stores the active context through a runtime slot.
Three type-checking scratch initializers still assign the context pointer
directly, leaving that slot absent. Probing a context-requiring call in an
overloaded `ifx` argument reaches `current_context` and panics at
`sema/lower.rs:236` with `context storage`.

The independent reproducer is
[context-call-probe.jai](../../tests/native-bindings/context-call-probe.jai).
It uses ordinary procedure names and no stdlib imports. The canonical compiler
ICEs compiling it. The same cause blocks building the actual formatter against
the latest foundation's complete Basic package; the older exit/print blockers
are resolved and are not the present failure.

The [reviewable general patch](compiler-scratch-context.patch) initializes all
three scratch contexts through the context setter, preserving the slot
invariant. It does not bypass runtime context selection or introduce a raw
pointer fallback. Native and interpreter reproducer checks pass with the
proposal, and the actual `jaifmt/main.jai` builds against current foundations.
Scoped rustfmt and `cargo clippy -p jaic --lib -- -D warnings` also pass.
The trial compiler and formatter are `.work/jaic-scratch-context-trial` and
`.work/jaifmt-current`; evidence is `.work/scratch-context-trial-evidence.json`.
The earlier ICE/backtrace is `.work/formatter-latest-context-ice.json`.

The peer compiler checkout was not modified. The owned compiler source and
canonical binary were restored after the trial. The current canonical binary
hash is `9b4c4fd3179a9c08d9912ec256688491bba3c9698bbba859e6356c33b43ba535`.
This proposal requires compiler-owner/coordinator integration; successful
formatting with the actual newly built formatter is not a claim that the
unpatched current compiler can build it.
