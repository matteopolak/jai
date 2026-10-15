# Data/resource public API evidence

All five facades now contain their reviewed public surface. Every procedure has
real behavior. Source presence does not establish native platform correctness.

| Module / API | Implementation and evidence |
| --- | --- |
| Simple_Package records/constants | Exact canonical shapes; native sizes/reflection |
| init/add/deinit | Copied names, borrowed payloads, lifecycle; interpreter/native O0/O2 |
| write | Real filesystem, reviewed wire, stable sorting/order, duplicate preservation |
| init_from_memory/init_from_file | Checked borrowed/owned buffers; interpreter/native O0/O2 and WASI |
| load_table_of_contents/load_table_of_contents_only | Separate TOC/payload allocations, initialized header, tail-only I/O; same runtime checks |
| Ico_File size helpers | Exact unusual reviewed formulas |
| create_ico_file | Five frames 256/128/48/32/16, helper-sized padded DIB, actual stb resizing; interpreter/native O0/O2, LLVM RC |
| create_ico_file_from_bitmap_filename | Real File/stb, bottom-up BGR conversion; Unicode/gradient/error tests |
| Subtitles all exports | [Per-API evidence](portable-subtitles.md); interpreter/native O0/O2 and WASI; writable counters and reviewed quirks |
| Windows_Resources records | Exact canonical Windows scalar identities and defaults; x64/ARM64 checks |
| Windows_Resources resource APIs | Real validated/aligned SDK transactions, exact IDs/language/destructive flag; native Windows execution pending |
| generate_manifest | Actual allocated XML, all eight option combinations; native portable engine and independent XML consumer |
| find_windows_kit_root overloads / find_visual_studio_in_a_ridiculous_garbage_way | Actual registry, numeric directory selection and Setup COM discovery; Windows target/source checks, native execution pending |
| disable_runtime_console | Actual workspace argument update, #run regression |
| Icon all six exports | Allocated canonical plugin callbacks, borrowed last -icon option, post-write dispatch, lifecycle/help/errors; interpreter/native and #run phase tests; positive Windows attachment pending |

[Windows details](portable-windows-resources.md), [test commands](portable-data-testing.md)
and [remaining narrow questions](specs/questions/portable-data.md). Native WASI
ICO/resize linkage is outside established support and fails honestly in the
explicit unsupported-target probe. No skipped Windows run counts as a pass.
