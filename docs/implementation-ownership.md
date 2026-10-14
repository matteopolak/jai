# Implementation ownership

- compiler: Rust compiler behavior/bootstrap and public Compiler, Jai_Lexer, Code_Visit, Program_Print; internal/compiler-api, internal/jai-lexer, internal/code-visit, internal/program-print.
- stdlib: all remaining portable/high-level modules, canonical stdlib/prelude/module.jai and Runtime_Support, except below.
- bindings: Android, Android/AAudio, Android/EGL, Curl, d3d11, d3d12, d3d_compiler, dxc_compiler, dxgi, freetype, GL, ImGui, iOS, Linux, lz4, macOS, meshoptimizer, Metal, MojoShader, nvidia_aftermath, nvtt, Objective_C, POSIX, rpmalloc, SDL, stb_image, stb_image_resize, stb_image_write, stb_vorbis, telemetry3, Vulkan, Windows, X11, xxHash; internal/bindings. Xar remains portable.
- numerics: Math, Sloppy_Math, Float16, Color_Interpolation, GetRect, GetRect_LeftHanded; internal/numerics.
- lsp: partial-edit resilience and for-keyword navigation; LSP source/tests/docs and minimal IDE-only core parser/sema changes as needed. Keep these separate for compiler release0.17.1, after current library/history/release work0.17.0. Core overlap will be integrated by coordinator; avoid bootstrap changes already owned by compiler.

Never modify another checkout. New independent code is permitted integration input. Preserve Extensions. Single bootstrap prelude/module.jai, public Preload import aliases same entry/storage/types; no legacy module.jai or second root prelude. Private helpers do not become facade exports.

Platform-io worker now owns File publicfacade/internalfile backend completion (especially Windows), and dedicated Windows backends for Process/System/Thread/Runtime_Support as time permits. Primary stdlib worker excludes File implementation and Windows backend work, continues remaining portable modules. Foundations retains File_Utilities, Basic/String/Hash. Separateworktrees only; coordinatorresolvescommonOStarget glue. Nopeermodification.
