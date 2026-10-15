# Current worker Mac integration evidence

After the Objective-C, shader and clipboard helper batches, one combined
bindings run staged current NEW independent portable/foundation, compiler API,
window/render, numerics and platform-I/O sources with owned bindings. It uses
the single producer prelude and the source-built compiler, with no original,
reference or quarantined inputs. Extensions are preserved.

Command:

```
python3 tools/native_bindings/verify.py --compiler .work/target-producer-refresh/debug/jaic --target-os macos --runtime --report .work/bindings-mac-combined-current.json
```

Result: **zero failed checks**. Applicable checks: 146 source, 98 native build/run
and 116 privacy passes. Separately reported unavailable cases: 26 target checks,
one iOS runtime case and 40 target-specific privacy checks. These unavailable
cases are not counted as passed. Native SDK/ABI assertions and allocator,
callback, ownership, lifetime and existing graphics/SDL safety regressions stay
active. No optional profile expansion, performance benchmark or release action
was performed. The compiler/artifact/staged-source hashes are in the report.

This is combined worker staging, not the coordinator's full application corpus
or final package integration. Their actual failure count is unavailable here;
the worker does not access coordinator raw logs or forbidden corpus libraries.
Windows/Linux native checks and genuine mobile/SDK limitations remain separate
required gates. The worker Mac result does not establish their success.
