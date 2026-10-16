# Io child MAIN configuration and HTTP termination controls

`tests/extensions/io-configured-production.jai` previously remapped Thread
and Io's Basic imports to `Thread_Basic_No_Assert`. That imported helper
supplied `ENABLE_ASSERT` in the first argument list. Current reviewed Basic
declares this a PROGRAM parameter in the second list, owned by the relevant
workspace's main program. Merely changing the helper's argument list would
still leave the wrong owner. No compiler cache, overwrite policy, helper
implementation or production module was changed.

The parent now adds `#import "Basic"()(ENABLE_ASSERT = false);` (or true for
the enabled profile) to the child main scope before adding the actual worker
file. It uses the existing null-scope `Compiler.add_build_string` contract.
The obsolete helper import path and two remaps are removed. The parent keeps
all argument checks, ERROR and COMPLETE assertions, optimization/CPU/output
selection, and the interpreter child-output path. Both child profiles now
use the same canonical Basic configuration across their imports.

Because the disabled PROGRAM setting also disables the worker's Basic.assert,
the worker now unconditionally exits with failure if its completed count is
not four. Its original completion assertion is also retained. This mandatory
fixture verification executes outside optional assertions. Worker scheduling,
sleep/yield counts, atomic update and required output are unchanged. Actual
worker runtime remains a native-provider CI gate; no thread or network worker
was executed in this focused review.

New independent fixtures in `tests/extensions/io-configuration-protocol/`
create a NO_OUTPUT child, configure only its main scope, and check public
`String_Builder.Buffer.ensured_count` visibility both in main and through an
ordinary imported observation module. They retain ERROR/COMPLETE assertions
and produce exact child/parent output. The imported module sets no PROGRAM
parameters. These nested fixtures are focused runner inputs, not new standalone
catalogue entries or substitutions for the real Io worker case.

Run `tools/check_io_http_configuration.py` with explicit `--compiler`,
`--source-root` and `--output`. Without `--interpreter` it runs source controls;
the flag adds only bounded, non-network interpreter protocols and termination
controls. It never builds/runs native programs or starts a server. Required
first-list and non-main PROGRAM negatives remain actual compiler rejections,
not accepted positives or assertion failures counted as successful negatives.

The final immutable owner receipt directory is
`portable-asn1-socket/shared-target/http-io-program-config-3vj51tb_` on T7.
`final-controls-with-mandatory-worker-check/results.json` has 19 passing checks:
11 source outcomes (including two required negatives) and eight interpreter
outcomes. The real Io parent successfully source-checks its existing worker
workload; the real worker source checks with both settings; the actual
parent's interpreter child-output path runs a simple non-network child for
each profile. No claim is made about executing Io's fiber workload.

Both unchanged HTTP termination fixtures pass direct Mac and WASM source
checks and interpreter execution. The status control exits 37 with only its
before marker. The failure control exits 1 with the exact failed-check and
failure-counter output, and no continuation marker. Neither fixture imports
the thread helper or creates a child compiler. Root's reported 833 catalogue
failures therefore still require exact sanitized argv, selected source/target
and diagnostic records; no cause or native/WASI replay success is inferred
from these direct controls. HTTP source bodies, support counters and exit
bindings remain unchanged. This does not clear the historical failed CI gate.

Nine strict-lint commands pass with complete coverage and no unvisited inputs;
real formatter check and Python lint/format pass. Original parent/worker
assertion lines and both HTTP fixture hashes are preserved. Compiler source
hashes are stable across a fresh offline source build, and its binary hashes
match the frozen tools used for verification. Frozen producer stdlib hashes
remain stable. Initial invalid-helper RED and formatter invocation mistake
are retained separately and are not counted as final successes.

App's native-only boundary and declared WASM codec/termination selection are
preserved: the existing three HTTP metadata regressions pass. The actual Io
native/fiber target requirement is unchanged. The stdlib owner was notified
about the common Thread helper/parent migration and owns that separate repair;
this patch touches neither. Root retains Hyperserve's unresolved runtime gate
and the Linux connect investigation awaiting admitted kernel metadata. No
capability waiver, Git/index action or publication occurred. Integration owns
the docs/README.md link and final patch adoption.
