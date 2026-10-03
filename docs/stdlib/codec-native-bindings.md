# Codec and native bindings

## What it is

These 16 modules retain the pinned public Jai APIs while independently authored Jai bridges call genuine upstream C/C++ or SDK entry points. The bridges handle the Jai/native boundary; codec, allocator, atlas, shader and vendor SDK algorithms remain external runtime dependencies.

The completion packet replaces all **230 fabricated compatibility adapter contracts** with independently authored Jai bodies: 109 MPEG operations/macros, 66 rpmalloc operations, 16 active Telemetry operations and 39 NVTT vtable operations. Direct C bindings use genuine upstream library selectors. This is source implementation coverage, not verified runtime coverage. Some historical API behavior remains unavailable or unverified, as listed below.

Maintained official headers establish the foreign API to target. They do not silently replace pinned module versions or expand public namespaces. Eight unused modern previews and five superseded module copies remain outside public `stdlib` in `/private/tmp/jai-codec-api-previews/`.

## How it works

Reference files were read only for declaration contracts. Original bodies, decoder tables, allocator algorithms, compile-time execution blocks, native assets and repository-relative binary locators were discarded. Public loading structure remains pinned; three new module-private `native.jai` files hold the MPEG, rpmalloc and Atlas bridges and genuine native declarations.

| Module | Jai/native boundary and required upstream profile |
| --- | --- |
| `freetype-2.12.1` | Pinned 2.12.1 records/constants and independently authored face-flag queries use `freetype`. Reviewed 2.14.3 basic symbols inform compatibility; OS-specific C `long` widths and full record ABI must match. |
| `freetype255` | Genuine `freetype` symbols and the pinned 2.5.5 record prefixes; appended modern fields and full record interchange remain unverified. |
| `lz4` | Genuine `lz4` symbols. Pinned 1.9.4 constants/stream declarations remain; reviewed 1.10.0 signatures include experimental static-API functions that an external build must expose. Private stream layout access remains version-sensitive. |
| `meshoptimizer` | Genuine 1.3 `meshoptimizer` exports. Four Jai wrappers adapt simplification arguments and convert modern meshlet arrays to the pinned inline 64-vertex/126-triangle representation. The scan builder replaces the old builder; old partition/numeric equivalence is unverified. |
| `stb_image` | Genuine 2.30 `stb_image` C exports, including stdio, HDR, GIF, 16-bit, zlib and thread-local APIs. Public callbacks are already C-call functions; `FILE` arguments are native C handles. |
| `stb_image_resize` | Genuine official deprecated 0.97 resize1 `stb_image_resize` exports. Current resize2 2.18b uses incompatible declarations and cannot satisfy the pinned resize1 ABI. |
| `stb_image_write` | Genuine 1.16 `stb_image_write` C exports and the three real mutable native settings variables. |
| `stb_vorbis` | Genuine 1.22 `stb_vorbis` exports with stdio, pushdata, pull decoding and short-sample APIs. Maintained Sound_Player treats the decoder as opaque; accessing its exposed internal records requires the exact native layout. |
| `pl_mpeg` | Jai wrappers convert strings, slices, `File`, booleans, packet enums, callbacks and public shadow records into the genuine reviewed native ABI. Every public low-level operation calls an actual `plm_*` export or independently implements a small helper. Internal helper exports and native records require the exact reviewed header hash and build profile. |
| `rpmalloc` | Jai wrappers call genuine rpmalloc 1.4.4 C allocation, first-class heap, thread and statistics APIs. Config strings/callbacks are translated to C, with callback context restored. A locked independent live-allocation registry supports Jai ownership queries. Both normal and `USE_RAW` surfaces call these same real native APIs. |
| `telemetry3` | Active Jai hooks initialize and call the actual pinned RAD SDK function table obtained through `tmGetApi` from `rad_tm_win64`; strings are interned through SDK formatting. Capture lifecycle, zones, plots, thread names and GPU zones call SDK entries. Disabled hooks intentionally emit no events. |
| `nvidia_aftermath` | Genuine `GFSDK_Aftermath_Lib.x64` entry points require the pinned API 535 ABI. Newer release metadata alone does not establish compatibility. |
| `nvtt` | Independently authored vtable forwarding and result-storage wrappers call genuine `nvtt` C++ symbols. Non-POD returns follow reviewed x86-64 Itanium/MSVC ordering; pointer/value overloads forward independently. The external archived NVTT 2.x header/compiler ABI must match. PS5 remains explicitly unsupported. |
| `MojoShader` | Genuine `mojoshader` C symbols with pinned records. Current main header contains 41 of the 45 retained names; four historical compiler/preprocessor procedures require a separately reviewed historical provider. |
| `Thekla_Atlas` | Jai wrappers map pinned options to the reviewed official current C++ API, map error enums, carry callback userdata and implement a nonmanifold retry by isolating faces and restoring original vertex cross-references. The native atlas algorithm stays upstream. |
| `Thekla_Baker` | Genuine historical `thekla_baker` C++ names retain the pinned declaration contract. A maintained authoritative public upstream source was not located; provider availability and layout review remain unresolved. |

