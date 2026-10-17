# Windows no-assert Thread fixture configuration

Completed Windows x64 job `117243082265` reports the fixture's import rejected
with `Too many module parameters: Wanted 0, got 1`, followed by six failed
platform-I/O checks. The retained central failure record is authoritative;
this is a configuration rejection, not evidence that six hardware faults failed.

The [reviewed Basic contract](../specs/stdlib/modules/basic.md) declares an empty
MODULE list and puts ENABLE_ASSERT in its second PROGRAM list. The independently
compiled fixture is a main-program root, so its configuration is now:

```jai
#import "Basic"()(ENABLE_ASSERT = false);
```

Only `()` was inserted. No workspace remap, module alias, compiler-origin
validation change or duplicate Basic instance is introduced. Program settings
remain subject to the compiler's actual origin rules. The original first-list
form still rejects on the same source-built compiler.

The rest of `windows-thread-noassert.jai` is byte-identical. It still verifies
that optional assertion arguments are not evaluated, and retains every explicit
exit/status check: invalid semaphore diagnostics through a returning handler,
real thread context/index, synchronization and completion, protected-handle
close failure with handle/index/storage retention, retry cleanup, destruction
and draining Thread_Group shutdown. No native/handler/thread/watcher assertion
or production operation is weakened.

Fresh current-source compiler/linter builds were followed by two before-RED
Windows x64/ARM64 checks, four after-positive `-check -no_dce` checks covering
both corrected and ordinary Thread fixtures, and two warnings-denied lint
contexts. Actual checked-file manifests retain the fixture body. Before and
after use the same compiler binary hash. Source guards preserve runner,
compiler-origin helper, Basic/Thread facades, fault fixtures and both Windows
crash backends. These are source checks, not native Windows proof.

The source-built formatter check is queued behind integration's exclusive full
catalogue runtime lease. It has not been executed or counted as passed; the
unchanged-body byte guard is not a formatter result.

The existing runner still requests both CPU source checks, interpreter with and
without `--`, and native O0/O2 for this fixture. Actual Windows replay remains
required, including both negative SDK failure paths and thread cleanup. Other
ae6 job failures remain separate owner obligations; no SDK-provider or native
fault success is inferred here. The prior POSIX crash-provider handoff is unchanged.

Exact hashes, filtered REDs and verification are pinned in
[the ready manifest](../status/windows-thread-program-ready.json).
Integration owns the scoped commit and selective docs/README.md link.
