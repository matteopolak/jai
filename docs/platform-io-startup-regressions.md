# Windows startup regressions after cc07c00

The coordinator-filtered feedback confirms the Platform I/O interpreter/native
O0/O2 step passed on real Windows x64 and ARM64 at cc07c00. The full jobs failed;
signed-wheel and renderer interpreter tests reported command-line conversion failure.
No raw logs or corpus implementation bodies were inspected.

## Omitted interpreter argv

The native runtime's strict conversion remains correct. The interpreter's
executable-query adapter returned an empty command line for an omitted argv vector,
then intercepted CommandLineToArgvW and deliberately returned NULL. The runner's
unconditional `--` populated argv[0], hiding this path from the passing step.

The fix supplies the interpreted executable name only when the entire argument
vector was omitted, leaves supplied arguments unchanged, and delegates parsing to
Shell32. It does not accept a failed conversion or bypass runtime initialization.
Microsoft documents that an empty CommandLineToArgvW input returns the executable
path, and NULL means failure, in its [native API contract](https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-commandlinetoargvw).
The runtime retains WC_ERR_INVALID_CHARS and both conversion count checks, matching
[WideCharToMultiByte](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-widechartomultibyte).

Two original Rust tests failed before the fix and pass afterward. Additional tests
preserve caller-supplied Unicode/empty/quoted arguments. The new
`tests/platform-io/startup-arguments-contract.jai` checks initialized context and
argv[0], valid surrogate-pair conversion, malformed-surrogate rejection and
insufficient-buffer failure. The runner now exercises no `--` and explicit `--`
startup independently. Actual Windows execution of this new fix remains required.

## ARM64 default crash policy: narrow review request

Reviewed compiler.md declares Build_Options.backtrace_on_crash default .ON and
runtime_support_definitions default .AUTO. Reviewed runtime-support.md selects the
x64-only Windows handler when its explicit enable parameter is true. The private
Compiler adapter serializes all option fields: untouched default .ON and an
explicit assignment of .ON have identical values. There is no reviewed AUTO crash
enum member or explicitness field to distinguish them.

Please review the exact default-versus-explicit rule for Windows ARM64. Is Compiler
.ON target-best-effort while explicit Runtime_Support imports remain strict, or is
another conditional default/selection rule required? No public default or strict
unsupported-handler diagnostic has been changed pending this review.

This original minimal reproducer uses the actual public defaults and fails with
the x64-only handler diagnostic on ARM64. Save it as `default-startup.jai`, supply
OUTPUT_PATH and CHILD_SOURCE with `-add`, and run `jaic default-startup.jai -check
-os windows -cpu arm64 -add '<definitions>'`. CHILD_SOURCE can name the original
startup-arguments fixture above. Its source was formatted before inclusion here;
the failing command/output is retained in target/platform-io-default-arm64/default-red.log.
It is a pending integration reproducer, not a completed positive native test.

```jai
// Original default-option reproducer; deliberately does not assign crash policy.
#import "Basic";
C :: #import "Compiler";

#run {
    workspace := C.compiler_create_workspace("default Windows startup");
    options := C.get_build_options(workspace);

    assert(options.backtrace_on_crash == .ON);
    assert(options.runtime_support_definitions == .AUTO);
    options.output_path = OUTPUT_PATH;
    options.output_executable_name = "default-startup";
    C.set_build_options(options, workspace);
    C.compiler_begin_intercept(workspace);
    C.add_build_file(CHILD_SOURCE, workspace);

    while true {
        message := C.compiler_wait_for_message();
        if message.kind == .COMPLETE {
            assert((cast(*C.Message_Complete) message).error_code == .NONE);
            break;
        }
    }

    C.compiler_end_intercept(workspace);
}

main :: () {}
```

The incomplete default ARM64 path remains a genuine full-matrix blocker. Explicit
OFF startup and the explicit ON rejection tests continue to run; neither is claimed
as proof that untouched defaults work. Renderer GL/GDI SDK library selection belongs
to bindings/window integration and remains separate from the interpreter argv fix.

## ARM64 default crash policy: resolved engineering direction

The coordinator decision in windows-arm64-backtrace-decision.md confirms that
untouched .ON and explicit .ON are indistinguishable. Public defaults remain
.ON/.AUTO. Runtime entry now uses an independent private native ARM64 backend;
the public x64-shaped Runtime_Support_Crash_Handler remains rejected on ARM64.
No guessed context layout, compiler target mask or false default/explicit split
was added. See [design and verification](platform-io-arm64-crash-plan.md).

The original default-options reproducer is restored as
`tests/platform-io/windows-default-startup-build.jai`. It failed with the x64-only
handler diagnostic before this implementation and now passes ARM64 checking with
both default fields untouched. Durable red/green logs are in
target/platform-io-default-arm64/default-backend-{red,green}.log.

The native runner now builds and executes ordinary startup and real access
violations under explicit .OFF, explicit .ON and untouched defaults at O0/O2.
Enabled faults must preserve STATUS_ACCESS_VIOLATION, print at least two real
frames and have no unwind/unavailable-stack failure. ARM64 additionally executes
native C init/reference-count/final-shutdown/reinitialization/filter/error-mode
assertions. No test assertion was dropped. Native execution of these new cases
remains for coordinator CI; x64 cross-builds and ARM64 source/object checks do not
establish native results.

The private backend uses SDK CONTEXT, a unique duplicated process handle and
serialized DbgHelp. RtlVirtualUnwind2 is dynamically resolved, validates stack
bounds and handles native unwind metadata/leaf frames. It requires Windows 11 or
Server 2022; missing API is an explicit error. A copied context protects the
OS-provided fault state. The public x64 callback ABI cannot represent ARM64 and
continues to diagnose. Concurrent symbol work reports stack-unavailable instead
of deadlocking. See the deviations report for lifecycle/concurrency limits.

Renderer GL/GDI SDK library selection remains a separate bindings/window gap.
The filtered missing Basic current_time_monotonic, seconds_since_init and to_apollo
names are present in reviewed basic.md and are real foundation API gaps, not invented
legacy conveniences. Native_Thread_Proc and ENABLE_NATIVE_INPUT_ADAPTERS were not
found in the reviewed module inventory; coordinator should classify those expectations
without weakening actual thread/input ABI and behavior regressions.
