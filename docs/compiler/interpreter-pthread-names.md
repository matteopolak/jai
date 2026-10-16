# Interpreter pthread naming

`pthread_create` and `pthread_self` expose scheduler identities (`slot + 1`)
to interpreted code. Those values are not OS pthread handles. Previously,
`pthread_setname_np` and `pthread_getname_np` were absent from both scheduler
dispatchers, allowing native foreign fallback to receive a synthetic identity.
The reported Linux ARM interpreter crash passed `0xd2` to glibc.

The native dispatcher now owns both naming symbols. On Linux, Android and macOS
hosts it validates the public signature and a live scheduler slot, then resolves
that slot to its real OS pthread. The main thread and adopted callbacks capture
their native identity; managed workers retain theirs through the owning Rust
join handle. A scheduler lock protects the identity through each short naming
operation, preventing teardown or adopted-slot recycling during the call.
Finished, cancelled, unknown and identityless slots produce interpreter errors.
Synthetic identities are never forwarded to these native APIs.

Linux/Android setters take a thread and name; the macOS setter takes only a name
and operates on the current thread. Queries take three arguments. Calls use
checked interpreter memory and bounded temporary buffers, then return the real
SDK status. Successful queries copy the terminated result back through checked
memory. Invalid payload pointers remain interpreter memory errors.

The [Linux man-pages contract](https://man7.org/linux/man-pages/man3/pthread_setname_np.3.html)
specifies a 16-byte name including its terminator and error-number returns.
The public macOS SDK `pthread/pthread.h` supplies its one-argument setter and
three-argument getter; `sys/proc_info.h` specifies a 64-byte name capacity.
The SDK-backed control observed macOS accepting a one-byte query and returning
an empty terminated name. Its original Linux-style error assertion was rejected
and corrected; production code already returned the SDK status unchanged.

## Unsupported boundaries

The inline scheduler has no OS pthread identity. Naming calls produce an
explicit unsupported diagnostic instead of native fallback or synthetic success.
Cross-target interpreter programs and other native host platforms are also
explicitly unsupported for these naming APIs. No virtual naming contract or
general routing rule for other pthread functions is introduced.

## Evidence and limits

[The source receipt](../status/compiler-pthread-names.json) records the accepted
`ac174e80` base, exact source/tool hashes, commands and outcomes. Two dispatcher
tests failed before the repair without executing an invalid native call. Five
pure routing/lifetime/signature tests pass afterward. Four source target
contexts (Linux/macOS, x64/ARM64) and four strict lint contexts pass. Rustfmt,
Clippy and the actual source Jai formatter pass.

The independent SDK-backed compiler/interpreter regression passes on macOS. It
saves/restores the main name, checks name updates and overlong-name errors,
queries a managed worker from its parent, then verifies worker self-naming and
join results. Its Linux branch also checks parent-to-worker naming. This test is
part of normal Linux/macOS compiler tests; worker execution used the serialized
native lease. No fault, GUI or broad corpus run was performed.

Actual Linux ARM CI replay remains required. Android and adopted-callback naming
are implemented but lack direct runtime proof in this handoff. The native Linux
SIGSEGV and POSIX pthread-storage ABI repair belong to the stdlib owner; this
interpreter result does not establish their native fault site or completion.
Any boxing, default-Type initialization, stdlib, WASM/GPU and Console argument
code remain unchanged.
