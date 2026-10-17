# io_uring initialization and the dependency reduction

The LinuxARM report locates a null read at
`tests/extensions/io-uring-dependency-repro.jai:7` and
`stdlib/Extensions/Io_Uring/ring.jai:206`. The original fixture explicitly says
it is source-check-only and that an uninitialized ring must never be submitted
at runtime. Its source is preserved unchanged.

The caller declares a default `Ring` and immediately calls `submit_and_wait`.
It never calls `ring_init` or `ring_init_params`. `submit_and_wait` calls
`publish_sqes`, whose first operation reads `ring.sq_tail.*`. That pointer has
not been mapped or assigned. This dereference precedes `io_uring_enter` and
there is no setup call on this path. Thus this specific reported null read is
explained by executing a source-only consumer outside the initialization
contract. It is not evidence of an EPERM/unsupported-kernel return, failed
allocation/context initialization, or syscall ABI failure. No arbitrary null
guard, kernel syscall substitute or production change is proposed.

The public Extension module's example initializes a ring, checks the negative
errno result, obtains/prepares a NOP and only then submits and consumes its
completion. `ring_init_params` first performs setup, returns setup errors before
mapping, then maps and assigns the queue pointers. Kernel policy and mapping
failures must be diagnosed from an actual initialization result on a supported
Linux host. They cannot be inferred from this invalid runtime invocation.
Existing raw-ring runtime availability handling is unchanged, not generalized
to a whole-module waiver.

The independent `io-uring-init-contract/initialized-nop.jai` control follows
that lifecycle, checks one NOP completion with user_data 42, and deinitializes
after successful setup. Every essential API call executes outside optional
assert expressions. A failed initialization prints its numeric status and
fails; it does not silently classify arbitrary errors as unavailable. This
worker only source-checks the control. Neither it nor the original invalid
consumer was executed, and no Linux syscall ran on Mac.

The proposed catalogue correction flags only the original authored reduction
as `source_check_only`. Generic runner support dispatches it to `-check`, never
an interpreter/native executable. A successful check has a separate
`source_check_only` count and nullable runtime-pass field, not a runtime pass,
compile-time execution or platform-unavailable success. Compile errors and
source-check timeouts still fail the required gate. Other target requirements,
precise negative controls and ordinary runtime accounting are preserved.
The initialized raw NOP/file/queue test and caller-memory queue protocol retain
their existing runtime requirements; they do not receive the source-only flag.

Foundation owns the exact catalogue annotation and integration owns runner
dispatch/report accounting. The shared files were not overwritten. The patch
contains their narrowly scoped proposed hunks; integration must reconcile its
concurrent Windows provider changes without replacing whole files. No compiler
cache/configuration workaround or alternate type/provider was introduced.

Fresh source-built compiler/linter tools have stable compiler source hashes.
The immutable own T7 directory `io-uring-init-contract-ogb9mhoj` records twelve
passing source outcomes: original and initialized control on Linux arm64/x64,
four complete strict-lint contexts, two required non-Linux module rejections,
and preserved raw/protocol Linux source controls. All frozen Jai input hashes
remain unchanged. These are static contract/layout checks, not Linux ABI or
kernel/runtime success.

The new policy regression fails against the current shared runner and passes
the isolated candidate. Thirty-one candidate policy methods pass, including
four new source-only dispatch/count/error controls and existing HTTP termination,
foundation target and Debug negative controls. Mocked compiler results test
accounting only and are not native evidence. Ruff checks pass; new Python and
foundation-hunk formatting pass. Full runtime-file formatting remains its
owner's responsibility: both the untouched proposal base and candidate fail
the whole-file format check, retained explicitly; unrelated formatting was
not included in the patch. Concurrent Windows provider edits were preserved
when refreshing the isolated candidate, and all 31 policies passed again.
Real JaiFmt verification of
the new positive fixture is queued behind integration's active full-catalogue
native lease, not claimed passed.

The admitted Linux HTTP job 117243021190 file supplies ten failure labels:
two backends copies and eight HTTPS O2 round-three copies. It supplies no exit,
phase or error category. HTTPS uses built-in test certificates and tests several
TLS/request/shutdown phases; failure labels alone do not identify the phase.
Root was asked for a bounded category/first assertion or numeric TLS return and
exit/phase, without endpoints, certificates/keys, auth or raw payload. No
HTTPS/runtime source repair is inferred from the labels. The failing-copy
observer is already admitted for integration CI; no extra workload, retry,
deadline, backlog, copy count or namespace/network change was made here.

Remaining gates are shared source-only dispatch adoption, queued JaiFmt check,
actual supported Linux initialized-ring/kernel behavior, and the original Linux
HTTP failures with matched failure evidence. Hyperserve's unresolved runtime
gate and the rejected execution remain untouched. Integration alone stages,
commits and links this note from docs/README.md. No native lease was claimed,
and no native/server/network/fault/benchmark/reference execution occurred.
