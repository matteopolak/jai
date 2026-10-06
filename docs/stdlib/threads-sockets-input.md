# Threads, atomics, sockets and input

## What it is

`Thread` (threads, mutexes, condition variables, semaphores, thread groups), `Atomics`, `Socket` (BSD/Winsock wrappers), and the input stack: `Input` (event queue and key state), `Keymap` (named key bindings loaded from text) and `Gamepad`.

## How it works

`Thread/primitives.jai` defines `Thread` and the operations `thread_init(thread, proc)`, `thread_start`, `thread_is_done`, `thread_deinit`, plus `Mutex` (`init`, `lock`, `unlock`, `destroy`), `Condition_Variable` (`wait`, `wake`, `wake_all`) and `Semaphore` (`signal`, `wait_for`). POSIX targets call `pthread_create` (`native_posix.jai`); Windows uses `CreateThread` (`native_windows.jai`). Under `jaic run` the interpreter schedules these threads cooperatively ([threads under jaic run](../compiler/interpreter-threads.md)).

The worker procedure has the type `Native_Thread_Proc :: (*Thread) -> s64`. The thread gets a copy of the starting context and its own temporary storage (16 KiB by default; a supplied `starting_storage` stays caller-owned). Waits take milliseconds: negative waits forever, zero polls.

```jai
#import "Basic";
#import "Atomics";
#import "Thread";

counter: s64;
worker :: (thread: *Thread) -> s64 {
    atomic_add(*counter, 1);
    return thread.index;
}

main :: () {
    t: Thread;
    thread_init(*t, worker);
    thread_start(*t);
    thread_deinit(*t);   // joins
    print("%\n", counter);   // 1
}
```

`Thread_Group` (`thread_group.jai`, loaded when `LOAD_THREAD_GROUP`) has `init`, `start`, `add_work`, `get_completed_work` and `shutdown(timeout_milliseconds)`. Each worker has locked available and completed queues; `get_completed_work` returns group-owned storage valid until the next call or shutdown.

`Atomics` offers `atomic_add`, `atomic_read`, `atomic_write`, `atomic_swap`, `atomic_and/or/xor`, `atomic_increment/decrement` and `compare_and_swap2`, built on the compiler's compare-and-swap primitive.

`Socket` has one generated declaration file per OS (`generated_linux.jai`, `generated_macos.jai`, `generated_windows.jai`, `generated_android.jai`) and a shared wrapper in `module.jai`: `socket_init`, `bind`, `accept`/`accept_v6`, `set_blocking`, `set_keepalive`, `get_last_socket_error`, `close_and_reset`, and address formatting via `to_string`.

`Input` owns the pending event list and per-frame key state. `update_window_events` clears frame transients, runs the installed event adapter and applies key transitions. `init_input_system` installs the native provider for the OS when none is set (`ENABLE_NATIVE_INPUT_ADAPTERS`); the first `update_window_events` calls it, so programs that never do still get events. On macOS the adapter follows only the windows `Window_Creation` made (`Window_Type.macos_program_windows`), not AppKit's own helper windows, and queues `QUIT` for one that is no longer visible without being minimized, which is what closing it does. Events can be tied to a window with `queue_input_event(window, event)`; held keys and focus are tracked per window (`window_key_is_down`, `get_window_key_state`, `set_input_focus(window, bool)`), and the global key array is the union.

On Windows, `Input` registers the window procedure `Window_Creation` gives its windows (`#add_context _windows_windowproc`). Windows calls it directly for sent messages that never reach the queue (`WM_SIZE` while a window is created, `WM_CLOSE` from the close button), so it copies each message into a fixed buffer, without a Jai context, and the pump turns them into events. `WM_CLOSE` reports `QUIT` and keeps the window open. On X11 a window's size is reported when it is mapped, because without a window manager no `ConfigureNotify` arrives.

`set_custom_cursor_handling(false)` (the default) keeps the standard arrow over Input's windows: Windows resets it from the class cursor on `WM_SETCURSOR`, and the macOS and X11 pumps set it again on every pointer move in one of the windows. With `true` the program owns the cursor (GetRect's pointer images, for example) and Input leaves it alone; on Windows the procedure answers `WM_SETCURSOR` in the client area itself. `tests/stdlib/window-input-native-events.jai` checks both settings on all three systems (X11 through XFixes cursor serials).

`Keymap` loads a text format (`[1]` version header, `[Section]` names, `S-`/`C-`/`A-`/`M-` modifier prefixes) into sections with press or hold callbacks; later sections have higher priority. `Gamepad` applies deadzones to controller state from XInput (Windows), GameController (macOS), evdev (Linux) or an SDL2 provider (`use_sdl_gamepad`).

## How to change it

- Keep OS calls in the platform files and the state machines in the shared ones. A provider reports what the OS reports; it doesn't synthesize events.
- `Window_Type` (`Window_Type.jai`) is the native window handle type of the target OS (`HWND`, `X11.Window`, `*NSWindow`); `Input.Event` has no window field, so per-window routing goes through `Routed_Input_Event` and the `queue_*`/`publish_*` overloads.
- Tests: `tests/stdlib/threads-cooperative.jai`, `input-multi-window-focus.jai`, `input-compat-names.jai`. Native providers (X11, AppKit, Win32, evdev, IOHID) need real windows and devices and have no tests.
- Mutex and thread-group changes affect `File_Async`, `Overwriting_Allocator` and the memory debugger, which all use them.

## Configuration

`Thread(LOAD_THREAD_GROUP=true, CACHE_LINE_SIZE=64, DO_RACE_DETECTOR=false)`; `DO_RACE_DETECTOR=true` is rejected at compile time. `Input(ENABLE_NATIVE_INPUT_ADAPTERS=true)`; set false to supply your own providers (adapters only fill empty callback slots). Gamepad deadzone, rotation and threshold fields are public configuration.

## Dependencies

`Basic`, `Atomics`, `POSIX`/`Windows` bindings, `Math` and `File`/`Text_File_Handler` (Keymap), `Bucket_Array` (Keymap). Native input needs X11, AppKit or Win32; gamepads additionally need XInput, libevdev, GameController or SDL2.
