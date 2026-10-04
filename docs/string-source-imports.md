# String source imports

## What it is

`#import,string` parses its literal text as a separate module entry source. This includes here-strings; their delimiter and importing span remain in the original syntax tree.

## How it works

Quoted module source, path and argument strings use the shared literal escape decoder and require UTF-8 text. Here-string source retains the same UTF-8 requirement; invalid byte escapes report the original literal span.

The loader creates an embedded `SourceRecord` at the actual import site. Its diagnostic label is separate from its relative-resolution anchor. Embedded entries bypass provider reads and canonicalization; their imports and loads use the importing source's anchor through the same configured provider.

An embedded `SourceId` distinguishes the module request and file cache from physical files, including physical files with the same diagnostic label. Parameter arguments, selected branches, pending discovery, exports and same-instance backedges use the existing module machinery. Repeated discovery of the same source site reuses the embedded text and syntax. Compiler source-origin receipts encode the literal text, resolution anchor and original importing-site chain, rather than granting physical-file authority to a diagnostic label.

## How to change it

Keep `loader/string_imports.rs` limited to retaining and parsing source. Change module identity in `params.rs` and loader entry handling together. Do not insert embedded labels into the provider file cache. Extend source-origin encoding when adding another source kind; every parent lookup and copied byte is admitted through its existing work budget.

The module tests cover distinct literal sites, parameterized instances, relative loads and physical-label collisions. The existing sema here-string fixture checks real execution returning `42`.

## Configuration

`GraphOptions.import_dirs` controls search imports inside literal text. File and directory imports and `#load` retain the same provider boundary as the importing source. This feature adds no host filesystem or native-library permission.

## Dependencies

This uses `jai-source` embedded source records, `jai-syntax` file parsing and the `jai-modules` parameter, discovery, import and compiler-origin machinery. It adds no registry dependencies.
