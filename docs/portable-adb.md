# Android SDK command subsystem design

CURRENT SDK/startup correction: android_find_sdk_path checks conventional home
directory first, then ANDROID_HOME/ANDROID_SDK_ROOT/ANDROID_SDK_HOME in exact reviewed
order, using the NEW foundation producer's real File_Utilities.is_directory. Set
invalid environment candidates warn; absent values are skipped. SDK selection
returns an active-context copy. is_adb_installed checks platform-tools/adb (adb.exe
on Windows) and returns a temporary path without running version or a daemon.
No PATH fallback or unrelated user directories are scanned. Conventional Windows
path is AppData/Local/Android/Sdk; all other reviewed targets use Android/Sdk.

With no explicit __adb_path, adb discovers once and retains an owned durable copy
using the runtime default allocator, preserving its allocator for replacement.
Public __adb_path is still the same mutable entity, with explicit caller overrides
honored directly. SDK environment changes do not refresh a nonempty cache. An
explicit clear permits rediscovery and releases the previous privately owned cache
through its saved allocator/normal Basic free path. Process-lifetime retention of
the current cache is intentional; no public teardown API is invented. Callers must
serialize configuration/environment mutation; concurrent cache reconfiguration
has no established public guarantee.

Every valid wrapper call explicitly executes executable start-server before the
requested command. Actual exit/launch/timeout failure logs/asserts and returns
failure if assertions continue. Essential calls are outside optional assertions;
captured startup buffers are released. No-command failure executes neither step.
Startup protocol logs prove ordering; this is a source-built SDK-command fixture,
not actual SDK/server/device/auth verification.

Evidence: target/adb-sdk-final.log. Main and SDK/cache fixtures pass five
interpreter/native ARM64+x64 O0/O2 modes each; verbosity passes three modes.
Default Basic ENABLE_ASSERT=true/false startup success/failure each pass allfive
modes, with verification explicitly importing a separate enabled instance. Both
staged Basic defaults are changed, so this actually varies the ADB instance.
Linux x64/ARM64 public bodies and strict lint pass. Formatting checks owned code.
Dependency composition copies NEW foundations read-only into target/, not peer
edits or completed coordinator integration. Public SDK environment fallback,
empty SDK missing-executable, cache/reset/rediscovery and startup failure are
tested. Existing conventional-home-directory precedence is implemented but that
existing-directory branch is not native-tested here: the actual home SDK is absent,
and tests do not mutate user home. Native Windows/Linux/Android and real SDK/device
integration remain pending; Windows Process/System integration is peer-owned.

Additional test corrections: expected fixture path first contained lexical ../
segments unlike canonical environment paths; normalize only the expected fixture
through public File.get_absolute_path and free its allocation. No production path
special case was introduced. Standalone internal-file lint needed the actual module
load context (facade plus file); both assertion configurations now receive it.
Historical follow-up notes below preserve earlier evidence and are superseded by
the CURRENT SDK/startup correction and first-policy batch where applicable.

REFRESHED REVIEW FOLLOW-UP: synchronized Android/Toolchain behavior now specifies
SDK discovery/cache, per-call server startup, generic shell double-quote wrapping,
compression conflict assertion, exact version lines/temporary fields and device
temporary-array backing. Existing implementation below predates that refinement
and still requires correction. PID failure=-1 and first-PID warning also differ.
Earlier protocol passes remain process/safety evidence, not conformance proof for
these policies. No SDK/device integration success is claimed. New ASN.1 contract
corrections are handled in a separate checkpoint before this ADB follow-through.

First correction batch is now verified: version requires exactly three ordered
prefix lines and returns temporary views into a retained temporary capture copy.
Devices require the heading/row data, diagnose malformed required fields, retain
temporary backing and return a temporary array; callers do not individually free
fields/array. This chooses safe backing lifetime where original capture lifetime
was ambiguous, as reviewer permits. Duplicate metadata simply updates a view.
Generic shell arguments containing literal spaces are wrapped in double quotes,
including prequoted strings; other characters are unchanged as reviewed. Transfer
compression conflicts assert and fail, not silently prioritize disabled mode.
PID failure is -1; success uses first PID and warns on ignored later values.
No-command adb logs and fails; failed launch preserves default exit code0.
SDK discovery/cache/server-start behavior remains a genuine open correction batch.

Evidence: target/adb-reviewed-policies-final.log passes all five interpreter/native
ARM64+x64 O0/O2 modes, verbosity, Linux both CPUs and strict lint. Explicit local
temporary storage exercises lifetimes while regular allocations return to zero.
Tests now require malformed-device assertion/error, both compression-conflict
assertions, exact PID warnings/failures, shell argument bytes and empty-command
diagnostics. Fatal verification handlers are restored after each intended failure.

