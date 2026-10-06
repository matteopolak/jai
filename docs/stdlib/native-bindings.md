# Native and platform bindings

## What it is

Declaration-only modules that let Jai code call operating-system APIs and C libraries through `#foreign`, `#system_library` and `#library`: the platform layers (`POSIX`, `macos`, `Windows`, `Linux`, `Android`, `Objective_C`, `Metal`, `X11`, `d3d11`, `d3d12`, `dxgi`, `d3d_compiler`, `dxc_compiler`, `Vulkan`, `GL`) and third-party libraries (`SDL`, `ImGui`, `Curl`, `stb_image`, `stb_image_write`, `stb_image_resize`, `stb_vorbis`, `freetype-2.12.1`, `freetype255`, `lz4`, `meshoptimizer`, `MojoShader`, `nvtt`, `pl_mpeg`, `rpmalloc`, `telemetry3`, `Thekla_Atlas`, `Thekla_Baker`, `nvidia_aftermath`). They contain types, constants and prototypes, and little logic.

## How it works

- Platform layers branch on `OS`: `POSIX/module.jai` pulls in `POSIX/bindings/{linux,macos,android}`, `errno.jai`, `file-mode-wait.jai` and `linux-stat.jai`; `macos/` has `core_foundation.jai`, `kernel.jai`, `mach.jai` and `kevent.jai`; `Objective_C/` holds Foundation, AppKit, CoreGraphics and GameController declarations (with `arm64`/`x64` ABI variants) and `bindings/{arm64,x64}/{message,runtime}.jai` for the Objective-C runtime and `objc_msgSend`; `Windows/` has `support.jai` and `resources.jai`; `Linux/` has `epoll.jai` and `io_uring*.jai`.
- Libraries are named with `#system_library "name"` (resolved by the OS loader) or `#library` (a path). Libraries no OS ships, like `stb_image` and `stb_vorbis`, are built from pinned sources by `tools/build_native_libs.py` into `artifacts/native-libs/<os>-<arch>/`, where `jaic` looks before the system search ([third-party native libraries](../tools/native-libs.md)). Other libraries (`SDL2`, `libcurl`, `freetype`, Vulkan) must be installed on the host.
- Some modules pick their foreign library per OS (`SDL/module.jai` selects SDL2 by `OS`; `Curl/{unix,windows}.jai`; `freetype-2.12.1/{unix,windows}.jai`). `Vulkan` has generated per-OS files plus a dispatch layer (`dispatch-native.jai`, `dispatch-registry.jai`) that loads entry points at run time. `GL` bundles a glad-style loader (`glad_core.jai`, `load-all.jai`) and per-OS context creation (`mac-context.jai`, `linux-context.jai`, `windows-context.jai`).
- Supported native targets: macOS x64/arm64, Linux x64/arm64, Windows x64/arm64. The browser target (`OS == .WASM`) uses the Linux x86-64 layouts that the sandbox implements (`crates/jaic/src/interp/sandbox.rs`), whatever `CPU` says (`CUSTOM` under `-os wasm`, as in the browser and `jaic build -os wasm`).
- **No silent defaults.** Every CPU-dependent layout or constant names each CPU it supports, and anything else is a compile error:

  ```jai
  #if CPU == .ARM64 && OS != .WASM {
      nlink_t :: u32;
  } else #if CPU == .X64 || OS == .WASM {
      nlink_t :: u64;
  } else {
      #assert false "POSIX: no Linux struct stat layout for this CPU";
  }
  ```

  A bare `else` would hand a new CPU the x86-64 layout, and a wrong layout fails silently: `is_directory` reads `st_uid` as the mode, or `pthread_mutex_init` clears 8 bytes past the mutex. Where a layout is the same on every CPU there is no branch; a comment says so only when that is surprising.
- Linux glibc differences between x86-64 and AArch64 that branch this way: `stat_t`/`stat64_t`, `nlink_t`/`blksize_t`, the pthread size table and `__pthread_mutex_s.__spins`, `__jmp_buf`, `O_DIRECTORY`/`O_NOFOLLOW`/`O_DIRECT`, `epoll_event` (packed only on x86-64), `ipc_perm.mode`, the signal context (`sigcontext`, `mcontext_t`, `ucontext_t`), `NGREG` and `MAP_32BIT` (x86-64 only), and the `SYS_*` numbers in `syscall.jai` (AArch64 uses the generic table, so none are declared there). Other per-CPU files: `POSIX/module.jai` (macOS and Android CPU directories), `Socket/generated_macos.jai` (`select` symbol), `Objective_C/module.jai` (runtime and `objc_msgSend` variants) and `Windows.jai` (`CONTEXT`, x64 and arm64).
- Cross-checking another OS needs no SDK: `jaic check file.jai -os windows` selects the `#if OS == .WINDOWS` branches. Calling them requires running on that OS.
- Many binding files are produced with [bindings-generator](bindings-generator.md) from the C headers; the generated files are checked in.

### ABI check against C headers

`tests/abi/manifest.txt` lists the C items the stdlib declares by hand (structs, opaque types, integer typedefs, constants), grouped into sections by OS or `os-cpu` target. `crates/jaic-cli/tests/abi_layout/mod.rs` turns the active entries for one target into two programs:

- a C program built against the system headers that prints `sizeof`, `_Alignof`, `offsetof`, each field's size, typedef signedness and constant values;
- a Jai program importing the stdlib bindings that prints the same items from `size_of`, `align_of`, `type_info` member offsets and sizes, and the constants.

The two outputs are compared item by item. A mismatch names the target, the item and both values:

```
[linux-arm64] struct ipc_perm field mode: size C=4 Jai=2
[windows-x64] type TIME_ZONE_INFORMATION: size C=172 Jai=0
[linux-x64] constant SOMAXCONN C=4096 Jai=128
```

