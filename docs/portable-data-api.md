# Data/resource public API evidence

Reviewed specs establish expectations; checks use this worktree's NEW compiler.
This ledger records partial completion, not full integration.

| Module / API | Implementation and evidence |
| --- | --- |
| Simple_Package records/constants | Exact canonical shapes; native size/reflection |
| init/add/deinit | Copied names, borrowed payloads, real lifecycle; interpreter/native O0/O2 |
| write | Real filesystem, reviewed wire, stable sorting/order; interpreter/native O0/O2 |
| init_from_memory/init_from_file | Checked borrowed/owned buffers; interpreter/native O0/O2 |
| load_table_of_contents/load_table_of_contents_only | Direct parsing and real tail reads; interpreter/native O0/O2 |
| Ico_File size helpers | Exact unusual reviewed formulas; interpreter/native vector |
| create_ico_file | Provisional single-frame encoder; LLVM RC accepts RGB/RGBA; sips decodes 16x16 |
| create_ico_file_from_bitmap_filename | Real File/stb backend; interpreter/native O0/O2 Unicode BMP and errors; frame policy unresolved |
| Subtitles all exports | Implemented supported contracts; [per-API evidence](portable-subtitles.md); interpreter/native O0/O2 and compiled WASI; narrow questions remain |
| Windows_Resources | Three exact records; real private wire/transaction backend; [per-API pending list and evidence](portable-windows-resources.md); public policies/native effects unresolved |
| Icon all exports | Pending; plugin host protocol unresolved |

ICO fixed-frame layout/resizing remains incomplete. SDK file consumption does not
establish native Win32 mutation. Load_Package has no reviewed deinit export;
caller-managed buffers/metadata follow the spec.
