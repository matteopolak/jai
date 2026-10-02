# Debug suppression

## What it is

`#no_debug` marks a source procedure or expanded macro body to suppress emitted debug information. The policy is retained separately from its callable type, so it does not change argument types, context mode, or calling convention.

## How it works

The parser records `DebugPolicy::Suppress` on the source procedure. A resolver applies that policy while capturing the procedure or expanded body. Suppression remains active through nested expansion and cleanup blocks. Macro arguments are evaluated in the caller before entering the marked body, so their initializer statements keep caller locations.

Source provenance remains available for diagnostics, code quotation origins, and `#caller_location`. Quotation captures retain their defining policy even when insertion requests the current lexical scope; insertion combines it with the active caller policy and restores that policy afterward. The IR debug sidecar records procedure policy independently of those source identities. Native debug emission consults the policy when creating procedure scopes and selecting the compilation unit's source.

## How to change it

The shared policy lives in `jai-types`, source suffix parsing in `jai-syntax`, and capture in `jai-sema`. Keep policy inheritance sticky within marked bodies and restore it on both success and failure after expansion. Changes to macro capture must preserve caller argument statements while excluding the macro's formal locals and body locations. Backend changes belong in `jai-codegen`'s debug adapters.

## Configuration

Apply `#no_debug` to a procedure with a source body: `helper :: () #no_debug {}`. Both `#expand #no_debug` and `#no_debug #expand` are accepted. Duplicate markers and markers on callback types or bodyless prototypes are rejected. Global debug output settings still control whether debug information is emitted for other procedures.

## Dependencies

This feature uses `jai-types::DebugPolicy`, syntax procedure metadata, semantic capture, the `jai-ir` debug sidecar, and LLVM debug emission in `jai-codegen`. It does not depend on or execute the original compiler.
