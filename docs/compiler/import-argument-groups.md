# Import argument groups and declared slots

This follow-up to `978397f6` closes two confirmed gaps: exported imports lost
their argument-list boundary, and a first-list named argument could bind a
declared PROGRAM slot. Root's sanitized official Jai 0.2.030 observation rejects
the non-main first-list Basic setting with
`Too many module parameters: Wanted 0, got 1.`

The parser now records first-list presence as well as the second-list offset.
The Import exporter emits the existing public `module_parameters_call` and
`program_parameters_call` separately. An explicitly empty list has an empty call
node; an absent list has no call node. The printer emits both calls. A publicly
edited node with only a program call receives the necessary empty first list.
No other exporter/printer construct or public record layout changes.

Target validation uses the declared ordinary and PROGRAM slot names/counts.
Initial requests retain their owned import provenance until header registration,
and validate before binding. Cache hits validate before shared program-instance
rebinding. Requests encountered before header readiness are queued, including
reentrant requests during typed slot registration, and checked before provenance
is released. First-list arguments never enter speculative program-setting
collection. No module name, filename, alias or type-name exception is used.

## Verification

[The follow-up receipt](../status/compiler-import-argument-groups.json) records
the exact new diff base, source/tool hashes and commands. Before the follow-up,
two new controls accepted invalid first-list settings. Afterward, the first-list
program-only case rejects with the official count category on initial loading,
after a plain import, and on an exact configured cache hit. Wrong-list named
arguments, duplicate/mixed bindings and ordinary module parameters are covered.

The original 52 module and 12 typed-configuration controls remain active. One
older positive used invalid first-list PROGRAM syntax; its setting now uses the
reviewed second list, preserving its shared-instance/value assertions. The old
form remains a negative. The excess-argument control now checks the count-error
category; the unknown-name diagnostic is unchanged. Initial failures and old
source evidence are retained rather than relabeled as passing.

108 focused Rust tests pass, including callable metadata and code export tests.
Seven compiler `#assert` round-trip controls check absent/empty groups, separate
counts, argument names, literal values and the edited program-only node. The
existing import/using round-trip fixture also source-checks. The independent
Basic first-list negative matches the official category. Strict fixture and
public-facade printer-context lint, Rustfmt, Clippy and actual JaiFmt pass.

The new fixture initially had an unused Basic import after switching to compiler
assertions; removing that unused import corrected lint. An initial exporter test
used indexing on the Rust Records list API; iteration corrected that test setup.
An initial printer formatting check required one blank line, now corrected.

## Boundaries

The work is source/compiler testing; no native executable, GUI, fault or benchmark
program ran. Brief source-formatter interpreter leases were released after their
children exited. Actual public NO_OUTPUT child-root protocol replay remains an
integration/root check, supported by the prior official acceptance. No new
grammar prohibition, default substitution, instance-key coalescing or general
positional-binding rewrite is introduced. Accepted IDE discovery, typed header
contracts, Any boxing, default-Type initialization and Uniform/path code remain
unchanged. Reference implementation bodies, raw logs and binaries were not read.
