# Storage contract and native elapsed-clock target selection

The 940 Mac catalogue diagnostic at `storage-time-contracts.jai:17` is reproduced
by selecting a WASM target: `seconds_since_init` is unavailable there. The same
unchanged source checks successfully for macOS. The CI host name does not by
itself identify the program's selected target.

The fixture already imports the canonical public Basic facade. The reviewed
[Basic contract](../specs/stdlib/modules/basic.md) declares
`seconds_since_init() -> float64` and defines its lazy monotonic origin and
elapsed-seconds behavior. The current public facade exposes it for Windows,
Linux, Android and macOS, alongside the corresponding native monotonic queries.
Runtime_Support's reviewed public inventory supplies runtime initialization,
allocation, assertions and output, without an alternative public elapsed-clock
function. A compiler tour's private WASI clock provider does not establish a
canonical Basic or Time export.

This repair adds one exact catalogue capability requirement for
`contracts/basic-slice-resize-and-monotonic-time-contracts`: native Basic
monotonic/elapsed clock. Its WASM execution is unavailable, never passed. Its
original file remains byte-identical, including all slice resize assertions and
both clock calls with the nonnegative/nondecreasing elapsed-time assertions.
Native execution remains required.

To retain portable coverage, the new independent catalogue case
`contracts/basic-slice-resize-contracts` executes the identical original storage
assertion block: zero-initialized growth, retained data when shrinking, growth
with `initialize = false`, and cleanup. It remains selected for interpreter,
native and WASM execution. The mixed storage/clock contract is not replaced with
an empty body or an OS-conditional successful clock test.

Only the case-specific capability function, one additional test manifest entry,
the new storage fixture and a selection regression change. No Basic, Time,
Runtime_Support, private provider or compiler implementation changes. Process
and Thread classification remains platform-owner scope; the separate HTTP App
metadata request is not folded into this patch.

Focused checks use the existing independently source-built compiler/linter pin
from the foundations follow-up receipt, with explicit tool hashes. There is no
rebuild against moving shared HEADs. Original WASM rejection, desktop source and
strict lint checks, actual Mac/WASI program outcomes, original fixture identity
and source guards are recorded in
[the handoff](../status/foundations-storage-clock.json). Linux and Windows native
execution remain CI requirements. The first WASM lint invocation used an invalid
`--target` option; its failure is retained, and the supported `-target` invocation
is verified separately rather than counted as that failed command passing.