Two native tests in `crates/jaic-cli/tests/native.rs` use it:

- `stdlib_c_abi_matches_host_headers` checks the host target. It runs on every CI host: `cargo test --workspace` in `ci.yml` (Linux and macOS, both CPUs) and `--test native` in `windows-native.yml` (Windows x64 and arm64, with clang and the MSVC/Windows SDK headers). Without a C compiler it skips locally and fails under `CI`.
- `stdlib_c_abi_matches_cross_target_headers` checks targets the host cannot run. It does nothing unless `JAIC_ABI_CROSS` is set. For each target it compiles the C program with `clang -target <triple> -S -emit-llvm` and reads the values out of a constant array in the IR (nothing runs), and evaluates the Jai side at compile time with `jaic check -target <triple>` and a `#run`.

The browser target is not checked: there are no C headers for it, and it reuses the Linux x86-64 layouts that the `linux-x64` check covers.

Cross checking needs headers for the target. From a macOS arm64 host:

| Target | Headers | Works locally |
|---|---|---|
| `macos-x64` | the macOS SDK (`xcrun --show-sdk-path` is added automatically) | yes |
| `windows-x64`, `windows-arm64` | MinGW-w64 (`brew install mingw-w64`) via `-isystem` | yes (MinGW, not the Windows SDK) |
| `linux-x64`, `linux-arm64` | a glibc sysroot via `--sysroot` | only with a sysroot |

zig's bundled glibc headers or a Nix/Docker sysroot would do; they aren't required because the Linux CI runners check both Linux CPUs natively. The per-host test is the guarantee; the cross test is a faster local signal.

## How to change it

- Add a function by declaring it with the exact C signature and calling convention; struct layouts must match the C ABI (the compiler classifies by-value structs, see the ABI notes in [bindings-generator](bindings-generator.md)).
- A new third-party library that no OS ships: add a source pin and a one-line translation unit to `tools/native-libs.json`, then rebuild with `build_native_libs.py`.
- Keep OS-specific declarations in their own file and select them with `#if OS == ...` in `module.jai`, so other targets still type-check.
- A binding whose C type or value differs between CPUs branches on every supported CPU and ends in `#assert false` (see above). For Linux, compare `<bits/stat.h>`, `<bits/pthreadtypes-arch.h>`, `<bits/fcntl.h>`, `<bits/setjmp.h>` and `<sys/ucontext.h>` per architecture.
- **Adding a manifest entry.** Put it in the narrowest section that has the C declaration (`[linux]`, `[linux-arm64]`, `[windows]`, ...). Add any missing `c:` include. Examples:

  ```
  struct stat_t = struct stat : st_mode st_size st_atime=st_atim
  struct inotify_event : wd mask cookie len name[]
  type pthread_mutex_t
  int nlink_t
  const O_DIRECTORY SOMAXCONN PTHREAD_CREATE.JOINABLE=PTHREAD_CREATE_JOINABLE
  ```

  C struct tags need `= struct <tag>`, renamed fields use `jai=c`, and a flexible array member is written `name[]` (declare it `[0] T` in Jai). Use `type` for structs declared `#type_info_none` (Windows `CONTEXT`), since their fields are not visible. Write `packed struct` for a C `__attribute__((packed))` struct (x86-64 `epoll_event`): Jai cannot give a struct a lower alignment than its members, so only its size and field offsets are compared. Then run the host test, and the cross test for the targets you can:

  ```sh
  cargo test -p jaic-cli --test native stdlib_c_abi
  JAIC_ABI_CROSS="macos-x64;windows-x64:-isystem $MINGW;windows-arm64:-isystem $MINGW" \
    cargo test -p jaic-cli --test native stdlib_c_abi_matches_cross_target_headers
  ```

  where `MINGW=/opt/homebrew/opt/mingw-w64/toolchain-x86_64/x86_64-w64-mingw32/include`.
- **Adding a target** (a new CPU or OS): add a branch for it to every `#if CPU` chain listed above (the `#assert false` arms point at each one when you compile for it), add its mapping in `cross_target` and the host OS/CPU mapping in `stdlib_c_abi_matches_host_headers`, add a manifest section if it has items of its own, and give it a CI runner that runs `--test native`, so the host check covers it.
- Regression programs that touch bindings: `tests/stdlib/posix-stat-and-mutex.jai` (stat results and a mutex's neighbour, built natively on every CI host), `tests/stdlib/c-variadic-foreign-calls.jai`, `cpp-method-and-array-decay.jai`, `buildcpp-api.jai`, `const-integer-pointer.jai`. Real library calls (SDL windows, GL contexts, Vulkan devices) are exercised only by the corpus projects, not by `tests/stdlib`.

## Configuration

`-os linux|windows|macos` (or `-target <triple>`, which also sets the CPU) on the `jaic` command line selects the OS and CPU branches. `Window_Creation`, `Simp`, `Input` and others take their own module parameters (see their pages). Library search: `artifacts/native-libs/<os>-<arch>/` first, then the system loader.

ABI check: `CC` (host C compiler; default `cc`, or `clang` on Windows), `CI` (a missing compiler is an error instead of a skip), `JAIC_ABI_CROSS` (`;`-separated `os-cpu[:extra clang args]` targets, e.g. `linux-arm64:--sysroot /path/to/sysroot`), `JAIC_ABI_CLANG` (clang for cross checks; default `clang`).

## Dependencies

System SDK headers/libraries at generation time and for the ABI check (a C compiler on every CI host; clang plus target headers for cross checks); at run time the named shared libraries must be present. The checked-in binding sources depend on `Basic`, `POSIX` and, for Apple frameworks, `Objective_C`.
