# Threads, sockets, and input

## What it is

`stdlib/Thread`, `Atomics.jai`, `Socket`, `Input`, `Keymap`, and `Gamepad` contain independently authored source bodies and normalized system SDK interfaces. The current OpenJai Thread and Input interfaces are the primary contracts; the richer older interfaces are additive where compatible.

This is an implementation draft with syntax evidence, not runtime acceptance. `stdlib/.coverage/thread-socket.json` records every owned file, its hash, frozen parser/lexer results, semantic blockers, and the remaining API and behavior gaps. Original source was read statically during API inspection, including some incidental implementation lines; no original implementation was copied into the authored procedure bodies and no original executable or native asset was executed, linked, or loaded.

## How it works

### Atomics

Scalar operations use the prelude's checked `compare_and_swap` primitive. Reads obtain the observed value through CAS; exchange, addition, and bit operations retry using the observed value from the previous attempt. Decrement reports whether the previous value was one. The compiler/VM primitive supplies the actual atomic operation and natural-alignment checks.

Deprecated double-width CAS uses the Linux x64 system `libatomic` generic compare-exchange entry. Other targets assert explicitly. Its ABI and execution remain unverified; it is not counted as cross-platform atomic coverage.

### Threads

`thread_init` prepares context and temporary storage, and `thread_start` creates the actual native worker. The C entry establishes the captured context, sets the worker index and temporary arena, invokes the typed callback, publishes completion through CAS, and signals its completion semaphore. Deinitialization joins the native worker before freeing owned arena storage. A supplied temporary arena remains caller-owned.

Mutexes use recursive pthread mutexes or Windows critical sections. Condition waits require one mutex acquisition; applications must recheck their own predicate after a wake. Semaphores maintain a count under a native mutex and condition variable. POSIX timed waits reuse one absolute realtime deadline across spurious wakes; Windows waits compute the remaining interval from the system tick count.

Thread groups allocate stable worker metadata before starting. Each worker has locked available/completed linked queues. Optional stealing pops other workers' queues under their locks. Entries move to completion only after the callback runs. `STOP` terminates that worker; shutdown returns false if queued work remains unprocessed or a deadline expires. A timeout retains the live group for a later retry. `get_completed_work` drains finished entries into group-owned array storage, valid until the next retrieval or shutdown. Shutdown releases queue metadata and thread resources; drain completed pointers before shutdown if they are needed.

The maintained `Thread_Proc` and `Thread_Group_Proc` opaque pointer aliases remain available. Typed `Native_Thread_Proc` and `Native_Thread_Group_Proc` overloads are provided for callable source callbacks. Conversion of opaque procedure cells and native callback entry still needs end-to-end compiler validation. Logging fields currently retain metadata; worker log output and race detection are not implemented. `DO_RACE_DETECTOR=true` rejects at compile time.

### Sockets

The four `generated_*.jai` files transcribe public SDK declarations, constants, and layouts without ordinary source bodies. Foreign entries identify installed system libraries. The wrappers implement initialization, error reporting, blocking and keepalive options, accept/bind, close/reset, address formatting, descriptor sets, ancillary alignment, and macOS byte-order conversion. IPv6 formatting compresses the longest zero run, choosing the first on ties. Address strings returned by Socket are allocated strings owned by the caller.

POSIX/Windows ABI approval and native link authority belong to the host/compiler, not these declarations. No native Socket executable was run. The inspected macOS `AI.MASK` expression is represented by its equal numeric mask to avoid an unresolved forward enum member in the frozen compiler. Binding inventory completeness does not establish that every SDK symbol exists in every installed SDK version.

### Input and Gamepad

Input owns pending events and frame state. `update_window_events` clears prior frame transients, calls an installed event adapter, publishes pending mouse/resize events, and applies keyboard transitions. Losing focus releases held states. Drag-and-drop events transfer their allocated filenames and array to Input, which releases them on the next frame. Queue and frame access belong to the same owner thread.

