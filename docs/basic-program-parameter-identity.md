# Basic program parameters and Apollo identity

The reviewed Basic header has an empty first/module parameter list. All five
settings belong to its second/program list: MEMORY_DEBUGGER, ENABLE_ASSERT,
REPLACEMENT_INTERFACE, VISUALIZE_MEMORY_DEBUGGER and
TEMP_ALLOCATOR_OVERWRITE_MEMORY. The facade had transcribed them into the first
list. This correction adds the missing empty list and changes no defaults,
contextual interface declaration, hook body, export or platform guard.

The incorrect declaration gave a configured Basic import and a dependent
File_Utilities import different module instances. Their private implementations
then declared different nominal Apollo_Time types. One immutable own-test
snapshot records File_Utilities.file_modtime_and_size returning type 247 while
the configured consumer expects 251. Those are opaque IDs within that single
run, not identities to compare between runs or compiler versions.

With the public declaration corrected, the existing compiler program-parameter
mechanism shares the configured Basic instance and its Apollo type. Its private
internal/basic header remains an ordinary parameterized implementation, unchanged.
No compiler/cache/conversion change, type-name equality exception, cast, alias
refresh or runtime-provider modification is part of this fix.

The coordinator's actual offline official compiler accepts all four independent
public controls: default conversion, default assignment, program-configured
assignment and the eight-line Focus-shaped program-configured conversion. These
are source-build positives; no reference implementation or protected runtime
body is supplied to this worker. The corrected declaration was separately
verified from the exact public header/interface.

The [ready receipt](status/basic-program-parameter-identity.json) preserves the
initial RED, private header-only hypothesis, exact production byte proof and
focused verification. Early hypotheses about general cache policy or lost
import-group provenance do not establish a remaining compiler bug and are not
implemented. The unrelated generic first-list experiment remains exploratory;
it is not treated as an official-positive language rule.

Independent source fixtures are under
`tests/portable-stdlib/basic-program-parameters`. They cover the four official
controls, assertion-dependent builder layout, an unrelated nominal-type
rejection, and a filesystem/conversion runtime control. That runtime control
explicitly disables visualization while enabling memory debugging; the official
eight-line source control retains its original settings unchanged. Ordinary
module parameter instances remain distinct; properly declared program parameters
share one instance. Native execution, when available after lease coordination,
must be recorded separately from interpreter/source checks.

This handoff verifies the declaration and public identity reduction using own
source-built tools and a source-pinned independent library snapshot. Integration
owns the shared index and combined pin. Root owns original Focus replay with its
already authorized diagnostic version-copy changes. Full application acceptance
is not inferred from these independent controls, and no application version or
body is changed here.
