# Mac Extensions worker inbox

Current exclusive scope is Json/Http production and tests, Byte_Search test time
dependency, and Io tests only. No Io production or compiler/stdlib changes.

The named stable baseline JSON and assigned T7 path were absent in the fresh
checkout. Missing-input question submitted; direct original-class reproducers
and this worktree's isolated artifacts/T7 build are used while waiting.

Json empty-path cleanup reproduced and repaired; unchanged interpreted leak
sweep passes. Http/Io atomic dependency migrations compile. Numerical work and
full affected-test verification continue; no full-completion claim is made yet.

Numeric dependencies are now migrated to reviewed width-specific public parsing
and public shortest formatting, with private Json spelling normalization. No
lossy conversion/private Basic export was added. Existing numbers now compare
parsing bits against native strtod/strtof, retain shortest-digit comparisons and
fixed spelling/round-trip assertions. A new numeric allocator test passes all
three modes. All27 original affected catalogue tests pass Mac native O0/O2.

The exact contextual lint command in docs/extensions/mac-dependency-repairs.md
still fails on a procedure-valued Json generic sketch in the original Http
client fixture; normal compile/execution passes. Compiler/linter worker owns
that reduction. Changed-source strict lint passes in the real positive consumer
context, without suppression. No Http/Io production lifecycle workaround is
introduced to mask compiler behavior.
