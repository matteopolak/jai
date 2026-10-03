# Browser source workspace

## What it is

The Jai playground edits a virtual collection of source files and runs its `main.jai` entry in the WebAssembly interpreter. A hierarchical explorer and professional source editor retain browser-session edits independently from an active execution snapshot.

## How it works

`workspace.mjs` owns parsed relative file identities and immutable source records. Both the JavaScript workspace and Rust bundle use explicit POSIX path normalization independent of the host OS. Rust delegates canonical bundle identities to `jai-source::normalize_virtual_path`; host `Path::is_absolute()` is unsuitable on `wasm32-unknown-unknown`. This keeps native and Wasm identities consistent: aliases resolve to one name, paths reject backslashes, colons and escapes from the workspace, and names must fit the bridge's UTF-8 boundary. A private factory token prevents constructing an unchecked `SourcePath`. The entry is always present and cannot be overwritten by adding an alias. Folder nodes derive from actual file paths; they do not bypass path validation.

Each changed source receives a strictly increasing version for language service synchronization. Adding or removing files sends actual open/close notifications. The editor retains each file's selection and undo history while switching. A run takes one immutable snapshot before sending source, additional files, arguments and fuel to its execution worker. Later edits affect the next run. Cancel terminates that worker; the next run creates a fresh interpreter, while the separate language worker remains available.

For example, put `answer :: () -> int { return 42; }` in `lib/helper.jai` and use `#load "lib/helper.jai";` from the entry. The explorer shows a `lib` folder with the actual helper source. Source names and contents cross pointer-free WebAssembly channels. Rust still enforces its aggregate source quota and closed virtual filesystem.

## How to change it

Change path, version, tree and snapshot behavior in `workspace.mjs`, interactions in `editor.mjs`, and responsive layout in `style.css`. Keep labels, hover and diagnostics as DOM text. Preserve entry identity and one snapshot per run; do not read live editor text after a job starts. The [browser editor](browser-editor.md) describes CodeMirror, lexical states and shared LSP integration.

`tools/test_browser_workspace.mjs` tests source identity, alias collisions, nested tree identities, versions and snapshot isolation. `tools/test_jai_editor.mjs` tests the lexer, editor history and language transport. Verify actual multi-file execution and cancellation separately with the staged real Wasm module.

## Configuration

The entry is `main.jai`. Run options retain the argument array and unsigned 32-bit step limit. Tab indents four spaces and Ctrl/Command+Enter runs. Names are limited to 4,096 UTF-8 bytes; the Rust source bundle limits aggregate source to 4 MiB. Refreshing starts a new workspace; persistent storage is not enabled.

Stage the real compiler using `python3 tools/build_scripting_wasm.py` and serve its output directory. The release packaging workflow additionally bundles the pinned editor and writes the immutable release revision. Every runtime asset and worker uses base-relative URLs so the same bundle can run at a nested path or in the portfolio iframe.

## Dependencies

The model uses standard JavaScript modules and text encoding. Editor behavior depends on the locally bundled CodeMirror packages; language services depend on the same bounded Rust core as native LSP. Execution uses the actual Rust-generated `jai_wasm.wasm`, `engine.mjs`, `worker.mjs`, and `jai-runtime` closed source provider. No browser CDN or third-party runtime fetch is required.
