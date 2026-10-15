# JAVA_HOME host discovery

Reviewed public API: Android/Toolchain JAVA_ENV_NAME and
find_java_bin_path_from_environment, including exact result and parameter names.
Canonical JAVA_ENV_NAME is immutable "JAVA_HOME". Private implementation lives
under internal/android-toolchain/java-discovery.jai and exports no conveniences.

JAVA_HOME names the Java installation root. The implementation copies only that
explicitly named variable, appends bin/java (bin/java.exe on Windows), then runs
the actual executable with -version and checks real launch/exit/timeout status.
It captures and frees output, including normal version text on stderr. Returned
bin/executable strings are independent context-owned allocations; failures return
false with empty paths and release intermediate allocations. Trailing separators
are normalized; spaces remain argv content rather than shell syntax. No JAVA_HOME
fallback, PATH scan, Java minimum-version guess, SDK default or installation is
invented. SDK/NDK discovery remains separate unfinished public surface.

Official host-tool authority: [Gradle installation](https://docs.gradle.org/current/userguide/installation.html)
documents JAVA_HOME pointing to a JDK root and java -version validation. This
does not establish unreviewed Jai failure/default/ownership policies: require a
working launcher before success, context-owned returned strings and absence of
PATH fallback are independent supported choices pending finer contract review.
No JDK version gate is inferred from current Gradle requirements.

POSIX uses public libc getenv, copying the selected value before process launch.
Windows uses GetEnvironmentVariableW and the existing Windows_Utf8 conversion;
environment size changes fail instead of exposing partial values. Private ABI
matches [official SDK](https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getenvironmentvariablew).
Windows Process implementation/integration is peer-owned and not yet validated
in this portable staging tree. No native Windows support claim is made by these
host tests. Callers must serialize concurrent environment mutation under the
native environment API's rules.

Run python3 -B tools/check_portable_java.py. It builds an independent C launcher
protocol fixture from source; this is not a JVM and does not prove Java/SDK
integration. Six environment cases (usable, trailing separators, exit7 failure,
missing file, empty, unset) run through interpreter and ARM64/x64 native O0/O2:
30 executions. Linux both-CPU source checks and focused strict lint pass.
Evidence: target/android-java-red.log and android-java-final.log.

Test corrections are separate: the first fixture used a relative JAVA_HOME but
the compiler CLI intentionally changes to the source directory before execution.
Use an absolute explicit fixture installation and expected result arguments so
interpreter/native launches refer to the same installation. Production relative
path resolution follows each process current directory; no compiler workaround
or module-specific path special case was added. Private standalone lint also
required its own scope-module Basic import, now explicit. No inherited legacy
test oracle changed and no SDK/device/auth/credential operations were run.
