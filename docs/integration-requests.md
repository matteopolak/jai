# Integration requests

Requests are read by coordinator; this worker cannot send messages to the desktop thread.

1. Run full original public application corpus externally without exposing vendored library/compiler sources to this worker. Supply filtered diagnostics and minimal independent reproducers only. Local integration must use vendor-free staging of permitted unchanged application entries.
2. Provide refreshed stable producer refs/manifest when meaningful checkpoints are ready. This worker uses only manifest-listed independent refs; it will not inspect shared/quarantined integration history or another checkout's scratch data.
3. After review, run native temporary-branch CI including macOS x64 and Windows. No publication/release jobs may run. Focus launch and user acceptance, particularly issue #1 signed wheel/event propagation, remain coordinator-owned gates.