`init_input_system` installs native providers when no application provider was set. Windows polls the owner thread's Win32 queue and dispatches messages; X11 consumes the authored display queue, uses per-window XIM contexts, and forwards unhandled events through `x11_unhandled_event_source`; macOS dequeues AppKit events, dispatches them through NSApplication, and measures existing native windows. Android's separately owned `Android` adapter installs native-app callbacks and its owner-thread looper source. These source adapters have not been exercised on native hardware.

The maintained `Window_Type` remains `s64` and the public Event layout has no window field. Native adapters transport an actual handle by casting its pointer/address or XID into that carrier. `queue_input_event(window,event)` and `publish_input_event(window,event)` preserve explicit origin. The unscoped overloads preserve existing single-window behavior. `events_this_frame` is the ordered compatibility union; `routed_events_this_frame` and `unrouted_events_this_frame` are borrowed views. A multi-window UI consumes only its routed entries, then applies the application's chosen policy for unscoped events. It must not also consume the union. Input clears borrowed views before freeing each owning file-drop payload once. The publisher, queue and all frame views belong to one owner thread.

`set_input_focus(window,false)` releases only keys whose latest queued or published press originated in that window, retaining the actual origin in generated releases. The legacy overload releases all held keys. The maintained button-state array is still global: simultaneous presses of the same key from different windows cannot be represented independently. Per-window key state would require another additive state API.

The pointer query adapter reports success explicitly through `input_pointer_query_source`; the old two-result provider remains accepted. Native queue pumps cover physical keys, mouse buttons/wheels/motion, text and focus. XIM produces UTF-8 text; fallback XLookupString produces its documented Latin-1 text. AppKit currently reads NSEvent characters rather than implementing NSTextInputClient composition. Win32 translates queued keys to UTF-16 WM_CHAR and combines surrogate pairs. Sent Win32 resize/move notifications require `windows_process_input_message` integration in the application's window procedure; queue polling alone cannot observe them. Native drag-and-drop, IME preedit/candidate interfaces, touch beyond Android, custom cursor installation, and X11 extension events remain gaps.

Gamepad applies radial stick deadzones and rotation, trigger filtering and optional digital events through Input's publisher. Windows uses XInput 1.4 controller zero. macOS enumerates current GCController instances and selects the first extended profile. Linux scans existing `/dev/input/eventN` nodes read-only, requires physical gamepad capabilities, and obtains initial/current state through installed system libevdev. It never grabs a device. libevdev's sync mode handles dropped-event resynchronization; disconnect closes the descriptor, and later samples rescan. The direct Linux profile follows generic kernel gamepad button/axis usages; different device layouts require an application provider or SDL. No controller GUID, VID/PID or connection state is invented.

`use_sdl_gamepad` selects an optional installed SDL2 provider using SDL's mapping database. `Gamepad/SDL_Input_Map` independently parses classic button/axis/hat mapping strings and preserves its older record names/defaults. Failed parsing frees its partial allocation and returns false. GUID formatting uses actual supplied bus/vendor/product/version values and temporary allocation. Signed/inverted axis extensions and the original embedded controller database are deliberately recorded as unsupported; no vendor database was copied. `Gamepad/evdev` restores public system C declarations; `Gamepad/IOHID` is a minimal HID/CoreFoundation surface rather than the older broad display-driver binding inventory.

`use_iohid_gamepad(layout)` enables an additional macOS HID provider. It enumerates actual joystick/gamepad devices, reads current input elements, normalizes logical axis ranges and eight-way hats, and maps button usages supplied by the caller. Generic Desktop axis usages have configurable defaults; button mappings default to unmapped, since numbered USB HID buttons have no universal A/B/X/Y meaning. Close the selected explicit provider on the same owner thread before process teardown. Missing or disconnected devices return false and release held buttons on the next update.

### Keymap

Keymap uses the authored `legacy/Bucket_Array` because section pointers must remain stable. Later sections have higher dispatch priority. Named actions support press or hold callbacks; hold transitions suppress duplicate callbacks and release when a map is disabled or reset. A `:command` invokes the configured string handler. Matching applies modifier flags or the map's ignore-modifier setting.

