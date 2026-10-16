# Mac application and input initialization

The public `Window_Creation.init_mac_app()` and `Input.update_window_events()` workflows execute essential AppKit and Objective-C runtime operations even when the actual default Basic instance has assertions disabled. Public declarations and record layouts are unchanged.

Before the production change, the real activation-policy operation and `class_addMethod` were evaluated only inside optional assertions. The corrected SDK setup gives enabled controls that pass and disabled controls that fail at both native O0 and O2. Receipt: `artifacts/local-verification-stdlib/cargo-target/cocoa-assertions-39e1u4q2/results.json`.

Private application initialization checks the SDK load, main thread, application and activation-policy results explicitly, logs errors and returns failure even when an assertion handler continues. It publishes its application pointer only after successful initialization. The public mutable `application_initialized` flag reflects that result. Window creation and event retrieval stop on initialization failure.

Input observer initialization calls method registration unconditionally. A failed method registration disposes the unregistered class pair. A successfully registered class remains owned for an object-allocation retry; notification-center failure releases the candidate object. The observer pointer is published after registration. A genuine native class-name collision is tested twice with a recovering assertion handler: both attempts log an error, and neither claims a notification method was installed.

Run with the worker-local source-built compiler and formatter:

```sh
CARGO_TARGET_DIR="$PWD/artifacts/local-verification-stdlib/cargo-target" python3 tools/check_portable_cocoa_shared.py
```

The final receipt `cocoa-assertions-uvrm8thj/results.json` contains 25 passing checks: twelve actual native executions, four builds, a strict SDK helper build, two Mac source targets, two complete owned strict-lint contexts and four formatting gates. Both real default configurations are tested; changing only a caller's imported Basic configuration would not test the default instances used by these modules. The helper uses real SDK calls and runtime introspection, creates no user windows and supplies no fake successful native results.

Test correction is separate from production: AppKit can already have prohibited activation policy and reject redundantly setting that same policy. The helper now queries the real policy before changing it. Initial setup failures in both configurations are preserved in `cocoa-assertions-z2ebkyy2` and `cocoa-assertions-6uvzke3x`; they are not evidence of the library defect.

Native X64 execution, full window/event delivery, allocation exhaustion, AppKit exception recovery and other platform backends remain unverified by this scope. No entire GUI module completion is claimed. T7 session 44236 remains without a result; the user identified repeated external-drive permission prompts, not a demonstrated hardware or capacity fault. Verification used newly authorized role-local output directories and current shared Rust sources.
