# Retained source providers

## What it is

`jai-source::SourceProvider` is the selected source-input contract. `jai-native-source` implements native observations and overlays, while graph loading retains their genuine decoded-text snapshots.

## How it works

`NativeSourceSnapshot` caches actual canonicalization, read and existence observations. Its decoded-text cache accepts only a successful retained read whose decoded bytes match the requested text. An overlay keeps the selected base provider; `insert_snapshot` preserves an actual owned source input, while ordinary byte replacement clears that authority. The loader inserts the provider's snapshot into its real `SourceMap` before lexer/parser work.

## How to change it

Keep decoded observations in the same ledger that owns the actual read. Equal paths or text from another provider are not retained ownership. Forward unoverridden paths to the selected base, and preserve compatibility imports through `jai-modules` while portable callers use `jai-source` directly. The recovered native adapter is isolated from the graph contract; avoid moving filesystem operations into `jai-source`.

## Configuration

Native filesystem adapters are disabled on `wasm32`. A new `NativeSourceSnapshot` observes a new source round; reusing the same real snapshot deliberately preserves its first read. Source journals must choose explicitly retained snapshots for generated inputs.

## Dependencies

This packet depends on the source-allocation foundation. `jai-native-source` depends on `jai-source` and the real `jai-lexer::decode_source` for matching retained UTF-8/UTF-16 observations. Workspace registration is included as a guarded source patch for coordinator review; no Cargo, host read or native command was run in this recovery lane. The authored tests remain unexecuted.
