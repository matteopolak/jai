# Codec and native bindings

## What it is

These independently authored Jai declaration surfaces cover the 16 assigned codec/native modules. Public names, signatures, defaults, fields, enum values, constants, and module-version contracts follow the pinned supplied Jai APIs. Foreign behavior remains an explicit external dependency; no native codec, allocator, profiler, shader tool, or vendor SDK implementation was authored or executed.

The maintained official SDK/header sources reviewed below inform the required foreign ABI. They do not expand the public Jai namespace. Eight unused modern API previews and five superseded module copies were moved to `/private/tmp/jai-codec-api-previews/`; no public source loads them.

## How it works

Reference sources were read only for declarative contracts. Their procedure bodies, native binary paths, compile-time execution blocks, decoder lookup tables and allocator algorithms were discarded. New helpers were written independently from their API shapes and specified behavior. The public modules retain their original loading structure: `module.jai` loads the pinned binding files, and rpmalloc's original `USE_RAW` option selects its raw contract variant.

`#foreign` declarations resolve through named `#system_library` selectors. Libraries must be independently obtained, built and reviewed outside this change. A custom adapter declaration is not a shipped implementation. Jai strings, slices, `File`, context callbacks and multiple return values require the exact Jai ABI; renaming a C symbol does not provide it.

| Module | Public contract and external ABI boundary |
| --- | --- |
| `freetype-2.12.1` | Pinned 2.12.1 declarations and constants remain. The `freetype` system selector requires a reviewed compatible layout and symbol set. Current 2.14.3 additions were removed from the public namespace. |
| `freetype255` | Pinned 2.5.5 layout through `jai_freetype255_legacy_adapter`; direct interchange with newer face/slot records is unverified. |
| `lz4` | Pinned 1.9.4 API, constants and stream layouts through `jai_lz4_1_9_4_adapter`. The incompatible current high-compression minimum constant does not replace the pinned contract. |
| `meshoptimizer` | Pinned 0.11 API through `jai_meshoptimizer_0_11_adapter`. Current meshlet/simplification signatures are incompatible and were removed from the public namespace. |
| `stb_image` | Pinned image API through `jai_stb_image_adapter`; no decoder implementation. |
| `stb_image_resize` | Pinned resize1 API through `jai_stb_image_resize_adapter`; current resize2 enums, signatures and state records are not public additions. |
| `stb_image_write` | Pinned encoder API and three external settings variables through `jai_stb_image_write_adapter`; no encoder implementation. |
| `stb_vorbis` | Pinned API through `jai_stb_vorbis_adapter`. Sound_Player needs only the seven existing procedures listed below and `stb_vorbis_info.channels`/`sample_rate`; it treats decoder state as opaque. |
| `pl_mpeg` | Pinned Jai records, slices, `File` handles and procedure names through `jai_pl_mpeg_adapter`; no MPEG or MP2 decoder implementation. |
| `rpmalloc` | Pinned 1.4.4 APIs, layouts, callback signatures, module parameters and mode dispatch contract through `jai_rpmalloc_adapter`. Current 2.0 mapping/configuration declarations were removed from the public namespace. |
| `telemetry3` | Disabled instrumentation is independently implemented. Active 3.5.0.147 instrumentation remains a `jai_telemetry3_adapter` contract. |
| `nvidia_aftermath` | Pinned API 535 through `jai_aftermath_535_adapter`; direct resolution to a newer SDK is unverified. |
| `nvtt` | Pinned original C++ platform declarations through `jai_nvtt_legacy_adapter`; non-POD returns require a reviewed ABI adapter. The missing PS5 declaration file is explicitly unsupported. |
| `MojoShader` | Pinned symbols and records through `jai_mojoshader_legacy_adapter`; unused current SPIR-V API expansion was removed. |
| `Thekla_Atlas` | Pinned declaration/platform layout contract through `jai_thekla_atlas_adapter`; no atlas implementation or ABI validation. |
| `Thekla_Baker` | Pinned declaration/platform layout contract through `jai_thekla_baker_adapter`; no baker implementation or ABI validation. |

Independent source behavior consists of FreeType flag/named-instance field queries, NVTT value-to-pointer overload forwarding, six MPEG pixel-format forwarding procedures, and disabled Telemetry hooks. Forwarding still depends on its target foreign procedure. The 122-procedure count includes platform variants and the deliberately disabled hooks, and is not a runtime coverage claim.