MPEG registries associate unchanged public records with separate exact native records. Constructors preserve memory/file ownership, callbacks restore their Jai context, and push/pull operations translate mutable record fields. Jai `File` never masquerades as native `FILE *`: genuine upstream buffer callback constructors use independent Jai read/seek/tell callbacks. The source profile requires stdio and interleaved audio, the recorded native layouts, and all 106 used non-static exports, including internal decoder helpers. Registry access assumes synchronous use of each decoder; concurrent shared manipulation is unverified.

The two pinned MPEG lexical macros are implemented independently. `BLOCK_SET` inserts the caller's `Code`, advances captured `di`/`si`, and supplies `x`, `y`, `dest_scan` and `source_scan`. `PUT_PIXEL` needs captured `frame`, `y_index`, `d_index`, `dest`, and precomputed `r`/`g`/`b` chroma offsets. It writes clamped RGB using documented BT.601 luma conversion. Their captured lexical contract is preserved; legacy numerical equivalence is unverified. Six named pixel-format aliases call the genuine upstream conversion functions.

rpmalloc ownership queries cover live blocks allocated through these wrappers, including their usable ranges. They do not inspect arbitrary native spans, classify freed blocks or discover allocations made outside the wrappers. `is_initialized()` records wrapper-managed lifecycle. `set_main_thread()` assigns a real acquired first-class heap. The module parameters affect the ABI/build profile and must match the independently built runtime; they do not rebuild or reconfigure an already loaded native library.

Atlas current upstream has no rich error-record API and no native assertion callback. The retained `error_data` output is null; registered assertion callbacks receive Jai input-validation failures, while native assertions cannot be intercepted. Isolated-face repair preserves attributes, materials and output cross-references but does not claim the historical repair algorithm or chart quality. These are remaining compatibility gaps.

The unchanged maintained consumer `stdlib/Sound_Player/cached_decoder.jai` needs `stb_vorbis_open_memory`, `stb_vorbis_open_filename`, `stb_vorbis_get_info`, `stb_vorbis_stream_length_in_samples`, `stb_vorbis_seek`, `stb_vorbis_get_samples_short_interleaved`, and `stb_vorbis_close`, plus `info.channels` and `info.sample_rate`. All survive in the pinned surface. They resolve to genuine stb_vorbis exports; a separate invented native adapter is no longer required.

## How to change it

Preserve pinned public names, signatures, defaults, fields and version constants unless an unchanged maintained consumer proves a change is required. Modify the module-private bridge when upstream argument order, callbacks, result storage or records differ. Record the precise native header revision, calling convention, build settings and ownership rules before claiming compatibility. Keep speculative SDK additions in private previews.

For MPEG, changing the native header requires reviewing every private record and internal helper export together. For rpmalloc, review both public variants and optional heap statistics/cache fields; `Span_Use` is needed when adaptive caching or statistics are enabled. For NVTT, adding an architecture requires implementing its non-POD return calling convention rather than relaxing the x86-64 guard.

The frozen parser cannot preserve Telemetry's private `#no_reset` metadata or NVTT procedure-pointer reflection metadata. NVTT destructor callback flags require an explicit argument because the old `.NONE` callback-type default is not representable. Genuine result-storage wrappers replace the former unsupported non-POD annotations. MPEG bake aliases use independent forwarding bodies.

