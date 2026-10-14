# Native Windows device notifications

`Input.MyWindowProc` now opens native HID and canonical `Windows.XBOX_GUID`
interface registrations at `WM_CREATE`, rolls back a partial registration failure,
and unregisters both handles at `WM_NCDESTROY`. Failure to register rejects native
window creation rather than claiming device support. Existing renderer teardown
continues at `WM_DESTROY`; it is independent of these notification handles.

Arrival/removal messages validate the native header, interface class, name byte
count and bounded UTF-16 terminator before invoking `the_gamepad_handler`. The
callback receives the original native path pointer, valid during that synchronous
callback. `connect` follows arrival/removal; `is_xbox` distinguishes the canonical
Xbox interface class from HID. No callback is emitted for other message kinds,
interface classes, null handlers or malformed supported payloads.

The native `dbch_size` describes kernel-provided readable storage. As with the
Win32 message contract, callers injecting messages must supply a readable buffer
of the advertised size; the parser cannot establish ownership of arbitrary pointers.
No native identifier or type is reconstructed: those come from the NEW canonical
Windows binding. Only its missing `UnregisterDeviceNotification` procedure is
privately declared with the SDK BOOL/HDEVNOTIFY ABI.

`tests/window-render/windows-device-decoding.jai` loads the exact production parser
with canonical Windows types and exercises it in the interpreter for x64/arm64.
It checks both classes and directions, pointer identity, Unicode path data, all
short headers, odd byte counts, absent terminators, unknown class/type/kind and
null callback/data. It creates no window and does not stand in for native execution.

`windows-device-notifications.jai` creates a real public window, sends native
`WM_DEVICECHANGE` messages through `SendMessageW`, and verifies actual public callback
propagation plus ignored malformed/unsupported payloads. It source-checks for both
Windows CPUs here; native runtime and physical hotplug remain pending Windows CI.
The regular issue #1 real-window wheel tests remain required and unchanged.

Native SDK sources:

- [RegisterDeviceNotificationW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerdevicenotificationw)
- [UnregisterDeviceNotification](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-unregisterdevicenotification)
- [DEV_BROADCAST_DEVICEINTERFACE_W](https://learn.microsoft.com/en-us/windows/win32/api/dbt/ns-dbt-dev_broadcast_deviceinterface_w)

Compatibility question: the reviewed Input contract does not state whether HID
paths associated with XInput must also report `is_xbox=true`. The implementation
uses the native registered interface class, without a guessed path/VID heuristic.
Any broader classification needs review and native devices; notification dispatch
and the native registration lifecycle are implemented independently of that question.
