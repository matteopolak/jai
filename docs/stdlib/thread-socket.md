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

Install `input_event_source`, `input_initialize_source`, and `input_pointer_source` to connect a window backend. A missing pointer adapter reports unavailable or asserts for the window-specific query. No macOS, X11, Android, or Win32 event-pump adapter is implemented here. The maintained `Window_Type` is `s64`; older platform pointer handles need an explicit adapter.

Gamepad accepts a normalized `Gamepad_Sample` provider, applies radial stick deadzones and rotation, filters triggers, tracks digital transitions, and optionally appends Input events. Windows installs an XInput 1.4 sampler for controller zero. Without a provider, the controller is disconnected and releases its held buttons. Set deadzones/thresholds and event flags before sampling. Automatic macOS/Linux device discovery and the older `IOHID`, `evdev`, and `SDL_Input_Map` modules are pending.

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
- Input adapter callbacks and Gamepad sample callback are explicitly configured integration points.
- Gamepad deadzones, rotation angles, digital thresholds, and event flags are public configuration fields; their zero/false record defaults remain intact.
- Socket keepalive optional intervals/counts use seconds and positive counts; zero leaves the system setting unchanged.

## Dependencies

The authored prelude, Basic allocation/array/builder helpers, Runtime_Support context, POSIX/Windows SDK interfaces, Math, File, Text_File_Handler, and the authored legacy Bucket_Array. Native providers require installed system libraries and separate trusted native linking approval.

Maintained interfaces were checked against [OpenJai Thread](https://raw.githubusercontent.com/withlang-dev/open-jai/main/modules/Thread/module.jai) and [OpenJai Input](https://raw.githubusercontent.com/withlang-dev/open-jai/main/modules/Input/module.jai) on 2026-10-02. XInput declarations and normalization follow Microsoft's [XInputGetState](https://learn.microsoft.com/en-us/windows/win32/api/xinput/nf-xinput-xinputgetstate) and [XINPUT_GAMEPAD](https://learn.microsoft.com/en-us/windows/win32/api/xinput/ns-xinput-xinput_gamepad) documentation. Live checks confirm those declarations and ranges, not hardware execution.
