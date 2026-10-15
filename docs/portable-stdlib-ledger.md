# Portable standard library module ledger

Status is explicit; a facade or declaration alone does not imply implementation.
Ownership exclusions are listed in [implementation ownership](implementation-ownership.md).

| Spec | Status |
| --- | --- |
| [adpcm](specs/stdlib/modules/adpcm.md) | Implemented fixed tables, nibble and complete-block decoder; saturation and two-channel PCM checks pass interpreter/native; incomplete blocks unsupported per spec |
| [android-aaudio](specs/stdlib/modules/android-aaudio.md) | Reserved for bindings worker; not implemented or modified here |
| [android-egl](specs/stdlib/modules/android-egl.md) | Reserved for bindings worker; not implemented or modified here |
| [android-toolchain](specs/stdlib/modules/android-toolchain.md) | Owned portable scope; not implemented |
| [android](specs/stdlib/modules/android.md) | Reserved for bindings worker; not implemented or modified here |
| [atomics](specs/stdlib/modules/atomics.md) | CAS arithmetic/bitwise contention and exact bootstrap load/store/exchange aliases execute in interpreter/native after compiler integration. Scalar domain/conversion/ordering details need review |
| [autorun](specs/stdlib/modules/autorun.md) | Unix native helper and real workspace COMPLETE lifecycle implemented/tested; argument/error/non-executable logs verified. Compiler spread fix permits direct argv call; workaround removed. CLI orchestration, callback parameter and Windows unfinished |
| [base64](specs/stdlib/modules/base64.md) | Implemented public tables, standard/URL codecs and self-tests; RFC and permissive edge vectors pass interpreter/native |
| [basic](specs/stdlib/modules/basic.md) | Shared foundations ownership: retained arrays/allocation/scalars/builder; portable owner adds to_apollo plus POSIX realtime/monotonic, timespec and UTC/local calendar conversions. Interpreter/native checks pass; full per-time-API gaps in portable-time.md |
| [bindings-generator](specs/stdlib/modules/bindings-generator.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [bit-array](specs/stdlib/modules/bit-array.md) | Implemented canonical type, bit mutation, padding and logical/selected iteration; interpreter/native cases pass |
| [bit-operations](specs/stdlib/modules/bit-operations.md) | Implemented width-generic byte swap, scans and population count; interpreter/native cases pass |
| [bucket-array](specs/stdlib/modules/bucket-array.md) | All reviewed exports implemented; stable pointers, locators, reuse and iteration pass interpreter/native |
| [buildcpp](specs/stdlib/modules/buildcpp.md) | Unix native-host C/C++ compile/archive/link/object and macOS universal outputs implemented; artifacts executed/loaded, stale archive members removed, failures preserve output and cleanup. Windows/cross toolchains and documented contract edges unfinished |
| [check](specs/stdlib/modules/check.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [clipboard](specs/stdlib/modules/clipboard.md) | Reserved for window/render worker by current ownership; not modified here |
| [code-visit](specs/stdlib/modules/code-visit.md) | Reserved for compiler worker; not implemented or modified here |
| [codex](specs/stdlib/modules/codex.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [color-interpolation](specs/stdlib/modules/color-interpolation.md) | Reserved for numerics worker; not implemented or modified here |
| [command-line](specs/stdlib/modules/command-line.md) | All reviewed exports implemented for flat scalar/fixed-array options; explicit/default argv, duplicates, notes/help and free arguments tested interpreter/native. Recorded nested/overlay/help edges require review |
| [compiler](specs/stdlib/modules/compiler.md) | Reserved for compiler worker; not implemented or modified here |
| [crc](specs/stdlib/modules/crc.md) | Implemented CRC-64/WE; empty and check vectors pass interpreter/native |
| [curl](specs/stdlib/modules/curl.md) | Reserved for bindings worker; not implemented or modified here |
| [d3d-compiler](specs/stdlib/modules/d3d-compiler.md) | Reserved for bindings worker; not implemented or modified here |
| [d3d11](specs/stdlib/modules/d3d11.md) | Reserved for bindings worker; not implemented or modified here |
| [d3d12](specs/stdlib/modules/d3d12.md) | Reserved for bindings worker; not implemented or modified here |
| [debug-info](specs/stdlib/modules/debug-info.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [debug](specs/stdlib/modules/debug.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [deep-copy](specs/stdlib/modules/deep-copy.md) | Graph/cycle/sharing/string/array/pointer-map/preallocated/callback cases now pass interpreter/native with real alignment metadata; original assertions retained. Statistics/debug globals real. Fixed arrays/Any/unions rejected; ownership/slice/statistic policies require review |
| [default-allocator](specs/stdlib/modules/default-allocator.md) | Documented C fallback allocator_proc/unsafe_reset implemented and interpreter/native tested, with real resize failure preservation and arm64 Linux/Windows checks. Optimized X64/Switch heap API explicitly rejected and remains unimplemented |
| [default-metaprogram](specs/stdlib/modules/default-metaprogram.md) | Owned portable scope; not implemented |
| [dxc-compiler](specs/stdlib/modules/dxc-compiler.md) | Reserved for bindings worker; not implemented or modified here |
| [dxgi](specs/stdlib/modules/dxgi.md) | Reserved for bindings worker; not implemented or modified here |
| [example-plugin](specs/stdlib/modules/example-plugin.md) | Owned portable scope; not implemented |
| [executable-formats](specs/stdlib/modules/executable-formats.md) | Partial: real bounded classic/GNU/COFF/BSD ar parsing, symbol indexes and universal signature detection. Native original C archive and malformed/lifetime tests pass. Missing Arch_File shape blocks universal records; remaining object/debug/text parsers unfinished |
| [file-utilities](specs/stdlib/modules/file-utilities.md) | Partial paths, Unix metadata, recursive listing/copy and replacement implemented; tree copying, self-copy rejection and metadata pass interpreter/native. Visit aliases missing reviewed signatures |
| [file-watcher](specs/stdlib/modules/file-watcher.md) | macOS SDK-native queue/lifecycle plus exact generic facade, coalescing/filtering and captured allocation implemented. Real event/rename/recursive/overflow tests pass interpreter/native; native backend passes ASan/UBSan and tracked allocations. Windows/Linux and detailed timing/lifetime policies unfinished or under review; retained NEW binding ABI defect |
| [file](specs/stdlib/modules/file.md) | Reserved completion for platform-io worker. Existing partial Unix implementation retained; offset/EOF/write/seek cases remain integration regressions. Windows/Android not completed here |
| [flat-pool](specs/stdlib/modules/flat-pool.md) | All reviewed APIs implemented for POSIX hosts, including exact inferred 256MiB module reserve default, public/lazy page-rounded init, global OR local stamp, real commit/reset/release and allocator modes. Public init/default/overwrite tests pass interpreter/native O0/O2; full95-case suite passes. Windows/console absent; Android unvalidated. See portable-flat-pool.md |
| [float16](specs/stdlib/modules/float16.md) | Reserved for numerics worker; not implemented or modified here |
| [freetype](specs/stdlib/modules/freetype.md) | Reserved for bindings worker; not implemented or modified here |
| [gamepad-sdl-input-map](specs/stdlib/modules/gamepad-sdl-input-map.md) | Reserved for window/render worker by current ownership; not modified here |
| [gamepad](specs/stdlib/modules/gamepad.md) | Reserved for window/render worker by current ownership; not modified here |
| [generate-c-header](specs/stdlib/modules/generate-c-header.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [getrect-lefthanded](specs/stdlib/modules/getrect-lefthanded.md) | Reserved for numerics worker; not implemented or modified here |
| [getrect](specs/stdlib/modules/getrect.md) | Reserved for numerics worker; not implemented or modified here |
| [gl](specs/stdlib/modules/gl.md) | Reserved for bindings worker; not implemented or modified here |
| [hash-table](specs/stdlib/modules/hash-table.md) | Real custom/string/scalar-default (NEW Hash) operations and duplicate temporary copies/removal, growth, tombstones, caller-initialized slots and collision counters pass interpreter/native. No storage-order assumption. Walk_Table caller-local expansion contract remains unspecified |
| [hash](specs/stdlib/modules/hash.md) | Partial: specified byte/string/array hashes and Knuth implemented. Scalar seed mix and scalar FNV formula unresolved; digest vectors pass interpreter/native |
| [ico-file](specs/stdlib/modules/ico-file.md) | Owned portable scope; not implemented |
| [icon](specs/stdlib/modules/icon.md) | Owned portable scope; not implemented |
| [imgui](specs/stdlib/modules/imgui.md) | Reserved for bindings worker; not implemented or modified here |
| [input](specs/stdlib/modules/input.md) | Reserved for window/render worker by current ownership; not modified here |
| [introsort](specs/stdlib/modules/introsort.md) | Implemented in-place comparison sorts; interpreter/native checks pass |
| [ios](specs/stdlib/modules/ios.md) | Reserved for bindings worker; not implemented or modified here |
| [iprof](specs/stdlib/modules/iprof.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [jai-lexer](specs/stdlib/modules/jai-lexer.md) | Reserved for compiler worker; not implemented or modified here |
| [keymap](specs/stdlib/modules/keymap.md) | Reserved for window/render worker by current ownership; not modified here |
| [linux-build](specs/stdlib/modules/linux-build.md) | Owned portable scope; not implemented |
| [linux](specs/stdlib/modules/linux.md) | Reserved for bindings worker; not implemented or modified here |
| [lz4](specs/stdlib/modules/lz4.md) | Reserved for bindings worker; not implemented or modified here |
| [machine-x64](specs/stdlib/modules/machine-x64.md) | Owned portable scope; not implemented |
| [macos-bundler](specs/stdlib/modules/macos-bundler.md) | All reviewed procedures implemented for macOS bundle/icon operations and portable XML scalar helpers. Real copied executable/resources/ten-size ICNS round-trip and native plist validation pass both modes. Float output requires NEW formatting foundation; detailed copy/name/Any policies await review |
| [macos](specs/stdlib/modules/macos.md) | Reserved for bindings worker; not implemented or modified here |
| [mail](specs/stdlib/modules/mail.md) | SMTP/MIME transport implemented through new Curl bindings; text/HTML, envelope/header recipients, binary attachments, explicit fixture auth, rejection and required-TLS failure tested against loopback in interpreter/native. Scramble, exact serialization and positive encrypted delivery unresolved/unverified |
| [math](specs/stdlib/modules/math.md) | Reserved for numerics worker; not implemented or modified here |
| [md5](specs/stdlib/modules/md5.md) | Implemented 32-character digest; empty, abc and message-digest vectors pass interpreter/native |
| [memory](specs/stdlib/modules/memory.md) | Generic and optional candidate/unwrap exports implemented with portable backend; overlap, widths and mutable capability state checked interpreter/native |
| [meow-hash](specs/stdlib/modules/meow-hash.md) | Reviewed exports implemented over canonical SIMD registers: calico one-shot/stream/block/finalize/lane/dump APIs and live mutable arrays. 317 independent C vectors include both 128-byte outputs and edited globals; interpreter/native O0/O2 pass. Ancillary scratch/store/dump/state-byte contracts and performance remain explicit review limits |
| [meshoptimizer](specs/stdlib/modules/meshoptimizer.md) | Reserved for bindings worker; not implemented or modified here |
| [metal](specs/stdlib/modules/metal.md) | Reserved for bindings worker; not implemented or modified here |
| [metaprogram-plugins](specs/stdlib/modules/metaprogram-plugins.md) | Owned portable scope; not implemented |
| [minimal-metaprogram](specs/stdlib/modules/minimal-metaprogram.md) | Owned portable scope; not implemented |
| [mojoshader](specs/stdlib/modules/mojoshader.md) | Reserved for bindings worker; not implemented or modified here |
| [nvidia-aftermath](specs/stdlib/modules/nvidia-aftermath.md) | Reserved for bindings worker; not implemented or modified here |
| [nvtt](specs/stdlib/modules/nvtt.md) | Reserved for bindings worker; not implemented or modified here |
| [objective-c](specs/stdlib/modules/objective-c.md) | Reserved for bindings worker; not implemented or modified here |
| [overwriting-allocator](specs/stdlib/modules/overwriting-allocator.md) | Reviewed exports implemented using real tracked allocations, poison and mutex; allocation/failed-resize/growth/free and concurrent tests use the new reviewed scalar Hash dependency. Lifecycle forwarding/destruction edges require review |
| [pcg](specs/stdlib/modules/pcg.md) | Implemented all reviewed exports; five-draw vector and bounds pass interpreter/native |
| [performance-report](specs/stdlib/modules/performance-report.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [pl-mpeg-public-tables](specs/stdlib/modules/pl-mpeg-public-tables.md) | Complete reviewed synthesis and DCT values declared as canonical constants; qualified-array write rejection is a retained compiler gap |
| [pl-mpeg](specs/stdlib/modules/pl-mpeg.md) | Partial: buffers/tables/pixels, video, Layer II audio with checked CRC, MPEG-1 PS demux and Plm lifecycle/callbacks/linear seeks. Full clip and original B/AC/stereo/protected fixtures pass. Inter-predicted B/richer content pending; format transitions rejected. Seek/stream-bound/macro/copy/no-start-code contracts and compiler constants gaps remain. See portable-mpeg.md |
| [pool](specs/stdlib/modules/pool.md) | Default bulk allocator implemented; alignment/accounting/reset and CAPS null-data name/flags pass interpreter/native. USE_UNMAPPING_ALLOCATOR=true explicitly rejected pending native unmapping support |
| [posix](specs/stdlib/modules/posix.md) | Reserved for bindings worker; not implemented or modified here |
| [preload](specs/stdlib/modules/preload.md) | Canonical declarations implemented; bootstrap layout checks pass |
| [print-color](specs/stdlib/modules/print-color.md) | ANSI enums, set/reset, formatting and scoped expansion implemented; stdout/stderr and reset on caller return tested. Native Windows console mode explicitly rejected; ANSI Windows configuration supported by target checking |
| [print-vars](specs/stdlib/modules/print-vars.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [process](specs/stdlib/modules/process.md) | Unix launch/capture/status/timeout/stream APIs implemented; interpreter/native, large dual streams, EPIPE, child pid and concurrent parent-exit cancellation tested. Windows and noted interactive/finite-query contracts incomplete or under review |
| [program-print](specs/stdlib/modules/program-print.md) | Reserved for compiler worker; not implemented or modified here |
| [project-generator](specs/stdlib/modules/project-generator.md) | Owned portable scope; not implemented |
| [protocol-for-memory-visualization](specs/stdlib/modules/protocol-for-memory-visualization.md) | Version-2 packet schemas/tags/constants implemented and layout/canonical-name checks pass interpreter/native. Comparator withheld: equality versus ordering contract absent |
| [radixsort](specs/stdlib/modules/radixsort.md) | Implemented rank buffers, radix passes, reset/resize/reorder and release; numeric/null-input cases pass interpreter/native |
| [random](specs/stdlib/modules/random.md) | All reviewed exports implemented; recurrence, odd seeds and float ranges checked interpreter/native |
| [reflection](specs/stdlib/modules/reflection.md) | All reviewed exports implemented; scalar/range/enum/array checks pass interpreter/native; malformed parser edges remain under review |
| [relative-pointers](specs/stdlib/modules/relative-pointers.md) | Implemented all reviewed exports; null/self/relocated references pass interpreter/native |
| [remap-context](specs/stdlib/modules/remap-context.md) | Both remap procedures plus exact lexical macro implemented; cached validated plans and nested/early-return restoration pass interpreter/native. Duplicate names/stack-trace adjustment need review |
| [rewrite](specs/stdlib/modules/rewrite.md) | Reserved for stdlib-tools; provisional Performance_Report files remain uncommitted for selective handling, not counted as complete |
| [rpmalloc](specs/stdlib/modules/rpmalloc.md) | Reserved for bindings worker; not implemented or modified here |
| [runtime-support-crash-handler](specs/stdlib/modules/runtime-support-crash-handler.md) | POSIX public records and real native signal/TLS backend implemented; explicit/protected faults, distinct worker stacks and cleanup pass interpreter/native. Linux native execution and Windows remain unfinished; deployment/lifetime details documented |
| [runtime-support](specs/stdlib/modules/runtime-support.md) | Partial: context, output, libc allocation, entry wrapper; interpreter smoke passes. Embedding initialization, owned scratch lifetime, synchronized output, explicit-Code once and fault hooks implemented; POSIX crash backtrace startup ON/OFF verified through source-built Compiler workspace; private settled temporary-size protocol adopted with real root/child allocation tests; remaining platform adaptations unfinished |
| [sdl](specs/stdlib/modules/sdl.md) | Reserved for bindings worker; not implemented or modified here |
| [shared-memory-channel](specs/stdlib/modules/shared-memory-channel.md) | Real Unix named-mapping SPSC reserve/commit/poll/done and ownership implemented; wrap/full/corruption and 2,048 packets in all four interpreter/native process pairings. Wire details require review; Windows absent, Linux native unverified |
| [simd](specs/stdlib/modules/simd.md) | All reviewed exports implemented as allocation-free scalar fallback, including corrected oracle 1/0 comparisons/truth masks, unaligned load/gather/scatter, byte offsets, lane-order overwrite, index steps and full interleaved reductions. Interpreter/native tests pass. Documented source defects follow reviewed intended mapping; reversed noncommutative scalar semantics remain unspecified |
| [simp](specs/stdlib/modules/simp.md) | Reserved for window/render worker by current ownership; not modified here |
| [simple-package](specs/stdlib/modules/simple-package.md) | Not implemented; oracle lacks package/TOC magic values and per-entry wire encoding. Questions recorded; no substitute archive format fabricated |
| [sloppy-math](specs/stdlib/modules/sloppy-math.md) | Reserved for numerics worker; not implemented or modified here |
| [soa](specs/stdlib/modules/soa.md) | Generated canonical component arrays, indexed gather/scatter and value/pointer loops implemented; overlay/constant omission, empty extent and writeback on continue/break/return tested. General overlapping-union selection requires review |
| [socket](specs/stdlib/modules/socket.md) | Partial Unix wrappers plus generated native declarations. IPv4 loopback, fd sets and IPv6 formatting pass interpreter/native; Windows wrappers and remaining native/helper gaps recorded separately |
| [sort](specs/stdlib/modules/sort.md) | Implemented both callback forms and built-in comparators; numeric sorting checks pass interpreter/native |
| [sound-player](specs/stdlib/modules/sound-player.md) | Now audio ownership; retained prior partial implementation: nineteen canonical common records/enums, sample arithmetic, bounded magic reads and live topology/accumulator/retired-decoder storage. Real arithmetic/layout/mutable-identity tests; playback, queues, device backends, spatial mixing and compressed decoders unfinished |
| [srgb](specs/stdlib/modules/srgb.md) | Reserved for window/render worker by current ownership; not modified here |
| [stb-image-resize](specs/stdlib/modules/stb-image-resize.md) | Reserved for bindings worker; not implemented or modified here |
| [stb-image-write](specs/stdlib/modules/stb-image-write.md) | Reserved for bindings worker; not implemented or modified here |
| [stb-image](specs/stdlib/modules/stb-image.md) | Reserved for bindings worker; not implemented or modified here |
| [stb-vorbis](specs/stdlib/modules/stb-vorbis.md) | Reserved for bindings worker; not implemented or modified here |
| [string](specs/stdlib/modules/string.md) | Partial: bytes, paths, split/join/replace, boolean/enum/token parsing; scan, wildcard and numeric parsing not implemented |
| [subtitles](specs/stdlib/modules/subtitles.md) | Owned portable scope; not implemented |
| [system](specs/stdlib/modules/system.md) | Partial Unix account/machine/executable/errno/processor APIs implemented and interpreter/native tested; Linux x64/arm64 checks pass. Linux topology falls back to online logical count; CPU counter, Windows and Android CLI validation incomplete |
| [telemetry3](specs/stdlib/modules/telemetry3.md) | Reserved for bindings worker; not implemented or modified here |
| [text-file-handler](specs/stdlib/modules/text-file-handler.md) | Reviewed exports implemented for byte lines, file/borrowed-memory input, comments/version parsing, diagnostics and array/table helpers; interpreter/native tests pass. Helper ownership and version lexical edges require review |
| [thread](specs/stdlib/modules/thread.md) | Partial POSIX release synchronization/lifecycle/work groups implemented and interpreter/native tested. Windows/iOS/console, DEBUG/race detector and automatic workspace metadata unfinished |
| [treemap](specs/stdlib/modules/treemap.md) | Stable bucket nodes, hierarchy weights/sort, indexed squarified layout, borders and caching implemented; hierarchy/non-overlap/areas/growth checks use new delegated Math. Default border/range/cache/coordinate policies need review |
| [unicode](specs/stdlib/modules/unicode.md) | Implemented immutable tables, decoding/encoding and iterator; consumed-tail, strict errors and scalar round trips pass interpreter/native; malformed edges need further coverage |
| [unmapping-allocator](specs/stdlib/modules/unmapping-allocator.md) | Unix guarded mappings, read-only retained frees, resize/failure preservation and exact metadata shape implemented; interpreter/native guards and stale writes checked using actual child signal termination. Windows/console and lifecycle policy incomplete or under review |
| [vulkan](specs/stdlib/modules/vulkan.md) | Reserved for bindings worker; not implemented or modified here |
| [wav-file](specs/stdlib/modules/wav-file.md) | Reviewed exports implemented for PCM/IMA metadata and borrowed data views; bounded/truncated chunk tests pass interpreter/native, Linux/Windows checks and lint. Duplicate chunks require review |
| [window-creation](specs/stdlib/modules/window-creation.md) | Reserved for window/render worker by current ownership; not modified here |
| [window-type](specs/stdlib/modules/window-type.md) | Reserved for window/render worker by current ownership; not modified here |
| [windows-registry](specs/stdlib/modules/windows-registry.md) | Owned portable scope; not implemented |
| [windows-resources](specs/stdlib/modules/windows-resources.md) | Owned portable scope; not implemented |
| [windows-utf8](specs/stdlib/modules/windows-utf8.md) | Owned portable scope; not implemented |
| [windows](specs/stdlib/modules/windows.md) | Reserved for bindings worker; not implemented or modified here |
| [x11](specs/stdlib/modules/x11.md) | Reserved for bindings worker; not implemented or modified here |
| [xar](specs/stdlib/modules/xar.md) | Reviewed exports implemented: stable exponential chunks, captured allocator, removal, coordinates/iterators, pointer/value loops and in-place sorting. Failure/iterator boundary policy noted; reverse iteration and capacity limits checked |
| [xxhash](specs/stdlib/modules/xxhash.md) | Reserved for bindings worker; not implemented or modified here |
| [zip-file-directory](specs/stdlib/modules/zip-file-directory.md) | Classic central directory parsing/ownership implemented; bounds, ZIP64/multidisk rejection and specified signature/descriptor assertions tested. position_in_file/extensions require review; current File dependency Unix-only |
