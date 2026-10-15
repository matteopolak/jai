# Android SDK command subsystem design

REFRESHED REVIEW FOLLOW-UP: synchronized Android/Toolchain behavior now specifies
SDK discovery/cache, per-call server startup, generic shell double-quote wrapping,
compression conflict assertion, exact version lines/temporary fields and device
temporary-array backing. Existing implementation below predates that refinement
and still requires correction. PID failure=-1 and first-PID warning also differ.
Earlier protocol passes remain process/safety evidence, not conformance proof for
these policies. No SDK/device integration success is claimed. New ASN.1 contract
corrections are handled in a separate checkpoint before this ADB follow-through.

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
