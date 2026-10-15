# Interpreter Windows thread handle and naming interoperability

Managed Windows threads now expose their actual kernel thread handle. The Rust
spawn JoinHandle transfers ownership into GThread in the shared scheduler state;
the handle is registered as the Object::Thread key. The interpreter still manages
waits, suspend counts, start gates and interpreted exit codes. The shared registry
recognizes native-range thread handles independently of event creation.

SetThreadDescription and GetThreadDescription remain ordinary native calls.
Windows stores the UTF-16 description, checks handle rights, returns the actual
HRESULT, and allocates query results for native LocalFree. No synthetic success,
name cache, string approximation or module-name exception is introduced. Current
thread pseudo handles continue to refer to the real calling OS thread. Invalid
and closed handles continue through the same native API error path. Native threads
created outside the interpreter keep their existing native path.

Explicit CloseHandle calls on managed thread handles invoke the real OS close.
A failed close (for example, protect-from-close) retains ownership and scheduler
identity and restores the captured native last-error after registry updates. A
successful close removes the mapping and consumes ownership exactly once, while
the running scheduler thread can finish independently. Closing a duplicate affects
only its kernel reference. Interpreter teardown releases remaining owned references
even if parked threads/callbacks still retain Shared; private cleanup removes a
caller-set protection flag at that boundary and reports failure to clear it.

Native description queries through duplicated handles observe the same object.
Unmanaged duplicates are not registered scheduler aliases: suspension/resumption
through such a duplicate of a live interpreted thread now diagnoses unsupported
behavior, rather than changing the OS suspend count while leaving the scheduler
start gate unchanged. Use the scheduler-managed handle for those operations.
Duplicate exit-code queries/waits remain native OS queries; they do not gain a
new guarantee of the interpreter return value or scheduler completion boundary.
Full alias scheduling/exit-code integration would require an explicit alias
ownership registry and additional regressions. No unrelated API stubs were added.

Official ABI contracts:

- [SetThreadDescription](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreaddescription): real handle rights, Unicode storage, replacement and HRESULT results.
- [GetThreadDescription](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreaddescription): query rights, returned UTF-16 allocation and LocalFree ownership.
- [GetCurrentThread](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentthread): per-caller pseudo identity and duplicate ownership.

## Original regressions and executed checks

The registry-only Rust test failed before the fix because a native-range thread
key was rejected unless a kernel event existed. Its numeric fixture is only a
map key; it never represents an OS allocation or fabricated native API result.
It passes after removing the process-global event-count shortcut in owns().

`tests/compiler-semantics/windows-thread-description.jai` is an original direct
SDK regression. It checks suspended startup, native thread IDs, Unicode/surrogate
names, empty/replaced names, parent/worker pseudo identity, descriptions through
native duplicates, denied set access through a query-only duplicate, protected
close failure/last-error parity, completed-thread query, invalid/closed handle
HRESULT failures and native LocalFree. The parent description is restored.
`crates/jaic/tests/cleanroom_windows_thread_description.rs` executes that fixture
through the interpreter on Windows. A Windows-only internal test verifies teardown
closes an owned protected handle even while Shared remains alive. Both compile in
Windows x64/ARM64 all-target clippy, but neither ran on this macOS host. Do not count
their target gating as a runtime pass.

Native Windows gate:

```sh
cargo test --locked -p jaic --test cleanroom_windows_thread_description
cargo test --locked -p jaic --lib interpreter_teardown_closes_its_owned_thread_handle
```

Run the owned standalone Jai fixture with the source-built compiler using -interp
and actual native -O0/-O2 execution on both CPUs. Also run the staged unchanged NEW
producer SDK reproducer in all three modes; it must print exactly ok and no naming
warnings. Native Windows execution is still required before declaring the CI
warning regression resolved. API availability follows native Windows (Windows 10
1607/Server 2016 or newer, with older documented export-location constraints).

Executed locally:

- Original core/backend library and focused language, atomic, context, module,
  reflection, variadic, interface, namespace, runtime and Windows scheduler suites
  pass; optimized Windows unwind O0/O2 metadata tests remain green, preserving true
  leaf behavior. Logs: target/thread-description-regressions.log and
  thread-description-scheduler-final.log.
- Runtime configuration CLI regressions retain real interpreter/native allocation
  and late workspace propagation. Producer adoption remains pending.
- Native host and Windows x64/ARM64 all-target clippy with warnings denied pass;
  owned Rust rustfmt/item spacing, source-built jaifmt check and strict verbose
  jailint pass on the owned Jai fixture.
- Owned and staged producer fixtures source-check for Windows x64/ARM64 and
  cross-link at x64 O0/O2. These are construction checks, not runtime evidence.

Safe producer staging: read NEW platform-io SDK reproducer, handoff/follow-up and
filtered ci-feedback-latest.md only. Copied it into our own
`target/producer-fixtures/thread-description`. Our old local candidate Thread had
a native Unix guard; the initial staging failure is retained. A separate own
library candidate copies the NEW platform-io Thread/internal/thread plus its
windows-text helper onto the documented runtime candidate. Missing helper staging
was corrected without editing producer sources or weakening guards. Final logs:
thread-description-producer-check-*-final.log and thread-description-native-builds*.log.
The initial filtered test invocation ran only the registry case (three scheduler
cases were filtered); it is not counted as scheduler coverage. The later full
scheduler suite passes. Clippy initially caught test-module placement; it was
fixed by moving tests to the end, without suppression.

Windows native descriptions and HRESULTs are delegated, not emulated on other
hosts. Host-independent scheduler tests still use synthetic handles there.
The existing scheduler parks unfinished OS workers after interpreter teardown;
this batch closes owned Windows handle references but does not redesign worker
cancellation. No benchmark claim is made for the extra registry mutex lookup on
native handles. See [runtime configuration](runtime-configuration.md) and the
mandatory deviations report for remaining independent integration/platform gates.
No peer writes, /Users/matthew/projects/jai-reference/quarantined/vendor body access or publication occurred.
