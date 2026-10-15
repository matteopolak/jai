# Canonical called-library body interception

The independent producer received main's TYPECHECKED body but not the called
ordinary Basic.alloc body before COMPLETE. Library declarations were skipped
outright, and resolved callee headers scheduled bodies only for polymorph
instances with binding scopes.

Already resolved library declarations now participate in export. Cold library
declarations remain lazy. Resolved headers schedule ordinary concrete bodies as
well as instances, using defining/binding scopes respectively. Only lowered
bodies are delivered; export does not lower unused or rejected candidates.
Ready bodies use the existing procedure exporter and canonical header cache.
Ready callees discovered during export drain transitively, even when the initial
drain exported none. Scheduling and header/body announcement sets use ProcId:
aliases/repeated calls retain one header and one body event per identity.
Generic templates and concrete instances remain distinct identities.

Resolved/full headers share flag computation; instance flags use semantic
polymorphism state. Parameter typing separates baked bindings from runtime
signature slots. Existing body links are reused. No module/function exception,
reconstructed AST, new public export, import privilege or library edit exists.
Public interception filters are unchanged.

Tests cover flags0, SKIP_PROCEDURE_BODIES, notes-only filtering, canonical
call/header/body links, aliases/repeat calls, ordinary/generic/private callees,
baked argument types, unused invalid bodies, duplicate events and successful
completion after required bodies. Private source access remains rejected after
interception. The new core test failed before the repair on missing ordinary
body; the baked metadata extension independently failed on a missing argument type.

Mac ARM64 verification: exact producer and public filter/lifecycle fixture pass
source-built checks with real NO_OUTPUT child workspaces. The runtime input
separately passes interpreter and actual native O0/O2 allocation/read/write/free
and ordinary/generic calls. NO_OUTPUT checks are not child runtime executions.
Scoped tests pass:165 core library,11 layout,9 reflection,1 interception,3 CLI,
10 library-root lint,11 target-aware lint,4 overload audit and11 jailint library.
Strict Jai lint/format, Rust format/item spacing and all-target warnings-denied
clippy pass. Evidence is in artifacts/compiler-mac-repairs/interception-*.log,
stdlib-body-*.log and native input executables.

Full Iprof instrumentation, cross-target runtime integration and other catalogue
prerequisites remain owner/integrator verification. Existing unsupported AST
forms are not implemented by this scheduling change.
