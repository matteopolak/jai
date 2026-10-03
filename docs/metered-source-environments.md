# Metered source environments

## What it is

`ModuleGraph::module_environment_origin_with_work` encodes the original module/source environment under a caller's existing cumulative work and metadata budget. The convenience API shares this encoder and uses version four, whose weak-float facts contain exact semantic DAG records.

## How it works

Borrowed modules, files, declarations, parameter values and captures follow the same original structural rules. Dense IDs only index local traversal tables; output records retain source spans, exact bytes, ordered arguments and target facts. Each visited entry and byte comparison is admitted before inspection. Vec traversal tables, sorting references, program facts and output growth are admitted before allocation with old and new backing overlapping.

Capture encoding borrows the real scalar/type instead of cloning a temporary parameter. Weak decimals use the shared metered `WeakFloatKey` codec; cached fingerprints cannot merge different semantic trees. Program facts and captured names use explicit comparison-charged stable sorting. The fixed layout policy's borrowed Hash walk is admitted before its infallible interface; its fallible byte sink retains and returns the first exact denial.

## How to change it

Extend the shared encoder for new parameter/type/capture variants. Keep the metered and convenience APIs on one path, and bump the environment version when semantic bytes change. The callback must come from the actual caller root budget. Encoding scratch is distinct from the original graph forest, which the caller visits through `visit_retained_source_storage` before ownership copies.

## Configuration

The existing structural nesting bound remains 128. There is no new quota: `FnMut(work, bytes)` chooses admission. Caller denial is `SourceOriginAdmissionError::Admission(E)`; original validation/allocation errors are `Origin(SourceOriginError)`. Exact weak-key records use their existing version-one format within environment version four.

## Dependencies

The encoder depends on actual `jai-modules` graph/publication state, genuine `jai-source` records and symbols, portable `jai-types` recipes, and the `jai-eval` exact metered weak-float codec. This packet has source formatting/apply checks only; its tests are authored and unrun.
