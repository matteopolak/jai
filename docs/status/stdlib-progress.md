# Portable stdlib progress

Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior implementations used. Extensions and corpus preserved.

Latest committed checkpoint: `a435581`, POSIX crash runtime/startup integration. Earlier
checkpoints cover foundations, Unix process/thread/files/system, codecs,
allocators, Soa, Xar, command/text parsing and reviewed protocol schemas; consult
[module ledger](../portable-stdlib-ledger.md) for exact partial/remaining scope.

Previously verified checkpoint: POSIX native crash diagnostics and runtime startup
flag integration. Native C builds with `-Wall -Wextra -Werror`. Actual protected
memory faults and raised SIGSEGV terminate with preserved signals and a native
stack in interpreter/native execution. Four worker threads independently initialize
and clean up stacks. Build_Options ON/OFF workspace tests pass native execution.
All 175 owned Jai files pass repo jaifmt --check and jailint -D warnings. The
expanded regression passes 58 interpreter/native cases, ten SMTP scenarios,
four parent-lifetime scenarios, four expected faults in both execution modes,
Xar reverse rejection, startup ON/OFF and selected Linux/Windows target checks.

Current verified checkpoint: classic Zip_File_Directory parsing and ownership,
including malformed second-record cleanup under a counting allocator. The full
focused run now passes 59 interpreter/native cases and six expected faults in
both modes, retaining the SMTP, parent-lifetime, startup and target checks above.
All 181 owned Jai files pass jaifmt --check and jailint -D warnings. The ZIP field
and extension contract gaps are documented, not asserted as established behavior.

Known workarounds and incomplete behavior are recorded in
[deviations](stdlib-deviations.md), [gaps](../portable-stdlib-gaps.md) and the
module ledger. Next: finish regression/checkpoint, then continue remaining owned
portable modules using reviewed specifications. Full corpus/release integration
remains the coordinator's responsibility.