The text loader accepts a `[1]` version header, registered `[Section]` names, `S-`, `C-`, `A-`, and `M-` prefixes, named keys, and a single UTF-8 code point. It validates every pending mapping before modifying any keymap. Invalid sections, actions, UTF-8, or modifiers leave existing mappings intact. Saving emits the version, sections, and active mappings, omitting comments. Text bindings currently cannot represent a literal `#` command payload, section brackets, or whitespace key tokens; a format extension is required for these cases.

## How to change it

Keep native ABI declarations in the platform files and portable state machines in the wrappers. Add a provider rather than returning invented events or completed work. Preserve public callback calling conventions, target widths, and ownership when extending device adapters.

Current OpenJai and older distribution surfaces conflict in places. Primary Thread returns, Input event bool/type/handle contracts, and enum values follow the maintained interface. Older Mutex named arguments, return shapes, Input numeric key values, native delegate APIs, and `Worker_Info` placement offsets are not fully preserved. Worker metadata retains named fields but uses separate padding rather than the original overlap layout. Record these differences as gaps rather than changing the primary API silently.

To validate syntax without building Rust, use the frozen CLI recorded in the coverage file:

```sh
target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs parse stdlib/Thread/module.jai
```

After compiler/dependency blockers are repaired, validate actual CAS contention, worker execution/join, stealing, timeout/retry, socket loopback exchange, Input press/release/focus transitions, Keymap failed-load rollback and save/reload, and XInput device sampling. Parsing or a foreign declaration alone proves none of these behaviors.

## Configuration

- Thread module parameters: `LOAD_THREAD_GROUP=true`, `CACHE_LINE_SIZE=64`, `DO_RACE_DETECTOR=false`.
- Thread temporary arena default: 16 KiB; caller-supplied storage remains borrowed.
- Thread and semaphore timeouts: milliseconds; negative waits indefinitely and zero polls.
- Native Input adapters install only into empty callback slots; custom application callbacks retain priority.
- Linux `gamepad_evdev_scan_limit=64` bounds discovery; `open_evdev_gamepad(path)` selects an explicit existing node.
- `use_sdl_gamepad` requires installed SDL2; `use_iohid_gamepad(layout)` requires an explicit HID usage profile.
- Input adapter callbacks and Gamepad sample callback remain application configuration points.
- Gamepad deadzones, rotation angles, digital thresholds, and event flags are public configuration fields; their zero/false record defaults remain intact.
- Socket keepalive optional intervals/counts use seconds and positive counts; zero leaves the system setting unchanged.

## Dependencies

The authored prelude, Basic allocation/array/builder helpers, Runtime_Support context, POSIX/Windows SDK interfaces, Math, File, Text_File_Handler, and the authored legacy Bucket_Array. Native providers require installed system libraries and separate trusted native linking approval.

Maintained interfaces were checked against [OpenJai Thread](https://raw.githubusercontent.com/withlang-dev/open-jai/main/modules/Thread/module.jai) and [OpenJai Input](https://raw.githubusercontent.com/withlang-dev/open-jai/main/modules/Input/module.jai) on 2026-10-02. XInput declarations and normalization follow Microsoft's [XInputGetState](https://learn.microsoft.com/en-us/windows/win32/api/xinput/nf-xinput-xinputgetstate) and [XINPUT_GAMEPAD](https://learn.microsoft.com/en-us/windows/win32/api/xinput/ns-xinput-xinput_gamepad) documentation. Live checks confirm those declarations and ranges, not hardware execution.

Current adapter SDK references: Microsoft's [message queue semantics](https://learn.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues), X.Org's [Xlib keyboard and input methods](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html), the kernel's [gamepad specification](https://www.kernel.org/doc/html/latest/input/gamepad.html), SDL2's [mapping-string contract](https://wiki.libsdl.org/SDL2/SDL_GameControllerAddMapping), and Apple's installed macOS SDK IOKit HID/CoreFoundation headers. This evidence establishes source contracts, not device execution or approval of foreign calls.