The maintained Sound_Player consumer in `stdlib/Sound_Player/cached_decoder.jai` calls `stb_vorbis_open_memory`, `stb_vorbis_open_filename`, `stb_vorbis_get_info`, `stb_vorbis_stream_length_in_samples`, `stb_vorbis_seek`, `stb_vorbis_get_samples_short_interleaved`, and `stb_vorbis_close`. All already exist in the pinned binding; no speculative names were needed. The adapter implementation has not been authored or executed.

## How to change it

Preserve the public pinned Jai contract unless a verified maintained consumer requires a specific name or signature change. Read the current official API/header to establish the matching foreign ABI, then record the consumer proof and ABI prerequisites in the coverage manifest. Keep speculative current SDK declarations in private temporary previews until they have a concrete consumer.

To implement a missing Jai-specific operation, replace its `#foreign codec_adapter` declaration with independently written behavior and verify actual inputs/outputs before updating behavioral coverage. Keep foreign library identity, symbol availability, callback calling conventions, field layout and ownership requirements explicit.

The frozen parser cannot represent several old metadata directives. Legacy Telemetry's private `#no_reset` counter annotation and NVTT's procedure-pointer reflection annotation were omitted. NVTT destructor callbacks require an explicit flags argument because the frozen callback-type parser cannot retain the `.NONE` default. NVTT non-POD return metadata is documented but unsupported; these are adapter contracts, not validated direct C++ calls. MPEG `#bake_arguments` pixel aliases were replaced by independently written forwarding procedures. Raw rpmalloc's supplied `FIRST_CLASS_HEAPS` profile is unresolved and explicitly asserted unsupported when `USE_RAW` is selected rather than guessing a layout/configuration.

## Configuration

Every module has an explicit 64-bit pointer-width assertion. The pinned native records and size types are unverified for other widths. Adapter build flags and layout must match the selected pinned contract; importing declarations does not establish that match.

`telemetry3` defaults to `ENABLED := false`. Disabled mode also applies outside Windows. Its 13 event/control no-ops are intentional only in that branch, and `telemetry_enabled()` returns false. Active hooks are external contracts. rpmalloc preserves its supplied allocator parameters and `USE_RAW` flag; they require a matching adapter implementation, not an assumed equivalent mapping to current rpmalloc 2.x.

Library selectors contain no repository-relative binary paths. The manifest lists the exact selectors per module. No dependency was installed, built, discovered, authenticated, loaded or linked by this work.

## Dependencies and verification

Compatibility declarations import internal `Basic`, `File`, `Math`, `POSIX`, `Windows`, `Atomics`, `Machine_X64` and `d3d12` modules where the pinned contracts require them. External libraries/adapters must be independently reviewed separately.

Current official sources were reviewed on 2026-10-02: [FreeType 2.14.3](https://freetype.org/), [LZ4 1.10.0](https://github.com/lz4/lz4/releases/tag/v1.10.0), [meshoptimizer 1.3](https://github.com/zeux/meshoptimizer/releases/tag/v1.3), [stb headers and versions](https://github.com/nothings/stb), [pl_mpeg public API](https://github.com/phoboslab/pl_mpeg/blob/master/pl_mpeg.h), and [rpmalloc 2.0.1](https://github.com/mjansson/rpmalloc/releases/tag/2.0.1). The modern resizer and rpmalloc 2.0 mapping callbacks differ from their pinned predecessors, which is why their speculative public declarations were removed.

Vendor provenance is [Telemetry history](https://www.radgametools.com/telemetry/history.html), [Aftermath SDK](https://developer.nvidia.com/nsight-aftermath/getting-started), [original archived NVTT project](https://github.com/castano/nvidia-texture-tools), [MojoShader official header](https://github.com/icculus/mojoshader/blob/main/mojoshader.h), and [Thekla Atlas](https://github.com/Thekla/thekla_atlas). No maintained official public Baker source was located. Current SDK names/version announcements alone do not prove compatible record layout or runtime behavior.

`stdlib/.coverage/codec-native-bindings.json` preserves official header SHA-256 digests, review URLs, exact removed-preview locations, maintained consumer proof, foreign/custom-adapter counts, independent helpers, unsupported metadata/configuration gaps, and syntax results. It also lists 17 excluded generator/native-build/example/test reference files; their workflow behavior is unavailable.

All **39 public Jai files** pass frozen `jai-rs parse FILE` syntax validation with **2,174 parsed top-level items**. The public surface contains **1,250 foreign declarations**, including **230 custom adapter contracts**, plus **122 independently authored procedures**. **Verified runtime behavior count is zero, and current SDK/API behavior completeness remains false.** No Cargo command, compiler build, original generator, native link, decoder execution or SDK execution was run. Syntax acceptance proves neither symbol availability nor native ABI/behavior.