Keep `stdlib/.coverage/codec-native-bindings.json` aligned with source changes. Its independent-body count includes module-private helpers, lexical macros, platform variants and deliberately disabled hooks; it is not a count of unique public APIs or executed behaviors. The older whitespace-normalization receipt is retained only as historical evidence and does not describe the new source token streams.

## Configuration

Every module requires 64-bit pointers. NVTT additionally requires `CPU == .X64`. No native dependency is installed, built, loaded or linked by this rewrite; externally reviewed builds must be discoverable under the recorded `#system_library` names. Header-only stb and MPEG libraries require externally compiled implementation translation units exporting their genuine entry points without static linkage.

rpmalloc requires genuine **1.4.4**, `RPMALLOC_FIRST_CLASS_HEAPS=1`, matching statistics/adaptive-cache/cache/configurable settings and matching related size constants. Both `USE_RAW` values are bridged. Current **2.0.1** has different configuration/statistics ABI and cannot be substituted implicitly. LZ4 experimental symbols require an external build that exposes static-API functions; stdio/thread-local feature selection must match the retained stb declarations.

`telemetry3` defaults to `ENABLED := false`; non-Windows targets also select disabled mode. Its 13 empty control/event hooks are intentional only in that disabled branch, and `telemetry_enabled()` returns false there. Active mode requires the pinned SDK 3.5.0.147 bootstrap and 2022.05.23.51766 API-table contract on Windows x64. SDK capture, finite-frame control and timestamp behavior remain unexecuted.

## Dependencies and verification

Internal dependencies include the pinned `Basic`, `File`, `Math`, `POSIX`, `Windows`, `Atomics`, `Machine_X64` and `d3d12` interfaces. Native libraries and vendor SDKs are independent external prerequisites, distinct from the Jai bridges implemented here.

Primary API review on 2026-10-02 covered [FreeType 2.14.3](https://github.com/freetype/freetype/blob/VER-2-14-3/include/freetype/freetype.h), [LZ4 1.10.0](https://github.com/lz4/lz4/releases/tag/v1.10.0), [meshoptimizer 1.3](https://github.com/zeux/meshoptimizer/releases/tag/v1.3), [official stb headers](https://github.com/nothings/stb), [deprecated resize1](https://github.com/nothings/stb/blob/master/deprecated/stb_image_resize.h), [pl_mpeg](https://github.com/phoboslab/pl_mpeg/blob/master/pl_mpeg.h), [current rpmalloc 2.0.1](https://github.com/mjansson/rpmalloc/releases/tag/2.0.1), and [pinned rpmalloc 1.4.4](https://github.com/mjansson/rpmalloc/blob/1.4.4/rpmalloc/rpmalloc.h). Record declarations in official rpmalloc 1.4.4 source were reviewed for optional layout dependencies; no allocator implementation was copied or executed.

Vendor and ABI sources are [RAD Telemetry history](https://www.radgametools.com/telemetry/history.html), [Aftermath SDK](https://developer.nvidia.com/nsight-aftermath/getting-started), [archived NVTT header](https://github.com/castano/nvidia-texture-tools/blob/master/src/nvtt/nvtt.h), [MojoShader current header](https://github.com/icculus/mojoshader/blob/main/mojoshader.h), [exact official Atlas revision](https://github.com/Thekla/thekla_atlas/blob/e6f034837ca3936c9817958746e9f46f8dd22a75/src/thekla/thekla_atlas.h), [Itanium result-return ABI](https://itanium-cxx-abi.github.io/cxx-abi/abi.html#non-trivial-return-values), and [LLVM's Microsoft ABI source](https://github.com/llvm/llvm-project/blob/main/clang/lib/CodeGen/MicrosoftCXXABI.cpp). Source digests and exact prerequisites are recorded in the manifest; symbol-name presence alone does not prove ABI compatibility.

All **42 Jai files** pass the frozen source-only parser with **2,466 top-level items**. Inventory is **1,150 foreign declarations**, **zero fabricated custom adapter contracts**, and **473 independently authored Jai bodies**, including private/platform/macro/disabled variants. **Verified runtime behavior count is zero; semantic typing, native linking, ABI execution and complete current SDK coverage have not been established.** No Cargo command, compiler build, original generator, supplied binary execution or native SDK/decoder/allocator execution was performed. Seventeen excluded reference generators, builds, examples and tests retain no workflow implementation coverage.
