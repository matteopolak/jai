# Foreign library declarations

## What it is

Foreign libraries are typed source declarations naming a system dependency or a local native path. Foreign procedure prototypes refer to their declaration identity through ordinary module lookup.

## How it works

`Crt :: #system_library "libc";` and `Crt :: #library,system "libc";` declare equivalent system dependencies. `Own :: #library "native/own";` declares a local dependency. Parsing preserves the target, kind, options, and source span without opening native files.

Older source can spell `#library` as `#foreign_library`. The lexer maps both spellings to the same directive tag while retaining the original token span. This alias uses the same modifiers, validation, declaration identity, and native linking policy; it does not grant access to local native bytes.

Semantic resolution looks up `#foreign Crt` or `#foreign Bindings.Crt` in the defining file's scope. Unknown names, private members, and declarations of another kind fail before code generation. Imported and reexported libraries retain their original declaration identity. Local paths resolve relative to the declaring source file, rather than the importing source or process working directory.

The checked IR retains resolved library metadata independently of executable expressions. LLVM emits foreign symbol declarations without searching for libraries. The host linker uses the actual system target: the source name `Crt` never becomes `-lCrt`. `libc` becomes `-lc`; on Linux a versioned basename such as `libstdc++.so.6` uses `-l:libstdc++.so.6`.

Source foreign symbols cannot declare or adopt the private `jai.pool.*` runtime helper namespace, regardless of prototype emission order. Program exports already reject the compiler's `jai.*` namespace. Internal Pool helpers and their installed libc dependencies use compiler-owned declarations.

Native reachability selects dependencies used by emitted procedure bodies and static callback values. Unused foreign prototypes keep their checked metadata without requiring a native dependency. `link_always` explicitly overrides this demand rule. Ordinary reachable local declarations fail before accessing their native bytes. The narrow [reviewed native linking](reviewed-native-linking.md) path can supply a process-local capability for a freshly rebuilt and ABI-checked dependency associated with the exact library identity.

System names must be plain basenames. Paths, NUL, whitespace, and linker-option prefixes are rejected. The CLI removes environment overrides for native search paths and SDK roots before invoking its independently installed linker driver. A source path or persisted receipt alone cannot grant local native linking; object emission and static metadata inspection remain available without accessing those bytes. Independently written C fixture tests may compile and link their own newly generated objects outside this source declaration path. Supplied reference native files must never be linked or loaded.

## How to change it

Extend syntax in `jai-syntax/src/libraries.rs`, source lookup in `jai-sema/src/modules/foreign_libraries.rs`, IR metadata/validation in `jai-ir/src/foreign_libraries.rs`, and target-specific linker spelling in `jai-cli/src/foreign_libraries.rs`. Directive spelling aliases belong in `jai-lexer/src/tokens.rs`; the first spelling is canonical and aliases share its typed tag. Keep library identity separate from the target name. Preserve namespace privacy and defining-source paths when extending aliases or generated sources.

Local linking capabilities are implemented separately in `jai-cli/src/native_dependencies.rs`: preparation checks the exact library identity, reachable foreign signatures and host ABI, rebuilds reviewed source, and retains a checked fresh snapshot until linking completes. Extend that authority boundary for new reviewed recipes. Merely canonicalizing a path does not establish that its native bytes are independently generated or trusted. Never substitute a supplied reference library for a missing system dependency.

## Configuration

`link_always` requests linking even when no prototype references the declaration. `no_dll` requests static-only linking; `no_static_library` requests dynamic-only linking. Duplicate modifiers and disabling both kinds fail during parsing. Explicit system linkage selection is currently supported through Linux linker mode switches and fails explicitly on other hosts. A system filename whose extension contradicts its requested linkage kind fails during metadata validation.

```jai
Crt :: #system_library "libc";
absolute :: (value: s32) -> s32 #foreign Crt "abs";

Cpp :: #system_library,link_always "libstdc++.so.6";
Own :: #library,no_dll "native/own";
```

`JAI_RS_CLANG` selects an independently installed linker driver subject to the CLI reference-path exclusion. Native linking is host-only; cross-target `emit-object` remains available.

## Dependencies

The syntax parser, scoped module graph and source map, checked IR publication boundary, LLVM object emitter, and independently installed Clang/system libraries. Static supplied-source inventory establishes syntax examples; executed self-written host fixtures establish native behavior.
