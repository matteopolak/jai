# Foreign data reexports

The original independent reduction used `state :: Native.state` in a facade,
then requested only `type_of(Facade.state)`. Strict lint attempted a host read of
the unavailable foreign variable. This was an invalid facade construction:
[reviewed module rules](../specs/jai/modules-workspaces-and-examples.md) explicitly
do not establish live mutable aliases through an immutable `::` declaration.
Changing constant declarations to mutable aliases would violate that boundary.

The proper facade uses `using,only(state) #import "Native";`. This exposes the
original declaration without copying its value or exporting a helper namespace.
The parser already accepts this general form, but module declaration collection
failed to register its exported import. The fix registers explicitly using
anonymous imports through the same filtered export lookup as named imports.
Ordinary anonymous imports and constant declaration semantics are unchanged.

The durable original module reduction, corrected to the supported reexport, is
[foreign-data-reexport/main.jai](../../tests/compiler-semantics/foreign-data-reexport/main.jai).
The red log preserves the missing-export failure. The core regression covers
only/except filtering, mutable storage identity, private module scope and
foreign type resolution without a host read. All52 module tests pass. The
Socket generator now uses this form for every mutable data declaration.

`python3 tools/check_portable_socket_resolver.py` passes on the actual production
library: two official C ABI/resolver probes, Jai interpreter and native ARM64/x64
O0/O2 executions, both CPU source checks and strict lint. It also verifies public
h_errno/in6addr_any against independently declared SDK storage addresses and
restores a live h_errno mutation. Generated production files must match two
independent regenerations. No staged library body or loader override is used.

Compiler owner/coordinator: this resolved the reported alias integration defect.
Do not introduce special mutable `::` semantics based on that earlier report.
Further standalone module-using export behavior should be reviewed separately;
this change uses the already parsed explicit filtered-import mechanism.
