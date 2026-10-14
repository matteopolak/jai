# Debug implementation questions: final review resolved

The final reviewed [Debug module page](../stdlib/modules/debug.md) resolves every previously routed question. No function contract/dependency blocker remains.

- `USE_GRAPHICS := true` is the sole parameter. Both interactive procedures are absent when false. Linux loads the real X11 dialog dependency only with graphics; Mac returns Abort as reviewed; Windows maps the native choices.
- Unix os_attach_to_debugger returns false without launching. The wrapper returns true for an existing debugger first. Windows uses real AeDebug registry substitution/confirmation, system vsjitdebugger fallback, process launch/wait/exit status and attachment polling for up to one minute.
- Automatic Windows dump state defaults Mini; None suppresses automatic output and Full requests full memory. Explicit writes choose Mini/Full from their Boolean independently. Names contain the executable basename and UTC timestamp in the working directory. Explicit calls do not update the borrowed automatic latest-result getter; failed/disabled automatic attempts replace that result with empty. Non-Windows write/getter return empty as explicitly reviewed.
- init_crash_handler_thread is absent under the supplied false constant. Its alternate conditional declaration promises no initialization effect; no separate crash thread is claimed.
- init installs the selected interactive_assert/break_assert callback only over the runtime default and preserves custom callbacks. The native snapshot lifecycle remains canonical and serialized.

Independent bounded policies are documented in [runtime policies](../../debug-public-runtime.md): exact UTC filename format with PID/sequence, CREATE_NEW failure behavior, nonblocking automatic DbgHelp lock acquisition, the documented two AeDebug %ld substitutions with unknown formats falling back, and bounded legacy X11 text rows. Internally remembered Ignore keys/backing are persistent process-owned storage; explicitly inserted public table keys retain normal Hash_Table lifetime requirements. Native context snapshots own bytes and borrow context pointees.

The remaining gaps are verification only: Windows/Linux native execution and Android compiler-target availability. Mac public behavior runs interpreter/native O0/O2; asynchronous fatal/foreign-thread callbacks run native only. SDK Windows builds and native-ready fixtures are not reported as Windows execution. The local worker inbox records coordination because agent_message is unavailable.
