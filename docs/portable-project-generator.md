# Project generator implementation plan and evidence

Goal: complete the reviewed singleton, file ownership and compiler-driven Visual
Studio scaffold workflow without a CLI bypass or private convenience exports.
Architecture: keep the exact anonymous public record in its facade; private
collector/workspace functions, path normalization and deterministic XML/solution
emission live under internal/build. Use real Compiler/File/System/Sort APIs.

- [x] Reviewed spec and missing-module red public test.
- [x] Implement mutable record and ownership/reset/file-message behavior.
- [x] Implement real workspace interception/build and completion defaults.
- [x] Emit solution/project/filters/user files with escaped data, deterministic
  identifiers, normalized sorted paths and byte-identical file retention.
- [x] Verify direct public collection in interpreter/native O0/O2; real compiler
  target generation and artifact contents, defaults/persistence, deduplication,
  escaping and unchanged file mtimes. Owned formatting/--check pass.
- [ ] Full strict lint: blocked by general executable-path SDK call in SandboxHost.
- [x] Update inventory, deviations, README and progress; commit cohesive behavior.

Windows Visual Studio execution is a later native platform gate. Mac tests must
write real files and run real compiler targets, not count declarations as behavior.

Executed `python3 -B tools/check_portable_project_generator.py`: direct collection
interpreter/native O0/O2, actual target O0/O2 workspaces and all four emitted files
pass. Tests parse XML, inspect sorted/relative paths and drive uppercase, preserve
parent segments outside filters, verify command/debugger XML escaping, persistent
defaults and configuration, ignored output_directory, reset after collection,
and byte-identical files whose old mtime is deliberately retained across rebuild.
An actual unwritable/missing-parent output path asserts instead of claiming success.
Generated driver/fixture and all owned source pass repository formatting/--check.

The full runner is still nonzero at strict lint: required `build_cmd := #run
get_path_of_running_executable()` calls the real Mac SDK, which jailint's host
does not expose. Minimal general pending/system-executable-path-run.jai reproduces
the same `_NSGetExecutablePath` denial. No hardcoded executable path, argv0
substitute, module-specific exception or lint suppression. A generated unused
Compiler import was corrected by actually setting parent optimization for the
target O0/O2 tests; all reported checks now reach only the host dependency.
Evidence: target/project-generator-workflow.log and
project-system-executable-lint-gap.log. Native collection runs use the real
default; schema/VS execution is not inferred from XML parse success.

Implementation uses deterministic SHA256-derived GUID-shaped identifiers to keep
content stable, proper XML escaping, C++ Makefile project properties and matching
filter items. SDK format inputs are Microsoft's [Makefile project documentation](https://learn.microsoft.com/en-us/cpp/build/reference/creating-a-makefile-project?view=msvc-170)
and [filter-file schema](https://learn.microsoft.com/en-us/cpp/build/reference/vcxproj-filters-files?view=msvc-170).
The reviewed Jai spec remains the sole public API/behavior oracle. Templates and
help/prose are independently authored. Config defaults persist for module lifetime;
reset frees only retained file strings/array, as reviewed. The conventional natvis
path is emitted, but this checkout has no editor_support/msvc/jai.natvis resource;
resource availability and working Visual Studio visualization remain pending.
