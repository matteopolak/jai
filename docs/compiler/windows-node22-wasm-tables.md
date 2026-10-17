# Windows Node 22 wasm table-limit failure

Job `117243082265` reports Node `22.23.3` rejecting table limits while compiling
many existing wasm outputs. The admitted sanitized record contains 60 matching
diagnostic records, not 60 independently established compiler bugs. The failed
modules were not retained by that job. This remains a required failure separate
from the previously reproduced T7/LLVM output-durability problem.

## Source findings and uncertainty

The owned backend selects a generic wasm64 CPU and appends `+bulk-memory` unless
explicitly overridden. Its linker wrapper invokes external `wasm-ld -mwasm64`.
The existing native test helper already supplies the Memory64 flag for Node
versions below 24. Adding that flag again cannot explain or repair these records.

The owned `tools/wasi_run.mjs` and `docs/native/wasm-target.md` document Node 24.
The main CI pins Node 24; the owned Windows workflow pins LLVM 23.1.2 but has no
Node setup/version pin. That source prerequisite difference needs comparison
with the actual CI tool/argv capture. No minimum version, required test, runner
flag or workflow has been changed here.

The public [WebAssembly Memory64 proposal](https://github.com/WebAssembly/memory64/blob/main/proposals/memory64/Overview.md)
distinguishes 64-bit table indexes from 64-bit memory indexes. The
[binary type specification](https://webassembly.github.io/memory64/core/binary/types.html#limits)
defines the limits encoding. A table capability mismatch is therefore a concrete
hypothesis; it is not established for the actual Windows outputs without their
bytes and selected tool identity. No table flag will be rewritten in isolation:
table index types and indirect-call semantics must remain coherent.

The already-owned 286-byte C/LLD stdout control was inspected as data only. It
retains SHA256 `c01e56d50689bae4e1a389e452dc3558ad4c7b322ae6b0b0f3b9d070bf44c68b`,
matching its earlier receipt. It contains a 64-bit memory definition and **no table**, so
it does not reproduce the table failure. No Node/LLD/compiler/SDK program was
executed during this source-only investigation while integration held the lease.

## Prepared reductions and metadata inspection

Owned T7 `windows-node22-tables/preparation.json` records hashes of new C and Jai
function-pointer reductions, plus an independent JavaScript binary-format
control. The control separately attempts table32/memory32, table32/memory64 and
table64/memory64 modules. It adds no Node flags; rejected modules remain nonzero
results. These reductions have been authored but not compiled/executed yet.

`python3 tools/inspect_wasm_limits.py <explicit.wasm> [...]` inspects at most
three explicitly admitted files, at most 2 MiB each. It reports defined table
and memory flags, index widths, offsets, limits and SHA256. It never executes,
transforms or copies a module. Its scope excludes imported types and code
validation; unsupported metadata yields a diagnostic rather than guessed values.
Six pure metadata tests cover table32 versus memory64, table64 maxima/wide
limits, truncation/overflow/unsupported flags and the size bound. Ruff checks and
formatting pass. These are not WebAssembly runtime or Windows CI passes.

## Exact next evidence

Integration owns the held runtime lease and workflow artifact wiring. The
requested bounded capture is no more than three existing failing wasm outputs,
each no larger than 2 MiB, with hashes, the actual triple/features, selected
LLD path/version and actual argv. No original application bulk, credentials or
raw remote logs are requested. Capture must preserve the existing failure status,
expected outputs and timeouts. The source preimage of the current test helper
must be confirmed before adding capture hooks there.

After explicit lease release, compile the independent function-pointer controls,
inspect the produced table bytes and run the encoding controls with the existing
runner configuration. Compare actual Node 22 behavior and the documented runtime
configuration without introducing experimental flags or a minimum-version waiver.
No production fix or full required-gate acceptance is claimed in this checkpoint.
