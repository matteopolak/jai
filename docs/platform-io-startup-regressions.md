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
The filtered missing Basic current_time_monotonic, seconds_since_init and to_apollo
names are present in reviewed basic.md and are real foundation API gaps, not invented
legacy conveniences. Native_Thread_Proc and ENABLE_NATIVE_INPUT_ADAPTERS were not
found in the reviewed module inventory; coordinator should classify those expectations
without weakening actual thread/input ABI and behavior regressions.