Separate harness correction: copyfile had dropped executable permission from
the malformed-output fixture. Earlier malformed version/devices assertions only
proved launch-failure fallback, not parsing. Refreshed diagnostic-count regression
exposed this (target/adb-reviewed-policies-first.log). copy2 now preserves mode;
the actual native malformed-output parser path runs. Earlier malformed coverage
claims are superseded; positive/exit-status process evidence remains valid.

Reviewed API: docs/specs/stdlib/modules/android-toolchain.md. SDK CLI protocol:
https://android.googlesource.com/platform/packages/modules/adb/+/refs/heads/main/docs/user/adb.1.md

Use direct argv Process execution, public configuration stored in the one facade
module instance, canonical Adb_Device/Adb_Version_Info/compression declarations,
and private parsing/remote-argument escaping grouped under internal/android-toolchain.
Capture stdout/stderr and expose actual process exit status. Failed launch,
nonzero exit and malformed SDK output must remain failures. No SDK/device results
are synthesized. Transfers map reviewed options to documented SDK flags.

First cohesive batch: command execution, version/device discovery and transfer/
process/package-query helpers. Install/key-mismatch recovery, device selection,
app external-storage policy and project/build orchestration remain separate work.
These must not be counted implemented by the first batch.

Tests use a source-built native CLI protocol fixture for process/argv/parser/error
behavior, clearly distinguished from SDK/device integration. Actual SDK version
may be checked with an explicit SDK path; no server/device/authentication commands
are executed against the user's environment. Native Android code generation and
unavailable device verification are not inferred from host orchestration tests.

Contract follow-up: the reviewed inventory does not specify returned string/array
ownership, empty-serial/global precedence, malformed-output policy or exact shell
escaping. Independent supported policy will return context-allocator-owned strings
and arrays; explicit nonempty serial overrides the public global. The optional
generic shell flag escapes spaces; command-specific wrappers quote literal remote
arguments fully. Record these as compatibility questions, not established reference
behavior. SDK tool commands/flags and canonical public record shapes are established.

Implemented first batch: adb/is_adb_installed/adb_version/adb_devices, push/pull,
shell mkdir/pidof and uninstall, three canonical public types and three live
configuration variables. Explicit serial overrides global serial; the public path
is read for each invocation. Generic shell escaping handles spaces only; the
high-level mkdir/pidof wrappers use complete POSIX literal quoting. Disable-
compression takes precedence over algorithm selection. These fine policies are
independent supported choices pending review, not inferred reference internals.
Returned capture/version/device strings and device-array data belong to the active
context allocator. Keep that allocator alive and free each returned field plus
array data. Device records do not borrow freed process-output buffers.

`python3 -B tools/check_portable_adb.py` builds its independent C protocol fixture,
then runs interpreter/host ARM64/translated x64 native O0/O2. It verifies actual
process execution, explicit/global serial selection, executable/arguments with
spaces, actual nonzero exit/status/stderr, launch failure, version/device parsing,
ready filtering, malformed output, exact transfer flags and remote quoting.
All test allocations return to zero under a tracking allocator. Linux both-CPU
source checks and strict scoped lint pass. Formatting/check uses repository config.
This is host protocol regression evidence, not SDK/device integration. No adb
executable was found on PATH; no actual daemon/device/auth command was run.

Initial owned errors: pointer-to-string indexing and pointer-array iteration were
corrected to explicit data/value access. Strict lint removed unused later result
bindings; actual exit codes still determine success in adb. A global private
Process import incorrectly made unrelated Windows digest use require the Unix
Process module; moved that dependency into the adb body. Existing Windows digest
checks pass again. Evidence: target/android-adb-red.log, android-adb-first.log,
android-adb-final.log, adb-digest-dependency.log and adb-digest-dependency-final.log.
The entire Android/Toolchain module remains incomplete; no declarations-only
completion, Windows ADB support or device behavior success is credited.

App lifecycle batch adds exact public stop_app, is_app_running and
android_is_app_installed signatures. Official SDK command authority:
https://developer.android.com/tools/adb (am force-stop and pm path).
Package arguments use the same private remote-shell quoting. pm path must succeed
and contain nonempty package:/ paths; malformed output is not installation proof.
pidof must return positive decimal s32 process IDs, including every token in a
multiple-process response. Hex prefixes, zero, overflow and malformed later IDs
fail. adb_shell_pidof shares this parser and returns the first valid PID.
The separate running/success result distinguishes an empty, diagnostic-free
status1 no-match from malformed output/transport/launch failures. This narrow
status policy is an independent supported choice pending review; no general
claim that every status1 means absence. Stop reports the actual force-stop status.

Evidence: target/adb-apps-red.log (missing exports), adb-apps-final.log (all five
interpreter/native host+x64 O0/O2 runs, verbosity, Linux both CPUs, strict lint).
The source-built CLI fixture exercises present/absent/offline/malformed paths,
multiple PIDs and memory ownership. No inherited tests were corrected. One
production tightening replaces generic integer parsing with decimal PID parsing.
Actual SDK/device lifecycle and Windows execution remain unverified.
