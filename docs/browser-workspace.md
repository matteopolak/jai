# Browser source workspace

## What it is

The Jai playground edits a virtual collection of source files and runs its `main.jai` entry in the WebAssembly interpreter. Source files remain in browser memory for the current page session.

## How it works

`workspace.mjs` owns parsed relative file identities and immutable source records. POSIX path normalization is independent of the host OS: aliases resolve to one name, paths cannot escape the workspace, and names must fit the bridge's UTF-8 boundary. A private factory token prevents constructing an unchecked `SourcePath`. The entry file is always present and cannot be overwritten by adding an alias.

`editor.mjs` saves edits when text changes and switches files without losing their contents. A run takes an immutable snapshot before sending source, additional files, arguments and fuel to the existing worker. Later edits affect the next run. Cancel terminates the worker; the next run creates a fresh engine.

For example, put `answer :: () -> int { return 42; }` in `helper.jai` and use this entry:

```jai
#load "helper.jai";

main :: () -> int {
    return answer();
}
```

Source names and contents cross the existing pointer-free WebAssembly channels. Rust still enforces its aggregate source quota and closed virtual filesystem. This editor does not grant file I/O, native library loading or process access to a Jai program.

## How to change it

Change path and snapshot behavior in `workspace.mjs`, user interaction in `editor.mjs`, and responsive layout in `style.css`. Keep file labels and diagnostics as DOM text rather than HTML. Preserve entry identity and take one snapshot per run; do not read the live editor after a job has started.

`tools/test_browser_workspace.mjs` covers source identity, collision rejection and snapshot isolation with Node's built-in test runner. Check actual editing, multi-file execution, errors and cancellation in the browser separately. The stage script copies every runner asset, so new modules need no special copy rule.

## Configuration

The entry is `main.jai`. Run options retain the argument array and unsigned 32-bit step limit from the existing bridge. Tab inserts four spaces; Ctrl/Command + Enter runs the current workspace. File names are limited to 4,096 UTF-8 bytes, and the Rust bundle limits aggregate source size to 4 MiB. Refreshing the page starts a new workspace; persistent storage is not enabled.

Stage the actual module with `python3 tools/build_scripting_wasm.py`, serve its output directory, and open the page as described in [Scripting runtime](scripting-runtime.md). Run model tests with `node --test tools/test_browser_workspace.mjs`.

## Dependencies

The workspace uses standard JavaScript modules, DOM APIs, workers and text encoding. Execution depends on the actual Rust-generated `jai_wasm.wasm`, `engine.mjs`, `worker.mjs`, and the `jai-runtime` closed source provider. No browser package manager or additional third-party dependency is required.
